--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-09-12
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
--  JMW gallery needs additional permissions for public role
--  User Revenue always returns 0
-- 	2) Which Git Issue Number is this patch solving?
--  #219
-- 	3) Which changes are going to be done?
--  Updated getTotalUserRevenue function
--  Updating unique constraint on payment table and deleting duplicated entries
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0056V_20180912';
		PatchNumber int 		 	 := 0056;
		PatchDescription varchar 	 := 'Fixed bug in getTotalUserRevenue function';
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
    vPatchNumber int := 0056;
BEGIN
-- #########################################################################################################################################


    CREATE OR REPLACE FUNCTION public.gettotaluserrevenue(
        vfrom timestamp with time zone,
        vto timestamp with time zone,
        vtechnologyuuid uuid,
        vcreatedby uuid,
        vroles text[])
        RETURNS TABLE(date date, hour text, technologydataname text, amount integer, revenue bigint)
        LANGUAGE 'plpgsql'

    AS $BODY$

        DECLARE
            vFunctionName varchar := 'GetTotalUserRevenue';
            vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
            vTechnologyDataUUID uuid := (select uuid_nil());
        BEGIN

        IF(vIsAllowed) THEN

        RETURN QUERY (select  to_date(r.year || '-' || r.month || '-' || r.day, 'YYYY-MM-DD') as date, r.hour::text, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from public.getrevenue(
                    vFrom,
                    vTo,
                    vTechnologyDataUUID,
                    vTechnologyUUID,
                    vCreatedBy,
                    vRoles) r
                    left outer join technologydata td
                    on td.technologydatauuid = r.technologydatauuid
                    left outer join technologies tg
                    on td.technologyid = tg.technologyid
                    where r.year = '0'
                    and r.month = '0'
                    and r.day = '0'
                    and r.hour = '0'
                    and r.technologydatauuid = vTechnologyDataUUID
                    order by r.year asc, r.month asc, r.day asc
            );
        ELSE
             RAISE EXCEPTION '%', 'Insufficiency rigths';
             RETURN;
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