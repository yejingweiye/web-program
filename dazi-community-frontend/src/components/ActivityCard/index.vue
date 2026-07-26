<template>
  <div class="activity-card card card-hover" @click="$router.push(`/activity/detail/${activity.id}`)">
    <div class="activity-row">
      <div class="activity-icon-col">
        <div class="activity-icon">🎉</div>
      </div>
      <div class="activity-main">
        <div class="activity-header">
          <h3 class="activity-title">{{ activity.title }}</h3>
          <el-tag :type="auditTagType" size="small" round effect="plain">
            {{ auditStatusText(activity.auditStatus) }}
          </el-tag>
        </div>
        <div class="activity-details">
          <span class="detail-item" v-if="activity.address">📍 {{ activity.address }}</span>
          <span class="detail-item" v-if="activity.startTime">🕐 {{ formatTime(activity.startTime) }}</span>
        </div>
        <div class="activity-footer">
          <span class="footer-info">👥 最多 {{ activity.maxPeople || '不限' }}人</span>
          <span class="footer-price" :class="{ free: !activity.fee }">{{ formatPrice(activity.fee) }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { ActivityInfo } from '@/types'
import { formatTime, formatPrice, auditStatusText } from '@/utils/format'

const props = defineProps<{ activity: ActivityInfo }>()
const auditTagType = computed(() => {
  if (props.activity.auditStatus === 1) return 'success'
  if (props.activity.auditStatus === 2) return 'danger'
  return 'warning'
})
</script>

<style scoped>
.activity-card { margin-bottom: 14px; }
.activity-row { display: flex; gap: 16px; }
.activity-icon-col { display: flex; align-items: flex-start; padding-top: 4px; }
.activity-icon {
  width: 48px; height: 48px; border-radius: 14px;
  background: linear-gradient(135deg, #fef3c7, #fde68a);
  display: flex; align-items: center; justify-content: center;
  font-size: 22px;
}
.activity-main { flex: 1; min-width: 0; }
.activity-header { display: flex; align-items: center; gap: 8px; margin-bottom: 6px; }
.activity-title { font-size: 16px; font-weight: 600; flex: 1; }
.activity-details { display: flex; flex-wrap: wrap; gap: 12px; margin-bottom: 8px; }
.detail-item { font-size: 13px; color: var(--text-secondary); }
.activity-footer { display: flex; align-items: center; justify-content: space-between; }
.footer-info { font-size: 13px; color: var(--text-muted); }
.footer-price { font-size: 16px; font-weight: 700; color: var(--danger); }
.footer-price.free { color: var(--success); }
</style>
