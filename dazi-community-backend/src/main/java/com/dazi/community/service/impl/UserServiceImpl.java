package com.dazi.community.service.impl;

import com.dazi.community.common.exception.BusinessException;
import com.dazi.community.entity.dto.UserUpdateRequest;
import com.dazi.community.entity.po.SysUser;
import com.dazi.community.mapper.SysUserMapper;
import com.dazi.community.service.UserService;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;

@Service
public class UserServiceImpl implements UserService {

    @Resource
    private SysUserMapper sysUserMapper;

    @Override
    public SysUser updateProfile(Long userId, UserUpdateRequest request) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        if (request.getNickname() != null) user.setNickname(request.getNickname());
        if (request.getAvatar() != null) user.setAvatar(request.getAvatar());
        if (request.getCity() != null) user.setCity(request.getCity());
        if (request.getAge() != null) user.setAge(request.getAge());
        if (request.getGender() != null) user.setGender(request.getGender());
        if (request.getFreeTime() != null) user.setFreeTime(request.getFreeTime());
        if (request.getBudget() != null) user.setBudget(request.getBudget());
        if (request.getTags() != null) user.setTags(request.getTags());
        sysUserMapper.updateById(user);
        return user;
    }

    @Override
    public SysUser getUserById(Long userId) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        return user;
    }
}
