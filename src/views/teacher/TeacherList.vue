<template>
  <div class="teacher-list">
    <el-card shadow="hover">
      <template #header>
        <div class="card-header">
          <h2>教师管理</h2>
          <el-button type="primary" @click="handleAddTeacher" v-if="userRole === 'ROLE_ADMIN'">
            <el-icon><Plus /></el-icon>
            新增教师
          </el-button>
        </div>
      </template>

      <!-- 教师列表 -->
      <el-table :data="teachers" style="width: 100%" border>
        <el-table-column prop="id" label="ID" width="80" />
        <el-table-column prop="employeeId" label="工号" width="120" />
        <el-table-column prop="username" label="用户名" width="120" />
        <el-table-column prop="name" label="姓名" width="120" />
        <el-table-column prop="email" label="邮箱" width="200" />
        <el-table-column prop="phone" label="电话" width="150" />
        <el-table-column prop="status" label="状态" width="100">
          <template #default="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createdAt" label="创建时间" width="200" />
        <el-table-column label="操作" width="200">
          <template #default="scope">
            <el-button type="primary" size="small" @click="handleEditTeacher(scope.row)">
              <el-icon><Edit /></el-icon>
              编辑
            </el-button>
            <el-button type="danger" size="small" @click="handleDeleteTeacher(scope.row.id)" v-if="userRole === 'ROLE_ADMIN'">
              <el-icon><Delete /></el-icon>
              删除
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination" v-if="teachers.length > 0">
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next, jumper"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </el-card>

    <!-- 教师表单对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="500px"
    >
      <TeacherForm
        ref="teacherFormRef"
        :model="formData"
        :is-edit="isEdit"
      />
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">确定</el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { Plus, Edit, Delete } from '@element-plus/icons-vue';
import TeacherForm from './TeacherForm.vue';
import { getAllTeachers, createTeacher, updateTeacher, deleteTeacher } from '../../api/teacherApi';
import { Teacher } from '../../api/teacherApi';
import { ElMessage, ElMessageBox } from 'element-plus';
import { useUserStore } from '../../store/user';

// 组件引用
const teacherFormRef = ref();

// 获取用户角色
const userStore = useUserStore();
const userRole = computed(() => userStore.getUserRole);

// 教师列表数据
const teachers = ref<Teacher[]>([]);
const total = ref(0);
const currentPage = ref(1);
const pageSize = ref(10);

// 对话框状态
const dialogVisible = ref(false);
const isEdit = ref(false);
const dialogTitle = ref('');

// 表单数据
const formData = ref<Teacher>({
  id: 0,
  username: '',
  password: '',
  name: '',
  role: 'ROLE_TEACHER',
  status: 1,
  employeeId: '',
  email: '',
  phone: '',
  createdAt: '',
  updatedAt: ''
});

// 获取教师列表
const fetchTeachers = async () => {
  try {
    const teacherData = await getAllTeachers();
    teachers.value = teacherData;
    total.value = teacherData.length;
  } catch (error) {
    ElMessage.error('获取教师列表失败');
  }
};

// 新增教师
const handleAddTeacher = () => {
  isEdit.value = false;
  dialogTitle.value = '新增教师';
  formData.value = {
    id: 0,
    username: '',
    password: '',
    name: '',
    role: 'ROLE_TEACHER',
    status: 1,
    employeeId: '',
    email: '',
    phone: '',
    createdAt: '',
    updatedAt: ''
  };
  dialogVisible.value = true;
};

// 编辑教师
const handleEditTeacher = (teacher: Teacher) => {
  isEdit.value = true;
  dialogTitle.value = '编辑教师';
  formData.value = { ...teacher };
  dialogVisible.value = true;
};

// 删除教师
const handleDeleteTeacher = (id: number) => {
  ElMessageBox.confirm('确定要删除该教师吗？', '删除确认', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
      try {
        await deleteTeacher(id);
        ElMessage.success('删除成功');
        fetchTeachers();
      } catch (error) {
        ElMessage.error('删除教师失败');
      }
    }).catch(() => {
    // 取消删除
  });
};

// 提交表单
const handleSubmit = async () => {
  if (!teacherFormRef.value) return;
  
  const valid = await teacherFormRef.value.validate();
  if (!valid) return;
  
  try {
    console.log('提交的教师数据:', formData.value);
    if (isEdit.value) {
      await updateTeacher(formData.value.id, formData.value);
      ElMessage.success('更新教师成功');
    } else {
      const response = await createTeacher(formData.value);
      console.log('创建教师的响应:', response);
      ElMessage.success('创建教师成功');
    }
    dialogVisible.value = false;
    fetchTeachers();
  } catch (error) {
    console.error('保存教师失败:', error);
    ElMessage.error('保存教师失败');
  }
};

// 分页处理
const handleSizeChange = (size: number) => {
  pageSize.value = size;
  currentPage.value = 1;
};

const handleCurrentChange = (page: number) => {
  currentPage.value = page;
};

// 初始化
onMounted(() => {
  fetchTeachers();
});
</script>

<style scoped>
.teacher-list {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
}
</style>
