package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("vip_order")
public class VipOrder {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private Long packageId;
    private BigDecimal payPrice;
    private Integer payStatus;
    private LocalDateTime expireTime;
    private String transactionId;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
