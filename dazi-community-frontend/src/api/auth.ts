import request from '@/utils/request'
import type { ApiResult, LoginResult, SysUser } from '@/types'

export function login(data: { phone: string; code: string; nickname?: string }) {
  return request.post<ApiResult<LoginResult>>('/auth/login', data)
}

export function getCurrentUser() {
  return request.get<ApiResult<SysUser>>('/auth/current')
}

export function submitFaceAuth(data: { realName: string; idCard: string; faceImg?: string }) {
  return request.post<ApiResult<any>>('/auth/face/submit', null, { params: data })
}

export function checkFaceAuth() {
  return request.get<ApiResult<any>>('/auth/face/status')
}
