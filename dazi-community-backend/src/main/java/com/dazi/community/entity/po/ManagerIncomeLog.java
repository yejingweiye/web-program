package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("manager_income_log")
public class ManagerIncomeLog {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long managerUserId;
    private Long communityId;
    private Integer orderType;
    private Long orderId;
    private BigDecimal amount;
    private Integer status;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
