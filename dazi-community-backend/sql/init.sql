-- ============================================================
-- 同城分层社区搭子平台 - 数据库初始化脚本
-- 数据库: dazi_community
-- 字符集: utf8mb4
-- ============================================================

CREATE DATABASE IF NOT EXISTS dazi_community DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dazi_community;

-- ============================================================
-- 3.1 用户相关表
-- ============================================================

-- 用户主表
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    nickname VARCHAR(50) NOT NULL DEFAULT '' COMMENT '昵称',
    avatar VARCHAR(500) DEFAULT '' COMMENT '头像URL',
    phone VARCHAR(20) NOT NULL DEFAULT '' COMMENT '手机号(加密存储)',
    city VARCHAR(50) DEFAULT '' COMMENT '城市',
    age INT DEFAULT 0 COMMENT '年龄',
    gender TINYINT DEFAULT 0 COMMENT '性别 0未知 1男 2女',
    free_time VARCHAR(200) DEFAULT '' COMMENT '空闲时间段',
    budget DECIMAL(10,2) DEFAULT 0.00 COMMENT '消费预算',
    tags VARCHAR(500) DEFAULT '' COMMENT '搭子标签(逗号分隔)',
    auth_type TINYINT DEFAULT 0 COMMENT '实名类型 0未实名 1手机实名 2人脸实名',
    status TINYINT DEFAULT 0 COMMENT '账号状态 0正常 1禁言 2封禁',
    is_vip TINYINT DEFAULT 0 COMMENT '是否会员 0否 1是',
    vip_expire_time DATETIME DEFAULT NULL COMMENT '会员过期时间',
    delete_flag TINYINT DEFAULT 0 COMMENT '逻辑删除 0未删 1已删',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_phone (phone),
    INDEX idx_city (city),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户主表';

