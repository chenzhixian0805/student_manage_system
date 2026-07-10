<template>
  <div class="home-container">
    <!-- 欢迎卡片 -->
    <el-card class="welcome-card">
      <div class="welcome-content">
        <div class="welcome-header">
          <h3 class="welcome-title">
            <el-icon class="welcome-icon"><House /></el-icon>
            欢迎回来，{{ userStore.userInfo?.name || '未知用户' }}
          </h3>
          <p class="welcome-subtitle">
            当前角色：{{ userStore.userInfo?.role === 'ROLE_ADMIN' ? '管理员' : userStore.userInfo?.role === 'ROLE_TEACHER' ? '教师' : '学生' }}
          </p>
        </div>
        <div class="system-stats">
          <el-row :gutter="24">
            <!-- 学生视角 -->
            <template v-if="userStore.userInfo?.role === 'ROLE_STUDENT'">
              <el-col :xs="12" :sm="12" :md="8" :lg="6">
                <div 
                  class="stat-card"
                  @click="navigateTo('/students/my-info')"
                  style="cursor: pointer;"
                >
                  <div class="stat-icon student-icon">
                    <div class="stat-icon-inner">
                      <el-icon><User /></el-icon>
                    </div>
                  </div>
                  <div class="stat-info">
                    <div class="stat-value">我的信息</div>
                    <div class="stat-label">查看和编辑个人信息</div>
                  </div>
                </div>
              </el-col>
              <el-col :xs="12" :sm="12" :md="8" :lg="6">
                <div 
                  class="stat-card"
                  @click="navigateTo('/scores/my-scores')"
                  style="cursor: pointer;"
                >
                  <div class="stat-icon course-icon">
                    <div class="stat-icon-inner">
                      <el-icon><Document /></el-icon>
                    </div>
                  </div>
                  <div class="stat-info">
                    <div class="stat-value">我的成绩</div>
                    <div class="stat-label">查看个人成绩</div>
                  </div>
                </div>
              </el-col>
              <el-col :xs="12" :sm="12" :md="8" :lg="6">
                <div 
                  class="stat-card"
                  @click="navigateTo('/courses')"
                  style="cursor: pointer;"
                >
                  <div class="stat-icon score-icon">
                    <div class="stat-icon-inner">
                      <el-icon><Collection /></el-icon>
                    </div>
                  </div>
                  <div class="stat-info">
                    <div class="stat-value">课程列表</div>
                    <div class="stat-label">查看所有课程</div>
                  </div>
                </div>
              </el-col>
              <el-col :xs="12" :sm="12" :md="8" :lg="6">
                <div 
                  class="stat-card"
                  @click="navigateTo('/scores/analysis')"
                  style="cursor: pointer;"
                >
                  <div class="stat-icon avg-score-icon">
                    <div class="stat-icon-inner">
                      <el-icon><DataAnalysis /></el-icon>
                    </div>
                  </div>
                  <div class="stat-info">
                    <div class="stat-value">成绩分析</div>
                    <div class="stat-label">查看成绩统计</div>
                  </div>
                </div>
              </el-col>
            </template>
            <!-- 管理员/教师视角 -->
            <template v-else>
              <el-col :xs="12" :sm="12" :md="8" :lg="6">
                <div 
                  class="stat-card"
                  @click="navigateTo('/students')"
                  style="cursor: pointer;"
                >
                  <div class="stat-icon student-icon">
                    <div class="stat-icon-inner">
                      <el-icon><User /></el-icon>
                    </div>
                  </div>
                  <div class="stat-info">
                    <div class="stat-value">{{ studentCount }}</div>
                    <div class="stat-label">学生总数</div>
                  </div>
                  <div class="stat-trend">
                    <el-icon color="#67c23a"><CaretTop /></el-icon>
                    <span>+12%</span>
                  </div>
                </div>
              </el-col>
              <el-col :xs="12" :sm="12" :md="8" :lg="6">
                <div 
                  class="stat-card"
                  @click="navigateTo('/courses')"
                  style="cursor: pointer;"
                >
                  <div class="stat-icon course-icon">
                    <div class="stat-icon-inner">
                      <el-icon><Collection /></el-icon>
                    </div>
                  </div>
                  <div class="stat-info">
                    <div class="stat-value">{{ courseCount }}</div>
                    <div class="stat-label">课程总数</div>
                  </div>
                  <div class="stat-trend">
                    <el-icon color="#67c23a"><CaretTop /></el-icon>
                    <span>+5%</span>
                  </div>
                </div>
              </el-col>
              <el-col :xs="12" :sm="12" :md="8" :lg="6">
                <div 
                  class="stat-card"
                  @click="navigateTo('/scores')"
                  style="cursor: pointer;"
                >
                  <div class="stat-icon score-icon">
                    <div class="stat-icon-inner">
                      <el-icon><Document /></el-icon>
                    </div>
                  </div>
                  <div class="stat-info">
                    <div class="stat-value">{{ gradeCount }}</div>
                    <div class="stat-label">成绩记录</div>
                  </div>
                  <div class="stat-trend">
                    <el-icon color="#67c23a"><CaretTop /></el-icon>
                    <span>+8%</span>
                  </div>
                </div>
              </el-col>
              <el-col :xs="12" :sm="12" :md="8" :lg="6">
                <div 
                  class="stat-card"
                  @click="navigateTo('/scores/analysis')"
                  style="cursor: pointer;"
                >
                  <div class="stat-icon avg-score-icon">
                    <div class="stat-icon-inner">
                      <el-icon><DataAnalysis /></el-icon>
                    </div>
                  </div>
                  <div class="stat-info">
                    <div class="stat-value">{{ averageScore ? averageScore.toFixed(1) : 0 }}</div>
                    <div class="stat-label">平均成绩</div>
                  </div>
                  <div class="stat-trend">
                    <el-icon color="#e6a23c"><CaretBottom /></el-icon>
                    <span>-2%</span>
                  </div>
                </div>
              </el-col>
            </template>
          </el-row>
        </div>
      </div>
    </el-card>
    
    <!-- 快捷操作卡片 -->
    <el-card class="quick-actions-card">
      <template #header>
        <div class="card-header">
          <h3 class="section-title">快捷操作</h3>
        </div>
      </template>
      <div class="quick-actions">
        <el-row :gutter="24">
          <!-- 学生视角 -->
          <template v-if="userStore.userInfo?.role === 'ROLE_STUDENT'">
            <el-col :xs="12" :sm="12" :md="8" :lg="6">
              <el-button
                type="primary"
                link
                class="quick-action-btn"
                @click="navigateTo('/students/my-info')"
                :icon="UserFilled"
              >
                <div class="quick-action-content">
                  <div class="quick-action-title">我的信息</div>
                  <div class="quick-action-desc">查看和编辑个人信息</div>
                </div>
              </el-button>
            </el-col>
            <el-col :xs="12" :sm="12" :md="8" :lg="6">
              <el-button
                type="success"
                link
                class="quick-action-btn"
                @click="navigateTo('/scores/my-scores')"
                :icon="Document"
              >
                <div class="quick-action-content">
                  <div class="quick-action-title">我的成绩</div>
                  <div class="quick-action-desc">查看我的各科成绩</div>
                </div>
              </el-button>
            </el-col>
            <el-col :xs="12" :sm="12" :md="8" :lg="6">
              <el-button
                type="warning"
                link
                class="quick-action-btn"
                @click="navigateTo('/courses')"
                :icon="Collection"
              >
                <div class="quick-action-content">
                  <div class="quick-action-title">课程列表</div>
                  <div class="quick-action-desc">查看所有课程信息</div>
                </div>
              </el-button>
            </el-col>
            <el-col :xs="12" :sm="12" :md="8" :lg="6">
              <el-button
                type="info"
                link
                class="quick-action-btn"
                @click="navigateTo('/scores/analysis')"
                :icon="DataAnalysis"
              >
                <div class="quick-action-content">
                  <div class="quick-action-title">成绩分析</div>
                  <div class="quick-action-desc">查看我的成绩统计分析</div>
                </div>
              </el-button>
            </el-col>
          </template>
          <!-- 管理员/教师视角 -->
          <template v-else>
            <el-col :xs="12" :sm="12" :md="8" :lg="6">
              <el-button
                type="primary"
                link
                class="quick-action-btn"
                @click="navigateTo('/students')"
                :icon="UserFilled"
              >
                <div class="quick-action-content">
                  <div class="quick-action-title">学生管理</div>
                  <div class="quick-action-desc">查看和管理学生信息</div>
                </div>
              </el-button>
            </el-col>
            <el-col :xs="12" :sm="12" :md="8" :lg="6">
              <el-button
                type="success"
                link
                class="quick-action-btn"
                @click="navigateTo('/scores')"
                :icon="Document"
              >
                <div class="quick-action-content">
                  <div class="quick-action-title">成绩管理</div>
                  <div class="quick-action-desc">查看和管理成绩信息</div>
                </div>
              </el-button>
            </el-col>
            <el-col :xs="12" :sm="12" :md="8" :lg="6">
              <el-button
                type="warning"
                link
                class="quick-action-btn"
                @click="navigateTo('/courses')"
                :icon="Collection"
              >
                <div class="quick-action-content">
                  <div class="quick-action-title">课程管理</div>
                  <div class="quick-action-desc">查看和管理课程信息</div>
                </div>
              </el-button>
            </el-col>
            <el-col :xs="12" :sm="12" :md="8" :lg="6">
              <el-button
                type="info"
                link
                class="quick-action-btn"
                @click="navigateTo('/scores/analysis')"
                :icon="DataAnalysis"
              >
                <div class="quick-action-content">
                  <div class="quick-action-title">成绩分析</div>
                  <div class="quick-action-desc">查看成绩统计分析</div>
                </div>
              </el-button>
            </el-col>
          </template>
        </el-row>
      </div>
    </el-card>
    
    <!-- 统计图表卡片 -->
    <el-row :gutter="24">
      <!-- 学生视角 -->
      <template v-if="userStore.userInfo?.role === 'ROLE_STUDENT'">
        <el-col :xs="24">
          <el-card class="stats-card">
            <template #header>
              <div class="card-header">
                <h3 class="section-title">我的成绩概览</h3>
              </div>
            </template>
            <div class="chart-container" ref="scoreDistributionChartRef"></div>
          </el-card>
        </el-col>
      </template>
      <!-- 管理员/教师视角 -->
      <template v-else>
        <el-col :xs="24" :md="12">
          <el-card class="stats-card">
            <template #header>
              <div class="card-header">
                <h3 class="section-title">学生状态分布</h3>
              </div>
            </template>
            <div class="chart-container" ref="studentStatusChartRef"></div>
          </el-card>
        </el-col>
        <el-col :xs="24" :md="12">
          <el-card class="stats-card">
            <template #header>
              <div class="card-header">
                <h3 class="section-title">成绩分布</h3>
              </div>
            </template>
            <div class="chart-container" ref="scoreDistributionChartRef"></div>
          </el-card>
        </el-col>
      </template>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../store/user'
