--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2017-09-25
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
--	The function gettechnologybyname returns error due to column not known or ambiguous. 
--	Fixed putting table prefix before column name.
-- 	2) Which Git Issue Number is this patch solving? 
--	#112;
-- 	3) Which changes are going to be done? 
--	The function gettechnologybyname is going to be overwritten
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V00004V_20170925';
		PatchNumber int 		 	 := 0004;
		PatchDescription varchar 	 := 'The function gettechnologybyname returns error due to column not known or ambiguous. 
										Fixed putting table prefix before column name.';

	BEGIN	
		--INSERT START VALUES TO THE PATCH TABLE
		INSERT INTO PATCHES (patchname, patchnumber, patchdescription, startat) VALUES (PatchName, PatchNumber, PatchDescription, now());		
	END;
$$;
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Run the patch itself and update patches table
--##############################################################################################
DO
$$
		DECLARE
			vPatchNumber int := (select max(patchnumber) from patches);
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------
			
			CREATE OR REPLACE FUNCTION public.gettechnologybyname(
		    IN vtechname character varying,
		    IN vuseruuid uuid,
		    IN vroles text[])
		  RETURNS TABLE(technologyuuid uuid, technologyname character varying, technologydescription character varying, createdat timestamp with time zone, 				createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
		$BODY$

			DECLARE
				vFunctionName varchar := 'GetTechnologyByName';
				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

			BEGIN

			IF(vIsAllowed) THEN

			RETURN QUERY (SELECT  	tg.technologyuuid,
						tg.technologyname,
						tg.technologydescription,
						tg.createdat at time zone 'utc',
						tg.createdby,
						tg.updatedat at time zone 'utc',
						tg.updatedby
				    FROM Technologies tg
				    WHERE lower(tg.technologyname) = lower(vtechName)
				 );

			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

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