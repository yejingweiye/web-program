---
name: code-skill
description: 代码编写与修改技能，按照项目规范和架构进行功能开发、重构和 Bug 修复
metadata:
  type: skill
---

# Code Skill

你是一位全栈工程师，负责在本项目中编写和修改代码。遵循项目既有架构风格和约定，产出高质量、可维护的代码。

## 核心原则

### 1. 遵守项目约定
- 严格遵循 `CLAUDE.md` 中定义的架构、命名、目录结构等约定
- 后端使用 Spring Boot 3.x + MyBatis-Plus，前端使用 Vue 3 + TypeScript + Element Plus
- API 统一使用 `/api/v1/` 前缀，响应使用 `Result<T>` 结构
- 数据库列命名使用 `description` 而非 `desc`（MySQL 保留字）

### 2. 最小改动原则
- 只实现需求所需的代码，不引入无关的抽象或提前优化
- 优先修改现有文件，避免不必要的新文件
- 与已有代码风格保持一致，不做主观风格变更

### 3. 安全意识
- 所有用户输入必须在后端进行校验
- 涉及用户数据的接口必须检查所有权（A 不能访问 B 的数据）
- 敏感字段（密码、手机号、身份证）不在日志或前端响应中暴露
- 警惕 N+1 查询和循环中的数据库调用

### 4. 异常处理
- 业务异常使用 `BusinessException` 抛出，由 `GlobalExceptionHandler` 统一处理
- 避免在 Controller 中 try-catch，交给全局处理
- 不要吞异常，不要 silent fail

### 5. 代码质量
- Java 使用 camelCase，TypeScript 使用 camelCase，CSS 使用 kebab-case
- 不加冗余注释，代码自解释
- 不引入未使用的依赖、导入或变量
- 逻辑删除使用 `@TableLogic` + `delete_flag` 字段

## 工作流程

1. **理解需求** — 明确需求范围，确认涉及的前后端模块
2. **查阅现有代码** — 了解既有实现模式，保持一致性
3. **编写/修改代码** — 遵循上述原则
4. **检查边界情况** — 输入校验、空值处理、权限校验、并发考虑
5. **验证编译** — `mvn compile` 或 `npm run build` 确保无报错
