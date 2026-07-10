<template>
  <div class="student-form-container">
    <el-card class="form-card">
      <template #header>
        <div class="card-header">
          <span>{{ isEdit ? '编辑学生' : '添加学生' }}</span>
        </div>
      </template>
      
      <el-form
        ref="studentFormRef"
        :model="studentForm"
        :rules="studentRules"
        label-width="120px"
        class="student-form"
      >
        <el-form-item label="学号" prop="studentId">
          <el-input
            v-model="studentForm.studentId"
            placeholder="请输入学号"
            :disabled="isEdit"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="姓名" prop="name">
          <el-input
            v-model="studentForm.name"
            placeholder="请输入姓名"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="性别" prop="gender">
          <el-radio-group v-model="studentForm.gender">
            <el-radio label="男">男</el-radio>
            <el-radio label="女">女</el-radio>
          </el-radio-group>
        </el-form-item>
        
        <el-form-item label="身份证号" prop="idCard">
          <el-input
            v-model="studentForm.idCard"
            placeholder="请输入身份证号"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="手机号" prop="phone">
          <el-input
            v-model="studentForm.phone"
            placeholder="请输入手机号"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="邮箱" prop="email">
          <el-input
            v-model="studentForm.email"
            placeholder="请输入邮箱"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="班级" prop="className">
          <el-input
            v-model="studentForm.className"
            placeholder="请输入班级"
          ></el-input>
        </el-form-item>
        
        <el-form-item label="状态" prop="status">
          <el-select v-model="studentForm.status" placeholder="请选择状态">
            <el-option label="在读" value="在读"></el-option>
            <el-option label="休学" value="休学"></el-option>
            <el-option label="退学" value="退学"></el-option>
            <el-option label="毕业" value="毕业"></el-option>
          </el-select>
        </el-form-item>
        
        <el-form-item>
          <el-button type="primary" :loading="loading" @click="handleSubmit">
            {{ isEdit ? '保存修改' : '添加学生' }}
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
import type { Student } from '../../types'
import { getStudentById, updateStudent, createStudent } from '../../api/studentApi'

const router = useRouter()
const route = useRoute()
const studentFormRef = ref<FormInstance>()
const loading = ref(false)

// 判断是否为编辑模式
const isEdit = computed(() => !!route.params.id)

// 学生表单
const studentForm = reactive<Partial<Student>>({
  studentId: '',
  name: '',
  gender: '男',
  idCard: '',
  phone: '',
  email: '',
  className: '',
  status: '在读'
})

// 表单验证规则
const studentRules = reactive<FormRules>({
  studentId: [
    { required: true, message: '请输入学号', trigger: 'blur' },
    { min: 8, max: 20, message: '学号长度在 8 到 20 个字符', trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入姓名', trigger: 'blur' },
    { min: 2, max: 20, message: '姓名长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  gender: [
    { required: true, message: '请选择性别', trigger: 'change' }
  ],
  idCard: [
    { pattern: /^\d{17}[\dXx]$/, message: '请输入有效的身份证号', trigger: 'blur' }
  ],
  phone: [
    { pattern: /^1[3-9]\d{9}$/, message: '请输入有效的手机号', trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: '请输入有效的邮箱地址', trigger: 'blur' }
  ],
  className: [
    { required: true, message: '请输入班级', trigger: 'blur' }
  ],
  status: [
    { required: true, message: '请选择状态', trigger: 'change' }
  ]
})

// 初始化数据（编辑模式）
onMounted(async () => {
  if (isEdit.value) {
    // 调用API获取学生详情
    const id = parseInt(route.params.id as string)
    loading.value = true
    try {
      const response = await getStudentById(id)
      Object.assign(studentForm, response)
    } catch (error) {
      console.error('获取学生详情失败:', error)
      ElMessage.error('获取学生详情失败')
      router.push('/students')
    } finally {
      loading.value = false
    }
  }
})

// 处理表单提交
const handleSubmit = async () => {
  if (!studentFormRef.value) return
  
  await studentFormRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      
      try {
        // 调用API进行添加或更新
        if (isEdit.value) {
          const id = parseInt(route.params.id as string)
          await updateStudent(id, studentForm)
          ElMessage.success('修改成功')
        } else {
          await createStudent(studentForm)
          ElMessage.success('添加成功')
        }
        router.push('/students')
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
  router.push('/students')
}
</script>

<style scoped>
.student-form-container {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.student-form {
  max-width: 600px;
  margin: 0 auto;
}

@media (max-width: 768px) {
  .student-form {
    max-width: 100%;
    padding: 0 10px;
  }
  
  .el-form-item {
    margin-right: 0 !important;
  }
}
</style>