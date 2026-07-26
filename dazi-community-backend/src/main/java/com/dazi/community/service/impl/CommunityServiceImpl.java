package com.dazi.community.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.common.exception.BusinessException;
import com.dazi.community.constant.BizConstant;
import com.dazi.community.entity.dto.CreateCommunityRequest;
import com.dazi.community.entity.enums.AuthType;
import com.dazi.community.entity.po.*;
import com.dazi.community.mapper.*;
import com.dazi.community.service.CommunityService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class CommunityServiceImpl implements CommunityService {

    @Resource
    private CommunityFirstMapper communityFirstMapper;
    @Resource
    private CommunitySecondMapper communitySecondMapper;
    @Resource
    private CommunityManagerMapper communityManagerMapper;
    @Resource
    private CommunityJoinApplyMapper communityJoinApplyMapper;
    @Resource
    private CommunityMemberMapper communityMemberMapper;
    @Resource
    private SysUserMapper sysUserMapper;

    @Override
    public List<CommunityFirst> getFirstLevelList() {
        return communityFirstMapper.selectList(
                new LambdaQueryWrapper<CommunityFirst>().eq(CommunityFirst::getStatus, 1)
                        .orderByAsc(CommunityFirst::getSort));
    }

    @Override
    public Page<CommunitySecond> getSecondLevelPage(Long firstId, String city, int page, int size) {
        LambdaQueryWrapper<CommunitySecond> wrapper = new LambdaQueryWrapper<CommunitySecond>()
                .eq(CommunitySecond::getStatus, 1);
        if (firstId != null) {
            wrapper.eq(CommunitySecond::getFirstId, firstId);
        }
        if (city != null && !city.isEmpty()) {
            wrapper.eq(CommunitySecond::getCity, city);
        }
        wrapper.orderByDesc(CommunitySecond::getCreateTime);
        return communitySecondMapper.selectPage(new Page<>(page, size), wrapper);
    }

    @Override
    public CommunitySecond getSecondDetail(Long id) {
        CommunitySecond cs = communitySecondMapper.selectById(id);
        if (cs == null) {
            throw new BusinessException("社区不存在");
        }
        return cs;
    }

    @Override
    @Transactional
    public CommunitySecond createSecond(Long userId, CreateCommunityRequest request) {
        // Check user auth level
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null || user.getAuthType() < AuthType.FACE) {
            throw new BusinessException(30001, "需完成人脸实名才可创建社区");
        }
        if (user.getStatus() != 0) {
            throw new BusinessException(10003, "账号状态异常");
        }

        // Check count of user's created communities
        long count = communitySecondMapper.selectCount(
                new LambdaQueryWrapper<CommunitySecond>().eq(CommunitySecond::getCreateUserId, userId));
        if (count >= BizConstant.COMMUNITY_CREATE_FREE && (user.getIsVip() == null || user.getIsVip() == 0)) {
            throw new BusinessException("免费用户限建1个社区，请开通会员或付费创建");
        }

        // Check parent exists
        CommunityFirst first = communityFirstMapper.selectById(request.getFirstId());
        if (first == null) {
            throw new BusinessException("一级社区不存在");
        }

        CommunitySecond cs = new CommunitySecond();
        cs.setFirstId(request.getFirstId());
        cs.setName(request.getName());
        cs.setCity(request.getCity());
        cs.setDescription(request.getDesc());
        cs.setJoinType(request.getJoinType() != null ? request.getJoinType() : 0);
        cs.setCreateUserId(userId);
        cs.setMemberCount(1);
        communitySecondMapper.insert(cs);

        // Creator becomes main manager
        CommunityManager manager = new CommunityManager();
        manager.setCommunityId(cs.getId());
        manager.setUserId(userId);
        manager.setRole(1);
        communityManagerMapper.insert(manager);

        // Auto join
        CommunityMember member = new CommunityMember();
        member.setCommunityId(cs.getId());
        member.setUserId(userId);
        member.setJoinTime(LocalDateTime.now());
        communityMemberMapper.insert(member);

        return cs;
    }

    @Override
    public List<CommunitySecond> getUserCreatedCommunities(Long userId) {
        return communitySecondMapper.selectList(
                new LambdaQueryWrapper<CommunitySecond>().eq(CommunitySecond::getCreateUserId, userId));
    }

    @Override
    @Transactional
    public void joinCommunity(Long userId, Long communityId) {
        CommunitySecond cs = communitySecondMapper.selectById(communityId);
        if (cs == null || cs.getStatus() != 1) {
            throw new BusinessException("社区不存在或已禁用");
        }

        // Check if already member
        Long memberCount = communityMemberMapper.selectCount(
                new LambdaQueryWrapper<CommunityMember>()
                        .eq(CommunityMember::getCommunityId, communityId)
                        .eq(CommunityMember::getUserId, userId));
        if (memberCount > 0) {
            throw new BusinessException("已经是社区成员");
        }

        if (cs.getJoinType() == 1) {
            throw new BusinessException("该社区需要管理员审核加入");
        }

        CommunityMember member = new CommunityMember();
        member.setCommunityId(communityId);
        member.setUserId(userId);
        member.setJoinTime(LocalDateTime.now());
        communityMemberMapper.insert(member);

        // Update member count
        cs.setMemberCount(cs.getMemberCount() + 1);
        communitySecondMapper.updateById(cs);
    }

    @Override
    @Transactional
    public void applyJoinCommunity(Long userId, Long communityId, String reason, String freeTime) {
        CommunitySecond cs = communitySecondMapper.selectById(communityId);
        if (cs == null || cs.getStatus() != 1) {
            throw new BusinessException("社区不存在或已禁用");
        }

        // Check if already member
        Long memberCount = communityMemberMapper.selectCount(
                new LambdaQueryWrapper<CommunityMember>()
                        .eq(CommunityMember::getCommunityId, communityId)
                        .eq(CommunityMember::getUserId, userId));
        if (memberCount > 0) {
            throw new BusinessException("已经是社区成员");
        }

        // Check if already applied
        Long applyCount = communityJoinApplyMapper.selectCount(
                new LambdaQueryWrapper<CommunityJoinApply>()
                        .eq(CommunityJoinApply::getCommunityId, communityId)
                        .eq(CommunityJoinApply::getUserId, userId)
                        .eq(CommunityJoinApply::getStatus, 0));
        if (applyCount > 0) {
            throw new BusinessException("已提交申请，请等待审核");
        }

        CommunityJoinApply apply = new CommunityJoinApply();
        apply.setCommunityId(communityId);
        apply.setUserId(userId);
        apply.setApplyReason(reason);
        apply.setFreeTime(freeTime);
        communityJoinApplyMapper.insert(apply);
    }

    @Override
    @Transactional
    public void approveApply(Long managerId, Long applyId, boolean approved) {
        CommunityJoinApply apply = communityJoinApplyMapper.selectById(applyId);
        if (apply == null || apply.getStatus() != 0) {
            throw new BusinessException("申请不存在或已处理");
        }

        // Check if manager
        if (!isManager(managerId, apply.getCommunityId())) {
            throw new BusinessException(10002, "权限不足");
        }

        apply.setStatus(approved ? 1 : 2);
        communityJoinApplyMapper.updateById(apply);

        if (approved) {
            CommunityMember member = new CommunityMember();
            member.setCommunityId(apply.getCommunityId());
            member.setUserId(apply.getUserId());
            member.setJoinTime(LocalDateTime.now());
            communityMemberMapper.insert(member);

            CommunitySecond cs = communitySecondMapper.selectById(apply.getCommunityId());
            cs.setMemberCount(cs.getMemberCount() + 1);
            communitySecondMapper.updateById(cs);
        }
    }

    @Override
    public Page<CommunityJoinApply> getApplyList(Long communityId, int page, int size) {
        return communityJoinApplyMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<CommunityJoinApply>()
                        .eq(CommunityJoinApply::getCommunityId, communityId)
                        .orderByDesc(CommunityJoinApply::getCreateTime));
    }

    @Override
    public List<CommunityMember> getCommunityMembers(Long communityId) {
        return communityMemberMapper.selectList(
                new LambdaQueryWrapper<CommunityMember>()
                        .eq(CommunityMember::getCommunityId, communityId));
    }

    @Override
    public boolean isMember(Long userId, Long communityId) {
        return communityMemberMapper.selectCount(
                new LambdaQueryWrapper<CommunityMember>()
                        .eq(CommunityMember::getCommunityId, communityId)
                        .eq(CommunityMember::getUserId, userId)) > 0;
    }

    @Override
    public boolean isManager(Long userId, Long communityId) {
        return communityManagerMapper.selectCount(
                new LambdaQueryWrapper<CommunityManager>()
                        .eq(CommunityManager::getCommunityId, communityId)
                        .eq(CommunityManager::getUserId, userId)) > 0;
    }

    @Override
    public List<CommunityManager> getManagers(Long communityId) {
        return communityManagerMapper.selectList(
                new LambdaQueryWrapper<CommunityManager>()
                        .eq(CommunityManager::getCommunityId, communityId));
    }

    @Override
    public Map<String, Object> getCommunityDetail(Long communityId, Long userId) {
        CommunitySecond cs = getSecondDetail(communityId);
        List<CommunityManager> managers = getManagers(communityId);
        boolean userIsMember = isMember(userId, communityId);
        boolean userIsManager = isManager(userId, communityId);
        long memberCount = communityMemberMapper.selectCount(
                new LambdaQueryWrapper<CommunityMember>().eq(CommunityMember::getCommunityId, communityId));

        Map<String, Object> result = new HashMap<>();
        result.put("community", cs);
        result.put("managers", managers.stream().map(m -> {
            SysUser u = sysUserMapper.selectById(m.getUserId());
            return Map.of("userId", m.getUserId(), "role", m.getRole(),
                    "nickname", u != null ? u.getNickname() : "");
        }).collect(Collectors.toList()));
        result.put("isMember", userIsMember);
        result.put("isManager", userIsManager);
        result.put("memberCount", memberCount);
        result.put("firstLevel", communityFirstMapper.selectById(cs.getFirstId()));
        return result;
    }
}
