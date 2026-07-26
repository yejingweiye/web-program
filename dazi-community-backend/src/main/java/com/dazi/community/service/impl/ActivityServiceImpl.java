package com.dazi.community.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.common.exception.BusinessException;
import com.dazi.community.constant.BizConstant;
import com.dazi.community.entity.dto.CreateActivityRequest;
import com.dazi.community.entity.po.*;
import com.dazi.community.mapper.*;
import com.dazi.community.service.ActivityService;
import com.dazi.community.service.CommunityService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Resource
    private ActivityInfoMapper activityInfoMapper;
    @Resource
    private ActivityOrderMapper activityOrderMapper;
    @Resource
    private CommunityService communityService;

    @Override
    @Transactional
    public ActivityInfo createActivity(Long userId, CreateActivityRequest request) {
        if (!communityService.isMember(userId, request.getCommunityId())) {
            throw new BusinessException(30002, "无社区准入权限");
        }

        ActivityInfo activity = new ActivityInfo();
        activity.setCommunityId(request.getCommunityId());
        activity.setUserId(userId);
        activity.setTitle(request.getTitle());
        activity.setContent(request.getContent());
        activity.setAddress(request.getAddress());
        if (request.getStartTime() != null && !request.getStartTime().isEmpty()) {
            activity.setStartTime(LocalDateTime.parse(request.getStartTime(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        }
        if (request.getEndTime() != null && !request.getEndTime().isEmpty()) {
            activity.setEndTime(LocalDateTime.parse(request.getEndTime(), DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        }
        activity.setMaxPeople(request.getMaxPeople() != null ? request.getMaxPeople() : 0);
        activity.setFee(request.getFee() != null ? request.getFee() : BigDecimal.ZERO);
        activity.setStatus(0);
        activity.setAuditStatus(0); // pending audit
        activity.setServiceRate(BigDecimal.valueOf(BizConstant.SERVICE_RATE_MIN));
        activityInfoMapper.insert(activity);
        return activity;
    }

    @Override
    public Page<ActivityInfo> getActivityPage(Long communityId, int page, int size) {
        LambdaQueryWrapper<ActivityInfo> wrapper = new LambdaQueryWrapper<ActivityInfo>()
                .eq(ActivityInfo::getStatus, 0)
                .eq(ActivityInfo::getAuditStatus, 1)
                .orderByDesc(ActivityInfo::getCreateTime);
        if (communityId != null) {
            wrapper.eq(ActivityInfo::getCommunityId, communityId);
        }
        return activityInfoMapper.selectPage(new Page<>(page, size), wrapper);
    }

    @Override
    public ActivityInfo getActivityDetail(Long id) {
        ActivityInfo activity = activityInfoMapper.selectById(id);
        if (activity == null) {
            throw new BusinessException("活动不存在");
        }
        return activity;
    }

    @Override
    @Transactional
    public ActivityOrder signUpActivity(Long userId, Long activityId) {
        ActivityInfo activity = activityInfoMapper.selectById(activityId);
        if (activity == null || activity.getStatus() != 0) {
            throw new BusinessException("活动不存在或已结束");
        }
        if (activity.getAuditStatus() != 1) {
            throw new BusinessException("活动尚未审核通过");
        }

        // Check duplicate
        Long count = activityOrderMapper.selectCount(
                new LambdaQueryWrapper<ActivityOrder>()
                        .eq(ActivityOrder::getActivityId, activityId)
                        .eq(ActivityOrder::getUserId, userId)
                        .in(ActivityOrder::getPayStatus, 0, 1));
        if (count > 0) {
            throw new BusinessException("已报名该活动");
        }

        // Check max people
        long signedCount = activityOrderMapper.selectCount(
                new LambdaQueryWrapper<ActivityOrder>()
                        .eq(ActivityOrder::getActivityId, activityId)
                        .eq(ActivityOrder::getPayStatus, 1));
        if (activity.getMaxPeople() > 0 && signedCount >= activity.getMaxPeople()) {
            throw new BusinessException("活动名额已满");
        }

        BigDecimal fee = activity.getFee() != null ? activity.getFee() : BigDecimal.ZERO;
        BigDecimal serviceFee = fee.multiply(activity.getServiceRate())
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

        ActivityOrder order = new ActivityOrder();
        order.setActivityId(activityId);
        order.setUserId(userId);
        order.setPayPrice(fee);
        order.setServiceFee(serviceFee);
        order.setPayStatus(1); // auto paid for demo
        order.setTransactionId(UUID.randomUUID().toString().replace("-", "").substring(0, 20));
        activityOrderMapper.insert(order);
        return order;
    }

    @Override
    public Page<ActivityOrder> getUserActivityOrders(Long userId, int page, int size) {
        return activityOrderMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<ActivityOrder>()
                        .eq(ActivityOrder::getUserId, userId)
                        .orderByDesc(ActivityOrder::getCreateTime));
    }

    @Override
    @Transactional
    public void auditActivity(Long managerId, Long activityId, boolean approved) {
        ActivityInfo activity = activityInfoMapper.selectById(activityId);
        if (activity == null || activity.getAuditStatus() != 0) {
            throw new BusinessException("活动不存在或已审核");
        }
        if (!communityService.isManager(managerId, activity.getCommunityId())) {
            throw new BusinessException(10002, "权限不足");
        }
        activity.setAuditStatus(approved ? 1 : 2);
        activityInfoMapper.updateById(activity);
    }
}
