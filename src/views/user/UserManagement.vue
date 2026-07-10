<template>
  <div class="user-management-container">
    <el-card class="user-management-card">
      <template #header>
        <div class="card-header">
          <h3 class="section-title">用户管理</h3>
          <el-button
            type="primary"
            @click="handleAdd"
            class="add-user-btn"
          >
            <el-icon><Plus /></el-icon>
            添加用户
          </el-button>
        </div>
      </template>
      
      <!-- 搜索和筛选区域 -->
      <div class="search-filter-container">
        <el-form :inline="true" :model="searchForm" class="search-form">
          <el-form-item label="用户名">
            <el-input
              v-model="searchForm.username"
              placeholder="请输入用户名"
              clearable
              class="search-input"
            ></el-input>
          </el-form-item>
          <el-form-item label="角色">
            <el-select
              v-model="searchForm.role"
              placeholder="请选择角色"
              clearable
              class="search-select"
            >
              <el-option label="全部角色" :value="''"></el-option>
              <el-option label="管理员" :value="'ROLE_ADMIN'"></el-option>
              <el-option label="教师" :value="'ROLE_TEACHER'"></el-option>
              <el-option label="学生" :value="'ROLE_STUDENT'"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item label="状态">
            <el-select
              v-model="searchForm.status"
              placeholder="请选择状态"
              clearable
              class="search-select"
            >
              <el-option label="全部状态" :value="''"></el-option>
              <el-option label="启用" :value="'active'"></el-option>
              <el-option label="禁用" :value="'inactive'"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="handleSearch">
              <el-icon><Search /></el-icon>
              搜索
            </el-button>
            <el-button @click="handleReset">
              <el-icon><Refresh /></el-icon>
              重置
            </el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <!-- 用户列表 -->
      <div class="user-list-container">
        <el-table
          v-loading="loading"
          :data="userList"
          stripe
          border
          style="width: 100%"
          class="user-table"
        >
          <el-table-column prop="id" label="ID" width="80" align="center"></el-table-column>
          <el-table-column prop="username" label="用户名" width="150"></el-table-column>
          <el-table-column prop="name" label="姓名" width="150"></el-table-column>
          <el-table-column prop="role" label="角色" width="120" align="center">
            <template #default="scope">
              <el-tag
                :type="scope.row.role === 'ROLE_ADMIN' ? 'danger' : scope.row.role === 'ROLE_TEACHER' ? 'warning' : 'success'"
                size="small"
              >
                {{ scope.row.role === 'ROLE_ADMIN' ? '管理员' : scope.row.role === 'ROLE_TEACHER' ? '教师' : '学生' }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column prop="status" label="状态" width="120" align="center">
            <template #default="scope">
              <el-switch
                v-model="scope.row.status"
                :active-value="1"
                :inactive-value="0"
                @change="handleStatusChange(scope.row)"
              ></el-switch>
            </template>
          </el-table-column>
          <el-table-column prop="createdAt" label="创建时间" width="200"></el-table-column>
          <el-table-column prop="updatedAt" label="更新时间" width="200"></el-table-column>
          <el-table-column label="操作" width="250" align="center">
            <template #default="scope">
              <el-button
                type="primary"
                link
                size="small"
                @click="handleEdit(scope.row.id)"
              >
                <el-icon><Edit /></el-icon>
                编辑
              </el-button>
              <el-button
                type="warning"
                link
                size="small"
                @click="handleResetPassword(scope.row.id, scope.row.username)"
              >
                <el-icon><Refresh /></el-icon>
                重置密码
              </el-button>
              <el-button
                type="danger"
                link
                size="small"
                @click="handleDelete(scope.row.id)"
                :disabled="scope.row.role === 'ROLE_ADMIN' && scope.row.username === 'admin'"
              >
                <el-icon><Delete /></el-icon>
                删除
              </el-button>
            </template>
          </el-table-column>
        </el-table>
      </div>
      
      <!-- 分页 -->
      <div v-if="userList.length > 0" class="pagination-container" :class="{ 'loading': loading }">
        <el-pagination
          v-model:current-page="pagination.currentPage"
          v-model:page-size="pagination.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="pagination.total"
          @update:page-size="handleSizeChange"
          @update:current-page="handleCurrentChange"
          prev-text="上一页"
          next-text="下一页"
        ></el-pagination>
      </div>
      <div v-else-if="!loading" class="pagination-container empty">
        暂无用户数据
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Plus,
  Search,
  Refresh,
  Edit,
  Delete
} from '@element-plus/icons-vue'
import type { User } from '../../types'
import { getAllUsers, searchUsers, deleteUser, changeUserStatus, resetPassword } from '../../api/userApi'

const router = useRouter()

// 搜索表单
const searchForm = reactive({
  username: '',
  role: '',
  status: ''
})

// 加载状态
const loading = ref(false)

// 原始用户列表数据
const allUsers = ref<User[]>([])
// 分页后的用户列表数据（用于显示）
const userList = ref<User[]>([])

