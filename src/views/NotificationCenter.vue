<template>
  <div class="notification-center-container">
    <el-card class="notification-card">
      <template #header>
        <div class="card-header">
          <h3 class="section-title">通知中心</h3>
          <div class="header-actions">
            <el-button type="primary" size="small" @click="markAllAsRead">
              <el-icon><Check /></el-icon>
              全部已读
            </el-button>
            <el-button type="success" size="small" @click="handleRefresh">
              <el-icon><Refresh /></el-icon>
              刷新
            </el-button>
          </div>
        </div>
      </template>
      
      <!-- 通知列表 -->
      <div class="notification-list-container">
        <div v-if="loading" class="loading-container">
          <el-skeleton :rows="5" animated></el-skeleton>
        </div>
        
        <el-empty v-else-if="notifications.length === 0" description="暂无通知"></el-empty>
        
        <el-timeline v-else>
          <el-timeline-item
            v-for="notification in notifications"
            :key="notification.id"
            :timestamp="notification.time"
            :class="{ 'unread-notification': !notification.read }"
          >
            <el-card
              :class="{ 'notification-card-item': true, 'unread': !notification.read }"
              @click="handleNotificationClick(notification)"
            >
              <div class="notification-header">
                <div class="notification-title">{{ notification.title }}</div>
                <el-tag v-if="!notification.read" size="small" type="danger">未读</el-tag>
              </div>
              <div class="notification-content">{{ notification.message }}</div>
              <div class="notification-actions">
                <el-button
                  type="text"
                  size="small"
                  @click.stop="markAsRead(notification.id)"
                >
                  标记已读
                </el-button>
                <el-button
                  type="text"
                  size="small"
                  @click.stop="handleDelete(notification.id)"
                  danger
                >
                  删除
                </el-button>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </div>
      
      <!-- 分页 -->
      <div v-if="notifications.length > 0" class="pagination-container" :class="{ 'loading': loading }">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.size"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="pagination.total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          prev-text="上一页"
          next-text="下一页"
        ></el-pagination>
      </div>
      <!-- 空状态 -->
      <div v-else class="pagination-container empty">
        暂无通知数据
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Check, Refresh } from '@element-plus/icons-vue'
import { useUserStore } from '../store/user'

interface Notification {
  id: number
  title: string
  message: string
  time: string
  read: boolean
  type: 'grade' | 'attendance' | 'system' | 'announcement'
}

const router = useRouter()
const userStore = useUserStore()
const loading = ref(false)

// 获取当前学生信息
const currentStudent = userStore.userInfo
const studentName = currentStudent?.name || '学生'
const studentId = currentStudent?.username || '000000'

// 生成与当前学生相关的通知数据
const generateStudentNotifications = () => {
  // 获取当前日期时间
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')
  const currentDate = `${year}-${month}-${day}`
  const currentTime = `${hours}:${minutes}`
  
  return [
    {
      id: 1,
      title: '成绩更新',
      message: `${studentName}同学，您的计算机基础课程成绩已更新为88分，绩点3.3`,
      time: `${currentDate} ${currentTime}`,
      read: false,
      type: 'grade'
    },
    {
      id: 2,
      title: '考勤提醒',
      message: `${studentName}同学(${studentId})，您有1次迟到记录，请注意按时上课`,
      time: `${currentDate} ${parseInt(hours) - 1}:${minutes}`,
      read: false,
      type: 'attendance'
    },
    {
      id: 3,
      title: '作业提醒',
      message: `${studentName}同学，数据结构课程作业已发布，请在${year}-${month}-${parseInt(day) + 3}前完成`,
      time: `${currentDate} ${parseInt(hours) - 2}:${minutes}`,
      read: true,
      type: 'announcement'
    },
    {
      id: 4,
      title: '课程通知',
      message: `${studentName}同学，您的高等数学课程时间有调整，请查看课表`,
      time: `${currentDate} ${parseInt(hours) - 3}:${minutes}`,
      read: true,
      type: 'system'
    },
    {
      id: 5,
      title: '考试提醒',
      message: `${studentName}同学，期末考试将于${year}-${month}-${parseInt(day) + 7}开始，请做好准备`,
      time: `${currentDate} ${parseInt(hours) - 4}:${minutes}`,
      read: true,
      type: 'system'
    }
  ]
}

// 通知数据
const notifications = ref<Notification[]>(generateStudentNotifications())

// 分页配置
const pagination = reactive({
  page: 1,
  size: 10,
  total: 5
})

// 标记单个通知为已读
const markAsRead = (id: number) => {
  const notification = notifications.value.find(n => n.id === id)
  if (notification) {
    notification.read = true
    ElMessage.success('已标记为已读')
  }
}

// 标记所有通知为已读
const markAllAsRead = () => {
  notifications.value.forEach(n => {
    n.read = true
  })
  ElMessage.success('全部通知已标记为已读')
}

// 处理通知点击
const handleNotificationClick = (notification: Notification) => {
  // 标记为已读
  if (!notification.read) {
    notification.read = true
  }
  
  // 根据通知类型跳转到相应页面
  switch (notification.type) {
    case 'grade':
      if (router && typeof router.push === 'function') {
        router.push('/scores/my-scores')
      }
      break
    case 'attendance':
      if (router && typeof router.push === 'function') {
        router.push('/attendance/my-attendance')
      }
      break
    default:
      // 系统通知和公告暂时不跳转
      ElMessage.info('通知详情功能开发中')
  }
}

// 处理删除通知
const handleDelete = (id: number) => {
  ElMessageBox.confirm('确定要删除该通知吗？', '删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      const index = notifications.value.findIndex(n => n.id === id)
      if (index > -1) {
        notifications.value.splice(index, 1)
        pagination.total--
        ElMessage.success('删除成功')
      }
    })
    .catch(() => {
      // 取消删除
    })
}

// 处理刷新
const handleRefresh = () => {
  loading.value = true
  setTimeout(() => {
    // 重新生成与学生相关的通知
    notifications.value = generateStudentNotifications()
    loading.value = false
    ElMessage.success('刷新成功')
  }, 500)
}

// 处理分页大小变化
const handleSizeChange = (size: number) => {
  pagination.size = size
  pagination.page = 1
  // 这里应该调用API获取数据
}

// 处理当前页码变化
const handleCurrentChange = (page: number) => {
  pagination.page = page
  // 这里应该调用API获取数据
}

onMounted(() => {
  // 页面加载时获取通知数据
  loading.value = true
  setTimeout(() => {
    loading.value = false
  }, 500)
})
</script>

<style scoped>
.notification-center-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.section-title {
  font-size: 18px;
  font-weight: 600;
  margin: 0;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.notification-list-container {
  margin-top: 20px;
}

.loading-container {
  padding: 20px;
}

.notification-card-item {
  cursor: pointer;
  transition: all 0.3s ease;
  margin-bottom: 10px;
  border-left: 4px solid transparent;
}

.notification-card-item:hover {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.notification-card-item.unread {
  border-left-color: #f56c6c;
  background-color: #fef0f0;
}

.notification-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 10px;
}

.notification-title {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
}

.notification-content {
  font-size: 14px;
  color: #606266;
  margin-bottom: 15px;
  line-height: 1.5;
}

.notification-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
}

.unread-notification .el-timeline-item__timestamp {
  color: #f56c6c;
  font-weight: 600;
}

@media (max-width: 768px) {
  .card-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
  
  .header-actions {
    width: 100%;
    justify-content: space-between;
  }
  
  .notification-actions {
    flex-direction: column;
    align-items: flex-end;
    gap: 5px;
  }
}
</style>
