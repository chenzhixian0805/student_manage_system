import request from '../utils/request';

export interface Teacher {
  id: number;
  username: string;
  password?: string;
  name: string;
  role: string;
  status: number;
  employeeId: string;
  email: string;
  phone: string;
  gender?: string;
  createdAt: string;
  updatedAt: string;
}

// 获取所有教师
export const getAllTeachers = () => {
  return request.get<Teacher[]>('/api/teachers');
};

// 根据ID获取教师
export const getTeacherById = (id: number) => {
  return request.get<Teacher>(`/api/teachers/${id}`);
};

// 创建教师
export const createTeacher = (teacher: Omit<Teacher, 'id' | 'createdAt' | 'updatedAt'>) => {
  return request.post<Teacher>('/api/teachers', teacher);
};

// 更新教师
export const updateTeacher = (id: number, teacher: Partial<Teacher>) => {
  return request.put<Teacher>(`/api/teachers/${id}`, teacher);
};

// 删除教师
export const deleteTeacher = (id: number) => {
  return request.delete(`/api/teachers/${id}`);
};

// 检查工号是否存在
export const checkEmployeeId = (employeeId: string) => {
  return request.get<boolean>(`/api/teachers/check-employee-id?employeeId=${employeeId}`);
};
