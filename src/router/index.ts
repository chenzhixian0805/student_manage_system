import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    meta: { requiresAuth: false }
  },
  {
    path: '/',
    name: 'Layout',
    component: () => import('../components/Layout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'Home',
        component: () => import('../views/Home.vue'),
        meta: { requiresAuth: true }
      },
      // 学生管理
      {
        path: '/students',
        name: 'StudentList',
        component: () => import('../views/student/StudentList.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER'] }
      },
      {
        path: '/students/add',
        name: 'AddStudent',
        component: () => import('../views/student/AddStudent.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER'] }
      },
      {        path: '/students/edit/:id',        name: 'EditStudent',        component: () => import('../views/student/AddStudent.vue'),        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_STUDENT'] }      },
      {
        path: '/students/detail/:id',
        name: 'StudentDetail',
        component: () => import('../views/student/StudentDetail.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_STUDENT'] }
      },
      {
        path: '/students/my-info',
        name: 'MyInfo',
        component: () => import('../views/student/StudentDetail.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_STUDENT'] }
      },

      // 教师管理
      {
        path: '/teachers',
        name: 'TeacherList',
        component: () => import('../views/teacher/TeacherList.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN'] }
      },
      // 成绩管理
      {
        path: '/scores',
        name: 'ScoreList',
        component: () => import('../views/score/ScoreList.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER'] }
      },
      {
        path: '/scores/my-scores',
        name: 'MyScores',
        component: () => import('../views/score/ScoreList.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_STUDENT'] }
      },
      {
        path: '/scores/add',
        name: 'AddScore',
        component: () => import('../views/score/AddScore.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER'] }
      },
      {
        path: '/scores/edit/:id',
        name: 'EditScore',
        component: () => import('../views/score/AddScore.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER'] }
      },
      {        path: '/scores/analysis',        name: 'ScoreAnalysis',        component: () => import('../views/score/ScoreAnalysis.vue'),        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_STUDENT'] }      },
      // 课程管理
      {        path: '/courses',        name: 'CourseList',        component: () => import('../views/course/CourseList.vue'),        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_STUDENT'] }      },
      {
        path: '/courses/add',
        name: 'AddCourse',
        component: () => import('../views/course/AddCourse.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER'] }
      },
      {
        path: '/courses/edit/:id',
        name: 'EditCourse',
        component: () => import('../views/course/EditCourse.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN', 'ROLE_TEACHER'] }
      },
      // 系统设置
      {
        path: '/settings',
        name: 'Settings',
        component: () => import('../views/Settings.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN'] }
      },
      // 用户管理
      {
        path: '/users',
        name: 'UserManagement',
        component: () => import('../views/user/UserManagement.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN'] }
      },
      {
        path: '/users/add',
        name: 'AddUser',
        component: () => import('../views/user/AddUser.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN'] }
      },
      {
        path: '/users/edit/:id',
        name: 'EditUser',
        component: () => import('../views/user/EditUser.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN'] }
      },

      // 通知中心
      {
        path: '/notifications',
        name: 'NotificationCenter',
        component: () => import('../views/NotificationCenter.vue'),
        meta: { requiresAuth: true }
      },
      // 系统日志
      {
        path: '/logs',
        name: 'Logs',
        component: () => import('../views/Logs.vue'),
        meta: { requiresAuth: true, roles: ['ROLE_ADMIN'] }
      }
    ]
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/login'
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// 路由守卫
router.beforeEach((to, _from, next) => {
  // 从localStorage获取token和用户信息
  const token = localStorage.getItem('token')
  const userInfoStr = localStorage.getItem('userInfo')
  let userInfo = null
  let role = ''
  
  try {
    // 尝试解析用户信息，防止localStorage数据被篡改
    if (userInfoStr) {
      userInfo = JSON.parse(userInfoStr)
      role = userInfo.role || ''
    }
  } catch (error) {
    console.error('用户信息解析失败，可能被篡改:', error)
    // 清除无效的用户信息
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
    userInfo = null
    role = ''
  }

  // 不需要认证的路由
  if (!to.meta.requiresAuth) {
    if (token && userInfo) {
      // 已登录用户访问登录页或其他公开页面时，跳转到首页
      if (to.path === '/login') {
        next('/')
        return
      }
      next()
      return
    }
    next()
    return
  }

  // 需要认证的路由
  if (!token || !userInfo) {
    // 未登录或用户信息缺失，跳转到登录页
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
    next({
      path: '/login',
      query: { redirect: to.fullPath } // 保存当前路由，登录后跳转回来
    })
    return
  }

  // 检查token是否过期（假设token中包含过期时间，实际项目中需要根据token结构调整）
  // 这里简单模拟，实际项目中应该解析JWT token获取过期时间
  const tokenExpiry = localStorage.getItem('tokenExpiry')
  if (tokenExpiry) {
    const expiryTime = parseInt(tokenExpiry)
    const currentTime = Date.now()
    if (currentTime > expiryTime) {
      // token已过期
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
      localStorage.removeItem('tokenExpiry')
      next({
        path: '/login',
        query: { redirect: to.fullPath, expired: 'true' }
      })
      return
    }
  }

  // 检查角色权限
  if (to.meta.roles && Array.isArray(to.meta.roles)) {
    // 确保角色是有效的
    const validRoles = ['ROLE_ADMIN', 'ROLE_TEACHER', 'ROLE_STUDENT']
    if (!validRoles.includes(role)) {
      console.error('无效的角色:', role)
      next('/')
      return
    }

    if (to.meta.roles.includes(role)) {
      next()
    } else {
      // 无权限访问，跳转到首页并提示
      console.warn('用户无权限访问该页面:', to.path, '角色:', role)
      next('/')
    }
  } else {
    // 没有配置roles的路由，允许所有认证用户访问
    next()
  }
})

export default router