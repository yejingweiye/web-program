package com.dazi.community.controller;

import com.dazi.community.common.result.Result;
import com.dazi.community.entity.dto.LoginRequest;
import com.dazi.community.entity.po.SysUser;
import com.dazi.community.entity.po.UserFaceAuth;
import com.dazi.community.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthController {

    @Resource
    private AuthService authService;

    @PostMapping("/login")
    public Result<Map<String, Object>> login(@Valid @RequestBody LoginRequest request) {
        return Result.success(authService.login(request));
    }

    @GetMapping("/current")
    public Result<SysUser> current(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(authService.getCurrentUser(userId));
    }

    @PostMapping("/face/submit")
    public Result<UserFaceAuth> submitFaceAuth(HttpServletRequest request,
                                                @RequestParam String realName,
                                                @RequestParam String idCard,
                                                @RequestParam(required = false) String faceImg) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(authService.submitFaceAuth(userId, realName, idCard, faceImg));
    }

    @GetMapping("/face/status")
    public Result<UserFaceAuth> checkFaceAuth(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(authService.checkFaceAuth(userId));
    }
}
