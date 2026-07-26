# 用户功能模块设计

## 整体架构

```
┌──────────────┐     ┌────────────────┐     ┌──────────────┐
│  前端页面     │────▶│  API 层        │────▶│  后端服务     │
│  Login.vue   │     │  auth.ts       │     │  AuthService  │
│  Profile.vue │     │  user.ts       │     │  UserService  │
│  Settings.vue│     │  user.ts       │     │  UserService  │
└──────────────┘     └────────────────┘     └──────────────┘
                                                    │
                                                    ▼
                                              ┌──────────────┐
                                              │  Mapper/DB    │
                                              │  sys_user 表  │
                                              │  user_black   │
                                              └──────────────┘
```

## 数据库设计

### 新增表：user_blacklist（用户黑名单）

```sql
CREATE TABLE IF NOT EXISTS user_blacklist (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    target_user_id BIGINT NOT NULL COMMENT '被拉黑用户ID',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_target (user_id, target_user_id),
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户黑名单';
```

### 新增表：user_login_log（登录日志）

```sql
CREATE TABLE IF NOT EXISTS user_login_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    ip VARCHAR(45) DEFAULT '' COMMENT '登录IP',
    device_info VARCHAR(500) DEFAULT '' COMMENT '设备信息',
    login_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '登录时间',
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='登录日志';
```

### sys_user 表扩展字段

```sql
ALTER TABLE sys_user
    ADD COLUMN register_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间' AFTER vip_expire_time,
    ADD COLUMN last_login_time DATETIME DEFAULT NULL COMMENT '最后登录时间' AFTER register_time,
    ADD COLUMN device_id VARCHAR(100) DEFAULT '' COMMENT '设备ID' AFTER last_login_time;
```

## 后端接口

### 新增接口

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/v1/auth/register` | 注册 |
| POST | `/api/v1/auth/revoke` | 申请注销 |
| POST | `/api/v1/auth/revoke/cancel` | 取消注销 |
| GET | `/api/v1/user/blacklist` | 黑名单列表 |
| POST | `/api/v1/user/blacklist/{targetUserId}` | 添加黑名单 |
| DELETE | `/api/v1/user/blacklist/{targetUserId}` | 移除黑名单 |
| PUT | `/api/v1/user/phone` | 修改手机号 |
| GET | `/api/v1/user/login-log` | 登录日志 |

### 修改接口

| 方法 | 路径 | 变更内容 |
|------|------|---------|
| PUT | `/api/v1/user/profile` | 增加 `tags`、`freeTime` 等字段支持 |

## 前端新增页面

| 路径 | 组件 | 说明 |
|------|------|------|
| `/register` | Register.vue | 注册页 |
| `/user/settings` | Settings.vue | 设置页 |
| `/user/settings/phone` | PhoneChange.vue | 换绑手机 |
| `/user/blacklist` | Blacklist.vue | 黑名单管理 |
| `/user/:id` | UserHome.vue | 他人主页 |
