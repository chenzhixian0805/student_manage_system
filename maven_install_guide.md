# Maven下载与安装指南

## 1. 下载Maven

访问Maven官方下载页面：
[https://maven.apache.org/download.cgi](https://maven.apache.org/download.cgi)

### 推荐下载版本
- 选择最新的稳定版（目前是Maven 3.9.9）
- 下载二进制压缩包（Binary zip archive）
- 文件名类似：`apache-maven-3.9.9-bin.zip`

### 直接下载链接
如果您无法访问官方网站，可以使用以下直接下载链接：
[https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip](https://dlcdn.apache.org/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip)

## 2. 安装Maven

### 步骤1：解压压缩包
1. 下载完成后，将压缩包解压到一个合适的目录
2. 建议解压到`C:\Program Files\`或`D:\`目录下
3. 解压后的目录结构类似：`C:\Program Files\apache-maven-3.9.9`

### 步骤2：配置环境变量

#### Windows系统
1. 右键点击「此电脑」→「属性」→「高级系统设置」→「环境变量」
2. 在「系统变量」中添加以下变量：
   - **变量名**：`MAVEN_HOME`
   - **变量值**：`C:\Program Files\apache-maven-3.9.9`（根据您的实际解压路径）
3. 在「系统变量」中找到`Path`变量，双击编辑
4. 添加新的路径：`%MAVEN_HOME%\bin`
5. 点击「确定」保存所有设置

## 3. 验证Maven安装

1. 打开命令行终端（Win+R → 输入`cmd` → 回车）
2. 输入以下命令：
   ```bash
   mvn -version
   ```
3. 如果安装成功，您将看到类似以下输出：
   ```
   Apache Maven 3.9.9 (8e86b3d5248cec5c2aed370f00541438c79edac9)
   Maven home: C:\Program Files\apache-maven-3.9.9
   Java version: 21.0.1, vendor: Oracle Corporation, runtime: C:\Program Files\Java\jdk-21
   Default locale: zh_CN, platform encoding: UTF-8
   OS name: "windows 11", version: "10.0", arch: "amd64", family: "windows"
   ```

## 4. 运行Spring Boot项目

1. 打开命令行终端
2. 进入后端项目目录：
   ```bash
   cd d:\student_manage_system\backend
   ```
3. 使用Maven运行项目：
   ```bash
   mvn spring-boot:run
   ```
4. 等待项目启动完成，您将看到类似以下输出：
   ```
   Started StudentManagementApplication in 3.567 seconds (process running for 4.234)
   ```
5. 访问后端API：
   - 学生列表：http://localhost:8080/students
   - Swagger文档：http://localhost:8080/swagger-ui.html

## 5. 前端访问

前端已经通过`npm run dev`启动，您可以访问：
http://localhost:5173

## 6. 常见问题解决

### Q1: 运行`mvn -version`时提示找不到命令
**A1**: 检查环境变量配置是否正确，确保：
- `MAVEN_HOME`指向正确的Maven目录
- `Path`变量中包含`%MAVEN_HOME%\bin`
- 重启命令行终端后重试

### Q2: 运行`mvn spring-boot:run`时提示依赖下载失败
**A2**: 检查网络连接，或配置Maven镜像：
1. 编辑`%MAVEN_HOME%\conf\settings.xml`
2. 在`<mirrors>`标签内添加阿里镜像：
   ```xml
   <mirror>
       <id>alimaven</id>
       <mirrorOf>central</mirrorOf>
       <name>aliyun maven</name>
       <url>https://maven.aliyun.com/repository/central</url>
   </mirror>
   ```

### Q3: 项目启动后无法访问API
**A3**: 检查：
- 端口是否被占用（默认使用8080端口）
- 数据库是否启动并配置正确
- 控制台输出是否有错误信息

## 7. 其他有用的Maven命令

- 清理项目：`mvn clean`
- 编译项目：`mvn compile`
- 打包项目：`mvn package`
- 运行测试：`mvn test`

祝您使用愉快！
