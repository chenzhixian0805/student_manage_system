USE stusys;

-- 更新老师姓名为更真实的名字
UPDATE sys_user SET real_name = '刘建国' WHERE user_name = 'teacher01';
UPDATE sys_user SET real_name = '王秀兰' WHERE user_name = 'teacher02';
UPDATE sys_user SET real_name = '张明远' WHERE user_name = 'teacher03';
UPDATE sys_user SET real_name = '李艳红' WHERE user_name = 'teacher04';
UPDATE sys_user SET real_name = '陈志强' WHERE user_name = 'teacher05';
UPDATE sys_user SET real_name = '赵美玲' WHERE user_name = 'teacher06';
UPDATE sys_user SET real_name = '周浩然' WHERE user_name = 'teacher07';
UPDATE sys_user SET real_name = '吴芳' WHERE user_name = 'teacher08';
UPDATE sys_user SET real_name = '郑文涛' WHERE user_name = 'teacher09';
UPDATE sys_user SET real_name = '孙丽娟' WHERE user_name = 'teacher10';

-- 更新学生姓名为更真实的名字
UPDATE sys_user SET real_name = '陈思宇' WHERE user_name = 'student01';
UPDATE sys_user SET real_name = '林雨涵' WHERE user_name = 'student02';
UPDATE sys_user SET real_name = '王俊杰' WHERE user_name = 'student03';
UPDATE sys_user SET real_name = '张梦琪' WHERE user_name = 'student04';
UPDATE sys_user SET real_name = '刘浩宇' WHERE user_name = 'student05';
UPDATE sys_user SET real_name = '李若曦' WHERE user_name = 'student06';
UPDATE sys_user SET real_name = '陈宇航' WHERE user_name = 'student07';
UPDATE sys_user SET real_name = '王嘉怡' WHERE user_name = 'student08';
UPDATE sys_user SET real_name = '赵晨阳' WHERE user_name = 'student09';
UPDATE sys_user SET real_name = '周雨萌' WHERE user_name = 'student10';
UPDATE sys_user SET real_name = '吴泽宇' WHERE user_name = 'student11';
UPDATE sys_user SET real_name = '郑可欣' WHERE user_name = 'student12';
UPDATE sys_user SET real_name = '孙博文' WHERE user_name = 'student13';
UPDATE sys_user SET real_name = '杨紫涵' WHERE user_name = 'student14';
UPDATE sys_user SET real_name = '陈浩然' WHERE user_name = 'student15';
UPDATE sys_user SET real_name = '王雨欣' WHERE user_name = 'student16';
UPDATE sys_user SET real_name = '刘俊杰' WHERE user_name = 'student17';
UPDATE sys_user SET real_name = '李梦琪' WHERE user_name = 'student18';
UPDATE sys_user SET real_name = '赵宇航' WHERE user_name = 'student19';
UPDATE sys_user SET real_name = '周嘉怡' WHERE user_name = 'student20';
UPDATE sys_user SET real_name = '吴晨阳' WHERE user_name = 'student21';
UPDATE sys_user SET real_name = '郑雨萌' WHERE user_name = 'student22';
UPDATE sys_user SET real_name = '孙泽宇' WHERE user_name = 'student23';
UPDATE sys_user SET real_name = '杨可欣' WHERE user_name = 'student24';
UPDATE sys_user SET real_name = '陈博文' WHERE user_name = 'student25';
UPDATE sys_user SET real_name = '王紫涵' WHERE user_name = 'student26';
UPDATE sys_user SET real_name = '刘浩然' WHERE user_name = 'student27';
UPDATE sys_user SET real_name = '李雨欣' WHERE user_name = 'student28';
UPDATE sys_user SET real_name = '赵俊杰' WHERE user_name = 'student29';
UPDATE sys_user SET real_name = '周梦琪' WHERE user_name = 'student30';
UPDATE sys_user SET real_name = '吴宇航' WHERE user_name = 'student31';
UPDATE sys_user SET real_name = '郑嘉怡' WHERE user_name = 'student32';
UPDATE sys_user SET real_name = '孙晨阳' WHERE user_name = 'student33';
UPDATE sys_user SET real_name = '杨雨萌' WHERE user_name = 'student34';
UPDATE sys_user SET real_name = '陈泽宇' WHERE user_name = 'student35';
UPDATE sys_user SET real_name = '王可欣' WHERE user_name = 'student36';
UPDATE sys_user SET real_name = '刘博文' WHERE user_name = 'student37';
UPDATE sys_user SET real_name = '李紫涵' WHERE user_name = 'student38';
UPDATE sys_user SET real_name = '赵浩然' WHERE user_name = 'student39';
UPDATE sys_user SET real_name = '周雨欣' WHERE user_name = 'student40';
UPDATE sys_user SET real_name = '吴俊杰' WHERE user_name = 'student41';
UPDATE sys_user SET real_name = '郑梦琪' WHERE user_name = 'student42';
UPDATE sys_user SET real_name = '孙宇航' WHERE user_name = 'student43';
UPDATE sys_user SET real_name = '杨嘉怡' WHERE user_name = 'student44';
UPDATE sys_user SET real_name = '陈晨阳' WHERE user_name = 'student45';
UPDATE sys_user SET real_name = '王雨萌' WHERE user_name = 'student46';
UPDATE sys_user SET real_name = '刘泽宇' WHERE user_name = 'student47';
UPDATE sys_user SET real_name = '李可欣' WHERE user_name = 'student48';
UPDATE sys_user SET real_name = '赵博文' WHERE user_name = 'student49';
UPDATE sys_user SET real_name = '周紫涵' WHERE user_name = 'student50';

-- 同时更新sys_student表中的学生姓名
UPDATE sys_student s JOIN sys_user u ON s.user_id = u.id SET s.name = u.real_name;
