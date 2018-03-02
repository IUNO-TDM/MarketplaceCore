--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-03-03
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
-- Update Get Components function
-- 	2) Which Git Issue Number is this patch solving?
--    #159
-- 	3) Which changes are going to be done?
--  Return displayColor also
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0029V_20180303';
		PatchNumber int 		 	 := 0029;
		PatchDescription varchar 	 := 'Update Get Components function';
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
			vPatchNumber int := 0029;
		BEGIN
-- #########################################################################################################################################

DROP FUNCTION public.getallcomponents(uuid, text[]);

CREATE OR REPLACE FUNCTION public.getallcomponents(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid integer, componentdescription character varying, displaycolor text, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetAllComponents';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));
		vRoot varchar := 'Root';

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  cp.componentuuid,
			cp.componentname,
			cp.componentparentid,
			cp.componentdescription,
			cp.displaycolor,
			cp.createdat  at time zone 'utc',
			cp.createdby,
			cp.updatedat  at time zone 'utc',
			cp.updatedby
			FROM Components cp
			WHERE cp.componentname != vRoot
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;

--#####################################################################################
DROP FUNCTION public.getcomponentbyid(uuid, uuid, text[]);

CREATE OR REPLACE FUNCTION public.getcomponentbyid(
    IN vcompuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid uuid, componentdescription character varying, displaycolor text, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetComponentById';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  cp.componentuuid,
				cp.componentname,
				cs.componentuuid,
				cp.componentdescription,
				cp.displaycolor,
				cp.createdat  at time zone 'utc',
				cp.createdby,
				cp.updatedat  at time zone 'utc',
				cp.updatedby
		    FROM Components cp
		    left outer join components cs on
		    cp.componentparentid = cs.componentid
		    WHERE cp.componentuuid = vCompUUID
		  );
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
--#####################################################################################
DROP FUNCTION public.getcomponentbyname(character varying, uuid, text[]);

CREATE OR REPLACE FUNCTION public.getcomponentbyname(
    IN vcompname character varying,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid integer, componentdescription character varying, displaycolor text, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetComponentByName';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  	componentuuid,
				cp.componentname,
				cp.componentparentid,
				cp.componentdescription,
				cp.displaycolor,
				cp.createdat  at time zone 'utc',
				cp.createdby,
				cp.updatedat  at time zone 'utc',
				cp.updatedby
		    FROM Components cp
		    WHERE cp.componentname = vCompName
		 );

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
--#####################################################################################
DROP FUNCTION public.getcomponentsbytechnology(uuid, uuid, text[]);

CREATE OR REPLACE FUNCTION public.getcomponentsbytechnology(
    IN vtechnologyuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid uuid, componentparentname character varying, displaycolor text, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetComponentsByTechnology';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select 	co.componentUUID,
			co.componentName,
			cs.componentUUID as componentParentUUID,
			cs.componentName as componentParentName,
			co.componentDescription,
			cp.displaycolor,
			co.createdat at time zone 'utc',
			co.createdby,
			co.updatedat at time zone 'utc',
			co.updatedby
			from components co
			join componentstechnologies ct
			on co.componentid = ct.componentid
			join technologies tc
			on tc.technologyid = ct.technologyid
			left outer join components cs
			on co.componentparentid = cs.componentid
			where tc.technologyuuid = vTechnologyUUID
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
--#####################################################################################
DROP FUNCTION public.getcomponentsfortechnologydataid(uuid, uuid, text[]);

CREATE OR REPLACE FUNCTION public.getcomponentsfortechnologydataid(
    IN vtechnologydatauuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid uuid, componentparentname character varying, displaycolor text, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetComponentsForTechnologyDataId';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select	co.componentuuid,
				co.componentname,
				cp.componentuuid as ComponentParentUUID,
				cp.componentname as ComponentParentName,
				co.componentDescription,
				co.displaycolor,
				co.createdat at time zone 'utc',
				td.CreatedBy,
				co.updatedat at time zone 'utc',
				td.UpdatedBy
			from technologydata td
			join technologydatacomponents tc
			on td.technologydataid = tc.technologydataid
			join components co on
			co.componentid = tc.componentid
			join components cp on
			co.componentparentid = cp.componentid
			where td.technologydatauuid = vTechnologyDataUUID
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