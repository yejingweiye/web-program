package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("circle_info")
public class CircleInfo {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long communityId;
    private String name;
    private Integer type;
    private Integer maxNum;
    private Long createUserId;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
