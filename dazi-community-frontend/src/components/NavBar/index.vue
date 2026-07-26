<template>
  <div class="navbar">
    <div class="navbar-inner">
      <div class="navbar-left">
        <router-link to="/home" class="logo">
          <span class="logo-icon">🤝</span>
          <span class="logo-text">搭子社区</span>
        </router-link>
      </div>

      <div class="navbar-center hide-mobile">
        <div class="nav-links">
          <router-link to="/home" class="nav-link" :class="{ active: $route.path === '/home' }">
            <span>🏠</span> 首页
          </router-link>
          <router-link to="/post/my" class="nav-link" :class="{ active: $route.path === '/post/my' }">
            <span>📝</span> 我的帖子
          </router-link>
          <router-link to="/vip" class="nav-link" :class="{ active: $route.path === '/vip' }">
            <span>👑</span> 会员
          </router-link>
        </div>
      </div>

      <div class="navbar-right">
        <template v-if="userStore.isLoggedIn">
          <el-badge :is-dot="userStore.isVip" type="warning" class="vip-badge">
            <el-dropdown trigger="click" @command="handleCommand">
              <div class="user-info">
                <div class="user-avatar">
                  <span>{{ userStore.userInfo?.nickname?.charAt(0) || 'U' }}</span>
                  <span v-if="userStore.isVip" class="vip-dot">👑</span>
                </div>
                <span class="user-name hide-mobile">{{ userStore.userInfo?.nickname || '用户' }}</span>
                <el-icon class="arrow-icon"><ArrowDown /></el-icon>
              </div>
              <template #dropdown>
                <el-dropdown-menu class="dropdown-menu">
                  <div class="dropdown-user">
                    <div class="dropdown-avatar">{{ userStore.userInfo?.nickname?.charAt(0) || 'U' }}</div>
                    <div>
                      <div class="dropdown-name">{{ userStore.userInfo?.nickname }}</div>
                      <div class="dropdown-auth">{{ ['未实名','手机实名','人脸实名'][userStore.userInfo?.authType ?? 0] }}</div>
                    </div>
                  </div>
                  <el-dropdown-item divided command="profile">👤 个人中心</el-dropdown-item>
                  <el-dropdown-item command="face-auth">🔐 人脸实名</el-dropdown-item>
                  <el-dropdown-item command="vip">👑 会员中心</el-dropdown-item>
                  <el-dropdown-item command="admin" v-if="isAdmin">⚙️ 管理后台</el-dropdown-item>
                  <el-dropdown-item divided command="logout" class="logout-item">🚪 退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </el-badge>
        </template>
        <template v-else>
          <el-button class="login-btn-nav" @click="$router.push('/login')" round>登录 / 注册</el-button>
        </template>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/userStore'
import { ArrowDown } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const isAdmin = computed(() => userStore.userInfo?.id === 1)

function handleCommand(command: string) {
  switch (command) {
    case 'profile': router.push('/user/profile'); break
    case 'face-auth': router.push('/user/face-auth'); break
    case 'vip': router.push('/vip'); break
    case 'admin': router.push('/admin'); break
    case 'logout':
      userStore.logout()
      ElMessage.success('已退出')
      router.push('/home')
      break
  }
}
</script>

<style scoped>
.navbar {
  height: 64px;
  background: rgba(255,255,255,0.85);
  backdrop-filter: blur(16px);
  border-bottom: 1px solid rgba(0,0,0,0.06);
  position: sticky;
  top: 0;
  z-index: 100;
}
.navbar-inner {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 100%;
  padding: 0 24px;
}

.logo { display: flex; align-items: center; gap: 8px; }
.logo-icon { font-size: 24px; }
.logo-text {
  font-size: 18px;
  font-weight: 700;
  background: linear-gradient(135deg, var(--primary), var(--secondary));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.nav-links { display: flex; gap: 4px; }
.nav-link {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 8px 16px;
  border-radius: 10px;
  font-size: 14px;
  font-weight: 500;
  color: var(--text-secondary);
  transition: var(--transition);
}
.nav-link:hover { background: var(--primary-bg); color: var(--primary); }
.nav-link.active { background: var(--primary-bg); color: var(--primary); font-weight: 600; }

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 4px 12px 4px 4px;
  border-radius: 30px;
  transition: var(--transition);
}
.user-info:hover { background: var(--primary-bg); }
.user-avatar {
  width: 36px; height: 36px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary), var(--secondary));
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 14px;
  font-weight: 600;
  position: relative;
}
.vip-dot { position: absolute; top: -6px; right: -6px; font-size: 12px; }
.user-name { font-size: 14px; font-weight: 500; color: var(--text); }
.arrow-icon { font-size: 14px; color: var(--text-muted); }

.login-btn-nav {
  background: linear-gradient(135deg, var(--primary), var(--secondary)) !important;
  color: #fff !important;
  border: none !important;
  font-weight: 500;
  padding: 20px 24px !important;
}

:deep(.dropdown-menu) { padding: 8px !important; border-radius: 14px !important; border: 1px solid var(--border) !important; box-shadow: var(--shadow-lg) !important; min-width: 220px !important; }
:deep(.el-dropdown-menu__item) { border-radius: 8px !important; padding: 10px 14px !important; font-size: 14px !important; }
:deep(.el-dropdown-menu__item:hover) { background: var(--primary-bg) !important; color: var(--primary) !important; }

.dropdown-user {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 14px;
  border-bottom: 1px solid var(--border);
  margin-bottom: 4px;
}
.dropdown-avatar {
  width: 40px; height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary), var(--secondary));
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 600;
}
.dropdown-name { font-size: 14px; font-weight: 600; }
.dropdown-auth { font-size: 12px; color: var(--text-muted); }
.logout-item { color: var(--danger) !important; }

@media (max-width: 768px) {
  .navbar-inner { padding: 0 16px; }
}
</style>
