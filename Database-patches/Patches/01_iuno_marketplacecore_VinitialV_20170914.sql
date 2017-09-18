/*########################################################################################
Company: TRUMPF Werkzeugmaschinen GmbH & Co KG
Project: IUNO
Author: Marcel Ely Gomes
CreatedAt: 2017-09-14
Description: Initial PATCH File for MarketplaceCore Database
	     Create Patches Table
#########################################################################################*/
DO
$$
BEGIN
		--Create Patches Table
		CREATE TABLE patches(
			patchid integer,
			patchname varchar,
			patchnumber integer, 
			description varchar, 
			createdat timestamp without time zone, 
			executedat timestamp without time zone);

		INSERT INTO patches (patchid,
				patchname,
				patchnumber, 
				description, 
				createdat, 
				executedat)
		VALUES (1, 'initial', 0, 'Initial patch - Create patches table and insert this line', now(), now());
	--ERROR HANDLING AND ROLLBACK
	EXCEPTION WHEN OTHERS THEN
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTechnologyData';
		ROLLBACK;	
END;
$$;
