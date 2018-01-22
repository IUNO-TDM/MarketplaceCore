--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-01-22
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
--  At the moment there are function which have to many permissions. This patch correct it.
-- 	2) Which Git Issue Number is this patch solving?
--  #111
-- 	3) Which changes are going to be done?
--  Delete role permissions for diverse functions
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0020V_20180122';
		PatchNumber int 		 	 := 0020;
		PatchDescription varchar 	 := 'Fixes #111: Drop unused or unnecessary functions';
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
			vPatchNumber int := 0020;
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------

                DROP FUNCTION public.gettechnologydataownerbyid(uuid, uuid, text[]);

                DROP FUNCTION public.getofferforpaymentinvoice(uuid, uuid, text[]);

                DROP FUNCTION public.getofferbyrequestid(uuid, uuid, text[]);

        ----------------------------------------------------------------------------------------------------------------------------------------
        -- UPDATE patch table status value
        UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
        --ERROR HANDLING
        EXCEPTION WHEN OTHERS THEN
            UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
         RETURN;
    END;
$$;