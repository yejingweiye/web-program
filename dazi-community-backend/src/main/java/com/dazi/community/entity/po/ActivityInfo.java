package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("activity_info")
public class ActivityInfo {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long communityId;
    private Long userId;
    private String title;
    private String content;
    private String address;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer maxPeople;
    private BigDecimal fee;
    private Integer status;
    private Integer auditStatus;
    private BigDecimal serviceRate;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
