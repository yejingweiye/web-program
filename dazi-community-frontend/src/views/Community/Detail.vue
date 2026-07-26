<template>
  <div v-if="loading" class="loading-wrap">
    <el-icon class="is-loading" :size="40" color="var(--primary)"><Loading /></el-icon>
    <p>加载社区信息...</p>
  </div>
  <div v-else-if="detail" class="community-detail">
    <!-- Back button -->
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">社区详情</span>
    </div>
    <!-- Banner -->
    <div class="community-banner" :style="{ background: bannerGradient }">
      <div class="banner-content">
        <div class="banner-top">
          <div class="banner-icon">{{ detail.community.name.charAt(0) }}</div>
          <div class="banner-info">
            <h1 class="banner-title">{{ detail.community.name }}</h1>
            <div class="banner-meta">
              <span>🏷 {{ detail.firstLevel?.name }}</span>
              <span>📍 {{ detail.community.city || '同城' }}</span>
              <span>👥 {{ detail.memberCount }}人</span>
              <el-tag size="small" :type="detail.community.joinType === 1 ? 'warning' : 'success'" round effect="dark">
                {{ detail.community.joinType === 1 ? '审核加入' : '自由加入' }}
              </el-tag>
            </div>
          </div>
        </div>
        <p class="banner-desc">{{ detail.community.description || '暂无简介' }}</p>
        <div class="banner-actions">
          <template v-if="!detail.isMember">
            <el-button class="join-btn" round @click="handleJoin">
              {{ detail.community.joinType === 1 ? '📋 申请加入' : '🚪 加入社区' }}
            </el-button>
          </template>
          <template v-else>
            <el-tag class="joined-tag" round>✅ 已加入</el-tag>
            <el-button class="action-btn" round @click="$router.push('/post/create')">📝 发帖</el-button>
            <el-button class="action-btn" round @click="$router.push('/activity/create')">🎉 发布活动</el-button>
          </template>
          <el-button class="action-btn" round @click="showCreateCircle = true" v-if="detail.isMember">
            🔗 创建圈子
          </el-button>
        </div>
      </div>
    </div>

    <!-- Tabs -->
    <el-tabs v-model="activeTab" class="content-tabs" @tab-change="loadTabData">
      <el-tab-pane label="📝 帖子" name="posts">
        <div v-if="detail.isMember">
          <PostCard v-for="post in posts" :key="post.id" :post="post" />
          <div v-if="posts.length === 0" class="empty-state">
            <div class="empty-icon">📝</div>
            <div class="empty-text">暂无帖子，快来发布第一个吧！</div>
          </div>
        </div>
        <div v-else class="empty-state">
          <div class="empty-icon">🔒</div>
          <div class="empty-text">加入社区后查看帖子</div>
        </div>
      </el-tab-pane>

      <el-tab-pane label="🎉 活动" name="activities">
        <div v-if="detail.isMember">
          <ActivityCard v-for="act in activities" :key="act.id" :activity="act" />
          <div v-if="activities.length === 0" class="empty-state">
            <div class="empty-icon">🎉</div>
            <div class="empty-text">暂无活动</div>
          </div>
        </div>
        <div v-else class="empty-state">
          <div class="empty-icon">🔒</div>
          <div class="empty-text">加入社区后查看活动</div>
        </div>
      </el-tab-pane>

      <el-tab-pane label="🔗 圈子" name="circles">
        <div v-if="circles.length === 0" class="empty-state">
          <div class="empty-icon">🔗</div>
          <div class="empty-text">暂无圈子</div>
        </div>
        <div v-else class="circle-grid">
          <div v-for="c in circles" :key="c.id" class="circle-card card card-hover"
               @click="$router.push(`/circle/${c.id}`)">
            <div class="circle-name">{{ c.name }}</div>
            <div class="circle-meta">
              <el-tag size="small" :type="c.type === 1 ? 'danger' : 'info'" round>
                {{ c.type === 1 ? '🔒 私密' : '🌐 公开' }}
              </el-tag>
              <span>👥 {{ c.maxNum }}人上限</span>
            </div>
          </div>
        </div>
      </el-tab-pane>

      <el-tab-pane label="👑 管理员" name="managers">
        <div class="manager-grid">
          <div v-for="m in detail.managers" :key="m.userId" class="manager-card card">
            <div class="manager-avatar">{{ m.nickname?.charAt(0) || '?' }}</div>
            <div class="manager-name">{{ m.nickname }}</div>
            <el-tag size="small" :type="m.role === 1 ? 'primary' : 'info'" round>
              {{ m.role === 1 ? '👑 主管理员' : '🔧 副管理员' }}
            </el-tag>
          </div>
        </div>
      </el-tab-pane>
    </el-tabs>

    <!-- Create Circle Dialog -->
    <el-dialog v-model="showCreateCircle" title="创建圈子" width="420px" :close-on-click-modal="false"
               class="dialog-modern">
      <el-form :model="circleForm" label-position="top">
        <el-form-item label="圈子名称">
          <el-input v-model="circleForm.name" placeholder="给圈子取个名字" size="large" />
        </el-form-item>
        <el-form-item label="圈子类型">
          <el-radio-group v-model="circleForm.type" class="w-full">
            <el-radio-button :value="0">🌐 公开圈子</el-radio-button>
            <el-radio-button :value="1">🔒 私密圈子</el-radio-button>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="showCreateCircle = false">取消</el-button>
        <el-button type="primary" @click="handleCreateCircle" round>创建圈子</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Loading, ArrowLeft } from '@element-plus/icons-vue'
