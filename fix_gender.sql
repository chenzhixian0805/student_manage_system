-- 修复学生性别错误
-- 基于姓名的性别特征进行修复
-- 常见女性名字特征列表
UPDATE sys_student 
SET gender = CASE 
    -- 女性名字常见特征
    WHEN name LIKE '%婷%' OR name LIKE '%娜%' OR name LIKE '%丽%' OR name LIKE '%芳%' OR name LIKE '%静%' 
    OR name LIKE '%敏%' OR name LIKE '%秀%' OR name LIKE '%玲%' OR name LIKE '%燕%' OR name LIKE '%艳%' 
    OR name LIKE '%娟%' OR name LIKE '%莉%' OR name LIKE '%萍%' OR name LIKE '%红%' OR name LIKE '%霞%' 
    OR name LIKE '%美%' OR name LIKE '%娇%' OR name LIKE '%倩%' OR name LIKE '%梅%' OR name LIKE '%华%' 
    OR name LIKE '%兰%' OR name LIKE '%菊%' OR name LIKE '%蓉%' OR name LIKE '%蓓%' OR name LIKE '%丹%' 
    OR name LIKE '%芬%' OR name LIKE '%萌%' OR name LIKE '%怡%' OR name LIKE '%媛%' OR name LIKE '%琪%' 
    OR name LIKE '%瑶%' OR name LIKE '%洁%' OR name LIKE '%颖%' OR name LIKE '%钰%' OR name LIKE '%萱%' 
    OR name LIKE '%菲%' OR name LIKE '%雅%' OR name LIKE '%诗%' OR name LIKE '%涵%' OR name LIKE '%蕊%' 
    OR name LIKE '%欣%' OR name LIKE '%彤%' OR name LIKE '%佳%' OR name LIKE '%雨%' OR name LIKE '%雪%' 
    OR name LIKE '%霜%' OR name LIKE '%露%' OR name LIKE '%梓%' OR name LIKE '%梦%' OR name LIKE '%依%' 
    OR name LIKE '%思%' OR name LIKE '%语%' OR name LIKE '%悦%' OR name LIKE '%乐%' OR name LIKE '%薇%' 
    OR name LIKE '%瑾%' OR name LIKE '%璇%' OR name LIKE '%琳%' OR name LIKE '%黛%' OR name LIKE '%菡%' 
    -- 男性名字常见特征
    ELSE '男' 
END;

-- 验证修复结果
SELECT gender, COUNT(*) as count FROM sys_student GROUP BY gender;