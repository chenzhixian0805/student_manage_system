// 日志记录工具类

// 日志级别
export enum LogLevel {
  DEBUG = 'DEBUG',
  INFO = 'INFO',
  WARN = 'WARN',
  ERROR = 'ERROR'
}

// 日志类型
export enum LogType {
  SYSTEM = 'SYSTEM',
  OPERATION = 'OPERATION',
  ERROR = 'ERROR',
  ACCESS = 'ACCESS'
}

// 日志接口
export interface Log {
  id: string
  timestamp: string
  level: LogLevel
  type: LogType
  user: string
  ip: string
  action: string
  message: string
  details?: any
}

// 日志记录工具类
export class Logger {
  private static logs: Log[] = []
  
  // 生成唯一ID
  private static generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2)
  }
  
  // 获取客户端IP（模拟）
  private static getClientIP(): string {
    // 实际项目中应该从请求头或其他方式获取真实IP
    return '127.0.0.1'
  }
  
  // 获取当前用户
  private static getCurrentUser(): string {
    const userInfo = localStorage.getItem('userInfo')
    if (userInfo) {
      return JSON.parse(userInfo).username
    }
    return 'anonymous'
  }
  
  // 记录日志
  private static log(
    level: LogLevel,
    type: LogType,
    action: string,
    message: string,
    details?: any
  ): void {
    const log: Log = {
      id: this.generateId(),
      timestamp: new Date().toISOString(),
      level,
      type,
      user: this.getCurrentUser(),
      ip: this.getClientIP(),
      action,
      message,
      details
    }
    
    // 保存到内存中
    this.logs.push(log)
    
    // 限制日志数量，最多保存1000条
    if (this.logs.length > 1000) {
      this.logs.shift()
    }
    
    // 打印到控制台
    this.printToConsole(log)
    
    // 这里可以添加日志持久化逻辑，如发送到服务器或保存到本地存储
    this.persistLog(log)
  }
  
  // 打印到控制台
  private static printToConsole(log: Log): void {
    const { level, type, timestamp, user, action, message, details } = log
    const logMessage = `[${timestamp}] [${level}] [${type}] [${user}] ${action}: ${message}`
    
    switch (level) {
      case LogLevel.DEBUG:
        console.debug(logMessage, details)
        break
      case LogLevel.INFO:
        console.info(logMessage, details)
        break
      case LogLevel.WARN:
        console.warn(logMessage, details)
        break
      case LogLevel.ERROR:
        console.error(logMessage, details)
        break
    }
  }
  
  // 持久化日志（模拟）
  private static persistLog(log: Log): void {
    // 实际项目中应该将日志发送到服务器保存
    // 这里我们简单地保存到localStorage
    try {
      const existingLogs = localStorage.getItem('system_logs')
      let logs: Log[] = []
      
      if (existingLogs) {
        const parsed = JSON.parse(existingLogs)
        // 确保 logs 是数组
        if (Array.isArray(parsed)) {
          logs = parsed
        }
      }
      
      logs.push(log)
      
      // 限制本地存储的日志数量
      if (logs.length > 1000) {
        logs = logs.slice(-1000)
      }
      
      localStorage.setItem('system_logs', JSON.stringify(logs))
    } catch (error) {
      console.error('Failed to persist log:', error)
    }
  }
  
  // 获取所有日志
  public static getAllLogs(): Log[] {
    // 如果内存中没有日志，尝试从localStorage获取
    if (this.logs.length === 0) {
      try {
        const existingLogs = localStorage.getItem('system_logs')
        if (existingLogs) {
          const parsed = JSON.parse(existingLogs)
          if (Array.isArray(parsed)) {
            // 将localStorage中的日志加载到内存中
            this.logs = parsed
          }
        }
      } catch (error) {
        console.error('Failed to load logs from localStorage:', error)
      }
    }
    return [...this.logs]
  }
  
  // 根据条件过滤日志
  public static getLogs(filter?: {
    level?: LogLevel
    type?: LogType
    user?: string
    startDate?: string
    endDate?: string
  }): Log[] {
    // 确保内存中加载了最新的日志
    this.getAllLogs()
    
    let filteredLogs = [...this.logs]
    
    if (filter) {
      if (filter.level) {
        filteredLogs = filteredLogs.filter(log => log.level === filter.level)
      }
      
      if (filter.type) {
        filteredLogs = filteredLogs.filter(log => log.type === filter.type)
      }
      
      if (filter.user) {
        const user = filter.user
        filteredLogs = filteredLogs.filter(log => log.user.includes(user))
      }
      
      if (filter.startDate) {
        const startDate = new Date(filter.startDate)
        filteredLogs = filteredLogs.filter(log => new Date(log.timestamp) >= startDate)
      }
      
      if (filter.endDate) {
        const endDate = new Date(filter.endDate)
        endDate.setHours(23, 59, 59, 999)
        filteredLogs = filteredLogs.filter(log => new Date(log.timestamp) <= endDate)
      }
    }
    
    return filteredLogs
  }
  
  // 清空日志
  public static clearLogs(): void {
    this.logs = []
    localStorage.removeItem('system_logs')
  }
  
  // 记录调试日志
  public static debug(type: LogType, action: string, message: string, details?: any): void {
    this.log(LogLevel.DEBUG, type, action, message, details)
  }
  
  // 记录信息日志
  public static info(type: LogType, action: string, message: string, details?: any): void {
    this.log(LogLevel.INFO, type, action, message, details)
  }
  
  // 记录警告日志
  public static warn(type: LogType, action: string, message: string, details?: any): void {
    this.log(LogLevel.WARN, type, action, message, details)
  }
  
  // 记录错误日志
  public static error(type: LogType, action: string, message: string, details?: any): void {
    this.log(LogLevel.ERROR, type, action, message, details)
  }
  
  // 记录操作日志
  public static operation(action: string, message: string, details?: any): void {
    this.log(LogLevel.INFO, LogType.OPERATION, action, message, details)
  }
  
  // 记录系统日志
  public static system(action: string, message: string, details?: any): void {
    this.log(LogLevel.INFO, LogType.SYSTEM, action, message, details)
  }
  
  // 记录错误日志
  public static errorLog(action: string, message: string, error: any): void {
    this.log(LogLevel.ERROR, LogType.ERROR, action, message, {
      error: {
        name: error.name,
        message: error.message,
        stack: error.stack
      }
    })
  }
  
  // 记录访问日志
  public static access(action: string, message: string, details?: any): void {
    this.log(LogLevel.INFO, LogType.ACCESS, action, message, details)
  }
}

// 导出默认实例
export default new Logger()
