<template>
  <div class="score-analysis-container">
    <el-card class="analysis-card">
      <template #header>
        <div class="card-header">
          <span>{{ isStudent ? '我的成绩分析' : '成绩统计分析' }}</span>
          <el-button 
            v-if="isTeacherOrAdmin"
            type="success" 
            @click="handleExport"
          >
            <el-icon><Download /></el-icon>
            导出数据
          </el-button>
        </div>
      </template>
      
      <!-- 课程选择器 -->
      <div class="course-selector" v-if="isTeacherOrAdmin">
        <el-form :inline="true" :model="formData" class="form">
          <el-form-item label="课程">
            <el-select
              v-model="formData.course_id"
              placeholder="请选择课程"
              clearable
              style="width: 220px;"
            >
              <el-option label="全部课程" :value="''"></el-option>
              <el-option
                v-for="course in courseOptions"
                :key="course.id"
                :label="`${course.name} (${course.course_id})`"
                :value="course.id"
              ></el-option>
            </el-select>
          </el-form-item>
          
          <el-form-item label="学期">
            <el-select
              v-model="formData.semester"
              placeholder="请选择学期"
              clearable
              style="width: 200px;"
            >
              <el-option label="2023-2024-1" value="2023-2024-1"></el-option>
              <el-option label="2023-2024-2" value="2023-2024-2"></el-option>
              <el-option label="2022-2023-1" value="2022-2023-1"></el-option>
              <el-option label="2022-2023-2" value="2022-2023-2"></el-option>
            </el-select>
          </el-form-item>
          
          <el-form-item>
            <el-button type="primary" @click="handleAnalyze">
              <el-icon><Search /></el-icon>
              分析
            </el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <!-- 统计指标卡片 -->
      <div class="stats-cards">
        <el-row :gutter="20">
          <el-col :span="6">
            <el-card class="stat-card">
              <div class="stat-title">平均分</div>
              <div class="stat-value">{{ stats.averageScore.toFixed(2) }}</div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card class="stat-card">
              <div class="stat-title">GPA</div>
              <div class="stat-value">{{ stats.gpa.toFixed(2) }}</div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card class="stat-card">
              <div class="stat-title">及格率</div>
              <div class="stat-value">{{ (stats.passRate * 100).toFixed(1) }}%</div>
            </el-card>
          </el-col>
          <el-col :span="6">
            <el-card class="stat-card">
              <div class="stat-title">优秀率</div>
              <div class="stat-value">{{ (stats.excellentRate * 100).toFixed(1) }}%</div>
            </el-card>
          </el-col>
        </el-row>
      </div>
      
      <!-- 成绩分布柱状图 -->
      <div class="chart-container">
        <h3 class="chart-title">成绩分布</h3>
        <div class="chart" ref="chartRef"></div>
      </div>
      
      <!-- 成绩趋势折线图 -->
      <div class="chart-container" v-if="hasMultipleSemesters">
        <h3 class="chart-title">成绩趋势</h3>
        <div class="chart" ref="trendChartRef"></div>
      </div>
      
      <!-- 课程对比雷达图 -->
      <div class="chart-container" v-if="hasMultipleCourses">
        <h3 class="chart-title">课程对比</h3>
        <div class="chart" ref="radarChartRef"></div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage } from 'element-plus'
import { Download, Search } from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import { getAllGradesForAnalysis, getGradesByStudentId, getGradeAnalysis } from '../../api/gradeApi'
import { getAllCourses } from '../../api/courseApi'
import { getStudentByStudentId } from '../../api/studentApi'

// 获取当前用户信息
const userInfoStr = localStorage.getItem('userInfo')
const userInfo = userInfoStr ? JSON.parse(userInfoStr) : {}
const isStudent = userInfo.role === 'ROLE_STUDENT'
const isTeacherOrAdmin = userInfo.role === 'ROLE_TEACHER' || userInfo.role === 'ROLE_ADMIN'

// 表单数据
const formData = reactive({
  course_id: '',
  semester: ''
})

// 成绩数据
interface ScoreData {
  id: number
  student_id: number
  student_name: string
  course_id: number
  course_name: string
  credit: number // 课程学分
  score: number
  gpa: number // 课程绩点
  semester: string
}

// 真实成绩数据
const realScores = ref<ScoreData[]>([])

// 课程选项
const courseOptions = ref<Array<{ id: number; name: string; course_id: string }>>([])

// 加载状态
const loading = ref(false)

// 统计数据
const stats = reactive({
  averageScore: 0,
  gpa: 0,
  passRate: 0,
  excellentRate: 0
})

// 计算是否有多个学期的数据
const hasMultipleSemesters = computed(() => {
  const semesters = new Set(realScores.value.map(score => score.semester))
  return semesters.size > 1
})

