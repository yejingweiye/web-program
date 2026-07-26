<template>
  <div class="face-auth-page" style="max-width: 520px; margin: 0 auto;">
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">人脸实名</span>
    </div>
    <div class="card">
      <div class="auth-header">
        <div class="auth-icon">🔐</div>
        <h2>人脸实名认证</h2>
        <p class="auth-desc">完成认证后解锁全部社区功能</p>
      </div>

      <!-- Status alert -->
      <div v-if="authInfo" class="mt-16">
        <el-alert
          :type="authInfo.authStatus === 1 ? 'success' : authInfo.authStatus === 2 ? 'error' : 'warning'"
          :title="authInfo.authStatus === 0 ? '📋 审核中，请耐心等待' : authInfo.authStatus === 1 ? '✅ 认证已通过' : '❌ 认证已驳回'"
          show-icon :closable="false" class="status-alert"
        />
      </div>

      <!-- Perks list -->
      <div class="perks-list">
        <div class="perk-item">✓ 加入线下社区</div>
        <div class="perk-item">✓ 创建二级社区</div>
        <div class="perk-item">✓ 参加线下活动</div>
        <div class="perk-item">✓ 使用安全工具</div>
      </div>

      <!-- Form -->
      <el-form :model="form" :rules="rules" ref="formRef" label-position="top"
               class="auth-form" v-if="!authInfo || authInfo.authStatus === 2">
        <el-form-item label="真实姓名" prop="realName">
          <el-input v-model="form.realName" placeholder="请输入真实姓名" size="large" prefix-icon="User" />
        </el-form-item>
        <el-form-item label="身份证号" prop="idCard">
          <el-input v-model="form.idCard" placeholder="请输入身份证号" size="large" maxlength="18" prefix-icon="Postcard" />
        </el-form-item>
        <el-form-item>
          <el-button class="btn-gradient w-full" :loading="submitting" @click="handleSubmit" round size="large">
            提交认证
          </el-button>
        </el-form-item>
      </el-form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { ArrowLeft } from '@element-plus/icons-vue'
import { checkFaceAuth, submitFaceAuth } from '@/api/auth'
import { isValidIdCard } from '@/utils/validate'

const formRef = ref()
const submitting = ref(false)
const authInfo = ref<any>(null)
const form = reactive({ realName: '', idCard: '' })
const rules = {
  realName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
  idCard: [{ required: true, validator: (_r: any, v: string, cb: Function) => {
    if (!v) cb(new Error('请输入身份证号'))
    else if (!isValidIdCard(v)) cb(new Error('身份证号格式不正确'))
    else cb()
  }, trigger: 'blur' }],
}

async function handleSubmit() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  submitting.value = true
  try {
    await submitFaceAuth(form)
    ElMessage.success('✅ 提交成功，请等待管理员审核')
    authInfo.value = { authStatus: 0 }
  } finally { submitting.value = false }
}

onMounted(async () => {
  try { const res = await checkFaceAuth(); authInfo.value = res.data.data } catch (e) { /* handled */ }
})
</script>

<style scoped>
.auth-header { text-align: center; margin-bottom: 8px; }
.auth-icon { font-size: 48px; margin-bottom: 12px; }
.auth-header h2 { font-size: 22px; font-weight: 700; margin-bottom: 4px; }
.auth-desc { color: var(--text-muted); font-size: 14px; }

.status-alert { border-radius: 12px; }
.status-alert :deep(.el-alert__content) { font-size: 14px; }

.perks-list {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 8px;
  margin: 20px 0;
  padding: 16px;
  background: var(--primary-bg);
  border-radius: 12px;
}
.perk-item {
  font-size: 13px;
  color: var(--primary);
  font-weight: 500;
}

.auth-form { margin-top: 8px; }
:deep(.el-form-item__label) { font-weight: 600; font-size: 14px; }
:deep(.el-input__wrapper) { border-radius: 12px !important; }
</style>
