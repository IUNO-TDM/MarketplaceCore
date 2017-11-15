--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--Author: Marcel Ely Gomes
--CreateAt: 2017-11-07
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
-- The Reporting routes were not REST like and some functions were double. There were some bugs on the revenue calculation as well.
-- 	2) Which Git Issue Number is this patch solving? 
--	Due to the number of changes, the patches are going to be splittet. This is the first of 5 patches.
--	#103, #47, #119, #117, #50
-- 	3) Which changes are going to be done? 
--	Delete old functions that are no needed anymore
--	Set Permission for new functions
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0007V_20171107';
		PatchNumber int 		 	 := 0007;
		PatchDescription varchar 	 := 'Delete old functions and set permission for the new ones. This is the first of 2 patches';
		CurrentPatch int 			 := (select max(p.patchnumber) from patches p);

	BEGIN	
		--INSERT START VALUES TO THE PATCH TABLE
		IF (PatchNumber <= CurrentPatch) THEN
			RAISE EXCEPTION '%', 'Wrong patch number. Please verify your patches!';
		ELSE
			INSERT INTO PATCHES (patchname, patchnumber, patchdescription, startat) VALUES (PatchName, PatchNumber, PatchDescription, now());		
		END IF;	
	END;
$$;
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Run the patch itself and update patches table
--##############################################################################################
DO
$$
		DECLARE
			vPatchNumber int := 0007;
			vFunctionList text[] := '{GetActivatedLicensesSince,
					GetActivatedLicensesSinceForUser,
					GetMostUsedComponents,
					GetMostUsedComponentsForUser,
					GetRevenueForUser,
					GetReveneuPerDayForUser,
					GetRevenuePerDaySince,
					GetRevenuePerHourSince,
					GetTopTechnologyDataForUser,
					GetTopTechnologyDataSince,
					GetTopTechnologyDataSinceForUser,
					GetTotalRevenueForUser,
					GetWorkLoadSince,
					GetWorkloadSince,
					GetWorkLoadSinceForUser
					}';
			vFunctionName text;
			vFunctionID integer;
			vDropFunction text;
			vFunctionOID integer;
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------

--DELETE Permisions AND DROP OLD FUNCTIONS
	 
		FOREACH vFunctionName in array vFunctionList LOOP
			vFunctionID := (select functionid from functions where functionname = vFunctionName);
			delete from rolespermissions where functionid = vFunctionID;
			delete from functions where functionid = vFunctionID;
			vFunctionOID := (select oid from pg_proc where lower(proname) = lower(vFunctionName) );
			vDropFunction := (select 'DROP FUNCTION ' || vFunctionName || '(' ||(select pg_get_function_arguments(vFunctionOID))::text || ')'); 
			IF NOT (vDropFunction is null) THEN execute vDropFunction; END IF;
		END LOOP;
	


--SetPermissions for new Functions

		perform SetPermission('{Public, TechnologyDataOwner}','GetRevenue',null,'{Admin}');
		perform SetPermission('{Public}','GetTotalRevenue',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','GetTotalUserRevenue',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','GetRevenueHistory',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner, Public}','GetTopTechnologyData',null,'{Admin}');
		perform SetPermission('{Public}','GetTopComponents',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','GetTechnologyDataHistory',null,'{Admin}'); 
	
	 
	----------------------------------------------------------------------------------------------------------------------------------------
		-- UPDATE patch table status value
		UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
		--ERROR HANDLING
		EXCEPTION WHEN OTHERS THEN
			UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;	 
		 RETURN;
	END;
$$; 