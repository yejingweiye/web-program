<template>
  <div>
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">我的帖子</span>
    </div>
    <div class="flex-between mb-20">
      <h2>我的帖子</h2>
      <el-button type="primary" @click="$router.push('/post/create')">发帖</el-button>
    </div>
    <PostCard v-for="post in posts" :key="post.id" :post="post" />
    <div v-if="loading" class="text-center" style="padding: 40px">
      <el-icon class="is-loading" :size="32"><Loading /></el-icon>
    </div>
    <div v-else-if="posts.length === 0" class="text-center card" style="padding: 40px; color: #999;">
      还没有发过帖子
    </div>
    <div v-if="hasMore" class="text-center mt-20">
      <el-button @click="loadMore">加载更多</el-button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Loading, ArrowLeft } from '@element-plus/icons-vue'
import { getMyPosts } from '@/api/post'
import type { PostInfo } from '@/types'
import PostCard from '@/components/PostCard/index.vue'

const posts = ref<PostInfo[]>([])
const loading = ref(false)
const page = ref(1)
const hasMore = ref(true)

async function load() {
  loading.value = true
  try {
    const res = await getMyPosts(page.value)
    posts.value.push(...res.data.data.records)
    hasMore.value = res.data.data.records.length === 10
  } finally {
    loading.value = false
  }
}

function loadMore() {
  page.value++
  load()
}

onMounted(load)
</script>
