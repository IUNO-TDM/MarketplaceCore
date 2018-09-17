--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-08-20
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
--  Need to update technologydataimageref on technologydata
-- 	2) Which Git Issue Number is this patch solving?
--
-- 	3) Which changes are going to be done?
--  Added imageref parameter to update technologydata function
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0051V_20180820';
		PatchNumber int 		 	 := 0051;
		PatchDescription varchar 	 := 'Added imageref parameter to update technologydata function';
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
    vPatchNumber int := 0051;
BEGIN
-- #########################################################################################################################################

    CREATE OR REPLACE FUNCTION public.updatetechnologydata(
        vTechnologyDataUUID uuid,
        vTechnologyData character varying,
        vIsFile boolean,
        vFilePath character varying,
        vTechnologyDataImageRef text,
        vUserUUID uuid,
        vRoles text[] DEFAULT NULL::text[])
        RETURNS VOID
        LANGUAGE 'plpgsql'

        AS $BODY$

            DECLARE
                vFunctionName varchar := 'UpdateTechnologyData';
                vFunctionID int := (select functionid from functions where functionname = vFunctionName);
                vOwnerUUID uuid := (select createdby from technologydata where technologydatauuid = vTechnologyDataUUID);
                vCheckOwnership boolean := (select public.checkOwnership(vFunctionName, vUserUUID, vOwnerUUID, vRoles));
                vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

            BEGIN

                IF(vIsAllowed) THEN

                    UPDATE technologydata
                    SET technologydata = COALESCE(vTechnologyData, technologydata),
                        isfile = COALESCE(vIsFile, isfile),
                        filepath = COALESCE(vFilePath, filepath),
                        technologydataimgref = COALESCE(vTechnologyDataImageRef, technologydataimgref),
                        updatedAt = now(),
                        updatedby = vUserUUID
                    WHERE technologydatauuid = vTechnologyDataUUID
                    AND createdby = vUserUUID;

                ELSE
                    RAISE EXCEPTION '%', 'Insufficiency rigths';
                END IF;

            END;

        $BODY$;

----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;