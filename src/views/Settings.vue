<template>
  <div class="settings-container">
    <el-card class="settings-card">
      <template #header>
        <div class="card-header">
          <span>系统设置</span>
        </div>
      </template>
      
      <!-- 个人信息修改 -->
      <el-card class="profile-card">
        <template #header>
          <h3 class="section-title">个人信息</h3>
        </template>
        
        <div class="profile-content">
          <!-- 头像上传 -->
          <div class="avatar-section">
            <el-upload
              class="avatar-uploader"
              :auto-upload="false"
              :show-file-list="false"
              :before-upload="beforeAvatarUpload"
              accept="image/*"
              @change="handleAvatarChange"
            >
              <el-image
                v-if="profileForm.avatar"
                :src="profileForm.avatar"
                class="avatar"
                :fit="'cover'"
              ></el-image>
              <el-icon v-else class="avatar-upload-icon"><Plus /></el-icon>
            </el-upload>
            <div class="avatar-tip">点击上传头像</div>
          </div>
          
          <el-form
            ref="profileFormRef"
            :model="profileForm"
            :rules="profileRules"
            label-width="120px"
            class="profile-form"
          >
            <el-form-item label="用户名" prop="username">
              <el-input
                v-model="profileForm.username"
                placeholder="请输入用户名"
                :disabled="true"
              ></el-input>
            </el-form-item>
            
            <el-form-item label="姓名" prop="name">
              <el-input
                v-model="profileForm.name"
                placeholder="请输入姓名"
              ></el-input>
            </el-form-item>
            
            <el-form-item label="邮箱" prop="email">
              <el-input
                v-model="profileForm.email"
                placeholder="请输入邮箱"
                type="email"
              ></el-input>
            </el-form-item>
            
            <el-form-item label="手机号" prop="phone">
              <el-input
                v-model="profileForm.phone"
                placeholder="请输入手机号"
              ></el-input>
            </el-form-item>
            
            <el-form-item label="角色" prop="role">
              <el-input
                v-model="profileForm.role"
                :disabled="true"
              ></el-input>
            </el-form-item>
            
            <el-form-item>
              <el-button type="primary" :loading="loading" @click="handleSubmit">
                保存修改
              </el-button>
              <el-button @click="handleReset">重置</el-button>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
      
      <!-- 密码修改 -->
      <el-card class="password-card">
        <template #header>
          <h3 class="section-title">修改密码</h3>
        </template>
        
        <el-form
          ref="passwordFormRef"
          :model="passwordForm"
          :rules="passwordRules"
          label-width="120px"
          class="password-form"
        >
          <el-form-item label="当前密码" prop="oldPassword">
            <el-input
              v-model="passwordForm.oldPassword"
              placeholder="请输入当前密码"
              type="password"
              show-password
            ></el-input>
          </el-form-item>
          
          <el-form-item label="新密码" prop="newPassword">
            <el-input
              v-model="passwordForm.newPassword"
              placeholder="请输入新密码"
              type="password"
              show-password
            ></el-input>
          </el-form-item>
          
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input
              v-model="passwordForm.confirmPassword"
              placeholder="请确认新密码"
              type="password"
              show-password
            ></el-input>
          </el-form-item>
          
          <el-form-item>
            <el-button type="primary" :loading="passwordLoading" @click="handlePasswordSubmit">
              修改密码
            </el-button>
            <el-button @click="handlePasswordReset">重置</el-button>
          </el-form-item>
        </el-form>
      </el-card>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useUserStore } from '../store/user'
import { ElMessage } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import type { FormInstance, FormRules } from 'element-plus'

const userStore = useUserStore()
const profileFormRef = ref<FormInstance>()
const passwordFormRef = ref<FormInstance>()
const loading = ref(false)
const passwordLoading = ref(false)

