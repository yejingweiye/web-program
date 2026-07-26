# 系统架构概览

## 整体架构

```
┌─────────────────────────────────────────────────────┐
│                   Frontend (Vue 3)                   │
│          Port 5173 (Dev) / Vite Proxy                │
├─────────────────────────────────────────────────────┤
│                    Nginx / Vite Proxy                │
│              /api → localhost:8080                   │
│              /ws → ws://localhost:8080               │
├─────────────────────────────────────────────────────┤
│              Backend (Spring Boot 3.x)               │
│                  Port 8080                           │
├─────────────────────────────────────────────────────┤
│                    MySQL 8.0                         │
│              Docker: mysql-dazi-community            │
│                    Port 3306                         │
└─────────────────────────────────────────────────────┘
```

## 后端分层

```
Controller (接收请求/返回响应)
    │
Service (业务接口契约)
    │
ServiceImpl (业务逻辑实现)
    │
Mapper (MyBatis-Plus, 数据访问)
    │
MySQL (数据存储)
```

### 各层职责

| 层 | 职责 | 示例 |
|----|------|------|
| Controller | 参数校验、调用 Service、返回 Result | `VipController` |
| Service | 定义接口方法 | `VipService` |
| ServiceImpl | 实现业务逻辑、事务管理 | `VipServiceImpl` |
| Mapper | 继承 `BaseMapper`，数据库 CRUD | `VipOrderMapper` |
| Entity (PO) | 数据库表映射，`@TableName` + `@Data` | `VipOrder.java` |

## 前端结构

```
src/api/         ← HTTP 请求封装，对应后端 Controller
src/router/      ← 路由配置 (Hash 模式)
src/stores/      ← Pinia 状态管理
src/views/       ← 页面级组件
src/components/  ← 可复用组件
src/utils/       ← 工具函数 (request, token 等)
src/hooks/       ← 组合式 API 函数
src/assets/      ← 样式/图片/静态资源
```

## 核心模块

| 模块 | 功能 |
|------|------|
| 用户 | 注册/登录、实名认证（手机/人脸）、信息管理 |
| 社区 | 一级分类（6个固定）、二级社区（用户创建）、社区管理 |
| 圈子 | 私密/公开圈子、圈子成员管理 |
| 帖子和评论 | 发帖、评论、点赞 |
| 活动 | 活动发布、报名、审核 |
| VIP | VIP 套餐、订单购买 |
| 聊天 | WebSocket 实时消息 |
| 举报 | 内容举报与处理 |
| 管理后台 | 全局配置、数据统计、审核管理 |
| 广告 | 商家入驻、广告投放 |
