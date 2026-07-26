-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: dazi_community
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `activity_info`
--

DROP TABLE IF EXISTS `activity_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `community_id` bigint NOT NULL COMMENT '社区ID',
  `user_id` bigint NOT NULL COMMENT '发起人用户ID',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '活动标题',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '活动内容',
  `address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '活动地址',
  `start_time` datetime DEFAULT NULL COMMENT '开始时间',
  `end_time` datetime DEFAULT NULL COMMENT '结束时间',
  `max_people` int DEFAULT '0' COMMENT '最大参与人数',
  `fee` decimal(10,2) DEFAULT '0.00' COMMENT '费用',
  `status` tinyint DEFAULT '0' COMMENT '状态 0正常 1已取消 2已结束',
  `audit_status` tinyint DEFAULT '0' COMMENT '审核状态 0待审核 1通过 2驳回',
  `service_rate` decimal(5,2) DEFAULT '5.00' COMMENT '服务费抽成比例(%)',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_community` (`community_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_audit` (`audit_status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='活动表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activity_order`
--

DROP TABLE IF EXISTS `activity_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `activity_id` bigint NOT NULL COMMENT '活动ID',
  `user_id` bigint NOT NULL COMMENT '报名用户ID',
  `pay_price` decimal(10,2) DEFAULT '0.00' COMMENT '支付金额',
  `service_fee` decimal(10,2) DEFAULT '0.00' COMMENT '服务费',
  `pay_status` tinyint DEFAULT '0' COMMENT '支付状态 0未支付 1已支付 2已退款 3支付失败',
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '交易流水号',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_activity` (`activity_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_pay_status` (`pay_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='活动报名订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chat_message`
--

DROP TABLE IF EXISTS `chat_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `from_user_id` bigint NOT NULL COMMENT '发送人',
  `to_user_id` bigint DEFAULT NULL COMMENT '接收人(私聊)',
  `circle_id` bigint DEFAULT NULL COMMENT '圈子ID(群聊)',
  `msg_type` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'text' COMMENT '消息类型 text/image/file',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '消息内容',
  `status` tinyint DEFAULT '0' COMMENT '状态 0未读 1已读',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_from_user` (`from_user_id`),
  KEY `idx_to_user` (`to_user_id`),
  KEY `idx_circle` (`circle_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聊天消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `circle_info`
--

DROP TABLE IF EXISTS `circle_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `circle_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `community_id` bigint NOT NULL COMMENT '所属社区ID',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '圈子名称',
  `type` tinyint DEFAULT '0' COMMENT '类型 0公开 1私密',
  `max_num` int DEFAULT '6' COMMENT '最大人数',
  `create_user_id` bigint NOT NULL COMMENT '创建人用户ID',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_community` (`community_id`),
  KEY `idx_create_user` (`create_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='圈子主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `circle_invite`
--

DROP TABLE IF EXISTS `circle_invite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `circle_invite` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `circle_id` bigint NOT NULL COMMENT '圈子ID',
  `invite_code` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '邀请码',
  `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_circle` (`circle_id`),
  KEY `idx_code` (`invite_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='圈子邀请链接表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `circle_member`
--

DROP TABLE IF EXISTS `circle_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `circle_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `circle_id` bigint NOT NULL COMMENT '圈子ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `join_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_circle_user` (`circle_id`,`user_id`),
  KEY `idx_circle` (`circle_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='圈子成员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `community_first`
--

DROP TABLE IF EXISTS `community_first`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community_first` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '社区名称',
  `icon` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图标',
  `sort` int DEFAULT '0' COMMENT '排序',
  `status` tinyint DEFAULT '1' COMMENT '状态 0禁用 1启用',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='一级官方社区';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `community_join_apply`
--

DROP TABLE IF EXISTS `community_join_apply`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community_join_apply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `community_id` bigint NOT NULL COMMENT '社区ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `apply_reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '申请理由',
  `free_time` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '空闲时间',
  `status` tinyint DEFAULT '0' COMMENT '状态 0待审 1通过 2拒绝',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_community` (`community_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区入群申请表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `community_manager`
--

DROP TABLE IF EXISTS `community_manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community_manager` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `community_id` bigint NOT NULL COMMENT '社区ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role` tinyint DEFAULT '2' COMMENT '角色 1主管理员 2副管理员',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_community` (`community_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区管理员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `community_member`
--

DROP TABLE IF EXISTS `community_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community_member` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `community_id` bigint NOT NULL COMMENT '社区ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `join_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '加入时间',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_community_user` (`community_id`,`user_id`),
  KEY `idx_community` (`community_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='社区成员表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `community_second`
--

DROP TABLE IF EXISTS `community_second`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `community_second` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `first_id` bigint NOT NULL COMMENT '所属一级社区ID',
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '社区名称',
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '城市',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '社区描述',
  `join_type` tinyint DEFAULT '0' COMMENT '准入模式 0自由进入 1管理员审核',
  `create_user_id` bigint NOT NULL COMMENT '创建人用户ID',
  `status` tinyint DEFAULT '1' COMMENT '状态 0禁用 1启用',
  `member_count` int DEFAULT '0' COMMENT '成员数',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_first_id` (`first_id`),
  KEY `idx_create_user` (`create_user_id`),
  KEY `idx_city` (`city`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='二级细分社区';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `manager_income_log`
--

DROP TABLE IF EXISTS `manager_income_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `manager_income_log` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `manager_user_id` bigint NOT NULL COMMENT '管理员用户ID',
  `community_id` bigint NOT NULL COMMENT '社区ID',
  `order_type` tinyint NOT NULL COMMENT '订单类型 0置顶分成',
  `order_id` bigint NOT NULL COMMENT '关联订单ID',
  `amount` decimal(10,2) NOT NULL COMMENT '分成金额',
  `status` tinyint DEFAULT '0' COMMENT '状态 0待结算 1已结算 2已提现',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_manager` (`manager_user_id`),
  KEY `idx_community` (`community_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='管理员分成流水表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `post_comment`
--

DROP TABLE IF EXISTS `post_comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '评论人ID',
  `content` varchar(1000) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论内容',
  `parent_id` bigint DEFAULT '0' COMMENT '父评论ID',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_post` (`post_id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子评论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `post_info`
--

DROP TABLE IF EXISTS `post_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `community_id` bigint NOT NULL COMMENT '社区ID',
  `user_id` bigint NOT NULL COMMENT '发布人用户ID',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '标题',
  `content` text COLLATE utf8mb4_unicode_ci COMMENT '内容',
  `img_list` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '图片列表(JSON数组)',
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '城市',
  `address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '地址',
  `start_time` datetime DEFAULT NULL COMMENT '活动时间',
  `budget` decimal(10,2) DEFAULT '0.00' COMMENT '预算',
  `people_num` int DEFAULT '1' COMMENT '期望人数',
  `tags` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '标签',
  `scope` tinyint DEFAULT '0' COMMENT '可见范围 0社区内 1全站公开',
  `status` tinyint DEFAULT '0' COMMENT '状态 0正常 1违规隐藏 2已删除',
  `is_top` tinyint DEFAULT '0' COMMENT '是否置顶 0否 1是',
  `top_expire_time` datetime DEFAULT NULL COMMENT '置顶过期时间',
  `view_count` int DEFAULT '0' COMMENT '浏览数',
  `like_count` int DEFAULT '0' COMMENT '点赞数',
  `comment_count` int DEFAULT '0' COMMENT '评论数',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_community` (`community_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_city` (`city`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_top` (`is_top`,`top_expire_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='搭子帖子表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `post_like`
--

DROP TABLE IF EXISTS `post_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `post_like` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_post_user` (`post_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子点赞表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `report_info`
--

DROP TABLE IF EXISTS `report_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `report_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `report_user_id` bigint NOT NULL COMMENT '举报人ID',
  `target_type` tinyint NOT NULL COMMENT '举报类型 1帖子 2用户 3评论 4活动',
  `target_id` bigint NOT NULL COMMENT '举报目标ID',
  `reason` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '举报原因',
  `status` tinyint DEFAULT '0' COMMENT '处理状态 0待处理 1已处理 2已驳回',
  `handle_user_id` bigint DEFAULT NULL COMMENT '处理人ID',
  `handle_result` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '处理结果',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_report_user` (`report_user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_target` (`target_type`,`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='举报表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shop_ad`
--

DROP TABLE IF EXISTS `shop_ad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_ad` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `shop_id` bigint NOT NULL COMMENT '商家ID',
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '广告标题',
  `img_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '广告图片',
  `link_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '跳转链接',
  `status` tinyint DEFAULT '0' COMMENT '状态 0待审 1投放中 2已驳回 3已结束',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_shop` (`shop_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家广告表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shop_info`
--

DROP TABLE IF EXISTS `shop_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_info` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `shop_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '商家名称',
  `license_img` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '营业执照',
  `contact_phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '联系电话',
  `address` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '商家地址',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '商家简介',
  `auth_status` tinyint DEFAULT '0' COMMENT '认证状态 0待审 1通过 2驳回',
  `expire_time` datetime DEFAULT NULL COMMENT '年费过期时间',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商家信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_config`
--

DROP TABLE IF EXISTS `sys_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_config` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `config_key` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置键',
  `config_value` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '配置值',
  `description` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '配置说明',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `nickname` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '昵称',
  `avatar` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '头像URL',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '手机号(加密存储)',
  `city` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '城市',
  `age` int DEFAULT '0' COMMENT '年龄',
  `gender` tinyint DEFAULT '0' COMMENT '性别 0未知 1男 2女',
  `free_time` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '空闲时间段',
  `budget` decimal(10,2) DEFAULT '0.00' COMMENT '消费预算',
  `tags` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '搭子标签(逗号分隔)',
  `auth_type` tinyint DEFAULT '0' COMMENT '实名类型 0未实名 1手机实名 2人脸实名',
  `status` tinyint DEFAULT '0' COMMENT '账号状态 0正常 1禁言 2封禁',
  `is_vip` tinyint DEFAULT '0' COMMENT '是否会员 0否 1是',
  `vip_expire_time` datetime DEFAULT NULL COMMENT '会员过期时间',
  `delete_flag` tinyint DEFAULT '0' COMMENT '逻辑删除 0未删 1已删',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_phone` (`phone`),
  KEY `idx_city` (`city`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tool_pay_order`
--

DROP TABLE IF EXISTS `tool_pay_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tool_pay_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `tool_type` tinyint NOT NULL COMMENT '工具类型 1人脸核验 2圈子扩容 3保险',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `pay_status` tinyint DEFAULT '0' COMMENT '支付状态',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='工具付费订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `top_order`
--

DROP TABLE IF EXISTS `top_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `top_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `post_id` bigint NOT NULL COMMENT '帖子ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `top_type` tinyint DEFAULT '0' COMMENT '置顶类型 0社区置顶 1全站置顶',
  `price` decimal(10,2) DEFAULT '0.00' COMMENT '价格',
  `hours` int DEFAULT '24' COMMENT '置顶时长(小时)',
  `platform_rate` decimal(5,2) DEFAULT '60.00' COMMENT '平台分成比例(%)',
  `manager_rate` decimal(5,2) DEFAULT '40.00' COMMENT '管理员分成比例(%)',
  `manager_user_id` bigint DEFAULT NULL COMMENT '管理员用户ID',
  `pay_status` tinyint DEFAULT '0' COMMENT '支付状态 0未支付 1已支付 2已退款',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_post` (`post_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_manager` (`manager_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='帖子置顶订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_face_auth`
--

DROP TABLE IF EXISTS `user_face_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_face_auth` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `real_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '真实姓名',
  `id_card` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '' COMMENT '身份证号',
  `face_img` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '人脸图片URL',
  `auth_status` tinyint DEFAULT '0' COMMENT '审核状态 0待审 1通过 2驳回',
  `auth_time` datetime DEFAULT NULL COMMENT '审核时间',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='人脸实名表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vip_order`
--

DROP TABLE IF EXISTS `vip_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vip_order` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `package_id` bigint NOT NULL COMMENT '套餐ID',
  `pay_price` decimal(10,2) NOT NULL COMMENT '支付金额',
  `pay_status` tinyint DEFAULT '0' COMMENT '支付状态 0未支付 1已支付 2已退款',
  `expire_time` datetime DEFAULT NULL COMMENT '会员过期时间',
  `transaction_id` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '交易流水号',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_pay_status` (`pay_status`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员订单';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `vip_package`
--

DROP TABLE IF EXISTS `vip_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vip_package` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '套餐名称',
  `type` tinyint NOT NULL COMMENT '类型 0白银 1黄金',
  `price` decimal(10,2) NOT NULL COMMENT '价格',
  `days` int NOT NULL COMMENT '有效天数',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT '' COMMENT '权益描述',
  `delete_flag` tinyint DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='会员套餐配置';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- MySQL dump 10.13  Distrib 8.0.36, for Linux (x86_64)
--
-- Host: localhost    Database: dazi_community
-- ------------------------------------------------------
-- Server version	8.0.36

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping data for table `activity_info`
--

LOCK TABLES `activity_info` WRITE;
/*!40000 ALTER TABLE `activity_info` DISABLE KEYS */;
INSERT INTO `activity_info` (`id`, `community_id`, `user_id`, `title`, `content`, `address`, `start_time`, `end_time`, `max_people`, `fee`, `status`, `audit_status`, `service_rate`, `delete_flag`, `create_time`, `update_time`) VALUES (1,1,1,'考研分享会','经验分享','海淀',NULL,NULL,20,0.00,0,0,5.00,0,'2026-07-12 14:20:55','2026-07-12 14:20:55');
/*!40000 ALTER TABLE `activity_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `activity_order`
--

LOCK TABLES `activity_order` WRITE;
/*!40000 ALTER TABLE `activity_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `activity_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `chat_message`
--

LOCK TABLES `chat_message` WRITE;
/*!40000 ALTER TABLE `chat_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `chat_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `circle_info`
--

LOCK TABLES `circle_info` WRITE;
/*!40000 ALTER TABLE `circle_info` DISABLE KEYS */;
INSERT INTO `circle_info` (`id`, `community_id`, `name`, `type`, `max_num`, `create_user_id`, `delete_flag`, `create_time`, `update_time`) VALUES (1,1,'学习小组',0,6,1,0,'2026-07-12 14:20:55','2026-07-12 14:20:55');
/*!40000 ALTER TABLE `circle_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `circle_invite`
--

LOCK TABLES `circle_invite` WRITE;
/*!40000 ALTER TABLE `circle_invite` DISABLE KEYS */;
/*!40000 ALTER TABLE `circle_invite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `circle_member`
--

LOCK TABLES `circle_member` WRITE;
/*!40000 ALTER TABLE `circle_member` DISABLE KEYS */;
INSERT INTO `circle_member` (`id`, `circle_id`, `user_id`, `join_time`, `delete_flag`, `create_time`, `update_time`) VALUES (1,1,1,'2026-07-12 14:20:55',0,'2026-07-12 14:20:55','2026-07-12 14:20:55');
/*!40000 ALTER TABLE `circle_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `community_first`
--

LOCK TABLES `community_first` WRITE;
/*!40000 ALTER TABLE `community_first` DISABLE KEYS */;
INSERT INTO `community_first` (`id`, `name`, `icon`, `sort`, `status`, `delete_flag`, `create_time`, `update_time`) VALUES (1,'考研自习','icon-study',1,1,0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(2,'球类运动','icon-sports',2,1,0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(3,'户外徒步旅游','icon-travel',3,1,0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(4,'美食饭搭子','icon-food',4,1,0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(5,'线上游戏','icon-game',5,1,0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(6,'求职面试','icon-job',6,1,0,'2026-07-12 13:42:31','2026-07-12 13:42:31');
/*!40000 ALTER TABLE `community_first` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `community_join_apply`
--

LOCK TABLES `community_join_apply` WRITE;
/*!40000 ALTER TABLE `community_join_apply` DISABLE KEYS */;
/*!40000 ALTER TABLE `community_join_apply` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `community_manager`
--

LOCK TABLES `community_manager` WRITE;
/*!40000 ALTER TABLE `community_manager` DISABLE KEYS */;
INSERT INTO `community_manager` (`id`, `community_id`, `user_id`, `role`, `delete_flag`, `create_time`, `update_time`) VALUES (1,1,1,1,0,'2026-07-12 14:20:54','2026-07-12 14:20:54');
/*!40000 ALTER TABLE `community_manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `community_member`
--

LOCK TABLES `community_member` WRITE;
/*!40000 ALTER TABLE `community_member` DISABLE KEYS */;
INSERT INTO `community_member` (`id`, `community_id`, `user_id`, `join_time`, `delete_flag`, `create_time`, `update_time`) VALUES (1,1,1,'2026-07-12 14:20:54',0,'2026-07-12 14:20:54','2026-07-12 14:20:54');
/*!40000 ALTER TABLE `community_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `community_second`
--

LOCK TABLES `community_second` WRITE;
/*!40000 ALTER TABLE `community_second` DISABLE KEYS */;
INSERT INTO `community_second` (`id`, `first_id`, `name`, `city`, `description`, `join_type`, `create_user_id`, `status`, `member_count`, `delete_flag`, `create_time`, `update_time`) VALUES (1,1,'北京考研圈','北京','',0,1,1,1,0,'2026-07-12 14:20:54','2026-07-12 14:20:54');
/*!40000 ALTER TABLE `community_second` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `manager_income_log`
--

LOCK TABLES `manager_income_log` WRITE;
/*!40000 ALTER TABLE `manager_income_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `manager_income_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `post_comment`
--

LOCK TABLES `post_comment` WRITE;
/*!40000 ALTER TABLE `post_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `post_info`
--

LOCK TABLES `post_info` WRITE;
/*!40000 ALTER TABLE `post_info` DISABLE KEYS */;
INSERT INTO `post_info` (`id`, `community_id`, `user_id`, `title`, `content`, `img_list`, `city`, `address`, `start_time`, `budget`, `people_num`, `tags`, `scope`, `status`, `is_top`, `top_expire_time`, `view_count`, `like_count`, `comment_count`, `delete_flag`, `create_time`, `update_time`) VALUES (1,1,1,'找个研友一起学习','周末去图书馆学习','','北京','',NULL,0.00,1,'考研,学习',1,0,0,NULL,0,0,0,0,'2026-07-12 14:20:54','2026-07-12 14:20:54');
/*!40000 ALTER TABLE `post_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `post_like`
--

LOCK TABLES `post_like` WRITE;
/*!40000 ALTER TABLE `post_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `post_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `report_info`
--

LOCK TABLES `report_info` WRITE;
/*!40000 ALTER TABLE `report_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `report_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `shop_ad`
--

LOCK TABLES `shop_ad` WRITE;
/*!40000 ALTER TABLE `shop_ad` DISABLE KEYS */;
/*!40000 ALTER TABLE `shop_ad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `shop_info`
--

LOCK TABLES `shop_info` WRITE;
/*!40000 ALTER TABLE `shop_info` DISABLE KEYS */;
/*!40000 ALTER TABLE `shop_info` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_config`
--

LOCK TABLES `sys_config` WRITE;
/*!40000 ALTER TABLE `sys_config` DISABLE KEYS */;
INSERT INTO `sys_config` (`id`, `config_key`, `config_value`, `description`, `delete_flag`, `create_time`, `update_time`) VALUES (1,'free_match_count','3','免费每日匹配次数',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(2,'free_chat_count','5','免费每日私信次数',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(3,'circle_max_free','6','免费圈子最大人数',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(4,'circle_max_pay','20','圈子扩容后人数',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(5,'community_create_free','1','社区创建免费上限',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(6,'community_create_price','9.9','社区创建单次付费金额',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(7,'community_top_price','5','社区置顶价格/24h',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(8,'site_top_price','15','全站置顶价格/24h',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(9,'top_platform_rate','60','置顶平台分成比例%',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(10,'top_manager_rate','40','置顶管理员分成比例%',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(11,'service_rate_min','5','活动服务费最低抽成%',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(12,'service_rate_max','8','活动服务费最高抽成%',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(13,'face_verify_price','3','双人核验单次价格',0,'2026-07-12 13:42:31','2026-07-12 13:42:31');
/*!40000 ALTER TABLE `sys_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` (`id`, `nickname`, `avatar`, `phone`, `city`, `age`, `gender`, `free_time`, `budget`, `tags`, `auth_type`, `status`, `is_vip`, `vip_expire_time`, `delete_flag`, `create_time`, `update_time`) VALUES (1,'测试用户','','13800138000','',0,0,'',0.00,'',2,0,1,'2026-08-11 14:14:09',0,'2026-07-12 13:53:32','2026-07-12 13:53:32'),(2,'Admin','','13900139000','',0,0,'',0.00,'',1,0,0,NULL,0,'2026-07-12 14:16:31','2026-07-12 14:16:31');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `tool_pay_order`
--

LOCK TABLES `tool_pay_order` WRITE;
/*!40000 ALTER TABLE `tool_pay_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `tool_pay_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `top_order`
--

LOCK TABLES `top_order` WRITE;
/*!40000 ALTER TABLE `top_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_face_auth`
--

LOCK TABLES `user_face_auth` WRITE;
/*!40000 ALTER TABLE `user_face_auth` DISABLE KEYS */;
INSERT INTO `user_face_auth` (`id`, `user_id`, `real_name`, `id_card`, `face_img`, `auth_status`, `auth_time`, `delete_flag`, `create_time`, `update_time`) VALUES (1,1,'张三','110101199001011234','https://example.com/face.jpg',1,'2026-07-12 14:17:53',0,'2026-07-12 14:17:52','2026-07-12 14:17:52');
/*!40000 ALTER TABLE `user_face_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `vip_order`
--

LOCK TABLES `vip_order` WRITE;
/*!40000 ALTER TABLE `vip_order` DISABLE KEYS */;
INSERT INTO `vip_order` (`id`, `user_id`, `package_id`, `pay_price`, `pay_status`, `expire_time`, `transaction_id`, `delete_flag`, `create_time`, `update_time`) VALUES (1,1,1,12.00,1,'2026-08-11 14:14:09','dd264c696fb44c25b835',0,'2026-07-12 14:14:09','2026-07-12 14:14:09');
/*!40000 ALTER TABLE `vip_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `vip_package`
--

LOCK TABLES `vip_package` WRITE;
/*!40000 ALTER TABLE `vip_package` DISABLE KEYS */;
INSERT INTO `vip_package` (`id`, `name`, `type`, `price`, `days`, `description`, `delete_flag`, `create_time`, `update_time`) VALUES (1,'白银月卡',0,12.00,30,'无限匹配私信、无广告、基础权益',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(2,'白银年卡',0,99.00,365,'无限匹配私信、无广告、基础权益',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(3,'黄金月卡',1,22.00,30,'免费置顶、无限圈子、免费核验',0,'2026-07-12 13:42:31','2026-07-12 13:42:31'),(4,'黄金年卡',1,168.00,365,'免费置顶、无限圈子、免费核验',0,'2026-07-12 13:42:31','2026-07-12 13:42:31');
/*!40000 ALTER TABLE `vip_package` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

