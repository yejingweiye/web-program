import request from '@/utils/request'
import type { ApiResult, ActivityInfo, ActivityOrder, PageResult } from '@/types'

export function createActivity(data: { communityId: number; title: string; content?: string; address?: string; startTime?: string; endTime?: string; maxPeople?: number; fee?: number }) {
  return request.post<ApiResult<ActivityInfo>>('/activity/create', data)
}

export function getActivityPage(params: { communityId?: number; page?: number; size?: number }) {
  return request.get<ApiResult<PageResult<ActivityInfo>>>('/activity/page', { params })
}

export function getActivityDetail(id: number) {
  return request.get<ApiResult<ActivityInfo>>(`/activity/detail/${id}`)
}

export function signUpActivity(activityId: number) {
  return request.post<ApiResult<ActivityOrder>>(`/activity/signup/${activityId}`)
}

export function getMyActivityOrders(page = 1, size = 10) {
  return request.get<ApiResult<PageResult<ActivityOrder>>>('/activity/orders', { params: { page, size } })
}

export function auditActivity(activityId: number, approved: boolean) {
  return request.post<ApiResult<void>>(`/activity/audit/${activityId}`, null, { params: { approved } })
}
