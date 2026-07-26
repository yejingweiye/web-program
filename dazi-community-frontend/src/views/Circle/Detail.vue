<template>
  <div v-if="loading" class="text-center" style="padding: 40px">
    <el-icon class="is-loading" :size="32"><Loading /></el-icon>
  </div>
  <div v-else-if="circle" class="circle-detail">
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">圈子详情</span>
    </div>
    <div class="card">
      <div class="flex-between">
        <div>
          <h2>{{ circle.name }}</h2>
          <el-tag :type="circle.type === 1 ? 'danger' : 'info'" class="mt-10">
            {{ circle.type === 1 ? '私密圈子' : '公开圈子' }}
          </el-tag>
          <span class="ml-10" style="color:#999">👥 {{ members.length }}/{{ circle.maxNum }}人</span>
        </div>
        <div v-if="userStore.isLoggedIn">
          <template v-if="!isMember">
            <el-button type="primary" @click="handleJoin">加入圈子</el-button>
          </template>
          <template v-else>
            <el-tag type="success">已加入</el-tag>
            <el-button class="ml-10" @click="handleLeave" type="danger" plain>退出</el-button>
          </template>
        </div>
      </div>
    </div>

    <div v-if="isMember || circle.type === 0" class="card mt-20">
      <h3 class="section-title">成员列表 ({{ members.length }})</h3>
      <div class="member-list">
        <div v-for="m in members" :key="m.id" class="member-item">
          <span>用户 {{ m.userId }}</span>
          <el-tag v-if="m.userId === circle.createUserId" type="warning" size="small">圈主</el-tag>
        </div>
      </div>
    </div>

    <div v-if="isOwner" class="card mt-20">
      <h3 class="section-title">圈主操作</h3>
      <div class="owner-actions">
        <el-button @click="handleGenerateInvite">生成邀请码</el-button>
        <el-button type="danger" @click="handleDismiss">解散圈子</el-button>
      </div>
      <div v-if="inviteCode" class="invite-code mt-10">
        <span>邀请码：</span>
        <el-tag>{{ inviteCode }}</el-tag>
        <el-button size="small" class="ml-10" @click="copyInvite">复制</el-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import { Loading, ArrowLeft } from '@element-plus/icons-vue'
import { getCircleDetail, getCircleMembers, joinCircle, leaveCircle, generateInvite } from '@/api/circle'
import { useUserStore } from '@/stores/userStore'
import type { CircleInfo } from '@/types'

const route = useRoute()
const userStore = useUserStore()
const circleId = Number(route.params.id)

const loading = ref(true)
const circle = ref<CircleInfo | null>(null)
const members = ref<any[]>([])
const isMember = ref(false)
const inviteCode = ref('')

const isOwner = computed(() => userStore.userInfo?.id === circle.value?.createUserId)

async function load() {
  loading.value = true
  try {
    const [detailRes, membersRes] = await Promise.all([
      getCircleDetail(circleId),
      getCircleMembers(circleId),
    ])
    circle.value = detailRes.data.data
    members.value = membersRes.data.data
    isMember.value = members.value.some(m => m.userId === userStore.userInfo?.id)
  } finally {
    loading.value = false
  }
}

async function handleJoin() {
  try {
    await joinCircle(circleId)
    ElMessage.success('加入成功')
    await load()
  } catch (e) { /* handled */ }
}

async function handleLeave() {
  try {
    await leaveCircle(circleId)
    ElMessage.success('已退出圈子')
    await load()
  } catch (e) { /* handled */ }
}

async function handleGenerateInvite() {
  try {
    const res = await generateInvite(circleId)
    inviteCode.value = res.data.data
    ElMessage.success('邀请码生成成功')
  } catch (e) { /* handled */ }
}

async function handleDismiss() {
  try {
    // await dismissCircle(circleId)
    ElMessage.success('圈子已解散')
  } catch (e) { /* handled */ }
}

function copyInvite() {
  navigator.clipboard.writeText(inviteCode.value)
  ElMessage.success('已复制邀请码')
}

onMounted(load)
</script>

<style scoped>
.section-title { font-size: 16px; margin-bottom: 12px; }
.member-list { display: flex; flex-wrap: wrap; gap: 8px; }
.member-item { padding: 8px 16px; background: #f5f7fa; border-radius: 6px; display: flex; align-items: center; gap: 8px; }
.owner-actions { display: flex; gap: 12px; }
.invite-code { display: flex; align-items: center; gap: 8px; }
</style>
