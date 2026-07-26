<template>
  <div v-if="loading" class="loading-wrap">
    <el-icon class="is-loading" :size="40" color="var(--primary)"><Loading /></el-icon>
    <p>加载帖子...</p>
  </div>
  <div v-else-if="post" class="post-detail">
    <!-- Back button -->
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">帖子详情</span>
    </div>
    <!-- Post header -->
    <div class="card post-header-card">
      <div class="post-author-row">
        <div class="author-avatar">{{ post.userId?.toString().slice(-1) || '?' }}</div>
        <div>
          <div class="author-name">用户 {{ post.userId }}</div>
          <div class="author-time">{{ formatTime(post.createTime) }}</div>
        </div>
        <el-tag v-if="post.isTop" class="top-tag" size="small">📌 置顶</el-tag>
        <el-tag v-if="post.scope === 1" class="public-tag" size="small">🌐 全站公开</el-tag>
        <span v-if="post.city" class="author-location">📍 {{ post.city }}</span>
      </div>
      <h1 class="post-title">{{ post.title }}</h1>
      <div class="post-content-text">{{ post.content }}</div>

      <!-- Tags -->
      <div class="post-tags" v-if="post.tags">
        <span v-for="tag in post.tags.split(',')" :key="tag" class="tag-item">{{ tag.trim() }}</span>
      </div>

      <!-- Info bar -->
      <div class="post-info-row">
        <div class="info-items">
          <span>💰 {{ post.budget ? '¥' + post.budget : '预算不限' }}</span>
          <span v-if="post.peopleNum">👥 {{ post.peopleNum }}人</span>
          <span v-if="post.address">📍 {{ post.address }}</span>
        </div>
      </div>

      <!-- Action bar -->
      <div class="post-actions">
        <button class="action-btn" :class="{ liked }" @click="handleLike">
          <span class="action-icon">{{ liked ? '❤️' : '🤍' }}</span>
          <span>{{ post.likeCount }}</span>
        </button>
        <button class="action-btn">
          <span class="action-icon">💬</span>
          <span>{{ post.commentCount }}</span>
        </button>
        <button class="action-btn">
          <span class="action-icon">👁️</span>
          <span>{{ post.viewCount }}</span>
        </button>
        <div class="action-spacer"></div>
        <el-button v-if="isOwner" class="top-btn" size="small" round @click="showTopDialog = true">
          📌 付费置顶
        </el-button>
        <el-button v-if="isOwner" size="small" round type="danger" plain @click="handleDelete">
          🗑️ 删除
        </el-button>
      </div>
    </div>

    <!-- Comments -->
    <div class="card comments-card mt-20">
      <h3 class="comments-title">💬 评论 ({{ post.commentCount }})</h3>
      <div v-if="userStore.isLoggedIn" class="comment-input-wrap">
        <el-input v-model="commentContent" placeholder="写下你的看法..." size="large"
                  class="comment-input" @keyup.enter="handleComment" />
        <el-button class="btn-gradient" @click="handleComment" round>发表</el-button>
      </div>
      <div v-for="c in comments" :key="c.id" class="comment-item">
        <div class="comment-avatar">{{ c.userId?.toString().slice(-1) || '?' }}</div>
        <div class="comment-body">
          <div class="comment-user">用户 {{ c.userId }}</div>
          <div class="comment-text">{{ c.content }}</div>
          <div class="comment-time">{{ formatRelativeTime(c.createTime) }}</div>
        </div>
      </div>
      <div v-if="comments.length === 0" class="empty-state" style="padding: 30px;">
        <div class="empty-text" style="color: var(--text-muted);">暂无评论，来说两句吧～</div>
      </div>
    </div>

    <!-- Top dialog -->
    <el-dialog v-model="showTopDialog" title="📌 帖子置顶" width="420px" class="dialog-modern" :close-on-click-modal="false">
      <div class="top-options">
        <div class="top-option" :class="{ active: topType === 0 }" @click="topType = 0">
          <div class="option-icon">🏘️</div>
          <div class="option-info">
            <div class="option-name">社区置顶</div>
            <div class="option-price">¥5 / 24小时</div>
          </div>
          <div class="option-check" v-if="topType === 0">✓</div>
        </div>
        <div class="top-option" :class="{ active: topType === 1 }" @click="topType = 1">
          <div class="option-icon">🌐</div>
          <div class="option-info">
            <div class="option-name">全站置顶</div>
            <div class="option-price">¥15 / 24小时</div>
          </div>
          <div class="option-check" v-if="topType === 1">✓</div>
        </div>
      </div>
      <template #footer>
        <el-button @click="showTopDialog = false">取消</el-button>
        <el-button type="primary" @click="handleTop" round>确认支付</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Loading, ArrowLeft } from '@element-plus/icons-vue'
import { getPostDetail, likePost, unlikePost, addComment, getComments, topPost, deletePost } from '@/api/post'
import { useUserStore } from '@/stores/userStore'
import type { PostInfo, PostComment } from '@/types'
import { formatTime, formatRelativeTime } from '@/utils/format'

const route = useRoute()
const userStore = useUserStore()
const postId = Number(route.params.id)
const loading = ref(true)
const post = ref<PostInfo | null>(null)
const comments = ref<PostComment[]>([])
const liked = ref(false)
const commentContent = ref('')
const showTopDialog = ref(false)
const topType = ref(0)
const isOwner = computed(() => userStore.userInfo?.id === post.value?.userId)

async function load() {
  loading.value = true
  try {
    const [postRes, commentRes] = await Promise.all([getPostDetail(postId), getComments(postId)])
    post.value = postRes.data.data
    comments.value = commentRes.data.data.records
  } finally { loading.value = false }
}

