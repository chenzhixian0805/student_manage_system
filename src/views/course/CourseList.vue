<template>
  <div class="course-list-container">
    <el-card class="list-card">
      <template #header>
        <div class="card-header">
          <span>{{ isStudent ? '选课中心' : '课程列表' }}</span>
          <div class="header-actions" v-if="!isStudent">
            <el-button type="success" @click="handleExport">
              <el-icon><Download /></el-icon>
              导出Excel
            </el-button>
            <el-button type="primary" @click="handleAddCourse">
              <el-icon><Plus /></el-icon>
              添加课程
            </el-button>
          </div>
        </div>
      </template>
      
      <!-- 搜索和筛选区域 -->
      <el-form :inline="true" :model="searchForm" class="search-form">
        <el-form-item label="课程ID">
          <el-input v-model="searchForm.courseId" placeholder="请输入课程ID" clearable></el-input>
        </el-form-item>
        
        <el-form-item label="课程名称">
          <el-input v-model="searchForm.name" placeholder="请输入课程名称" clearable></el-input>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
      
      <!-- 课程列表表格 -->
      <el-table
        :data="courseList"
        :loading="loading"
        border
        stripe
        style="width: 100%"
        :default-sort="{ prop: 'id', order: 'descending' }"
      >
        <el-table-column prop="courseId" label="课程ID" sortable></el-table-column>
        <el-table-column prop="name" label="课程名称" sortable></el-table-column>
        <el-table-column prop="credit" label="学分" width="80"></el-table-column>
        <el-table-column prop="description" label="描述"></el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180" sortable></el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template #default="scope">
            <!-- 学生视角：选课/退选按钮 -->
            <template v-if="isStudent">
              <el-button
                v-if="selectedCourseIds.has(scope.row.id)"
                type="warning"
                size="small"
                @click="handleDropCourse(scope.row)"
              >
                退选
              </el-button>
              <el-button
                v-else
                type="primary"
                size="small"
                @click="handleSelectCourse(scope.row)"
              >
                选课
              </el-button>
            </template>
            <!-- 管理员/教师视角：编辑/删除按钮 -->
            <template v-else>
              <el-button
                size="small"
                @click="handleEditCourse(scope.row.id)"
              >
                编辑
              </el-button>
              <el-button
                type="danger"
                size="small"
                @click="handleDeleteCourse(scope.row.id)"
              >
                删除
              </el-button>
            </template>
          </template>
        </el-table-column>
      </el-table>
      
      <!-- 分页组件 -->
      <div v-if="courseList.length > 0" class="pagination-container" :class="{ 'loading': loading }">
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
        暂无课程数据
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, Search, Download } from '@element-plus/icons-vue'
import * as XLSX from 'xlsx'
import type { Course } from '../../types'
import { getAllCourses, searchCourses, deleteCourse } from '../../api/courseApi'
import { useUserStore } from '../../store/user'

const router = useRouter()
const userStore = useUserStore()

// 搜索表单
const searchForm = reactive({
  courseId: '',
  name: ''
})

// 分页配置
const pagination = reactive({
  page: 1,
  size: 10,
  total: 100
})

// 加载状态
const loading = ref(false)

// 原始课程列表数据
const allCourses = ref<Course[]>([])
// 分页后的课程列表数据（用于显示）
const courseList = ref<Course[]>([])

// 已选课程ID集合（模拟数据，实际应从API获取）
const selectedCourseIds = ref<Set<number>>(new Set([1, 3]))

// 计算当前用户是否为学生
const isStudent = computed(() => userStore.userInfo?.role === 'ROLE_STUDENT')

// 获取课程列表数据
const fetchCourses = async () => {
  loading.value = true
  try {
    const response = await getAllCourses()
    // 使用类型断言修复TypeScript错误
    allCourses.value = response || []
    pagination.total = allCourses.value.length
    // 执行前端分页
    paginateCourses()
  } catch (error) {
    ElMessage.error('获取课程列表失败')
  } finally {
    loading.value = false
  }
}

