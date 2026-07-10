import request from '../utils/request'

// 课程管理API服务

// 获取所有课程
export const getAllCourses = () => {
  return request.get<any[]>('/api/courses')
}

// 根据ID获取课程
export const getCourseById = (id: number) => {
  return request.get<any>(`/api/courses/${id}`)
}

// 根据课程代码获取课程
export const getCourseByCourseCode = (courseCode: string) => {
  return request.get<any>(`/api/courses/by-course-code/${courseCode}`)
}

// 创建课程
export const createCourse = (course: any) => {
  return request.post<any>('/api/courses', course)
}

// 更新课程
export const updateCourse = (id: number, course: any) => {
  return request.put<any>(`/api/courses/${id}`, course)
}

// 删除课程
export const deleteCourse = (id: number) => {
  return request.delete(`/api/courses/${id}`)
}

// 搜索课程
export const searchCourses = (keyword?: string, courseType?: string) => {
  return request.get<any[]>('/api/courses/search', { params: { keyword, courseType } })
}

// 根据学期获取课程
export const getCoursesBySemester = (semester: string) => {
  return request.get<any[]>(`/api/courses/by-semester/${semester}`)
}

// 根据教师获取课程
export const getCoursesByTeacher = (teacher: string) => {
  return request.get<any[]>(`/api/courses/by-teacher/${teacher}`)
}
