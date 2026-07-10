import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css' // Element Plus 样式
import router from './router'
import './style.css' // 全局样式
import App from './App.vue'
import { Logger } from './utils/logger'



const app = createApp(App)
const pinia = createPinia()

app.use(pinia)
app.use(ElementPlus)
app.use(router)

app.mount('#app')