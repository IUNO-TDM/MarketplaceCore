--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-01-23
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
--  TicketID is not used
-- 	2) Which Git Issue Number is this patch solving?
--  #148
-- 	3) Which changes are going to be done?
--  Drop function GetOfferForTicket as well as the column TicketId in the Table LicenseOrder. Update CreateLicenseOrder function
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0021V_20180124';
		PatchNumber int 		 	 := 0021;
		PatchDescription varchar 	 := 'Fixes #148: Drop function GetOfferForTicket as well as the column TicketId in the Table LicenseOrder. Update CreateLicenseOrder function';
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
			vPatchNumber int := 0021;
		BEGIN
-- #########################################################################################################################################

-- 1. Create Table UserKey
CREATE TABLE userkeys (useruuid uuid, keys int[]);
-- 2. Add Column Key and IsOwner to Function table
ALTER TABLE functions ADD COLUMN key int;
ALTER TABLE functions ADD COLUMN IsOwner boolean;
-- 2a. Insert values into function table
update functions set key = 1 where functionname = 'CreateLicenseOrder';
update functions set key = 2  where functionname = 'CreateOffer';
update functions set key = 3  where functionname = 'CreateOfferRequest';
update functions set key = 4  where functionname = 'CreatePaymentInvoice';
update functions set key = 5  where functionname = 'CreateRole';
update functions set key = 6  where functionname = 'CreateTechnology';
update functions set key = 7  where functionname = 'GetAllOffers';
update functions set key = 8  where functionname = 'GetAllUsers';
update functions set key = 9  where functionname = 'GetComponentsByTechnology';
update functions set key = 10  where functionname = 'GetComponentsForTechnologyDataId';
update functions set key = 11  where functionname = 'GetLicenseFeeByTechnologyData';
update functions set key = 12  where functionname = 'GetLicenseFeeByTransaction';
update functions set key = 13  where functionname = 'GetNewProductCode';
update functions set key = 14  where functionname = 'GetOfferById';
update functions set key = 15  where functionname = 'GetOfferByRequestId';
update functions set key = 16  where functionname = 'GetOfferForPaymentInvoice';
update functions set key = 17  where functionname = 'GetOfferForTicket';
update functions set key = 18  where functionname = 'GetOfferForTransaction';
update functions set key = 19  where functionname = 'GetOfferRequestById';
update functions set key = 20  where functionname = 'GetPaymentInvoiceForOfferRequest';
update functions set key = 21  where functionname = 'GetTechnologyDataByOfferRequest';
update functions set key = 22  where functionname = 'GetTechnologyDataOwnerById';
update functions set key = 23  where functionname = 'GetTechnologyForOfferRequest';
update functions set key = 24  where functionname = 'GetTransactionById';
update functions set key = 25  where functionname = 'GetTransactionByOfferRequest';
update functions set key = 26  where functionname = 'SetComponent';
update functions set key = 27  where functionname = 'SetPayment';
update functions set key = 28  where functionname = 'SetPaymentInvoiceOffer';
update functions set key = 29  where functionname = 'SetPermission';
-- 3. Insert IsOwner = true for functions
update functions set isowner =  true  where functionname = 'DeleteTechnologyData';
update functions set isowner =  true  where functionname = 'GetActivatedLicensesCountForUser';
update functions set isowner =  true  where functionname = 'GetAllAttributes';
update functions set isowner =  true  where functionname = 'GetAllOffers';
update functions set isowner =  true  where functionname = 'GetAllTags';
update functions set isowner =  true  where functionname = 'GetRevenue';
update functions set isowner =  true  where functionname = 'GetRevenueHistory';
update functions set isowner =  true  where functionname = 'GetRevenuePerForUSer';
update functions set isowner =  true  where functionname = 'GetTechnologyDataById';
update functions set isowner =  true  where functionname = 'GetTechnologyDataByName';
update functions set isowner =  true  where functionname = 'GetTechnologyDataByParams';
update functions set isowner =  true  where functionname = 'GetTechnologyDataForUser';
update functions set isowner =  true  where functionname = 'GetTechnologyDataHistory';
update functions set isowner =  true  where functionname = 'GetTopTechnologyData';
update functions set isowner =  true  where functionname = 'GetTotalUserRevenue';
update functions set isowner =  true  where functionname = 'GetWorkloadSinceForUser'; 

-- 4. Set keys for users
INSERT INTO userkeys (useruuid, keys) values ('86912144-2cf4-4071-a9c9-be2d42e67d6a','{6,7,8,9,10,11,14,15,16,17,18,20,21,22,23,24,25,29}'); -- Admin
INSERT INTO userkeys (useruuid, keys) values ('978f5a7e-d5c2-4591-80c6-8f85ea4872ce','{1,13,19,24,27}'); -- MarketplaceCoreUser
INSERT INTO userkeys (useruuid, keys) values ('5e5d4ebc-7985-45e4-93c2-ca5572b6947e','{2,3,4,7,8,9,10,11,14,15,16,18,20,21,23,25,28}'); -- MixerControl 
-- 5. Improve CheckPermissions Functions
DROP FUNCTION public.checkpermissions(text[], character varying);

CREATE OR REPLACE FUNCTION public.checkpermissions(
    vuseruuid uuid,
    vroles text[],
    vfunctionname character varying)
  RETURNS boolean AS
$BODY$
	#variable_conflict use_column
	DECLARE	vIsAllowed boolean;
		vFunctionId integer := (select functionId from functions where functionname = vFunctionName);
		vUserHasKey boolean;
		vKey int := (select key from functions where functionname = vFunctionName);
	BEGIN
		vIsAllowed := (select exists(select 1 from rolespermissions rp
									 join roles ro on ro.roleid = rp.roleid
									 where ro.rolename = ANY(vRoles)
									 and functionId = vFunctionId));

		vUserHasKey := (select case when (vKey is not null) then exists(select 1 from userkeys where vKey = ANY(keys) and useruuid = vUserUUID) else true end);									 

		
		if(vIsAllowed) then
			if(vUserHasKey) then
				return true;
				else return false;
			end if;
		else
			return false;
		end if;
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
 




