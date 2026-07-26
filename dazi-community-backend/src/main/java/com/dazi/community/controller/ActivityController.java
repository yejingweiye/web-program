package com.dazi.community.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.common.result.Result;
import com.dazi.community.entity.dto.CreateActivityRequest;
import com.dazi.community.entity.po.ActivityInfo;
import com.dazi.community.entity.po.ActivityOrder;
import com.dazi.community.service.ActivityService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;

@RestController
@RequestMapping("/api/v1/activity")
public class ActivityController {

    @Resource
    private ActivityService activityService;

    @PostMapping("/create")
    public Result<ActivityInfo> createActivity(HttpServletRequest request, @Valid @RequestBody CreateActivityRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(activityService.createActivity(userId, req));
    }

    @GetMapping("/page")
    public Result<Page<ActivityInfo>> getActivityPage(
            @RequestParam(required = false) Long communityId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(activityService.getActivityPage(communityId, page, size));
    }

    @GetMapping("/detail/{id}")
    public Result<ActivityInfo> getDetail(@PathVariable Long id) {
        return Result.success(activityService.getActivityDetail(id));
    }

    @PostMapping("/signup/{activityId}")
    public Result<ActivityOrder> signUp(HttpServletRequest request, @PathVariable Long activityId) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(activityService.signUpActivity(userId, activityId));
    }

    @GetMapping("/orders")
    public Result<Page<ActivityOrder>> getMyOrders(HttpServletRequest request,
                                                    @RequestParam(defaultValue = "1") int page,
                                                    @RequestParam(defaultValue = "10") int size) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(activityService.getUserActivityOrders(userId, page, size));
    }

    @PostMapping("/audit/{activityId}")
    public Result<Void> auditActivity(HttpServletRequest request, @PathVariable Long activityId,
                                       @RequestParam boolean approved) {
        Long userId = (Long) request.getAttribute("userId");
        activityService.auditActivity(userId, activityId, approved);
        return Result.success();
    }
}