import * as echarts from 'echarts'
import {
    House,
    User,
    UserFilled,
    Collection,
    Document,
    DataAnalysis,
    CaretTop,
    CaretBottom
} from '@element-plus/icons-vue'
import request from '../utils/request'
import { getStudentByStudentId } from '../api/studentApi'
import { getGradesByStudentId } from '../api/gradeApi'

const router = useRouter()
const userStore = useUserStore()

// 首页统计数据
const studentCount = ref<number>(0)
const courseCount = ref<number>(0)
const gradeCount = ref<number>(0)
const averageScore = ref<number>(0)

// 图表引用
const studentStatusChartRef = ref<HTMLElement | null>(null)
const scoreDistributionChartRef = ref<HTMLElement | null>(null)
let studentStatusChart: echarts.ECharts | null = null
let scoreDistributionChart: echarts.ECharts | null = null

// 从API获取学生总数
const fetchStudentCount = async () => {
  try {
    const count = await request.get('/api/students/count')
    studentCount.value = count
  } catch (error) {
    console.error('获取学生总数失败:', error)
  }
}

// 从API获取课程总数
const fetchCourseCount = async () => {
  try {
    const count = await request.get('/api/courses/count')
    courseCount.value = count
  } catch (error) {
    console.error('获取课程总数失败:', error)
  }
}

