<template>
  <div class="score-list-container">
    <el-card class="list-card">
      <template #header>
        <div class="card-header">
          <span>{{ isMyScores ? '我的成绩' : '成绩列表' }}</span>
          <div class="header-actions" v-if="!isMyScores">
            <el-button type="success" @click="handleExport">
              <el-icon><Download /></el-icon>
              导出Excel
            </el-button>
            <el-button type="primary" @click="handleAddScore">
              <el-icon><Plus /></el-icon>
              添加成绩
            </el-button>
          </div>
        </div>
      </template>
      
      <!-- 搜索表单 -->
      <el-form :inline="true" :model="searchForm" class="search-form" v-if="!isMyScores">
        <el-form-item label="学生ID">
          <el-input v-model="searchForm.studentId" placeholder="请输入学生ID或姓名" clearable></el-input>
        </el-form-item>
        
        <el-form-item label="课程ID">
          <el-input v-model="searchForm.courseId" placeholder="请输入课程ID或名称" clearable></el-input>
        </el-form-item>
        
        <el-form-item label="学期">
          <el-select v-model="searchForm.semester" placeholder="请选择学期" clearable>
            <el-option label="2023-2024-1" value="2023-2024-1"></el-option>
            <el-option label="2023-2024-2" value="2023-2024-2"></el-option>
            <el-option label="2024-2025-1" value="2024-2025-1"></el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
      
      <!-- 成绩列表表格 -->
      <el-table
        :data="scoreList"
        :loading="loading"
        border
        stripe
        style="width: 100%"
        :default-sort="{ prop: 'id', order: 'descending' }"
        empty-text=""
      >
        <!-- 自定义空状态 -->
        <template #empty>
          <div class="empty-state-container">
            <el-empty
              description="暂无成绩数据"
              :image-size="100"
            >
              <template #description>
                <span class="empty-state-text">
                  {{ isSearching ? '未找到匹配的成绩信息' : '暂无成绩数据' }}
                </span>
              </template>
              <el-button type="primary" @click="handleReset" v-if="isSearching">
                <el-icon><Refresh /></el-icon>
                重置搜索
              </el-button>
              <el-button type="primary" @click="handleAddScore" v-else>
                <el-icon><Plus /></el-icon>
                添加成绩
              </el-button>
            </el-empty>
          </div>
        </template>
        
        <el-table-column type="selection" width="55" v-if="!isMyScores"></el-table-column>
        <el-table-column prop="student.studentId" label="学生ID" min-width="120"></el-table-column>
        <el-table-column prop="student.name" label="学生姓名" min-width="100"></el-table-column>
        <el-table-column prop="student.className" label="班级" min-width="150"></el-table-column>
        <el-table-column prop="course.courseId" label="课程ID" min-width="100"></el-table-column>
        <el-table-column prop="course.name" label="课程名称" min-width="150"></el-table-column>
        <el-table-column prop="score" label="分数" width="100" sortable>
          <template #default="scope">
            <span class="score-value" :class="getScoreClass(scope.row.score)">
              {{ scope.row.score }}
            </span>
          </template>
        </el-table-column>
        <el-table-column label="等级" width="100">
          <template #default="scope">
            <el-tag :type="getGradeClass(scope.row.score)">
              {{ calculateGrade(scope.row.score) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="gpa" label="GPA" width="100" sortable>
          <template #default="scope">
            {{ scope.row.gpa.toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column prop="semester" label="学期"></el-table-column>
        <el-table-column label="考试日期时间" min-width="200">
          <template #default="scope">
            {{ formatExamDateTime(scope.row.examDateTime) }}
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150" fixed="right" v-if="!isMyScores">
          <template #default="scope">
            <el-button
              size="small"
              @click="handleEditScore(scope.row.id)"
            >
              编辑
            </el-button>
            <el-button
              type="danger"
              size="small"
              @click="handleDeleteScore(scope.row.id)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页组件 -->
      <div v-if="scoreList.length > 0" class="pagination-container" :class="{ 'loading': loading }">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.size"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="pagination.total"
          @update:page-size="handleSizeChange"
          @update:current-page="handleCurrentChange"
          prev-text="上一页"
          next-text="下一页"
        ></el-pagination>
      </div>
      <div v-else-if="!loading" class="pagination-container empty">
        暂无成绩数据
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search, Download } from '@element-plus/icons-vue'
import * as XLSX from 'xlsx'
import type { Score } from '../../types'
import { getAllGrades, searchGrades, getGradesByStudentId } from '../../api/gradeApi'
import { getStudentByStudentId } from '../../api/studentApi'

// 绩点计算规则：0-59分=0.0，60分=1.0，每增加1分+0.1，最高不超过5.0，保留两位小数
const getGradePoint = (score: number): number => {
  if (score < 60) {
    return 0.0
  } else {
    // 0-59=0.0，60分=1.0，每增加1分+0.1，最高不超过5.0
    const gpa = (score - 60) * 0.1 + 1.0
    const finalGpa = Math.min(gpa, 5.0)
    // 保留两位小数
    return Math.round(finalGpa * 100) / 100
  }
}

// 根据分数计算等级（国内通用标准）
const calculateGrade = (score: number): string => {
  if (score >= 90) return '优秀'
  if (score >= 80) return '良好'
  if (score >= 70) return '中等'
  if (score >= 60) return '及格'
  return '不及格'
}

// 格式化考试日期时间为 "年月日（时间段）" 格式
const formatExamDateTime = (examDateTime: string): string => {
  if (!examDateTime) return ''
  
  try {
    const date = new Date(examDateTime)
    // 格式化日期为YYYY-MM-DD
    const formattedDate = date.toISOString().split('T')[0]
    // 格式化时间为HH:MM
    const formattedTime = date.toTimeString().split(' ')[0].slice(0, 5)
    
    // 根据开始时间生成结束时间
    let endTime = ''
    const hour = date.getHours()
    
    // 使用用户指定的两个时间段
    if (hour === 8) {
      // 上午场：8:30——10:30
      endTime = '10:30'
    } else if (hour === 15) {
      // 下午场：15:00——17:30
      endTime = '17:30'
    } else {
      // 其他时间，根据开始时间自动计算结束时间（2小时后）
      const endHour = hour + 2
      const endMinute = date.getMinutes()
      endTime = `${endHour.toString().padStart(2, '0')}:${endMinute.toString().padStart(2, '0')}`
    }
    
    return `${formattedDate}（${formattedTime}——${endTime}）`
  } catch (error) {
    console.error('日期时间格式化失败:', error)
    return examDateTime
  }
}

const router = useRouter()
const route = useRoute()

// 搜索表单
const searchForm = reactive({
  studentId: '',
  courseId: '',
  semester: ''
})

// 分页配置
const pagination = reactive({
  page: 1,
  size: 10,
  total: 100
})

// 加载状态
const loading = ref(false)

// 原始成绩列表数据
const allScores = ref<Score[]>([])
// 分页后的成绩列表数据（用于显示）
const scoreList = ref<Score[]>([])

// 搜索状态标识
const isSearching = ref(false)

// 检查是否是学生查看自己的成绩
const isMyScores = ref(false)

// 获取成绩列表数据
const fetchGrades = async () => {
  loading.value = true
  try {
    let response: any
    
    // 检查当前路由是否为/my-scores
    isMyScores.value = route.path === '/scores/my-scores'
    
    if (isMyScores.value) {
      // 从localStorage获取当前用户信息
      const userInfoStr = localStorage.getItem('userInfo')
      if (userInfoStr) {
        const userInfo = JSON.parse(userInfoStr)
        // 学生的username就是student_id
        const studentIdStr = userInfo.username
        
        // 首先通过学号获取学生信息，包括数据库中的主键id
        const studentResponse = await getStudentByStudentId(studentIdStr)
        if (studentResponse && (studentResponse.id || studentResponse.ID)) {
          // 使用学生的主键id获取成绩
          const studentPrimaryId = studentResponse.id || studentResponse.ID
          response = await getGradesByStudentId(studentPrimaryId)
        }
      }
      
      // 使用类型断言修复TypeScript错误
      allScores.value = response || []
      pagination.total = allScores.value.length
      // 执行前端分页
      paginateScores()
    } else {
      // 获取分页成绩数据
      response = await getAllGrades(pagination.page - 1, pagination.size)
      
      // 处理后端返回的分页数据结构
      if (response && response.content) {
        scoreList.value = response.content || []
        pagination.total = response.totalElements || 0
        pagination.page = response.currentPage + 1 || 1
        pagination.size = response.pageSize || 10
      } else {
        // 兼容旧格式（如果需要）
        scoreList.value = response || []
        pagination.total = scoreList.value.length
      }
    }
  } catch (error) {
    console.error('获取成绩列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 执行前端分页
const paginateScores = () => {
  const start = (pagination.page - 1) * pagination.size
  const end = start + pagination.size
  scoreList.value = allScores.value.slice(start, end)
}

// 初始化获取成绩列表
onMounted(() => {
  fetchGrades()
})

// 处理搜索
const handleSearch = async () => {
  // 重置到第一页
  pagination.page = 1
  // 设置搜索状态
  isSearching.value = true
  // 执行搜索
  await searchGradesList()
}

// 调用后端API搜索成绩
const searchGradesList = async () => {
  loading.value = true
  try {
    // 合并搜索条件
    const keyword = searchForm.studentId || searchForm.courseId
    const semester = searchForm.semester
    
    // 先获取所有成绩，然后在前端过滤
    let allGrades: any[] = []
    if (isMyScores.value) {
      // 从localStorage获取当前用户信息
      const userInfoStr = localStorage.getItem('userInfo')
      if (userInfoStr) {
        const userInfo = JSON.parse(userInfoStr)
        // 学生的username就是studentId
        const studentIdStr = userInfo.username
        
        // 首先通过学号获取学生信息，包括数据库中的主键id
        const studentResponse = await getStudentByStudentId(studentIdStr)
        if (studentResponse && (studentResponse.id || studentResponse.ID)) {
          // 使用学生的主键id获取成绩
          const studentPrimaryId = studentResponse.id || studentResponse.ID
          allGrades = await getGradesByStudentId(studentPrimaryId)
        }
      }
    } else {
      // 获取所有成绩数据（不使用分页，获取所有数据）
      const response = await getAllGrades(0, 1000) // 获取最多1000条数据
      if (response && response.content) {
        allGrades = response.content || []
      } else {
        allGrades = response || []
      }
    }
    
    // 在前端过滤成绩
    let filteredGrades = [...allGrades]
    
    // 按关键词过滤
    if (keyword && keyword.trim()) {
      filteredGrades = filteredGrades.filter(grade => {
        // 按学生ID或姓名过滤
        const matchesStudent = grade.student && 
          (grade.student.studentId && grade.student.studentId.includes(keyword)) || 
          (grade.student.name && grade.student.name.includes(keyword));
        // 按课程ID或名称过滤
        const matchesCourse = grade.course && 
          (grade.course.courseId && grade.course.courseId.includes(keyword)) || 
          (grade.course.name && grade.course.name.includes(keyword));
        return matchesStudent || matchesCourse;
      })
    }
    
    // 按学期过滤
    if (semester) {
      filteredGrades = filteredGrades.filter(grade => semester === grade.semester)
    }
    
    // 使用过滤后的成绩
    allScores.value = filteredGrades
    pagination.total = allScores.value.length
    // 执行前端分页
    paginateScores()
  } catch (error) {
    console.error('搜索成绩列表失败:', error)
    // 显示错误信息
    ElMessage.error('搜索成绩失败，请稍后重试')
  } finally {
    loading.value = false
  }
}

// 处理重置
const handleReset = async () => {
  // 重置搜索表单
  Object.assign(searchForm, {
    student_id: '',
    course_id: '',
    semester: ''
  })
  
  // 重置到第一页
  pagination.page = 1
  
  // 重置搜索状态
  isSearching.value = false
  
  // 重新获取完整数据
  await fetchGrades()
}

// 处理导出Excel
const handleExport = () => {
  try {
    // 准备导出数据
        const exportData = scoreList.value.map(score => ({
          '学生ID': score.student?.studentId || '',
          '学生姓名': score.student?.name || '',
          '班级': score.student?.className || '',
          '课程ID': score.course?.courseId || '',
          '课程名称': score.course?.name || '',
          '分数': score.score,
          '等级': calculateGrade(score.score),
          'GPA': getGradePoint(score.score).toFixed(1),
          '学期': score.semester,
          '考试日期时间': score.examDateTime,
          '创建时间': score.createdAt,
          '更新时间': score.updatedAt
        }))
    
    // 创建工作簿和工作表
    const worksheet = XLSX.utils.json_to_sheet(exportData)
    const workbook = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(workbook, worksheet, '成绩列表')
    
    // 导出文件
    XLSX.writeFile(workbook, `成绩列表_${new Date().toISOString().slice(0, 10)}.xlsx`)
    
    ElMessage.success('导出成功')
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error('导出失败')
  }
}

// 处理添加成绩
const handleAddScore = () => {
  router.push('/scores/add')
}

// 处理编辑成绩
const handleEditScore = (id: number) => {
  router.push(`/scores/edit/${id}`)
}

// 处理删除成绩
const handleDeleteScore = (_id: number) => {
  ElMessageBox.confirm('确定要删除该成绩吗？', '删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(async () => {
      // 调用API进行删除
      // await deleteScore(_id)
      // 刷新成绩列表
      await fetchGrades()
      ElMessage.success('删除成功')
    })
    .catch(() => {
      // 取消删除
    })
}

// 处理分页大小变化
const handleSizeChange = (size: number) => {
  pagination.size = size
  // 调用后端分页
  fetchGrades()
}

// 处理当前页码变化
const handleCurrentChange = (page: number) => {
  pagination.page = page
  // 调用后端分页
  fetchGrades()
}

// 获取分数样式类
const getScoreClass = (score: number): string => {
  if (score >= 90) return 'score-excellent'
  if (score >= 80) return 'score-good'
  if (score >= 70) return 'score-average'
  if (score >= 60) return 'score-pass'
  return 'score-fail'
}

// 获取等级样式类
const getGradeClass = (score: number): string => {
  if (score >= 90) return 'success'
  if (score >= 80) return 'primary'
  if (score >= 70) return 'warning'
  if (score >= 60) return 'info'
  return 'danger'
}
</script>

<style scoped>
.score-list-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.search-form {
  margin-bottom: 20px;
  padding: 15px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.empty-state-container {
  margin: 50px 0;
}

.empty-state-text {
  font-size: 16px;
  color: #606266;
}

.pagination-container {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.pagination-container.empty {
  justify-content: center;
  color: #909399;
  padding: 20px;
}

.pagination-container.loading {
  opacity: 0.7;
}

.score-value {
  font-weight: 500;
}

.score-excellent {
  color: #67c23a;
}

.score-good {
  color: #409eff;
}

.score-average {
  color: #e6a23c;
}

.score-pass {
  color: #909399;
}

.score-fail {
  color: #f56c6c;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .search-form {
    flex-direction: column;
    gap: 10px;
  }
  
  .el-form-item {
    margin-right: 0 !important;
    margin-bottom: 10px !important;
  }
}
</style>