--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-03-13
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
--  Role and permissions concept was not consistence.
-- 	2) Which Git Issue Number is this patch solving?
--  # 165
-- 	3) Which changes are going to be done?
--  Delete old role and permission concept, Create CheckOwnership function, Update CheckPermission function and others.
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0029V_20180303';
		PatchNumber int 		 	 := 0030;
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
			vPatchNumber int := 0030;
		BEGIN
-- #########################################################################################################################################

-- 1. Delete Admin Permissions
DELETE FROM rolespermissions where roleid = 0 and functionid <> 1;
-- 2. Drop Column isOwner from functions
ALTER TABLE functions DROP COLUMN isOwner;
-- 3. Add Column CheckOwnership to RolesPermissions
ALTER TABLE RolesPermissions ADD COLUMN CheckOwnership boolean;
-- 4. Drop deleted functions from rolespermissions and functions tables
delete from rolespermissions where functionid in
(select functionid from functions where lower(functionname) not in (
SELECT  lower(p.proname)
FROM    pg_catalog.pg_namespace n
JOIN    pg_catalog.pg_proc p
ON      p.pronamespace = n.oid
WHERE   n.nspname = 'public'));

delete from functions where lower(functionname) not in (
SELECT  lower(p.proname)
FROM    pg_catalog.pg_namespace n
JOIN    pg_catalog.pg_proc p
ON      p.pronamespace = n.oid
WHERE   n.nspname = 'public');
-- 5. Drop UserKeys Table
DROP TABLE UserKeys;
-- 6. Drop Column Key from Functions Table
ALTER TABLE Functions DROP COLUMN Key;
-- 7. update values to CheckOwnership column
-- At first false for all
update rolespermissions set CheckOwnership = false;

-- Now restrictive
update rolespermissions set CheckOwnership = true where functionid = 'DeleteTechnologyData' and roleid <> 1;
update rolespermissions set CheckOwnership = true where functionid = 'GetRevenue' and roleid <> 1;
update rolespermissions set CheckOwnership = true where functionid = 'GetTechnologyDataForUser' and roleid <> 1;
update rolespermissions set CheckOwnership = true where functionid = 'GetTopTechnologyData' and roleid <> 1;

-- 8. Update CheckPermission - Set to original form
DROP FUNCTION public.checkpermissions(uuid, text[], character varying);

CREATE OR REPLACE FUNCTION public.checkpermissions(
    vroles text[],
    vfunctionname character varying)
  RETURNS boolean AS
$BODY$
	#variable_conflict use_column
	DECLARE	vIsAllowed boolean;
		vFunctionId integer := (select functionId from functions where functionname = vFunctionName);
	BEGIN
		vIsAllowed := (select exists(select 1 from rolespermissions rp
									 join roles ro on ro.roleid = ro.roleid
									 where ro.rolename = ANY(vRoles)
									 and functionId = vFunctionId));
		if(vIsAllowed) then
			return true;
		else
			return false;
		end if;
	END;
$BODY$
LANGUAGE PLPGSQL;
-- 9. Create CheckOwnership function
CREATE OR REPLACE FUNCTION public.checkownership(
    vfunctionname text,
    vcreatedby uuid,
    vowneruuid uuid,
    vroles text[])
  RETURNS boolean AS
$BODY$
	DECLARE vFunctionID int := (select functionid from functions where functionname = vFunctionName);
		vCheckOwnership bool :=
			(select CheckOwnership from rolespermissions where functionid = vFunctionID and roleid in
				(select r.roleid from roles r
				join rolespermissions rp on r.roleid = rp.roleid
				where rp.functionid = vFunctionID and
				r.rolename = ANY(vRoles))
			);
	BEGIN
		IF (vCheckOwnership is null) THEN
			RAISE EXCEPTION '%', 'ERROR: You are not allowed to run this procedure: ' || vFunctionName || '.';
			ELSE IF (vCheckOwnership = false) THEN
					RETURN false;
				ELSE IF (vCheckOwnership = true) THEN
					IF (vOwnerUUID != vCreatedby or vCreatedby is null) THEN
						RAISE EXCEPTION '%', 'ERROR: You are not the data owner';
						RETURN false;
					END IF;
				END IF;
			END IF;
		END IF;

		RETURN true;
	END;
$BODY$
  LANGUAGE plpgsql;
-- 9. Update Function GetTopTechnologyData
CREATE OR REPLACE FUNCTION public.gettoptechnologydata(
    IN vfrom timestamp with time zone,
    IN vto timestamp with time zone,
    IN vlimit integer,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(year text, month text, day text, hour text, technologydataname text, amount integer, revenue bigint) AS
$BODY$

			DECLARE
				vFunctionName varchar := 'GetTopTechnologyData';
				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
				vOwnerUUID uuid := vcreatedby;
				vCheckOwnership boolean := (select public.checkOwnership(vFunctionName, vCreatedby, vOwnerUUID, vRoles));

			BEGIN

			IF(vIsAllowed) THEN
				IF (vCheckOwnership = false) THEN vCreatedBy = null; END IF;


			RETURN QUERY (select r.year, r.month, r.day, r.hour, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from
					getrevenue(vFrom,
						   vTo,
						   null,
						   vcreatedby,
						   vRoles) r
						   join technologydata td
						   on td.technologydatauuid = r.technologydatauuid
							where r.year = '0'
							and r.month = '0'
							and r.day = '0'
							and r.hour = '0'
							and td.technologydataname <> 'Total'
							and td.deleted is null
						order by r.amount desc, td.technologydataname
						limit vLimit
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