export interface ApiResult<T> {
  code: number
  msg: string
  data: T
}

export interface PageResult<T> {
  records: T[]
  total: number
  current: number
  size: number
  pages: number
}

export interface SysUser {
  id: number
  nickname: string
  avatar: string
  phone: string
  city: string
  age: number
  gender: number
  freeTime: string
  budget: number
  tags: string
  authType: number
  status: number
  isVip: number
  vipExpireTime: string
  createTime: string
}

export interface LoginResult {
  token: string
  userId: number
  nickname: string
  avatar: string
  authType: number
  isVip: number
  isNew: boolean
}

export interface CommunityFirst {
  id: number
  name: string
  icon: string
  sort: number
  status: number
}

export interface CommunitySecond {
  id: number
  firstId: number
  name: string
  city: string
  description: string
  joinType: number
  createUserId: number
  status: number
  memberCount: number
  createTime: string
}

export interface CommunityDetail {
  community: CommunitySecond
  managers: { userId: number; role: number; nickname: string }[]
  isMember: boolean
  isManager: boolean
  memberCount: number
  firstLevel: CommunityFirst
}

export interface CommunityJoinApply {
  id: number
  communityId: number
  userId: number
  applyReason: string
  freeTime: string
  status: number
  createTime: string
}

export interface CircleInfo {
  id: number
  communityId: number
  name: string
  type: number
  maxNum: number
  createUserId: number
  createTime: string
}

export interface PostInfo {
  id: number
  communityId: number
  userId: number
  title: string
  content: string
  imgList: string
  city: string
  address: string
  startTime: string
  budget: number
  peopleNum: number
  tags: string
  scope: number
  status: number
  isTop: number
  viewCount: number
  likeCount: number
  commentCount: number
  createTime: string
}

export interface PostComment {
  id: number
  postId: number
  userId: number
  content: string
  parentId: number
  createTime: string
}

export interface ActivityInfo {
  id: number
  communityId: number
  userId: number
  title: string
  content: string
  address: string
  startTime: string
  endTime: string
  maxPeople: number
  fee: number
  status: number
  auditStatus: number
  createTime: string
}

export interface ActivityOrder {
  id: number
  activityId: number
  userId: number
  payPrice: number
  serviceFee: number
  payStatus: number
  createTime: string
}

export interface VipPackage {
  id: number
  name: string
  type: number
  price: number
  days: number
  description: string
}

export interface VipOrder {
  id: number
  userId: number
  packageId: number
  payPrice: number
  payStatus: number
  expireTime: string
  createTime: string
}

export interface ReportInfo {
  id: number
  reportUserId: number
  targetType: number
  targetId: number
  reason: string
  status: number
  createTime: string
}

export interface DashboardStats {
  totalUsers: number
  totalCommunities: number
  totalReports: number
  totalVipOrders: number
  totalActivityOrders: number
  totalTopOrders: number
}
