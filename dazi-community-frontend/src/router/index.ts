import { createRouter, createWebHashHistory } from 'vue-router'
import { getToken } from '@/utils/token'

const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    {
      path: '/',
      component: () => import('@/components/Layout/index.vue'),
      redirect: '/home',
      children: [
        { path: 'home', name: 'Home', component: () => import('@/views/Home/index.vue'), meta: { title: '首页' } },
        { path: 'community/:id', name: 'CommunityDetail', component: () => import('@/views/Community/Detail.vue'), meta: { title: '社区详情' } },
        { path: 'community/create', name: 'CreateCommunity', component: () => import('@/views/Community/Create.vue'), meta: { title: '创建社区', requiresAuth: true } },
        { path: 'circle/:id', name: 'CircleDetail', component: () => import('@/views/Circle/Detail.vue'), meta: { title: '圈子详情' } },
        { path: 'post/detail/:id', name: 'PostDetail', component: () => import('@/views/Post/Detail.vue'), meta: { title: '帖子详情' } },
        { path: 'post/create', name: 'CreatePost', component: () => import('@/views/Post/Create.vue'), meta: { title: '发帖', requiresAuth: true } },
        { path: 'post/my', name: 'MyPosts', component: () => import('@/views/Post/MyPosts.vue'), meta: { title: '我的帖子', requiresAuth: true } },
        { path: 'activity/detail/:id', name: 'ActivityDetail', component: () => import('@/views/Activity/Detail.vue'), meta: { title: '活动详情' } },
        { path: 'activity/create', name: 'CreateActivity', component: () => import('@/views/Activity/Create.vue'), meta: { title: '发布活动', requiresAuth: true } },
        { path: 'user/profile', name: 'UserProfile', component: () => import('@/views/User/Profile.vue'), meta: { title: '个人中心', requiresAuth: true } },
        { path: 'user/face-auth', name: 'FaceAuth', component: () => import('@/views/User/FaceAuth.vue'), meta: { title: '人脸实名', requiresAuth: true } },
        { path: 'vip', name: 'VipCenter', component: () => import('@/views/Vip/index.vue'), meta: { title: '会员中心' } },
        { path: 'admin', name: 'Admin', component: () => import('@/views/Admin/index.vue'), meta: { title: '管理后台', requiresAuth: true } },
      ],
    },
    { path: '/login', name: 'Login', component: () => import('@/views/Login/index.vue'), meta: { title: '登录' } },
  ],
})

router.beforeEach((to, _from, next) => {
  document.title = (to.meta.title as string) + ' - 搭子社区'
  if (to.meta.requiresAuth && !getToken()) {
    next('/login')
  } else {
    next()
  }
})

export default router
