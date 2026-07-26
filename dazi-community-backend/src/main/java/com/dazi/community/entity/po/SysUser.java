package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("sys_user")
public class SysUser {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String nickname;
    private String avatar;
    private String phone;
    private String city;
    private Integer age;
    private Integer gender;
    private String freeTime;
    private BigDecimal budget;
    private String tags;
    private Integer authType;
    private Integer status;
    private Integer isVip;
    private LocalDateTime vipExpireTime;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
