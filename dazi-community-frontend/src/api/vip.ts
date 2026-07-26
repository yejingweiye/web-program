import request from '@/utils/request'
import type { ApiResult, VipPackage, VipOrder } from '@/types'

export function getPackageList() {
  return request.get<ApiResult<VipPackage[]>>('/vip/packages')
}

export function createVipOrder(packageId: number) {
  return request.post<ApiResult<VipOrder>>(`/vip/create-order/${packageId}`)
}

export function getVipOrders() {
  return request.get<ApiResult<VipOrder[]>>('/vip/orders')
}
