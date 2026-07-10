<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <h2 class="login-title">
          <el-icon class="logo"><School /></el-icon>
          学生管理系统
        </h2>
        <p class="login-subtitle">请登录您的账号</p>
      </div>
      <el-form
        ref="loginFormRef"
        :model="loginForm"
        :rules="loginRules"
        class="login-form"
      >
        <el-form-item prop="username">
          <el-input
            v-model="loginForm.username"
            placeholder="请输入用户名"
            prefix-icon="User"
            size="large"
          ></el-input>
        </el-form-item>
        
        <el-form-item prop="password">
          <el-input
            v-model="loginForm.password"
            type="password"
            placeholder="请输入密码"
            prefix-icon="Lock"
            show-password
            size="large"
          ></el-input>
        </el-form-item>
        
        <el-form-item>
          <div class="login-options">
            <el-checkbox v-model="loginForm.remember" size="large">记住账号</el-checkbox>
          </div>
        </el-form-item>
        
        <el-form-item>
          <el-button
            type="primary"
            :loading="loading"
            @click="handleLogin"
            class="login-btn"
            size="large"
          >
            登录
          </el-button>
        </el-form-item>
      </el-form>
    </div>
    <div class="login-bg"></div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../store/user'
import type { FormInstance, FormRules } from 'element-plus'
import { ElMessage } from 'element-plus'
import { Logger } from '../utils/logger'
import { login, type LoginRequest } from '../api/authApi'

const router = useRouter()
const userStore = useUserStore()
const loginFormRef = ref<FormInstance>()
const loading = ref(false)

const loginForm = reactive<LoginRequest>({
  username: '',
  password: '',
  remember: false
})

const loginRules = reactive<FormRules>({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' }
  ]
})

const handleLogin = () => {
  if (!loginFormRef.value) return
  
  loginFormRef.value.validate((valid) => {
    if (valid) {
      loading.value = true
      
      login(loginForm).then(response => {
        // 从response中直接获取数据，因为响应拦截器已经处理了
        const { token, userInfo } = response
        
        userStore.setToken(token)
        userStore.setUserInfo(userInfo)
        
        // 记录登录成功日志
        Logger.access('LOGIN', `用户 ${loginForm.username} 登录成功，角色：${userInfo.role}`)
        
        ElMessage.success('登录成功')
        router.push('/')
      }).catch(error => {
        // 记录登录失败日志
        Logger.errorLog('LOGIN', `用户 ${loginForm.username} 登录失败`, error)
        // 显示更具体的错误信息
        const errorMsg = error.response?.data?.message || '登录失败，请检查用户名和密码'
        ElMessage.error(errorMsg)
      }).finally(() => {
        loading.value = false
      })
    }
  })
}
</script>

<style scoped>
.login-container {
  position: relative;
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  overflow: hidden;
}

.login-box {
  position: relative;
  z-index: 2;
  width: 420px;
  padding: 40px;
  background-color: rgba(255, 255, 255, 0.95);
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
}

.login-box:hover {
  box-shadow: 0 15px 50px rgba(0, 0, 0, 0.2);
  transform: translateY(-2px);
}

.login-bg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
  background-image: 
    radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
    radial-gradient(circle at 80% 20%, rgba(255, 255, 255, 0.15) 0%, transparent 50%),
    radial-gradient(circle at 40% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
  animation: bgAnimation 20s ease infinite;
}

@keyframes bgAnimation {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

.login-header {
  text-align: center;
  margin-bottom: 30px;
}

.login-title {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  font-size: 28px;
  font-weight: 700;
  color: var(--primary-color);
  margin: 0 0 10px 0;
  width: 100%;
}

.logo {
  font-size: 32px;
}

.login-subtitle {
  font-size: 14px;
  color: var(--text-secondary);
  margin: 0;
  width: 100%;
  text-align: center;
}

.login-form {
  margin-top: 20px;
  width: 100%;
}

.login-box {
  position: relative;
  z-index: 2;
  width: 420px;
  padding: 40px;
  background-color: rgba(255, 255, 255, 0.95);
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.15);
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.login-options {
  display: flex;
  justify-content: flex-start;
  align-items: center;
}

.login-btn {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 12px;
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
  border: none;
  transition: all 0.3s ease;
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(64, 158, 255, 0.4);
}

@media (max-width: 768px) {
  .login-box {
    width: 90%;
    max-width: 420px;
    padding: 30px 20px;
  }
  
  .login-title {
    font-size: 24px;
  }
  
  .logo {
    font-size: 28px;
  }
}
</style>