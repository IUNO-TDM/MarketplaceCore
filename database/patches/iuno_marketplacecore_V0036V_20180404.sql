--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-04-04
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
--  Missing or wrong client id in created_at field
-- 	2) Which Git Issue Number is this patch solving?
--  #174
-- 	3) Which changes are going to be done?
--  Added clientId column to protocols table
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0036V_20180404';
		PatchNumber int 		 	 := 0036;
		PatchDescription varchar 	 := 'Added clientId column to protocols table';
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
			vPatchNumber int := 0036;
		BEGIN
-- #########################################################################################################################################

ALTER TABLE protocols ADD COLUMN ClientId uuid;

-- #########################################################################################################################################

CREATE OR REPLACE FUNCTION public.createprotocols(
    IN vdata jsonb,
    IN vclientid uuid,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(eventtype text, payload json, "timestamp" timestamptz, clientid uuid, createdby uuid, createdat timestamptz) AS
$BODY$
DECLARE
    vFunctionName varchar := 'CreateProtocols';
    vProtocolID int := (select nextval('protocolid'));
    vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

BEGIN
    IF(vIsAllowed) THEN
            INSERT INTO protocols (ProtocolID, eventtype, payload, sourcetimestamp, clientid, createdby, createdat)
            SELECT 	vProtocolID,
                    (vData->>'eventType')::text,
                    (vData->>'payload')::json,
                    (vData->>'timestamp')::timestamptz,
                    vClientId,
                    vCreatedBy,
                    now()::timestamptz;

            RETURN QUERY ( 	select 	p.eventType,
                                    p.payload,
                                    p.sourceTimestamp,
                                    p.clientid,
                                    p.createdby,
                                    p.createdat
                             from protocols p where protocolid = vProtocolID

            );
    ELSE
         RAISE EXCEPTION '%', 'Insufficiency rigths';
         RETURN;
    END IF;

END;

$BODY$
LANGUAGE plpgsql;

-- #########################################################################################################################################
DROP FUNCTION public.getprotocols(text, timestamp without time zone, timestamp without time zone, uuid, text[]);
CREATE OR REPLACE FUNCTION GetProtocols(vEventType text, vFrom timestamp, vTo timestamp, vUseruuid uuid, vRoles text[])
RETURNS TABLE (eventtype text, payload json, sourcetimestamp timestamptz, clientid uuid, createdby uuid, createat timestamptz) AS
$BODY$
	DECLARE vFunctionName text := 'GetProtocols';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN
		IF(vIsAllowed) THEN
		RETURN QUERY (
			select 	p.eventtype,
				p.payload,
				p.sourcetimestamp,
				p.clientid,
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