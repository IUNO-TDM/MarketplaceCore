--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-04-05
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
--  Missing limits in db query
-- 	2) Which Git Issue Number is this patch solving?
--  #176
-- 	3) Which changes are going to be done?
--  Updated GetProtocols function to include ClientId filter.
--  Introduced new function GetLastProtocolForEachClient: Returning only the last protocol for each client.
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0037V_20180405';
		PatchNumber int 		 	 := 0037;
		PatchDescription varchar 	 := 'Added client_limit and limit and client_id to GetProtocols function';
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
			vPatchNumber int := 0037;
		BEGIN
-- #########################################################################################################################################
DROP FUNCTION public.getprotocols(text, timestamp without time zone, timestamp without time zone, uuid, text[]);

CREATE OR REPLACE FUNCTION GetProtocols(vEventType text, vClientId uuid, vFrom timestamp, vTo timestamp, vLimit integer, vUseruuid uuid, vRoles text[])
RETURNS TABLE (eventtype text, payload json, sourcetimestamp timestamptz, clientid uuid, createdby uuid, createat timestamptz) AS
$BODY$
	DECLARE vFunctionName text := 'GetProtocols';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN
		IF(vIsAllowed) THEN

            RETURN QUERY (
                            SELECT
                                p.eventtype,
                                p.payload,
                                p.sourcetimestamp,
                                p.clientid,
                                p.createdby,
                                p.createdat
                            FROM protocols p
                            WHERE lower(p.eventtype) = LOWER(vEventType)
                            AND p.sourcetimestamp BETWEEN vFrom AND vTo
                            AND (p.clientid = vClientId OR vClientId IS NULL)
                            ORDER BY p.sourcetimestamp DESC
                            limit vLimit
                         );

		ELSE
			RAISE EXCEPTION '%', 'Insufficiency rigths';
		    RETURN;
	    END IF;
	END;
$BODY$
Language plpgsql;

-- #########################################################################################################################################

CREATE OR REPLACE FUNCTION GetLastProtocolForEachClient(vEventType text, vFrom timestamp, vTo timestamp, vUseruuid uuid, vRoles text[])
RETURNS TABLE (eventtype text, payload json, sourcetimestamp timestamptz, clientid uuid, createdby uuid, createat timestamptz) AS
$BODY$
	DECLARE vFunctionName text := 'GetLastProtocolForEachClient';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN
		IF(vIsAllowed) THEN
		RETURN QUERY
            (
                SELECT  p.eventtype,
                        p.payload,
                        p.sourcetimestamp,
                        p.clientid,
                        p.createdby,
                        p.createdat
                FROM
                    (
                        SELECT p2.clientid, MAX(p2.sourcetimestamp) AS sourcetimestamp
                        FROM protocols p2
                        WHERE LOWER(p2.eventtype) = LOWER(vEventType)
                        AND p2.sourcetimestamp between vFrom and vTo
                        GROUP BY p2.clientid
                    ) pFilter
                JOIN protocols p
                ON pFilter.clientid = p.clientid
                AND pFilter.sourcetimestamp = p.sourcetimestamp
            );
		ELSE
			RAISE EXCEPTION '%', 'Insufficiency rigths';
		    RETURN;
	    END IF;
	END;
$BODY$
Language plpgsql;

insert into functions (functionid, functionname) values ((select nextval('functionid')),'GetLastProtocolForEachClient');

perform public.setpermission('{Admin}','GetLastProtocolForEachClient',null,'{Admin}');

update rolespermissions set CheckOwnership = false where functionid = (select functionid from functions where functionname = 'GetLastProtocolForEachClient');


----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;