<template>
  <div class="layout-container">
    <div class="sidebar" :class="{ 'sidebar-collapsed': !sidebarOpen }">
      <div class="sidebar-header">
        <h3 class="sidebar-title" v-if="sidebarOpen">学生管理系统</h3>
        <el-icon class="sidebar-logo" v-else><School /></el-icon>
        <el-button type="text" @click="toggleSidebar" class="collapse-btn">
          <el-icon>
            <ArrowLeft v-if="sidebarOpen" />
            <ArrowRight v-else />
          </el-icon>
        </el-button>
      </div>
      
      <el-menu
        :default-active="activeMenu"
        class="sidebar-menu"
        router
        unique-opened
        :collapse="!sidebarOpen"
      >
        <el-menu-item index="/">
          <el-icon><House /></el-icon>
          <template #title>首页</template>
        </el-menu-item>
        
        <el-sub-menu index="students" v-if="hasPermission(['ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_STUDENT'])">
          <template #title>
            <el-icon><User /></el-icon>
            <span>学生管理</span>
          </template>
          <el-menu-item index="/students" v-if="hasPermission(['ROLE_ADMIN', 'ROLE_TEACHER'])" @click="handleMenuClick">学生列表</el-menu-item>
          <el-menu-item index="/students/my-info" v-if="hasPermission(['ROLE_STUDENT'])" @click="handleMenuClick">我的信息</el-menu-item>
        </el-sub-menu>
        
        <el-sub-menu index="teachers" v-if="hasPermission(['ROLE_ADMIN'])">
          <template #title>
            <el-icon><UserFilled /></el-icon>
            <span>教师管理</span>
          </template>
          <el-menu-item index="/teachers" v-if="hasPermission(['ROLE_ADMIN'])" @click="handleMenuClick">教师列表</el-menu-item>
        </el-sub-menu>
        
        <el-sub-menu index="scores" v-if="hasPermission(['ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_STUDENT'])">
          <template #title>
            <el-icon><Document /></el-icon>
            <span>成绩管理</span>
          </template>
          <el-menu-item index="/scores" v-if="hasPermission(['ROLE_ADMIN', 'ROLE_TEACHER'])" @click="handleMenuClick">成绩列表</el-menu-item>
          <el-menu-item index="/scores/my-scores" v-if="hasPermission(['ROLE_STUDENT'])" @click="handleMenuClick">我的成绩</el-menu-item>
          <el-menu-item index="/scores/analysis" v-if="hasPermission(['ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_STUDENT'])" @click="handleMenuClick">成绩分析</el-menu-item>
        </el-sub-menu>
        
        <el-sub-menu index="courses" v-if="hasPermission(['ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_STUDENT'])">
          <template #title>
            <el-icon><Collection /></el-icon>
            <span>课程管理</span>
          </template>
          <el-menu-item index="/courses" @click="handleMenuClick">课程列表</el-menu-item>
        </el-sub-menu>
        

        
        <el-menu-item index="/users" v-if="hasPermission(['ROLE_ADMIN'])" @click="handleMenuClick">
          <el-icon><User /></el-icon>
          <template #title>用户管理</template>
        </el-menu-item>
        
        <el-menu-item index="/settings" v-if="hasPermission(['ROLE_ADMIN'])" @click="handleMenuClick">
          <el-icon><Setting /></el-icon>
          <template #title>系统设置</template>
        </el-menu-item>
        
        <el-menu-item index="/logs" v-if="hasPermission(['ROLE_ADMIN'])" @click="handleMenuClick">
          <el-icon><Document /></el-icon>
          <template #title>系统日志</template>
        </el-menu-item>
      </el-menu>
    </div>
    
    <div class="main-content" :class="{ 'main-content-collapsed': !sidebarOpen }">
      <header class="top-header">
        <el-button type="text" @click="toggleSidebar" class="mobile-menu-btn">
          <el-icon><Menu /></el-icon>
        </el-button>
        
        <div class="header-left">
          <el-breadcrumb separator="/" class="breadcrumb">
            <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
            <el-breadcrumb-item v-if="currentPageTitle !== '首页'">{{ currentPageTitle }}</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        
        <div class="header-right">
          <!-- 通知图标 -->
          <el-dropdown trigger="click" :close-on-click-outside="true" :hide-on-click="true">
            <span class="notification-icon">
              <el-icon><Bell /></el-icon>
              <el-badge :value="unreadCount" type="danger" :hidden="unreadCount === 0" />
            </span>
            <template #dropdown>
              <div class="notification-dropdown">
                <div class="notification-header">
                  <h4>通知中心</h4>
                  <el-button type="text" size="small" @click="markAllAsRead">全部已读</el-button>
                </div>
                <div class="notification-list">
                  <div v-if="notifications.length === 0" class="no-notifications">
                    暂无通知
                  </div>
                  <div
                    v-for="notification in notifications"
                    :key="notification.id"
                    class="notification-item"
                    :class="{ 'unread-notification': !notification.read }"
                    @click="markAsRead(notification.id)"
                  >
                    <div class="notification-content">
                      <div class="notification-title">{{ notification.title }}</div>
                      <div class="notification-message">{{ notification.message }}</div>
                    </div>
                    <div class="notification-meta">
                      <div class="notification-time">{{ notification.time }}</div>
                      <el-tag v-if="!notification.read" size="small" type="danger">未读</el-tag>
                    </div>
                  </div>
                </div>
                <div class="notification-footer">
                  <el-button type="text" size="small" @click="goToNotificationCenter">查看全部</el-button>
                </div>
              </div>
            </template>
          </el-dropdown>
          
          <!-- 用户信息 -->
          <el-dropdown>
            <span class="user-info">
              <el-icon><User /></el-icon>
              <span class="user-name">{{ userStore.userInfo?.name || '未知用户' }}</span>
              <el-icon class="el-icon--right"><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item disabled>
                  角色：{{ userStore.userInfo?.role === 'ROLE_ADMIN' ? '管理员' : userStore.userInfo?.role === 'ROLE_TEACHER' ? '教师' : '学生' }}
                </el-dropdown-item>
                <el-dropdown-item @click="handleLogout">
                  <el-icon><SwitchButton /></el-icon>
                  退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </header>
      
      <main class="content-wrapper">
        <router-view />
      </main>
    </div>
    
    <div class="mobile-overlay" v-if="isMobile && sidebarOpen" @click="toggleSidebar"></div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../store/user'
