<template>
  <div class="student-list-container">
    <el-card class="list-card">
      <template #header>
        <div class="card-header">
          <span>学生列表</span>
          <div class="header-actions">
            <el-button type="success" @click="handleExport">
              <el-icon><Download /></el-icon>
              导出Excel
            </el-button>
            <el-button type="primary" @click="handleAddStudent">
              <el-icon><Plus /></el-icon>
              添加学生
            </el-button>
          </div>
        </div>
      </template>
      
      <!-- 基础搜索区域 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="学号">
          <el-input v-model="searchForm.studentId" placeholder="请输入学号" clearable></el-input>
        </el-form-item>
        
        <el-form-item label="姓名">
          <el-input v-model="searchForm.name" placeholder="请输入姓名" clearable></el-input>
        </el-form-item>
        
        <el-form-item label="班级">
          <el-input v-model="searchForm.className" placeholder="请输入班级" clearable></el-input>
        </el-form-item>
        
        <el-form-item label="状态">
          <el-select v-model="searchForm.status" placeholder="请选择状态" clearable style="width: 150px;">
            <el-option label="在读" value="在读"></el-option>
            <el-option label="休学" value="休学"></el-option>
            <el-option label="退学" value="退学"></el-option>
            <el-option label="毕业" value="毕业"></el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="handleReset">重置</el-button>
          <el-button type="default" @click="advancedSearchVisible = !advancedSearchVisible">
            <el-icon><ArrowDown v-if="advancedSearchVisible" /><ArrowUp v-else /></el-icon>
            高级搜索
          </el-button>
        </el-form-item>
      </el-form>
      
      <!-- 高级搜索面板 -->
      <el-collapse-transition>
        <el-form 
          v-if="advancedSearchVisible" 
          :inline="true" 
          :model="advancedSearchForm" 
          class="advanced-search-form"
        >
          <el-form-item label="性别">
            <el-select v-model="advancedSearchForm.gender" placeholder="请选择性别" clearable style="width: 120px;">
              <el-option label="男" value="男"></el-option>
              <el-option label="女" value="女"></el-option>
            </el-select>
          </el-form-item>
          
          <el-form-item label="手机号">
            <el-input v-model="advancedSearchForm.phone" placeholder="请输入手机号" clearable></el-input>
          </el-form-item>
          
          <el-form-item label="邮箱">
            <el-input v-model="advancedSearchForm.email" placeholder="请输入邮箱" clearable></el-input>
          </el-form-item>
          
          <el-form-item label="创建时间">
            <el-date-picker
              v-model="advancedSearchForm.created_at"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              clearable
            ></el-date-picker>
          </el-form-item>
          
          <el-form-item>
            <el-button type="primary" @click="handleAdvancedSearch">
              <el-icon><Search /></el-icon>
              高级搜索
            </el-button>
          </el-form-item>
        </el-form>
      </el-collapse-transition>
      
      <!-- 学生列表表格 -->
      <el-table
        :data="studentList"
        :loading="loading"
        border
        stripe
        style="width: 100%"
        :default-sort="{ prop: 'id', order: 'descending' }"
        empty-text=""
      >
        <!-- 自定义空状态 -->
        <template #empty>
          <div class="empty-state-container">
            <el-empty
              description="暂无学生数据"
              :image-size="100"
            >
              <template #description>
                <span class="empty-state-text">
                  {{ isSearching ? '未找到匹配的学生信息' : '暂无学生数据' }}
                </span>
              </template>
              <el-button type="primary" @click="handleReset" v-if="isSearching">
                <el-icon><Refresh /></el-icon>
                重置搜索
              </el-button>
              <el-button type="primary" @click="handleAddStudent" v-else>
                <el-icon><Plus /></el-icon>
                添加学生
              </el-button>
            </el-empty>
          </div>
        </template>
        
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="studentId" label="学号" sortable></el-table-column>
        <el-table-column prop="name" label="姓名" sortable></el-table-column>
        <el-table-column prop="gender" label="性别" width="80"></el-table-column>
        <el-table-column label="学院">
          <template #default="scope">
            {{ scope.row.major?.college?.collegeName || '-' }}
          </template>
        </el-table-column>
        <el-table-column label="专业">
          <template #default="scope">
            {{ scope.row.major?.majorName || '-' }}
          </template>
        </el-table-column>
        <el-table-column prop="className" label="班级"></el-table-column>
        <el-table-column prop="phone" label="手机号"></el-table-column>
        <el-table-column prop="email" label="邮箱"></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="getStatusTagType(scope.row.status)">{{ scope.row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="180" sortable></el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template #default="scope">
            <el-button
              type="primary"
              size="small"
              @click="handleViewDetail(scope.row.id)"
            >
              查看详情
            </el-button>
            <el-button
              size="small"
              @click="handleEditStudent(scope.row.id)"
            >
              编辑
            </el-button>
            <el-button
              type="danger"
              size="small"
              @click="handleDeleteStudent(scope.row.id)"
            >
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页组件 -->
      <div v-if="studentList.length > 0" class="pagination-container" :class="{ 'loading': loading }">
        <el-pagination
          v-model:current-page="pagination.page"
          v-model:page-size="pagination.size"
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
        暂无学生数据
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search, Download, ArrowDown, ArrowUp } from '@element-plus/icons-vue'
import * as XLSX from 'xlsx'
import type { Student } from '../../types'
import { getAllStudents, searchStudents, deleteStudent } from '../../api/studentApi'

const router = useRouter()

// 搜索表单
const searchForm = reactive({
  studentId: '',
  name: '',
  className: '',
  status: ''
})

// 高级搜索表单
const advancedSearchForm = reactive({
  gender: '',
  phone: '',
  email: '',
  created_at: null as [Date, Date] | null
})

// 高级搜索可见性
const advancedSearchVisible = ref(false)

// 搜索状态标识
const isSearching = ref(false)

// 分页配置
const pagination = reactive({
  page: 1,
  size: 10,
  total: 100
})

// 加载状态
const loading = ref(false)



// 获取状态标签类型
const getStatusTagType = (status: string) => {
  switch (status) {
    case '在读':
      return 'success'
    case '休学':
      return 'warning'
    case '退学':
      return 'danger'
    case '毕业':
      return 'info'
    default:
      return ''
  }
}

// 原始学生列表数据
const allStudents = ref<Student[]>([])
// 分页后的学生列表数据（用于显示）
const studentList = ref<Student[]>([])

// 获取学生列表数据
const fetchStudents = async () => {
  loading.value = true
  try {
    const response = await getAllStudents()
    // 使用类型断言修复TypeScript错误
    allStudents.value = response || []
    pagination.total = allStudents.value.length
    // 执行前端分页
    paginateStudents()
  } catch (error) {
    console.error('获取学生列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 执行前端分页
const paginateStudents = () => {
  const start = (pagination.page - 1) * pagination.size
  const end = start + pagination.size
  studentList.value = allStudents.value.slice(start, end)
}

// 初始化获取学生列表
onMounted(() => {
  fetchStudents()
})

// 处理搜索
const handleSearch = async () => {
  // 重置到第一页
  pagination.page = 1
  // 设置搜索状态
  isSearching.value = true
  // 执行搜索
  await searchStudentsList()
}

// 处理高级搜索
const handleAdvancedSearch = async () => {
  // 重置到第一页
  pagination.page = 1
  // 设置搜索状态
  isSearching.value = true
  // 执行搜索
  await searchStudentsList()
}

// 调用后端API搜索学生
const searchStudentsList = async () => {
  loading.value = true
  try {
    // 合并搜索条件
    const keyword = searchForm.name || searchForm.studentId
    const className = searchForm.className
    
    // 调用后端API进行搜索
    const response = await searchStudents(keyword, className)
    // 使用类型断言修复TypeScript错误
    allStudents.value = response || []
    pagination.total = allStudents.value.length
    // 重置页码到第一页
    pagination.page = 1
    // 执行前端分页
    paginateStudents()
  } catch (error) {
    console.error('搜索学生列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 处理重置
const handleReset = async () => {
  Object.assign(searchForm, {
    studentId: '',
    name: '',
    className: '',
    status: ''
  })
  
  // 重置高级搜索表单
  Object.assign(advancedSearchForm, {
    gender: '',
    phone: '',
    email: '',
    created_at: null
  })
  
  // 重置页码
  pagination.page = 1
  // 重置搜索状态
  isSearching.value = false
  
  // 重新获取完整数据
  await fetchStudents()
}

// 处理导出Excel
const handleExport = () => {
  try {
    // 准备导出数据
    const exportData = studentList.value.map(student => ({
      '学号': student.studentId,
      '姓名': student.name,
      '性别': student.gender,
      '班级': student.className,
      '手机号': student.phone,
      '邮箱': student.email,
      '状态': student.status,
      '创建时间': student.createdAt
    }))
    
    // 创建工作簿和工作表
    const worksheet = XLSX.utils.json_to_sheet(exportData)
    const workbook = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(workbook, worksheet, '学生列表')
    
    // 导出文件
    XLSX.writeFile(workbook, `学生列表_${new Date().toISOString().slice(0, 10)}.xlsx`)
    
    ElMessage.success('导出成功')
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error('导出失败')
  }
}

// 处理添加学生
const handleAddStudent = () => {
  router.push('/students/add')
}

// 处理查看详情
const handleViewDetail = (id: number) => {
  router.push(`/students/detail/${id}`)
}

// 处理编辑学生
const handleEditStudent = (id: number) => {
  router.push(`/students/edit/${id}`)
}

// 处理删除学生
const handleDeleteStudent = (id: number) => {
  ElMessageBox.confirm('确定要删除该学生吗？', '删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(async () => {
      // 调用API进行删除
      await deleteStudent(id)
      // 刷新学生列表
      await fetchStudents()
      ElMessage.success('删除成功')
    })
    .catch(() => {
      // 取消删除
    })
}

// 处理分页大小变化
const handleSizeChange = (size: number) => {
  pagination.size = size
  // 执行前端分页
  paginateStudents()
}

// 处理当前页码变化
const handleCurrentChange = (page: number) => {
  pagination.page = page
  // 执行前端分页
  paginateStudents()
}
</script>

<style scoped>
.student-list-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.search-form {
  margin-bottom: 10px;
  padding: 10px;
  background-color: #f5f7fa;
  border-radius: 4px;
}

.advanced-search-form {
  margin-bottom: 20px;
  padding: 15px;
  background-color: #f0f2f5;
  border-radius: 4px;
  border: 1px solid #e6e6e6;
}

.advanced-search-form .el-form-item {
  margin-bottom: 15px;
}

@media (max-width: 768px) {
  .search-form {
    flex-direction: column;
    gap: 10px;
  }
  
  .el-form-item {
    margin-right: 0 !important;
    margin-bottom: 10px !important;
  }
}
</style>