-- Drops all user defined objects in a SQLServer database 
-- You may need to run this a couple of times if functions/sps reference other objects of the same type.
-- Copied from https://stackoverflow.com/a/8150428/716689, which is adapted from https://web.archive.org/web/20120308203046/http://blog.falafel.com/Blogs/AdamAnderson/09-01-06/T-SQL_Drop_All_Objects_in_a_SQL_Server_Database.aspx by Adam Anderson

declare @n char(1)
set @n = char(10)

declare @stmt nvarchar(max)

-- procedures
select @stmt = isnull( @stmt + @n, '' ) +
    'drop procedure [' + schema_name(schema_id) + '].[' + name + ']'
from sys.procedures
where schema_name(schema_id) != 'sys'

-- check constraints
select @stmt = isnull( @stmt + @n, '' ) +
'alter table [' + schema_name(schema_id) + '].[' + object_name( parent_object_id ) + ']    drop constraint [' + name + ']'
from sys.check_constraints
where schema_name(schema_id) != 'sys'

-- functions
select @stmt = isnull( @stmt + @n, '' ) +
    'drop function [' + schema_name(schema_id) + '].[' + name + ']'
from sys.objects
where type in ( 'FN', 'IF', 'TF' )
and schema_name(schema_id) != 'sys'

-- views
select @stmt = isnull( @stmt + @n, '' ) +
    'drop view [' + schema_name(schema_id) + '].[' + name + ']'
from sys.views
where schema_name(schema_id) != 'sys'

-- foreign keys
select @stmt = isnull( @stmt + @n, '' ) +
    'alter table [' + schema_name(schema_id) + '].[' + object_name( parent_object_id ) + '] drop constraint [' + name + ']'
from sys.foreign_keys
where schema_name(schema_id) != 'sys'

-- tables
select @stmt = isnull( @stmt + @n, '' ) +
    'drop table [' + schema_name(schema_id) + '].[' + name + ']'
from sys.tables
where schema_name(schema_id) != 'sys'

-- user defined types
select @stmt = isnull( @stmt + @n, '' ) +
    'drop type [' + schema_name(schema_id) + '].[' + name + ']'
from sys.types
where is_user_defined = 1
and schema_name(schema_id) != 'sys'

exec sp_executesql @stmt