import { ElMessage } from 'element-plus'
import {
  School,
  House,
  User,
  UserFilled,
  Document,
  Collection,
  ArrowLeft,
  ArrowRight,
  ArrowDown,
  SwitchButton,
  Menu,
  Setting,
  Bell
} from '@element-plus/icons-vue'
import { Logger } from '../utils/logger'

const router = useRouter()
const userStore = useUserStore()
const isMobile = ref(false)

const checkMobile = () => {
  isMobile.value = window.innerWidth <= 768
}

onMounted(() => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
})

onUnmounted(() => {
  window.removeEventListener('resize', checkMobile)
})

const activeMenu = computed(() => {
  return router.currentRoute.value.path
})

const currentPageTitle = computed(() => {
  const path = router.currentRoute.value.path
  const titleMap: Record<string, string> = {
    '/': '首页',
    '/students': '学生列表',
    '/students/my-info': '我的信息',
    '/students/add': '添加学生',
    '/students/edit/': '编辑学生',
    '/students/detail/': '学生详情',
    '/scores': '成绩列表',
    '/scores/my-scores': '我的成绩',
    '/scores/add': '添加成绩',
    '/scores/edit/': '编辑成绩',
    '/scores/analysis': '成绩分析',
    '/courses': '课程列表',
    '/courses/add': '添加课程',
    '/courses/edit/': '编辑课程',
    '/attendance': '考勤记录',
    '/attendance/add': '添加考勤',
    '/attendance/edit/': '编辑考勤',
    '/attendance/my-attendance': '我的考勤',
    '/attendance/statistics': '考勤统计',
    '/users': '用户管理',
    '/settings': '系统设置',
    '/logs': '系统日志',
    '/classes': '班级列表',
    '/teachers': '教师列表'
  }
  
  // 先尝试精确匹配
  if (titleMap[path]) {
    return titleMap[path]
  }
  
  // 对于带参数的路由，优先匹配更长的路径
  // 按路径长度降序排序，确保先匹配更长的路径，避免先匹配到'/'
  const keys = Object.keys(titleMap)
    .sort((a, b) => b.length - a.length)
  
  for (const key of keys) {
    // 处理带参数的路由匹配，无论键是否带有尾随斜杠
    if (path.startsWith(key) || path.startsWith(key.replace(/\/$/, '')) || 
        (key.endsWith('/') && path.startsWith(key.slice(0, -1)))) {
      return titleMap[key]
    }
  }
  
  return '未知页面'
})

const toggleSidebar = () => {
  userStore.toggleSidebar()
}

const hasPermission = (roles: string[]) => {
  const userRole = userStore.getUserRole
  if (!userRole) {
    return true
  }
  return roles.includes(userRole)
}

const handleLogout = () => {
  const username = userStore.userInfo?.username || '未知用户'
  Logger.access('LOGOUT', `用户 ${username} 退出登录`)
  userStore.logout()
  ElMessage.success('退出成功')
  router.push('/login')
}

