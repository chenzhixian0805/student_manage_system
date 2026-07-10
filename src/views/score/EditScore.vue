<template>
  <div class="score-form-container">
    <el-card class="form-card">
      <template #header>
        <div class="card-header">
          <span>{{ isEdit ? '编辑成绩' : '添加成绩' }}</span>
        </div>
      </template>
      
      <el-form
        ref="scoreFormRef"
        :model="scoreForm"
        :rules="scoreRules"
        label-width="120px"
        class="score-form"
      >
        <el-form-item label="学生" prop="student_id">
          <el-select
            v-model="scoreForm.student_id"
            placeholder="请选择学生"
            filterable
            remote
            :remote-method="handleStudentSearch"
            :loading="studentLoading"
            :disabled="isEdit.value"
          >
            <el-option
              v-for="student in studentOptions"
              :key="student.id"
              :label="student.name + ' (' + student.student_id + ')'"
              :value="student.id"
            ></el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="课程" prop="course_id">
          <el-select
            v-model="scoreForm.course_id"
            placeholder="请选择课程"
            filterable
            remote
            :remote-method="handleCourseSearch"
            :loading="courseLoading"
            :disabled="isEdit.value"
          >
            <el-option
              v-for="course in courseOptions"
              :key="course.id"
              :label="course.name + ' (' + course.course_id + ')'"
              :value="course.id"
            ></el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item label="分数" prop="score">
          <el-input
            v-model.number="scoreForm.score"
            placeholder="请输入分数"
            type="number"
            :min="0"
            :max="100"
            @input="updateGpa"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="GPA" prop="gpa">
          <el-input
            v-model.number="scoreForm.gpa"
            placeholder="自动计算"
            type="number"
            :min="0"
            :max="5.0"
            step="0.1"
            disabled
          ></el-input>
        </el-form-item>
        
        <el-form-item label="学期" prop="semester">
          <el-input
            v-model="scoreForm.semester"
            placeholder="请输入学期，如：2023-2024-1"
            :disabled="isEdit.value"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="考试日期时间" prop="exam_datetime">
          <el-date-picker
            v-model="scoreForm.exam_datetime"
            type="datetime"
            placeholder="选择考试日期和时间"
            value-format="YYYY-MM-DD HH:mm:ss"
            format="YYYY-MM-DD HH:mm:ss"
            :disabled="isEdit.value"
          ></el-date-picker>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" :loading="loading" @click="handleSubmit">
            {{ isEdit ? '保存修改' : '添加成绩' }}
          </el-button>
          <el-button @click="handleCancel">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import type { Score } from '../../types'

const router = useRouter()
const route = useRoute()
const scoreFormRef = ref<FormInstance>()
const loading = ref(false)

// 判断是否为编辑模式
const isEdit = ref(!!route.params.id)



// 成绩表单
const scoreForm = reactive<Partial<Score>>({  student_id: undefined,
  course_id: undefined,
  score: 0,
  gpa: 0,
  semester: '',
  exam_datetime: ''
})

// 绩点计算规则：0-59分=0.0，60分=1.0，每增加1分+0.1，最高不超过5.0，保留两位小数
const calculateGpa = (score: number): number => {
  if (score < 60) {
    return 0.0
  } else {
    // 0-59=0.0，60分=1.0，每增加1分+0.1，最高不超过5.0
    const gpa = (score - 60) * 0.1 + 1.0
    const finalGpa = Math.min(gpa, 5.0)
    // 保留两位小数
    return Math.round(finalGpa * 100) / 100
  }
}

// 移除不必要的score ref

// 监听scoreForm.score变化，自动计算gpa
const updateGpa = () => {
  if (scoreForm.score !== undefined) {
    // 确保score是数字类型
    const scoreValue = typeof scoreForm.score === 'string' ? parseFloat(scoreForm.score) : scoreForm.score
    scoreForm.gpa = calculateGpa(scoreValue)
  }
}

// 为scoreForm.score添加watch，当score变化时自动计算gpa
watch(() => scoreForm.score, () => {
  updateGpa()
}, { immediate: true }) // 立即执行一次，确保初始值也能计算绩点

