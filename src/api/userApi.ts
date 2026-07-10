import request from '../utils/request'

// 用户管理API服务

// 获取所有用户
export const getAllUsers = () => {
  return request.get('/api/users')
}

// 根据ID获取用户
export const getUserById = (id: number) => {
  return request.get(`/api/users/${id}`)
}

// 创建用户
export const createUser = (user: any) => {
  return request.post('/api/users', user)
}

// 更新用户
export const updateUser = (id: number, user: any) => {
  return request.put(`/api/users/${id}`, user)
}

// 删除用户
export const deleteUser = (id: number) => {
  return request.delete(`/api/users/${id}`)
}

// 搜索用户
export const searchUsers = (keyword?: string, role?: string, status?: string) => {
  return request.get('/api/users/search', { params: { keyword, role, status } })
}

// 更改用户状态
export const changeUserStatus = (id: number, status: string) => {
  return request.patch(`/api/users/${id}/status`, { status })
}

// 修改用户密码
export const resetPassword = (id: number, password: string) => {
  return request.patch(`/api/users/${id}/password`, { password })
}