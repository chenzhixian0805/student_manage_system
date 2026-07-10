import request from '../utils/request'

// 认证API服务

// 登录请求参数类型
export interface LoginRequest {
  username: string
  password: string
  remember?: boolean
}

// 通用响应类型
export interface ResponseResult<T> {
  code: number
  message: string
  data: T
}

// 登录响应数据类型
export interface LoginResponseData {
  token: string
  userInfo: {
    username: string
    role: string
    name: string
    email: string
    phone: string
  }
}

// 登录
export const login = (loginData: LoginRequest) => {
  return request.post<LoginResponseData>('/api/auth/login', loginData)
}

// 登出
export const logout = () => {
  return request.post('/api/auth/logout')
}

// 获取当前用户信息
export const getCurrentUser = () => {
  return request.get('/api/auth/me')
}

// 刷新Token
export const refreshToken = () => {
  return request.post('/api/auth/refresh')
}
