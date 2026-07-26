import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import 'dayjs/locale/zh-cn'

dayjs.extend(relativeTime)
dayjs.locale('zh-cn')

export function formatTime(time: string | undefined): string {
  if (!time) return '未知'
  return dayjs(time).format('YYYY-MM-DD HH:mm')
}

export function formatRelativeTime(time: string | undefined): string {
  if (!time) return ''
  return dayjs(time).fromNow()
}

export function formatPrice(price: number | undefined): string {
  if (price === undefined || price === null) return '免费'
  return `¥${Number(price).toFixed(2)}`
}

export function authTypeText(type: number | undefined): string {
  const map: Record<number, string> = { 0: '未实名', 1: '手机实名', 2: '人脸实名' }
  return map[type ?? 0] || '未知'
}

export function statusText(status: number | undefined): string {
  const map: Record<number, string> = { 0: '正常', 1: '禁言', 2: '封禁' }
  return map[status ?? 0] || '未知'
}

export function genderText(gender: number | undefined): string {
  const map: Record<number, string> = { 0: '未知', 1: '男', 2: '女' }
  return map[gender ?? 0] || '未知'
}

export function joinTypeText(type: number | undefined): string {
  return type === 1 ? '审核加入' : '自由加入'
}

export function circleTypeText(type: number | undefined): string {
  return type === 1 ? '私密圈子' : '公开圈子'
}

export function payStatusText(status: number | undefined): string {
  const map: Record<number, string> = { 0: '未支付', 1: '已支付', 2: '已退款', 3: '支付失败' }
  return map[status ?? 0] || '未知'
}

export function auditStatusText(status: number | undefined): string {
  const map: Record<number, string> = { 0: '待审核', 1: '已通过', 2: '已驳回' }
  return map[status ?? 0] || '未知'
}