// 表单验证规则
const scoreRules = reactive<FormRules>({
  student_id: [
    { required: true, message: '请选择学生', trigger: 'change' }
  ],
  course_id: [
    { required: true, message: '请选择课程', trigger: 'change' }
  ],
  score: [
    { required: true, message: '请输入分数', trigger: 'blur' },
    { type: 'number', min: 0, max: 100, message: '分数必须在 0 到 100 之间', trigger: 'blur' }
  ],
  gpa: [
        { type: 'number', min: 0, max: 5.0, message: 'GPA必须在 0 到 5.0 之间', trigger: 'blur' }
      ],
  semester: [
    { required: true, message: '请输入学期', trigger: 'blur' }
  ],
  exam_datetime: [
    { required: true, message: '请选择考试日期和时间', trigger: 'change' }
  ]
})

// 学生选择器选项
const studentOptions = ref<any[]>([])

// 课程选择器选项
const courseOptions = ref<any[]>([])

// 加载状态
const studentLoading = ref(false)
const courseLoading = ref(false)

// 初始化数据（学生和课程列表）
const initData = async () => {
  try {
    // 导入API函数
    const { getAllStudents } = await import('../../api/studentApi')
    const { getAllCourses } = await import('../../api/courseApi')
    
    // 获取所有学生和课程
    const studentsResponse = await getAllStudents()
    const coursesResponse = await getAllCourses()
    
    // 处理分页数据，获取content字段
    const students = studentsResponse.content || studentsResponse
    const courses = coursesResponse.content || coursesResponse
    
    // 格式化学生选项
    studentOptions.value = students.map(student => ({
      id: student.id,
      name: student.name,
      student_id: student.studentId || student.student_id
    }))
    
    // 格式化课程选项
    courseOptions.value = courses.map(course => ({
      id: course.id,
      name: course.name,
      course_id: course.courseId || course.course_id
    }))
  } catch (error) {
    console.error('获取学生和课程数据失败:', error)
  }
}

// 处理学生搜索
const handleStudentSearch = async (query: string) => {
  studentLoading.value = true
  try {
    // 导入API函数
    const studentApi = await import('../../api/studentApi')
    
    // 根据是否有查询词选择不同的API
    const studentsResponse = query 
      ? await studentApi.searchStudents(query)
      : await studentApi.getAllStudents()
    
    // 处理响应数据
    const students = studentsResponse.content || studentsResponse
    
    // 格式化学生选项
    studentOptions.value = students.map(student => ({
      id: student.id,
      name: student.name,
      student_id: student.studentId || student.student_id
    }))
  } catch (error) {
    console.error('搜索学生失败:', error)
    studentOptions.value = []
  } finally {
    studentLoading.value = false
  }
}

// 处理课程搜索
const handleCourseSearch = async (query: string) => {
  courseLoading.value = true
  try {
    // 导入API函数
    const courseApi = await import('../../api/courseApi')
    
    // 根据是否有查询词选择不同的API
    const coursesResponse = query 
      ? await courseApi.searchCourses(query)
      : await courseApi.getAllCourses()
    
    // 处理响应数据
    const courses = coursesResponse.content || coursesResponse
    
    // 格式化课程选项
    courseOptions.value = courses.map(course => ({
      id: course.id,
      name: course.name,
      course_id: course.courseId || course.course_id
    }))
  } catch (error) {
    console.error('搜索课程失败:', error)
    courseOptions.value = []
  } finally {
    courseLoading.value = false
  }
}

