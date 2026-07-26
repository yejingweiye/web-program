package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("report_info")
public class ReportInfo {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long reportUserId;
    private Integer targetType;
    private Long targetId;
    private String reason;
    private Integer status;
    private Long handleUserId;
    private String handleResult;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
