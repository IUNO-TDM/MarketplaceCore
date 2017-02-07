-- ------------------------------------------------------------------------------------------
-- Created by: Marcel Ely Gomes
-- Create date: 2017-02-02
-- Company: TRUMPF Werkzeugmaschinen GmbH & CO KG
-- Description: Create Insert Function dynamically based on the existing tables
-- Schema name is obligatory, otherwiese its create the function for all databases.
-- ------------------------------------------------------------------------------------------
DO $$   
DECLARE 
    tableName VARCHAR;
    schemaName text := 'public';
    test text;
    sqlText text := 
'with tableColumnsWithType as (
        select  string_agg(cols.column_name || '' '' || cols.data_type, '','') as columns from information_schema.columns cols        
        where cols.table_schema = $1 and cols.table_name = $2
),
tableColumns as (
        select  string_agg(cols.column_name,'','') as columns from information_schema.columns cols 
        where cols.table_schema = $1 and cols.table_name = $2
) 
select ''CREATE FUNCTION Create_''|| tables.table_name || ''('' || tableColumnsWithType.columns || '') 
     RETURNS void AS
  $BODY$
      BEGIN
      INSERT INTO '' ||$2||'' ('' || tableColumns.columns ||'')
       VALUES('' || tableColumns.columns ||'');
      END;
  $BODY$
  LANGUAGE ''''plpgsql''''; '' as Function
from information_schema.tables tables 
cross join tableColumns 
cross join tableColumnsWithType
join information_schema.columns cols on tables.table_name = cols.table_name
where tables.table_schema = $1 and tables.table_name = $2    
group by tableColumns.columns, tables.table_name,  tableColumnsWithType.columns'; 
    BEGIN 
        FOR tableName in 
        select table_name from information_schema.tables where table_schema = schemaName
        loop 
       		execute sqlText into test
            using schemaName, tableName;
            raise info '%', test; 
        end loop; 
    END $$;
 