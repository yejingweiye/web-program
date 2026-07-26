package com.dazi.community.entity.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class TopPostRequest {
    @NotNull(message = "帖子ID不能为空")
    private Long postId;
    @NotNull(message = "置顶类型不能为空")
    private Integer topType;
}
