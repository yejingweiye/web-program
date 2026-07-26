package com.dazi.community.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.dazi.community.common.exception.BusinessException;
import com.dazi.community.constant.BizConstant;
import com.dazi.community.entity.dto.CreateCircleRequest;
import com.dazi.community.entity.po.*;
import com.dazi.community.mapper.*;
import com.dazi.community.service.CircleService;
import com.dazi.community.service.CommunityService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class CircleServiceImpl implements CircleService {

    @Resource
    private CircleInfoMapper circleInfoMapper;
    @Resource
    private CircleMemberMapper circleMemberMapper;
    @Resource
    private CircleInviteMapper circleInviteMapper;
    @Resource
    private CommunityService communityService;

    @Override
    public List<CircleInfo> getCirclesByCommunity(Long communityId) {
        return circleInfoMapper.selectList(
                new LambdaQueryWrapper<CircleInfo>()
                        .eq(CircleInfo::getCommunityId, communityId));
    }

    @Override
    @Transactional
    public CircleInfo createCircle(Long userId, CreateCircleRequest request) {
        // Must be community member
        if (!communityService.isMember(userId, request.getCommunityId())) {
            throw new BusinessException(30002, "无社区准入权限");
        }

        CircleInfo circle = new CircleInfo();
        circle.setCommunityId(request.getCommunityId());
        circle.setName(request.getName());
        circle.setType(request.getType() != null ? request.getType() : 0);
        circle.setMaxNum(BizConstant.CIRCLE_MAX_FREE);
        circle.setCreateUserId(userId);
        circleInfoMapper.insert(circle);

        // Creator auto-joins
        CircleMember member = new CircleMember();
        member.setCircleId(circle.getId());
        member.setUserId(userId);
        member.setJoinTime(LocalDateTime.now());
        circleMemberMapper.insert(member);

        return circle;
    }

    @Override
    @Transactional
    public void joinCircle(Long userId, Long circleId, String inviteCode) {
        CircleInfo circle = circleInfoMapper.selectById(circleId);
        if (circle == null) {
            throw new BusinessException("圈子不存在");
        }

        // Check if already member
        Long count = circleMemberMapper.selectCount(
                new LambdaQueryWrapper<CircleMember>()
                        .eq(CircleMember::getCircleId, circleId)
                        .eq(CircleMember::getUserId, userId));
        if (count > 0) {
            throw new BusinessException("已经是圈子成员");
        }

        if (circle.getType() == 1) {
            // Private circle requires invite
            if (inviteCode == null) {
                throw new BusinessException("私密圈子需要邀请码");
            }
            CircleInvite invite = circleInviteMapper.selectOne(
                    new LambdaQueryWrapper<CircleInvite>()
                            .eq(CircleInvite::getInviteCode, inviteCode)
                            .eq(CircleInvite::getCircleId, circleId));
            if (invite == null) {
                throw new BusinessException("邀请码无效");
            }
            if (invite.getExpireTime() != null && invite.getExpireTime().isBefore(LocalDateTime.now())) {
                throw new BusinessException("邀请码已过期");
            }
        }

        // Check member count
        long memberCount = circleMemberMapper.selectCount(
                new LambdaQueryWrapper<CircleMember>().eq(CircleMember::getCircleId, circleId));
        if (memberCount >= circle.getMaxNum()) {
            throw new BusinessException("圈子人数已满");
        }

        CircleMember member = new CircleMember();
        member.setCircleId(circleId);
        member.setUserId(userId);
        member.setJoinTime(LocalDateTime.now());
        circleMemberMapper.insert(member);
    }

    @Override
    @Transactional
    public void leaveCircle(Long userId, Long circleId) {
        CircleInfo circle = circleInfoMapper.selectById(circleId);
        if (circle == null) {
            throw new BusinessException("圈子不存在");
        }
        if (circle.getCreateUserId().equals(userId)) {
            throw new BusinessException("圈主不能退出，请转让或解散圈子");
        }
        circleMemberMapper.delete(new LambdaQueryWrapper<CircleMember>()
                .eq(CircleMember::getCircleId, circleId)
                .eq(CircleMember::getUserId, userId));
    }

    @Override
    @Transactional
    public void kickMember(Long userId, Long circleId, Long memberId) {
        CircleInfo circle = circleInfoMapper.selectById(circleId);
        if (circle == null || !circle.getCreateUserId().equals(userId)) {
            throw new BusinessException(10002, "仅圈主可踢人");
        }
        if (memberId.equals(userId)) {
            throw new BusinessException("不能踢出自己");
        }
        circleMemberMapper.delete(new LambdaQueryWrapper<CircleMember>()
                .eq(CircleMember::getCircleId, circleId)
                .eq(CircleMember::getUserId, memberId));
    }

    @Override
    @Transactional
    public void dismissCircle(Long userId, Long circleId) {
        CircleInfo circle = circleInfoMapper.selectById(circleId);
        if (circle == null || !circle.getCreateUserId().equals(userId)) {
            throw new BusinessException(10002, "仅圈主可解散圈子");
        }
        circleInfoMapper.deleteById(circleId);
        circleMemberMapper.delete(new LambdaQueryWrapper<CircleMember>()
                .eq(CircleMember::getCircleId, circleId));
    }

    @Override
    public CircleInfo getCircleDetail(Long circleId) {
        CircleInfo circle = circleInfoMapper.selectById(circleId);
        if (circle == null) {
            throw new BusinessException("圈子不存在");
        }
        return circle;
    }

    @Override
    public List<CircleMember> getCircleMembers(Long circleId) {
        return circleMemberMapper.selectList(
                new LambdaQueryWrapper<CircleMember>().eq(CircleMember::getCircleId, circleId));
    }

    @Override
    public String generateInviteCode(Long userId, Long circleId) {
        CircleInfo circle = circleInfoMapper.selectById(circleId);
        if (circle == null || !circle.getCreateUserId().equals(userId)) {
            throw new BusinessException(10002, "仅圈主可生成邀请码");
        }

        String code = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        CircleInvite invite = new CircleInvite();
        invite.setCircleId(circleId);
        invite.setInviteCode(code);
        invite.setExpireTime(LocalDateTime.now().plusDays(7));
        circleInviteMapper.insert(invite);
        return code;
    }

    @Override
    @Transactional
    public CircleInfo joinByInviteCode(Long userId, String inviteCode) {
        CircleInvite invite = circleInviteMapper.selectOne(
                new LambdaQueryWrapper<CircleInvite>().eq(CircleInvite::getInviteCode, inviteCode));
        if (invite == null) {
            throw new BusinessException("邀请码无效");
        }
        CircleInfo circle = circleInfoMapper.selectById(invite.getCircleId());
        if (circle == null) {
            throw new BusinessException("圈子不存在");
        }
        joinCircle(userId, circle.getId(), inviteCode);
        return circle;
    }

    @Override
    public boolean isCircleMember(Long userId, Long circleId) {
        return circleMemberMapper.selectCount(
                new LambdaQueryWrapper<CircleMember>()
                        .eq(CircleMember::getCircleId, circleId)
                        .eq(CircleMember::getUserId, userId)) > 0;
    }
}
