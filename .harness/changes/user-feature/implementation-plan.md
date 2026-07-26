# 用户功能实现计划

## 优先级排序

按依赖关系和业务价值排序：

## Phase 1: 注册流程完善（3天）

### D1 - 后端
- [ ] `AuthController.register()` — 注册接口
- [ ] `AuthService.register()` — 注册逻辑（校验验证码、创建用户）
- [ ] 验证码存储改用 Redis（当前为内存 Map，生产需改为 Redis）

### D2-D3 - 前端
- [ ] `Register.vue` — 注册页组件
- [ ] 完善 `auth.ts` API 层
- [ ] 注册完自动跳转主页

## Phase 2: 黑名单功能（2天）

### D4 - 后端
- [ ] 创建 `user_blacklist` 表
- [ ] `UserBlacklistMapper` + `UserBlacklistService`
- [ ] CRUD 接口：增删查
- [ ] 内容过滤逻辑：帖子/评论列表查询时排除黑名单用户

### D5 - 前端
- [ ] `Blacklist.vue` — 黑名单管理页面
- [ ] 用户主页添加"拉黑"按钮
- [ ] 帖子/评论列表过滤黑名单用户

## Phase 3: 用户主页（2天）

### D6 - 后端
- [ ] `UserController.getUserHome()` — 聚合用户信息和内容
- [ ] 帖子/活动/评论的按用户查询接口

### D7 - 前端
- [ ] `UserHome.vue` — 用户主页组件
- [ ] Tab 切换：帖子 / 活动 / 评论
- [ ] 实名等级和 VIP 标识展示

## Phase 4: 账号管理与安全设置（3天）

### D8 - 后端
- [ ] `AuthController.revoke()` / `revokeCancel()` — 注销相关
- [ ] `UserController.updatePhone()` — 换绑手机
- [ ] `UserController.getLoginLog()` — 登录日志
- [ ] `user_login_log` 表 + Mapper
- [ ] sys_user 表扩展字段迁移

### D9-D10 - 前端
- [ ] `Settings.vue` — 设置页（注销入口、改绑手机、登录日志）
- [ ] `PhoneChange.vue` — 换绑手机页
- [ ] Revoke 确认弹窗 + 倒计时提示

## 数据库迁移顺序

```
1. 新增 user_blacklist 表
2. 新增 user_login_log 表
3. ALTER sys_user 添加扩展字段
```

## 风险评估

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| 验证码方案临时 | 重启丢失 | Phase 1 即引入 Redis |
| 注销后数据恢复 | 法律合规 | 7 天冷静期 + 用户确认 |
| 黑名单数据量大 | 查询性能 | user_id 索引 + 分页 |
