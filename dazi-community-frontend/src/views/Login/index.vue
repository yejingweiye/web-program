<template>
  <div class="login-page">
    <!-- Animated background -->
    <div class="bg-shapes">
      <div class="shape shape-1"></div>
      <div class="shape shape-2"></div>
      <div class="shape shape-3"></div>
      <div class="shape shape-4"></div>
    </div>

    <div class="login-wrapper">
      <!-- Brand section -->
      <div class="brand-section">
        <div class="brand-logo">
          <div class="logo-icon">
            <span class="logo-emoji">🤝</span>
          </div>
        </div>
        <h1 class="brand-title gradient-text">搭子社区</h1>
        <p class="brand-subtitle">找到属于你的同城搭子</p>
      </div>

      <!-- Login card -->
      <div class="login-card">
        <div class="card-header">
          <h2 class="card-title">欢迎回来</h2>
          <p class="card-desc">手机号一键登录，开启搭子之旅</p>
        </div>

        <el-form :model="form" :rules="rules" ref="formRef" class="login-form" @keyup.enter="handleLogin">
          <el-form-item prop="phone">
            <div class="input-wrapper">
              <span class="input-prefix">📱</span>
              <el-input v-model="form.phone" placeholder="请输入手机号" size="large" maxlength="11" class="clean-input" />
            </div>
          </el-form-item>

          <el-form-item prop="code">
            <div class="input-wrapper code-wrapper">
              <span class="input-prefix">🔑</span>
              <el-input v-model="form.code" placeholder="输入验证码" size="large" maxlength="6" class="clean-input" />
              <el-button class="code-btn" :disabled="sending" @click="sendCode" text>
                {{ sending ? `${countdown}s` : '获取验证码' }}
              </el-button>
            </div>
          </el-form-item>

          <el-form-item>
            <div class="input-wrapper">
              <span class="input-prefix">✏️</span>
              <el-input v-model="form.nickname" placeholder="设置昵称（选填）" size="large" class="clean-input" />
            </div>
          </el-form-item>

          <el-form-item>
            <el-button class="login-btn btn-gradient" size="large" :loading="loading" @click="handleLogin" round>
              <span v-if="!loading">登录 / 注册</span>
            </el-button>
          </el-form-item>
        </el-form>

        <div class="login-footer">
          <div class="divider"><span>演示模式</span></div>
          <p class="demo-hint">验证码任意输入即可登录</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { login } from '@/api/auth'
import { getUserInfo } from '@/api/user'
import { useUserStore } from '@/stores/userStore'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref()
const loading = ref(false)
const sending = ref(false)
const countdown = ref(60)
let timer: ReturnType<typeof setInterval> | null = null

const form = reactive({ phone: '', code: '', nickname: '' })
const rules = {
  phone: [{ required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '手机号格式不正确', trigger: 'blur' }],
  code: [{ required: true, message: '请输入验证码', trigger: 'blur' }],
}

function sendCode() {
  if (!form.phone || !/^1[3-9]\d{9}$/.test(form.phone)) {
    ElMessage.warning('请输入正确手机号')
    return
  }
  sending.value = true
  countdown.value = 60
  timer = setInterval(() => {
    countdown.value--
    if (countdown.value <= 0) { clearInterval(timer!); sending.value = false }
  }, 1000)
  ElMessage.success('验证码已发送（演示模式）')
}

async function handleLogin() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  loading.value = true
  try {
    const res = await login(form)
    const data = res.data.data
    userStore.setTokenValue(data.token)
    const userRes = await getUserInfo()
    userStore.setUserInfo(userRes.data.data)
    ElMessage.success('🎉 登录成功')
    router.push('/home')
  } finally { loading.value = false }
}

onUnmounted(() => { if (timer) clearInterval(timer) })
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #0f0c29 0%, #302b63 50%, #24243e 100%);
  position: relative;
  overflow: hidden;
}

/* Animated background shapes */
.bg-shapes { position: absolute; inset: 0; pointer-events: none; }
.shape {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.3;
  animation: float 6s ease-in-out infinite;
}
.shape-1 { width: 400px; height: 400px; background: var(--primary); top: -100px; right: -100px; animation-delay: 0s; }
.shape-2 { width: 300px; height: 300px; background: var(--secondary); bottom: -80px; left: -80px; animation-delay: 2s; }
.shape-3 { width: 200px; height: 200px; background: #06b6d4; top: 50%; left: 10%; animation-delay: 4s; }
.shape-4 { width: 250px; height: 250px; background: #f43f5e; top: 20%; right: 20%; animation-delay: 3s; }

.login-wrapper {
  position: relative;
  z-index: 1;
  display: flex;
  gap: 60px;
  align-items: center;
}

.brand-section { text-align: center; }
.logo-icon {
  width: 80px; height: 80px;
  background: rgba(255,255,255,0.1);
  backdrop-filter: blur(20px);
  border-radius: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 20px;
  border: 1px solid rgba(255,255,255,0.2);
}
.logo-emoji { font-size: 36px; }
.brand-title { font-size: 42px; font-weight: 800; margin-bottom: 8px; }
.brand-subtitle { color: rgba(255,255,255,0.6); font-size: 16px; letter-spacing: 2px; }

.login-card {
  background: rgba(255,255,255,0.95);
  backdrop-filter: blur(20px);
  border-radius: 20px;
  padding: 40px;
  width: 400px;
  max-width: 90vw;
  box-shadow: 0 25px 80px rgba(0,0,0,0.3);
  border: 1px solid rgba(255,255,255,0.3);
}

.card-header { margin-bottom: 28px; }
.card-title { font-size: 24px; font-weight: 700; color: var(--text); margin-bottom: 6px; }
.card-desc { color: var(--text-secondary); font-size: 14px; }

.input-wrapper {
  display: flex;
  align-items: center;
  background: #f8fafc;
  border-radius: 12px;
  padding: 0 16px;
  border: 2px solid transparent;
  transition: var(--transition);
}
.input-wrapper:focus-within {
  border-color: var(--primary);
  background: #fff;
  box-shadow: 0 0 0 4px rgba(99,102,241,0.1);
}
.input-prefix { font-size: 18px; margin-right: 12px; }
.code-wrapper { padding-right: 4px; }
.code-btn {
  white-space: nowrap;
  color: var(--primary) !important;
  font-weight: 600 !important;
  font-size: 13px !important;
}
.code-btn:disabled { color: var(--text-muted) !important; }

:deep(.clean-input .el-input__wrapper) {
  background: transparent !important;
  box-shadow: none !important;
  padding: 0 !important;
}
:deep(.clean-input .el-input__inner) {
  font-size: 15px;
  height: 48px;
}
:deep(.el-form-item) { margin-bottom: 20px; }
:deep(.el-form-item__error) { padding-left: 4px; font-size: 12px; }

.login-btn {
  width: 100%;
  height: 50px;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 1px;
}

.login-footer { margin-top: 24px; }
.divider {
  display: flex;
  align-items: center;
  gap: 12px;
  color: var(--text-muted);
  font-size: 12px;
  margin-bottom: 12px;
}
.divider::before, .divider::after { content: ''; flex: 1; height: 1px; background: var(--border); }
.demo-hint { text-align: center; font-size: 13px; color: var(--text-muted); }

@media (max-width: 768px) {
  .login-wrapper { flex-direction: column; gap: 30px; padding: 20px; }
  .brand-title { font-size: 32px; }
  .brand-section { display: none; }
  .login-card { padding: 30px 24px; }
}
</style>
