--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-03-15
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
--  To create charts that show machine status and other machine data
-- 	2) Which Git Issue Number is this patch solving?
--  # 165
-- 	3) Which changes are going to be done?
--  Create Function CreateProtocols.
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0032V_20180315';
		PatchNumber int 		 	 := 0032;
		PatchDescription varchar 	 := 'Create Function CreateProtocols';
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
			vPatchNumber int := 0032;
		BEGIN
-- #########################################################################################################################################
--0. Create Sequence for ProtocolID
CREATE SEQUENCE protocolid START WITH 1;
--1. CREATE Protocols TABLE
CREATE TABLE protocols (protocolid integer, data jsonb, createdby uuid, createdat timestamp);
ALTER TABLE protocols ADD PRIMARY KEY (protocolid);
--2. CREATE FUNCTION to insert Protocols
CREATE OR REPLACE FUNCTION public.createprotocols(
    IN vdata jsonb,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(eventtype text, "timestamp" timestamp with time zone, payload json) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'CreateProtocols';
		vProtocolID int := (select nextval('protocolid'));
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));


	BEGIN
		IF(vIsAllowed) THEN
				INSERT INTO protocols (ProtocolID, data, createdby, createdat) values (vProtocolID, vData, vCreatedBy, now());

				RETURN QUERY ( 	select 	(data->>'eventType')::text as eventType,
							(data->>'timestamp')::timestamp at time zone 'utc' as timestamp,
							(data->>'payload')::json as payload
						from protocols where protocolid = vProtocolID

				);
		ELSE
			 RAISE EXCEPTION '%', 'Insufficiency rigths';
			 RETURN;
		END IF;

	END;

 $BODY$
  LANGUAGE plpgsql;

--3. Insert CreateProtocols FUNCTION into functions table
insert into functions (functionid, functionname) values ((select nextval('functionid')),'CreateProtocols');
--4. Create Permissions to new Function CreateProtocols
perform public.setpermission('{MachineOperator}','CreateProtocols',null,'{Admin}');
perform public.setpermission('{MarketplaceComponent}','CreateProtocols',null,'{Admin}');
----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;