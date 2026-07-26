package com.dazi.community.controller;

import com.dazi.community.common.result.Result;
import com.dazi.community.entity.po.VipOrder;
import com.dazi.community.entity.po.VipPackage;
import com.dazi.community.service.VipService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.List;

@RestController
@RequestMapping("/api/v1/vip")
public class VipController {

    @Resource
    private VipService vipService;

    @GetMapping("/packages")
    public Result<List<VipPackage>> getPackages() {
        return Result.success(vipService.getPackageList());
    }

    @PostMapping("/create-order/{packageId}")
    public Result<VipOrder> createOrder(HttpServletRequest request, @PathVariable Long packageId) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(vipService.createOrder(userId, packageId));
    }

    @GetMapping("/order/{orderId}")
    public Result<VipOrder> getOrder(@PathVariable Long orderId) {
        return Result.success(vipService.getOrderDetail(orderId));
    }

    @GetMapping("/orders")
    public Result<List<VipOrder>> getOrders(HttpServletRequest request) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(vipService.getUserOrders(userId));
    }
}
