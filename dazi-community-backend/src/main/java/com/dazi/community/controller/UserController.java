package com.dazi.community.controller;

import com.dazi.community.common.result.Result;
import com.dazi.community.entity.dto.UserUpdateRequest;
import com.dazi.community.entity.po.SysUser;
import com.dazi.community.service.UserService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;

@RestController
@RequestMapping("/api/v1/user")
public class UserController {

    @Resource
    private UserService userService;

    @PutMapping("/profile")
    public Result<SysUser> updateProfile(HttpServletRequest request, @RequestBody UserUpdateRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(userService.updateProfile(userId, req));
    }

    @GetMapping("/info")
    public Result<SysUser> getUserInfo(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(userService.getUserById(userId));
    }

    @GetMapping("/info/{id}")
    public Result<SysUser> getUserInfoById(@PathVariable Long id) {
        return Result.success(userService.getUserById(id));
    }
}
