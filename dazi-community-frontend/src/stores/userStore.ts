import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { getToken, setToken, removeToken } from '@/utils/token'
import type { SysUser } from '@/types'

export const useUserStore = defineStore('user', () => {
  const token = ref<string | null>(getToken())
  const userInfo = ref<SysUser | null>(null)

  const isLoggedIn = computed(() => !!token.value)
  const isVip = computed(() => userInfo.value?.isVip === 1)
  const authType = computed(() => userInfo.value?.authType ?? 0)
  const isFaceAuthed = computed(() => authType.value >= 2)

  function setTokenValue(t: string) {
    token.value = t
    setToken(t)
  }

  function setUserInfo(info: SysUser) {
    userInfo.value = info
  }

  function logout() {
    token.value = null
    userInfo.value = null
    removeToken()
  }

  function initFromToken() {
    if (token.value) {
      // Will be called on mount to restore session
    }
  }

  return {
    token,
    userInfo,
    isLoggedIn,
    isVip,
    authType,
    isFaceAuthed,
    setTokenValue,
    setUserInfo,
    logout,
    initFromToken,
  }
})