const handleMenuClick = () => {
  if (isMobile.value) {
    userStore.toggleSidebar()
  }
}

const sidebarOpen = computed(() => userStore.sidebarOpen)

// 通知数据
const notifications = ref([
  {
    id: 1,
    title: '成绩更新',
    message: '您的计算机基础课程成绩已更新为88分',
    time: '2024-01-15 14:30',
    read: false
  },
  {
    id: 2,
    title: '考勤提醒',
    message: '您有1次迟到记录，请注意按时上课',
    time: '2024-01-14 09:00',
    read: false
  },
  {
    id: 3,
    title: '系统公告',
    message: '系统将于2024-01-20进行维护，请提前做好准备',
    time: '2024-01-13 16:00',
    read: true
  }
])

// 未读通知数量
const unreadCount = computed(() => {
  return notifications.value.filter(n => !n.read).length
})

// 标记单个通知为已读
const markAsRead = (id: number) => {
  const notification = notifications.value.find(n => n.id === id)
  if (notification) {
    notification.read = true
  }
}

// 标记所有通知为已读
const markAllAsRead = () => {
  notifications.value.forEach(n => {
    n.read = true
  })
}

// 跳转到通知中心
const goToNotificationCenter = () => {
  router.push('/notifications')
}
</script>

<style scoped>
.layout-container {
  display: flex;
  height: 100vh;
  overflow: hidden;
  position: relative;
}

.sidebar {
  width: 200px;
  background-color: #304156;
  color: #fff;
  display: flex;
  flex-direction: column;
  transition: width 0.3s ease;
  position: fixed;
  left: 0;
  top: 0;
  height: 100vh;
  z-index: 1000;
}

.sidebar-collapsed {
  width: 64px;
}

@media (max-width: 768px) {
  .sidebar {
    left: -200px;
    transition: left 0.3s ease;
    width: 200px;
  }
  
  .sidebar:not(.sidebar-collapsed) {
    left: 0;
  }
  
  .sidebar-collapsed {
    left: -200px;
    width: 200px;
  }
}

.sidebar-header {
  height: 60px;
  display: flex;
  align-items: center;
  padding: 0 16px;
  border-bottom: 1px solid #404e67;
}

.sidebar-title {
  margin: 0;
  font-size: 18px;
  font-weight: 600;
  color: #fff;
  margin-right: auto;
  white-space: nowrap;
  transition: opacity 0.3s ease;
}

.sidebar-collapsed .sidebar-title {
  opacity: 0;
  width: 0;
  margin-right: 0;
  overflow: hidden;
}

