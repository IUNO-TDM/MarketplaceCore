--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-09-12
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
--  JMW gallery needs additional permissions for public role
--  Core log is full of errors caused by duplicated entries in Payment Table
-- 	2) Which Git Issue Number is this patch solving?
--  #220
-- 	3) Which changes are going to be done?
--  Updated permissions for public role
--  Updating unique constraint on payment table and deleting duplicated entries
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0055V_20180912';
		PatchNumber int 		 	 := 0055;
		PatchDescription varchar 	 := 'Updated permissions for public role, removed duplicates in payment table, added unique constraints to payment table';
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
    vPatchNumber int := 0055;
BEGIN
-- #########################################################################################################################################

---
--- UPDATE PUBLIC PERMISSIONS
---

perform public.setpermission('{Public}','GetComponentsForTechnologyDataId',null,'{Admin}');
perform public.setpermission('{Public}','GetComponentAttributesForTechnologyData',null,'{Admin}');

--
-- DELETE orphan payments as they are duplicates and add unique constraint
--

DELETE FROM payment WHERE paymentid NOT IN (SELECT paymentid FROM transactions WHERE paymentid IS NOT NULL);
ALTER TABLE payment ADD CONSTRAINT uniqueExtInvoiceId UNIQUE (extinvoiceid);
ALTER TABLE payment ADD CONSTRAINT uniquePaymentInvoiceId UNIQUE (paymentinvoiceid);


----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;