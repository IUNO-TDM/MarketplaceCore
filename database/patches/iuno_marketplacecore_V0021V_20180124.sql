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
	----------------------------------------------------------------------------------------------------------------------------------------

             DROP FUNCTION public.getofferforticket(character varying, uuid, text[]);

             ALTER TABLE licenseorder DROP COLUMN ticketid;

             DROP FUNCTION public.createlicenseorder(character varying, uuid, uuid, text[]);

             --##########################################################################################

            CREATE OR REPLACE FUNCTION public.createlicenseorder(
                IN vofferuuid uuid,
                IN vuseruuid uuid,
                IN vroles text[])
              RETURNS TABLE(licenseorderuuid uuid, offeruuid uuid, activatedat timestamp with time zone, createdat timestamp with time zone, createdby uuid) AS
            $BODY$
                #variable_conflict use_column
                  DECLARE 	vLicenseOrderID integer := (select nextval('LicenseOrderID'));
                            vLicenseOrderUUID uuid := (select uuid_generate_v4());
                            vOfferID integer := (select offerid from offer where offeruuid = vOfferUUID);
                            vTransactionID integer := (select transactionid from transactions where offerid = vOfferID);
                            vFunctionName varchar := 'CreateLicenseOrder';
                            vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

                BEGIN

                IF(vIsAllowed) THEN
                    INSERT INTO LicenseOrder(LicenseOrderID, LicenseOrderUUID, OfferID, ActivatedAt, CreatedBy, CreatedAt)
                    VALUES(vLicenseOrderID, vLicenseOrderUUID, vOfferID, now(), vUserUUID, now());

                    -- Update Transactions table
                    UPDATE Transactions SET LicenseOrderID = vLicenseOrderID, UpdatedAt = now(), UpdatedBy = vUserUUID
                    WHERE TransactionID = vTransactionID;

                    ELSE
                         RAISE EXCEPTION '%', 'Insufficiency rigths';
                         RETURN;
                    END IF;
                        -- Begin Log if success
                        perform public.createlog(0,'Created CreateLicenseOrder sucessfully', 'CreateLicenseOrder',
                                                'PaymentInvoiceID: ' || cast(vLicenseOrderID as varchar)
                                || ', OfferID: ' || cast(vOfferID as varchar)
                                || ', CreatedBy: ' || cast(vUserUUID as varchar));

                        -- End Log if success
                        -- Return
                        RETURN QUERY (
                        select 	LicenseOrderUUID,
                            vOfferUUID,
                            ActivatedAt at time zone 'utc',
                            CreatedAt at time zone 'utc',
                            vUserUUID
                        from licenseorder
                        where licenseorderuuid = vLicenseOrderUUID
                        );

                        exception when others then
                        -- Begin Log if error
                        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateLicenseOrder',
                                                'PaymentInvoiceID: ' || cast(vLicenseOrderID as varchar)
                                || ', OfferID: ' || cast(vOfferID as varchar)
                                || ', CreatedBy: ' || cast(vUserUUID as varchar));
                        -- End Log if error
                        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateLicenseOrder';
                        RETURN;
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