// 计算是否有多个课程的数据
const hasMultipleCourses = computed(() => {
  const courses = new Set(realScores.value.map(score => score.course_name))
  return courses.size > 0
})

// 获取课程列表
const fetchCourses = async () => {
  try {
    const courses: any[] = await getAllCourses()
    courseOptions.value = courses.map((course: any) => ({
      id: course.id,
      name: course.name,
      course_id: course.course_id
    }))
  } catch (error) {
    console.error('获取课程列表失败:', error)
    ElMessage.error('获取课程列表失败')
  }
}

// 获取成绩数据
const fetchScores = async () => {
  loading.value = true
  try {
    if (isStudent) {
      // 学生只能获取自己的成绩 - 保持原逻辑
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
          const response = await getGradesByStudentId(studentPrimaryId)
          
          // 转换成绩数据格式
          realScores.value = response.map((grade: any) => {
            if (!grade.student || !grade.course) {
              return {
                id: grade.id,
                student_id: 0,
                student_name: '未知学生',
                course_id: 0,
                course_name: '未知课程',
                credit: 0,
                score: 0,
                gpa: 0,
                semester: grade.semester || ''
              }
            }
            
            return {
              id: grade.id,
              student_id: grade.student.id,
              student_name: grade.student.name,
              course_id: grade.course.id,
              course_name: grade.course.name,
              credit: grade.course.credit || 0,
              score: grade.score || 0,
              gpa: grade.gpa || 0,
              semester: grade.semester || ''
            }
          })
        }
      }
    } else {
      // 教师和管理员使用高效的成绩分析API
      const response = await getGradeAnalysis(
        formData.course_id ? Number(formData.course_id) : undefined,
        formData.semester || undefined
      )
      
      // 直接使用API返回的统计数据
      stats.averageScore = response.averageScore || 0
      stats.gpa = response.gpa || 0
      stats.passRate = response.passRate || 0
      stats.excellentRate = response.excellentRate || 0
      
      // 如果需要详细的成绩列表，我们可能需要继续使用原API
      // 但为了性能优化，我们可以先只使用统计数据
      // 这里我们先保留原逻辑，后续可以进一步优化
      const gradeListResponse = await getAllGradesForAnalysis()
      
      // 转换成绩数据格式
      realScores.value = gradeListResponse.map((grade: any) => {
        if (!grade.student || !grade.course) {
          return {
            id: grade.id,
            student_id: 0,
            student_name: '未知学生',
            course_id: 0,
            course_name: '未知课程',
            credit: 0,
            score: 0,
            gpa: 0,
            semester: grade.semester || ''
          }
        }
        
        return {
          id: grade.id,
          student_id: grade.student.id,
          student_name: grade.student.name,
          course_id: grade.course.id,
          course_name: grade.course.name,
          credit: grade.course.credit || 0,
          score: grade.score || 0,
          gpa: grade.gpa || 0,
          semester: grade.semester || ''
        }
      })
    }
  } catch (error) {
    console.error('获取成绩数据失败:', error)
    ElMessage.error('获取成绩数据失败')
    realScores.value = []
  } finally {
    loading.value = false
  }
}

// 计算GPA（国内高校标准）
const calculateGPA = (score: number): number => {
  if (score >= 90) return 4.0
  if (score >= 85) return 3.7
  if (score >= 82) return 3.3
  if (score >= 78) return 3.0
  if (score >= 75) return 2.7
  if (score >= 72) return 2.3
  if (score >= 68) return 2.0
  if (score >= 64) return 1.5
  if (score >= 60) return 1.0
  return 0.0
}

// 图表引用
const chartRef = ref<HTMLElement | null>(null)
const trendChartRef = ref<HTMLElement | null>(null)
const radarChartRef = ref<HTMLElement | null>(null)
let chart: echarts.ECharts | null = null
let trendChart: echarts.ECharts | null = null
let radarChart: echarts.ECharts | null = null

// 过滤成绩数据
const filterScores = () => {
  let filtered = [...realScores.value]
  
  // 按课程过滤
  if (formData.course_id) {
    filtered = filtered.filter(score => score.course_id === Number(formData.course_id))
  }
  
  // 按学期过滤
  if (formData.semester) {
    filtered = filtered.filter(score => score.semester === formData.semester)
  }
  
  return filtered
}

