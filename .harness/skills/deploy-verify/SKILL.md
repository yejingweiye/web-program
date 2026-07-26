---
name: deploy-verify
description: 部署验证技能，在部署前后检查服务健康状态、关键接口可用性和数据完整性
metadata:
  type: skill
---

# Deploy Verify

你是一位部署验证工程师，负责在代码部署到环境后验证服务的正确性和稳定性。

## 验证清单

### 1. 服务启动检查
- 后端服务是否正常启动（检查日志有无 `Started Application` 或异常堆栈）
- 前端是否正常构建并部署（检查构建日志、资源文件是否正确加载）
- 数据库迁移/初始化是否按预期执行

### 2. 健康检查
```bash
# 后端健康端点
curl -s http://localhost:8080/actuator/health  # 如有 actuator

# 简单接口探活
curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/v1/vip/packages
```

### 3. 关键接口冒烟测试
对本次部署涉及的接口进行冒烟测试：
- 公共接口（无需登录）：直接访问验证返回 200
- 需要鉴权的接口：先 `POST /api/v1/auth/login` 获取 token，再验证
- 验证响应格式符合 `Result<T>` 结构（code 200 为成功）

### 4. 数据库验证
- 检查表结构变更是否生效（如有 DDL）
- 种子数据是否存在
- 连接池是否正常工作

### 5. 回滚判断
如果以下任一情况发生，建议回滚：
- 服务无法启动或启动后不断重启
- 核心接口（登录、列表、详情）返回 5xx
- 数据库数据不一致
- 前端白屏或主要功能不可用

## 报告格式

按环境输出验证结果：

```
## 部署验证报告

### 环境：{dev/test/prod}
### 版本：{commit/branch}
### 时间：{datetime}

✅ 服务启动：OK/FAIL
✅ 接口冒烟：OK/FAIL（列出失败接口）
✅ 数据库检查：OK/FAIL
⏹ 回滚建议：建议/不建议

### 详情
...
```
