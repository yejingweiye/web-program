package com.dazi.community;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.dazi.community.mapper")
public class DaziCommunityApplication {
    public static void main(String[] args) {
        SpringApplication.run(DaziCommunityApplication.class, args);
    }
}
