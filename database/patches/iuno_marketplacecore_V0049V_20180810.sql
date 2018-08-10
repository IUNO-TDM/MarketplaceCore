--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-08-10
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
--  GetComponents function do not return their attributes
-- 	2) Which Git Issue Number is this patch solving?
--
-- 	3) Which changes are going to be done?
-- Create Function GetComponentAttributesForTechnologyData
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0049V_20180810';
		PatchNumber int 		 	 := 0049;
		PatchDescription varchar 	 := 'Create Function GetComponentAttributesForTechnologyData';
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
    vPatchNumber int := 0049;
BEGIN
-- #########################################################################################################################################

CREATE OR REPLACE FUNCTION public.getcomponentattributesfortechnologydata(
	vtechnologydatauuid uuid,
	vroles text[])
    RETURNS TABLE(componentuuid uuid, attributeuuid uuid, attributename character varying)
    LANGUAGE 'plpgsql'

AS $BODY$

	DECLARE
		vFunctionName varchar := 'GetComponentAttributesForTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

        RETURN QUERY (
                        SELECT comp.componentuuid, atr.attributeuuid, atr.attributename FROM attributes atr
                        JOIN componentsattribute compatr ON compatr.attributeid = atr.attributeid
                        JOIN components comp ON comp.componentid = compatr.componentid
                        JOIN technologydatacomponents techcomp ON techcomp.componentid = compatr.componentid
                        JOIN technologydata td ON td.technologydataid = techcomp.technologydataid
                        WHERE td.technologydatauuid = vTechnologyDataUUID
                        AND td.deleted IS NULL
        );

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;

$BODY$;

insert into functions (functionid, functionname) values ((select nextval('functionid')),'GetComponentAttributesForTechnologyData');

perform public.setpermission('{MachineOperator}','GetComponentAttributesForTechnologyData',null,'{Admin}');

update rolespermissions set CheckOwnership = false where functionid = (select functionid from functions where functionname = 'GetComponentAttributesForTechnologyData');

----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;