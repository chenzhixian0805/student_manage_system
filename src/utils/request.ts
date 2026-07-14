import axios from 'axios'
import type { AxiosInstance, InternalAxiosRequestConfig, AxiosResponse } from 'axios'
import { ElMessage } from 'element-plus'

// 扩展axios类型，使其返回响应数据类型，而不是AxiosResponse
interface ExtendedAxiosInstance extends AxiosInstance {
  get<T = any>(url: string, config?: Partial<InternalAxiosRequestConfig>): Promise<T>
  post<T = any>(url: string, data?: any, config?: Partial<InternalAxiosRequestConfig>): Promise<T>
  put<T = any>(url: string, data?: any, config?: Partial<InternalAxiosRequestConfig>): Promise<T>
  delete<T = any>(url: string, config?: Partial<InternalAxiosRequestConfig>): Promise<T>
}

const service: ExtendedAxiosInstance = axios.create({
  baseURL: '/',
  timeout: 30000
}) as ExtendedAxiosInstance

// 扩展配置类型
interface ExtendedInternalAxiosRequestConfig extends InternalAxiosRequestConfig {
  silent?: boolean;
  hideSuccessMessage?: boolean;
}

// 请求拦截器
service.interceptors.request.use(
  (config: ExtendedInternalAxiosRequestConfig) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers = config.headers || {}
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    console.error('请求参数错误:', error)
    ElMessage.error('请求参数错误')
    return Promise.reject(error)
  }
)

// 响应拦截器
service.interceptors.response.use(
  (response: AxiosResponse) => {
    const res = response.data
    const config = response.config as ExtendedInternalAxiosRequestConfig
    
    // 根据后端返回的状态码处理
    if (res.code !== 200) {
      // 处理业务错误，只有非静默请求才弹窗
      if (res.message && !config.silent) {
        ElMessage.error(res.message || '操作失败')
      }
      return Promise.reject(new Error(res.message || 'Error'))
    } else {
      // 操作成功，显示成功消息（只对修改类操作且未隐藏消息）
      if (res.message && !config.hideSuccessMessage && 
          (config.method === 'post' || config.method === 'put' || config.method === 'delete')) {
        ElMessage.success(res.message)
      }
      return res.data
    }
  },
  (error) => {
    // 处理HTTP错误
    let errorMessage = '网络请求失败，请稍后重试'
    const config = (error.config as ExtendedInternalAxiosRequestConfig) || {}
    
    if (error.response) {
      switch (error.response.status) {
        case 400:
          errorMessage = '请求参数错误'
          break
        case 401:
          errorMessage = '登录已过期，请重新登录'
          // 清除本地存储的token和用户信息
          localStorage.removeItem('token')
          localStorage.removeItem('userInfo')
          // 跳转到登录页面
          setTimeout(() => {
            window.location.href = '/login'
          }, 1500)
          break
        case 403:
          errorMessage = '没有权限执行此操作'
          break
        case 404:
          errorMessage = '请求的资源不存在'
          break
        case 500:
          errorMessage = '服务器内部错误'
          break
        default:
          errorMessage = `请求失败，错误码：${error.response.status}`
      }
    } else if (error.request) {
      // 请求已发送但没有收到响应
      errorMessage = '网络超时，请稍后重试'
    }
    
    // 只有非静默请求才弹窗
    if (!config.silent) {
      ElMessage.error(errorMessage)
    }
    console.error('请求失败:', error)
    return Promise.reject(error)
  }
)

export default service