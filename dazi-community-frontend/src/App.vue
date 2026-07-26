<template>
  <router-view />
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useUserStore } from '@/stores/userStore'

const userStore = useUserStore()

onMounted(() => {
  userStore.initFromToken()
})
</script>
