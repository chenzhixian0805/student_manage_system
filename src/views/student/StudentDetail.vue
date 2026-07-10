<template>
  <div class="student-detail-container">
    <el-card class="detail-card">
      <template #header>
        <div class="card-header">
          <span>学生详情</span>
          <el-button size="small" @click="handleEdit">
            <el-icon><Edit /></el-icon>
            编辑
          </el-button>
        </div>
      </template>
      
      <!-- 学生基本信息 -->
      <div class="student-info">
        <el-descriptions :column="2" border>
          <el-descriptions-item label="学号">{{ studentDetail.studentId || studentDetail.student_id }}</el-descriptions-item>
          <el-descriptions-item label="姓名">{{ studentDetail.name }}</el-descriptions-item>
          <el-descriptions-item label="性别">{{ studentDetail.gender }}</el-descriptions-item>
          <el-descriptions-item label="学院">{{ studentDetail.major?.college?.collegeName || studentDetail.major?.college?.name || '-' }}</el-descriptions-item>
          <el-descriptions-item label="专业">{{ studentDetail.major?.majorName || studentDetail.major?.name || '-' }}</el-descriptions-item>
          <el-descriptions-item label="班级">{{ studentDetail.className || studentDetail.class || '-' }}</el-descriptions-item>
          <el-descriptions-item label="手机号">{{ studentDetail.phone || '-' }}</el-descriptions-item>
          <el-descriptions-item label="邮箱">{{ studentDetail.email || '-' }}</el-descriptions-item>
          <el-descriptions-item label="身份证号">{{ studentDetail.idCard || studentDetail.id_card || '-' }}</el-descriptions-item>
          <el-descriptions-item label="总GPA">{{ studentGPA.toFixed(2) }}</el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="getStatusTagType(studentDetail.status)">{{ getStatusText(studentDetail.status) }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="创建时间">{{ formatDate(studentDetail.createdAt || studentDetail.created_at) }}</el-descriptions-item>
          <el-descriptions-item label="更新时间">{{ formatDate(studentDetail.updatedAt || studentDetail.updated_at) }}</el-descriptions-item>
        </el-descriptions>
      </div>
      
      <!-- 学生成绩信息 -->
      <div class="student-scores" v-if="studentScores.length > 0">
        <h3 class="section-title">成绩信息</h3>
        <el-table
          :data="studentScores"
          border
          stripe
          style="width: 100%"
        >
          <el-table-column label="课程ID">
            <template #default="scope">
              {{ scope.row.course?.courseId || '-' }}
            </template>
          </el-table-column>
          <el-table-column label="课程名称">
            <template #default="scope">
              {{ scope.row.course?.name || '未知课程' }}
            </template>
          </el-table-column>
          <el-table-column prop="score" label="分数" sortable></el-table-column>
          <el-table-column prop="gpa" label="GPA" sortable></el-table-column>
          <el-table-column prop="semester" label="学期"></el-table-column>
          <el-table-column label="考试日期时间">
          <template #default="scope">
            {{ formatExamDateTime(scope.row.examDateTime) }}
          </template>
        </el-table-column>
        </el-table>
      </div>
      
      <!-- 没有成绩信息的提示 -->
      <el-empty description="暂无成绩信息" v-else>
        <template #description>
          <span>暂无成绩信息</span>
        </template>
      </el-empty>
      
      <!-- 返回按钮 -->
      <div class="action-buttons">
        <el-button @click="handleBack">返回列表</el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Edit } from '@element-plus/icons-vue'
import type { Student, Score } from '../../types'
import { getStudentById, getStudentByStudentId } from '../../api/studentApi'
import { getGradesByStudentId, getStudentGPA } from '../../api/gradeApi'

const router = useRouter()
const route = useRoute()

// 学生详情
const studentDetail = ref<Student>({
  id: 0,
  student_id: '',
  name: '',
  gender: '男',
  class: '',
  status: '在读',
  created_at: '',
  updated_at: ''
})

// 学生成绩列表
const studentScores = ref<Score[]>([])

// 学生总GPA
const studentGPA = ref(0.0)

// 加载状态
const loading = ref(false)

// 获取状态标签类型
const getStatusTagType = (status: string) => {
  switch (status) {
    case '在读':
      return 'success'
    case '休学':
      return 'warning'
    case '退学':
      return 'danger'
    case '毕业':
      return 'info'
    default:
      return ''
  }
}

