package com.dazi.community.service;

import com.dazi.community.entity.dto.CreateCircleRequest;
import com.dazi.community.entity.po.CircleInfo;
import com.dazi.community.entity.po.CircleMember;

import java.util.List;
import java.util.Map;

public interface CircleService {
    List<CircleInfo> getCirclesByCommunity(Long communityId);
    CircleInfo createCircle(Long userId, CreateCircleRequest request);
    void joinCircle(Long userId, Long circleId, String inviteCode);
    void leaveCircle(Long userId, Long circleId);
    void kickMember(Long userId, Long circleId, Long memberId);
    void dismissCircle(Long userId, Long circleId);
    CircleInfo getCircleDetail(Long circleId);
    List<CircleMember> getCircleMembers(Long circleId);
    String generateInviteCode(Long userId, Long circleId);
    CircleInfo joinByInviteCode(Long userId, String inviteCode);
    boolean isCircleMember(Long userId, Long circleId);
}
