package com.dazi.community.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.entity.dto.CreateActivityRequest;
import com.dazi.community.entity.po.ActivityInfo;
import com.dazi.community.entity.po.ActivityOrder;

public interface ActivityService {
    ActivityInfo createActivity(Long userId, CreateActivityRequest request);
    Page<ActivityInfo> getActivityPage(Long communityId, int page, int size);
    ActivityInfo getActivityDetail(Long id);
    ActivityOrder signUpActivity(Long userId, Long activityId);
    Page<ActivityOrder> getUserActivityOrders(Long userId, int page, int size);
    void auditActivity(Long managerId, Long activityId, boolean approved);
}
