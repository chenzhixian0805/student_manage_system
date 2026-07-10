-- 添加性别字段到sys_user表
ALTER TABLE sys_user ADD gender VARCHAR(10);

-- 为老师设置合理的性别
-- 基于姓名的性别特征进行修复
UPDATE sys_user 
SET gender = CASE 
    -- 女性名字常见特征
    WHEN name LIKE '%婷%' OR name LIKE '%娜%' OR name LIKE '%丽%' OR name LIKE '%芳%' OR name LIKE '%静%' 
    OR name LIKE '%敏%' OR name LIKE '%秀%' OR name LIKE '%玲%' OR name LIKE '%燕%' OR name LIKE '%艳%' 
    OR name LIKE '%娟%' OR name LIKE '%莉%' OR name LIKE '%萍%' OR name LIKE '%红%' OR name LIKE '%霞%' 
    OR name LIKE '%美%' OR name LIKE '%娇%' OR name LIKE '%倩%' OR name LIKE '%梅%' OR name LIKE '%华%' 
    OR name LIKE '%雪%' OR name LIKE '%丹%' OR name LIKE '%瑶%' OR name LIKE '%怡%' OR name LIKE '%欣%' 
    -- 男性名字常见特征
    WHEN name LIKE '%军%' OR name LIKE '%涛%' OR name LIKE '%明%' OR name LIKE '%强%' OR name LIKE '%刚%' 
    OR name LIKE '%磊%' OR name LIKE '%洋%' OR name LIKE '%辉%' OR name LIKE '%超%' OR name LIKE '%鹏%' 
    OR name LIKE '%杰%' OR name LIKE '%宇%' OR name LIKE '%浩%' OR name LIKE '%博%' OR name LIKE '%豪%' 
    OR name LIKE '%龙%' OR name LIKE '%伟%' OR name LIKE '%健%' OR name LIKE '%成%' OR name LIKE '%松%' 
    OR name LIKE '%峰%' OR name LIKE '%阳%' OR name LIKE '%飞%' OR name LIKE '%文%' OR name LIKE '%勇%' 
    OR name LIKE '%瑞%' OR name LIKE '%亮%' OR name LIKE '%涛%' OR name LIKE '%斌%' OR name LIKE '%凯%' 
    -- 默认男性
    ELSE '男' 
END 
WHERE role LIKE '%TEACHER%' OR role = 'ROLE_TEACHER';