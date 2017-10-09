select tables.table_schema, tables.table_name, cols.column_name, cols.data_type from information_schema.tables tables
join information_schema.columns cols on tables.table_name = cols.table_name
where tables.table_schema = 'public'
order by tables.table_name