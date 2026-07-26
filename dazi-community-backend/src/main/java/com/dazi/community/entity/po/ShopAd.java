package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("shop_ad")
public class ShopAd {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long shopId;
    private String title;
    private String imgUrl;
    private String linkUrl;
    private Integer status;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
