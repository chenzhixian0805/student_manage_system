// 测试Logger工具的脚本
const fs = require('fs');
const path = require('path');

// 模拟浏览器环境的localStorage
class LocalStorage {
  constructor() {
    this.store = {};
  }

  getItem(key) {
    return this.store[key] || null;
  }

  setItem(key, value) {
    this.store[key] = value;
  }

  removeItem(key) {
    delete this.store[key];
  }
}

// 设置全局localStorage
global.localStorage = new LocalStorage();

// 读取并执行Logger的JavaScript版本（简单转换）
const loggerPath = path.join(__dirname, 'src', 'utils', 'logger.ts');
const loggerContent = fs.readFileSync(loggerPath, 'utf8');

// 简单转换TypeScript到JavaScript以便在Node.js中执行
const jsContent = loggerContent
  .replace(/export enum/g, 'const')
  .replace(/= '.*',/g, ': ".*",')
  .replace(/= '.*'/g, ': ".*"')
  .replace(/export interface/g, '// interface')
  .replace(/export class/g, 'class')
  .replace(/private static/g, 'static')
  .replace(/public static/g, 'static')
  .replace(/type:/g, '')
  .replace(/?:/g, ':')
  .replace(/LogLevel\.|LogType\./g, '')
  .replace(/export default new Logger\(\);/g, '');

// 执行转换后的代码
try {
  eval(jsContent);
  
  // 测试Logger功能
  console.log('=== 测试Logger功能 ===');
  
  // 创建一些测试日志
  Logger.info('OPERATION', 'TEST_ACTION', '测试日志1');
  Logger.error('ERROR', 'TEST_ERROR', '测试错误日志');
  Logger.access('LOGIN', '用户测试登录');
  
  // 获取日志
  const logs = Logger.getAllLogs();
  console.log('创建的日志数量:', logs.length);
  console.log('日志内容:', JSON.stringify(logs, null, 2));
  
  // 测试localStorage存储
  const storedLogs = localStorage.getItem('system_logs');
  console.log('localStorage中的日志:', storedLogs ? JSON.parse(storedLogs).length : 0);
  
  // 测试过滤功能
  const infoLogs = Logger.getLogs({ level: 'INFO' });
  console.log('INFO级别的日志数量:', infoLogs.length);
  
  console.log('=== 测试完成 ===');
} catch (error) {
  console.error('测试过程中发生错误:', error.message);
  console.error('错误堆栈:', error.stack);
  // 输出转换后的代码以便调试
  console.log('转换后的代码:', jsContent);
}
