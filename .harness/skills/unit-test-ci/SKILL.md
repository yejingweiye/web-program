---
name: unit-test-ci
description: CI 环境下的单元测试执行与配置管理技能，确保测试在自动化流水线中可靠运行
metadata:
  type: skill
---

# Unit Test CI

你是一位 CI 流水线工程师，负责配置和维护项目在 CI 环境中的单元测试执行。

## 项目配置

### 后端（Maven）
```bash
# 运行全部测试
JAVA_HOME=/usr/local/Cellar/openjdk@17/17.0.19/libexec/openjdk.jdk/Contents/Home mvn test

# 跳过测试打包
mvn package -DskipTests

# 运行指定测试类
mvn test -Dtest=VipServiceTest
```

### 前端（Vite/Vitest）
```bash
cd dazi-community-frontend
npm test          # 运行测试
npm run coverage  # 覆盖率报告
```

## CI 规范

### 1. 测试触发条件
- `push` 到 `main`/`develop` 分支：全量测试
- PR 提交/更新：增量测试（仅测试改动涉及模块）
- 定时任务：每日全量测试

### 2. 测试质量门禁
- 所有测试必须通过（FAIL 则流水线中断）
- 新增代码覆盖率不低于 80%（行覆盖）
- 不允许新增 `@Disabled` / `test.skip` 测试

### 3. 测试环境要求
- CI 环境应启动独立的测试数据库（如 H2 内存库或专用 MySQL 实例）
- 测试数据在每次运行前清理重建，不依赖执行顺序
- 前端测试使用 jsdom 或 happy-dom 模拟浏览器环境

### 4. 失败处理
- CI 测试失败时，截图/日志需完整保留
- Flaky 测试（偶发失败）需标记并记录，在 PR 通过前需有重试机制
- 超时测试（>30s）需要排查性能问题

### 5. 报告
- JUnit XML 格式的测试报告（用于 CI 平台展示）
- JaCoCo / Vitest 覆盖率报告归档
- 测试趋势与历史对比

## 常见问题排查

| 问题 | 排查方向 |
|------|---------|
| 本地通过 CI 失败 | 检查环境差异（JDK 版本、MySQL 时区、Node 版本） |
| 测试执行慢 | 检查是否缺少 `@Transactional` 导致数据未清理 |
| 随机失败 | 检查测试数据共享、线程安全问题 |