// 计算统计数据
const calculateStats = (scores: ScoreData[]) => {
  if (scores.length === 0) {
    stats.averageScore = 0
    stats.gpa = 0
    stats.passRate = 0
    stats.excellentRate = 0
    return
  }
  
  // 计算平均分
  const totalScore = scores.reduce((sum, score) => sum + score.score, 0)
  stats.averageScore = totalScore / scores.length
  
  // 计算GPA
  if (userInfo.role === 'ROLE_ADMIN') {
    // 管理员全部采用平均分：GPA使用简单平均
    const totalGPA = scores.reduce((sum, score) => sum + score.gpa, 0)
    stats.gpa = totalGPA / scores.length
  } else {
    // 非管理员使用加权平均GPA（考虑课程学分）
    // 计算总学分
    const totalCredit = scores.reduce((sum, score) => sum + score.credit, 0)
    
    if (totalCredit === 0) {
      // 如果总学分为0，使用简单平均
      const totalGPA = scores.reduce((sum, score) => sum + score.gpa, 0)
      stats.gpa = totalGPA / scores.length
    } else {
      // 否则使用加权平均，使用数据库中的gpa值
      const weightedTotalGPA = scores.reduce((sum, score) => sum + score.gpa * score.credit, 0)
      stats.gpa = weightedTotalGPA / totalCredit
    }
  }
  
  // 计算及格率（60分及以上）
  const passedCount = scores.filter(score => score.score >= 60).length
  stats.passRate = passedCount / scores.length
  
  // 计算优秀率（90分及以上）
  const excellentCount = scores.filter(score => score.score >= 90).length
  stats.excellentRate = excellentCount / scores.length
}

// 计算成绩分布
const calculateScoreDistribution = (scores: ScoreData[]) => {
  // 初始化分布数组，确保每个区间都是0
  const distribution = [0, 0, 0, 0, 0]
  
  scores.forEach(score => {
    const scoreValue = score.score || 0
    if (scoreValue < 60) distribution[0]++
    else if (scoreValue < 70) distribution[1]++
    else if (scoreValue < 80) distribution[2]++
    else if (scoreValue < 90) distribution[3]++
    else distribution[4]++
  })
  
  return distribution
}

// 计算成绩趋势
const calculateScoreTrend = (scores: ScoreData[]) => {
  // 按学期分组
  const semesterGroups: Record<string, number[]> = {}
  
  scores.forEach(score => {
    const semester = score.semester || '未知学期'
    // 确保semesterGroups[semester]是数组
    if (!semesterGroups[semester]) {
      semesterGroups[semester] = []
    }
    semesterGroups[semester].push(score.score || 0)
  })
  
  // 计算每个学期的平均分
  const trend: { semester: string; average: number }[] = []
  
  Object.entries(semesterGroups).forEach(([semester, scoreArray]) => {
    if (Array.isArray(scoreArray) && scoreArray.length > 0) {
      const avg = scoreArray.reduce((sum, score) => sum + score, 0) / scoreArray.length
      trend.push({ semester, average: avg })
    }
  })
  
  // 按学期排序
  trend.sort((a, b) => {
    // 自定义排序函数，处理多种学期格式
    // 支持格式：2023-2024学年第一学期 或 2023-2024第一学期 或 2023-2024第二学期
    const semesterRegex = /^(\d{4}-\d{4})(?:学年)?(第?(一|二)学期)$/;
    
    const aMatch = a.semester.match(semesterRegex);
    const bMatch = b.semester.match(semesterRegex);
    
    if (aMatch && bMatch) {
      const aYear = aMatch[1];
      const bYear = bMatch[1];
      const aTerm = aMatch[2];
      const bTerm = bMatch[2];
      
      // 先按年份排序
      if (aYear !== bYear) {
        return aYear.localeCompare(bYear);
      }
      
      // 再按学期排序，第一学期在前
      return aTerm === '一' ? -1 : 1;
    }
    
    // 如果格式不匹配，使用默认排序
    return a.semester.localeCompare(b.semester);
  })
  
  return trend
}

// 计算课程对比数据
const calculateCourseComparison = (scores: ScoreData[]) => {
  // 按课程分组
  const courseGroups: Record<string, number[]> = {}
  
  scores.forEach(score => {
    const courseName = score.course_name || '未知课程'
    // 确保courseGroups[courseName]是数组
    if (!courseGroups[courseName]) {
      courseGroups[courseName] = []
    }
    courseGroups[courseName].push(score.score || 0)
  })
  
  // 计算每门课程的平均分
  const comparison: { course: string; average: number }[] = []
  
  Object.entries(courseGroups).forEach(([course, scoreArray]) => {
    if (Array.isArray(scoreArray) && scoreArray.length > 0) {
      const avg = scoreArray.reduce((sum, score) => sum + score, 0) / scoreArray.length
      comparison.push({ course, average: avg })
    }
  })
  
  return comparison
}