async function handleLike() {
  if (!userStore.isLoggedIn) return
  try {
    if (liked.value) { await unlikePost(postId); liked.value = false; if (post.value) post.value.likeCount-- }
    else { await likePost(postId); liked.value = true; if (post.value) post.value.likeCount++ }
  } catch (e) { /* handled */ }
}

async function handleComment() {
  if (!commentContent.value) return
  try {
    await addComment(postId, commentContent.value)
    ElMessage.success('评论成功')
    commentContent.value = ''
    const res = await getComments(postId)
    comments.value = res.data.data.records
    if (post.value) post.value.commentCount = comments.value.length
  } catch (e) { /* handled */ }
}

async function handleTop() {
  try { await topPost({ postId, topType: topType.value }); ElMessage.success('置顶成功'); showTopDialog.value = false }
  catch (e) { /* handled */ }
}

async function handleDelete() {
  try { await deletePost(postId); ElMessage.success('已删除'); window.history.back() }
  catch (e) { /* handled */ }
}

onMounted(load)
</script>

<style scoped>
.loading-wrap { display: flex; flex-direction: column; align-items: center; padding: 80px 20px; gap: 16px; color: var(--text-muted); }
.back-nav { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; }
.back-nav :deep(.el-button) { color: var(--text-muted); font-size: 13px; }
.back-nav :deep(.el-button:hover) { color: var(--primary); }
.back-title { font-size: 13px; color: var(--text-muted); }
.post-header-card { padding: 28px; }
.post-author-row { display: flex; align-items: center; gap: 12px; margin-bottom: 16px; flex-wrap: wrap; }
.author-avatar {
  width: 44px; height: 44px; border-radius: 14px;
  background: linear-gradient(135deg, var(--primary-bg), #ede9fe);
  color: var(--primary); display: flex; align-items: center; justify-content: center;
  font-size: 18px; font-weight: 700;
}
.author-name { font-size: 14px; font-weight: 600; }
.author-time { font-size: 12px; color: var(--text-muted); }
.author-location { margin-left: auto; font-size: 13px; color: var(--text-muted); }
.top-tag { background: linear-gradient(135deg, #fef3c7, #fde68a) !important; border: none !important; color: #92400e !important; }
.public-tag { background: rgba(16,185,129,0.1) !important; border: none !important; color: #059669 !important; }
.post-title { font-size: 22px; font-weight: 700; margin-bottom: 12px; line-height: 1.4; }
.post-content-text { font-size: 15px; line-height: 1.8; color: var(--text-secondary); margin-bottom: 16px; white-space: pre-wrap; }
.post-tags { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 16px; }
.tag-item { padding: 4px 12px; border-radius: 20px; background: var(--primary-bg); color: var(--primary); font-size: 13px; font-weight: 500; }
.post-info-row { display: flex; gap: 16px; color: var(--text-muted); font-size: 13px; margin-bottom: 16px; flex-wrap: wrap; }
.info-items { display: flex; gap: 16px; flex-wrap: wrap; }
.post-actions { display: flex; align-items: center; gap: 8px; border-top: 1px solid var(--border); padding-top: 16px; }
.action-btn {
  display: flex; align-items: center; gap: 6px;
  padding: 8px 16px; border-radius: 10px;
  border: none; background: transparent;
  cursor: pointer; font-size: 14px; color: var(--text-secondary);
  transition: var(--transition); font-family: inherit;
}
.action-btn:hover { background: #f1f5f9; }
.action-btn.liked { color: #ef4444; }
.action-icon { font-size: 16px; }
.action-spacer { flex: 1; }
.top-btn { background: linear-gradient(135deg, #fef3c7, #fde68a) !important; border: none !important; color: #92400e !important; }

.comments-card { padding: 24px 28px; }
.comments-title { font-size: 17px; font-weight: 600; margin-bottom: 16px; }
.comment-input-wrap { display: flex; gap: 12px; margin-bottom: 20px; }
.comment-input { flex: 1; }
.comment-input :deep(.el-input__wrapper) { border-radius: 12px !important; }
.comment-item { display: flex; gap: 12px; padding: 16px 0; border-bottom: 1px solid #f1f5f9; }
.comment-item:last-child { border-bottom: none; }
.comment-avatar {
  width: 36px; height: 36px; border-radius: 10px;
  background: var(--primary-bg); color: var(--primary);
  display: flex; align-items: center; justify-content: center;
  font-size: 14px; font-weight: 600; flex-shrink: 0;
}
.comment-body { flex: 1; }
.comment-user { font-size: 13px; font-weight: 600; margin-bottom: 2px; }
.comment-text { font-size: 14px; color: var(--text-secondary); line-height: 1.5; }
.comment-time { font-size: 12px; color: var(--text-muted); margin-top: 4px; }

.top-options { display: flex; flex-direction: column; gap: 12px; }
.top-option {
  display: flex; align-items: center; gap: 14px;
  padding: 16px; border-radius: 14px;
  border: 2px solid var(--border); cursor: pointer;
  transition: var(--transition);
}
.top-option:hover { border-color: var(--primary-light); }
.top-option.active { border-color: var(--primary); background: var(--primary-bg); }
.option-icon { font-size: 24px; }
.option-name { font-weight: 600; font-size: 15px; }
.option-price { font-size: 13px; color: var(--text-muted); }
.option-check { margin-left: auto; width: 24px; height: 24px; border-radius: 50%; background: var(--primary); color: #fff; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; }
.dialog-modern :deep(.el-dialog__header) { padding: 24px 24px 0; font-weight: 700; }
.dialog-modern :deep(.el-dialog__body) { padding: 20px 24px; }
.dialog-modern :deep(.el-dialog__footer) { padding: 0 24px 24px; }
</style>
