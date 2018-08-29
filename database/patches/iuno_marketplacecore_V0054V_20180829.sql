--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-08-28
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
--  Marketplace reports not working properly
-- 	2) Which Git Issue Number is this patch solving?
--
-- 	3) Which changes are going to be done?
--  Fixed report functions like topcomponents
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0054V_20180829';
		PatchNumber int 		 	 := 0054;
		PatchDescription varchar 	 := 'Fixed report functions';
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
    vPatchNumber int := 0054;
BEGIN
-- #########################################################################################################################################

DROP FUNCTION public.gettopcomponents(timestamp with time zone, timestamp with time zone, integer, uuid, text[]);

CREATE OR REPLACE FUNCTION public.gettopcomponents(
   	vfrom timestamp with time zone,
   	vto timestamp with time zone,
   	vlimit integer,
   	vuseruuid uuid,
   	vlanguagecode text DEFAULT 'en'::text,
   	vroles text[] DEFAULT NULL::text[])
       RETURNS TABLE(componentname character varying, amount integer)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   	DECLARE
   		vFunctionName varchar := 'GetTopComponents';
   		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

   	BEGIN

   	IF(vIsAllowed) THEN
   	RETURN QUERY (
   		with activatedLincenses as(
   				select tl.value as componentname, activatedat from licenseorder lo
   				join offer of on lo.offerid = of.offerid
   				join paymentinvoice pi on
   				of.paymentinvoiceid = pi.paymentinvoiceid
   				join offerrequest oq on
   				pi.offerrequestid = oq.offerrequestid
   				join offerrequestitems ri on
   				oq.offerrequestid = ri.offerrequestid
   				join technologydata td on
   				ri.technologydataid = td.technologydataid
   				join technologydatacomponents tc on
   				tc.technologydataid = td.technologydataid
   				join components co on
   				co.componentid = tc.componentid
   				JOIN translations tl ON
   						co.textid = tl.textid
   						JOIN languages la ON
   						tl.languageid = la.languageid
   						AND la.languagecode = vlanguagecode
   			),
   		rankTable as (
   		select a.componentname, count(a.componentname) as rank from activatedLincenses a
   		where activatedat between vFrom and vTo
   		group by a.componentname)
   		select r.componentname::varchar(250), rank::integer from rankTable r
   		order by rank desc limit vLimit);

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