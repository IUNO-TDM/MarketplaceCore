--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2017-09-25
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
--	The function gettechnologydatabyname returns error due to column not known or ambiguous. 
--	Fixed putting table prefix before column name. Furthermore it's necessary to use lower
--  while comparing the technologydataname to avoid the use of a technologydataname twice.
-- 	2) Which Git Issue Number is this patch solving?  
--	#112
-- 	3) Which changes are going to be done?  
--  Update the function GetTechnologyDataByName
--: Run Patches
DO
$$
	BEGIN		
		CREATE OR REPLACE FUNCTION public.gettechnologydatabyname(
    IN vtechnologydataname character varying,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee integer, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByName';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

    	RETURN QUERY (SELECT 	td.technologydatauuid,
				tc.technologyuuid,
				lower(td.technologydataname)::character varying,
				td.technologydata,
				td.technologydatadescription,
				td.productcode,
				td.licensefee,
				td.technologydatathumbnail,
				td.technologydataimgref,
				td.createdat  at time zone 'utc',
				td.createdby,
				td.updatedat  at time zone 'utc',
				td.updatedBy
			FROM TechnologyData td
			join technologies tc
			on td.technologyid = tc.technologyid
			where lower(td.technologydataname) = lower(vTechnologyDataName)
			and td.deleted is null
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
	$BODY$
  LANGUAGE plpgsql;	
END;
$$;
