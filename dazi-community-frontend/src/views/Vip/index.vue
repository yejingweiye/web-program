<template>
  <div class="vip-page">
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">会员中心</span>
    </div>
    <!-- Hero -->
    <div class="vip-hero">
      <div class="hero-content">
        <h1 class="hero-title">👑 会员中心</h1>
        <p class="hero-desc">开通会员，解锁全部权益，享受更好的搭子体验</p>
        <div v-if="userStore.isVip" class="vip-active-badge">
          ⭐ 您已是VIP会员
        </div>
      </div>
    </div>

    <!-- Package grid -->
    <div class="package-grid mt-20">
      <div v-for="pkg in packages" :key="pkg.id" class="package-card" :class="{ gold: pkg.type === 1 }">
        <div class="package-badge" v-if="pkg.type === 1">🔥 推荐</div>
        <div class="package-icon">{{ pkg.type === 1 ? '👑' : '🥈' }}</div>
        <h3 class="package-name">{{ pkg.name }}</h3>
        <div class="package-price-wrap">
          <span class="package-currency">¥</span>
          <span class="package-price">{{ pkg.price }}</span>
          <span class="package-period">/{{ pkg.days }}天</span>
        </div>
        <div class="package-desc">{{ pkg.description }}</div>
        <ul class="package-features">
          <li>✓ 无限匹配私信</li>
          <li>✓ 无广告打扰</li>
          <li>✓ {{ pkg.type === 1 ? '免费置顶 + 无限圈子' : '基础权益' }}</li>
        </ul>
        <el-button class="buy-btn" :class="{ 'btn-gradient': pkg.type === 1 }"
                   :type="pkg.type === 1 ? 'primary' : 'default'"
                   round size="large" @click="handleBuy(pkg.id)">
          {{ userStore.isVip ? '续费开通' : '立即开通' }}
        </el-button>
      </div>
    </div>

    <!-- Orders -->
    <div v-if="orders.length > 0" class="card mt-20">
      <h3 class="section-title">我的订单</h3>
      <div v-for="o in orders" :key="o.id" class="order-item">
        <div class="order-info">
          <span class="order-name">套餐 #{{ o.packageId }}</span>
          <span class="order-time">{{ formatTime(o.createTime) }}</span>
        </div>
        <div class="order-right">
          <span class="order-price">¥{{ o.payPrice }}</span>
          <el-tag :type="o.payStatus === 1 ? 'success' : 'warning'" size="small" round>
            {{ o.payStatus === 1 ? '已支付' : '未支付' }}
          </el-tag>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { ArrowLeft } from '@element-plus/icons-vue'
import { getPackageList, createVipOrder, getVipOrders } from '@/api/vip'
import { useUserStore } from '@/stores/userStore'
import type { VipPackage, VipOrder } from '@/types'
import { formatTime } from '@/utils/format'

const userStore = useUserStore()
const packages = ref<VipPackage[]>([])
const orders = ref<VipOrder[]>([])

async function handleBuy(packageId: number) {
  if (!userStore.isLoggedIn) { ElMessage.warning('请先登录'); return }
  try {
    await createVipOrder(packageId)
    ElMessage.success('🎉 开通成功！')
    userStore.userInfo!.isVip = 1
    const res = await getVipOrders()
    orders.value = res.data.data
  } catch (e) { /* handled */ }
}

onMounted(async () => {
  const [pkgRes, orderRes] = await Promise.all([
    getPackageList(),
    getVipOrders().catch(() => ({ data: { data: [] } })),
  ])
  packages.value = pkgRes.data.data
  orders.value = orderRes.data.data || []
})
</script>

<style scoped>
.vip-hero {
  background: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #1e1b4b 100%);
  border-radius: 20px;
  padding: 40px 48px;
  text-align: center;
  position: relative;
  overflow: hidden;
}
.vip-hero::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at 50% 0%, rgba(251,191,36,0.15), transparent 60%);
}
.hero-content { position: relative; z-index: 1; }
.hero-title { font-size: 32px; font-weight: 800; color: #fff; margin-bottom: 8px; }
.hero-desc { color: rgba(255,255,255,0.6); font-size: 15px; }
.vip-active-badge {
  display: inline-block;
  margin-top: 16px;
  padding: 8px 24px;
  border-radius: 100px;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #fff;
  font-weight: 600;
  font-size: 14px;
}

.package-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(260px, 1fr));
  gap: 20px;
}
.package-card {
  background: var(--bg-card);
  border-radius: 20px;
  padding: 32px 28px;
  text-align: center;
  border: 2px solid var(--border);
  position: relative;
  transition: var(--transition);
}
.package-card:hover { transform: translateY(-4px); box-shadow: var(--shadow-lg); }
.package-card.gold {
  border-color: #f59e0b;
  background: linear-gradient(180deg, #fffbeb 0%, var(--bg-card) 40%);
}
.package-badge {
  position: absolute;
  top: -12px; left: 50%;
  transform: translateX(-50%);
  padding: 4px 16px;
  border-radius: 100px;
  background: linear-gradient(135deg, #f59e0b, #d97706);
  color: #fff;
  font-size: 13px;
  font-weight: 600;
}
.package-icon { font-size: 40px; margin-bottom: 12px; }
.package-name { font-size: 18px; font-weight: 700; margin-bottom: 12px; }
.package-price-wrap { display: flex; align-items: baseline; justify-content: center; gap: 2px; margin-bottom: 8px; }
.package-currency { font-size: 18px; color: var(--danger); font-weight: 600; }
.package-price { font-size: 40px; font-weight: 800; color: var(--danger); line-height: 1; }
.package-period { font-size: 14px; color: var(--text-muted); }
.package-desc { font-size: 14px; color: var(--text-secondary); margin-bottom: 16px; }
.package-features { list-style: none; padding: 0; margin: 0 0 20px; text-align: left; }
.package-features li {
  padding: 6px 0;
  font-size: 14px;
  color: var(--text-secondary);
}
.buy-btn { width: 100%; font-weight: 600; letter-spacing: 0.5px; }

.order-item { display: flex; align-items: center; justify-content: space-between; padding: 12px 0; border-bottom: 1px solid var(--border); }
.order-item:last-child { border-bottom: none; }
.order-info { display: flex; flex-direction: column; gap: 2px; }
.order-name { font-weight: 600; font-size: 14px; }
.order-time { font-size: 12px; color: var(--text-muted); }
.order-right { display: flex; align-items: center; gap: 12px; }
.order-price { font-size: 16px; font-weight: 700; color: var(--text); }

.section-title { font-size: 17px; font-weight: 700; margin-bottom: 8px; }

@media (max-width: 768px) {
  .package-grid { grid-template-columns: 1fr; }
}
</style>
