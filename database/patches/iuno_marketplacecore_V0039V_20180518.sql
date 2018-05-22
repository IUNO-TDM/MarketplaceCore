--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-05-18
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
--  Encrypted data should only be returned for paid orders.
-- 	2) Which Git Issue Number is this patch solving?
--  #186
-- 	3) Which changes are going to be done?
--  Created new function to get the encrypted technologydata for paid orders
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0039V_20180518';
		PatchNumber int 		 	 := 0039;
		PatchDescription varchar 	 := 'Created new function to get the encrypted technologydata for paid orders';
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
			vPatchNumber int := 0039;
		BEGIN
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettechnologydatawithcontent(
	vtechnologydatauuid uuid,
	vofferuuid uuid,
	vclientuuid uuid,
	vuseruuid uuid,
	vroles text[])
    RETURNS TABLE(technologydatauuid uuid, technologydata character varying, productcode integer)
    LANGUAGE 'plpgsql'

AS $BODY$

	DECLARE
		vFunctionName varchar := 'GetTechnologyDataWithContent';
		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (
					SELECT td.technologydatauuid,td.technologydata,td.productcode
                    FROM offer o
                    JOIN transactions tr
                    ON tr.offerid = o.offerid
                    JOIN offerrequestitems ori
                    ON ori.offerrequestid = tr.offerrequestid
                    JOIN technologydata td
                    ON td.technologydataid = ori.technologydataid
                    WHERE o.offeruuid = vOfferUUID
                    AND td.technologydatauuid = vTechnologyDataUUID
                    AND td.deleted IS NULL
                    AND tr.licenseorderid IS NOT NULL
                    AND tr.buyerid = vClientUUID
                    AND tr.createdby = vUserUUID
	);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;

$BODY$;

insert into functions (functionid, functionname) values ((select nextval('functionid')),'GetTechnologyDataWithContent');

perform public.setpermission('{MachineOperator}','GetTechnologyDataWithContent',null,'{Admin}');

update rolespermissions set CheckOwnership = false where functionid = (select functionid from functions where functionname = 'GetTechnologyDataWithContent');

-- #########################################################################################################################################


----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;