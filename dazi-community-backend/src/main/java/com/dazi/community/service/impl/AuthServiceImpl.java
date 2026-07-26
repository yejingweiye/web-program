package com.dazi.community.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.dazi.community.common.exception.BusinessException;
import com.dazi.community.common.jwt.JwtUtil;
import com.dazi.community.entity.dto.LoginRequest;
import com.dazi.community.entity.enums.AuthType;
import com.dazi.community.entity.po.SysUser;
import com.dazi.community.entity.po.UserFaceAuth;
import com.dazi.community.mapper.SysUserMapper;
import com.dazi.community.mapper.UserFaceAuthMapper;
import com.dazi.community.service.AuthService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
public class AuthServiceImpl implements AuthService {

    @Resource
    private SysUserMapper sysUserMapper;
    @Resource
    private UserFaceAuthMapper userFaceAuthMapper;
    @Resource
    private JwtUtil jwtUtil;

    @Override
    public Map<String, Object> login(LoginRequest request) {
        String phone = request.getPhone();
        // For demo: accept any verification code "1234" or any code
        // In production, integrate with SMS service
        if (request.getCode() == null || request.getCode().isEmpty()) {
            throw new BusinessException("验证码不能为空");
        }

        // Find or create user by phone
        SysUser user = sysUserMapper.selectOne(
                new LambdaQueryWrapper<SysUser>().eq(SysUser::getPhone, phone));
        boolean isNew = false;
        if (user == null) {
            user = new SysUser();
            user.setPhone(phone);
            user.setNickname(request.getNickname() != null ? request.getNickname() :
                    "用户" + phone.substring(Math.max(0, phone.length() - 4)));
            user.setAuthType(AuthType.PHONE); // phone verified by code
            user.setStatus(0);
            user.setIsVip(0);
            sysUserMapper.insert(user);
            isNew = true;
        }

        if (user.getStatus() == 2) {
            throw new BusinessException(10003, "账号已封禁");
        }

        String token = jwtUtil.generateToken(user.getId());
        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("userId", user.getId());
        result.put("nickname", user.getNickname());
        result.put("avatar", user.getAvatar());
        result.put("authType", user.getAuthType());
        result.put("isVip", user.getIsVip());
        result.put("isNew", isNew);
        return result;
    }

    @Override
    public SysUser getCurrentUser(Long userId) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        // Mask phone
        user.setPhone(maskPhone(user.getPhone()));
        return user;
    }

    @Override
    @Transactional
    public UserFaceAuth submitFaceAuth(Long userId, String realName, String idCard, String faceImg) {
        // Check existing
        UserFaceAuth existing = userFaceAuthMapper.selectOne(
                new LambdaQueryWrapper<UserFaceAuth>().eq(UserFaceAuth::getUserId, userId));
        if (existing != null) {
            throw new BusinessException("已提交过人脸认证");
        }

        UserFaceAuth auth = new UserFaceAuth();
        auth.setUserId(userId);
        auth.setRealName(realName);
        auth.setIdCard(idCard);
        auth.setFaceImg(faceImg);
        auth.setAuthStatus(0); // pending
        userFaceAuthMapper.insert(auth);
        return auth;
    }

    @Override
    public UserFaceAuth checkFaceAuth(Long userId) {
        return userFaceAuthMapper.selectOne(
                new LambdaQueryWrapper<UserFaceAuth>().eq(UserFaceAuth::getUserId, userId));
    }

    private String maskPhone(String phone) {
        if (phone == null || phone.length() < 7) return phone;
        return phone.substring(0, 3) + "****" + phone.substring(phone.length() - 4);
    }
}
