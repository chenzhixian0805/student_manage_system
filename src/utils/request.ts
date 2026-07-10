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

// 请求拦截器
service.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = localStorage.getItem('token')
    console.log('请求URL:', config.url)
    console.log('请求Token:', token)
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
    
    // 根据后端返回的状态码处理
    if (res.code !== 200) {
      // 处理业务错误
      // 对于统计类和获取数据类接口，不显示错误信息，只在控制台打印
      if (res.message && !response.config.url?.includes('/count') && !response.config.url?.includes('/statistics') && !response.config.url?.includes('/grades')) {
        ElMessage.error(res.message || '操作失败')
      }
      return Promise.reject(new Error(res.message || 'Error'))
    } else {
      // 操作成功，显示成功消息（只对修改类操作）
      if (res.message && (response.config.method === 'post' || response.config.method === 'put' || response.config.method === 'delete')) {
        ElMessage.success(res.message)
      }
      return res.data
    }
  },
  (error) => {
    // 处理HTTP错误
    let errorMessage = '网络请求失败，请稍后重试'
    
    if (error.response) {
      // 获取请求URL，用于特殊处理某些接口
      const requestUrl = error.config?.url || ''
      
      switch (error.response.status) {
        case 400:
          errorMessage = '请求参数错误'
          break
        case 401:
          // 对于统计类接口，不强制跳转登录，只显示错误信息
          if (requestUrl.includes('/count') || requestUrl.includes('/statistics') || requestUrl.includes('/grades')) {
            errorMessage = '获取数据失败，请稍后重试'
          } else {
            errorMessage = '登录已过期，请重新登录'
            // 清除本地存储的token和用户信息
            localStorage.removeItem('token')
            localStorage.removeItem('userInfo')
            // 跳转到登录页面
            setTimeout(() => {
              window.location.href = '/login'
            }, 1500)
          }
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
    
    // 对于获取成绩列表等数据类接口，不显示错误信息，只在控制台打印
    if (!error.config?.url?.includes('/grades')) {
      ElMessage.error(errorMessage)
    }
    console.error('请求失败:', error)
    return Promise.reject(error)
  }
)

export default service