// 初始化数据（编辑模式）
onMounted(async () => {
  // 无论是否为编辑模式，都获取所有学生和课程
  await initData()
  
  if (isEdit.value) {
    try {
      // 调用API获取成绩详情
      const { getGradeById } = await import('../../api/gradeApi')
      const gradeResponse = await getGradeById(Number(route.params.id))
      // 直接使用响应对象，不需要访问.data字段
      const gradeDetail = gradeResponse
      
      // 处理字段映射，将驼峰命名转换为下划线命名
      const gradeData = {
        student_id: gradeDetail.studentId || gradeDetail.student_id,
        course_id: gradeDetail.courseId || gradeDetail.course_id,
        score: gradeDetail.score,
        semester: gradeDetail.semester,
        exam_datetime: gradeDetail.examDateTime || gradeDetail.exam_datetime
      }
      
      // 将成绩详情赋值给表单
      Object.assign(scoreForm, gradeData)
      
      // 调用updateGpa函数，根据分数计算绩点
      updateGpa()
      
      // 直接使用gradeDetail中的student和course信息
      // 检查学生是否已经在选项中
      const studentExists = studentOptions.value.some(student => student.id === gradeData.student_id)
      if (!studentExists) {
        if (gradeDetail.student) {
          // 使用gradeDetail中已有的学生信息
          studentOptions.value.push({
            id: gradeDetail.student.id,
            name: gradeDetail.student.name,
            student_id: gradeDetail.student.studentId || gradeDetail.student.student_id
          })
        } else {
          // 如果gradeDetail.student不存在，通过API获取学生详情
          try {
            const { getStudentById } = await import('../../api/studentApi')
            const studentResponse = await getStudentById(gradeData.student_id)
            // 直接使用响应对象，不需要访问.data字段
            const student = studentResponse
            if (student) {
              // 添加学生到选项中
              studentOptions.value.push({
                id: student.id,
                name: student.name,
                student_id: student.studentId || student.student_id
              })
            }
          } catch (error) {
            console.error('获取学生详情失败:', error)
          }
        }
      }
      
      // 检查课程是否已经在选项中
      const courseExists = courseOptions.value.some(course => course.id === gradeData.course_id)
      if (!courseExists) {
        if (gradeDetail.course) {
          // 使用gradeDetail中已有的课程信息
          courseOptions.value.push({
            id: gradeDetail.course.id,
            name: gradeDetail.course.name,
            course_id: gradeDetail.course.courseId || gradeDetail.course.course_id
          })
        } else {
          // 如果gradeDetail.course不存在，通过API获取课程详情
          try {
            const { getCourseById } = await import('../../api/courseApi')
            const courseResponse = await getCourseById(gradeData.course_id)
            // 直接使用响应对象，不需要访问.data字段
            const course = courseResponse
            if (course) {
              // 添加课程到选项中
              courseOptions.value.push({
                id: course.id,
                name: course.name,
                course_id: course.courseId || course.course_id
              })
            }
          } catch (error) {
            console.error('获取课程详情失败:', error)
          }
        }
      }
    } catch (error) {
      console.error('获取成绩详情失败:', error)
      ElMessage.error('获取成绩详情失败')
      router.push('/scores')
    }
  }
})

// 处理表单提交
const handleSubmit = async () => {
  if (!scoreFormRef.value) return
  
  await scoreFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      
      try {
        // 导入API函数
        const { createGrade, updateGrade } = await import('../../api/gradeApi')
        
        // 构建后端所需的请求格式
        const gradeRequest = {
          studentId: scoreForm.student_id,
          courseId: scoreForm.course_id,
          score: scoreForm.score,
          gpa: scoreForm.gpa,
          semester: scoreForm.semester,
          examDateTime: scoreForm.exam_datetime
        }
        
        if (isEdit.value) {
          // 更新成绩
          await updateGrade(Number(route.params.id), gradeRequest)
          ElMessage.success('修改成功')
        } else {
          // 添加成绩
          await createGrade(gradeRequest)
          ElMessage.success('添加成功')
        }
        
        router.push('/scores')
        loading.value = false
      } catch (error) {
        console.error('操作失败:', error)
        ElMessage.error(isEdit.value ? '修改失败' : '添加失败')
        loading.value = false
      }
    }
  })
}

// 处理取消
const handleCancel = () => {
  router.push('/scores')
}
</script>

<style scoped>
.score-form-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.score-form {
  max-width: 600px;
  margin: 0 auto;
}

@media (max-width: 768px) {
  .score-form {
    max-width: 100%;
    padding: 0 10px;
  }
  
  .el-form-item {
    margin-right: 0 !important;
  }
}
</style>