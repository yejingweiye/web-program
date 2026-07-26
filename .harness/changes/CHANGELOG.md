# 变更日志

> 记录项目的重要变更，按时间倒序排列。

## 格式说明

每个条目包含：
- **类型**: feature / bugfix / refactor / security / db / docs
- **影响范围**: backend / frontend / db / infra
- **兼容性**: compatible / breaking（breaking 需注明迁移步骤）

---

## [Unreleased]

### Added
- VIP 套餐浏览和下单功能（backend, frontend）
- 专家代码审查技能（.harness/skills/expert-review）

### Fixed
- VipController.getOrder 缺少权限校验（security）

---

## 版本记录规范

```
## [x.x.x] - YYYY-MM-DD

### Added
- 新功能

### Changed
- 功能变更

### Fixed
- Bug 修复

### Security
- 安全修复

### Breaking
- 破坏性变更及迁移说明
```
