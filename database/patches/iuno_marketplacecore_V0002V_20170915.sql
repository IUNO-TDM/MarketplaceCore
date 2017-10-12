--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2017-09-15
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
--	With the public user wasn't possible to call the functions GetActivatedLicensesSince and GetWorkloadSince. 
--	Furthermore there were some errors (Ambiguous Column) in the functions GetActivatedLicensesSince, GetWorkloadSince and GetMostUsedComponents
-- 	2) Which Git Issue Number is this patch solving?
--	#35
-- 	3) Which changes are going to be done?
--	The old function GetActivatedLicensesSince will be dropped
--  Create new function GetActivatedLicensesSince and update the functions GetWorkloadSince and GetMostUsedComponents
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V00002V_20170913';
		PatchNumber int 		 	 := 0002;
		PatchDescription varchar 	 := 'With the public user was not possible to call the functions GetActivatedLicensesSince and GetWorkloadSince. 
	Furthermore there were some errors (Ambiguous Column) in the functions GetActivatedLicensesSince, GetWorkloadSince and GetMostUsedComponents';

	BEGIN	
		--INSERT START VALUES TO THE PATCH TABLE
		INSERT INTO PATCHES (patchname, patchnumber, patchdescription, startat) VALUES (PatchName, PatchNumber, PatchDescription, now());		
	END;
$$;
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Run the patch itself and update patches table
--##############################################################################################
DO
$$
		DECLARE
			vPatchNumber int := (select max(patchnumber) from patches);
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------
			
			perform SetPermission('{Public}','GetActivatedLicensesSince',null,'{Admin}');
perform SetPermission('{Public}','GetWorkloadSince',null,'{Admin}');  
 
CREATE OR REPLACE FUNCTION public.getmostusedcomponents(
    IN vsincedate timestamp without time zone,
    IN vtopvalue integer,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentname character varying, amount integer) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetMostUsedComponents';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN
	RETURN QUERY (
		with activatedLincenses as(
				select co.componentname, activatedat from licenseorder lo
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
				where td.deleted is null
			),
		rankTable as (
		select a.componentname, count(a.componentname) as rank from activatedLincenses a where
		(select datediff('second',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
		(select datediff('minute',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
		(select datediff('hour',vSinceDate::timestamp,activatedat::timestamp)) >= 0
		group by a.componentname)
		select r.componentname::varchar(250), rank::integer from rankTable r
		order by rank desc limit vTopValue);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
 $BODY$
  LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION public.getworkloadsince(
    IN vsincedate timestamp without time zone,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydataname character varying, date date, amount integer, dayhour integer) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetWorkloadSince';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY	(with activatedLicenses as(
				select td.technologydataname, activatedat from licenseorder lo
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
				where td.deleted is null
				),
			rankTable as (
			select a.technologydataname, a.activatedat,
			a.activatedat::date as dateValue,
			date_part('hour',activatedat) as dayhour from activatedLicenses as a where
			(select datediff('second',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('minute',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('hour',vSinceDate::timestamp,activatedat::timestamp)) >= 0
			group by a.technologydataname, a.activatedat )
			select r.technologydataname, r.dateValue, count(r.dayhour)::integer as amount, r.dayhour::integer from rankTable r
			group by r.technologydataname, r.dateValue, r.dayhour
			order by r.dayhour asc);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
  DROP FUNCTION getactivatedlicensessince(timestamp without time zone,uuid,text[]);

 CREATE OR REPLACE FUNCTION public.getactivatedlicensessince(
    vtime timestamp without time zone,
    vuseruuid uuid,
    vroles text[])
  RETURNS table(count integer) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetActivatedLicensesSince';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (with activatedLincenses as(
			select * from licenseorder lo
			join offer of on lo.offerid = of.offerid
			join paymentinvoice pi on
			of.paymentinvoiceid = pi.paymentinvoiceid
			join offerrequest oq on
			pi.offerrequestid = oq.offerrequestid
			join offerrequestitems ri on
			oq.offerrequestid = ri.offerrequestid
			join technologydata td on
			ri.technologydataid = td.technologydataid
			)
		select count(*)::integer from activatedLincenses where
		(select datediff('second',vTime::timestamp,activatedat::timestamp)) >= 0 AND
		(select datediff('minute',vTime::timestamp,activatedat::timestamp)) >= 0 AND
		(select datediff('hour',vTime::timestamp,activatedat::timestamp)) >= 0);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;

$BODY$
  LANGUAGE plpgsql VOLATILE; 
			
	----------------------------------------------------------------------------------------------------------------------------------------
		-- UPDATE patch table status value
		UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
		--ERROR HANDLING
		EXCEPTION WHEN OTHERS THEN
			UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;	 
		 RETURN;
	END;
$$; 