// 执行前端分页
const paginateCourses = () => {
  const start = (pagination.page - 1) * pagination.size
  const end = start + pagination.size
  courseList.value = allCourses.value.slice(start, end)
}

// 初始化获取课程列表
onMounted(() => {
  fetchCourses()
})

// 处理搜索
const handleSearch = async () => {
  // 重置到第一页
  pagination.page = 1
  // 执行搜索
  await searchCoursesList()
}

// 调用后端API搜索课程
const searchCoursesList = async () => {
  loading.value = true
  try {
    // 合并搜索条件
    const keyword = searchForm.name || searchForm.courseId
    
    // 调用后端API进行搜索
    const response = await searchCourses(keyword)
    // 使用类型断言修复TypeScript错误
    allCourses.value = response || []
    pagination.total = allCourses.value.length
    // 执行前端分页
    paginateCourses()
  } catch (error) {
    console.error('搜索课程列表失败:', error)
    ElMessage.error('搜索失败')
    // 清空当前列表，显示无数据
    allCourses.value = []
    courseList.value = []
    pagination.total = 0
  } finally {
    loading.value = false
  }
}

// 处理重置
const handleReset = async () => {
  Object.assign(searchForm, {
    course_id: '',
    name: ''
  })
  // 重新获取完整数据
  await fetchCourses()
}

// 处理导出Excel
const handleExport = () => {
  try {
    // 准备导出数据
    const exportData = courseList.value.map(course => ({
      '课程ID': course.courseId,
      '课程名称': course.name,
      '学分': course.credit,
      '描述': course.description,
      '创建时间': course.createTime
    }))
    
    // 创建工作簿和工作表
    const worksheet = XLSX.utils.json_to_sheet(exportData)
    const workbook = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(workbook, worksheet, '课程列表')
    
    // 导出文件
    XLSX.writeFile(workbook, `课程列表_${new Date().toISOString().slice(0, 10)}.xlsx`)
    
    ElMessage.success('导出成功')
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error('导出失败')
  }
}

// 处理添加课程
const handleAddCourse = () => {
  router.push('/courses/add')
}

// 处理编辑课程
const handleEditCourse = (id: number) => {
  router.push(`/courses/edit/${id}`)
}

// 处理删除课程
const handleDeleteCourse = (id: number) => {
  ElMessageBox.confirm('确定要删除该课程吗？', '删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(async () => {
      loading.value = true
      try {
        // 调用API进行删除
        await deleteCourse(id)
        ElMessage.success('删除成功')
        // 重新获取课程列表
        await fetchCourses()
      } catch (error) {
        console.error('删除课程失败:', error)
        ElMessage.error('删除失败')
      } finally {
        loading.value = false
      }
    })
    .catch(() => {
      // 取消删除
    })
}

// 处理选课
const handleSelectCourse = (course: Course) => {
  ElMessageBox.confirm(`确定要选 ${course.name} 课程吗？`, '选课确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'success'
  })
    .then(() => {
      // 实际应调用API进行选课
      selectedCourseIds.value.add(course.id)
      ElMessage.success('选课成功')
    })
    .catch(() => {
      // 取消选课
    })
}

// 处理退选
const handleDropCourse = (course: Course) => {
  ElMessageBox.confirm(`确定要退选 ${course.name} 课程吗？`, '退选确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  })
    .then(() => {
      // 实际应调用API进行退选
      selectedCourseIds.value.delete(course.id)
      ElMessage.success('退选成功')
    })
    .catch(() => {
      // 取消退选
    })
}

// 处理分页大小变化
const handleSizeChange = (size: number) => {
  pagination.size = size
  // 执行前端分页
  paginateCourses()
}

// 处理当前页码变化
const handleCurrentChange = (page: number) => {
  pagination.page = page
  // 执行前端分页
  paginateCourses()
}
</script>

<style scoped>
.course-list-container {
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
  margin-bottom: 20px;
  padding: 10px;
  background-color: #f5f7fa;
  border-radius: 4px;
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