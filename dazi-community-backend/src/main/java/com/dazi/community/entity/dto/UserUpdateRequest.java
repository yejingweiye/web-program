package com.dazi.community.entity.dto;

import lombok.Data;
import java.math.BigDecimal;

@Data
public class UserUpdateRequest {
    private String nickname;
    private String avatar;
    private String city;
    private Integer age;
    private Integer gender;
    private String freeTime;
    private BigDecimal budget;
    private String tags;
}
