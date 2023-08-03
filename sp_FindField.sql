/*  Fernando Da Silva, Oct.06, 2022
    Find objects with respective names and types in a Database
    MS-SQL Server

    Sample:
    exec sp_FindField 'User'
*/
create procedure sp_FindField 
@Name varchar(max)  
 
as 
SET NOCOUNT ON; 

declare @Result as Table (
  Name varchar(max)
 ,ObjectName varchar(max)
 ,ObjectType varchar(max)
)   
 
insert into @Result 
SELECT      c.name  AS 'ColumnName' 
            ,t.name AS 'TableName' 
            ,'Table' AS 'ObjectType'
FROM        sys.columns c 
JOIN        sys.tables  t 
  ON c.object_id = t.object_id 
WHERE       c.name LIKE '%'+@Name +'%' 
ORDER BY    TableName 
            ,ColumnName; 
 
insert into @Result 
SELECT      COLUMN_NAME AS 'ColumnName' 
            ,TABLE_NAME AS  'TableName' 
            ,'Column' AS 'ObjectType'
FROM        INFORMATION_SCHEMA.COLUMNS 
WHERE       COLUMN_NAME LIKE '%'+@Name +'%' 
ORDER BY    TableName 
            ,ColumnName; 

insert into @Result 
SELECT DISTINCT 
       o.name AS Object_Name, 
       o.type_desc as 'Object',
       o.type_desc AS 'ObjectType'
FROM   sys.sql_modules m 
  INNER JOIN sys.objects o 
    ON m.object_id = o.object_id 
WHERE m.definition Like '%'+@Name +'%' 
 
select distinct  Name, ObjectName, ObjectType from @Result	
order by ObjectType, ObjectName, Name 
