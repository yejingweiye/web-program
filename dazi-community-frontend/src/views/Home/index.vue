<template>
  <div class="home-page">
    <!-- Hero banner -->
    <div class="hero-banner">
      <div class="hero-content">
        <h1 class="hero-title">找到你的<span class="gradient-text">同城搭子</span></h1>
        <p class="hero-desc">加入兴趣社区，认识志同道合的朋友</p>
        <div class="hero-stats">
          <div class="stat-item" v-if="stats">
            <span class="stat-num">{{ stats.totalCommunities }}</span>
            <span class="stat-label">个社区</span>
          </div>
          <div class="stat-divider"></div>
          <div class="stat-item" v-if="stats">
            <span class="stat-num">{{ stats.totalUsers }}</span>
            <span class="stat-label">位搭子</span>
          </div>
        </div>
      </div>
      <div class="hero-illustration">
        <div class="floating-icons">
          <span class="float-icon icon-1">📚</span>
          <span class="float-icon icon-2">⚽</span>
          <span class="float-icon icon-3">🏔️</span>
          <span class="float-icon icon-4">🍜</span>
          <span class="float-icon icon-5">🎮</span>
          <span class="float-icon icon-6">💼</span>
        </div>
      </div>
    </div>

    <!-- Category pills - scrollable -->
    <div class="category-section">
      <div class="section-header">
        <h3 class="section-title">社区分类</h3>
        <span class="category-hint">选择你感兴趣的分类</span>
      </div>
      <div class="category-scroll">
        <div class="category-list">
          <button v-for="cat in categories" :key="cat.id" class="category-pill"
                  :class="{ active: selectedFirstId === cat.id }"
                  @click="selectCategory(cat.id)">
            <span class="pill-icon">{{ catIcons[cat.id] || '#' }}</span>
            <span>{{ cat.name }}</span>
          </button>
          <button class="category-pill all-btn" :class="{ active: selectedFirstId === 0 }"
                  @click="selectCategory(0)">
            <span class="pill-icon">✨</span>
            <span>全部</span>
          </button>
        </div>
      </div>
    </div>

    <!-- Sub-communities grid -->
    <div class="section-header mt-24">
      <h3 class="section-title">同城社区</h3>
      <div class="header-actions">
        <el-button class="btn-gradient" size="small" @click="$router.push('/community/create')" round>
          ＋ 创建社区
        </el-button>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="community-grid">
      <div v-for="i in 6" :key="i" class="skeleton-card">
        <div class="skeleton skeleton-title"></div>
        <div class="skeleton skeleton-meta"></div>
        <div class="skeleton skeleton-desc"></div>
      </div>
    </div>

    <!-- Empty -->
    <div v-else-if="communities.length === 0" class="empty-state">
      <div class="empty-icon">🏘️</div>
      <div class="empty-text">暂无社区，快去创建第一个吧！</div>
    </div>

    <!-- Community grid -->
    <div v-else class="community-grid">
      <div v-for="item in communities" :key="item.id" class="community-card card card-hover"
           @click="$router.push(`/community/${item.id}`)">
        <div class="card-top">
          <div class="community-icon" :style="{ background: getGradient(item.id) }">
            {{ item.name.charAt(0) }}
          </div>
          <div class="community-info">
            <div class="community-name text-ellipsis">{{ item.name }}</div>
            <div class="community-meta">
              <span>📍 {{ item.city || '同城' }}</span>
              <span>👥 {{ item.memberCount }}人</span>
            </div>
          </div>
        </div>
        <div class="community-desc">{{ item.description || '暂无简介' }}</div>
        <div class="card-footer">
          <el-tag size="small" :type="item.joinType === 1 ? 'warning' : 'success'" round effect="plain">
            {{ item.joinType === 1 ? '审核加入' : '自由加入' }}
          </el-tag>
          <span class="footer-time">{{ formatRelativeTime(item.createTime) }}</span>
        </div>
      </div>
    </div>

    <!-- Public posts section -->
    <div class="section-header mt-24">
      <h3 class="section-title">全站公开帖子</h3>
    </div>
    <PostCard v-for="post in publicPosts" :key="post.id" :post="post" />
    <div v-if="publicPosts.length === 0" class="empty-state">
      <div class="empty-icon">📝</div>
      <div class="empty-text">暂无公开帖子</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Loading } from '@element-plus/icons-vue'
import { getFirstLevelList, getSecondLevelPage } from '@/api/community'
import { getPublicPosts } from '@/api/post'
import { getDashboard } from '@/api/admin'
import type { CommunityFirst, CommunitySecond, PostInfo, DashboardStats } from '@/types'
import PostCard from '@/components/PostCard/index.vue'
import { formatRelativeTime } from '@/utils/format'

const categories = ref<CommunityFirst[]>([])
const communities = ref<CommunitySecond[]>([])
const publicPosts = ref<PostInfo[]>([])
const stats = ref<DashboardStats | null>(null)
const selectedFirstId = ref(0)
const loading = ref(false)

const catIcons: Record<number, string> = { 1: '📚', 2: '⚽', 3: '🏔️', 4: '🍜', 5: '🎮', 6: '💼' }
const gradients = ['#6366f1', '#8b5cf6', '#ec4899', '#f43f5e', '#f59e0b', '#10b981', '#06b6d4', '#3b82f6']

function getGradient(id: number) { return gradients[id % gradients.length] }

