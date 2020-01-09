解锁表：--Oracle 查询锁表 以及解锁2009年11月20日 星期五 14:02--查询锁表信息

select c.owner,
       c.object_name,
       c.object_type,
       b.sid,
       b.serial#,
       b.status,
       b.osuser,
       b.machine
  from v$locked_object a, v$session b, dba_objects c
 where b.sid = a.session_id
   and a.object_id = c.object_id;

--然后可以用下面的语句来杀死会话：

alter system kill session '323,23453' immediate;