.sidebar-logo {
  font-size: 24px;
  margin-right: auto;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.sidebar-collapsed .sidebar-logo {
  opacity: 1;
}

.collapse-btn {
  color: #fff;
  font-size: 18px;
}

.sidebar-menu {
  flex: 1;
  background-color: transparent;
  border-right: none;
}

.sidebar-menu :deep(.el-menu-item),
.sidebar-menu :deep(.el-sub-menu__title) {
  color: #bfcbd9;
  height: 50px;
  line-height: 50px;
  border-right: 3px solid transparent;
}

.sidebar-menu :deep(.el-menu-item:hover),
.sidebar-menu :deep(.el-sub-menu__title:hover) {
  background-color: #263445;
  color: #fff;
}

.sidebar-menu :deep(.el-menu-item.is-active) {
  color: var(--primary-color);
  background-color: #263445;
  border-right-color: var(--primary-color);
}

/* 统一菜单图标大小 */
.sidebar-menu :deep(.el-icon) {
  font-size: 18px;
  margin-right: 8px;
}

/* 折叠状态下的图标样式 */
.sidebar-collapsed :deep(.el-icon) {
  margin-right: 0;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  margin-left: 200px;
  transition: margin-left 0.3s ease;
}

.main-content-collapsed {
  margin-left: 64px;
}

@media (max-width: 768px) {
  .main-content {
    margin-left: 0;
  }
  
  .main-content-collapsed {
    margin-left: 0;
  }
}

.top-header {
  height: 60px;
  background-color: #fff;
  border-bottom: 1px solid #e6e6e6;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  position: relative;
  z-index: 100;
}

.mobile-menu-btn {
  display: none;
  color: var(--text-primary);
  font-size: 20px;
  margin-right: 16px;
}

@media (max-width: 768px) {
  .mobile-menu-btn {
    display: block;
  }
}

.header-left {
  flex: 1;
  display: flex;
  align-items: center;
  overflow: hidden;
}

.breadcrumb {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  font-size: 14px;
}

.header-right {
  display: flex;
  align-items: center;
  margin-left: 20px;
  gap: 20px;
}

.notification-icon {
  cursor: pointer;
  display: flex;
  align-items: center;
  font-size: 18px;
  color: var(--text-primary);
  position: relative;
}

/* 统一所有图标大小 */
:deep(.el-icon) {
  font-size: 18px !important;
  width: 18px !important;
  height: 18px !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

/* 特殊情况：需要更大图标的地方单独设置 */
.sidebar-logo {
  font-size: 24px !important;
  width: 24px !important;
  height: 24px !important;
}

.welcome-icon {
  font-size: 28px !important;
  width: 28px !important;
  height: 28px !important;
}

.notification-dropdown {
  width: 420px;
  padding: 0;
  border-radius: var(--border-radius-md);
  box-shadow: var(--shadow-lg);
  overflow: hidden;
}

.notification-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 18px;
  border-bottom: 1px solid var(--border-light);
  background-color: var(--bg-primary);
}

.notification-header h4 {
  margin: 0;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
}

.notification-list {
  max-height: 420px;
  overflow-y: auto;
  background-color: var(--bg-primary);
}

/* 优化滚动条样式 */
.notification-list::-webkit-scrollbar {
  width: 6px;
}

.notification-list::-webkit-scrollbar-track {
  background: var(--bg-secondary);
}

.notification-list::-webkit-scrollbar-thumb {
  background: var(--border-color);
  border-radius: 3px;
}

.notification-list::-webkit-scrollbar-thumb:hover {
  background: var(--text-placeholder);
}

.no-notifications {
  padding: 30px 20px;
  text-align: center;
  color: var(--text-secondary);
  font-size: 14px;
  background-color: var(--bg-primary);
}

.notification-item {
  padding: 14px 18px;
  border-bottom: 1px solid var(--border-light);
  cursor: pointer;
  transition: all 0.2s ease;
  background-color: var(--bg-primary);
}

.notification-item:hover {
  background-color: var(--bg-tertiary);
  transform: translateX(2px);
}

.unread-notification {
  background-color: var(--bg-tertiary);
}

.notification-content {
  margin-bottom: 8px;
}

.notification-title {
  font-size: 14px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 4px;
  transition: color 0.2s ease;
}

.notification-item:hover .notification-title {
  color: var(--primary-color);
}

.notification-message {
  font-size: 13px;
  color: var(--text-regular);
  line-height: 1.5;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.notification-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 12px;
  color: var(--text-secondary);
}

.notification-footer {
  padding: 12px 18px;
  text-align: center;
  border-top: 1px solid var(--border-light);
  background-color: var(--bg-secondary);
}

.user-info {
  display: flex;
  align-items: center;
  cursor: pointer;
  color: var(--text-primary);
  font-size: 14px;
  gap: 8px;
  padding: 6px 12px;
  border-radius: var(--border-radius-md);
  transition: all 0.2s ease;
}

.user-info:hover {
  background-color: var(--bg-secondary);
}

.user-name {
  white-space: nowrap;
  font-weight: 500;
  max-width: 120px;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* 优化面包屑导航样式 */
.breadcrumb {
  font-size: 14px;
}

.breadcrumb :deep(.el-breadcrumb__item) {
  color: var(--text-secondary);
}

.breadcrumb :deep(.el-breadcrumb__item:last-child) {
  color: var(--text-primary);
  font-weight: 500;
}

.breadcrumb :deep(.el-breadcrumb__separator) {
  color: var(--border-color);
  margin: 0 6px;
}

/* 优化菜单高亮样式 */
.sidebar-menu :deep(.el-menu-item.is-active),
.sidebar-menu :deep(.el-sub-menu.is-active > .el-sub-menu__title) {
  color: var(--primary-color);
  background-color: #263445;
  border-right-color: var(--primary-color);
  font-weight: 500;
}

/* 优化折叠按钮样式 */
.collapse-btn {
  color: #fff;
  font-size: 18px;
  padding: 8px;
  border-radius: var(--border-radius-sm);
  transition: all 0.2s ease;
  cursor: pointer;
}

.collapse-btn:hover {
  background-color: rgba(255, 255, 255, 0.1);
  transform: scale(1.1);
}

/* 优化菜单文本溢出处理 */
.sidebar-menu :deep(.el-menu-item__content),
.sidebar-menu :deep(.el-sub-menu__title .el-sub-menu__title-text) {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.content-wrapper {
  flex: 1;
  padding: 20px;
  background-color: #f5f7fa;
  overflow-y: auto;
}

.mobile-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 999;
}

@media (max-width: 768px) {
  .top-header {
    padding: 0 10px;
  }
  
  .user-name {
    max-width: 60px;
  }
  
  .content-wrapper {
    padding: 10px;
  }
}

@media (max-width: 480px) {
  .user-name {
    display: none;
  }
  
  .breadcrumb {
    font-size: 12px;
  }
}
</style>