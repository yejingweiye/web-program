<template>
  <div class="admin-page">
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">管理后台</span>
    </div>
    <!-- Header -->
    <div class="admin-header">
      <div>
        <h1 class="admin-title">⚙️ 管理后台</h1>
        <p class="admin-desc">平台运营数据概览</p>
      </div>
      <el-tag round size="large" v-if="stats">最后更新: {{ new Date().toLocaleTimeString() }}</el-tag>
    </div>

    <!-- Stats -->
    <div class="stats-grid" v-if="stats">
      <div class="stat-card">
        <div class="stat-icon" style="background:#eef2ff">👥</div>
        <div class="stat-body">
          <span class="stat-num">{{ stats.totalUsers }}</span>
          <span class="stat-label">用户总数</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#fef3c7">🏘️</div>
        <div class="stat-body">
          <span class="stat-num">{{ stats.totalCommunities }}</span>
          <span class="stat-label">社区总数</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#fce7f3">📋</div>
        <div class="stat-body">
          <span class="stat-num">{{ stats.totalReports }}</span>
          <span class="stat-label">待处理举报</span>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background:#d1fae5">💳</div>
        <div class="stat-body">
          <span class="stat-num">{{ stats.totalVipOrders }}</span>
          <span class="stat-label">VIP订单</span>
        </div>
      </div>
    </div>

    <!-- Tabs -->
    <el-tabs v-model="activeTab" class="admin-tabs" type="card">
      <el-tab-pane label="👥 用户管理" name="users">
        <el-table :data="users" stripe v-loading="usersLoading" class="admin-table" size="large">
          <el-table-column prop="id" label="ID" width="70" />
          <el-table-column prop="nickname" label="昵称" min-width="120" />
          <el-table-column prop="phone" label="手机号" width="140" />
          <el-table-column prop="authType" label="实名" width="100">
            <template #default="{ row }"><el-tag size="small" round>{{ authTypeText(row.authType) }}</el-tag></template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="100">
            <template #default="{ row }">
              <el-tag :type="row.status === 2 ? 'danger' : row.status === 1 ? 'warning' : 'success'" size="small" round>
                {{ statusText(row.status) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="140" fixed="right">
            <template #default="{ row }">
              <el-button size="small" :type="row.status === 2 ? 'success' : 'danger'" round
                         @click="toggleUserStatus(row)">
                {{ row.status === 2 ? '解封' : row.status === 1 ? '解禁言' : '封禁' }}
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="🏘️ 社区管理" name="communities">
        <el-table :data="communities" stripe v-loading="communitiesLoading" class="admin-table" size="large">
          <el-table-column prop="id" label="ID" width="70" />
          <el-table-column prop="name" label="名称" min-width="150" />
          <el-table-column prop="city" label="城市" width="100" />
          <el-table-column prop="memberCount" label="人数" width="80" />
          <el-table-column prop="status" label="状态" width="80">
            <template #default="{ row }">
              <el-tag :type="row.status === 1 ? 'success' : 'danger'" size="small" round>{{ row.status === 1 ? '正常' : '禁用' }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="120" fixed="right">
            <template #default="{ row }">
              <el-button size="small" :type="row.status === 1 ? 'warning' : 'success'" round
                         @click="toggleCommunityStatus(row)">
                {{ row.status === 1 ? '禁用' : '启用' }}
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="🔐 人脸审核" name="faceAuth">
        <el-table :data="faceAuths" stripe v-loading="faceAuthLoading" class="admin-table" size="large">
          <el-table-column prop="nickname" label="用户" min-width="120" />
          <el-table-column prop="realName" label="姓名" width="120" />
          <el-table-column prop="idCard" label="身份证" width="180" />
          <el-table-column prop="authStatus" label="状态" width="100">
            <template #default="{ row }">
              <el-tag :type="row.authStatus === 0 ? 'warning' : row.authStatus === 1 ? 'success' : 'danger'" size="small" round>
                {{ row.authStatus === 0 ? '待审' : row.authStatus === 1 ? '通过' : '驳回' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="140" fixed="right">
            <template #default="{ row }">
              <el-button size="small" type="success" round @click="handleFaceAuth(row.id, true)" v-if="row.authStatus === 0">✓ 通过</el-button>
              <el-button size="small" type="danger" round @click="handleFaceAuth(row.id, false)" v-if="row.authStatus === 0">✕ 驳回</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="📋 举报管理" name="reports">
        <el-table :data="reports" stripe v-loading="reportsLoading" class="admin-table" size="large">
          <el-table-column prop="reportUserId" label="举报人" width="80" />
          <el-table-column prop="targetType" label="类型" width="80">
            <template #default="{ row }">{{ ['','帖子','用户','评论','活动'][row.targetType] }}</template>
          </el-table-column>
          <el-table-column prop="reason" label="原因" min-width="200" />
          <el-table-column prop="status" label="状态" width="100">
            <template #default="{ row }">
              <el-tag :type="row.status === 0 ? 'warning' : row.status === 1 ? 'success' : 'info'" size="small" round>
                {{ ['待处理','已处理','已驳回'][row.status] }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="140" fixed="right">
            <template #default="{ row }">
              <el-button size="small" type="primary" round @click="handleReportAction(row.id, 1)" v-if="row.status === 0">✓ 处理</el-button>
              <el-button size="small" round @click="handleReportAction(row.id, 2)" v-if="row.status === 0">✕ 驳回</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { ArrowLeft } from '@element-plus/icons-vue'
import {
  getDashboard, getUserPage, updateUserStatus,
  getFaceAuthPage, approveFaceAuth,
  getReportPage, handleReport,
  getAdminCommunityPage, updateCommunityStatus
} from '@/api/admin'
import { authTypeText, statusText } from '@/utils/format'
import type { DashboardStats } from '@/types'

const activeTab = ref('users')
const stats = ref<DashboardStats | null>(null)
const users = ref<any[]>([]); const usersLoading = ref(false)
const communities = ref<any[]>([]); const communitiesLoading = ref(false)
const faceAuths = ref<any[]>([]); const faceAuthLoading = ref(false)
const reports = ref<any[]>([]); const reportsLoading = ref(false)

async function loadAll() {
  const [s, u, c, f, r] = await Promise.all([
    getDashboard(), getUserPage(), getAdminCommunityPage(), getFaceAuthPage(), getReportPage()
  ])
  stats.value = s.data.data
  users.value = u.data.data.records
  communities.value = c.data.data.records
  faceAuths.value = f.data.data.records
  reports.value = r.data.data.records
}
async function toggleUserStatus(row: any) { await updateUserStatus(row.id, row.status === 2 ? 0 : 2); ElMessage.success('操作成功'); loadAll() }
async function toggleCommunityStatus(row: any) { await updateCommunityStatus(row.id, row.status === 1 ? 0 : 1); ElMessage.success('操作成功'); loadAll() }
async function handleFaceAuth(authId: number, approved: boolean) { await approveFaceAuth(authId, approved); ElMessage.success('操作成功'); loadAll() }
async function handleReportAction(reportId: number, status: number) { await handleReport(reportId, status, status === 1 ? '已处理' : '已驳回'); ElMessage.success('操作成功'); loadAll() }
onMounted(loadAll)
</script>

<style scoped>
.admin-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; }
.admin-title { font-size: 24px; font-weight: 700; margin-bottom: 4px; }
.admin-desc { font-size: 14px; color: var(--text-muted); }

.stats-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 16px; margin-bottom: 20px; }
.stat-card {
  background: var(--bg-card); border-radius: 16px; padding: 24px;
  display: flex; align-items: center; gap: 16px;
  border: 1px solid var(--border); box-shadow: var(--shadow-sm);
  transition: var(--transition);
}
.stat-card:hover { box-shadow: var(--shadow); transform: translateY(-2px); }
.stat-icon { width: 48px; height: 48px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 22px; flex-shrink: 0; }
.stat-body { display: flex; flex-direction: column; }
.stat-num { font-size: 26px; font-weight: 800; line-height: 1.2; }
.stat-label { font-size: 13px; color: var(--text-muted); }

.admin-tabs :deep(.el-tabs__header) { margin-bottom: 16px; }
.admin-tabs :deep(.el-tabs__item) { font-size: 14px; font-weight: 500; padding: 0 18px; }
.admin-table { width: 100%; border-radius: 12px; overflow: hidden; }
.admin-table :deep(th.el-table__cell) { background: #f8fafc !important; font-weight: 600; color: var(--text); }
</style>
