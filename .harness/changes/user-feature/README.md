# 用户功能模块

## 概述

用户功能模块涵盖用户的注册登录、个人资料管理、实名认证体系、账号安全设置等功能。本模块是平台的基础能力，其他所有模块（社区、帖子、活动等）都依赖用户身份系统。

## 功能清单

| 功能 | 状态 | 后端 | 前端 | 说明 |
|------|------|------|------|------|
| 手机号登录 | ✅ 已完成 | AuthController | Login | 任意验证码登录 |
| Token 鉴权 | ✅ 已完成 | JwtInterceptor | request.ts | Bearer Token |
| 当前用户信息 | ✅ 已完成 | GET /auth/current | 通用 | 获取登录用户信息 |
| 资料编辑 | ✅ 已完成 | PUT /user/profile | Profile | 昵称、头像、城市等 |
| 人脸实名认证 | ✅ 已完成 | POST /auth/face/submit | FaceAuth | 提审+状态查询 |
| 他人资料查看 | ✅ 已完成 | GET /user/info/{id} | - | 公开资料 |
| 用户注册 | 🆕 待开发 | - | - | 完善注册流程 |
| 账号注销 | 🆕 待开发 | - | - | 账号注销功能 |
| 用户黑名单 | 🆕 待开发 | - | - | 屏蔽用户 |
| 收藏/关注 | 🆕 待开发 | - | - | 用户关系 |

## 模块依赖

```
auth (登录鉴权)
  └── sys_user (用户基础信息)
        ├── user_face_auth (实名信息)
        ├── post_info (帖子)
        ├── post_comment (评论)
        ├── activity_order (活动报名)
        ├── community_member (社区成员)
        ├── circle_member (圈子成员)
        ├── vip_order (VIP)
        └── chat_message (聊天)
```
