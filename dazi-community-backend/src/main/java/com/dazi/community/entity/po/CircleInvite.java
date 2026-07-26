package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("circle_invite")
public class CircleInvite {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long circleId;
    private String inviteCode;
    private LocalDateTime expireTime;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