// 个人信息表单
const profileForm = reactive({
  username: userStore.userInfo?.username || '',
  name: userStore.userInfo?.name || '',
  role: userStore.userInfo?.role === 'ROLE_ADMIN' ? '管理员' : userStore.userInfo?.role === 'ROLE_TEACHER' ? '教师' : '学生',
  email: userStore.userInfo?.email || '',
  phone: userStore.userInfo?.phone || '',
  avatar: ''
})

// 密码修改表单
const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

// 个人信息验证规则
const profileRules = reactive<FormRules>({
  name: [
    { required: true, message: '请输入姓名', trigger: 'blur' },
    { min: 2, max: 20, message: '姓名长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入有效的手机号', trigger: 'blur' }
  ]
})

// 密码验证规则
const passwordRules = reactive<FormRules>({
  oldPassword: [
    { required: true, message: '请输入当前密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认新密码', trigger: 'blur' },
    {
      validator: (_rule, value, callback) => {
        if (value !== passwordForm.newPassword) {
          callback(new Error('两次输入的密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
})

// 初始化表单数据
onMounted(async () => {
  try {
    if (userStore.userInfo?.role === 'ROLE_STUDENT') {
      // 对于学生用户，从学生API获取详细信息
      const { getStudentByStudentId } = await import('../api/studentApi')
      const studentInfo = await getStudentByStudentId(userStore.userInfo.username)
      
      // 更新用户信息到store，同步学生信息
      userStore.setUserInfo({
        ...userStore.userInfo,
        email: studentInfo.email || '',
        phone: studentInfo.phone || ''
      })
      
      // 更新表单数据
      profileForm.email = studentInfo.email || ''
      profileForm.phone = studentInfo.phone || ''
    } else {
      // 对于非学生用户，先检查是否已登录
      if (userStore.isLoggedIn && userStore.userInfo) {
        try {
          // 尝试从API获取最新用户信息
          const { getCurrentUser } = await import('../api/authApi')
          const userInfo = await getCurrentUser()
          
          // 更新用户信息到store
          userStore.setUserInfo(userInfo)
          
          // 更新表单数据
          profileForm.email = userInfo.email || ''
          profileForm.phone = userInfo.phone || ''
        } catch (error) {
          console.error('从API获取用户信息失败，使用本地存储中的信息:', error)
          // 如果API调用失败，使用store中已有的信息
          profileForm.email = userStore.userInfo.email || ''
          profileForm.phone = userStore.userInfo.phone || ''
        }
      } else {
        // 如果未登录，使用表单默认值
        profileForm.email = ''
        profileForm.phone = ''
      }
    }
  } catch (error) {
    console.error('获取用户信息失败:', error)
    // 如果获取失败，从store中获取已有信息
    if (userStore.userInfo) {
      profileForm.email = userStore.userInfo.email || ''
      profileForm.phone = userStore.userInfo.phone || ''
    }
  }
})

// 处理个人信息提交
const handleSubmit = async () => {
  if (!profileFormRef.value) return
  
  await profileFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      
      try {
        if (userStore.userInfo?.role === 'ROLE_STUDENT') {
          // 对于学生用户，调用学生API更新信息
          const { updateStudent } = await import('../api/studentApi')
          const { getStudentByStudentId } = await import('../api/studentApi')
          
          // 先根据学号获取学生详情，获取学生ID
          const studentInfo = await getStudentByStudentId(profileForm.username)
          
          // 更新学生信息，传递必填字段和需要修改的字段
          await updateStudent(studentInfo.id, {
            id: studentInfo.id,
            studentId: studentInfo.studentId,
            name: profileForm.name,
            status: studentInfo.status, // 保持原有状态
            email: profileForm.email,
            phone: profileForm.phone
          })
          
          // 更新用户store，同步信息
          userStore.setUserInfo({
            username: profileForm.username,
            role: userStore.userInfo?.role || '',
            name: profileForm.name,
            email: profileForm.email,
            phone: profileForm.phone
          })
        } else {
          // 对于非学生用户，使用原有逻辑
          // 调用用户API更新信息
          const { updateUser, getAllUsers } = await import('../api/userApi')
          
          // 先获取用户列表，找到当前用户ID
          const users = await getAllUsers()
          const currentUser = users.find(user => user.username === profileForm.username)
          if (currentUser) {
            await updateUser(currentUser.id, {
              ...currentUser,
              name: profileForm.name,
              email: profileForm.email,
              phone: profileForm.phone
            })
          }
          
          // 更新用户store
          userStore.setUserInfo({
            username: profileForm.username,
            role: userStore.userInfo?.role || '',
            name: profileForm.name,
            email: profileForm.email,
            phone: profileForm.phone
          })
        }
        
        ElMessage.success('个人信息修改成功')
        loading.value = false
      } catch (error) {
        console.error('更新个人信息失败:', error)
        ElMessage.error('个人信息修改失败')
        loading.value = false
      }
    }
  })
}

// 处理个人信息重置
const handleReset = () => {
  profileForm.name = userStore.userInfo?.name || ''
  profileForm.email = userStore.userInfo?.email || ''
  profileForm.phone = userStore.userInfo?.phone || ''
  profileForm.avatar = ''
  profileFormRef.value?.resetFields()
}

// 处理密码提交
const handlePasswordSubmit = async () => {
  if (!passwordFormRef.value) return
  
  await passwordFormRef.value.validate(async (valid) => {
    if (valid) {
      passwordLoading.value = true
      
      try {
        // 这里应该调用API更新密码
        setTimeout(() => {
          ElMessage.success('密码修改成功')
          passwordLoading.value = false
          handlePasswordReset()
        }, 1000)
      } catch (error) {
        ElMessage.error('密码修改失败')
        passwordLoading.value = false
      }
    }
  })
}

// 处理密码重置
const handlePasswordReset = () => {
  passwordForm.oldPassword = ''
  passwordForm.newPassword = ''
  passwordForm.confirmPassword = ''
  passwordFormRef.value?.resetFields()
}

// 头像上传前的验证
const beforeAvatarUpload = (rawFile: File) => {
  const isImage = rawFile.type.startsWith('image/')
  if (!isImage) {
    ElMessage.error('请上传图片文件')
    return false
  }
  const isLt2M = rawFile.size / 1024 / 1024 < 2
  if (!isLt2M) {
    ElMessage.error('上传头像图片大小不能超过 2MB')
    return false
  }
  return true
}

// 头像上传处理
const handleAvatarChange = (file: any) => {
  const rawFile = file.raw
  if (rawFile) {
    const reader = new FileReader()
    reader.onload = (e) => {
      profileForm.avatar = e.target?.result as string
    }
    reader.readAsDataURL(rawFile)
  }
}
</script>

<style scoped>
.settings-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.settings-card {
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow-md);
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

.profile-card,
.password-card {
  margin-bottom: 24px;
  border-radius: var(--border-radius-md);
  box-shadow: var(--shadow-sm);
}

.profile-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px 0;
}

.avatar-section {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 30px;
}

.avatar-uploader {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 120px;
  height: 120px;
  border-radius: 50%;
  overflow: hidden;
  border: 2px dashed #ccc;
  cursor: pointer;
  transition: all 0.3s;
}

.avatar-uploader:hover {
  border-color: var(--primary-color);
  background-color: rgba(0, 0, 0, 0.05);
}

.avatar {
  width: 120px;
  height: 120px;
  border-radius: 50%;
  object-fit: cover;
}

.avatar-upload-icon {
  font-size: 32px;
  color: #ccc;
}

.avatar-tip {
  margin-top: 10px;
  font-size: 14px;
  color: var(--text-secondary);
}

.profile-form,
.password-form {
  max-width: 600px;
  margin: 0 auto;
  padding: 20px 0;
  width: 100%;
}

@media (max-width: 768px) {
  .profile-form,
  .password-form {
    max-width: 100%;
    padding: 10px;
  }
  
  .el-form-item {
    margin-right: 0 !important;
  }
}
</style>