import { getSecondDetail, joinCommunity, applyCommunity } from '@/api/community'
import { getCircleList, createCircle } from '@/api/circle'
import { getPostPage } from '@/api/post'
import { getActivityPage } from '@/api/activity'
import { useUserStore } from '@/stores/userStore'
import type { CommunityDetail, CircleInfo, PostInfo, ActivityInfo } from '@/types'
import PostCard from '@/components/PostCard/index.vue'
import ActivityCard from '@/components/ActivityCard/index.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const communityId = Number(route.params.id)
const loading = ref(true)
const detail = ref<CommunityDetail | null>(null)
const circles = ref<CircleInfo[]>([])
const posts = ref<PostInfo[]>([])
const activities = ref<ActivityInfo[]>([])
const activeTab = ref('posts')
const showCreateCircle = ref(false)
const circleForm = ref({ name: '', type: 0 })

const gradients = ['#6366f1', '#8b5cf6', '#ec4899', '#f43f5e', '#f59e0b', '#10b981', '#06b6d4', '#3b82f6']
const bannerGradient = `linear-gradient(135deg, ${gradients[communityId % gradients.length]}, ${gradients[(communityId + 1) % gradients.length]})`

async function loadAll() {
  loading.value = true
  try {
    const [detailRes, circleRes] = await Promise.all([
      getSecondDetail(communityId),
      getCircleList(communityId),
    ])
    detail.value = detailRes.data.data
    circles.value = circleRes.data.data
    await loadTabData(activeTab.value)
  } finally { loading.value = false }
}

async function loadTabData(tab?: string) {
  const t = tab || activeTab.value
  if (t === 'posts' && detail.value?.isMember) {
    const res = await getPostPage({ communityId, page: 1, size: 10 })
    posts.value = res.data.data.records
  } else if (t === 'activities' && detail.value?.isMember) {
    const res = await getActivityPage({ communityId, page: 1, size: 10 })
    activities.value = res.data.data.records
  }
}

async function handleJoin() {
  if (!userStore.isLoggedIn) { router.push('/login'); return }
  try {
    if (detail.value?.community.joinType === 1) {
      await applyCommunity({ communityId })
      ElMessage.success('申请已提交，请等待管理员审核')
    } else {
      await joinCommunity(communityId)
      ElMessage.success('🎉 加入成功')
      const res = await getSecondDetail(communityId)
      detail.value = res.data.data
    }
  } catch (e) { /* handled */ }
}

async function handleCreateCircle() {
  try {
    await createCircle({ communityId, name: circleForm.value.name, type: circleForm.value.type })
    ElMessage.success('圈子创建成功')
    showCreateCircle.value = false
    circleForm.value = { name: '', type: 0 }
    const res = await getCircleList(communityId)
    circles.value = res.data.data
  } catch (e) { /* handled */ }
}

onMounted(loadAll)
</script>

<style scoped>
.loading-wrap {
  display: flex; flex-direction: column; align-items: center; justify-content: center;
  padding: 80px 20px; gap: 16px; color: var(--text-muted);
}

