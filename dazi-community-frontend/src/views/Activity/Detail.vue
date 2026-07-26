<template>
  <div v-if="loading" class="text-center" style="padding: 40px">
    <el-icon class="is-loading" :size="32"><Loading /></el-icon>
  </div>
  <div v-else-if="activity" class="activity-detail">
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">活动详情</span>
    </div>
    <div class="card">
      <h2>{{ activity.title }}</h2>
      <div class="activity-info mt-10">
        <p>📍 {{ activity.address || '待定' }}</p>
        <p>🕐 {{ formatTime(activity.startTime) }} ~ {{ formatTime(activity.endTime) }}</p>
        <p>👥 最多 {{ activity.maxPeople || '不限' }}人</p>
        <p>💰 {{ formatPrice(activity.fee) }}</p>
        <p>📋 {{ activity.content }}</p>
      </div>
      <el-tag :type="activity.auditStatus === 1 ? 'success' : 'warning'" class="mt-10">
        {{ auditStatusText(activity.auditStatus) }}
      </el-tag>
      <div class="mt-20">
        <el-button v-if="activity.auditStatus === 1 && userStore.isLoggedIn" type="primary" @click="handleSignUp">
          立即报名 ({{ formatPrice(activity.fee) }})
        </el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Loading, ArrowLeft } from '@element-plus/icons-vue'
import { getActivityDetail, signUpActivity } from '@/api/activity'
import { useUserStore } from '@/stores/userStore'
import type { ActivityInfo } from '@/types'
import { formatTime, formatPrice, auditStatusText } from '@/utils/format'

const route = useRoute()
const userStore = useUserStore()
const activityId = Number(route.params.id)
const loading = ref(true)
const activity = ref<ActivityInfo | null>(null)

async function load() {
  loading.value = true
  try {
    const res = await getActivityDetail(activityId)
    activity.value = res.data.data
  } finally {
    loading.value = false
  }
}

async function handleSignUp() {
  try {
    await signUpActivity(activityId)
    ElMessage.success('报名成功')
  } catch (e) { /* handled */ }
}

onMounted(load)
</script>

<style scoped>
.activity-info p { margin: 8px 0; color: #555; }
</style>
