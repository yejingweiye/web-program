# 数据库关系参考

## 表总览（25 张表）

### 用户相关
| 表名 | 说明 | 核心字段 |
|------|------|---------|
| `sys_user` | 用户主表 | `phone`, `auth_type`, `is_vip`, `vip_expire_time` |
| `user_face_auth` | 人脸实名 | `user_id`, `real_name`, `id_card`, `auth_status` |

### 社区相关
| 表名 | 说明 | 核心字段 |
|------|------|---------|
| `community_first` | 一级社区（固定 6 个分类） | `name`, `sort_order` |
| `community_second` | 二级社区（用户创建） | `first_id`, `name`, `icon` |
| `community_manager` | 社区管理员 | `user_id`, `community_id` |
| `community_member` | 社区成员 | `user_id`, `community_id`, `role` |
| `community_join_apply` | 入社申请 | `user_id`, `community_id`, `status` |

### 圈子相关
| 表名 | 说明 | 核心字段 |
|------|------|---------|
| `circle_info` | 圈子信息 | `second_id`, `name`, `type`(私密/公开) |
| `circle_member` | 圈子成员 | `circle_id`, `user_id`, `role` |
| `circle_invite` | 圈子邀请 | `circle_id`, `inviter_id`, `invitee_id` |

### 内容相关
| 表名 | 说明 | 核心字段 |
|------|------|---------|
| `post_info` | 帖子 | `user_id`, `second_id`, `circle_id`, `title`, `content` |
| `post_comment` | 评论 | `post_id`, `user_id`, `content`, `parent_id` |
| `post_like` | 点赞 | `post_id`, `user_id` |

### 活动相关
| 表名 | 说明 | 核心字段 |
|------|------|---------|
| `activity_info` | 活动 | `post_id`, `max_people`, `start_time`, `status` |
| `activity_order` | 报名记录 | `activity_id`, `user_id`, `status` |

### VIP 相关
| 表名 | 说明 | 核心字段 |
|------|------|---------|
| `vip_package` | VIP 套餐 | `name`, `type`, `price`, `days` |
| `vip_order` | VIP 订单 | `user_id`, `package_id`, `pay_price`, `pay_status`, `expire_time` |

### 其他
| 表名 | 说明 | 核心字段 |
|------|------|---------|
| `chat_message` | 聊天消息 | `from_id`, `to_id`, `content`, `msg_type` |
| `report_info` | 举报 | `reporter_id`, `target_type`, `target_id`, `reason` |
| `shop_info` | 商家 | `name`, `contact`, `status` |
| `shop_ad` | 广告位 | `shop_id`, `image`, `url` |
| `top_order` | 置顶订单 | `target_type`, `target_id`, `expire_time` |
| `manager_income_log` | 收入日志 | `manager_id`, `amount`, `type` |
| `sys_config` | 系统配置 | `config_key`, `config_value` |
| `tool_pay_order` | 工具支付订单 | `user_id`, `amount`, `status` |

## 核心数据流

### 社区三级模型

```
community_first (固定 6 大类)
    │
    ▼
community_second (用户创建的子社区)
    │
    ├── circle_info (私密/公开圈子)
    ├── post_info (帖子)
    └── community_member (社区成员)
```

### VIP 购买流程

```
vip_package (套餐列表)
    │
    ▼
vip_order (用户下单 → 支付)
    │
    ▼
sys_user.is_vip = 1, sys_user.vip_expire_time = 订单过期时间
```