.community-banner {
  border-radius: 20px;
  padding: 32px 36px;
  color: #fff;
  position: relative;
  overflow: hidden;
}
.community-banner::after {
  content: '';
  position: absolute; inset: 0;
  background: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cg fill='none' fill-rule='evenodd'%3E%3Cg fill='%23ffffff' fill-opacity='0.05'%3E%3Cpath d='M36 34v-4h-2v4h-4v2h4v4h2v-4h4v-2h-4zm0-30V0h-2v4h-4v2h4v4h2V6h4V4h-4zM6 34v-4H4v4H0v2h4v4h2v-4h4v-2H6zM6 4V0H4v4H0v2h4v4h2V6h4V4H6z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
}
.banner-content { position: relative; z-index: 1; }
.banner-top { display: flex; align-items: center; gap: 20px; margin-bottom: 12px; }
.banner-icon {
  width: 64px; height: 64px;
  border-radius: 18px;
  background: rgba(255,255,255,0.2);
  backdrop-filter: blur(10px);
  display: flex;
  align-items: center; justify-content: center;
  font-size: 28px; font-weight: 700;
  flex-shrink: 0;
  border: 1px solid rgba(255,255,255,0.3);
}
.banner-title { font-size: 26px; font-weight: 700; margin-bottom: 4px; }
.banner-meta { display: flex; gap: 12px; font-size: 13px; opacity: 0.85; flex-wrap: wrap; align-items: center; }
.banner-desc { font-size: 14px; opacity: 0.8; margin-bottom: 20px; line-height: 1.6; }
.banner-actions { display: flex; gap: 8px; flex-wrap: wrap; }

.join-btn {
  background: rgba(255,255,255,0.2) !important;
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255,255,255,0.3) !important;
  color: #fff !important;
  font-weight: 600;
}
.join-btn:hover { background: rgba(255,255,255,0.3) !important; }
.joined-tag {
  background: rgba(255,255,255,0.2) !important;
  border: 1px solid rgba(255,255,255,0.3) !important;
  color: #fff !important;
  font-size: 14px;
  padding: 8px 16px;
}
.action-btn {
  background: rgba(255,255,255,0.15) !important;
  border: 1px solid rgba(255,255,255,0.2) !important;
  color: #fff !important;
}
.action-btn:hover { background: rgba(255,255,255,0.25) !important; }

.content-tabs { margin-top: 20px; }
.content-tabs :deep(.el-tabs__header) { margin-bottom: 20px; }
.content-tabs :deep(.el-tabs__nav-wrap::after) { height: 1px; background: var(--border); }
.content-tabs :deep(.el-tabs__item) {
  font-size: 15px; font-weight: 500;
  padding: 0 20px; height: 44px; line-height: 44px;
}
.content-tabs :deep(.el-tabs__item.is-active) { color: var(--primary); font-weight: 600; }
.content-tabs :deep(.el-tabs__active-bar) { background: var(--primary); height: 3px; border-radius: 2px; }

.circle-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 14px; }
.circle-card { display: flex; flex-direction: column; gap: 8px; }
.circle-name { font-size: 16px; font-weight: 600; }
.circle-meta { display: flex; align-items: center; gap: 12px; font-size: 13px; color: var(--text-muted); }

.manager-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(180px, 1fr)); gap: 16px; }
.manager-card { text-align: center; padding: 24px; }
.manager-avatar {
  width: 48px; height: 48px;
  border-radius: 50%;
  background: linear-gradient(135deg, var(--primary-bg), #ede9fe);
  color: var(--primary);
  display: flex; align-items: center; justify-content: center;
  font-size: 20px; font-weight: 700;
  margin: 0 auto 10px;
}
.manager-name { font-size: 14px; font-weight: 600; margin-bottom: 6px; }

.back-nav { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; }
.back-nav :deep(.el-button) { color: var(--text-muted); font-size: 13px; }
.back-nav :deep(.el-button:hover) { color: var(--primary); }
.back-title { font-size: 13px; color: var(--text-muted); }

.dialog-modern :deep(.el-dialog__header) { padding: 24px 24px 0; font-weight: 700; }
.dialog-modern :deep(.el-dialog__body) { padding: 20px 24px; }
.dialog-modern :deep(.el-dialog__footer) { padding: 0 24px 24px; }
</style>
