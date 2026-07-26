import { defineStore } from 'pinia'
import { ref } from 'vue'

export interface ChatMsg {
  id?: number
  fromUserId: number
  toUserId?: number
  circleId?: number
  content: string
  msgType: string
  createTime?: string
}

export const useChatStore = defineStore('chat', () => {
  const messages = ref<ChatMsg[]>([])
  const wsConnected = ref(false)

  function addMessage(msg: ChatMsg) {
    messages.value.push(msg)
  }

  function setConnected(val: boolean) {
    wsConnected.value = val
  }

  function clearMessages() {
    messages.value = []
  }

  return {
    messages,
    wsConnected,
    addMessage,
    setConnected,
    clearMessages,
  }
})
