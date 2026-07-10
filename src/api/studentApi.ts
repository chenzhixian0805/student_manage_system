import request from '../utils/request'

// 学生管理API服务

// 获取所有学生
export const getAllStudents = () => {
  return request.get('/api/students')
}

// 根据ID获取学生
export const getStudentById = (id: number) => {
  return request.get(`/api/students/${id}`)
}

// 根据学号获取学生
export const getStudentByStudentId = (studentId: string) => {
  return request.get(`/api/students/by-student-id/${studentId}`)
}

// 创建学生
export const createStudent = (student: any) => {
  return request.post('/api/students', student)
}

// 更新学生
export const updateStudent = (id: number, student: any) => {
  return request.put(`/api/students/${id}`, student)
}

// 删除学生
export const deleteStudent = (id: number) => {
  return request.delete(`/api/students/${id}`)
}

// 搜索学生
export const searchStudents = (keyword?: string, className?: string) => {
  return request.get('/api/students/search', { params: { keyword, className } })
}

// 获取学生总数
export const getStudentCount = () => {
  return request.get('/api/students/count')
}

// 获取学生性别统计
export const getGenderStatistics = () => {
  return request.get('/api/students/gender-statistics')
}
