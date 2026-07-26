package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("tool_pay_order")
public class ToolPayOrder {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Integer toolType;
    private BigDecimal price;
    private Integer payStatus;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
