<template>
  <div class="course-form-container">
    <el-card class="form-card">
      <template #header>
        <div class="card-header">
          <span>{{ isEdit ? '编辑课程' : '添加课程' }}</span>
        </div>
      </template>
      
      <el-form
        ref="courseFormRef"
        :model="courseForm"
        :rules="courseRules"
        label-width="120px"
        class="course-form"
      >
        <el-form-item label="课程ID" prop="course_id">
          <el-input
            v-model="courseForm.course_id"
            placeholder="请输入课程ID"
            :disabled="isEdit"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="课程名称" prop="name">
          <el-input
            v-model="courseForm.name"
            placeholder="请输入课程名称"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="学分" prop="credit">
          <el-input
            v-model.number="courseForm.credit"
            placeholder="请输入学分"
            type="number"
            :min="0"
            :max="10"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="课程类型" prop="description">
          <el-select
            v-model="courseForm.description"
            placeholder="请选择课程类型"
            clearable
          >
            <el-option label="必修" value="必修"></el-option>
            <el-option label="选修" value="选修"></el-option>
            <el-option label="公共课" value="公共课"></el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="授课教师" prop="teacher_id">
          <el-select
            v-model="courseForm.teacher_id"
            placeholder="请选择授课教师"
            clearable
          >
            <el-option
              v-for="teacher in teachers"
              :key="teacher.id"
              :label="teacher.name"
              :value="teacher.id"
            >
              {{ teacher.name }} ({{ teacher.employeeId }})
            </el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" :loading="loading" @click="handleSubmit">
            {{ isEdit ? '保存修改' : '添加课程' }}
          </el-button>
          <el-button @click="handleCancel">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import type { Course } from '../../types'
import { createCourse, updateCourse, getCourseById } from '../../api/courseApi'
import { Logger, LogType } from '../../utils/logger'

const router = useRouter()
const route = useRoute()
const courseFormRef = ref<FormInstance>()
const loading = ref(false)
const teachers = ref<any[]>([])
const teachersLoading = ref(false)

// 判断是否为编辑模式
const isEdit = computed(() => !!route.params.id)

// 课程表单
const courseForm = reactive<Partial<Course>>({  course_id: '',  name: '',  credit: 0,  description: '',  teacher_id: undefined})

// 表单验证规则
const courseRules = reactive<FormRules>({
  course_id: [
    { required: true, message: '请输入课程ID', trigger: 'blur' },
    { min: 3, max: 20, message: '课程ID长度在 3 到 20 个字符', trigger: 'blur' },
    { pattern: /^[A-Z0-9]+$/, message: '课程ID只能包含大写字母和数字', trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入课程名称', trigger: 'blur' },
    { min: 2, max: 50, message: '课程名称长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  credit: [
    { required: true, message: '请输入学分', trigger: 'blur' },
    { type: 'number', min: 1, max: 10, message: '学分必须在 1 到 10 之间', trigger: 'blur' },
    { validator: (_rule, value, callback) => {
        if (value !== undefined && value % 0.5 !== 0) {
          callback(new Error('学分必须是0.5的倍数'));
        } else {
          callback();
        }
      },
      trigger: 'blur'
    }
  ],
  description: [
    { max: 200, message: '课程描述不能超过200个字符', trigger: 'blur' }
  ]
})

// 获取教师列表
const fetchTeachers = async () => {
  teachersLoading.value = true
  try {
    // 调用教师API获取所有教师列表
    const response = await fetch('/api/teachers', {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
      }
    })
    
    if (response.ok) {
      const data = await response.json()
      if (data.code === 200 && Array.isArray(data.data)) {
        teachers.value = data.data
      }
    }
  } catch (error) {
    console.error('获取教师列表失败:', error)
  } finally {
    teachersLoading.value = false
  }
}

// 初始化数据（编辑模式）
onMounted(async () => {
  // 获取教师列表
  await fetchTeachers()
  
  if (isEdit.value && route.params.id) {
    loading.value = true
    try {
      const id = Number(route.params.id)
      const response = await getCourseById(id)
      Object.assign(courseForm, response)
      // 如果课程有教师，设置teacher_id
      if (response.teacher) {
        courseForm.teacher_id = response.teacher.id
      }
    } catch (error) {
      Logger.error(LogType.ERROR, '获取课程详情', '获取课程详情失败', error)
      ElMessage.error('获取课程详情失败')
    } finally {
      loading.value = false
    }
  }
})

// 处理表单提交
const handleSubmit = async () => {
  if (!courseFormRef.value) return
  
  await courseFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      
      try {
        // 转换字段名，从下划线命名转换为驼峰命名
        const courseData = {
          courseId: courseForm.course_id,
          name: courseForm.name,
          credit: courseForm.credit,
          description: courseForm.description,
          teacherId: courseForm.teacher_id
        }
        
        if (isEdit.value && route.params.id) {
          // 更新课程
          const id = Number(route.params.id)
          await updateCourse(id, courseData)
          Logger.info(LogType.OPERATION, '更新课程', `课程更新成功，ID: ${id}`)
          ElMessage.success('修改成功')
        } else {
          // 添加课程
          await createCourse(courseData)
          Logger.info(LogType.OPERATION, '添加课程', `课程添加成功，ID: ${courseForm.course_id}`)
          ElMessage.success('添加成功')
        }
        router.push('/courses')
      } catch (error) {
        const action = isEdit.value ? '修改' : '添加'
        Logger.error(LogType.ERROR, `${action}课程`, `${action}课程失败`, error)
        ElMessage.error(`${action}失败`)
      } finally {
        loading.value = false
      }
    }
  })
}

// 处理取消
const handleCancel = () => {
  router.push('/courses')
}
</script>

<style scoped>
.course-form-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.course-form {
  max-width: 600px;
  margin: 0 auto;
}

@media (max-width: 768px) {
  .course-form {
    max-width: 100%;
    padding: 0 10px;
  }
  
  .el-form-item {
    margin-right: 0 !important;
  }
}
</style>