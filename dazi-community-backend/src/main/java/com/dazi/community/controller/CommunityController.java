package com.dazi.community.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.common.result.Result;
import com.dazi.community.entity.dto.ApplyCommunityRequest;
import com.dazi.community.entity.dto.CreateCommunityRequest;
import com.dazi.community.entity.po.*;
import com.dazi.community.service.CommunityService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/community")
public class CommunityController {

    @Resource
    private CommunityService communityService;

    @GetMapping("/first/list")
    public Result<List<CommunityFirst>> getFirstLevelList() {
        return Result.success(communityService.getFirstLevelList());
    }

    @GetMapping("/second/page")
    public Result<Page<CommunitySecond>> getSecondLevelPage(
            @RequestParam(required = false) Long firstId,
            @RequestParam(required = false) String city,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(communityService.getSecondLevelPage(firstId, city, page, size));
    }

    @GetMapping("/second/{id}")
    public Result<Map<String, Object>> getSecondDetail(@PathVariable Long id, HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(communityService.getCommunityDetail(id, userId));
    }

    @PostMapping("/second/create")
    public Result<CommunitySecond> createSecond(HttpServletRequest request,
                                                 @Valid @RequestBody CreateCommunityRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(communityService.createSecond(userId, req));
    }

    @GetMapping("/second/my")
    public Result<List<CommunitySecond>> getMyCommunities(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(communityService.getUserCreatedCommunities(userId));
    }

    @PostMapping("/join/{communityId}")
    public Result<Void> joinCommunity(HttpServletRequest request, @PathVariable Long communityId) {
        Long userId = (Long) request.getAttribute("userId");
        communityService.joinCommunity(userId, communityId);
        return Result.success();
    }

    @PostMapping("/apply")
    public Result<Void> applyCommunity(HttpServletRequest request, @Valid @RequestBody ApplyCommunityRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        communityService.applyJoinCommunity(userId, req.getCommunityId(), req.getApplyReason(), req.getFreeTime());
        return Result.success();
    }

    @GetMapping("/apply/list/{communityId}")
    public Result<Page<CommunityJoinApply>> getApplyList(
            @PathVariable Long communityId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        if (!communityService.isManager(userId, communityId)) {
            return Result.error(10002, "权限不足");
        }
        return Result.success(communityService.getApplyList(communityId, page, size));
    }

    @PostMapping("/apply/approve/{applyId}")
    public Result<Void> approveApply(HttpServletRequest request, @PathVariable Long applyId,
                                      @RequestParam boolean approved) {
        Long userId = (Long) request.getAttribute("userId");
        communityService.approveApply(userId, applyId, approved);
        return Result.success();
    }

    @GetMapping("/members/{communityId}")
    public Result<List<CommunityMember>> getMembers(@PathVariable Long communityId) {
        return Result.success(communityService.getCommunityMembers(communityId));
    }

    @GetMapping("/check-member/{communityId}")
    public Result<Map<String, Boolean>> checkMember(HttpServletRequest request, @PathVariable Long communityId) {
        Long userId = (Long) request.getAttribute("userId");
        boolean isMember = communityService.isMember(userId, communityId);
        boolean isManager = communityService.isManager(userId, communityId);
        return Result.success(Map.of("isMember", isMember, "isManager", isManager));
    }
}
