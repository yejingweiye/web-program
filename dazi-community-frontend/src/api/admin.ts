import request from '@/utils/request'
import type { ApiResult, PageResult, DashboardStats, ReportInfo } from '@/types'

export function getDashboard() {
  return request.get<ApiResult<DashboardStats>>('/admin/dashboard')
}

export function getUserPage(page = 1, size = 10) {
  return request.get<ApiResult<PageResult<any>>>('/admin/users', { params: { page, size } })
}

export function updateUserStatus(userId: number, status: number) {
  return request.put<ApiResult<void>>(`/admin/user/${userId}/status`, null, { params: { status } })
}

export function getFaceAuthPage(page = 1, size = 10) {
  return request.get<ApiResult<PageResult<any>>>('/admin/face-auth', { params: { page, size } })
}

export function approveFaceAuth(authId: number, approved: boolean) {
  return request.post<ApiResult<void>>(`/admin/face-auth/${authId}/approve`, null, { params: { approved } })
}

export function getReportPage(page = 1, size = 10) {
  return request.get<ApiResult<PageResult<ReportInfo>>>('/admin/reports', { params: { page, size } })
}

export function handleReport(reportId: number, status: number, result: string) {
  return request.post<ApiResult<void>>(`/admin/report/${reportId}/handle`, null, { params: { status, result } })
}

export function getAdminCommunityPage(page = 1, size = 10) {
  return request.get<ApiResult<PageResult<any>>>('/admin/communities', { params: { page, size } })
}

export function updateCommunityStatus(communityId: number, status: number) {
  return request.put<ApiResult<void>>(`/admin/community/${communityId}/status`, null, { params: { status } })
}
