package com.dazi.community.entity.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.math.BigDecimal;

@Data
public class CreateActivityRequest {
    @NotNull(message = "社区ID不能为空")
    private Long communityId;
    @NotBlank(message = "活动标题不能为空")
    private String title;
    private String content;
    private String address;
    private String startTime;
    private String endTime;
    private Integer maxPeople;
    private BigDecimal fee;
}
