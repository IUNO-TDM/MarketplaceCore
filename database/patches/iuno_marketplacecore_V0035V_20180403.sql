--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-04-03
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
--  Missing function to get a transaction by offeruuid
-- 	2) Which Git Issue Number is this patch solving?
--
-- 	3) Which changes are going to be done?
--  Added function to get a transaction by offeruuid
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0035V_20180403';
		PatchNumber int 		 	 := 0035;
		PatchDescription varchar 	 := 'Added function GetTransactionByOffer';
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
			vPatchNumber int := 0035;
		BEGIN
-- #########################################################################################################################################
--1. Create function
CREATE OR REPLACE FUNCTION public.gettransactionbyoffer(
	vofferuuid uuid,
	vuseruuid uuid,
	vroles text[])
    RETURNS TABLE(transactionuuid uuid, buyer uuid, offeruuid uuid, offerrequestuuid uuid, paymentuuid uuid, paymentinvoiceid uuid, licenseorderuuid uuid, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid)
AS $BODY$

	DECLARE
		vFunctionName varchar := 'GetTransactionByOffer';
		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select	ts.transactionuuid,
				ts.buyerid,
				ofr.offeruuid,
				oq.offerrequestuuid,
				py.paymentuuid,
				pi.paymentinvoiceuuid,
				li.licenseorderuuid,
				ts.createdat at time zone 'utc',
				ts.createdby,
				ts.updatedat at time zone 'utc',
				ts.updatedby
			from transactions ts
			join offerrequest oq
			on ts.offerrequestid = oq.offerrequestid
			left outer join offer ofr on ofr.offerid = ts.offerid
			left outer join payment py on py.paymentid = ts.paymentid
			left outer join paymentinvoice pi
			on pi.paymentinvoiceid = ts.paymentinvoiceid
			left outer join licenseorder li
			on li.licenseorderid = ts.licenseorderid
			WHERE ofr.offeruuid = vOfferUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;

  -- #########################################################################################################################################

 --2. Add entry in functions table
 insert into functions (functionid, functionname) values ((select nextval('functionid')),'GetTransactionByOffer');
 --3. Set permissions for function
 perform public.setpermission('{MachineOperator}','GetTransactionByOffer',null,'{Admin}');
 --4. Set CheckOwnership to false
 update rolespermissions set CheckOwnership = false where functionid = (select functionid from functions where functionname = 'GetTransactionByOffer');

----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;