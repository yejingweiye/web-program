package com.dazi.community.service;

import com.dazi.community.entity.dto.UserUpdateRequest;
import com.dazi.community.entity.po.SysUser;

public interface UserService {
    SysUser updateProfile(Long userId, UserUpdateRequest request);
    SysUser getUserById(Long userId);
}
