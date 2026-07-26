import request from '@/utils/request'
import type { ApiResult, CommunityFirst, CommunitySecond, CommunityDetail, CommunityJoinApply, PageResult } from '@/types'

export function getFirstLevelList() {
  return request.get<ApiResult<CommunityFirst[]>>('/community/first/list')
}

export function getSecondLevelPage(params: { firstId?: number; city?: string; page?: number; size?: number }) {
  return request.get<ApiResult<PageResult<CommunitySecond>>>('/community/second/page', { params })
}

export function getSecondDetail(id: number) {
  return request.get<ApiResult<CommunityDetail>>(`/community/second/${id}`)
}

export function createSecondCommunity(data: { firstId: number; name: string; city?: string; desc?: string; joinType?: number }) {
  return request.post<ApiResult<CommunitySecond>>('/community/second/create', data)
}

export function getMyCommunities() {
  return request.get<ApiResult<CommunitySecond[]>>('/community/second/my')
}

export function joinCommunity(communityId: number) {
  return request.post<ApiResult<void>>(`/community/join/${communityId}`)
}

export function applyCommunity(data: { communityId: number; applyReason?: string; freeTime?: string }) {
  return request.post<ApiResult<void>>('/community/apply', data)
}

export function getApplyList(communityId: number, page = 1, size = 10) {
  return request.get<ApiResult<PageResult<CommunityJoinApply>>>(`/community/apply/list/${communityId}`, {
    params: { page, size }
  })
}

export function approveApply(applyId: number, approved: boolean) {
  return request.post<ApiResult<void>>(`/community/apply/approve/${applyId}`, null, { params: { approved } })
}

export function checkMember(communityId: number) {
  return request.get<ApiResult<{ isMember: boolean; isManager: boolean }>>(`/community/check-member/${communityId}`)
}
