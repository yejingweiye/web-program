package com.dazi.community.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.common.exception.BusinessException;
import com.dazi.community.entity.enums.AuthType;
import com.dazi.community.entity.po.*;
import com.dazi.community.mapper.*;
import com.dazi.community.service.AdminService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class AdminServiceImpl implements AdminService {

    @Resource
    private SysUserMapper sysUserMapper;
    @Resource
    private UserFaceAuthMapper userFaceAuthMapper;
    @Resource
    private ReportInfoMapper reportInfoMapper;
    @Resource
    private CommunitySecondMapper communitySecondMapper;
    @Resource
    private VipOrderMapper vipOrderMapper;
    @Resource
    private ActivityOrderMapper activityOrderMapper;
    @Resource
    private TopOrderMapper topOrderMapper;

    @Override
    public Page<SysUser> getUserPage(int page, int size) {
        return sysUserMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<SysUser>().orderByDesc(SysUser::getCreateTime));
    }

    @Override
    @Transactional
    public void updateUserStatus(Long userId, Integer status) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        user.setStatus(status);
        sysUserMapper.updateById(user);
    }

    @Override
    public Page<ReportInfo> getReportPage(int page, int size) {
        return reportInfoMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<ReportInfo>().orderByDesc(ReportInfo::getCreateTime));
    }

    @Override
    @Transactional
    public void handleReport(Long adminId, Long reportId, Integer status, String result) {
        ReportInfo report = reportInfoMapper.selectById(reportId);
        if (report == null) {
            throw new BusinessException("举报不存在");
        }
        report.setStatus(status);
        report.setHandleUserId(adminId);
        report.setHandleResult(result);
        reportInfoMapper.updateById(report);
    }

    @Override
    public Page<CommunitySecond> getCommunityPage(int page, int size) {
        return communitySecondMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<CommunitySecond>().orderByDesc(CommunitySecond::getCreateTime));
    }

    @Override
    @Transactional
    public void updateCommunityStatus(Long communityId, Integer status) {
        CommunitySecond cs = communitySecondMapper.selectById(communityId);
        if (cs == null) {
            throw new BusinessException("社区不存在");
        }
        cs.setStatus(status);
        communitySecondMapper.updateById(cs);
    }

    @Override
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalUsers", sysUserMapper.selectCount(null));
        stats.put("totalCommunities", communitySecondMapper.selectCount(null));
        stats.put("totalReports", reportInfoMapper.selectCount(
                new LambdaQueryWrapper<ReportInfo>().eq(ReportInfo::getStatus, 0)));
        stats.put("totalVipOrders", vipOrderMapper.selectCount(null));
        stats.put("totalActivityOrders", activityOrderMapper.selectCount(null));
        stats.put("totalTopOrders", topOrderMapper.selectCount(null));
        return stats;
    }

    @Override
    public Page<FaceAuthVO> getFaceAuthPage(int page, int size) {
        Page<UserFaceAuth> authPage = userFaceAuthMapper.selectPage(new Page<>(page, size),
                new LambdaQueryWrapper<UserFaceAuth>().orderByDesc(UserFaceAuth::getCreateTime));
        Page<FaceAuthVO> voPage = new Page<>(authPage.getCurrent(), authPage.getSize(), authPage.getTotal());
        List<FaceAuthVO> records = authPage.getRecords().stream().map(a -> {
            SysUser user = sysUserMapper.selectById(a.getUserId());
            return new FaceAuthVO(
                    a.getId(), a.getUserId(), a.getRealName(), a.getIdCard(), a.getFaceImg(),
                    a.getAuthStatus(), a.getAuthTime() != null ? a.getAuthTime().toString() : "",
                    user != null ? user.getNickname() : "");
        }).collect(Collectors.toList());
        voPage.setRecords(records);
        return voPage;
    }

    @Override
    @Transactional
    public void approveFaceAuth(Long authId, boolean approved) {
        UserFaceAuth auth = userFaceAuthMapper.selectById(authId);
        if (auth == null || auth.getAuthStatus() != 0) {
            throw new BusinessException("认证不存在或已处理");
        }
        auth.setAuthStatus(approved ? 1 : 2);
        auth.setAuthTime(LocalDateTime.now());
        userFaceAuthMapper.updateById(auth);

        if (approved) {
            SysUser user = sysUserMapper.selectById(auth.getUserId());
            user.setAuthType(AuthType.FACE);
            sysUserMapper.updateById(user);
        }
    }
}
