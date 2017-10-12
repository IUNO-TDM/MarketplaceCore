--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2017-09-13
--Version: 00.00.01 (Initial)
--#######################################################################################################
-- READ THE INSTRUCTIONS BEFORE CONTINUE - USE ONLY PatchDBTool to deploy patches to existing Databases
-- Describe your patch here
-- Patch Description: 
-- 	1) Why is this Patch necessary?
-- 	2) Which Git Issue Number is this patch solving?
-- 	3) Which changes are going to be done?
-- PATCH FILE NAME - THIS IS MANDATORY
-- iuno_<databasename>_V<patchnumber>V_<creation date>.sql
-- PatchNumber Format: 00000 whereas each new Patch increase the patchnumber by 1
-- Example: iuno_marketplacecore_V00001V_20170913.sql
--#######################################################################################################
-- PUT YOUR STATEMENTS HERE:
-- 	1) Why is this Patch necessary?
--	This patche prepares the database so that other patches might be tracked
-- 	2) Which Git Issue Number is this patch solving?
--	#54
-- 	3) Which changes are going to be done?
--	Create the patches table
--: Run Patches
DO
$$
BEGIN
		--Create Patches Table
		CREATE TABLE patches(
			patchname varchar,
			patchnumber integer, 
			patchdescription varchar,
			startat timestamp without time zone,
			endat timestamp without time zone,
			status varchar
			);

		INSERT INTO patches (
				patchname,
				patchnumber,   
				patchdescription,
				startat,
				endat,
				status)
		VALUES ('initial', 0, 'First patch at all. Create patches table.', now(), now(), 'OK');
	--ERROR HANDLING AND ROLLBACK
	EXCEPTION WHEN OTHERS THEN
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at Initial Patch';
		ROLLBACK;	
END;
$$;
