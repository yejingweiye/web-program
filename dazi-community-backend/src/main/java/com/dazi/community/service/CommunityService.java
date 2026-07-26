package com.dazi.community.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.entity.dto.CreateCommunityRequest;
import com.dazi.community.entity.po.*;

import java.util.List;
import java.util.Map;

public interface CommunityService {
    List<CommunityFirst> getFirstLevelList();
    Page<CommunitySecond> getSecondLevelPage(Long firstId, String city, int page, int size);
    CommunitySecond getSecondDetail(Long id);
    CommunitySecond createSecond(Long userId, CreateCommunityRequest request);
    List<CommunitySecond> getUserCreatedCommunities(Long userId);

    // Member management
    void joinCommunity(Long userId, Long communityId);
    void applyJoinCommunity(Long userId, Long communityId, String reason, String freeTime);
    void approveApply(Long managerId, Long applyId, boolean approved);
    Page<CommunityJoinApply> getApplyList(Long communityId, int page, int size);
    List<CommunityMember> getCommunityMembers(Long communityId);
    boolean isMember(Long userId, Long communityId);
    boolean isManager(Long userId, Long communityId);

    // Manager
    List<CommunityManager> getManagers(Long communityId);
    Map<String, Object> getCommunityDetail(Long communityId, Long userId);
}
