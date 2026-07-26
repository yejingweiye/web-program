package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("community_second")
public class CommunitySecond {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long firstId;
    private String name;
    private String city;
    private String description;
    private Integer joinType;
    private Long createUserId;
    private Integer status;
    private Integer memberCount;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
