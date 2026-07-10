import { defineStore } from 'pinia'

export interface UserState {
  token: string | null
  userInfo: {
    username: string
    role: string
    name: string
    email: string
    phone: string
    gender?: string
  } | null
  sidebarOpen: boolean
}

export const useUserStore = defineStore('user', {
  state: (): UserState => {
    const storedUserInfo = localStorage.getItem('userInfo')
    let parsedUserInfo = storedUserInfo ? JSON.parse(storedUserInfo) : null
    
    // 确保userInfo始终包含email、phone和gender字段
    if (parsedUserInfo) {
      parsedUserInfo = {
        ...parsedUserInfo,
        email: parsedUserInfo.email || '',
        phone: parsedUserInfo.phone || '',
        gender: parsedUserInfo.gender || ''
      }
      // 更新localStorage，确保持久化存储包含完整字段
      localStorage.setItem('userInfo', JSON.stringify(parsedUserInfo))
    }
    
    return {
      token: localStorage.getItem('token'),
      userInfo: parsedUserInfo,
      sidebarOpen: true
    }
  },
  
  getters: {
    isLoggedIn: (state) => !!state.token,
    getUserRole: (state) => state.userInfo?.role || ''
  },
  
  actions: {
    setToken(token: string) {
      this.token = token
      localStorage.setItem('token', token)
    },
    
    setUserInfo(userInfo: {
      username: string
      role: string
      name: string
      email: string
      phone: string
      gender?: string
    }) {
      this.userInfo = userInfo
      localStorage.setItem('userInfo', JSON.stringify(userInfo))
    },
    
    toggleSidebar() {
      this.sidebarOpen = !this.sidebarOpen
    },
    
    logout() {
      this.token = null
      this.userInfo = null
      localStorage.removeItem('token')
      localStorage.removeItem('userInfo')
    }
  }
})