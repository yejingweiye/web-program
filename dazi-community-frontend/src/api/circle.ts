import request from '@/utils/request'
import type { ApiResult, CircleInfo } from '@/types'

export function getCircleList(communityId: number) {
  return request.get<ApiResult<CircleInfo[]>>(`/circle/list/${communityId}`)
}

export function createCircle(data: { communityId: number; name: string; type?: number }) {
  return request.post<ApiResult<CircleInfo>>('/circle/create', data)
}

export function joinCircle(circleId: number, inviteCode?: string) {
  return request.post<ApiResult<void>>(`/circle/join/${circleId}`, null, { params: { inviteCode } })
}

export function leaveCircle(circleId: number) {
  return request.post<ApiResult<void>>(`/circle/leave/${circleId}`)
}

export function generateInvite(circleId: number) {
  return request.post<ApiResult<string>>(`/circle/invite/generate/${circleId}`)
}

export function joinByInvite(code: string) {
  return request.post<ApiResult<CircleInfo>>('/circle/invite/join', null, { params: { code } })
}

export function getCircleDetail(circleId: number) {
  return request.get<ApiResult<CircleInfo>>(`/circle/detail/${circleId}`)
}

export function getCircleMembers(circleId: number) {
  return request.get<ApiResult<any[]>>(`/circle/members/${circleId}`)
}
