# API 设计与安全规则

## 认证与鉴权

### JWT 认证机制

- 前端通过 `POST /api/v1/auth/login` 获取 JWT Token
- Token 放在 `Authorization: Bearer <token>` 请求头
- `JwtInterceptor` 自动解析 Token 并注入 `request.setAttribute("userId", userId)`
- Controller 通过 `(Long) request.getAttribute("userId")` 获取当前用户 ID

### 拦截规则

- **GET 请求**: JWT 拦截器放行（公共浏览），但特定用户接口仍需鉴权
- **POST/PUT/DELETE 请求**: 必须携带有效 Token
- OPTIONS 请求: 始终放行（CORS）

## 权限检查规则

### 数据所有权校验

涉及用户私有数据的接口必须做所有权校验：

```java
// 错误：A 用户可查 B 用户的订单
@GetMapping("/order/{orderId}")
public Result<VipOrder> getOrder(@PathVariable Long orderId) {
    return Result.success(vipService.getOrderDetail(orderId));
}

// 正确：必须校验当前用户与数据所有者一致
@GetMapping("/order/{orderId}")
public Result<VipOrder> getOrder(HttpServletRequest request, @PathVariable Long orderId) {
    Long userId = (Long) request.getAttribute("userId");
    VipOrder order = vipService.getOrderDetail(orderId);
    if (order != null && !order.getUserId().equals(userId)) {
        // 管理员可查看全部，普通用户只能看自己的
    }
    return Result.success(order);
}
```

### 需要权限检查的场景

| 场景 | 检查方式 |
|------|---------|
| 查看自己的信息 | `userId == requestAttribute.userId` |
| 社区/圈子管理操作 | 检查 `community_manager` 表 |
| 管理员操作 | 通过 AdminController（需额外鉴权） |

## 安全注意事项

### 数据安全
- 密码不在日志中打印
- 手机号等敏感信息不在前端响应中明文暴露
- 用户输入必须在后端校验（前端校验是辅助）

### SQL 安全
- 使用 MyBatis-Plus 的 `LambdaQueryWrapper`，避免 `${}` SQL 拼接
- 动态排序字段使用白名单校验

### XSS / CSRF
- 用户展示型字段（昵称、签名）需转义 HTML 特殊字符
- API 设计为 stateless（Token 认证），无 CSRF 风险
