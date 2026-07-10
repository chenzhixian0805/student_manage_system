<template>
  <div class="logs-container">
    <el-card class="logs-card">
      <template #header>
        <div class="card-header">
          <h3 class="section-title">系统日志</h3>
          <div class="header-actions">
        <el-button type="primary" size="small" @click="refreshLogs">刷新</el-button>
        <el-button type="success" size="small" @click="generateTestLog">生成测试日志</el-button>
        <el-button type="danger" size="small" @click="clearLogs" :confirm-message="'确定要清空所有日志吗？'">清空</el-button>
      </div>
        </div>
      </template>
      
      <div class="logs-content">
        <!-- 日志筛选 -->
        <div class="logs-filter">
          <el-row :gutter="16">
            <el-col :xs="24" :sm="12" :md="8">
              <el-select v-model="filter.level" placeholder="日志级别" clearable>
                <el-option label="DEBUG" value="DEBUG"></el-option>
                <el-option label="INFO" value="INFO"></el-option>
                <el-option label="WARN" value="WARN"></el-option>
                <el-option label="ERROR" value="ERROR"></el-option>
              </el-select>
            </el-col>
            <el-col :xs="24" :sm="12" :md="8">
              <el-select v-model="filter.type" placeholder="日志类型" clearable>
                <el-option label="SYSTEM" value="SYSTEM"></el-option>
                <el-option label="OPERATION" value="OPERATION"></el-option>
                <el-option label="ERROR" value="ERROR"></el-option>
                <el-option label="ACCESS" value="ACCESS"></el-option>
              </el-select>
            </el-col>
            <el-col :xs="24" :sm="12" :md="8">
              <el-input v-model="filter.user" placeholder="用户名" clearable></el-input>
            </el-col>
          </el-row>
        </div>
        
        <!-- 日志列表 -->
        <div class="logs-list">
          <el-empty v-if="filteredLogs.length === 0" description="暂无日志记录"></el-empty>
          <el-timeline v-else>
            <el-timeline-item
              v-for="log in filteredLogs"
              :key="log.id"
              :timestamp="formatTime(log.timestamp)"
              :type="getTimelineType(log.level)"
              :color="getLevelColor(log.level)"
            >
              <div class="log-item">
                <div class="log-header">
                  <span class="log-level" :style="{ backgroundColor: getLevelColor(log.level) }">
                    {{ log.level }}
                  </span>
                  <span class="log-type">{{ log.type }}</span>
                  <span class="log-user">{{ log.user }}</span>
                  <span class="log-ip">{{ log.ip }}</span>
                </div>
                <div class="log-content">
                  <div class="log-action">{{ log.action }}: {{ log.message }}</div>
                  <div v-if="log.details" class="log-details">
                    <el-button type="text" size="small" @click="expandDetails(log)">
                      {{ expandedLogs.includes(log.id) ? '收起详情' : '查看详情' }}
                    </el-button>
                    <div v-if="expandedLogs.includes(log.id)" class="log-details-content">
                      <pre>{{ JSON.stringify(log.details, null, 2) }}</pre>
                    </div>
                  </div>
                </div>
              </div>
            </el-timeline-item>
          </el-timeline>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Logger, LogLevel, LogType } from '../utils/logger'

// 日志列表
const logs = ref<any[]>([])
const expandedLogs = ref<string[]>([])

// 筛选条件
const filter = ref({
  level: '',
  type: '',
  user: ''
})

// 格式化时间
const formatTime = (timestamp: string) => {
  const date = new Date(timestamp)
  return date.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  })
}

// 获取时间线类型
const getTimelineType = (level: string) => {
  switch (level) {
    case LogLevel.ERROR:
      return 'error'
    case LogLevel.WARN:
      return 'warning'
    case LogLevel.INFO:
      return 'success'
    default:
      return 'info'
  }
}

// 获取日志级别颜色
const getLevelColor = (level: string) => {
  switch (level) {
    case LogLevel.DEBUG:
      return '#909399'
    case LogLevel.INFO:
      return '#67c23a'
    case LogLevel.WARN:
      return '#e6a23c'
    case LogLevel.ERROR:
      return '#f56c6c'
    default:
      return '#909399'
  }
}

