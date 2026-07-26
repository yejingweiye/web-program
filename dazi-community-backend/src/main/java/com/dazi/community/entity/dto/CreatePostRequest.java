package com.dazi.community.entity.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class CreatePostRequest {
    @NotNull(message = "社区ID不能为空")
    private Long communityId;
    @NotBlank(message = "标题不能为空")
    private String title;
    private String content;
    private String imgList;
    private String city;
    private String address;
    private String startTime;
    private BigDecimal budget;
    private Integer peopleNum;
    private String tags;
    private Integer scope;
}
