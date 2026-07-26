package com.dazi.community.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.common.result.Result;
import com.dazi.community.entity.po.CommunitySecond;
import com.dazi.community.entity.po.ReportInfo;
import com.dazi.community.entity.po.SysUser;
import com.dazi.community.service.AdminService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/admin")
public class AdminController {

    @Resource
    private AdminService adminService;

    @GetMapping("/dashboard")
    public Result<Map<String, Object>> dashboard() {
        return Result.success(adminService.getDashboardStats());
    }

    @GetMapping("/users")
    public Result<Page<SysUser>> getUserPage(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(adminService.getUserPage(page, size));
    }

    @PutMapping("/user/{userId}/status")
    public Result<Void> updateUserStatus(@PathVariable Long userId, @RequestParam Integer status) {
        adminService.updateUserStatus(userId, status);
        return Result.success();
    }

    @GetMapping("/face-auth")
    public Result<Page<AdminService.FaceAuthVO>> getFaceAuthPage(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(adminService.getFaceAuthPage(page, size));
    }

    @PostMapping("/face-auth/{authId}/approve")
    public Result<Void> approveFaceAuth(@PathVariable Long authId, @RequestParam boolean approved) {
        adminService.approveFaceAuth(authId, approved);
        return Result.success();
    }

    @GetMapping("/reports")
    public Result<Page<ReportInfo>> getReportPage(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(adminService.getReportPage(page, size));
    }

    @PostMapping("/report/{reportId}/handle")
    public Result<Void> handleReport(HttpServletRequest request, @PathVariable Long reportId,
                                      @RequestParam Integer status, @RequestParam String result) {
        Long adminId = (Long) request.getAttribute("userId");
        adminService.handleReport(adminId, reportId, status, result);
        return Result.success();
    }

    @GetMapping("/communities")
    public Result<Page<CommunitySecond>> getCommunityPage(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(adminService.getCommunityPage(page, size));
    }

    @PutMapping("/community/{communityId}/status")
    public Result<Void> updateCommunityStatus(@PathVariable Long communityId, @RequestParam Integer status) {
        adminService.updateCommunityStatus(communityId, status);
        return Result.success();
    }
}