// 过滤日志
const filteredLogs = computed(() => {
  let result = [...logs.value]
  
  if (filter.value.level) {
    result = result.filter(log => log.level === filter.value.level)
  }
  
  if (filter.value.type) {
    result = result.filter(log => log.type === filter.value.type)
  }
  
  if (filter.value.user) {
    result = result.filter(log => log.user.includes(filter.value.user))
  }
  
  return result.reverse() // 倒序显示，最新的在前面
})

// 刷新日志
const refreshLogs = () => {
  loadLogs()
}

// 清空日志
const clearLogs = () => {
  Logger.clearLogs()
  logs.value = []
  ElMessage.success('日志已清空')
}

// 展开/收起详情
const expandDetails = (log: any) => {
  const index = expandedLogs.value.indexOf(log.id)
  if (index > -1) {
    expandedLogs.value.splice(index, 1)
  } else {
    expandedLogs.value.push(log.id)
  }
}

// 生成测试日志
const generateTestLog = () => {
  Logger.info(LogType.OPERATION, 'TEST_ACTION', '这是一条测试日志', { testData: 'test value', timestamp: new Date().toISOString() })
  ElMessage.success('测试日志已生成')
  refreshLogs()
}

// 加载日志
const loadLogs = () => {
  // 从Logger实例获取日志
  const loggerLogs = Logger.getAllLogs()
  logs.value = loggerLogs
  
  // 如果内存中没有日志，尝试从localStorage获取
  if (logs.value.length === 0) {
    try {
      const storedLogs = localStorage.getItem('system_logs')
      if (storedLogs) {
        const parsed = JSON.parse(storedLogs)
        if (Array.isArray(parsed)) {
          logs.value = parsed
        }
      }
    } catch (error) {
      console.error('Failed to load logs from localStorage:', error)
    }
  }
}

// 初始化
onMounted(() => {
  loadLogs()
})
</script>

<style scoped>
.logs-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
  padding: 0;
}

.logs-card {
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow-md);
  transition: var(--transition);
}

.logs-card:hover {
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

.header-actions {
  display: flex;
  gap: 12px;
}

.logs-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.logs-filter {
  padding: 16px;
  background-color: var(--bg-secondary);
  border-radius: var(--border-radius-md);
}

.logs-list {
  max-height: 600px;
  overflow-y: auto;
  padding-right: 8px;
}

.log-item {
  background-color: var(--bg-secondary);
  border-radius: var(--border-radius-md);
  padding: 16px;
  box-shadow: var(--shadow-sm);
  transition: var(--transition);
}

.log-item:hover {
  box-shadow: var(--shadow-md);
}

.log-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 8px;
  flex-wrap: wrap;
}

.log-level {
  padding: 2px 8px;
  border-radius: 4px;
  color: white;
  font-size: 12px;
  font-weight: 500;
}

.log-type {
  font-size: 13px;
  color: var(--text-secondary);
  background-color: var(--bg-primary);
  padding: 2px 8px;
  border-radius: 4px;
}

.log-user {
  font-size: 13px;
  font-weight: 500;
  color: var(--text-primary);
}

.log-ip {
  font-size: 12px;
  color: var(--text-placeholder);
}

.log-content {
  margin-top: 8px;
}

.log-action {
  font-size: 14px;
  color: var(--text-primary);
  line-height: 1.5;
}

.log-details {
  margin-top: 8px;
}

.log-details-content {
  margin-top: 8px;
  background-color: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: var(--border-radius-sm);
  padding: 12px;
  overflow-x: auto;
}

.log-details-content pre {
  margin: 0;
  font-size: 13px;
  line-height: 1.4;
  color: var(--text-regular);
}

/* 滚动条样式 */
.logs-list::-webkit-scrollbar {
  width: 6px;
}

.logs-list::-webkit-scrollbar-track {
  background: var(--bg-tertiary);
  border-radius: 3px;
}

.logs-list::-webkit-scrollbar-thumb {
  background: var(--border-color);
  border-radius: 3px;
}

.logs-list::-webkit-scrollbar-thumb:hover {
  background: var(--text-placeholder);
}

@media (max-width: 768px) {
  .log-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 8px;
  }
}
</style>