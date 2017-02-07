-- ------------------------------------------------------------------------------------------
-- Created by: Marcel Ely Gomes
-- Create date: 2017-02-02
-- Company: TRUMPF Werkzeugmaschinen GmbH & CO KG
-- Description: Create Insert Function dynamically based on the existing tables
-- Schema name is obligatory, otherwiese its create the function for all databases.
-- ------------------------------------------------------------------------------------------
with constSchema as (
     select 'public'::varchar as schema_name  
),
tableName as (
     select 'company'::varchar as table_name
),
tableColumnsWithType as (
        select  string_agg(cols.column_name || ' ' || cols.data_type, ',') as columns from information_schema.columns cols
        cross join tableName
        cross join constSchema
        where cols.table_schema = constSchema.schema_name and cols.table_name = tableName.table_name
),
tableColumns as (
        select  string_agg(cols.column_name,',') as columns from information_schema.columns cols
        cross join tableName
        cross join constSchema
        where cols.table_schema = constSchema.schema_name and cols.table_name = tableName.table_name
) 
select 'CREATE FUNCTION Create_'|| tables.table_name || '(' || tableColumnsWithType.columns || ') 
     RETURNS void AS
  $BODY$
      BEGIN
      INSERT INTO ' ||tables.table_name||' (' || tableColumns.columns ||')
       VALUES(' || tableColumns.columns ||');
      END;
  $BODY$
  LANGUAGE ''plpgsql'' VOLATILE
  COST 100;' as Function
from information_schema.tables tables 
cross join tableName
cross join tableColumns 
cross join tableColumnsWithType
cross join constSchema
join information_schema.columns cols on tables.table_name = cols.table_name
where tables.table_schema = constSchema.schema_name and tables.table_name = tableName.table_name    
group by tableColumns.columns, tables.table_name,  tableColumnsWithType.columns