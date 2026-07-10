import os
import re

# 实体类目录
target_dir = r"d:\student_manage_system\backend\src\main\java\com\example\studentmanagement\entity"

# 处理每个实体类文件
for filename in os.listdir(target_dir):
    if filename.endswith('.java'):
        file_path = os.path.join(target_dir, filename)
        print(f"正在处理文件: {file_path}")
        
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # 跳过ResponseResult.java（非实体类）
        if filename == "ResponseResult.java":
            print(f"  跳过: 非实体类")
            continue
        
        # 提取类名
        class_start = content.find("public class ")
        if class_start == -1:
            print(f"  跳过: 未找到类定义")
            continue
        
        # 提取字段，支持带有默认值的字段定义
        field_pattern = re.compile(r'\s*private\s+(\w+)\s+(\w+)\s*(?:=\s*[^;]+)?\s*;')
        fields = field_pattern.findall(content)
        if not fields:
            print(f"  跳过: 未找到字段定义")
            continue
        
        # 修复字段名的大小写，生成正确的驼峰命名法getter和setter方法名
        def fix_field_name(field_name):
            # 处理像courseId这样的驼峰命名，生成getCourseId()而不是getCourseid()
            parts = []
            current_part = ""
            for char in field_name:
                if char.isupper():
                    if current_part:
                        parts.append(current_part)
                        current_part = char
                    else:
                        current_part = char
                else:
                    current_part += char
            if current_part:
                parts.append(current_part)
            
            # 首字母大写，其余部分保持原样
            result = ""
            for i, part in enumerate(parts):
                if i == 0:
                    result += part.capitalize()
                else:
                    result += part
            return result
        
        # 生成getter和setter方法
        getters_setters = "\n"
        for field_type, field_name in fields:
            # 生成正确的方法名
            method_name = fix_field_name(field_name)
            
            # 生成getter方法
            getters_setters += "    public " + field_type + " get" + method_name + "() {\n"
            getters_setters += "        return this." + field_name + ";\n"
            getters_setters += "    }\n\n"
            
            # 生成setter方法
            getters_setters += "    public void set" + method_name + "(" + field_type + " " + field_name + ") {\n"
            getters_setters += "        this." + field_name + " = " + field_name + ";\n"
            getters_setters += "    }\n\n"
        
        # 移除Lombok注解
        new_content = content
        new_content = new_content.replace("@Data\n", "")
        new_content = new_content.replace("@ToString(exclude = {\"teacher\", \"grades\", \"selections\"})\n", "")
        new_content = new_content.replace("@ToString(exclude = {\"courses\"})\n", "")
        new_content = new_content.replace("@ToString\n", "")
        
        # 找到类结束括号
        class_end = new_content.rfind("}")
        if class_end == -1:
            print(f"  跳过: 未找到类结束括号")
            continue
        
        # 在类结束括号前插入getter和setter方法
        new_content = new_content[:class_end] + getters_setters + new_content[class_end:]
        
        # 保存修改后的文件
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"  完成: 生成了 {len(fields)*2} 个方法")

print("\n所有文件处理完成！")