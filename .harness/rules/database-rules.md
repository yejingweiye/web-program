# 数据库规则

## 通用规范

- **数据库**: MySQL 8.0, InnoDB 引擎
- **字符集**: `utf8mb4` + `utf8mb4_unicode_ci`
- **主键**: BIGINT AUTO_INCREMENT（MyBatis-Plus 自增）
- **时间字段**: DATETIME, 默认 `CURRENT_TIMESTAMP`
- **软删除**: 所有表包含 `delete_flag TINYINT DEFAULT 0`
- **审计字段**: 所有表包含 `create_time`, `update_time`

## 命名规范

| 对象 | 规范 | 示例 |
|------|------|------|
| 表名 | `snake_case`, 名词单数 | `sys_user`, `post_info`, `vip_order` |
| 列名 | `snake_case` | `pay_status`, `delete_flag`, `vip_expire_time` |
| 索引 | `idx_字段名` | `idx_user_id`, `idx_phone` |

## 保留字注意

- **禁止**使用 `desc` 作为列名（MySQL 保留字），使用 `description` 替代

## MyBatis-Plus 特性

### 逻辑删除
```java
@TableLogic
private Integer deleteFlag;
```
自动在 SELECT/UPDATE/DELETE 中追加 `WHERE delete_flag=0`

### 自动填充
```java
@TableField(fill = FieldFill.INSERT)
private LocalDateTime createTime;

@TableField(fill = FieldFill.INSERT_UPDATE)
private LocalDateTime updateTime;
```

### 查询包装器
- 优先使用 `LambdaQueryWrapper`（类型安全，防 SQL 注入）
- 连表查询使用注解 `@TableName` + 关联查询在 XML 中编写

## 表关系概览

```
sys_user ──┬── user_face_auth       (1:1)
           ├── community_manager    (1:N) 用户管理的社区
           ├── community_member     (1:N) 用户加入的社区
           ├── circle_member        (1:N) 用户加入的圈子
           ├── post_info            (1:N) 用户的帖子
           ├── post_comment         (1:N) 用户的评论
           ├── post_like            (1:N) 用户的点赞
           ├── activity_order       (1:N) 用户的活动报名
           ├── vip_order            (1:N) 用户的VIP订单
           ├── chat_message         (1:N) 用户的消息
           └── report_info          (1:N) 用户的举报

community_first ──┬── community_second (1:N)
                  └── (固定6个分类)

community_second ──┬── circle_info       (1:N)
                   ├── community_member  (1:N)
                   └── community_manager (1:N)

circle_info ──┬── circle_member (1:N)
              └── post_info     (1:N) 圈子内的帖子

post_info ──┬── post_comment (1:N)
            ├── post_like    (1:N)
            └── activity_info (1:N) 帖子关联的活动
```
