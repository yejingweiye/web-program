# Vue3 / TypeScript 前端编码规则

## 项目基础

- **框架**: Vue 3 + Vite + TypeScript + Element Plus
- **路由**: Hash 模式 (`createWebHashHistory`), 懒加载
- **状态管理**: Pinia
- **HTTP**: Axios（封装在 `src/utils/request.ts`）
- **Token**: localStorage 存储（`src/utils/token.ts`）

## 目录结构

```
src/
├── api/          # API 调用模块（每个后端 Controller 对应一个）
├── assets/       # 静态资源、CSS
├── components/   # 通用组件
├── hooks/        # 组合式函数
├── router/       # 路由配置
├── stores/       # Pinia 状态
├── types/        # TypeScript 类型定义
├── utils/        # 工具函数
└── views/        # 页面组件
```

## 命名规范

- `.vue` 文件: `PascalCase`（如 `UserProfile.vue`）
- `.ts` 文件: `camelCase` 或 `kebab-case`
- 组件名: 多词组合避免 HTML 冲突（如 `UserAvatar`）
- CSS 类名: `kebab-case`
- CSS 变量: `--kebab-case`（主题色 `--primary: #6366f1`）

## API 层规范

- 每个后端 Controller 对应一个 `src/api/xxx.ts` 文件
- 方法返回 Promise 类型
- 统一使用 `request` 实例（自动附加 Authorization header）

```typescript
// src/api/vip.ts
import request from '@/utils/request'

export function getPackages() {
  return request.get('/vip/packages')
}
```

## 路由规范

- 使用 `createWebHashHistory`（hash 路由）
- 组件懒加载：`() => import('@/views/Xxx.vue')`
- 需要登录的路由添加 `meta: { requiresAuth: true }`

## 组件规范

- 使用 `<script setup lang="ts">` 语法
- Props 和 Emits 使用 `defineProps` / `defineEmits` 并定义类型
- 样式使用 `<style scoped>` 避免污染
- 复杂组件拆分原子组件

## 状态管理

- 全局状态使用 Pinia Store
- 组件内状态使用 `ref` / `reactive`
- 派生状态使用 `computed`

## 样式

- 设计 Token 通过 CSS 自定义属性定义在 `src/assets/style.css`
- 主色调 Indigo: `--primary: #6366f1`
- 组件样式在 `<style scoped>` 中编写
