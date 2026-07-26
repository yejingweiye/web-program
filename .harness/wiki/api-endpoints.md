# API 端点汇总

所有 API 前缀：`/api/v1`

## 认证 (AuthController)

| 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|
| POST | `/auth/login` | 登录获取 Token | 否 |
| GET | `/auth/current` | 获取当前用户信息 | 是 |

## 用户 (UserController)

| 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|
| POST | `/auth/face-auth` | 提交人脸实名 | 是 |
| GET | `/user/profile/{userId}` | 查看用户资料 | 否 |
| PUT | `/user/profile` | 更新自己的资料 | 是 |

## 社区 (CommunityController)

| 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|
| GET | `/community/first/list` | 一级社区列表 | 否 |
| GET | `/community/second/page` | 二级社区分页 | 否 |
| GET | `/community/second/{id}` | 二级社区详情 | 否 |
| POST | `/community/second/create` | 创建二级社区 | 是 |
| GET | `/community/second/my` | 我创建的社区 | 是 |
| POST | `/community/join/{communityId}` | 加入社区 | 是 |
| POST | `/community/apply` | 申请加入 | 是 |
| GET | `/community/apply/list/{communityId}` | 申请列表 | 是 |
| POST | `/community/apply/approve/{applyId}` | 审批申请 | 是 |
| GET | `/community/members/{communityId}` | 成员列表 | 否 |
| GET | `/community/check-member/{communityId}` | 检查是否成员 | 是 |

## 圈子 (CircleController)

| 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|
| GET | `/circle/list/{secondId}` | 圈子列表 | 否 |
| POST | `/circle/create` | 创建圈子 | 是 |
| POST | `/circle/join/{circleId}` | 加入圈子 | 是 |
| GET | `/circle/members/{circleId}` | 圈子成员 | 否 |

## 帖子 (PostController)

| 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|
| GET | `/post/page` | 帖子分页列表 | 否 |
| GET | `/post/detail/{id}` | 帖子详情 | 否 |
| POST | `/post/create` | 发帖 | 是 |
| PUT | `/post/update` | 编辑帖子 | 是 |
| DELETE | `/post/{id}` | 删帖 | 是 |
| POST | `/post/comment` | 评论 | 是 |
| GET | `/post/comments/{postId}` | 评论列表 | 否 |
| POST | `/post/like/{postId}` | 点赞/取消 | 是 |

## 活动 (ActivityController)

| 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|
| POST | `/activity/create` | 发布活动 | 是 |
| GET | `/activity/page` | 活动列表 | 否 |
| GET | `/activity/detail/{id}` | 活动详情 | 否 |
| POST | `/activity/signup/{activityId}` | 报名 | 是 |
| GET | `/activity/orders` | 我的报名 | 是 |
| POST | `/activity/audit/{activityId}` | 审核活动 | 是 |

## VIP (VipController)

| 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|
| GET | `/vip/packages` | 套餐列表 | 否 |
| POST | `/vip/create-order/{packageId}` | 创建订单 | 是 |
| GET | `/vip/order/{orderId}` | 订单详情 | 否(需修复) |
| GET | `/vip/orders` | 我的订单 | 是(有缺陷) |

## 管理后台 (AdminController)

| 方法 | 路径 | 说明 | 认证 |
|------|------|------|------|
| GET | `/admin/users` | 用户列表 | 是(管理) |
| GET | `/admin/reports` | 举报列表 | 是(管理) |
| PUT | `/admin/report/handle/{id}` | 处理举报 | 是(管理) |
| POST | `/admin/face-auth/approve` | 审核实名 | 是(管理) |
| GET | `/admin/statistics` | 数据统计 | 是(管理) |
| PUT | `/admin/config` | 更新系统配置 | 是(管理) |

## WebSocket

| 端点 | 说明 |
|------|------|
| `/ws/chat` | 实时聊天 |

## 统一响应格式

```json
{
  "code": 200,
  "msg": "success",
  "data": {}
}
```

| code | 说明 |
|------|------|
| 200 | 成功 |
| 500 | 服务器内部错误 |
| 10001 | 未登录 / Token 失效 |
