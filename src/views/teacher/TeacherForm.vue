<template>
  <el-form
    ref="formRef"
    :model="model"
    :rules="rules"
    label-width="100px"
    class="teacher-form"
  >
    <!-- 工号 -->
    <el-form-item label="工号" prop="employeeId">
      <el-input
        v-model="model.employeeId"
        placeholder="请输入工号"
        @blur="checkEmployeeId"
      >
        <template #prepend>
          <el-icon><User /></el-icon>
        </template>
      </el-input>
      <el-form-item v-if="employeeIdExists" prop="employeeId" error="该工号已存在">
        <template #error>
          该工号已存在
        </template>
      </el-form-item>
    </el-form-item>
    
    <!-- 性别 -->
    <el-form-item label="性别" prop="gender">
      <el-select v-model="model.gender" placeholder="请选择性别">
        <el-option label="男" value="男"></el-option>
        <el-option label="女" value="女"></el-option>
      </el-select>
    </el-form-item>

    <!-- 用户名 -->
    <el-form-item label="用户名" prop="username">
      <el-input
        v-model="model.username"
        placeholder="请输入用户名"
      >
        <template #prepend>
          <el-icon><CircleUser /></el-icon>
        </template>
      </el-input>
    </el-form-item>

    <!-- 密码 -->
    <el-form-item
      label="密码"
      prop="password"
      :rules="isEdit ? editPasswordRules : createPasswordRules"
    >
      <el-input
        v-model="model.password"
        type="password"
        placeholder="请输入密码"
        show-password
      >
        <template #prepend>
          <el-icon><Lock /></el-icon>
        </template>
      </el-input>
    </el-form-item>

    <!-- 姓名 -->
    <el-form-item label="姓名" prop="name">
      <el-input
        v-model="model.name"
        placeholder="请输入真实姓名"
      >
        <template #prepend>
          <el-icon><UserFilled /></el-icon>
        </template>
      </el-input>
    </el-form-item>

    <!-- 邮箱 -->
    <el-form-item label="邮箱" prop="email">
      <el-input
        v-model="model.email"
        placeholder="请输入邮箱"
        type="email"
      >
        <template #prepend>
          <el-icon><Message /></el-icon>
        </template>
      </el-input>
    </el-form-item>

    <!-- 电话 -->
    <el-form-item label="电话" prop="phone">
      <el-input
        v-model="model.phone"
        placeholder="请输入电话"
      >
        <template #prepend>
          <el-icon><Phone /></el-icon>
        </template>
      </el-input>
    </el-form-item>

    <!-- 状态 -->
    <el-form-item label="状态" prop="status">
      <el-radio-group v-model="model.status">
        <el-radio :label="1">启用</el-radio>
        <el-radio :label="0">禁用</el-radio>
      </el-radio-group>
    </el-form-item>
  </el-form>
</template>

<script setup lang="ts">
import { ref, reactive, watch } from 'vue';
import { User, Lock, UserFilled, Message, Phone } from '@element-plus/icons-vue';
import { checkEmployeeId as checkEmployeeIdApi } from '../../api/teacherApi';
import { Teacher } from '../../api/teacherApi';

// 定义props
const props = defineProps<{
  model: Teacher;
  isEdit: boolean;
}>();

// 定义emits (暂时未使用，保留定义)
// const emit = defineEmits<{
//   (e: 'update:model', value: Teacher): void;
// }>();

// 表单引用
const formRef = ref();

// 工号是否存在
const employeeIdExists = ref(false);
let originalEmployeeId = ref(props.model.employeeId);

// 监听model变化
watch(
  () => props.model,
  (newVal) => {
    if (newVal.employeeId !== originalEmployeeId.value) {
      employeeIdExists.value = false;
    }
  },
  { deep: true }
);

// 工号验证
const checkEmployeeId = async () => {
  if (!props.model.employeeId) {
    employeeIdExists.value = false;
    return;
  }

  // 如果是编辑状态且工号未修改，不检查
  if (props.isEdit && props.model.employeeId === originalEmployeeId.value) {
    employeeIdExists.value = false;
    return;
  }

  try {
    const exists = await checkEmployeeIdApi(props.model.employeeId);
    employeeIdExists.value = exists;
  } catch (error) {
    employeeIdExists.value = false;
  }
};

// 表单验证规则
const rules = reactive({
  employeeId: [
    { required: true, message: '请输入工号', trigger: 'blur' },
    { min: 4, max: 20, message: '工号长度在4到20个字符', trigger: 'blur' }
  ],
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在3到20个字符', trigger: 'blur' }
  ],
  name: [
    { required: true, message: '请输入真实姓名', trigger: 'blur' },
    { min: 2, max: 20, message: '姓名长度在2到20个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入有效的邮箱地址', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入电话', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入有效的手机号码', trigger: 'blur' }
  ],
  gender: [
    { required: false, message: '请选择性别', trigger: 'change' }
  ],
  status: [
    { required: true, message: '请选择状态', trigger: 'change' }
  ]
});

// 创建密码规则
const createPasswordRules = [
  { required: true, message: '请输入密码', trigger: 'blur' },
  { min: 6, max: 20, message: '密码长度在6到20个字符', trigger: 'blur' }
];

// 编辑密码规则
const editPasswordRules = [
  { min: 6, max: 20, message: '密码长度在6到20个字符', trigger: 'blur' }
];

// 表单验证
const validate = async () => {
  if (!formRef.value) return false;
  
  console.log('验证前的表单数据:', props.model);
  
  // 先检查工号
  await checkEmployeeId();
  if (employeeIdExists.value) return false;
  
  // 再验证表单
  const result = await formRef.value.validate();
  console.log('表单验证结果:', result);
  return result;
};

// 重置表单
const resetForm = () => {
  if (formRef.value) {
    formRef.value.resetFields();
    employeeIdExists.value = false;
  }
};

// 暴露方法
defineExpose({
  validate,
  resetForm
});
</script>

<style scoped>
.teacher-form {
  padding: 10px 0;
}

/* 调整表单项间距 */
:deep(.el-form-item) {
  margin-bottom: 20px;
}
</style>
