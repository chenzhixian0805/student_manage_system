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
import { createStudent, updateStudent, getStudentById } from '../../api/studentApi'

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

// 自定义验证：身份证号验证
const validateIdCard = (_rule: any, value: string, callback: any) => {
  if (!value) {
    callback(new Error('请输入身份证号码'))
    return
  }
  
  // 18位身份证号验证正则
  const idCardRegex = /^[1-9]\d{5}(18|19|20)\d{2}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01])\d{3}[\dXx]$/
  if (!idCardRegex.test(value)) {
    callback(new Error('请输入有效的18位身份证号码'))
    return
  }
  
  // 校验码验证
  const weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
  const checkCodes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2']
  
  let sum = 0
  for (let i = 0; i < 17; i++) {
    sum += parseInt(value[i]) * weights[i]
  }
  
  const checkCode = checkCodes[sum % 11]
  if (checkCode !== value[17].toUpperCase()) {
    callback(new Error('身份证号码校验码错误，请检查'))
    return
  }
  
  callback()
}

// 自定义验证：学号唯一性验证
const validateStudentIdUnique = (_rule: any, value: string, callback: any) => {
  if (!value) {
    callback()
    return
  }
  
  // 模拟学号唯一性检查，实际项目中应调用API
  // 这里简单模拟，实际开发中需要替换为真实的API调用
  const existingStudentIds = ['20230001', '20230002', '20230003']
  
  // 编辑模式下排除当前学号
  const isEditing = isEdit.value
  const currentStudentId = isEditing ? studentForm.studentId : ''
  
  if (existingStudentIds.includes(value) && value !== currentStudentId) {
    callback(new Error('学号已存在，请更换其他学号'))
    return
  }
  
  callback()
}

// 表单验证规则
const studentRules = reactive<FormRules>({
  studentId: [
    { required: true, message: '请输入学号', trigger: ['blur', 'change'] },
    { min: 8, max: 20, message: '学号长度必须在 8-20 个字符之间', trigger: ['blur', 'change'] },
    { pattern: /^[a-zA-Z0-9]+$/, message: '学号只能包含字母和数字，不允许特殊字符', trigger: ['blur', 'change'] },
    { validator: validateStudentIdUnique, message: '学号已存在，请更换其他学号', trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入学生姓名', trigger: ['blur', 'change'] },
    { min: 2, max: 20, message: '姓名长度必须在 2-20 个字符之间', trigger: ['blur', 'change'] },
    { pattern: /^[\u4e00-\u9fa5a-zA-Z\s·.]+$/, message: '姓名只能包含中文、英文字母、空格、点和分隔符', trigger: ['blur', 'change'] }
  ],
  gender: [
    { required: true, message: '请选择学生性别', trigger: 'change' }
  ],
  idCard: [
    { required: true, message: '请输入身份证号码', trigger: ['blur', 'change'] },
    { validator: validateIdCard, message: '请输入有效的18位身份证号码', trigger: ['blur', 'change'] }
  ],
  phone: [
    { required: true, message: '请输入手机号码', trigger: ['blur', 'change'] },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入有效的11位手机号码', trigger: ['blur', 'change'] }
  ],
  email: [
    { required: true, message: '请输入电子邮箱', trigger: ['blur', 'change'] },
    { type: 'email', message: '请输入有效的电子邮箱地址', trigger: ['blur', 'change'] },
    { pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/, message: '邮箱格式不正确，示例：user@example.com', trigger: ['blur', 'change'] }
  ],
  className: [
    { required: true, message: '请输入班级名称', trigger: ['blur', 'change'] },
    { min: 2, max: 50, message: '班级名称长度必须在 2-50 个字符之间', trigger: ['blur', 'change'] },
    { pattern: /^[^<>'"&]+$/, message: '班级名称不允许包含特殊字符', trigger: ['blur', 'change'] }
  ],
  status: [
    { required: true, message: '请选择学生状态', trigger: 'change' }
  ]
})



// 初始化数据（编辑模式）
onMounted(async () => {
  if (isEdit.value && route.params.id) {
    loading.value = true
    try {
      const id = Number(route.params.id)
      const response = await getStudentById(id)
      Object.assign(studentForm, response)
      
      // 权限检查：学生只能编辑自己的信息
      const userInfoStr = localStorage.getItem('userInfo')
      if (userInfoStr) {
        const userInfo = JSON.parse(userInfoStr)
        if (userInfo.role === 'ROLE_STUDENT') {
          // 检查当前学生是否与登录用户一致
            if (userInfo.username !== studentForm.studentId) {
            ElMessage.error('您没有权限编辑该学生信息')
            router.push('/students/my-info')
          }
        }
      }
    } catch (error) {
      console.error('获取学生详情失败:', error)
      ElMessage.error('获取学生详情失败')
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
        if (isEdit.value && route.params.id) {
          // 更新学生
          const id = Number(route.params.id)
          await updateStudent(id, studentForm)
          ElMessage.success('修改成功')
          
          // 从localStorage获取当前用户信息，判断是否为学生
          const userInfoStr = localStorage.getItem('userInfo')
          if (userInfoStr) {
            const userInfo = JSON.parse(userInfoStr)
            if (userInfo.role === 'ROLE_STUDENT') {
              // 学生修改自己的信息后，返回自己的信息页面
              router.push('/students/my-info')
              return
            }
          }
          // 管理员和教师修改学生信息后，返回学生列表
          router.push('/students')
        } else {
          // 添加学生
          await createStudent(studentForm)
          ElMessage.success('添加成功')
          router.push('/students')
        }
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
  // 从localStorage获取当前用户信息，判断是否为学生
  const userInfoStr = localStorage.getItem('userInfo')
  if (userInfoStr) {
    const userInfo = JSON.parse(userInfoStr)
    if (userInfo.role === 'ROLE_STUDENT') {
      // 学生取消编辑后，返回自己的信息页面
      router.push('/students/my-info')
      return
    }
  }
  // 管理员和教师取消编辑后，返回学生列表
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