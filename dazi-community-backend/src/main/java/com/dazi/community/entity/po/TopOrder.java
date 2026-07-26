package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("top_order")
public class TopOrder {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long postId;
    private Long userId;
    private Integer topType;
    private BigDecimal price;
    private Integer hours;
    private BigDecimal platformRate;
    private BigDecimal managerRate;
    private Long managerUserId;
    private Integer payStatus;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
