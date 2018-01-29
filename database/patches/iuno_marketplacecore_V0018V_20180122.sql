--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-01-22
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
--  Since the LicenseFee Data Type has been changed to big int, all functions using this columns must be adapted
-- 	2) Which Git Issue Number is this patch solving?
--  #
-- 	3) Which changes are going to be done?
--  Change Return value for diverse functions.
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0018V_20180122';
		PatchNumber int 		 	 := 0018;
		PatchDescription varchar 	 := 'Fixes #149: Distinguish between useruuid and clientuuid in offerrequest';
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
			vPatchNumber int := 0018;
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------

    DROP FUNCTION public.createofferrequest(jsonb, character varying, uuid, uuid, text[]);

--#############################################################################################################################################
    CREATE OR REPLACE FUNCTION public.createofferrequest(
        vitems jsonb,
        vhsmid character varying,
        vuseruuid uuid,
        vclientuuid uuid,
        vroles text[])
        RETURNS TABLE(result json)

    AS $BODY$

        #variable_conflict use_column
          DECLARE 	vOfferRequestItemID integer := (select nextval('OfferRequestItemID'));
            vOfferRequestID integer := (select nextval('OfferRequestID'));
            vOfferRequestUUID uuid := (select uuid_generate_v4());
            vTransactionID integer := (select nextval('TransactionID'));
            vTransactionUUID uuid := (select uuid_generate_v4());
            vFunctionName varchar := 'CreateOfferRequest';
            vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

        BEGIN

        IF(vIsAllowed) THEN
            INSERT INTO OfferRequest(OfferRequestID, OfferRequestUUID, HSMID, RequestedBy, CreatedAt)
            VALUES(vOfferRequestID, vOfferRequestUUID, vHSMID, vclientuuid, now());

            INSERT INTO Transactions(TransactionID, TransactionUUID, OfferRequestID, BuyerID, CreatedBy, CreatedAt)
            VALUES (vTransactionID, vTransactionUUID, vOfferRequestID, vclientuuid, vuseruuid, now());

            with items as (
                select 	vOfferRequestItemID as OfferRequestItemID, vOfferRequestID as offerrequestid,
                    (json_array_elements_text(vitems::json->'items')::json->>'dataId')::text as dataId,
                    (json_array_elements_text(vitems::json->'items')::json->'amount')::text as amount
                )
            insert into offerrequestitems(offerrequestitemid, offerrequestid,technologydataId,amount)
            select OfferRequestItemID, offerrequestid, td.technologydataid, amount::integer from items it
            join technologydata td on it.dataid::uuid = td.technologydatauuid;

        ELSE
             RAISE EXCEPTION '%', 'Insufficiency rigths';
             RETURN;
        END IF;
            -- Begin Log if success
            perform public.createlog(0,'Created OfferRequest sucessfully', 'CreateOfferRequest',
                                    'OfferRequestID: ' || cast(vOfferRequestID as varchar)
                    || ', Items: ' || cast(vItems as varchar)
                    || ', HSMID: ' || vHSMID);

            -- End Log if success
            -- Return OfferRequestUUID
            RETURN QUERY (
                    select row_to_json (t) as result from (
                        select offerrequestuuid,
                            (
                            select	 array_to_json(array_agg(row_to_json(d)))
                            from (select   td.TechnologyDataUUID::uuid,   oi.Amount
                                from offerrequest ofr
                                join offerrequestitems oi on oi.offerrequestid = ofr.offerrequestid
                                join technologydata td
                                on oi.technologydataid = td.technologydataid
                                where offerrequestuuid = vOfferRequestUUID
                                ) d
                             ) as items, HSMID, CreatedAt at time zone 'utc' as CreatedAt, RequestedBy
                         from offerrequest where offerrequestuuid = vOfferRequestUUID) t
            );

            exception when others then
            -- Begin Log if error
            perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateOfferRequest',
                                    'OfferRequestID: ' || cast(vOfferRequestID as varchar)
                    || ', Items: ' || cast(vItems as varchar)
                    || ', HSMID: ' || vHSMID);
            -- End Log if error
            RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateOfferRequest';
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