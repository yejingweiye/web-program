<template>
  <div>
    <div class="back-nav">
      <el-button text size="small" @click="$router.back()">
        <el-icon><ArrowLeft /></el-icon> 返回
      </el-button>
      <span class="back-title">创建社区</span>
    </div>
    <div class="create-community card">
      <h2>创建二级社区</h2>
    <el-form :model="form" :rules="rules" ref="formRef" label-width="100px" class="mt-20">
      <el-form-item label="所属分类" prop="firstId">
        <el-select v-model="form.firstId" placeholder="选择一级社区分类">
          <el-option v-for="cat in categories" :key="cat.id" :label="cat.name" :value="cat.id" />
        </el-select>
      </el-form-item>
      <el-form-item label="社区名称" prop="name">
        <el-input v-model="form.name" maxlength="50" />
      </el-form-item>
      <el-form-item label="所在城市" prop="city">
        <el-input v-model="form.city" placeholder="如：北京" />
      </el-form-item>
      <el-form-item label="社区描述" prop="desc">
        <el-input v-model="form.desc" type="textarea" :rows="3" />
      </el-form-item>
      <el-form-item label="准入模式" prop="joinType">
        <el-radio-group v-model="form.joinType">
          <el-radio :value="0">自由加入</el-radio>
          <el-radio :value="1">管理员审核</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">创建社区</el-button>
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
import { getFirstLevelList, createSecondCommunity } from '@/api/community'
import type { CommunityFirst } from '@/types'

const router = useRouter()
const formRef = ref()
const categories = ref<CommunityFirst[]>([])
const submitting = ref(false)

const form = reactive({
  firstId: undefined as number | undefined,
  name: '',
  city: '',
  desc: '',
  joinType: 0,
})

const rules = {
  firstId: [{ required: true, message: '请选择分类', trigger: 'change' }],
  name: [{ required: true, message: '请输入社区名称', trigger: 'blur' }],
}

async function handleSubmit() {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  submitting.value = true
  try {
    const res = await createSecondCommunity(form as any)
    ElMessage.success('社区创建成功')
    router.push(`/community/${res.data.data.id}`)
  } catch (e) {
    // handled
  } finally {
    submitting.value = false
  }
}

onMounted(async () => {
  const res = await getFirstLevelList()
  categories.value = res.data.data
})
</script>

<style scoped>
.create-community {
  max-width: 600px;
  margin: 0 auto;
}
</style>