-- 人脸实名表
CREATE TABLE IF NOT EXISTS user_face_auth (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    real_name VARCHAR(50) NOT NULL DEFAULT '' COMMENT '真实姓名',
    id_card VARCHAR(20) NOT NULL DEFAULT '' COMMENT '身份证号',
    face_img VARCHAR(500) DEFAULT '' COMMENT '人脸图片URL',
    auth_status TINYINT DEFAULT 0 COMMENT '审核状态 0待审 1通过 2驳回',
    auth_time DATETIME DEFAULT NULL COMMENT '审核时间',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='人脸实名表';

-- ============================================================
-- 3.2 社区分层表
-- ============================================================

-- 一级官方社区
CREATE TABLE IF NOT EXISTS community_first (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    name VARCHAR(50) NOT NULL COMMENT '社区名称',
    icon VARCHAR(500) DEFAULT '' COMMENT '图标',
    sort INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态 0禁用 1启用',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='一级官方社区';

-- 二级细分社区
CREATE TABLE IF NOT EXISTS community_second (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    first_id BIGINT NOT NULL COMMENT '所属一级社区ID',
    name VARCHAR(100) NOT NULL COMMENT '社区名称',
    city VARCHAR(50) DEFAULT '' COMMENT '城市',
    description VARCHAR(500) DEFAULT '' COMMENT '社区描述',
    join_type TINYINT DEFAULT 0 COMMENT '准入模式 0自由进入 1管理员审核',
    create_user_id BIGINT NOT NULL COMMENT '创建人用户ID',
    status TINYINT DEFAULT 1 COMMENT '状态 0禁用 1启用',
    member_count INT DEFAULT 0 COMMENT '成员数',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_first_id (first_id),
    INDEX idx_create_user (create_user_id),
    INDEX idx_city (city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='二级细分社区';

-- 社区管理员表
CREATE TABLE IF NOT EXISTS community_manager (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    community_id BIGINT NOT NULL COMMENT '社区ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role TINYINT DEFAULT 2 COMMENT '角色 1主管理员 2副管理员',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_community (community_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区管理员表';

-- 社区入群申请表
CREATE TABLE IF NOT EXISTS community_join_apply (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    community_id BIGINT NOT NULL COMMENT '社区ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    apply_reason VARCHAR(500) DEFAULT '' COMMENT '申请理由',
    free_time VARCHAR(200) DEFAULT '' COMMENT '空闲时间',
    status TINYINT DEFAULT 0 COMMENT '状态 0待审 1通过 2拒绝',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_community (community_id),
    INDEX idx_user (user_id),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区入群申请表';

-- 社区成员表
CREATE TABLE IF NOT EXISTS community_member (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    community_id BIGINT NOT NULL COMMENT '社区ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    join_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_community (community_id),
    INDEX idx_user (user_id),
    UNIQUE KEY uk_community_user (community_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区成员表';

-- ============================================================
-- 3.3 私密圈子表
-- ============================================================

-- 圈子主表
CREATE TABLE IF NOT EXISTS circle_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    community_id BIGINT NOT NULL COMMENT '所属社区ID',
    name VARCHAR(100) NOT NULL COMMENT '圈子名称',
    type TINYINT DEFAULT 0 COMMENT '类型 0公开 1私密',
    max_num INT DEFAULT 6 COMMENT '最大人数',
    create_user_id BIGINT NOT NULL COMMENT '创建人用户ID',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_community (community_id),
    INDEX idx_create_user (create_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='圈子主表';

-- 圈子成员表
CREATE TABLE IF NOT EXISTS circle_member (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    circle_id BIGINT NOT NULL COMMENT '圈子ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    join_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_circle (circle_id),
    INDEX idx_user (user_id),
    UNIQUE KEY uk_circle_user (circle_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='圈子成员表';

-- 圈子邀请链接表
CREATE TABLE IF NOT EXISTS circle_invite (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    circle_id BIGINT NOT NULL COMMENT '圈子ID',
    invite_code VARCHAR(64) NOT NULL COMMENT '邀请码',
    expire_time DATETIME DEFAULT NULL COMMENT '过期时间',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_circle (circle_id),
    INDEX idx_code (invite_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='圈子邀请链接表';

-- ============================================================
-- 3.4 帖子、活动、订单表
-- ============================================================

-- 搭子帖子表
CREATE TABLE IF NOT EXISTS post_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    community_id BIGINT NOT NULL COMMENT '社区ID',
    user_id BIGINT NOT NULL COMMENT '发布人用户ID',
    title VARCHAR(200) NOT NULL COMMENT '标题',
    content TEXT COMMENT '内容',
    img_list VARCHAR(2000) DEFAULT '' COMMENT '图片列表(JSON数组)',
    city VARCHAR(50) DEFAULT '' COMMENT '城市',
    address VARCHAR(200) DEFAULT '' COMMENT '地址',
    start_time DATETIME DEFAULT NULL COMMENT '活动时间',
    budget DECIMAL(10,2) DEFAULT 0.00 COMMENT '预算',
    people_num INT DEFAULT 1 COMMENT '期望人数',
    tags VARCHAR(200) DEFAULT '' COMMENT '标签',
    scope TINYINT DEFAULT 0 COMMENT '可见范围 0社区内 1全站公开',
    status TINYINT DEFAULT 0 COMMENT '状态 0正常 1违规隐藏 2已删除',
    is_top TINYINT DEFAULT 0 COMMENT '是否置顶 0否 1是',
    top_expire_time DATETIME DEFAULT NULL COMMENT '置顶过期时间',
    view_count INT DEFAULT 0 COMMENT '浏览数',
    like_count INT DEFAULT 0 COMMENT '点赞数',
    comment_count INT DEFAULT 0 COMMENT '评论数',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_community (community_id),
    INDEX idx_user (user_id),
    INDEX idx_city (city),
    INDEX idx_create_time (create_time),
    INDEX idx_top (is_top, top_expire_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='搭子帖子表';

-- 帖子评论表
CREATE TABLE IF NOT EXISTS post_comment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    post_id BIGINT NOT NULL COMMENT '帖子ID',
    user_id BIGINT NOT NULL COMMENT '评论人ID',
    content VARCHAR(1000) NOT NULL COMMENT '评论内容',
    parent_id BIGINT DEFAULT 0 COMMENT '父评论ID',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_post (post_id),
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子评论表';

-- 帖子点赞表
CREATE TABLE IF NOT EXISTS post_like (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    post_id BIGINT NOT NULL COMMENT '帖子ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_post_user (post_id, user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子点赞表';

-- 活动表
CREATE TABLE IF NOT EXISTS activity_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    community_id BIGINT NOT NULL COMMENT '社区ID',
    user_id BIGINT NOT NULL COMMENT '发起人用户ID',
    title VARCHAR(200) NOT NULL COMMENT '活动标题',
    content TEXT COMMENT '活动内容',
    address VARCHAR(200) DEFAULT '' COMMENT '活动地址',
    start_time DATETIME DEFAULT NULL COMMENT '开始时间',
    end_time DATETIME DEFAULT NULL COMMENT '结束时间',
    max_people INT DEFAULT 0 COMMENT '最大参与人数',
    fee DECIMAL(10,2) DEFAULT 0.00 COMMENT '费用',
    status TINYINT DEFAULT 0 COMMENT '状态 0正常 1已取消 2已结束',
    audit_status TINYINT DEFAULT 0 COMMENT '审核状态 0待审核 1通过 2驳回',
    service_rate DECIMAL(5,2) DEFAULT 5.00 COMMENT '服务费抽成比例(%)',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_community (community_id),
    INDEX idx_user (user_id),
    INDEX idx_audit (audit_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='活动表';

-- 活动报名订单
CREATE TABLE IF NOT EXISTS activity_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    activity_id BIGINT NOT NULL COMMENT '活动ID',
    user_id BIGINT NOT NULL COMMENT '报名用户ID',
    pay_price DECIMAL(10,2) DEFAULT 0.00 COMMENT '支付金额',
    service_fee DECIMAL(10,2) DEFAULT 0.00 COMMENT '服务费',
    pay_status TINYINT DEFAULT 0 COMMENT '支付状态 0未支付 1已支付 2已退款 3支付失败',
    transaction_id VARCHAR(100) DEFAULT '' COMMENT '交易流水号',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_activity (activity_id),
    INDEX idx_user (user_id),
    INDEX idx_pay_status (pay_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='活动报名订单';

-- 帖子置顶订单表
CREATE TABLE IF NOT EXISTS top_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    post_id BIGINT NOT NULL COMMENT '帖子ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    top_type TINYINT DEFAULT 0 COMMENT '置顶类型 0社区置顶 1全站置顶',
    price DECIMAL(10,2) DEFAULT 0.00 COMMENT '价格',
    hours INT DEFAULT 24 COMMENT '置顶时长(小时)',
    platform_rate DECIMAL(5,2) DEFAULT 60.00 COMMENT '平台分成比例(%)',
    manager_rate DECIMAL(5,2) DEFAULT 40.00 COMMENT '管理员分成比例(%)',
    manager_user_id BIGINT DEFAULT NULL COMMENT '管理员用户ID',
    pay_status TINYINT DEFAULT 0 COMMENT '支付状态 0未支付 1已支付 2已退款',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_post (post_id),
    INDEX idx_user (user_id),
    INDEX idx_manager (manager_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子置顶订单';

-- ============================================================
-- 3.5 会员、增值付费表
-- ============================================================

-- 会员套餐配置
CREATE TABLE IF NOT EXISTS vip_package (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    name VARCHAR(50) NOT NULL COMMENT '套餐名称',
    type TINYINT NOT NULL COMMENT '类型 0白银 1黄金',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    days INT NOT NULL COMMENT '有效天数',
    description VARCHAR(500) DEFAULT '' COMMENT '权益描述',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员套餐配置';

-- 会员订单
CREATE TABLE IF NOT EXISTS vip_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    package_id BIGINT NOT NULL COMMENT '套餐ID',
    pay_price DECIMAL(10,2) NOT NULL COMMENT '支付金额',
    pay_status TINYINT DEFAULT 0 COMMENT '支付状态 0未支付 1已支付 2已退款',
    expire_time DATETIME DEFAULT NULL COMMENT '会员过期时间',
    transaction_id VARCHAR(100) DEFAULT '' COMMENT '交易流水号',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user (user_id),
    INDEX idx_pay_status (pay_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员订单';

-- 工具付费订单
CREATE TABLE IF NOT EXISTS tool_pay_order (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    tool_type TINYINT NOT NULL COMMENT '工具类型 1人脸核验 2圈子扩容 3保险',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    pay_status TINYINT DEFAULT 0 COMMENT '支付状态',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工具付费订单';

-- ============================================================
-- 3.6 聊天、举报、商家表
-- ============================================================

-- 聊天消息表
CREATE TABLE IF NOT EXISTS chat_message (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    from_user_id BIGINT NOT NULL COMMENT '发送人',
    to_user_id BIGINT DEFAULT NULL COMMENT '接收人(私聊)',
    circle_id BIGINT DEFAULT NULL COMMENT '圈子ID(群聊)',
    msg_type VARCHAR(20) DEFAULT 'text' COMMENT '消息类型 text/image/file',
    content TEXT COMMENT '消息内容',
    status TINYINT DEFAULT 0 COMMENT '状态 0未读 1已读',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_from_user (from_user_id),
    INDEX idx_to_user (to_user_id),
    INDEX idx_circle (circle_id),
    INDEX idx_create_time (create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聊天消息表';

-- 举报表
CREATE TABLE IF NOT EXISTS report_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    report_user_id BIGINT NOT NULL COMMENT '举报人ID',
    target_type TINYINT NOT NULL COMMENT '举报类型 1帖子 2用户 3评论 4活动',
    target_id BIGINT NOT NULL COMMENT '举报目标ID',
    reason VARCHAR(500) DEFAULT '' COMMENT '举报原因',
    status TINYINT DEFAULT 0 COMMENT '处理状态 0待处理 1已处理 2已驳回',
    handle_user_id BIGINT DEFAULT NULL COMMENT '处理人ID',
    handle_result VARCHAR(500) DEFAULT '' COMMENT '处理结果',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_report_user (report_user_id),
    INDEX idx_status (status),
    INDEX idx_target (target_type, target_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='举报表';

-- 商家信息表
CREATE TABLE IF NOT EXISTS shop_info (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    shop_name VARCHAR(100) NOT NULL COMMENT '商家名称',
    license_img VARCHAR(500) DEFAULT '' COMMENT '营业执照',
    contact_phone VARCHAR(20) DEFAULT '' COMMENT '联系电话',
    address VARCHAR(200) DEFAULT '' COMMENT '商家地址',
    description VARCHAR(500) DEFAULT '' COMMENT '商家简介',
    auth_status TINYINT DEFAULT 0 COMMENT '认证状态 0待审 1通过 2驳回',
    expire_time DATETIME DEFAULT NULL COMMENT '年费过期时间',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家信息表';

-- 商家广告表
CREATE TABLE IF NOT EXISTS shop_ad (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    shop_id BIGINT NOT NULL COMMENT '商家ID',
    title VARCHAR(200) NOT NULL COMMENT '广告标题',
    img_url VARCHAR(500) DEFAULT '' COMMENT '广告图片',
    link_url VARCHAR(500) DEFAULT '' COMMENT '跳转链接',
    status TINYINT DEFAULT 0 COMMENT '状态 0待审 1投放中 2已驳回 3已结束',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_shop (shop_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家广告表';

-- 管理员分成流水表
CREATE TABLE IF NOT EXISTS manager_income_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    manager_user_id BIGINT NOT NULL COMMENT '管理员用户ID',
    community_id BIGINT NOT NULL COMMENT '社区ID',
    order_type TINYINT NOT NULL COMMENT '订单类型 0置顶分成',
    order_id BIGINT NOT NULL COMMENT '关联订单ID',
    amount DECIMAL(10,2) NOT NULL COMMENT '分成金额',
    status TINYINT DEFAULT 0 COMMENT '状态 0待结算 1已结算 2已提现',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_manager (manager_user_id),
    INDEX idx_community (community_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员分成流水表';

-- ============================================================
-- 初始化基础数据
-- ============================================================

-- 一级社区(6大固定分类)
INSERT INTO community_first (id, name, icon, sort, status) VALUES
(1, '考研自习', 'icon-study', 1, 1),
(2, '球类运动', 'icon-sports', 2, 1),
(3, '户外徒步旅游', 'icon-travel', 3, 1),
(4, '美食饭搭子', 'icon-food', 4, 1),
(5, '线上游戏', 'icon-game', 5, 1),
(6, '求职面试', 'icon-job', 6, 1);

-- 会员套餐
INSERT INTO vip_package (id, name, type, price, days, description) VALUES
(1, '白银月卡', 0, 12.00, 30, '无限匹配私信、无广告、基础权益'),
(2, '白银年卡', 0, 99.00, 365, '无限匹配私信、无广告、基础权益'),
(3, '黄金月卡', 1, 22.00, 30, '免费置顶、无限圈子、免费核验'),
(4, '黄金年卡', 1, 168.00, 365, '免费置顶、无限圈子、免费核验');

-- 系统配置表
CREATE TABLE IF NOT EXISTS sys_config (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    config_key VARCHAR(100) NOT NULL COMMENT '配置键',
    config_value VARCHAR(500) NOT NULL COMMENT '配置值',
    description VARCHAR(200) DEFAULT '' COMMENT '配置说明',
    delete_flag TINYINT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

INSERT INTO sys_config (config_key, config_value, description) VALUES
('free_match_count', '3', '免费每日匹配次数'),
('free_chat_count', '5', '免费每日私信次数'),
('circle_max_free', '6', '免费圈子最大人数'),
('circle_max_pay', '20', '圈子扩容后人数'),
('community_create_free', '1', '社区创建免费上限'),
('community_create_price', '9.9', '社区创建单次付费金额'),
('community_top_price', '5', '社区置顶价格/24h'),
('site_top_price', '15', '全站置顶价格/24h'),
('top_platform_rate', '60', '置顶平台分成比例%'),
('top_manager_rate', '40', '置顶管理员分成比例%'),
('service_rate_min', '5', '活动服务费最低抽成%'),
('service_rate_max', '8', '活动服务费最高抽成%'),
('face_verify_price', '3', '双人核验单次价格');
