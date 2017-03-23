-- Create LogUser
DO
$$
BEGIN
	IF ((SELECT 1 FROM pg_roles WHERE rolname='dblink_loguser') is null) THEN
	CREATE USER dblink_loguser WITH PASSWORD 'PASSWORD';  -- PUT YOUR PWD HERE
	END IF;
	CREATE FOREIGN DATA WRAPPER postgresql VALIDATOR postgresql_fdw_validator;
	CREATE SERVER fdtest FOREIGN DATA WRAPPER postgresql OPTIONS (hostaddr '127.0.0.1', dbname 'DBNAME'); -- PUT YOUR DATABASENAME HERE
	CREATE USER MAPPING FOR dblink_loguser SERVER fdtest OPTIONS (user 'dblink_loguser', password 'PASSWORD';); -- PUT YOUR PWD HERE
	GRANT USAGE ON FOREIGN SERVER fdtest TO dblink_loguser;
	GRANT INSERT ON TABLE logtable TO dblink_loguser;	
END;
$$; 