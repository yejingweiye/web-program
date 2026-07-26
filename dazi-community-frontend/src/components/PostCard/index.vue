<template>
  <div class="post-card card card-hover" @click="$router.push(`/post/detail/${post.id}`)">
    <div class="post-row">
      <div class="post-main">
        <div class="post-header">
          <h3 class="post-title">{{ post.title }}</h3>
          <el-tag v-if="post.isTop" class="top-tag" size="small">📌 置顶</el-tag>
        </div>
        <div class="post-content" v-if="post.content">
          {{ post.content }}
        </div>
        <div class="post-tags" v-if="post.tags">
          <span v-for="tag in post.tags.split(',')" :key="tag" class="tag-item">{{ tag.trim() }}</span>
        </div>
        <div class="post-footer">
          <span class="footer-stat" title="浏览">👁 <em>{{ post.viewCount || 0 }}</em></span>
          <span class="footer-stat" title="点赞">❤️ <em>{{ post.likeCount || 0 }}</em></span>
          <span class="footer-stat" title="评论">💬 <em>{{ post.commentCount || 0 }}</em></span>
          <span class="footer-sep"></span>
          <span class="footer-info" v-if="post.city">📍 {{ post.city }}</span>
          <span class="footer-info" v-if="post.budget">💰 ¥{{ post.budget }}</span>
          <span class="footer-time">{{ formatRelativeTime(post.createTime) }}</span>
        </div>
      </div>
      <div class="post-avatar-col hide-mobile">
        <div class="post-author-icon">{{ post.userId?.toString().slice(-1) || '?' }}</div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { PostInfo } from '@/types'
import { formatRelativeTime } from '@/utils/format'

defineProps<{ post: PostInfo }>()
</script>

<style scoped>
.post-card { margin-bottom: 14px; }
.post-row { display: flex; gap: 16px; }
.post-main { flex: 1; min-width: 0; }

.post-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 6px;
}
.post-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text);
  line-height: 1.4;
}
.top-tag {
  background: linear-gradient(135deg, #fef3c7, #fde68a) !important;
  border: none !important;
  color: #92400e !important;
  font-weight: 600;
  flex-shrink: 0;
}

.post-content {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 10px;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.6;
}

.post-tags { display: flex; flex-wrap: wrap; gap: 6px; margin-bottom: 10px; }
.tag-item {
  font-size: 12px;
  padding: 3px 10px;
  border-radius: 20px;
  background: var(--primary-bg);
  color: var(--primary);
  font-weight: 500;
}

.post-footer {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 13px;
  color: var(--text-muted);
}
.footer-stat { display: flex; align-items: center; gap: 3px; cursor: default; }
.footer-stat em { font-style: normal; font-weight: 500; }
.footer-sep { width: 1px; height: 14px; background: var(--border); }
.footer-info { color: var(--text-muted); }
.footer-time { margin-left: auto; font-size: 12px; }

.post-avatar-col {
  display: flex;
  align-items: flex-start;
  padding-top: 2px;
}
.post-author-icon {
  width: 40px; height: 40px;
  border-radius: 12px;
  background: linear-gradient(135deg, #e0e7ff, #c7d2fe);
  color: var(--primary);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 16px;
  font-weight: 700;
}
</style>
