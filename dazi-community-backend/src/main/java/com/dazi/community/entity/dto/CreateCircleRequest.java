package com.dazi.community.entity.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CreateCircleRequest {
    @NotNull(message = "社区ID不能为空")
    private Long communityId;
    @NotBlank(message = "圈子名称不能为空")
    private String name;
    private Integer type;
}