// 从API获取成绩记录总数
const fetchGradeCount = async () => {
  try {
    const count = await request.get('/api/grades/count')
    gradeCount.value = count
  } catch (error) {
    console.error('获取成绩记录总数失败:', error)
  }
}

// 从API获取整体平均成绩
const fetchAverageScore = async () => {
  try {
    const score = await request.get('/api/grades/statistics/average')
    averageScore.value = score
  } catch (error) {
    console.error('获取整体平均成绩失败:', error)
  }
}

// 获取所有首页数据
const fetchHomeData = async () => {
  await Promise.all([
    fetchStudentCount(),
    fetchCourseCount(),
    fetchGradeCount(),
    fetchAverageScore()
  ])
}

// 导航到指定页面
const navigateTo = (path: string) => {
  if (router && typeof router.push === 'function') {
    router.push(path)
  }
}

// 从API获取学生状态统计
const fetchStudentStatusStatistics = async () => {
  try {
    const stats = await request.get('/api/students/status-statistics')
    return stats
  } catch (error) {
    console.error('获取学生状态统计失败:', error)
    return []
  }
}

// 初始化学生状态分布图表
const initStudentStatusChart = async () => {
  if (studentStatusChartRef.value) {
    studentStatusChart = echarts.init(studentStatusChartRef.value)
    
    // 从API获取真实数据
    const statusStats = await fetchStudentStatusStatistics()
    
    // 处理数据，确保所有状态都有值
    const statusMap = new Map([
      ['在读', 0],
      ['休学', 0],
      ['退学', 0],
      ['毕业', 0]
    ])
    
    // 更新实际统计数据
    statusStats.forEach((stat: any) => {
      if (stat && stat.length >= 2) {
        const status = stat[0]
        const count = stat[1]
        if (statusMap.has(status)) {
          statusMap.set(status, count)
        }
      }
    })
    
    // 准备图表数据
    const chartData = [
      { value: statusMap.get('在读') || 0, name: '在读', itemStyle: { color: '#67c23a' } },
      { value: statusMap.get('休学') || 0, name: '休学', itemStyle: { color: '#e6a23c' } },
      { value: statusMap.get('退学') || 0, name: '退学', itemStyle: { color: '#f56c6c' } },
      { value: statusMap.get('毕业') || 0, name: '毕业', itemStyle: { color: '#409eff' } }
    ]
    
    const option = {
      tooltip: {
        trigger: 'item',
        formatter: '{b}: {c} ({d}%)'
      },
      legend: {
        orient: 'vertical',
        left: 'left',
        top: 'center',
        itemGap: 16,
        textStyle: {
          fontSize: 14
        }
      },
      series: [
        {
          name: '学生状态',
          type: 'pie',
          radius: ['40%', '70%'],
          center: ['65%', '50%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 12,
            borderColor: '#fff',
            borderWidth: 2
          },
          label: {
            show: false,
            position: 'center'
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 24,
              fontWeight: 'bold'
            }
          },
          labelLine: {
            show: false
          },
          data: chartData
        }
      ]
    }
    
    studentStatusChart.setOption(option)
  }
}

