<template>
  <el-container class="layout-container">
    <el-header class="layout-header">
      <NavBar />
    </el-header>
    <el-main class="layout-main">
      <div class="page-container">
        <router-view />
      </div>
    </el-main>
  </el-container>
</template>

<script setup lang="ts">
import NavBar from '@/components/NavBar/index.vue'
</script>

<style scoped>
.layout-container {
  min-height: 100vh;
}
.layout-header {
  padding: 0;
  background: #fff;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
  position: sticky;
  top: 0;
  z-index: 100;
}
.layout-main {
  padding: 0;
  background: #f5f7fa;
  min-height: calc(100vh - 60px);
}
</style>