// 分页数据
const pagination = reactive({
  currentPage: 1,
  pageSize: 10,
  total: 0
})

// 加载用户列表
const loadUserList = async () => {
  loading.value = true
  try {
    const response = await getAllUsers()
    // 使用类型断言修复TypeScript错误
    allUsers.value = response || []
    pagination.total = allUsers.value.length
    // 执行前端分页
    paginateUsers()
  } catch (error) {
    console.error('获取用户列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 执行前端分页
const paginateUsers = () => {
  const start = (pagination.currentPage - 1) * pagination.pageSize
  const end = start + pagination.pageSize
  userList.value = allUsers.value.slice(start, end)
}

// 搜索
const handleSearch = async () => {
  pagination.currentPage = 1
  await searchUsersList()
}

// 调用后端API搜索用户
const searchUsersList = async () => {
  loading.value = true
  try {
    // 合并搜索条件
    const keyword = searchForm.username
    const role = searchForm.role
    const status = searchForm.status
    
    // 调用后端API进行搜索
    const response = await searchUsers(keyword, role, status)
    // 使用类型断言修复TypeScript错误
    allUsers.value = response || []
    pagination.total = allUsers.value.length
    // 执行前端分页
    paginateUsers()
  } catch (error) {
    console.error('搜索用户列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 重置
const handleReset = async () => {
  searchForm.username = ''
  searchForm.role = ''
  searchForm.status = ''
  pagination.currentPage = 1
  await loadUserList()
}

// 分页大小变化
const handleSizeChange = (size: number) => {
  pagination.pageSize = size
  // 执行前端分页
  paginateUsers()
}

// 当前页变化
const handleCurrentChange = (current: number) => {
  pagination.currentPage = current
  // 执行前端分页
  paginateUsers()
}

// 添加用户
const handleAdd = () => {
  router.push('/users/add')
}

// 编辑用户
const handleEdit = (id: number) => {
  router.push(`/users/edit/${id}`)
}

// 删除用户
const handleDelete = (id: number) => {
  const user = userList.value.find(u => u.id === id)
  if (user && user.username === 'admin') {
    ElMessage.warning('不能删除默认管理员账号')
    return
  }
  
  ElMessageBox.confirm(
    '确定要删除该用户吗？此操作不可撤销。',
    '删除确认',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    loading.value = true
    try {
      await deleteUser(id)
      // 重新获取用户列表
      await loadUserList()
      ElMessage.success('删除成功')
    } catch (error) {
      console.error('删除用户失败:', error)
    } finally {
      loading.value = false
    }
  }).catch(() => {
    // 取消删除
  })
}

// 状态变更
const handleStatusChange = async (user: any) => {
  if (user.username === 'admin') {
    user.status = 1
    ElMessage.warning('不能禁用默认管理员账号')
    return
  }
  
  loading.value = true
  try {
    await changeUserStatus(user.id, user.status)
    ElMessage.success('状态更新成功')
  } catch (error) {
    console.error('更新用户状态失败:', error)
    // 恢复原状态
    await loadUserList()
  } finally {
    loading.value = false
  }
}

// 重置密码
const handleResetPassword = async (id: number, username: string) => {
  ElMessageBox.prompt('请输入新密码', `重置用户 ${username} 的密码`, {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    inputType: 'password',
    inputPlaceholder: '请输入新密码',
    inputValidator: (value) => {
      if (!value) {
        return '请输入新密码'
      }
      if (value.length < 6) {
        return '密码长度不能少于6位'
      }
      return true
    }
  }).then(async ({ value }) => {
    loading.value = true
    try {
      await resetPassword(id, value)
      ElMessage.success('密码重置成功')
    } catch (error) {
      console.error('重置密码失败:', error)
      ElMessage.error('重置密码失败')
    } finally {
      loading.value = false
    }
  }).catch(() => {
    // 取消重置
  })
}

// 页面加载时获取用户列表
onMounted(() => {
  loadUserList()
})
</script>

<style scoped>
.user-management-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.user-management-card {
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

.add-user-btn {
  display: flex;
  align-items: center;
  gap: 8px;
}

.search-filter-container {
  margin-bottom: 20px;
  padding: 16px;
  background-color: var(--bg-secondary);
  border-radius: var(--border-radius-md);
}

.search-form {
  display: flex;
  flex-wrap: wrap;
  gap: 16px;
  align-items: center;
}

.search-input {
  width: 200px;
}

.search-select {
  width: 150px;
}

.user-list-container {
  margin-bottom: 20px;
}

.user-table {
  border-radius: var(--border-radius-md);
  overflow: hidden;
}

@media (max-width: 768px) {
  .search-form {
    flex-direction: column;
    align-items: stretch;
  }
  
  .search-input,
  .search-select {
    width: 100%;
  }
  
  .card-header {
    flex-direction: column;
    align-items: stretch;
    gap: 16px;
  }
  
  .add-user-btn {
    justify-content: center;
  }
  
  .pagination-container {
    justify-content: center;
  }
}
</style>