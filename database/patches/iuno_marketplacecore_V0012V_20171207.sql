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
-- 	2) Which Git Issue Number is this patch solving? 
--	#135 
-- 	3) Which changes are going to be done? 
--	Set Permission and create new function GetActivatedLicensesCountForUser
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V00012V_20171207';
		PatchNumber int 		 	 := 0012;
		PatchDescription varchar 	 := 'Set Permission and create new function GetActivatedLicensesCountForUser';
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
			vPatchNumber int := 0012;
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------
			perform SetPermission('{TechnologyDataOwner}', 'GetActivatedLicensesCountForUser',null, '{Admin}');
			
			CREATE OR REPLACE FUNCTION public.getactivatedlicensescountforuser(
				vuseruuid uuid,
				vInquereID uuid,
				vroles text[])
			  RETURNS integer AS
			$BODY$
				#variable_conflict use_column
				DECLARE vFunctionName varchar := 'GetActivatedLicensesCountForUser';
					vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

				BEGIN

					IF(vIsAllowed) THEN
						RETURN (select sum(amount) from transactions ts
							join licenseorder lo
							on ts.licenseorderid = lo.licenseorderid
							join offerrequest oq
							on oq.offerrequestid = ts.offerrequestid
							join offerrequestitems ri
							on ri.offerrequestid = oq.offerrequestid
							join technologydata td			
							on ri.technologydataid = td.technologydataid 	
							where td.createdby = vuseruuid);

					ELSE
						 RAISE EXCEPTION '%', 'Insufficiency rigths';
						 RETURN NULL;
					END IF;
				  
				END;
			  $BODY$
			  LANGUAGE plpgsql VOLATILE;
			
	----------------------------------------------------------------------------------------------------------------------------------------
		-- UPDATE patch table status value
		UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
		--ERROR HANDLING
		EXCEPTION WHEN OTHERS THEN
			UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;	 
		 RETURN;
	END;
$$; 