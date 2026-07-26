package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("shop_info")
public class ShopInfo {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String shopName;
    private String licenseImg;
    private String contactPhone;
    private String address;
    private String description;
    private Integer authStatus;
    private LocalDateTime expireTime;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
