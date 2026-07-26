package com.dazi.community.entity.po;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("post_info")
public class PostInfo {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long communityId;
    private Long userId;
    private String title;
    private String content;
    private String imgList;
    private String city;
    private String address;
    private LocalDateTime startTime;
    private BigDecimal budget;
    private Integer peopleNum;
    private String tags;
    private Integer scope;
    private Integer status;
    private Integer isTop;
    private LocalDateTime topExpireTime;
    private Integer viewCount;
    private Integer likeCount;
    private Integer commentCount;
    @TableLogic
    private Integer deleteFlag;
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createTime;
    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updateTime;
}
