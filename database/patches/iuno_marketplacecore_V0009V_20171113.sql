--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2017-09-13
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
--	The function GetTechnologydatabyParams returns also deleted technologydata. This is wrong!
-- 	2) Which Git Issue Number is this patch solving? 
--	#120
-- 	3) Which changes are going to be done? 
--	The function GetTechnologyDataByParams will be updated.
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0009V_20171113';
		PatchNumber int 		 	 := 0009;
		PatchDescription varchar 	 := 'Do not return deleted technologydata';
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
			vPatchNumber int :=  0009;
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------
			
		CREATE OR REPLACE FUNCTION public.gettechnologydatabyparams(
    IN vcomponents text[],
    IN vtechnologyuuid uuid,
    IN vtechnologydataname character varying,
    IN vowneruuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(result json) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByParams';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	 RETURN QUERY (	 with tg as (
				select tg.tagid, tg.tagname from tags tg
				join technologydatatags ts
				on tg.tagid = ts.tagid
				join technologydata td
				on ts.technologydataid = td.technologydataid
				join technologies tt
				on td.technologyid = tt.technologyid
				group by tg.tagid, tg.tagname
			),
			 att as (
				select ab.attributeid, attributename from components co
				join componentsattribute ca on
				co.componentid = ca.componentid
				join attributes ab on
				ca.attributeid = ab.attributeid
				join technologydatacomponents tc
				on tc.componentid = co.componentid
				group by ab.attributeid
			),
			comp as (
			select co.componentuuid, co.componentid, co.componentname, array_to_json(array_agg(t.*)) as attributes from att t
			join componentsattribute ca on t.attributeid = ca.attributeid
			join components co on co.componentid = ca.componentid
			group by co.componentname, co.componentid, co.componentuuid
			),
			techData as (
				select td.technologydatauuid,
					td.technologydataname,
					tt.technologyuuid,
					td.technologydata,
					td.licensefee,
					td.productcode,
					td.technologydatadescription,
					td.technologydatathumbnail,
					td.technologydataimgref,
					td.createdat at time zone 'utc',
					td.CreatedBy,
					td.updatedat at time zone 'utc',
					td.UpdatedBy,
					array_to_json(array_agg(co.*)) ComponentsWithAttribute
				from comp co join technologydatacomponents tc
				on co.componentid = tc.componentid
				join technologydata td on
				td.technologydataid = tc.technologydataid
				join components cm on cm.componentid = co.componentid
				join technologies tt on
				tt.technologyid = td.technologyid
				where (vOwnerUUID is null OR td.createdby = vOwnerUUID)
				and td.deleted is null
				group by td.technologydatauuid,
					td.technologydataname,
					tt.technologyuuid,
					td.technologydata,
					td.licensefee,
					td.productcode,
					td.technologydatadescription,
					td.technologydatathumbnail,
					td.technologydataimgref,
					td.createdat,
					td.createdby,
					td.updatedat,
					td.updatedby
			),
			compIn as (
				select	td.technologydataname, array_agg(componentuuid order by componentuuid asc) comp
				from components co
				join technologydatacomponents tc
				on co.componentid = tc.componentid
				join technologydata td on
				td.technologydataid = tc.technologydataid
				where td.deleted is null
				group by td.technologydataname

			)
			select array_to_json(array_agg(td.*)) from techData	td
			join compIn co on co.technologydataname = td.technologydataname
			where (co.comp::text[] <@ vComponents OR vComponents is null)
			and (vTechnologyDataName is null OR td.technologydataname = vTechnologyDataName)

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