// 计算成绩分布
const calculateScoreDistribution = (scores: any[]) => {
  // 初始化分布数组，确保每个区间都是0
  const distribution = [0, 0, 0, 0, 0]
  
  scores.forEach(score => {
    // 确保score是数字类型，处理可能的null或undefined情况
    const scoreValue = typeof score.score === 'number' ? score.score : 0
    if (scoreValue < 60) distribution[0]++
    else if (scoreValue < 70) distribution[1]++
    else if (scoreValue < 80) distribution[2]++
    else if (scoreValue < 90) distribution[3]++
    else distribution[4]++
  })
  
  return distribution
}

// 初始化成绩分布图表
const initScoreDistributionChart = async () => {
  if (scoreDistributionChartRef.value) {
    scoreDistributionChart = echarts.init(scoreDistributionChartRef.value)
    
    // 根据用户角色调整图表配置
    const isStudentUser = userStore.userInfo?.role === 'ROLE_STUDENT'
    const yAxisName = isStudentUser ? '科目数量' : '人数'
    const tooltipFormatter = isStudentUser ? '{b}: {c}门' : '{b}: {c}人'
    const seriesName = isStudentUser ? '科目数量' : '人数'
    
    let realData = [15, 35, 120, 180, 100] // 默认数据
    
    if (isStudentUser) {
      // 如果是学生角色，获取真实成绩数据
      try {
        // 使用userStore中的用户信息
        const userInfo = userStore.userInfo
        if (userInfo) {
          const studentIdStr = userInfo.username
          
          // 首先通过学号获取学生信息，包括数据库中的主键id
          const student = await getStudentByStudentId(studentIdStr)
          
          if (student && student.id) {
            // 使用学生的主键id获取成绩
            const grades = await getGradesByStudentId(student.id)
            
            // 计算成绩分布
            realData = calculateScoreDistribution(grades)
          }
        }
      } catch (error) {
        console.error('获取学生成绩数据失败:', error)
      }
    } else {
      // 如果是管理员或教师角色，从API获取成绩分布数据
      try {
        const distribution = await request.get('/api/grades/statistics/distribution')
        if (Array.isArray(distribution)) {
          realData = distribution
        }
      } catch (error) {
        console.error('获取成绩分布数据失败:', error)
      }
    }
    
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
        data: ['60分以下', '60-69分', '70-79分', '80-89分', '90-100分'],
        axisLabel: {
          fontSize: 12
        }
      },
      yAxis: {
        type: 'value',
        name: yAxisName,
        axisLabel: {
          fontSize: 12
        }
      },
      series: [
        {
          name: seriesName,
          type: 'bar',
          barWidth: '60%',
          data: realData,
          itemStyle: {
            borderRadius: [8, 8, 0, 0],
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#409eff' },
              { offset: 1, color: '#66b1ff' }
            ])
          },
          emphasis: {
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: '#66b1ff' },
                { offset: 1, color: '#89c9ff' }
              ])
            }
          }
        }
      ]
    }
    
    scoreDistributionChart.setOption(option)
  }
}

