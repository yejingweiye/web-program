---
name: unit-test-write
description: 单元测试编写技能，为 Spring Boot 后端和 Vue3 前端编写高质量的单元测试
metadata:
  type: skill
---

# Unit Test Write

你是一位测试工程师，负责为项目编写高质量的单元测试和集成测试。

## 通用原则

- 测试应该是**可重复的**、**独立的**、**可读的**
- 一个测试只验证一个行为
- 测试命名清晰说明场景和期望：`methodName_shouldDo_whenCondition`
- 遵循 Arrange-Act-Assert（3A）模式

## 后端测试（JUnit 5 + Mockito + MockMvc）

### 测试层次

#### Controller 层（MockMvc）
- 验证 HTTP 状态码、响应结构 `Result<T>`
- 验证请求分发、参数绑定
- Mock Service 层，不加载完整 Spring 上下文

```java
@WebMvcTest(XxxController.class)
class XxxControllerTest {
    @Autowired
    private MockMvc mockMvc;
    @MockitoBean
    private XxxService xxxService;

    @Test
    void getList_shouldReturnOk_whenValidRequest() throws Exception {
        mockMvc.perform(get("/api/v1/xxx"))
               .andExpect(status().isOk())
               .andExpect(jsonPath("$.code").value(200));
    }
}
```

#### Service 层
- Mock Mapper/DAO 层
- 覆盖业务逻辑分支（正常流程、异常流程、边界值）

```java
@Test
void createOrder_shouldThrowException_whenPackageNotExist() {
    when(packageMapper.selectById(any())).thenReturn(null);
    assertThrows(BusinessException.class, () -> vipService.createOrder(1L, 999L));
}
```

#### Mapper 层（@MybatisPlusTest）
- 验证 SQL 生成是否正确
- 验证 MyBatis-Plus 逻辑删除、自动填充等特性

### 测试模板

#### Service 测试模板
```java
@ExtendWith(MockitoExtension.class)
class XxxServiceTest {
    @Mock
    private XxxMapper xxxMapper;
    @InjectMocks
    private XxxServiceImpl xxxService;

    @Test
    void method_shouldDoSomething_whenCondition() {
        // Arrange
        // Act
        // Assert
        // Verify: verify(xxxMapper).method(arg);
    }
}
```

### 注意事项
- 涉及数据库操作的服务方法使用 `@Transactional` 避免数据污染
- 测试数据构造使用 builder 或 factory 方法，减少重复
- 异步方法使用 `awaitility` 或 `CompletableFuture` 同步等待
- 日期/随机数等不可控因素使用 Mock 或固定值

## 前端测试（Vitest + Vue Test Utils）

### 测试层次

#### 组件测试
- 验证组件渲染输出
- 验证用户交互行为（点击、输入）
- 验证组件 Props/Emits

```typescript
import { mount } from '@vue/test-utils'
import { describe, it, expect } from 'vitest'

describe('XxxComponent', () => {
  it('should emit click event when button is clicked', async () => {
    const wrapper = mount(XxxComponent)
    await wrapper.find('button').trigger('click')
    expect(wrapper.emitted('click')).toBeTruthy()
  })
})
```

#### Store 测试（Pinia）
- 验证状态变化逻辑
- Mock API 调用

#### 工具函数测试
- 纯函数直接测试输入/输出

### 注意事项
- 对 Element Plus 组件使用 `global.components` 或 stubs
- `vue-router` 使用 `createRouter` + `createMemoryHistory` 模拟
- API 请求使用 `vi.mock('@/utils/request')` 拦截
