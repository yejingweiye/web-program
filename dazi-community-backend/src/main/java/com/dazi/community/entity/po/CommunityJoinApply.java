package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("community_join_apply")
public class CommunityJoinApply {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long communityId;
    private Long userId;
    private String applyReason;
    private String freeTime;
    private Integer status;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