// 监听窗口大小变化，调整图表大小
const handleResize = () => {
  studentStatusChart?.resize()
  scoreDistributionChart?.resize()
}

onMounted(async () => {
  await fetchHomeData()
  // 根据用户角色初始化不同的图表
  if (userStore.userInfo?.role !== 'ROLE_STUDENT') {
    await initStudentStatusChart()
  }
  await initScoreDistributionChart()
  window.addEventListener('resize', handleResize)
})
</script>

<style scoped>
.home-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
  padding: 0;
}

/* 欢迎卡片样式 */
.welcome-card {
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow-md);
  overflow: hidden;
  transition: var(--transition);
}

.welcome-card:hover {
  box-shadow: var(--shadow-lg);
}

.welcome-content {
  padding: 24px;
}

.welcome-header {
  margin-bottom: 30px;
}

.welcome-title {
  display: flex;
  align-items: center;
  gap: 12px;
  font-size: 24px;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 8px 0;
}

.welcome-icon {
  font-size: 28px;
  color: var(--primary-color);
}

.welcome-subtitle {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
}

/* 统计卡片样式 */
.system-stats {
  margin-top: 24px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  background-color: var(--bg-secondary);
  border-radius: var(--border-radius-md);
  transition: var(--transition);
  box-shadow: var(--shadow-sm);
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
  background-color: var(--bg-primary);
}

