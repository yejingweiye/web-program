# 认证与授权流程

## 认证方式：JWT Token

### 登录流程

```
用户 → POST /api/v1/auth/login {phone, code}
        │
        ▼
AuthController.login()
        │
        ▼
验证验证码 → 生成 JWT Token（含 userId）
        │
        ▼
返回 {token, userInfo}
```

- 测试环境：任意手机号 + 任意验证码（如 `13800138001` + `1234`）

### 请求鉴权流程

```
客户端请求
    │
    ▼
JwtInterceptor.preHandle()
    │
    ├─ OPTIONS → 直接放行 (CORS)
    │
    ├─ 无 Authorization header
    │   ├─ GET → 放行（公共浏览，但不设置 userId）
    │   └─ POST/PUT/DELETE → 返回 10001 未登录
    │
    └─ 有 Bearer token
        ├─ token 无效/过期 → 返回 10001 token失效
        └─ token 有效 → 解析 userId → request.setAttribute("userId", userId) → 放行
```

### 获取当前用户

Controller 中从 request attribute 获取：

```java
Long userId = (Long) request.getAttribute("userId");
```

## 实名认证体系

### 三级实名 (auth_type)

| 等级 | 值 | 说明 |
|------|----|------|
| 未实名 | 0 | 初始状态 |
| 手机实名 | 1 | 手机号注册即完成 |
| 人脸实名 | 2 | 上传身份证+人脸照，需管理员审核 |

### 人脸实名审核流程

```
用户 → POST /api/v1/auth/face-auth {realName, idCard, faceImg}
        │
        ▼
user_face_auth 表写入记录, auth_status = 0 (待审核)
        │
        ▼
管理员 → POST /api/v1/admin/face-auth/approve
        │
        ├─ 通过: sys_user.auth_type = 2, user_face_auth.auth_status = 1
        └─ 驳回: user_face_auth.auth_status = 2
```

## 权限控制规则

| 操作类型 | 控制方式 |
|---------|---------|
| 登录/注册 | 无需认证 |
| 浏览社区/帖子/活动 | GET 请求，无需登录 |
| 发帖/评论/报名 | POST 请求，需 JWT 认证 |
| 管理社区/圈子 | 需检查 `community_manager` 表 |
| 管理后台 | AdminController 内置管理校验 |
| 数据所有权 | Controller 层通过 userId 对比校验 |
