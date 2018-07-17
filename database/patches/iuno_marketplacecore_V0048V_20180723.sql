--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-07-23
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
--  Missing function to update technology data table
-- 	2) Which Git Issue Number is this patch solving?
--  #06
-- 	3) Which changes are going to be done?
-- Create Function UpdateTechnologyData
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0048V_20180723';
		PatchNumber int 		 	 := 0048;
		PatchDescription varchar 	 := 'Create Function UpdateTechnologyData';
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
    vPatchNumber int := 0048;
BEGIN
-- #########################################################################################################################################



    CREATE OR REPLACE FUNCTION public.updatetechnologydata(
        vtechnologydatauuid uuid,
        vtechnologydata character varying,
        vuseruuid uuid,
        vroles text[] DEFAULT NULL::text[])
        RETURNS boolean
        LANGUAGE 'plpgsql'

        AS $BODY$

            DECLARE
                vFunctionName varchar := 'UpdateTechnologyData';
                vFunctionID int := (select functionid from functions where functionname = vFunctionName);
                vOwnerUUID uuid := (select createdby from technologydata where technologydatauuid = vTechnologyDataUUID);
                vCheckOwnership boolean := (select public.checkOwnership(vFunctionName, vuseruuid, vOwnerUUID, vRoles));
                vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

            BEGIN

                IF(vIsAllowed) THEN

                    UPDATE technologydata set technologydata = vTechnologyData
                    WHERE technologydatauuid = vTechnologyDataUUID
                    AND createdby = vuseruuid;

                ELSE
                    RAISE EXCEPTION '%', 'Insufficiency rigths';
                END IF;



            END;

        $BODY$;

        INSERT INTO functions (functionid, functionname) VALUES ((SELECT nextval('functionid')),'UpdateTechnologyData');
        perform SetPermission('{TechnologyDataOwner}','UpdateTechnologyData',NULL,'{Admin}');
        UPDATE rolespermissions SET CheckOwnership = TRUE WHERE functionid = (SELECT functionid FROM functions WHERE functionname = 'UpdateTechnologyData');

----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;