async function loadAll() {
  loading.value = true
  try {
    const [catRes, statsRes] = await Promise.all([
      getFirstLevelList(),
      getDashboard().catch(() => ({ data: { data: null } })),
    ])
    categories.value = catRes.data.data
    stats.value = statsRes.data.data
    await Promise.all([loadCommunities(), loadPublicPosts()])
  } finally { loading.value = false }
}

async function loadCommunities() {
  const res = await getSecondLevelPage({ firstId: selectedFirstId.value || undefined, page: 1, size: 20 })
  communities.value = res.data.data.records
}

async function loadPublicPosts() {
  const res = await getPublicPosts(1, 5)
  publicPosts.value = res.data.data.records
}

function selectCategory(id: number) {
  selectedFirstId.value = id
  loadCommunities()
}

onMounted(loadAll)
</script>

<style scoped>
/* Hero Banner */
.hero-banner {
  background: linear-gradient(135deg, #1e1b4b 0%, #312e81 50%, #1e1b4b 100%);
  border-radius: 20px;
  padding: 40px 48px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 28px;
  position: relative;
  overflow: hidden;
}
.hero-banner::before {
  content: '';
  position: absolute;
  inset: 0;
  background: radial-gradient(ellipse at top right, rgba(99,102,241,0.3), transparent 60%),
              radial-gradient(ellipse at bottom left, rgba(139,92,246,0.3), transparent 60%);
}
.hero-content { position: relative; z-index: 1; }
.hero-title { font-size: 32px; font-weight: 800; color: #fff; margin-bottom: 8px; }
.hero-desc { color: rgba(255,255,255,0.6); font-size: 15px; margin-bottom: 20px; }
.hero-stats { display: flex; align-items: center; gap: 16px; }
.stat-item { display: flex; align-items: baseline; gap: 4px; }
.stat-num { font-size: 24px; font-weight: 800; color: #fff; }
.stat-label { font-size: 13px; color: rgba(255,255,255,0.5); }
.stat-divider { width: 1px; height: 28px; background: rgba(255,255,255,0.2); }

.hero-illustration { position: relative; z-index: 1; }
.floating-icons { position: relative; width: 200px; height: 160px; }
.float-icon {
  position: absolute;
  font-size: 32px;
  animation: float 3s ease-in-out infinite;
  opacity: 0.9;
}
.icon-1 { top: 0; left: 20px; animation-delay: 0s; }
.icon-2 { top: 30px; right: 10px; animation-delay: 0.5s; font-size: 28px; }
.icon-3 { top: 60px; left: 0; animation-delay: 1s; font-size: 36px; }
.icon-4 { bottom: 10px; right: 30px; animation-delay: 1.5s; }
.icon-5 { bottom: 40px; left: 40px; animation-delay: 2s; font-size: 26px; }
.icon-6 { top: 10px; right: 40px; animation-delay: 2.5s; }

/* Category pills */
.category-section { margin-bottom: 8px; }
.category-scroll { overflow-x: auto; -webkit-overflow-scrolling: touch; }
.category-list { display: flex; gap: 10px; padding-bottom: 8px; }
.category-pill {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 20px;
  border-radius: 100px;
  border: 1.5px solid var(--border);
  background: var(--bg-card);
  cursor: pointer;
  transition: var(--transition);
  white-space: nowrap;
  font-size: 14px;
  color: var(--text-secondary);
  font-family: inherit;
}
.category-pill:hover {
  border-color: var(--primary-light);
  color: var(--primary);
  background: var(--primary-bg);
}
.category-pill.active {
  background: linear-gradient(135deg, var(--primary), var(--secondary));
  border-color: transparent;
  color: #fff;
  box-shadow: 0 4px 14px rgba(99,102,241,0.35);
}
.pill-icon { font-size: 16px; }
.category-hint { font-size: 13px; color: var(--text-muted); }

/* Community grid */
.community-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
}
.community-card { overflow: hidden; }
.card-top { display: flex; align-items: center; gap: 14px; margin-bottom: 12px; }
.community-icon {
  width: 48px; height: 48px;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: 700;
  color: #fff;
  flex-shrink: 0;
}
.community-info { flex: 1; min-width: 0; }
.community-name { font-size: 16px; font-weight: 600; margin-bottom: 2px; }
.community-meta { display: flex; gap: 12px; color: var(--text-muted); font-size: 13px; }
.community-desc {
  color: var(--text-secondary);
  font-size: 13px;
  margin-bottom: 12px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.card-footer { display: flex; align-items: center; justify-content: space-between; }
.footer-time { font-size: 12px; color: var(--text-muted); }

/* Skeleton */
.skeleton-card {
  background: var(--bg-card);
  border-radius: var(--radius);
  padding: 20px;
  border: 1px solid var(--border);
}
.skeleton-title { height: 20px; width: 60%; margin-bottom: 12px; }
.skeleton-meta { height: 14px; width: 40%; margin-bottom: 12px; }
.skeleton-desc { height: 14px; width: 80%; }

.header-actions { display: flex; gap: 8px; }

@media (max-width: 768px) {
  .hero-banner { padding: 28px 24px; flex-direction: column; text-align: center; }
  .hero-title { font-size: 24px; }
  .hero-illustration { display: none; }
  .hero-stats { justify-content: center; }
  .community-grid { grid-template-columns: 1fr; }
}
</style>
