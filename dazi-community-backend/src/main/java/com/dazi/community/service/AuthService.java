package com.dazi.community.service;

import com.dazi.community.entity.dto.LoginRequest;
import com.dazi.community.entity.po.SysUser;
import com.dazi.community.entity.po.UserFaceAuth;

import java.util.Map;

public interface AuthService {
    Map<String, Object> login(LoginRequest request);
    SysUser getCurrentUser(Long userId);
    UserFaceAuth submitFaceAuth(Long userId, String realName, String idCard, String faceImg);
    UserFaceAuth checkFaceAuth(Long userId);
}
