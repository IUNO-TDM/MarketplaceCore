--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-03-20
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
--  Create function to return protocols data
-- 	2) Which Git Issue Number is this patch solving?
--  # 162
-- 	3) Which changes are going to be done?
--  Create Function GetProtocols.
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0033V_20180320';
		PatchNumber int 		 	 := 0033;
		PatchDescription varchar 	 := 'Create Function GetProtocols';
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
			vPatchNumber int := 0033;
		BEGIN
-- #########################################################################################################################################
--1. Create GetProtocols function
CREATE OR REPLACE FUNCTION GetProtocols(vEventType text, vFrom timestamp, vTo timestamp, vUseruuid uuid, vRoles text[])
RETURNS TABLE (eventtype text, payload json, sourcetimestamp timestamptz, createdby uuid, createat timestamptz) AS
$BODY$
	DECLARE vFunctionName text := 'GetProtocols';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN
		IF(vIsAllowed) THEN
		RETURN QUERY (
			select 	p.eventtype,
				p.payload,
				p.sourcetimestamp,
				p.createdby,
				p.createdat
			from protocols p
			where lower(p.eventtype) = lower(vEventType)
			and p.sourcetimestamp between vFrom and vTo
		);

		ELSE
			RAISE EXCEPTION '%', 'Insufficiency rigths';
		RETURN;
	END IF;

	END;
$BODY$
Language plpgsql;
--2. Insert CreateProtocols FUNCTION into functions table
insert into functions (functionid, functionname) values ((select nextval('functionid')),'GetProtocols');
--3. Create Permissions to new Function CreateProtocols
perform public.setpermission('{Admin}','GetProtocols',null,'{Admin}');
--4. Set CheckOwnership for GetProtocols function to false
update rolespermissions set CheckOwnership = false where functionid = (select functionid from functions where functionname = 'GetProtocols') and roleid <> 1;
----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;