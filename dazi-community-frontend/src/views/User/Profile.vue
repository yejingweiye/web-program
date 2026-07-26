<template>
  <div class="profile-page" style="max-width: 700px; margin: 0 auto;">
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">个人中心</span>
    </div>
    <!-- Profile header -->
    <div class="profile-hero card">
      <div class="profile-header-row">
        <div class="profile-avatar-wrap">
          <div class="profile-avatar">{{ userInfo?.nickname?.charAt(0) || 'U' }}</div>
          <div class="avatar-badge" v-if="userInfo?.isVip">👑</div>
        </div>
        <div class="profile-info">
          <h2 class="profile-name">{{ userInfo?.nickname || '未知' }}</h2>
          <div class="profile-tags">
            <span class="profile-tag" :class="'level-' + (userInfo?.authType || 0)">
              {{ authTypeText(userInfo?.authType) }}
            </span>
            <span class="profile-tag" v-if="userInfo?.isVip" style="background:#fef3c7;color:#92400e;">
              👑 VIP
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit form -->
    <div class="card mt-20">
      <h3 class="card-title">编辑资料</h3>
      <el-form :model="form" label-position="top" class="mt-16">
        <div class="form-grid">
          <el-form-item label="昵称">
            <el-input v-model="form.nickname" size="large" />
          </el-form-item>
          <el-form-item label="城市">
            <el-input v-model="form.city" placeholder="如：北京" size="large" />
          </el-form-item>
          <el-form-item label="年龄">
            <el-input-number v-model="form.age" :min="0" :max="150" size="large" style="width:100%" />
          </el-form-item>
          <el-form-item label="性别">
            <el-radio-group v-model="form.gender">
              <el-radio-button :value="1">👨 男</el-radio-button>
              <el-radio-button :value="2">👩 女</el-radio-button>
              <el-radio-button :value="0">🔒 保密</el-radio-button>
            </el-radio-group>
          </el-form-item>
        </div>
        <el-form-item label="空闲时间">
          <el-input v-model="form.freeTime" placeholder="如：周末、晚上" size="large" />
        </el-form-item>
        <el-form-item label="消费预算">
          <el-input-number v-model="form.budget" :min="0" :precision="2" size="large" style="width:200px" />
        </el-form-item>
        <el-form-item label="搭子标签">
          <el-input v-model="form.tags" placeholder="逗号分隔，如：跑步,羽毛球,读书" size="large" />
        </el-form-item>
        <el-form-item>
          <el-button class="btn-gradient" :loading="saving" @click="handleSave" round size="large">💾 保存</el-button>
        </el-form-item>
      </el-form>
    </div>

    <!-- Quick actions -->
    <div class="card mt-20">
      <h3 class="card-title">快捷操作</h3>
      <div class="quick-actions">
        <button class="quick-btn" @click="$router.push('/user/face-auth')">
          <span class="quick-icon">🔐</span>
          <span>人脸实名</span>
        </button>
        <button class="quick-btn" @click="$router.push('/vip')">
          <span class="quick-icon">👑</span>
          <span>会员中心</span>
        </button>
        <button class="quick-btn" @click="$router.push('/post/my')">
          <span class="quick-icon">📝</span>
          <span>我的帖子</span>
        </button>
        <button class="quick-btn" @click="$router.push('/admin')" v-if="userInfo?.id === 1">
          <span class="quick-icon">⚙️</span>
          <span>管理后台</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { ArrowLeft } from '@element-plus/icons-vue'
import { getUserInfo, updateProfile } from '@/api/user'
import { useUserStore } from '@/stores/userStore'
import { authTypeText } from '@/utils/format'

const userStore = useUserStore()
const saving = ref(false)
const userInfo = ref(userStore.userInfo)
const form = reactive({ nickname: '', city: '', age: 0, gender: 0, freeTime: '', budget: 0, tags: '' })

async function handleSave() {
  saving.value = true
  try {
    const res = await updateProfile(form)
    userStore.setUserInfo(res.data.data)
    userInfo.value = res.data.data
    ElMessage.success('✅ 保存成功')
  } finally { saving.value = false }
}

onMounted(async () => {
  try {
    const res = await getUserInfo()
    userStore.setUserInfo(res.data.data)
    userInfo.value = res.data.data
    Object.assign(form, { nickname: res.data.data.nickname || '', city: res.data.data.city || '', age: res.data.data.age || 0, gender: res.data.data.gender || 0, freeTime: res.data.data.freeTime || '', budget: res.data.data.budget || 0, tags: res.data.data.tags || '' })
  } catch (e) { /* handled */ }
})
</script>

<style scoped>
.profile-hero { padding: 28px; }
.profile-header-row { display: flex; align-items: center; gap: 20px; }
.profile-avatar-wrap { position: relative; }
.profile-avatar {
  width: 72px; height: 72px;
  border-radius: 20px;
  background: linear-gradient(135deg, var(--primary), var(--secondary));
  color: #fff;
  display: flex; align-items: center; justify-content: center;
  font-size: 28px; font-weight: 700;
}
.avatar-badge { position: absolute; top: -6px; right: -6px; font-size: 18px; }
.profile-name { font-size: 22px; font-weight: 700; margin-bottom: 6px; }
.profile-tags { display: flex; gap: 8px; flex-wrap: wrap; }
.profile-tag {
  padding: 4px 14px; border-radius: 20px;
  font-size: 13px; font-weight: 500;
}
.profile-tag.level-0 { background: #f1f5f9; color: #64748b; }
.profile-tag.level-1 { background: #dbeafe; color: #2563eb; }
.profile-tag.level-2 { background: #d1fae5; color: #059669; }

.card-title { font-size: 17px; font-weight: 700; }
.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 0 20px; }

.quick-actions { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 12px; margin-top: 12px; }
.quick-btn {
  display: flex; flex-direction: column; align-items: center; gap: 8px;
  padding: 20px 16px; border-radius: 14px;
  background: var(--bg); border: 1px solid var(--border);
  cursor: pointer; transition: var(--transition);
  font-family: inherit; font-size: 13px; color: var(--text-secondary);
}
.quick-btn:hover { background: var(--primary-bg); border-color: var(--primary-light); color: var(--primary); }
.quick-icon { font-size: 24px; }

@media (max-width: 768px) { .form-grid { grid-template-columns: 1fr; } }
</style>
