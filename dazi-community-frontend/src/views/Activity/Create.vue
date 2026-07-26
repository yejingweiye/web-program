<template>
  <div>
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">发布活动</span>
    </div>
    <div class="create-activity card" style="max-width: 600px; margin: 0 auto;">
      <h2>发布活动</h2>
    <el-form :model="form" :rules="rules" ref="formRef" label-width="100px" class="mt-20">
      <el-form-item label="所属社区" prop="communityId">
        <el-select v-model="form.communityId" filterable>
          <el-option v-for="c in communities" :key="c.id" :label="c.name" :value="c.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="活动标题" prop="title">
        <el-input v-model="form.title" />
      </el-form-item>
      <el-form-item label="活动内容">
        <el-input v-model="form.content" type="textarea" :rows="3" />
      </el-form-item>
      <el-form-item label="地址">
        <el-input v-model="form.address" />
      </el-form-item>
      <el-form-item label="开始时间">
        <el-date-picker v-model="form.startTime" type="datetime" format="YYYY-MM-DD HH:mm:ss"
                        value-format="YYYY-MM-DD HH:mm:ss" />
      </el-form-item>
      <el-form-item label="结束时间">
        <el-date-picker v-model="form.endTime" type="datetime" format="YYYY-MM-DD HH:mm:ss"
                        value-format="YYYY-MM-DD HH:mm:ss" />
      </el-form-item>
      <el-form-item label="最大人数">
        <el-input-number v-model="form.maxPeople" :min="0" />
      </el-form-item>
      <el-form-item label="费用(元)">
        <el-input-number v-model="form.fee" :min="0" :precision="2" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">发布活动</el-button>
        <el-button @click="$router.back()">取消</el-button>
      </el-form-item>
    </el-form>
      </div>
    </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { ArrowLeft } from '@element-plus/icons-vue'
import { getMyCommunities } from '@/api/community'
import { createActivity } from '@/api/activity'
import type { CommunitySecond } from '@/types'

const router = useRouter()
const formRef = ref()
const communities = ref<CommunitySecond[]>([])
const submitting = ref(false)

const form = reactive({
  communityId: undefined as number | undefined,
  title: '',
  content: '',
  address: '',
  startTime: '',
  endTime: '',
  maxPeople: 0,
  fee: 0,
})

const rules = {
  communityId: [{ required: true, message: '请选择社区', trigger: 'change' }],
  title: [{ required: true, message: '请输入活动标题', trigger: 'blur' }],
}

async function handleSubmit() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  submitting.value = true
  try {
    await createActivity(form as any)
    ElMessage.success('活动发布成功，等待审核')
    router.push('/home')
  } catch (e) { /* handled */ }
  finally { submitting.value = false }
}

onMounted(async () => {
  const res = await getMyCommunities()
  communities.value = res.data.data
})
</script>
