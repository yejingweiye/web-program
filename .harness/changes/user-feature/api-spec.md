# 用户功能 API 规格

## 注册

```
POST /api/v1/auth/register
```

**请求体：**
```json
{
  "phone": "13800138001",
  "code": "1234",
  "nickname": "小明",
  "gender": 1,
  "ageRange": "25-34",
  "city": "北京"
}
```

**响应：**
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "user": {
      "id": 1,
      "nickname": "小明",
      "phone": "138****8001",
      "gender": 1,
      "city": "北京",
      "authType": 1,
      "isVip": 0
    }
  }
}
```

## 注销账号

```
POST /api/v1/auth/revoke
```

**请求头:** `Authorization: Bearer <token>`

**响应：**
```json
{
  "code": 200,
  "msg": "已提交注销申请，7天内可登录取消注销",
  "data": {
    "revokeTime": "2026-07-16T10:00:00",
    "expireTime": "2026-07-23T10:00:00"
  }
}
```

## 取消注销

```
POST /api/v1/auth/revoke/cancel
```

**请求头:** `Authorization: Bearer <token>`

**响应：**
```json
{
  "code": 200,
  "msg": "已取消注销",
  "data": null
}
```

## 黑名单列表

```
GET /api/v1/user/blacklist?page=1&size=20
```

**请求头:** `Authorization: Bearer <token>`

**响应：**
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "records": [
      {
        "id": 1,
        "targetUserId": 2,
        "nickname": "用户A",
        "avatar": "https://...",
        "createTime": "2026-07-15T12:00:00"
      }
    ],
    "total": 1,
    "page": 1,
    "size": 20
  }
}
```

## 添加黑名单

```
POST /api/v1/user/blacklist/{targetUserId}
```

**请求头:** `Authorization: Bearer <token>`

**响应：**
```json
{
  "code": 200,
  "msg": "已拉黑",
  "data": null
}
```

## 移除黑名单

```
DELETE /api/v1/user/blacklist/{targetUserId}
```

**请求头:** `Authorization: Bearer <token>`

**响应：**
```json
{
  "code": 200,
  "msg": "已移除黑名单",
  "data": null
}
```

## 修改手机号

```
PUT /api/v1/user/phone
```

**请求头:** `Authorization: Bearer <token>`

**请求体：**
```json
{
  "oldPhone": "13800138001",
  "oldCode": "5678",
  "newPhone": "13900139001",
  "newCode": "9012"
}
```

**响应：**
```json
{
  "code": 200,
  "msg": "手机号修改成功",
  "data": null
}
```

## 用户主页

```
GET /api/v1/user/home/{userId}
```

**响应：**
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "user": {
      "id": 1,
      "nickname": "小明",
      "avatar": "https://...",
      "city": "北京",
      "authType": 1,
      "isVip": 1,
      "tags": ["运动", "桌游"]
    },
    "postCount": 12,
    "activityCount": 3
  }
}
```

## 登录日志

```
GET /api/v1/user/login-log?page=1&size=10
```

**请求头:** `Authorization: Bearer <token>`

**响应：**
```json
{
  "code": 200,
  "msg": "success",
  "data": {
    "records": [
      {
        "ip": "192.168.1.1",
        "deviceInfo": "iPhone 15 Pro / iOS 18",
        "loginTime": "2026-07-16T09:00:00"
      }
    ]
  }
}
```
