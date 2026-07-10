// 用户类型
export interface User {
  id: number
  username: string
  password: string
  role: string
  name: string
  email: string
  phone: string
  gender?: string
  created_at: string
  updated_at: string
  status: number | string
}

// 学院类型
export interface College {
  id: number
  college_name: string
  description?: string
  created_at?: string
  updated_at?: string
}

// 专业类型
export interface Major {
  id: number
  major_name: string
  college_id: number
  college?: College
  description?: string
  created_at?: string
  updated_at?: string
}

// 学生类型
export interface Student {
  id: number
  student_id: string
  name: string
  gender: '男' | '女'
  id_card?: string
  phone?: string
  email?: string
  class: string
  status: '在读' | '休学' | '退学' | '毕业'
  created_at: string
  updated_at: string
  college_id?: number
  major_id?: number
  major?: Major
  // college直接通过major关联获取，这里保留college字段是为了兼容前端代码
  college?: College
}

// 课程类型
export interface Course {
  id: number
  course_id: string
  name: string
  description?: string
  credit?: number
  createTime: string
  updateTime: string
  teacher_id?: number
  teacher?: User
}

// 成绩类型
export interface Score {
  id: number
  student_id: number
  student?: Student
  course_id: number
  course?: Course
  score: number
  gpa: number
  semester: string
  exam_datetime: string
  created_at: string
  updated_at: string
}

// 分页响应类型
export interface PageResponse<T> {
  total: number
  list: T[]
  page: number
  size: number
}

// 登录请求类型
export interface LoginRequest {
  username: string
  password: string
  remember?: boolean
}

// 登录响应类型
export interface LoginResponse {
  token: string
  userInfo: {
    username: string
    role: string
    name: string
    email: string
    phone: string
    gender?: string
  }
}