/* 统计卡片图标容器 - 圆形背景 */
.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

/* 学生总数图标背景 */
.student-icon {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

/* 课程总数图标背景 */
.course-icon {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

/* 成绩记录图标背景 */
.score-icon {
  background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
}

/* 平均成绩图标背景 */
.avg-score-icon {
  background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
}

/* 图标内部容器 - 用于统一图标大小 */
.stat-icon-inner {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
}

/* 确保图标大小一致 */
.stat-icon-inner .el-icon {
  font-size: 24px !important;
  width: 24px !important;
  height: 24px !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

.stat-icon-inner .el-icon svg {
  width: 24px !important;
  height: 24px !important;
  flex: none !important;
}

/* 统计信息 */
.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 24px;
  font-weight: 700;
  color: var(--text-primary);
  line-height: 1;
}

.stat-label {
  font-size: 14px;
  color: var(--text-secondary);
  margin-top: 4px;
}

/* 统计趋势 */
.stat-trend {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 12px;
  font-weight: 500;
}

/* 快捷操作卡片样式 */
.quick-actions-card {
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow-md);
  transition: var(--transition);
}

.quick-actions-card:hover {
  box-shadow: var(--shadow-lg);
}

.quick-actions {
  padding: 8px 0;
}

.quick-action-btn {
  display: block;
  width: 100%;
  text-align: left;
  padding: 20px;
  margin: 0;
  border-radius: var(--border-radius-md);
  background-color: var(--bg-secondary);
  transition: var(--transition);
  box-shadow: var(--shadow-sm);
}

.quick-action-btn:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-md);
  background-color: var(--bg-primary);
}

.quick-action-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.quick-action-title {
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
}

.quick-action-desc {
  font-size: 12px;
  color: var(--text-secondary);
}

/* 统计图表卡片样式 */
.stats-card {
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow-md);
  transition: var(--transition);
  height: 100%;
}

.stats-card:hover {
  box-shadow: var(--shadow-lg);
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.section-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0;
}

.chart-container {
  width: 100%;
  height: 350px;
  padding: 10px 0;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .welcome-title {
    font-size: 20px;
  }
  
  .welcome-icon {
    font-size: 24px;
  }
  
  .stat-card {
    padding: 16px;
  }
  
  .stat-icon {
    width: 50px;
    height: 50px;
  }
  
  .stat-icon-inner {
    width: 28px;
    height: 28px;
    font-size: 20px;
  }
  
  .stat-icon-inner .el-icon {
    font-size: 20px !important;
    width: 20px !important;
    height: 20px !important;
  }
  
  .stat-icon-inner .el-icon svg {
    width: 20px !important;
    height: 20px !important;
  }
  
  .stat-value {
    font-size: 20px;
  }
  
  .chart-container {
    height: 300px;
  }
  
  .quick-action-btn {
    padding: 16px;
  }
  
  .quick-action-title {
    font-size: 14px;
  }
}

@media (max-width: 480px) {
  .welcome-content {
    padding: 16px;
  }
  
  .system-stats :deep(.el-col) {
    margin-bottom: 16px;
  }
  
  .quick-actions :deep(.el-col) {
    margin-bottom: 16px;
  }
  
  .chart-container {
    height: 250px;
  }
}
</style>