// 更新成绩分布柱状图
const updateScoreDistributionChart = (distribution: number[]) => {
  if (!chart && chartRef.value) {
    chart = echarts.init(chartRef.value)
  }
  
  if (chart) {
    // 根据用户角色调整图表配置
    const isStudentUser = isStudent
    const yAxisName = isStudentUser ? '科目数量' : '人数'
    const tooltipFormatter = isStudentUser ? '{b}: {c}门' : '{b}: {c}人'
    const seriesName = isStudentUser ? '科目数量' : '学生人数'
    
    const option = {
      tooltip: {
        trigger: 'axis',
        axisPointer: {
          type: 'shadow'
        },
        formatter: tooltipFormatter
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        data: ['60分以下', '60-69分', '70-79分', '80-89分', '90-100分']
      },
      yAxis: {
        type: 'value',
        name: yAxisName
      },
      series: [{
        data: distribution,
        type: 'bar',
        name: seriesName,
        itemStyle: {
          color: '#409eff'
        }
      }]
    }
    
    chart.setOption(option)
  }
}

// 更新成绩趋势折线图
const updateScoreTrendChart = (trend: { semester: string; average: number }[]) => {
  if (!trendChart && trendChartRef.value) {
    trendChart = echarts.init(trendChartRef.value)
  }
  
  if (trendChart && trend.length > 0) {
    const option = {
      tooltip: {
        trigger: 'axis',
        formatter: '{b}: {c:.2f}分'
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true
      },
      xAxis: {
        type: 'category',
        data: trend.map(item => item.semester)
      },
      yAxis: {
        type: 'value',
        name: '平均分',
        min: 0,
        max: 100
      },
      series: [{
        data: trend.map(item => item.average),
        type: 'line',
        name: '平均分',
        smooth: true,
        itemStyle: {
          color: '#67c23a'
        },
        areaStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: 'rgba(103, 194, 58, 0.3)' },
            { offset: 1, color: 'rgba(103, 194, 58, 0.1)' }
          ])
        }
      }]
    }
    
    trendChart.setOption(option)
  }
}

// 更新课程对比雷达图
const updateCourseComparisonChart = (comparison: { course: string; average: number }[]) => {
  if (!radarChart && radarChartRef.value) {
    radarChart = echarts.init(radarChartRef.value)
  }
  
  if (radarChart && comparison.length > 0) {
    const option = {
      tooltip: {
        trigger: 'item'
      },
      radar: {
        indicator: comparison.map(item => ({
          name: item.course,
          max: 100
        })),
        radius: '70%'
      },
      series: [{
        type: 'radar',
        data: [{
          value: comparison.map(item => item.average),
          name: '平均成绩'
        }],
        itemStyle: {
          color: '#e6a23c'
        },
        areaStyle: {
          color: new echarts.graphic.RadialGradient(0.5, 0.5, 1, [
            { offset: 0, color: 'rgba(230, 162, 60, 0.3)' },
            { offset: 1, color: 'rgba(230, 162, 60, 0.1)' }
          ])
        }
      }]
    }
    
    radarChart.setOption(option)
  }
}

// 处理分析
const handleAnalyze = () => {
  // 过滤数据
  const filteredScores = filterScores()
  
  // 计算统计数据
  calculateStats(filteredScores)
  
  // 更新图表
  const distribution = calculateScoreDistribution(filteredScores)
  updateScoreDistributionChart(distribution)
  
  const trend = calculateScoreTrend(filteredScores)
  updateScoreTrendChart(trend)
  
  const comparison = calculateCourseComparison(filteredScores)
  updateCourseComparisonChart(comparison)
  
  ElMessage.success('数据分析完成')
}

// 处理数据导出
const handleExport = () => {
  ElMessage.info('导出功能开发中')
}

// 监听窗口大小变化，调整图表大小
const handleResize = () => {
  chart?.resize()
  trendChart?.resize()
  radarChart?.resize()
}

// 初始化数据
const initData = async () => {
  await fetchCourses()
  await fetchScores()
}

onMounted(async () => {
  window.addEventListener('resize', handleResize)
  
  // 初始化数据
  await initData()
  
  // 页面加载时自动执行一次分析，显示初始数据
  handleAnalyze()
})
</script>

<style scoped>
.score-analysis-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.analysis-card {
  border-radius: 8px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 16px;
}

.form {
  margin-bottom: 20px;
}

.stats-cards {
  margin: 20px 0;
}

.stat-card {
  text-align: center;
  padding: 20px;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}

.stat-title {
  font-size: 14px;
  color: #606266;
  margin-bottom: 10px;
}

.stat-value {
  font-size: 28px;
  font-weight: bold;
  color: #409eff;
}

.chart-container {
  height: 400px;
  margin: 20px 0;
}

.chart-title {
  margin: 0 0 10px 0;
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}

.chart {
  width: 100%;
  height: 350px;
}
</style>