import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { CommunityFirst, CommunitySecond } from '@/types'

export const useCommunityStore = defineStore('community', () => {
  const firstLevelList = ref<CommunityFirst[]>([])
  const currentSecondLevel = ref<CommunitySecond | null>(null)

  function setFirstLevelList(list: CommunityFirst[]) {
    firstLevelList.value = list
  }

  function setCurrentSecondLevel(cs: CommunitySecond) {
    currentSecondLevel.value = cs
  }

  return {
    firstLevelList,
    currentSecondLevel,
    setFirstLevelList,
    setCurrentSecondLevel,
  }
})
