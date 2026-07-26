package com.dazi.community.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.dazi.community.common.exception.BusinessException;
import com.dazi.community.entity.po.SysUser;
import com.dazi.community.entity.po.VipOrder;
import com.dazi.community.entity.po.VipPackage;
import com.dazi.community.mapper.SysUserMapper;
import com.dazi.community.mapper.VipOrderMapper;
import com.dazi.community.mapper.VipPackageMapper;
import com.dazi.community.service.VipService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class VipServiceImpl implements VipService {

    @Resource
    private VipPackageMapper vipPackageMapper;
    @Resource
    private VipOrderMapper vipOrderMapper;
    @Resource
    private SysUserMapper sysUserMapper;

    @Override
    public List<VipPackage> getPackageList() {
        return vipPackageMapper.selectList(null);
    }

    @Override
    @Transactional
    public VipOrder createOrder(Long userId, Long packageId) {
        VipPackage pkg = vipPackageMapper.selectById(packageId);
        if (pkg == null) {
            throw new BusinessException("套餐不存在");
        }

        VipOrder order = new VipOrder();
        order.setUserId(userId);
        order.setPackageId(packageId);
        order.setPayPrice(pkg.getPrice());
        order.setPayStatus(1); // auto paid for demo
        order.setExpireTime(LocalDateTime.now().plusDays(pkg.getDays()));
        order.setTransactionId(UUID.randomUUID().toString().replace("-", "").substring(0, 20));
        vipOrderMapper.insert(order);

        // Update user vip status
        SysUser user = sysUserMapper.selectById(userId);
        user.setIsVip(1);
        user.setVipExpireTime(order.getExpireTime());
        user.setVipExpireTime(LocalDateTime.now().plusDays(pkg.getDays()));
        sysUserMapper.updateById(user);

        return order;
    }

    @Override
    public VipOrder getOrderDetail(Long orderId) {
        return vipOrderMapper.selectById(orderId);
    }

    @Override
    public List<VipOrder> getUserOrders(Long userId) {
        return vipOrderMapper.selectList(
                new LambdaQueryWrapper<VipOrder>()
                        .eq(VipOrder::getUserId, userId)
                        .orderByDesc(VipOrder::getCreateTime));
    }
}