// 获取状态文本
const getStatusText = (status: string): string => {
  return status || ''
}

// 格式化日期时间为YYYY-MM-DD HH:mm:ss格式
const formatDate = (date: any): string => {
  if (!date) return ''
  
  try {
    const d = new Date(date)
    return d.toISOString().slice(0, 19).replace('T', ' ')
  } catch (error) {
    console.error('日期格式化失败:', error)
    return String(date)
  }
}

// 格式化考试日期时间为 "年月日（时间段）" 格式
const formatExamDateTime = (examDateTime: string): string => {
  if (!examDateTime) return ''
  
  try {
    const date = new Date(examDateTime)
    // 格式化日期为YYYY-MM-DD
    const formattedDate = date.toISOString().split('T')[0]
    // 格式化时间为HH:MM
    const startHour = date.getHours()
    const startMinute = date.getMinutes()
    const formattedTime = `${startHour.toString().padStart(2, '0')}:${startMinute.toString().padStart(2, '0')}`
    
    // 计算结束时间，确保不超过24小时
    const endDate = new Date(date.getTime() + 2 * 60 * 60 * 1000) // 2小时后
    const endHour = endDate.getHours()
    const endMinute = endDate.getMinutes()
    const endTime = `${endHour.toString().padStart(2, '0')}:${endMinute.toString().padStart(2, '0')}`
    
    return `${formattedDate}（${formattedTime}——${endTime}）`
  } catch (error) {
    console.error('日期时间格式化失败:', error)
    return examDateTime
  }
}

// 获取学生成绩
const fetchStudentGrades = async (studentId: number) => {
  try {
    const response = await getGradesByStudentId(studentId)
    studentScores.value = response || []
    
    // 从后端获取学生总GPA
    const gpa = await getStudentGPA(studentId)
    studentGPA.value = gpa || 0.0
  } catch (error) {
    console.error('获取学生成绩失败:', error)
    studentGPA.value = 0.0
  }
}

// 初始化学生详情
const initStudentDetail = async () => {
  loading.value = true
  try {
    let studentId: number | null = null
    let response: any
    
    // 检查当前路由是否为/my-info
    if (route.path === '/students/my-info') {
      // 从localStorage获取当前用户信息
      const userInfoStr = localStorage.getItem('userInfo')
      if (userInfoStr) {
        const userInfo = JSON.parse(userInfoStr)
        // 学生的username就是student_id
        const studentIdStr = userInfo.username
        // 通过学号获取学生信息
        response = await getStudentByStudentId(studentIdStr)
        studentDetail.value = response || {}
        // 确保studentId不为空
        if (response && (response.id || response.ID)) {
          studentId = response.id || response.ID
        } else {
          studentId = null
        }
      }
    } else {
      // 从URL中获取学生ID
    const idParam = route.params.id
    studentId = Number(idParam)
    // 检查学生ID是否为有效数字
    if (isNaN(studentId)) {
      console.error('无效的学生ID:', idParam)
      loading.value = false
      return
    }
    // 调用API获取学生详情
    response = await getStudentById(studentId)
    // 使用类型断言修复TypeScript错误
    studentDetail.value = response || {}
    }
    
    // 获取学生成绩
    if (studentId) {
      await fetchStudentGrades(studentId)
    }
  } catch (error) {
    console.error('获取学生详情失败:', error)
  } finally {
    loading.value = false
  }
}

// 处理编辑
const handleEdit = () => {
  router.push(`/students/edit/${studentDetail.value.id}`)
}

// 处理返回
const handleBack = () => {
  router.push('/students')
}

onMounted(() => {
  initStudentDetail()
})
</script>

<style scoped>
.student-detail-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.student-info {
  margin-bottom: 20px;
}

.section-title {
  margin: 20px 0 10px 0;
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}

.action-buttons {
  margin-top: 20px;
  display: flex;
  justify-content: flex-start;
}

@media (max-width: 768px) {
  .student-info :deep(.el-descriptions) {
    :deep(.el-descriptions-item) {
      width: 100%;
      margin-right: 0;
    }
  }
  
  .el-table {
    font-size: 12px;
  }
  
  .el-table-column {
    min-width: 80px;
  }
}
</style>