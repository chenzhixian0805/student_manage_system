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
        
        <el-form-item label="描述" prop="description">
          <el-input
            v-model="courseForm.description"
            placeholder="请输入课程描述"
            type="textarea"
            :rows="4"
          ></el-input>
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
import { getCourseById, updateCourse, createCourse } from '../../api/courseApi'

const router = useRouter()
const route = useRoute()
const courseFormRef = ref<FormInstance>()
const loading = ref(false)

// 判断是否为编辑模式
const isEdit = computed(() => !!route.params.id)

// 课程表单
const courseForm = reactive<Partial<Course>>({
  course_id: '',
  name: '',
  credit: 0,
  description: ''
})

// 表单验证规则
const courseRules = reactive<FormRules>({
  course_id: [
    { required: true, message: '请输入课程ID', trigger: 'blur' },
    { min: 3, max: 20, message: '课程ID长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入课程名称', trigger: 'blur' },
    { min: 2, max: 50, message: '课程名称长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  credit: [
    { required: true, message: '请输入学分', trigger: 'blur' },
    { type: 'number', min: 0, max: 10, message: '学分必须在 0 到 10 之间', trigger: 'blur' }
  ]
})

// 初始化数据（编辑模式）
onMounted(async () => {
  if (isEdit.value) {
    loading.value = true
    try {
      // 调用API获取课程详情
      const id = parseInt(route.params.id as string)
      const response = await getCourseById(id)
      // 处理字段映射，将驼峰命名转换为下划线命名
      const courseData = {
        id: response.id,
        course_id: response.courseId || response.course_id,
        name: response.name,
        description: response.description,
        credit: response.credit,
        teacher_id: response.teacherId || response.teacher_id
      }
      Object.assign(courseForm, courseData)
    } catch (error) {
      console.error('获取课程详情失败:', error)
      ElMessage.error('获取课程详情失败')
      router.push('/courses')
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
        
        // 调用API进行添加或更新
        if (isEdit.value) {
          const id = parseInt(route.params.id as string)
          await updateCourse(id, courseData)
          ElMessage.success('修改成功')
        } else {
          await createCourse(courseData)
          ElMessage.success('添加成功')
        }
        router.push('/courses')
      } catch (error) {
        console.error('提交失败:', error)
        ElMessage.error(isEdit.value ? '修改失败' : '添加失败')
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