<template>
  <div>
    <!-- Back button -->
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">发布帖子</span>
    </div>
    <div class="create-post card" style="max-width: 700px; margin: 0 auto;">
      <h2>发布搭子帖</h2>
    <el-form :model="form" :rules="rules" ref="formRef" label-width="100px" class="mt-20">
      <el-form-item label="社区" prop="communityId">
        <el-select v-model="form.communityId" placeholder="选择社区" filterable>
          <el-option v-for="c in myCommunities" :key="c.id" :label="c.name" :value="c.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="标题" prop="title">
        <el-input v-model="form.title" maxlength="100" />
      </el-form-item>
      <el-form-item label="内容">
        <el-input v-model="form.content" type="textarea" :rows="4" />
      </el-form-item>
      <el-form-item label="城市">
        <el-input v-model="form.city" placeholder="如：北京" />
      </el-form-item>
      <el-form-item label="地址">
        <el-input v-model="form.address" />
      </el-form-item>
      <el-form-item label="活动时间">
        <el-date-picker v-model="form.startTime" type="datetime" placeholder="选择时间"
                        format="YYYY-MM-DD HH:mm:ss" value-format="YYYY-MM-DD HH:mm:ss" />
      </el-form-item>
      <el-form-item label="预算">
        <el-input-number v-model="form.budget" :min="0" :precision="2" />
      </el-form-item>
      <el-form-item label="期望人数">
        <el-input-number v-model="form.peopleNum" :min="1" />
      </el-form-item>
      <el-form-item label="标签">
        <el-input v-model="form.tags" placeholder="逗号分隔，如：跑步,羽毛球" />
      </el-form-item>
      <el-form-item label="可见范围">
        <el-radio-group v-model="form.scope">
          <el-radio :value="0">社区内可见</el-radio>
          <el-radio :value="1">全站公开</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">发布</el-button>
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
import { createPost } from '@/api/post'
import type { CommunitySecond } from '@/types'

const router = useRouter()
const formRef = ref()
const myCommunities = ref<CommunitySecond[]>([])
const submitting = ref(false)

const form = reactive({
  communityId: undefined as number | undefined,
  title: '',
  content: '',
  city: '',
  address: '',
  startTime: '',
  budget: 0,
  peopleNum: 1,
  tags: '',
  scope: 0,
  // imgList omitted for simplicity
})

const rules = {
  communityId: [{ required: true, message: '请选择社区', trigger: 'change' }],
  title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
}

async function handleSubmit() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  submitting.value = true
  try {
    const res = await createPost(form as any)
    ElMessage.success('发帖成功')
    router.push(`/post/detail/${res.data.data.id}`)
  } catch (e) { /* handled */ }
  finally { submitting.value = false }
}

onMounted(async () => {
  try {
    const res = await getMyCommunities()
    myCommunities.value = res.data.data
  } catch (e) { /* handled */ }
})
</script>
