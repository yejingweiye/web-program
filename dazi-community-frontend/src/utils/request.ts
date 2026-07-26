import axios, { AxiosError, type AxiosInstance, type AxiosResponse } from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getToken, removeToken } from './token'
import type { ApiResult } from '@/types'

const request: AxiosInstance = axios.create({
  baseURL: '/api/v1',
  timeout: 30000,
  headers: { 'Content-Type': 'application/json' },
})

request.interceptors.request.use((config) => {
  const token = getToken()
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

request.interceptors.response.use(
  (response: AxiosResponse<ApiResult<any>>) => {
    const res = response.data
    if (res.code !== 200) {
      if (res.code === 10001) {
        removeToken()
        ElMessageBox.confirm('登录已失效，请重新登录', '提示', {
          confirmButtonText: '去登录',
          cancelButtonText: '取消',
          type: 'warning',
        }).then(() => {
          window.location.href = '/#/login'
        })
        return Promise.reject(new Error(res.msg))
      }
      ElMessage.error(res.msg || '请求失败')
      return Promise.reject(new Error(res.msg))
    }
    return response
  },
  (error: AxiosError) => {
    ElMessage.error('网络错误，请稍后重试')
    return Promise.reject(error)
  }
)

export default request
