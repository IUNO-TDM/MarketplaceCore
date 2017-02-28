@echo off
REM 001 Create database
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -p 5432 -U postgres -d postgres -f "C:\\01_Projekte\\07_IUNO\\Source\\MarketplaceCore\\SqlScripts\\CreateDatabase.sql"
ping -n 4 127.0.0.1 >nul
REM 002 connect to database and create tables
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -p 5432 -U postgres -d marketplacecore -f "C:\\01_Projekte\\07_IUNO\\Source\\MarketplaceCore\\SqlScripts\\CreateTables.sql"
ping -n 4 127.0.0.1 >nul
REM 003 connect to database and create components - funtions etc.
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -p 5432 -U postgres -d marketplacecore -f "C:\\01_Projekte\\07_IUNO\\Source\\MarketplaceCore\\SqlScripts\\DatabaseComponents.sql"
ping -n 4 127.0.0.1 >nul
REM 003 connect to database and create some testdata
"C:\Program Files\PostgreSQL\9.6\bin\psql.exe" -h localhost -p 5432 -U postgres -d marketplacecore -f "C:\\01_Projekte\\07_IUNO\\Source\\MarketplaceCore\\SqlScripts\\BaseData.sql"


