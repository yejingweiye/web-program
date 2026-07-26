package com.dazi.community.entity.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ApplyCommunityRequest {
    @NotNull(message = "社区ID不能为空")
    private Long communityId;
    private String applyReason;
    private String freeTime;
}
