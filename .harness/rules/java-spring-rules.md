# Java / Spring Boot 编码规则

## 项目基础

- **JDK**: 17
- **框架**: Spring Boot 3.2.5, MyBatis-Plus 3.5.7
- **包结构**: `com.dazi.community.{common,config,constant,controller,entity,mapper,service,mq,websocket}`
- **构建**: Maven, 入口 `DaziCommunityApplication.java` 已配置 `@MapperScan`

## 分层规范

```
Controller → Service(接口) → ServiceImpl(实现) → Mapper(MyBatis-Plus)
```

- Controller 只做参数接收和结果返回，不写业务逻辑
- Service 接口定义契约，Impl 实现业务
- Mapper 继承 `BaseMapper<T>`，复杂查询使用 `LambdaQueryWrapper`
- Entity 使用 `@Data` (Lombok)，PO 类统一放在 `entity.po` 包

## 命名规范

- 类名: `PascalCase`（如 `VipOrder`, `UserServiceImpl`）
- 方法名: `camelCase`（如 `createOrder`, `getUserOrders`）
- 包名: 全小写
- 数据库列: `snake_case`（如 `delete_flag`, `pay_status`）
- 数据库表: `snake_case`（如 `vip_order`, `post_info`）

## API 规范

- 统一前缀 `/api/v1/`
- 统一响应体 `Result<T>`：`{code, msg, data}`
  - 200 = 成功, 500 = 服务器错误, 10001 = 认证失败
- Controller 类加 `@RestController` + `@RequestMapping("/api/v1/xxx")`
- 使用 `jakarta.*` 命名空间（Spring Boot 3.x），非 `javax.*`

## 异常处理

- 业务异常使用 `BusinessException` + 错误信息
- 全局异常由 `GlobalExceptionHandler` 统一拦截处理
- Controller 层不需要 try-catch

## 依赖注入

- 使用 `@Resource`（jakarta.annotation.Resource）而非 `@Autowired`
- 优先注入接口（面向接口编程）

## 逻辑删除

- 所有表包含 `delete_flag` 字段（TINYINT, 0=未删 1=已删）
- Entity 字段加 `@TableLogic` 注解
- MyBatis-Plus 自动拼接 `WHERE delete_flag=0`
