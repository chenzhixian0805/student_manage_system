<template>
  <div class="edit-user-container">
    <el-card class="edit-user-card">
      <template #header>
        <div class="card-header">
          <h3 class="section-title">编辑用户</h3>
        </div>
      </template>
      
      <!-- 编辑用户表单 -->
      <div class="edit-user-form-container" v-if="!loading">
        <el-form
          ref="editUserFormRef"
          :model="editUserForm"
          :rules="editUserRules"
          label-width="120px"
          class="edit-user-form"
        >
          <el-form-item label="用户名" prop="username">
            <el-input
              v-model="editUserForm.username"
              placeholder="请输入用户名"
              clearable
              maxlength="20"
              show-word-limit
              disabled
            ></el-input>
          </el-form-item>
          
          <el-form-item label="密码" prop="password">
            <el-input
              v-model="editUserForm.password"
              placeholder="请输入密码（不填写则不修改）"
              type="password"
              show-password
              maxlength="20"
            ></el-input>
          </el-form-item>
          
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input
              v-model="editUserForm.confirmPassword"
              placeholder="请确认密码"
              type="password"
              show-password
              maxlength="20"
            ></el-input>
          </el-form-item>
          
          <el-form-item label="姓名" prop="name">
            <el-input
              v-model="editUserForm.name"
              placeholder="请输入姓名"
              clearable
              maxlength="10"
              show-word-limit
            ></el-input>
          </el-form-item>
          
          <el-form-item label="角色" prop="role">
            <el-select
              v-model="editUserForm.role"
              placeholder="请选择角色"
              clearable
              :disabled="editUserForm.username === 'admin'"
            >
              <el-option label="管理员" :value="'ROLE_ADMIN'"></el-option>
              <el-option label="教师" :value="'ROLE_TEACHER'"></el-option>
              <el-option label="学生" :value="'ROLE_STUDENT'"></el-option>
            </el-select>
          </el-form-item>
          
          <el-form-item label="状态" prop="status">
            <el-switch
              v-model="editUserForm.status"
              active-value="active"
              inactive-value="inactive"
              :disabled="editUserForm.username === 'admin'"
            ></el-switch>
          </el-form-item>
          
          <el-form-item>
            <div class="form-actions">
              <el-button
                type="primary"
                @click="handleSubmit"
              >
                <el-icon><Check /></el-icon>
                保存
              </el-button>
              <el-button
                @click="handleCancel"
              >
                <el-icon><Close /></el-icon>
                取消
              </el-button>
            </div>
          </el-form-item>
        </el-form>
      </div>
      <div v-else class="loading-container">
        <el-skeleton :rows="6" animated></el-skeleton>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElForm, ElLoading } from 'element-plus'
import {
  Check,
  Close
} from '@element-plus/icons-vue'
import { getUserById, updateUser } from '../../api/userApi'

const router = useRouter()
const route = useRoute()

// 加载状态
const loading = ref(true)

// 表单引用
const editUserFormRef = ref<InstanceType<typeof ElForm> | null>(null)

// 编辑用户表单数据
const editUserForm = reactive({
  id: 0,
  username: '',
  password: '',
  confirmPassword: '',
  name: '',
  role: 'ROLE_STUDENT',
  status: 'active'
})

// 编辑用户表单规则
const editUserRules = computed(() => ({
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9_]+$/, message: '用户名只能包含字母、数字和下划线', trigger: 'blur' }
  ],
  password: [
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    {
      validator: (_rule: any, value: string, callback: any) => {
        if (editUserForm.password && value === '') {
          callback(new Error('请确认密码'))
        } else if (editUserForm.password && value !== editUserForm.password) {
          callback(new Error('两次输入密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ],
  name: [
    { required: true, message: '请输入姓名', trigger: 'blur' },
    { min: 1, max: 10, message: '姓名长度在 1 到 10 个字符', trigger: 'blur' }
  ],
  role: [
    { required: true, message: '请选择角色', trigger: 'change' }
  ]
}))

// 获取用户ID
const userId = computed(() => {
  return Number(route.params.id) || 0
})

// 加载用户数据
const loadUserData = async () => {
  loading.value = true
  try {
    // 调用真实API获取用户数据
    const response = await getUserById(userId.value)
    
    // 填充表单数据
    Object.assign(editUserForm, {
      ...response,
      // 将后端状态转换为前端使用的active/inactive
      status: response.status === 1 ? 'active' : 'inactive'
    })
  } catch (error) {
    console.error('获取用户数据失败:', error)
    ElMessage.error('获取用户数据失败')
    router.push('/users')
  } finally {
    loading.value = false
  }
}

// 提交表单
const handleSubmit = () => {
  if (!editUserFormRef.value) return
  
  editUserFormRef.value.validate((valid) => {
    if (valid) {
      // 表单验证通过，提交数据
      handleUpdateUser()
    }
  })
}

// 取消编辑
const handleCancel = () => {
  router.push('/users')
}

// 更新用户
const handleUpdateUser = async () => {
  // 准备提交数据
  const submitData = {
    ...editUserForm,
    // 将前端状态转换为后端使用的1/0
    status: editUserForm.status === 'active' ? 1 : 0,
    // 如果密码为空，则不传递密码字段，避免修改密码
    ...(editUserForm.password ? { password: editUserForm.password } : {})
  }
  
  // 删除不需要传递的字段
  delete submitData.confirmPassword
  
  const loadingInstance = ElLoading.service({
    text: '更新中...',
    background: 'rgba(0, 0, 0, 0.7)'
  })
  
  try {
    // 调用真实API更新用户数据
    await updateUser(userId.value, submitData)
    loadingInstance.close()
    ElMessage.success('更新成功')
    router.push('/users')
  } catch (error) {
    loadingInstance.close()
    console.error('更新用户失败:', error)
    ElMessage.error('更新失败')
  }
}

// 页面加载时获取用户数据
onMounted(() => {
  loadUserData()
})
</script>

<style scoped>
.edit-user-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.edit-user-card {
  border-radius: var(--border-radius-lg);
  box-shadow: var(--shadow-md);
  overflow: hidden;
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

.edit-user-form-container {
  padding: 20px;
}

.loading-container {
  padding: 20px;
}

.edit-user-form {
  max-width: 600px;
}

.form-actions {
  display: flex;
  gap: 16px;
  margin-top: 20px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .edit-user-form-container {
    padding: 16px;
  }
  
  .loading-container {
    padding: 16px;
  }
  
  .edit-user-form {
    max-width: 100%;
  }
  
  .form-actions {
    flex-direction: column;
  }
}
</style>