import request from '@/utils/request'
import type { ApiResult, SysUser } from '@/types'

export function updateProfile(data: Partial<SysUser>) {
  return request.put<ApiResult<SysUser>>('/user/profile', data)
}

export function getUserInfo() {
  return request.get<ApiResult<SysUser>>('/user/info')
}

export function getUserInfoById(id: number) {
  return request.get<ApiResult<SysUser>>(`/user/info/${id}`)
}
