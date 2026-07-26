package com.dazi.community.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.entity.po.*;

import java.util.Map;

public interface AdminService {
    Page<SysUser> getUserPage(int page, int size);
    void updateUserStatus(Long userId, Integer status);
    Page<ReportInfo> getReportPage(int page, int size);
    void handleReport(Long adminId, Long reportId, Integer status, String result);
    Page<CommunitySecond> getCommunityPage(int page, int size);
    void updateCommunityStatus(Long communityId, Integer status);
    Map<String, Object> getDashboardStats();
    Page<FaceAuthVO> getFaceAuthPage(int page, int size);
    void approveFaceAuth(Long authId, boolean approved);

    // VO for face auth list
    record FaceAuthVO(Long id, Long userId, String realName, String idCard, String faceImg,
                      Integer authStatus, String authTime, String nickname) {}
}
