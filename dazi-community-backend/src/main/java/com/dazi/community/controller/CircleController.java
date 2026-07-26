package com.dazi.community.controller;

import com.dazi.community.common.result.Result;
import com.dazi.community.entity.dto.CreateCircleRequest;
import com.dazi.community.entity.po.CircleInfo;
import com.dazi.community.entity.po.CircleMember;
import com.dazi.community.service.CircleService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/v1/circle")
public class CircleController {

    @Resource
    private CircleService circleService;

    @GetMapping("/list/{communityId}")
    public Result<List<CircleInfo>> getCircles(@PathVariable Long communityId) {
        return Result.success(circleService.getCirclesByCommunity(communityId));
    }

    @PostMapping("/create")
    public Result<CircleInfo> createCircle(HttpServletRequest request, @Valid @RequestBody CreateCircleRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(circleService.createCircle(userId, req));
    }

    @PostMapping("/join/{circleId}")
    public Result<Void> joinCircle(HttpServletRequest request, @PathVariable Long circleId,
                                    @RequestParam(required = false) String inviteCode) {
        Long userId = (Long) request.getAttribute("userId");
        circleService.joinCircle(userId, circleId, inviteCode);
        return Result.success();
    }

    @PostMapping("/leave/{circleId}")
    public Result<Void> leaveCircle(HttpServletRequest request, @PathVariable Long circleId) {
        Long userId = (Long) request.getAttribute("userId");
        circleService.leaveCircle(userId, circleId);
        return Result.success();
    }

    @PostMapping("/kick/{circleId}/{memberId}")
    public Result<Void> kickMember(HttpServletRequest request, @PathVariable Long circleId,
                                    @PathVariable Long memberId) {
        Long userId = (Long) request.getAttribute("userId");
        circleService.kickMember(userId, circleId, memberId);
        return Result.success();
    }

    @PostMapping("/dismiss/{circleId}")
    public Result<Void> dismissCircle(HttpServletRequest request, @PathVariable Long circleId) {
        Long userId = (Long) request.getAttribute("userId");
        circleService.dismissCircle(userId, circleId);
        return Result.success();
    }

    @GetMapping("/detail/{circleId}")
    public Result<CircleInfo> getDetail(@PathVariable Long circleId) {
        return Result.success(circleService.getCircleDetail(circleId));
    }

    @GetMapping("/members/{circleId}")
    public Result<List<CircleMember>> getMembers(@PathVariable Long circleId) {
        return Result.success(circleService.getCircleMembers(circleId));
    }

    @PostMapping("/invite/generate/{circleId}")
    public Result<String> generateInvite(HttpServletRequest request, @PathVariable Long circleId) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(circleService.generateInviteCode(userId, circleId));
    }

    @PostMapping("/invite/join")
    public Result<CircleInfo> joinByInvite(HttpServletRequest request, @RequestParam String code) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(circleService.joinByInviteCode(userId, code));
    }

    @GetMapping("/check/{circleId}")
    public Result<Boolean> checkMember(HttpServletRequest request, @PathVariable Long circleId) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(circleService.isCircleMember(userId, circleId));
    }
}
