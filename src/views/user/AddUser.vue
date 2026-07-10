<template>
  <div class="add-user-container">
    <el-card class="add-user-card">
      <template #header>
        <div class="card-header">
          <h3 class="section-title">添加用户</h3>
        </div>
      </template>
      
      <!-- 添加用户表单 -->
      <div class="add-user-form-container">
        <el-form
          ref="addUserFormRef"
          :model="addUserForm"
          :rules="addUserRules"
          label-width="120px"
          class="add-user-form"
        >
          <el-form-item label="用户名" prop="username">
            <el-input
              v-model="addUserForm.username"
              placeholder="请输入用户名"
              clearable
              maxlength="20"
              show-word-limit
            ></el-input>
          </el-form-item>
          
          <el-form-item label="密码" prop="password">
            <el-input
              v-model="addUserForm.password"
              placeholder="请输入密码"
              type="password"
              show-password
              maxlength="20"
            ></el-input>
          </el-form-item>
          
          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input
              v-model="addUserForm.confirmPassword"
              placeholder="请确认密码"
              type="password"
              show-password
              maxlength="20"
            ></el-input>
          </el-form-item>
          
          <el-form-item label="姓名" prop="name">
            <el-input
              v-model="addUserForm.name"
              placeholder="请输入姓名"
              clearable
              maxlength="10"
              show-word-limit
            ></el-input>
          </el-form-item>
          
          <el-form-item label="角色" prop="role">
            <el-select
              v-model="addUserForm.role"
              placeholder="请选择角色"
              clearable
            >
              <el-option label="管理员" :value="'ROLE_ADMIN'"></el-option>
              <el-option label="教师" :value="'ROLE_TEACHER'"></el-option>
              <el-option label="学生" :value="'ROLE_STUDENT'"></el-option>
            </el-select>
          </el-form-item>
          
          <el-form-item label="状态" prop="status">
            <el-switch
              v-model="addUserForm.status"
              active-value="active"
              inactive-value="inactive"
            ></el-switch>
          </el-form-item>
          
          <el-form-item>
            <div class="form-actions">
              <el-button
                type="primary"
                @click="handleSubmit"
              >
                <el-icon><Check /></el-icon>
                确定
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
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElForm, ElLoading } from 'element-plus'
import {
  Check,
  Close
} from '@element-plus/icons-vue'

const router = useRouter()

// 表单引用
const addUserFormRef = ref<InstanceType<typeof ElForm> | null>(null)

// 添加用户表单数据
const addUserForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  name: '',
  role: 'ROLE_STUDENT',
  status: 'active'
})

// 添加用户表单规则
const addUserRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' },
    { pattern: /^[a-zA-Z0-9_]+$/, message: '用户名只能包含字母、数字和下划线', trigger: 'blur' }
  ],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, max: 20, message: '密码长度在 6 到 20 个字符', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { 
      validator: (_rule: any, value: string, callback: any) => {
        if (value === '') {
          callback(new Error('请确认密码'))
        } else if (value !== addUserForm.password) {
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
}

// 提交表单
const handleSubmit = () => {
  if (!addUserFormRef.value) return
  
  addUserFormRef.value.validate((valid) => {
    if (valid) {
      // 表单验证通过，提交数据
      handleAddUser()
    }
  })
}

// 取消添加
const handleCancel = () => {
  router.push('/users')
}

// 添加用户
const handleAddUser = () => {
  // 模拟API请求
  const loading = ElLoading.service({
    text: '添加中...',
    background: 'rgba(0, 0, 0, 0.7)'
  })
  
  setTimeout(() => {
    loading.close()
    ElMessage.success('添加成功')
    router.push('/users')
  }, 1000)
}
</script>

<style scoped>
.add-user-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.add-user-card {
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

.add-user-form-container {
  padding: 20px;
}

.add-user-form {
  max-width: 600px;
}

.form-actions {
  display: flex;
  gap: 16px;
  margin-top: 20px;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .add-user-form-container {
    padding: 16px;
  }
  
  .add-user-form {
    max-width: 100%;
  }
  
  .form-actions {
    flex-direction: column;
  }
}
</style>