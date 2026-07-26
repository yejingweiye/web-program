package com.dazi.community.service;

import com.dazi.community.entity.po.VipPackage;
import com.dazi.community.entity.po.VipOrder;

import java.util.List;

public interface VipService {
    List<VipPackage> getPackageList();
    VipOrder createOrder(Long userId, Long packageId);
    VipOrder getOrderDetail(Long orderId);
    List<VipOrder> getUserOrders(Long userId);
}
