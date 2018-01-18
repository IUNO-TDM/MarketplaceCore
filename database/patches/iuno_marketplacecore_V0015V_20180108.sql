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
--  By now it is possible that an user delete technologydata from other users.
-- 	2) Which Git Issue Number is this patch solving?
--  #127
-- 	3) Which changes are going to be done? 
--	Update DeleteTechnologyData - It has to be proof if the user is allowed to do it.
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 := 'iuno_marketplacecore_V0015V_20180108';
		PatchNumber int 		 := 0015;
		PatchDescription varchar 	 := 'HotFix for DeleteTechnologyData - It has to be proof if the user is allowed to do it.';
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
			vPatchNumber int := 0015;
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------

			CREATE OR REPLACE FUNCTION public.deletetechnologydata(
				vtechnologydatauuid uuid,
				vuseruuid uuid,
				vroles text[])
			  RETURNS boolean AS
			$BODY$

				DECLARE
					vFunctionName varchar := 'DeleteTechnologyData';
					vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
					vOwnerUUID uuid := (select createdby from technologydata where technologydatauuid = vTechnologyDataUUID);

				BEGIN

				IF(vIsAllowed) THEN

					IF (vUserUUID = vOwnerUUID) THEN

					 update technologydata set deleted = true
					 where technologydatauuid = vTechnologyDataUUID
					 and createdby = vuseruuid;

					 ELSE

						 RAISE EXCEPTION '%', 'You are not allowed to delete this technologydata.';
						 RETURN false;

					 END IF;

				ELSE
					 RAISE EXCEPTION '%', 'Insufficiency rigths';
					 RETURN false;
				END IF;

				-- Begin Log if success
					perform public.createlog(0,'Delete TechnologyData successfull', 'DeleteTechnologyData',
											'TechnologyDataID: ' || cast(vtechnologydatauuid as varchar));

					-- End Log if success
					RETURN true;
				 -- Begin Log if error
					perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'DeleteTechnologyData',
											'TechnologyDataID: ' || cast(vtechnologydatauuid as varchar));
					-- End Log if error
					RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTechnologyDataComponents';
				RETURN false;

				END;
					$BODY$
			  LANGUAGE plpgsql;
		 

	----------------------------------------------------------------------------------------------------------------------------------------

		-- UPDATE patch table status value
		UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
		--ERROR HANDLING
		EXCEPTION WHEN OTHERS THEN
			UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;	 
		 RETURN;
	END;
$$; 