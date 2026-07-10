import request from '../utils/request'

// 成绩管理API服务

// 获取所有成绩
export const getAllGrades = (page?: number, size?: number) => {
  return request.get<any>(`/api/grades?page=${page || 0}&size=${size || 20}`)
}

// 根据ID获取成绩
export const getGradeById = (id: number) => {
  return request.get<any>(`/api/grades/${id}`)
}

// 创建成绩
export const createGrade = (grade: any) => {
  return request.post<any>('/api/grades', grade)
}

// 更新成绩
export const updateGrade = (id: number, grade: any) => {
  return request.put<any>(`/api/grades/${id}`, grade)
}

// 删除成绩
export const deleteGrade = (id: number) => {
  return request.delete(`/api/grades/${id}`)
}

// 根据学生ID获取成绩
export const getGradesByStudentId = (studentId: number) => {
  return request.get<any[]>(`/api/grades/by-student/${studentId}`)
}

// 根据课程ID获取成绩
export const getGradesByCourseId = (courseId: number) => {
  return request.get<any[]>(`/api/grades/by-course/${courseId}`)
}

// 根据学期获取成绩
export const getGradesBySemester = (semester: string) => {
  return request.get<any[]>(`/api/grades/by-semester/${semester}`)
}

// 根据学生ID和学期获取成绩
export const getGradesByStudentIdAndSemester = (studentId: number, semester: string) => {
  return request.get<any[]>(`/api/grades/by-student-and-semester/${studentId}/${semester}`)
}

// 根据课程ID和学期获取成绩
export const getGradesByCourseIdAndSemester = (courseId: number, semester: string) => {
  return request.get<any[]>(`/api/grades/by-course-and-semester/${courseId}/${semester}`)
}

// 获取课程平均分
export const getCourseAverageScore = (courseId: number) => {
  return request.get<number>(`/api/grades/statistics/average/${courseId}`)
}

// 获取课程及格率
export const getCoursePassRate = (courseId: number) => {
  return request.get<number>(`/api/grades/statistics/pass-rate/${courseId}`)
}

// 获取课程优秀率
export const getCourseExcellentRate = (courseId: number) => {
  return request.get<number>(`/api/grades/statistics/excellent-rate/${courseId}`)
}

// 获取整体平均成绩
export const getOverallAverageScore = () => {
  return request.get<number>('/api/grades/statistics/average')
}

// 搜索成绩
export const searchGrades = (keyword?: string, courseType?: string, semester?: string) => {
  return request.get<any[]>('/api/grades/search', { params: { keyword, courseType, semester } })
}

// 根据学生ID和课程ID获取成绩
export const getGradeByStudentIdAndCourseId = (studentId: number, courseId: number) => {
  return request.get<any>(`/api/grades/by-student-and-course/${studentId}/${courseId}`)
}

// 获取所有成绩（用于成绩分析）
export const getAllGradesForAnalysis = async () => {
  let allGrades: any[] = [];
  let page = 0;
  const pageSize = 100;
  let totalPages = 1;
  
  try {
    // Fetch all pages of data
    while (page < totalPages) {
      const response = await request.get<any>(`/api/grades?page=${page}&size=${pageSize}`);
      if (response && response.content) {
        allGrades = [...allGrades, ...response.content];
        totalPages = response.totalPages || 1;
        page++;
      } else {
        // Fallback: if response is not paginated, return it as is
        return response;
      }
    }
    return allGrades;
  } catch (error) {
    console.error('获取成绩分析数据失败:', error);
    throw error;
  }
}

// 获取学生总GPA
export const getStudentGPA = (studentId: number) => {
  return request.get<number>(`/api/grades/statistics/gpa/${studentId}`)
}

// 获取成绩分析结果
export const getGradeAnalysis = (courseId?: number, semester?: string) => {
  return request.get<any>(`/api/grades/statistics/analysis`, { 
    params: { 
      course_id: courseId, 
      semester: semester 
    } 
  })
}
