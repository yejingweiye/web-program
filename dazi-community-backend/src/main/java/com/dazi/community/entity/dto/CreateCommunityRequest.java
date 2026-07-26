package com.dazi.community.entity.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateCommunityRequest {
    @NotNull(message = "所属一级社区不能为空")
    private Long firstId;
    @NotBlank(message = "社区名称不能为空")
    private String name;
    private String city;
    private String desc;
    private Integer joinType;
}
