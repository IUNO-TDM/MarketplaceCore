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
--  Enhance the database access control
-- 	2) Which Git Issue Number is this patch solving?
--  #127
-- 	3) Which changes are going to be done?
--  Update all functions due to the checkpermissions update.
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0022V_20180126';
		PatchNumber int 		 	 := 0022;
		PatchDescription varchar 	 := 'Update all functions due to the checkpermissions update.';
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
			vPatchNumber int := 0022;
		BEGIN
-- #########################################################################################################################################

CREATE OR REPLACE FUNCTION public.createattribute(
    IN vattributename character varying,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(attributeuuid uuid, attributename character varying, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vAttributeID integer := (select nextval('AttributeID'));
		vAttributeUUID uuid := (select uuid_generate_v4());
		vFunctionName varchar := 'CreateAttribute';
		vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));
      BEGIN

	IF(vIsAllowed) THEN
		INSERT INTO public.Attributes(AttributeID, AttributeUUID, AttributeName, CreatedBy, CreatedAt)
		VALUES(vAttributeID, vAttributeUUID, vAttributeName, vCreatedBy, now());
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- Begin Log if success
        perform public.createlog(0,'Created Attribute sucessfully', 'CreateAttribute',
                                'AttributeID: ' || cast(vAttributeID as varchar)
				|| ', AttributeName: ' || vAttributeName
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select	AttributeUUID,
			AttributeName,
			CreatedAt at time zone 'utc',
			vCreatedby
		from attributes
		where attributeuuid = vAttributeUUID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,'CreateAttribute',
                                'AttributeID: ' || cast(vAttributeID as varchar)
				|| ', AttributeName: ' || vAttributeName
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateAttribute';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;

 -- #########################################################################################################################################

 CREATE OR REPLACE FUNCTION public.createcomponent(
    IN vcomponentparentuuid uuid,
    IN vcomponentname character varying,
    IN vcomponentdescription character varying,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentname character varying, componentparentuuid uuid, componentdecription character varying, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vComponentID integer := (select nextval('ComponentID'));
		vComponentUUID uuid := (select uuid_generate_v4());
		vComponentParentID integer := (select componentid from components where componentuuid = vComponentParentUUID);
		vFunctionName varchar := 'CreateComponent';
		vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));
      BEGIN

	IF(vIsAllowed) THEN

        INSERT INTO components(ComponentID, ComponentUUID, ComponentParentID, ComponentName, ComponentDescription, CreatedBy, CreatedAt)
        VALUES(vComponentID, vComponentUUID, vComponentParentID, vComponentName, vComponentDescription, vCreatedBy, now());

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- Begin Log if success
        perform public.createlog(0,'Created Component sucessfully', 'CreateComponent',
                                'ComponentID: ' || cast(vComponentID as varchar) || ', '
                                || 'ComponentParentID: ' || cast(vComponentParentID as varchar)
                                || ', ComponentName: '
                                || vComponentName
                                || ', ComponentDescription: '
                                || vComponentDescription
                                || ', CreatedBy: '
                                || cast(vCreatedBy as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	co.ComponentUUID,
			co.ComponentName,
			cs.ComponentName as componentParentName,
			cs.ComponentUUID as componentParentUUID,
			co.ComponentDescription,
			co.CreatedAt at time zone 'utc',
			vCreatedBy
		from components co
		left outer join components cs
		on co.componentparentid = cs.componentid
		where co.componentuuid = vComponentUUID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponent',
                                'ComponentID: ' || cast(vComponentID as varchar) || ', '
                                || 'ComponentParentID: ' || cast(vComponentParentID as varchar)
                                || ', ComponentName: '
                                || vComponentName
                                || ', ComponentDescription: '
                                || vComponentDescription
                                || ', CreatedBy: '
                                || cast(vCreatedBy as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateComponent';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;

 -- #########################################################################################################################################
 
DROP FUNCTION public.createcomponentsattribute(uuid, text[], text[]);

 CREATE OR REPLACE FUNCTION public.createcomponentsattribute(
    IN vcomponentuuid uuid,
    IN vattributelist text[],
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, attributelist uuid[]) AS
$BODY$
	#variable_conflict use_column
  	DECLARE vAttributeName text;
		vAttrID int;
		vComponentID integer := (select componentid from components where componentuuid = vComponentUUID);
		vFunctionName varchar := 'CreateComponentsAttribute';
		vIsAllowed boolean := (select public.checkPermissions(vUserUUID, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN
        FOREACH vAttributeName in array vAttributeList
        LOOP
        	 vAttrID := (select attributes.attributeID from public.attributes where attributename = vAttributeName);
         	 INSERT INTO ComponentsAttribute(ComponentID, AttributeID)
             VALUES (vComponentID, vAttrID);
        END LOOP;

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- Begin Log if success
        perform public.createlog(0,'Created relation from component to attributes sucessfully', 'CreateComponentsAttribute',
                                'ComponentID: ' || cast(vComponentID as varchar)
                                || ', AttributeList: '
                                || cast(vAttributeList as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	vComponentUUId,
				array_agg(att.AttributeUUID)
		from componentsattribute ca
		join attributes att
		on ca.attributeid = att.attributeid
		where componentid = vComponentID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponentsAttribute',
                                'ComponentID: ' || cast(vComponentID as varchar)
                                || ', AttributeList: '
                                || cast(vAttributeList as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateComponentsAttribute';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;

 -- #########################################################################################################################################

DROP FUNCTION public.createcomponentstechnologies(uuid, text[], text[]);

CREATE OR REPLACE FUNCTION public.createcomponentstechnologies(
    IN vcomponentuuid uuid,
    IN vtechnologylist text[],
    IN vUserUUID uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, technologylist uuid[]) AS
$BODY$
	#variable_conflict use_column
    DECLARE 	vTechName text;
		vTechID integer;
		vComponentID integer := (select componentid from components where componentuuid = vComponentUUID);
		vFunctionName varchar := 'CreateComponentsTechnologies';
		vIsAllowed boolean := (select public.checkPermissions(vUserUUID, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN
		FOREACH vTechName in array vTechnologyList
		LOOP
			vTechID := (select technologyid from technologies where technologyname = vTechName);
			 INSERT INTO ComponentsTechnologies(ComponentID, TechnologyID)
		     VALUES (vComponentID, vTechID);
		END LOOP;

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- Begin Log if success
        perform public.createlog(0,'Created relation from component to attributes sucessfully', 'CreateComponentsTechnologies',
                                'ComponentID: ' || cast(vComponentID as varchar)
                                || ', TechnologyList: '
                                || cast(vTechnologyList as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	vComponentUUID,
			array_agg(technologyUUID)
		from componentstechnologies ct
		join technologies th on ct.technologyid = th.technologyid
		where componentid = vComponentID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponentsTechnologies',
                                'ComponentID: ' || cast(vComponentID as varchar)
                                || ', TechnologyList: '
                                || cast(vTechnologyList as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateComponentsTechnologies';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
 
-- #########################################################################################################################################

 CREATE OR REPLACE FUNCTION public.createlicenseorder(
    IN vticketid character varying,
    IN vofferuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(licenseorderuuid uuid, ticketid character varying, offeruuid uuid, activatedat timestamp with time zone, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 			vLicenseOrderID integer := (select nextval('LicenseOrderID'));
				vLicenseOrderUUID uuid := (select uuid_generate_v4());
				vOfferID integer := (select offerid from offer where offeruuid = vOfferUUID);
				vTransactionID integer := (select transactionid from transactions where offerid = vOfferID);
				vFunctionName varchar := 'CreateLicenseOrder';
				vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN
		INSERT INTO LicenseOrder(LicenseOrderID, LicenseOrderUUID, TicketID, OfferID, ActivatedAt, CreatedBy, CreatedAt)
		VALUES(vLicenseOrderID, vLicenseOrderUUID, vTicketID, vOfferID, now(), vUserUUID, now());

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
				|| ', TicketID: ' || vTicketID
				|| ', OfferID: ' || cast(vOfferID as varchar)
				|| ', CreatedBy: ' || cast(vUserUUID as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	LicenseOrderUUID,
			TicketID,
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
				|| ', TicketID: ' || vTicketID
				|| ', OfferID: ' || cast(vOfferID as varchar)
				|| ', CreatedBy: ' || cast(vUserUUID as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateLicenseOrder';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;

-- #########################################################################################################################################

CREATE OR REPLACE FUNCTION public.createoffer(
    IN vpaymentinvoiceuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(offeruuid uuid, paymentinvoiceuuid uuid, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vOfferID integer := (select nextval('OfferID'));
		vOfferUUID uuid := (select uuid_generate_v4());
		vPaymentInvoiceID integer := (select paymentinvoiceid from paymentinvoice where paymentinvoiceuuid = vPaymentInvoiceUUID);
		vTransactionID integer := (select transactionid from transactions where paymentinvoiceid = vPaymentInvoiceID);
		vFunctionName varchar := 'CreateOffer';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

		INSERT INTO Offer(OfferID, OfferUUID, PaymentInvoiceID, CreatedBy, CreatedAt)
		VALUES(vOfferID, vOfferUUID, vPaymentInvoiceID, vUserUUID, now());

		-- Update Transactions table
		UPDATE Transactions SET OfferId = vOfferID, UpdatedAt = now(), UpdatedBy = vUserUUID
		WHERE TransactionID = vTransactionID;

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- Begin Log if success
        perform public.createlog(0,'Created Offer sucessfully', 'CreateOffer',
                                'OfferID: ' || cast(vOfferID as varchar)
				|| ', PaymentInvoiceUUID: ' || cast(vPaymentInvoiceUUID as varchar)
				|| ', CreatedBy: ' || cast(vUserUUID as varchar));

        -- End Log if success
        -- Return vOfferUUID
        RETURN QUERY (
		select 	OfferUUID,
			vPaymentInvoiceUUID,
			CreatedAt at time zone 'utc',
			vUserUUID
		from offer where offeruuid = vOfferUUID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateOffer',
                                'OfferID: ' || cast(vOfferID as varchar)
				|| ', PaymentInvoiceUUID: ' || cast(vPaymentInvoiceUUID as varchar)
				|| ', CreatedBy: ' || cast(vUserUUID as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateOffer';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
  
-- #########################################################################################################################################

CREATE OR REPLACE FUNCTION public.createofferrequest(
    IN vitems jsonb,
    IN vhsmid character varying,
    IN vuseruuid uuid,
    IN vclientuuid uuid,
    IN vroles text[])
  RETURNS TABLE(result json) AS
$BODY$

        #variable_conflict use_column
          DECLARE 	vOfferRequestItemID integer := (select nextval('OfferRequestItemID'));
            vOfferRequestID integer := (select nextval('OfferRequestID'));
            vOfferRequestUUID uuid := (select uuid_generate_v4());
            vTransactionID integer := (select nextval('TransactionID'));
            vTransactionUUID uuid := (select uuid_generate_v4());
            vFunctionName varchar := 'CreateOfferRequest';
            vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

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

-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.createpaymentinvoice(
    IN vinvoice character varying,
    IN vofferrequestuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(paymentinvoiceuuid uuid, offerrequestuuid uuid, invoice character varying, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
	DECLARE vPaymentInvoiceID integer := (select nextval('PaymentInvoiceID'));
		vPaymentInvoiceUUID uuid := (select uuid_generate_v4());
		vOfferReqID integer := (select offerrequestid from offerrequest where offerrequestuuid = vOfferRequestUUID);
		vTransactionID integer := (select transactionid from transactions where offerrequestid = vOfferReqID);
		vFunctionName varchar := 'CreatePaymentInvoice';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN
		INSERT INTO PaymentInvoice(PaymentInvoiceID, PaymentInvoiceUUID, OfferRequestID, Invoice, CreatedBy, CreatedAt)
		VALUES(vPaymentInvoiceID, vPaymentInvoiceUUID, vOfferReqID, vInvoice, vUserUUID, now());

		-- Update Transactions table
		UPDATE Transactions SET PaymentInvoiceID = vPaymentInvoiceID, UpdatedAt = now(), UpdatedBy = vUserUUID
		WHERE TransactionID = vTransactionID;

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- Begin Log if success
        perform public.createlog(0,'Created PaymentInvoice sucessfully', 'CreatePaymentInvoice',
                                'PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar)
				|| ', OfferRequestID: ' || cast(vOfferReqID as varchar)
				|| ', Invoice: ' || coalesce(vInvoice, 'Empty')
				|| ', CreatedBy: ' || cast(vuseruuid as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select	pi.PaymentInvoiceUUID,
			oq.OfferRequestUUID,
			pi.Invoice,
			pi.CreatedAt at time zone 'utc',
			pi.CreatedBy
		from paymentinvoice pi
		join offerrequest oq
		on pi.offerrequestid = oq.offerrequestid
		where pi.paymentinvoiceuuid = vPaymentInvoiceUUID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'CreatePaymentInvoice',
                                'PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar)
				|| ', OfferRequestID: ' || cast(vOfferReqID as varchar)
				|| ', Invoice: ' || coalesce(vInvoice, 'Empty')
				|| ', CreatedBy: ' || cast(vuseruuid as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreatePaymentInvoice';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.createrole(
    vroles text[],
    vroledescription character varying,
    vuseruuid uuid,
    vrolesuser text[])
  RETURNS void AS
$BODY$
	Declare vRoleID integer;
		vFunctionName varchar := 'CreateRole';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRolesUser, vFunctionName));
		vRoleName varchar;

	BEGIN
		if(vIsAllowed) then
			FOREACH vRoleName in array vRoles LOOP
				vRoleID := (select nextval('RoleID'));
				insert into roles (RoleID, RoleName, RoleDescription)
				values (vRoleID, vRoleName, vRoleDescription);
			END LOOP;
		else
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
		end if;

	 -- Begin Log if success
        perform public.createlog(0,'Created Role sucessfully', 'CreateRole',
                                'RoleID: ' || cast(vRoleID as varchar)
                                || ', vRoles: ' || cast(vRoles as varchar)
                                || ', RoleDescription: '
                                || vRoleDescription);

	 exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'CreateRole',
                                'RoleID: ' || cast(vRoleID as varchar)
                                || ', vRoles: ' || cast(vRoles as varchar)
                                || ', RoleDescription: '
                                || vRoleDescription);
        -- End Log if error
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateRole';
		RETURN;
	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.createtag(
    IN vtagname character varying,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(taguuid uuid, tagname character varying, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vTagID integer := (select nextval('TagID'));
		vTagUUID uuid := (select uuid_generate_v4());
		vFunctionName varchar := 'CreateTag';
		vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));
      BEGIN

	IF(vIsAllowed) THEN
		INSERT INTO Tags(TagID, TagUUID, TagName, CreatedBy, CreatedAt)
		VALUES(vTagID, vTagUUID, vTagName, vCreatedBy, now());
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

        -- Begin Log if success
        perform public.createlog(0,'Created Tag sucessfully', 'CreateTag',
                                'TagID: ' || cast(vTagID as varchar)
				|| ', TagName: ' || vTagName
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	TagUUID,
			TagName,
			CreatedAt at time zone 'utc',
			vCreatedBy
		from tags tg
		where taguuid = vTagUUID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'CreateTag',
                                'TagID: ' || cast(vTagID as varchar)
				|| ', TagName: ' || vTagName
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTag';
       RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.createtechnology(
    IN vtechnologyname character varying,
    IN vtechnologydescription character varying,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(technologyuuid uuid, technologyname character varying, technologydescription character varying, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vTechnologyID integer := (select nextval('TechnologyID'));
		vTechnologyUUID uuid := (select uuid_generate_v4());
		vFunctionName varchar := 'CreateTechnology';
		vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));

      BEGIN

	IF(vIsAllowed) THEN
		INSERT INTO Technologies(TechnologyID, TechnologyUUID, TechnologyName, TechnologyDescription, CreatedBy, CreatedAt)
		VALUES(vTechnologyID, vTechnologyUUID, vTechnologyName, vTechnologyDescription, vCreatedby, now());

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- Begin Log if success
        perform public.createlog(0,'Created Technology sucessfully', 'CreateTechnology',
                                'TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', TechnologyName: '
                                || vTechnologyName
                                || ', TechnologyDescription: '
                                || vTechnologyDescription
                                || ', CreatedBy: '
                                || cast(vCreatedby as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	TechnologyUUID,
			TechnologyName,
			TechnologyDescription,
			CreatedAt at time zone 'utc',
			vCreatedBy
		from technologies
		where technologyuuid = vTechnologyUUID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTechnology',
                                'TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', TechnologyName: '
                                || vTechnologyName
                                || ', TechnologyDescription: '
                                || vTechnologyDescription
                                || ', CreatedBy: '
                                || cast(vCreatedby as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTechnology';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.createtechnologydata(
    IN vtechnologydataname character varying,
    IN vtechnologydata character varying,
    IN vtechnologydatadescription character varying,
    IN vlicensefee integer,
    IN vproductcode integer,
    IN vtechnologyuuid uuid,
    IN vtechnologydataimgref text,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, productcode integer, licensefee bigint, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vTechnologyDataID integer := (select nextval('TechnologyDataID'));
		vTechnologyDataUUID uuid := (select uuid_generate_v4());
		vTechnologyID integer := (select technologyid from technologies where technologyuuid = vTechnologyUUID);
		vFunctionName varchar := 'CreateTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));

      BEGIN
	IF(vIsAllowed) then
		INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, ProductCode, TechnologyID, technologydataimgref, CreatedBy, CreatedAt)
        VALUES(vTechnologyDataID, vTechnologyDataUUID, vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, vTechnologyID, vtechnologydataimgref, vCreatedBy, now());
	else
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	end if;

        -- Begin Log if success
        perform public.createlog(0,'Created TechnologyData sucessfully', 'CreateTechnologyData',
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: '
                                || replace(vTechnologyDataName, '''', '''''') || ', TechnologyData: ' || vTechnologyData
                                || ', TechnologyDataDescription: ' || replace(vTechnologyDataDescription, '''', '''''')
				-- || ', vTechnologyDataAuthor: ' || cast(vTechAuthor as varchar)
                                || ', TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', LicenseFee: ' || cast(vLicenseFee as varchar)
                                || ', ProductCode: ' || cast(vProductCode as varchar)
                                || ', CreatedBy: ' || vCreatedBy);

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	td.TechnologyDataUUID,
			td.TechnologyDataName,
			tc.TechnologyUUID,
			td.TechnologyData,
			td.ProductCode,
			td.LicenseFee,
			td.TechnologyDataDescription,
			td.TechnologyDataThumbnail,
			td.TechnologyDataImgRef,
			td.CreatedAt at time zone 'utc',
			vCreatedby as CreateBy
		from technologydata td
		join technologies tc on
		td.technologyid = tc.technologyid
		where td.technologydatauuid = vTechnologyDataUUID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTechnologyData',
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: '
                                || replace(vTechnologyDataName, '''', '''''') || ', TechnologyData: ' || vTechnologyData
                                || ', TechnologyDataDescription: ' || replace(vTechnologyDataDescription, '''', '''''')
				-- || ', vTechnologyDataAuthor: ' || cast(vTechAuthor as varchar)
                                || ', TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', LicenseFee: ' || cast(vLicenseFee as varchar)
                                || ', ProductCode: ' || cast(vProductCode as varchar)
                                || ', CreatedBy: ' || vCreatedBy);
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTechnologyData';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
DROP FUNCTION public.createtechnologydatacomponents(uuid, text[], text[]);

CREATE OR REPLACE FUNCTION public.createtechnologydatacomponents(
    IN vtechnologydatauuid uuid,
    IN vcomponentlist text[],
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, componentlist uuid[]) AS
$BODY$
	#variable_conflict use_column
  	DECLARE vCompUUID uuid;
		vCompID integer;
		vTechnologyDataID integer := (select technologydataid from technologydata where technologydatauuid = vTechnologyDataUUID);
		vFunctionName varchar := 'CreateTechnologyDataComponents';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

      BEGIN
	IF(vIsAllowed) THEN
		FOREACH vCompUUID in array vComponentList
		LOOP
			vCompID := (select componentID from components where componentUUID = vCompUUID);

			INSERT INTO TechnologyDataComponents(technologydataid, componentid)
			VALUES (vTechnologyDataID, vCompID);
		END LOOP;
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- Begin Log if success
        perform public.createlog(0,'Created relation from Componets to TechnologyData sucessfully', 'CreateTechnologyDataComponents',
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar)
                                || ', ComponentList: ' || cast(vComponentList as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	vTechnologyDataUUID,
			array_agg(ComponentUUID)
		from technologydatacomponents tc join
		components co on tc.componentid = co.componentid
		where technologydataid = vTechnologyDataID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,'CreateTechnologyDataComponents',
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar)
                                || ', ComponentList: ' || cast(vComponentList as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTechnologyDataComponents';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.createtechnologydatatags(
    IN vtechnologydatauuid uuid,
    IN vtaglist text[],
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, taglist uuid[]) AS
$BODY$
	#variable_conflict use_column
  	DECLARE vTagName text;
		vtagID integer;
		vTechnologyDataID integer := (select technologydataid from technologydata where technologydatauuid = vTechnologyDataUUID);
		vFunctionName varchar := 'CreateTechnologyDataTags';
		vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));
      BEGIN

	IF(vIsAllowed) THEN
		FOREACH vTagName in array vTagList
		LOOP
			 vtagID := (select tags.tagID from tags where tagName = vTagName);
			 INSERT INTO TechnologyDataTags(TechnologyDataID, tagID)
				VALUES (vTechnologyDataID, vtagID);

		END LOOP;
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

        -- Begin Log if success
        perform public.createlog(0,'Created relation from Tags to TechnologyData sucessfully', 'CreateTechnologyDataTags',
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar)
                                || ', TagList: '
                                || cast(vTagList as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
		select  vTechnologyDataUUID,
			array_agg(taguuid)
		from technologydatatags td
		join tags tg on td.tagid = tg.tagid
		where td.technologydataid = vTechnologyDataID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE || cast(vtagID as varchar), 'CreateTechnologyDataTags',
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar)
                                || ', TagList: '
                                || cast(vTagList as varchar));
        -- End Log if error
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTechnologyDataTags';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.deletetechnologydata(
    vtechnologydatauuid uuid,
    vuseruuid uuid,
    vroles text[])
  RETURNS boolean AS
$BODY$

	DECLARE
		vFunctionName varchar := 'DeleteTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));
		vOwnerUUID uuid := (select createdby from technologydata where technologydatauuid = vTechnologyDataUUID);

	BEGIN

	IF(vIsAllowed) THEN

		IF (vUserUUID = vOwnerUUID) THEN

		 update technologydata set deleted = true
		 where technologydatauuid = vTechnologyDataUUID
		 and createdby = vuseruuid;

		 ELSE

			 RAISE EXCEPTION '%', 'You are not allowed to delete this technologydata.';
			 RETURN false;

		 END IF;

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN false;
	END IF;

	-- Begin Log if success
		perform public.createlog(0,'Delete TechnologyData successfull', 'DeleteTechnologyData',
								'TechnologyDataID: ' || cast(vtechnologydatauuid as varchar));

		-- End Log if success
		RETURN true;
	 -- Begin Log if error
		perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'DeleteTechnologyData',
								'TechnologyDataID: ' || cast(vtechnologydatauuid as varchar));
		-- End Log if error
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTechnologyDataComponents';
	RETURN false;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getactivatedlicensescountforuser(
    vuseruuid uuid,
    vinquereid uuid,
    vroles text[])
  RETURNS integer AS
$BODY$
				#variable_conflict use_column
				DECLARE vFunctionName varchar := 'GetActivatedLicensesCountForUser';
					vIsAllowed boolean := (select public.checkPermissions(vinquereid, vRoles, vFunctionName));

				BEGIN

					IF(vIsAllowed) THEN
						RETURN (select sum(amount) from transactions ts
							join licenseorder lo
							on ts.licenseorderid = lo.licenseorderid
							join offerrequest oq
							on oq.offerrequestid = ts.offerrequestid
							join offerrequestitems ri
							on ri.offerrequestid = oq.offerrequestid
							join technologydata td			
							on ri.technologydataid = td.technologydataid 	
							where td.createdby = vuseruuid);

					ELSE
						 RAISE EXCEPTION '%', 'Insufficiency rigths';
						 RETURN NULL;
					END IF;
				  
				END;
			  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getallattributes(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(attributeuuid uuid, attributename character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetAllAttributes';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY	(SELECT  attributeuuid,
				attributename,
				att.createdat at time zone 'utc',
				att.createdby,
				att.updatedat at time zone 'utc',
				att.updatedby
			FROM attributes att
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getallcomponents(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid integer, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetAllComponents';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));
		vRoot varchar := 'Root';

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  cp.componentuuid,
			cp.componentname,
			cp.componentparentid,
			cp.componentdescription,
			cp.createdat  at time zone 'utc',
			cp.createdby,
			cp.updatedat  at time zone 'utc',
			cp.updatedby
			FROM Components cp
			WHERE cp.componentname != vRoot
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getalloffers(
    IN vuseruuid character varying,
    IN vroles text[])
  RETURNS TABLE(offeruuid uuid, paymentinvoiceuuid uuid, createdat timestamp with time zone, createdby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetAllOffers';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  offeruuid,
				paymentinvoiceuuid,
				offr.createdat at time zone 'utc',
				offr.createdby
			FROM offer offr JOIN
			paymentinvoice pi ON offr.paymentinvoiceid = pi.paymentinvoiceid
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getalltags(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(taguuid uuid, tagname character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetAllTags';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  taguuid,
				tagname,
				tg.createdat  at time zone 'utc',
				tg.createdby,
				tg.updatedat  at time zone 'utc',
				tg.updatedby
		    FROM tags tg
		  );

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getalltechnologies(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologyuuid uuid, technologyname character varying, technologydescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetAllTechnologies';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  technologyuuid,
				technologyname,
				technologydescription,
				tg.createdat at time zone 'utc',
				tg.createdby,
				tg.updatedat at time zone 'utc',
				tg.updatedby
		    FROM Technologies tg
		 );

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getalltechnologydata(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid) AS
$BODY$
	DECLARE vFunctionName varchar := 'GetAllTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

		RETURN QUERY (SELECT 	technologydatauuid,
					tc.technologyuuid,
					td.technologydataname,
					technologydata,
					technologydatadescription,
					licensefee,
					td.productcode,
					technologydatathumbnail,
					technologydataimgref,
					td.createdat  at time zone 'utc',
					td.createdBy,
					td.updatedat  at time zone 'utc',
					td.UpdatedBy
			FROM TechnologyData td
			join technologies tc
			on td.technologyid = tc.technologyid
			);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
	$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getattributebyid(
    IN vattruuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(attributeuuid uuid, attributename character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetAttributeById';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY	(SELECT  attributeuuid,
				attributename,
				att.createdat at time zone 'utc',
				att.createdby,
				att.updatedat at time zone 'utc',
				att.updatedby
			FROM attributes att
			WHERE attributeUUID = vAttrUUID
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getattributebyname(
    IN vattrname character varying,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(attributeuuid uuid, attributename character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetAttributeByName';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY	(SELECT  attributeuuid,
				attributename,
				att.createdat at time zone 'utc',
				att.createdby,
				att.updatedat at time zone 'utc',
				att.updatedby
			FROM attributes att
			WHERE attributeName = vAttrName
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getcomponentbyid(
    IN vcompuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid uuid, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetComponentById';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  cp.componentuuid,
				cp.componentname,
				cs.componentuuid,
				cp.componentdescription,
				cp.createdat  at time zone 'utc',
				cp.createdby,
				cp.updatedat  at time zone 'utc',
				cp.updatedby
		    FROM Components cp
		    left outer join components cs on
		    cp.componentparentid = cs.componentid
		    WHERE cp.componentuuid = vCompUUID
		  );
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getcomponentbyname(
    IN vcompname character varying,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid integer, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetComponentByName';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  	componentuuid,
				cp.componentname,
				cp.componentparentid,
				cp.componentdescription,
				cp.createdat  at time zone 'utc',
				cp.createdby,
				cp.updatedat  at time zone 'utc',
				cp.updatedby
		    FROM Components cp
		    WHERE cp.componentname = vCompName
		 );

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getcomponentsbytechnology(
    IN vtechnologyuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid uuid, componentparentname character varying, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetComponentsByTechnology';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select 	co.componentUUID,
			co.componentName,
			cs.componentUUID as componentParentUUID,
			cs.componentName as componentParentName,
			co.componentDescription,
			co.createdat at time zone 'utc',
			co.createdby,
			co.updatedat at time zone 'utc',
			co.updatedby
			from components co
			join componentstechnologies ct
			on co.componentid = ct.componentid
			join technologies tc
			on tc.technologyid = ct.technologyid
			left outer join components cs
			on co.componentparentid = cs.componentid
			where tc.technologyuuid = vTechnologyUUID
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getcomponentsfortechnologydataid(
    IN vtechnologydatauuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid uuid, componentparentname character varying, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetComponentsForTechnologyDataId';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select	co.componentuuid,
				co.componentname,
				cp.componentuuid as ComponentParentUUID,
				cp.componentname as ComponentParentName,
				co.componentDescription,
				co.createdat at time zone 'utc',
				td.CreatedBy,
				co.updatedat at time zone 'utc',
				td.UpdatedBy
			from technologydata td
			join technologydatacomponents tc
			on td.technologydataid = tc.technologydataid
			join components co on
			co.componentid = tc.componentid
			join components cp on
			co.componentparentid = cp.componentid
			where td.technologydatauuid = vTechnologyDataUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
	$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getlicensefeebytechnologydata(
    IN vtechnologydatauuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(licensefee bigint) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetLicenseFeeByTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select	td.licenseFee
			from technologydata td
			where td.technologydatauuid = vTechnologyDataUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getlicensefeebytransaction(
    IN vtransactionuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(licensefee bigint) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetLicenseFeeByTransaction';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select	td.licenseFee
			from transactions ts
			join offerrequest oq
			on oq.offerrequestid = ts.offerrequestid
			join offerrequestitems ri
			on oq.offerrequestid = ri.offerrequestid
			join technologydata td
			on ri.technologydataid = td.technologydataid
			where ts.transactionuuid = vTransactionUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
DROP FUNCTION public.getnewproductcode(text[]);

CREATE OR REPLACE FUNCTION public.getnewproductcode(vuseruuid uuid, vroles text[])
  RETURNS SETOF integer AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetNewProductCode';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN
		IF(vIsAllowed) then
			RETURN QUERY (select nextval('ProductCode')::integer);
		else
			RAISE EXCEPTION '%', 'Insufficiency rigths';
			RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getofferbyid(
    IN vofferid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(offeruuid uuid, paymentinvoiceuuid uuid, createdat timestamp with time zone, createdby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetOfferById';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  ofr.offeruuid,
				pm.paymentinvoiceuuid,
				ofr.createdat at time zone 'utc',
				ofr.createdby
			FROM offer ofr
			JOIN paymentinvoice pm
			ON ofr.paymentinvoiceid = pm.paymentinvoiceid
			WHERE ofr.offeruuid = vOfferID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getofferforticket(
    IN vticketid character varying,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(offeruuid uuid, paymentinvoiceuuid uuid, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetOfferForTicket';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select 	ofr.offerUUID,
				pi.PaymentInvoiceUUID,
				pi.createdat at time zone 'utc',
				ofr.createdby
			from Offer ofr
			join paymentinvoice pi
			on ofr.paymentinvoiceid = pi.paymentinvoiceid
			join licenseorder lo
			on lo.offerid = ofr.offerid
			and lo.ticketid = vTicketID

		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getofferfortransaction(
    IN vtransactionuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(offeruuid uuid, paymentinvoiceuuid uuid, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetOfferForTransaction';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select 	ofr.offerUUID,
				pi.PaymentInvoiceUUID,
				pi.createdat at time zone 'utc',
				ofr.createdby
			from Offer ofr
			join paymentinvoice pi
			on ofr.paymentinvoiceid = pi.paymentinvoiceid
			join transactions ts
			on ts.offerid = ofr.offerid
			and ts.transactionuuid = vTransactionUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getofferrequestbyid(
    IN vofferrequestuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(result json) AS
$BODY$
	declare
		vFunctionName varchar := 'GetOfferRequestById';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN
	 RETURN QUERY (select row_to_json (t) as result from (
			select offerrequestuuid,
			(
			select	 array_to_json(array_agg(row_to_json(d)))
			from (select   td.TechnologyDataUUID::uuid,   oi.Amount, td.ProductCode
				from offerrequest ofr
				join offerrequestitems oi
				on oi.offerrequestid = ofr.offerrequestid
				join technologydata td
				on oi.technologydataid = td.technologydataid
				where offerrequestuuid = vOfferRequestUUID
				) d
			 ) as items, HSMID, CreatedAt at time zone 'utc' as CreatedAt, RequestedBy
		 from offerrequest where offerrequestuuid = vOfferRequestUUID) t
		 );
	ELSE
			RAISE EXCEPTION '%', 'Insufficiency rigths';
			RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getpaymentinvoiceforofferrequest(
    IN vofferrequestuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(paymentinvoiceuuid uuid, offerrequestuuid uuid, invoice character varying, createdat timestamp with time zone, createdby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetPaymentInvoiceForOfferRequest';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select 	pi.paymentinvoiceuuid,
							oq.offerrequestuuid,
							pi.invoice,
							pi.createdat at time zone 'utc',
							pi.createdby
				from PaymentInvoice pi
				join offerrequest oq
				on pi.offerrequestid = oq.offerrequestid
				where oq.offerRequestUUID = vOfferRequestUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getrevenue(
    IN vfrom timestamp with time zone,
    IN vto timestamp with time zone,
    IN vtechnologydatauuid uuid,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(year text, month text, day text, hour text, technologydatauuid uuid, amount integer, revenue bigint, average bigint) AS
$BODY$

			DECLARE
				vFunctionName varchar := 'GetRevenue';
				vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName)); 				
				vPublic text := (select t from unnest(vRoles) as t limit 1);

			BEGIN

			IF(vIsAllowed) THEN

			IF(vPublic = 'Public') THEN vCreatedBy := null; END IF;

			RETURN QUERY ( with revenue as (
				select  case when (to_char(activatedat,'YYYY') is null) then '0' else to_char(activatedat,'YYYY') end as Year,
					case when (to_char(activatedat,'MM') is null) then '0' else to_char(activatedat,'MM') end as Month, 
					case when (to_char(activatedat,'DD') is null) then '0' else to_char(activatedat,'DD') end as Day, 
					case when (to_char(activatedat,'HH24') is null) then '0' else to_char(activatedat,'HH24') end as Hour, 					
					coalesce(td.technologydatauuid,'00000000-0000-0000-0000-000000000000') as technologydatauuid, 
					sum(ri.amount) as amount, 
					(sum(td.licensefee*ri.amount))::bigint as revenue,
					(AVG(td.licensefee*ri.amount))::bigint as average	
				from transactions ts
					join licenseorder lo
					on ts.licenseorderid = lo.licenseorderid
					join offerrequest oq
					on oq.offerrequestid = ts.offerrequestid
					join offerrequestitems ri
					on ri.offerrequestid = oq.offerrequestid
					join technologydata td			
					on ri.technologydataid = td.technologydataid 	
					where (vcreatedby is null or td.createdby = vcreatedby)
					and (activatedat between vFrom and vTo)			
					group by CUBE (to_char(activatedat,'YYYY'), 
							to_char(activatedat,'MM'), 
							to_char(activatedat,'DD'), 
							to_char(activatedat,'HH24'), 
							td.technologydatauuid)
					order by to_char(activatedat,'YYYY') asc, 
							to_char(activatedat,'MM') asc, 
							to_char(activatedat,'DD') asc, 
							to_char(activatedat,'HH24') asc, 
							td.technologydatauuid asc,
							amount desc
				)
				select	r.year::text, 
					r.month::text,
					r.day::text,
					r.hour::text,
					r.technologydatauuid,
					r.Amount::integer,
					r.Revenue::bigint,
					r.Average::bigint
				from revenue r  
				where (vTechnologyDataUUID is null or r.technologydatauuid = vTechnologyDataUUID)
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
		$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getrevenuehistory(
    IN vfrom timestamp with time zone,
    IN vto timestamp with time zone,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(date date, technologydataname text, revenue bigint) AS
$BODY$

			DECLARE
				vFunctionName varchar := 'GetRevenueHistory'; 
				vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));		

			BEGIN 

			IF(vIsAllowed) THEN

			RETURN QUERY (with basis as (select r.year, r.month, r.day, r.hour, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue, r.average  from public.getrevenue(
					    vfrom,
					    vto,
					    null,
					    vcreatedby,
					    vroles) r
					join technologydata td on td.technologydatauuid = r.technologydatauuid
					where r.year <> '0' and r.month <> '0' and r.day <> '0' and r.hour <> '0'
					and r.technologydatauuid <> uuid_nil()
					order by r.year, r.month, r.day, r.hour, td.technologydatauuid),
					benchmark as (
					select r.year, r.month, r.day, 'Benchmark'::text as technologydataname, (r.revenue / r.amount) as revenue from public.getrevenue(
					    vfrom,
					    vto,
					    null,
					    null,
					    vroles) r 
					where r.year <> '0' and r.month <> '0' and r.day <> '0' and r.hour = '0'
					and r.technologydatauuid = uuid_nil()
					group by r.year, r.month, r.day, r.revenue, r.amount			 
					),
					techName as (select distinct a.technologydataname
							from basis a),			
					dates as (select distinct a.year, a.month, a.day
							from benchmark a ),							
					allData as (select tn.technologydataname, dt.year, dt.month, dt.day
							from techname tn, dates dt),
					totalData as (select ad.year, ad.month, ad.day, ad.technologydataname, case when (ba.revenue is null) then 0::bigint else ba.revenue::bigint end as revenue
						from allData ad
						left outer join basis ba
						on ad.year = ba.year
						and ad.month = ba.month
						and ad.day = ba.day
						and ad.technologydataname = ba.technologydataname),
					result as (			
					select to_date(t.year || '-' || t.month || '-' || t.day, 'YYYY-MM-DD') as date, t.technologydataname, t.revenue::bigint from totalData t			union all 
					select to_date(b.year || '-' || b.month || '-' || b.day, 'YYYY-MM-DD') as date, b.technologydataname, b.revenue::bigint from benchmark b)
					select rs.date, rs.technologydataname, sum(rs.revenue)::bigint from result rs
					group by rs.date, rs.technologydataname
					order by rs.date asc
					 
				
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
		$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.getrevenueperdayforuser(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(date date, revenue bigint) AS
$BODY$
			DECLARE
				vFunctionName varchar := 'GetRevenuePerForUSer';
				vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

			BEGIN

			IF(vIsAllowed) THEN

			RETURN QUERY (select activatedat::date, (sum(td.licensefee*ri.amount))::bigint as "Revenue (in IUNOs)" from transactions ts
					join licenseorder lo
					on ts.licenseorderid = lo.licenseorderid
					join offerrequest oq
					on oq.offerrequestid = ts.offerrequestid
					join offerrequestitems ri
					on ri.offerrequestid = oq.offerrequestid
					join technologydata td
					on ri.technologydataid = td.technologydataid
					where  activatedat::date = now()::date
					and td.createdby = vUserUUID
					and td.deleted is null
					group by activatedat::date
					order by activatedat::date
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
			$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettagbyid(
    IN vtagid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(taguuid uuid, tagname character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetTagById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  taguuid,
				tagname,
				tg.createdat  at time zone 'utc',
				tg.createdby,
				tg.updatedat  at time zone 'utc',
				tg.updatedby
		    FROM tags tg
		    WHERE tagUUID = vTagID
		  );

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettagbyname(
    IN vtagname character varying,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(taguuid uuid, tagname character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetTagByName';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  taguuid,
				tagname,
				tg.createdat  at time zone 'utc',
				tg.createdby,
				tg.updatedat  at time zone 'utc',
				tg.updatedby
		    FROM tags tg
		    WHERE tagName = vTagName
		  );

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettechnologybyid(
    IN vtechuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologyuuid uuid, technologyname character varying, technologydescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTechnologyById';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (SELECT  technologyuuid,
			technologyname,
			technologydescription,
			tg.createdat at time zone 'utc',
			tg.createdby,
			tg.updatedat at time zone 'utc',
			tg.updatedby
		FROM Technologies tg
		WHERE technologyuuid = vtechUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettechnologybyname(
    IN vtechname character varying,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologyuuid uuid, technologyname character varying, technologydescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$

			DECLARE
				vFunctionName varchar := 'GetTechnologyByName';
				vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

			BEGIN

			IF(vIsAllowed) THEN

			RETURN QUERY (SELECT  	tg.technologyuuid,
						tg.technologyname,
						tg.technologydescription,
						tg.createdat at time zone 'utc',
						tg.createdby,
						tg.updatedat at time zone 'utc',
						tg.updatedby
				    FROM Technologies tg
				    WHERE lower(tg.technologyname) = lower(vtechName)
				 );

			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
		    $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettechnologydatabyid(
    IN vtechnologydatauuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedyby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataById';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (	SELECT 	td.technologydatauuid,
				tc.technologyuuid,
				td.technologydataname,
				td.technologydata,
				td.technologydatadescription,
				td.productcode,
				td.licensefee,
				td.technologydatathumbnail,
				td.technologydataimgref,
				td.createdat  at time zone 'utc',
				td.createdby,
				td.updatedat  at time zone 'utc',
				td.updatedby
				FROM TechnologyData td
				join technologies tc
				on td.technologyid = tc.technologyid
				where td.technologydatauuid = vtechnologydatauuid
				and td.deleted is null
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettechnologydatabyname(
    IN vtechnologydataname character varying,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByName';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

    	RETURN QUERY (SELECT 	td.technologydatauuid,
				tc.technologyuuid,
				td.technologydataname,
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
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettechnologydatabyofferrequest(
    IN vofferrequestuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByOfferRequest';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

    	RETURN QUERY (SELECT 	technologydatauuid,
			tc.technologyuuid,
			td.technologydataname,
			technologydata,
			technologydatadescription,
			licensefee,
			technologydatathumbnail,
			technologydataimgref,
			td.createdat  at time zone 'utc',
			td.createdby,
			td.updatedat  at time zone 'utc',
			td.UpdatedBy
			FROM TechnologyData td
			join technologies tc
			on td.technologyid = tc.technologyid
			join offerrequest oq
			on oq.technologydataid = td.technologydataid
			and oq.offerrequestuuid = vOfferRequestUUID
			and td.deleted is null
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
	$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
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
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

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
			select co.componentuuid, co.componentid, co.componentname,
			case when t.* is null then '[]' else array_to_json(array_agg(t.*)) end as attributes from att t
			join componentsattribute ca on t.attributeid = ca.attributeid
			right outer join components co on co.componentid = ca.componentid
			group by co.componentname, co.componentid, co.componentuuid, t.*
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
					array_to_json(array_agg(co.*)) componentlist
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
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettechnologydataforuser(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, revenue bigint, licensefee bigint, componentlist text[], technologydatadescription character varying) AS
$BODY$
				DECLARE
					vFunctionName varchar := 'GetTechnologyDataForUser';
					vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

				BEGIN

				IF(vIsAllowed) THEN

				RETURN QUERY (	with revenue as (select td.technologydataname, (sum(td.licensefee*ri.amount))::bigint as revenue from transactions ts
						join licenseorder lo
						on ts.licenseorderid = lo.licenseorderid
						join offerrequest oq
						on oq.offerrequestid = ts.offerrequestid
						join offerrequestitems ri
						on oq.offerrequestid = ri.offerrequestid
						join technologydata td
						on ri.technologydataid = td.technologydataid
						where td.createdby = vUserUUID
						group by td.technologydataname
					), result as (
					select 	td.technologydatauuid,
						td.technologydataname,
						coalesce(rv.revenue,0)::bigint as revenue,
						td.licensefee,
						array_agg(co.componentname)::text[] as componentlist,
						td.technologydatadescription
					from technologydata td
					left outer join revenue rv on td.technologydataname = rv.technologydataname
					join technologydatacomponents tc
					on tc.technologydataid = td.technologydataid
					join components co
					on tc.componentid = co.componentid
					where td.createdby = vUserUUID
					and td.deleted is null
					group by td.technologydatauuid, td.technologydataname, td.licensefee, rv.revenue, td.technologydatadescription)
					select  r.technologydatauuid,
						r.technologydataname,
						sum(r.revenue)::bigint as revenue,
						r.licensefee::bigint,
						r.componentlist,
						r.technologydatadescription
					from result r
					group by r.technologydatauuid,
						r.technologydataname,
						r.licensefee,
						r.componentlist,
						r.technologydatadescription
					);

				ELSE
					 RAISE EXCEPTION '%', 'Insufficiency rigths';
					 RETURN;
				END IF;

				END;
			$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettechnologydatahistory(
    IN vfrom timestamp with time zone,
    IN vto timestamp with time zone,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(year text, month text, day text, hour text, technologydataname text, amount integer, revenue bigint) AS
$BODY$

			DECLARE
				vFunctionName varchar := 'GetTechnologyDataHistory'; 
				vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));
				vTechnologyDataName text := 'Total';

			BEGIN 

			IF(vIsAllowed) THEN

			RETURN QUERY (select r.year, r.month, r.day, r.hour, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from public.getrevenue(
					    vFrom,
					    vTo,
					    null,
					    null,
					    vRoles) r
					left outer join technologydata td
					on td.technologydatauuid = r.technologydatauuid
					where r.year <> '0' and r.month <> '0' and r.day <> '0' and r.hour <> '0'
					and r.technologydatauuid <> uuid_nil()	
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
		$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettechnologyforofferrequest(
    IN vofferrequestuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologyuuid uuid, technologyname character varying, technologydescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTechnologyForOfferRequest';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select 	tc.technologyuuid,
				tc.technologyName,
				tc.technologyDescription,
				tc.createdat at time zone 'utc',
				td.createdby,
				tc.updatedat at time zone 'utc',
				td.updatedby
			from technologydata td
			join offerrequest oq
			on oq.technologydataid = td.technologydataid
			join technologies tc
			on tc.technologyid = td.technologyid
			where oq.offerrequestuuid = vOfferRequestUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettopcomponents(
    IN vfrom timestamp with time zone,
    IN vto timestamp with time zone,
    IN vlimit integer,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentname character varying, amount integer) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetTopComponents';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

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
 $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
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
				vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));		

			BEGIN 

			IF(vIsAllowed) THEN

			RETURN QUERY (select r.year, r.month, r.day, r.hour, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from 
					getrevenue(vFrom,
						   vTo,
						   null,
						   vCreatedBy,
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
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettotalrevenue(
    IN vfrom timestamp with time zone,
    IN vto timestamp with time zone,
    IN vdetail text,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(date date, hour text, technologydataname text, amount integer, revenue bigint) AS
$BODY$

			DECLARE
				vFunctionName varchar := 'GetTotalRevenue'; 
				vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));
				vTechnologyDataUUID uuid := (select uuid_nil())::uuid;

			BEGIN 

			IF(vIsAllowed) THEN

			RETURN QUERY (select  to_date(r.year || '-' || r.month || '-' || r.day, 'YYYY-MM-DD') as date, r.hour::text, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from public.getrevenue(
					    vFrom,
					    vTo,
					    vTechnologyDataUUID,
					    vCreatedBy,
					    vRoles) r
					    left outer join technologydata td on
					    td.technologydatauuid = r.technologydatauuid
					    where r.year <> '0'
					    and r.month <> '0'
					    and r.day <> '0'
					    and case when (vDetail = 'hour') then r.hour <> '0' else r.hour = '0' end	 			    
					    order by r.year asc, r.month asc, r.day asc
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
		$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettotaluserrevenue(
    IN vfrom timestamp with time zone,
    IN vto timestamp with time zone,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(date date, hour text, technologydataname text, amount integer, revenue bigint) AS
$BODY$

			DECLARE
				vFunctionName varchar := 'GetTotalUserRevenue'; 
				vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));
				vTechnologyDataUUID uuid := (select uuid_nil());
			BEGIN 

			IF(vIsAllowed) THEN

			RETURN QUERY (select  to_date(r.year || '-' || r.month || '-' || r.day, 'YYYY-MM-DD') as date, r.hour::text, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from public.getrevenue(
					    vFrom,
					    vTo,
					    vTechnologyDataUUID,
					    vCreatedBy,
					    vRoles) r
					    left outer join technologydata td
					    on td.technologydatauuid = r.technologydatauuid
					    where r.year = '0'
					    and r.month = '0'
					    and r.day = '0'
					    and r.hour = '0'
					    and r.technologydatauuid = vTechnologyDataUUID			    
					    order by r.year asc, r.month asc, r.day asc
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
		$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettransactionbyid(
    IN vtransactionuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(transactionuuid uuid, buyer uuid, offeruuid uuid, offerrequestuuid uuid, paymentuuid uuid, paymentinvoiceid uuid, licenseorderuuid uuid, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTransactionById';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

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
			and ts.transactionuuid = vTransactionUUID
			left outer join offer ofr on ofr.offerid = ts.offerid
			left outer join payment py on py.paymentid = ts.paymentid
			left outer join paymentinvoice pi
			on pi.paymentinvoiceid = ts.paymentinvoiceid
			left outer join licenseorder li
			on li.licenseorderid = ts.licenseorderid
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.gettransactionbyofferrequest(
    IN vofferrequestuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(transactionuuid uuid, buyer uuid, offeruuid uuid, offerrequestuuid uuid, paymentuuid uuid, paymentinvoiceid uuid, licenseorderuuid uuid, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTransactionByOfferRequest';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

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
			and oq.offerrequestuuid = vOfferRequestUUID
			left outer join offer ofr on ofr.offerid = ts.offerid
			left outer join payment py on py.paymentid = ts.paymentid
			left outer join paymentinvoice pi
			on pi.paymentinvoiceid = ts.paymentinvoiceid
			left outer join licenseorder li
			on li.licenseorderid = ts.licenseorderid
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.setcomponent(
    IN vcomponentname character varying,
    IN vcomponentparentname character varying,
    IN vcomponentdescription character varying,
    IN vattributelist text[],
    IN vtechnologylist text[],
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentname character varying, componentparentuuid uuid, componentdescription character varying, attributelist uuid[], technologylist uuid[], createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vAttributeName text;
        	vTechName text;
		vCompID integer;
		vCompUUID uuid;
		vCompParentUUID uuid;
		vFunctionName varchar := 'SetComponent';
		vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

		-- Is none ParentComponent -> set Root as Parent
		if (vcomponentparentname is null) then
			vcomponentparentname := 'Root';
		end if;
		vCompParentUUID := (select case when (vComponentParentName = 'Root' and not exists (select 1 from components where componentName = 'Root')) then uuid_generate_v4() else componentuuid end from components where componentname = vComponentParentName);

		-- Proof if all technologies are avaiable
		if(vTechnologyList is not null OR array_length(vTechnologyList,1)>0) then
			FOREACH vTechName in array vTechnologyList
			LOOP
				 if not exists (select technologyid from technologies where technologyname = vTechName) then
				 raise exception using
				 errcode = 'invalid_parameter_value',
				 message = 'There is no technology with TechnologyName: ' || vTechName;
				 end if;
			END LOOP;

			-- Create new Component
			perform public.createcomponent(vCompParentUUID,vComponentName, vComponentdescription, vCreatedby, vRoles);
			vCompID := (select currval('ComponentID'));
			vCompUUID := (select componentuuid from components where componentID = vCompID);

			-- Create relation from Components to TechnologyData
			perform public.CreateComponentsTechnologies(vCompUUID, vTechnologyList, vRoles);
		end if;

		-- Proof if all Attributes are avaiable
		if(vAttributeList is not null OR array_length(vAttributeList,1)>0) then
			FOREACH vAttributeName in array vAttributeList
			LOOP
				 if not exists (select attributeid from public.attributes where attributename = vAttributeName) then
					perform public.createattribute(vAttributeName,vCreatedBy, vRoles);
				 end if;
			END LOOP;

			-- Create relation from Components to Attribute
			perform public.CreateComponentsAttribute(vCompUUID, vAttributeList, vRoles);
		end if;

		-- Begin Log if success
		perform public.createlog(0,'Set Component sucessfully','SetComponent',
					'ComponentID: ' || cast(vCompID as varchar) || ', componentname: '
					|| vComponentName || ', componentdescription: ' || vComponentDescription
					|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- End Log if success
        -- Return UserID
        RETURN QUERY (
			select 	co.ComponentUUID,
				co.ComponentName,
				cs.ComponentName as componentParentName,
				cs.ComponentUUID as componentParentUUID,
				co.ComponentDescription,
				array_agg(att.attributeuuid),
				array_agg(tc.technologyuuid),
				co.CreatedAt at time zone 'utc',
				vCreatedBy as CreatedBy
			from components co
			left outer join componentsattribute ca
			on co.componentid = ca.componentid
			left outer join attributes att
			on ca.attributeid = att.attributeid
			join componentstechnologies ct
			on co.componentid = ct.componentid
			join technologies tc
			on tc.technologyid = ct.technologyid
			left outer join components cs
			on co.componentparentid = cs.componentid
			where co.componentid = vCompID
			group by co.ComponentUUID, co.ComponentName, cs.ComponentName,
				cs.ComponentUUID, co.ComponentDescription, co.createdat
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,'SetComponent',
                                'ComponentID: ' || cast(vCompID as varchar) || ', componentname: '
                                || vComponentName || ', componentdescription: ' || vComponentDescription
                                || ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetComponent';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.setpayment(
    IN vtransactionuuid uuid,
    IN vbitcointransaction character varying,
    IN vconfidencestate character varying,
    IN vdepth integer,
    IN vextinvoiceid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(paymentuuid uuid, paymentinvoiceuuid uuid, paydate timestamp with time zone, bitcointransation character varying, confidencestate character varying, depth integer, extinvoiceid uuid, createdby uuid, createdat timestamp with time zone, updatedby uuid, updatedat timestamp with time zone) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vPaymentID integer;
		vPaymentUUID uuid := (select uuid_generate_v4());
		vPaymentInvoiceID integer := (select PaymentInvoiceID from transactions where transactionuuid = vTransactionUUID);
		vPayDate timestamp without time zone := null;
		vTransactionID integer := (select transactionid from transactions where transactionuuid = vtransactionuuid);
		vFunctionName varchar := 'SetPayment';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN


		IF exists (select extinvoiceid from payment where extinvoiceid = vExtInvoiceID) THEN
		-- TEST
		vPaymentID := (select paymentid from payment where ExtInvoiceID = vExtInvoiceID);
		perform public.createlog(0,'START Updated Payment sucessfully', 'SetPayment',
                                'PaymentID: ' || cast(vPaymentID as varchar)
				|| ', PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar)
				|| ', BitcoinTransaction: ' || coalesce(vBitcoinTransaction, 'no BitcoinTransaction')
				|| ', Confidence State: ' || coalesce(vconfidencestate, 'no value')
				|| ', Depth: ' || coalesce(cast(vDepth as varchar), 'no value')
				|| ', ExtInvoiceID: ' || cast(vExtInvoiceId as varchar)
				|| ', CreatedBy: ' || cast(vuseruuid as varchar));
		-- update
		--Proof if ConfidenceState is Pending and PayDate is null
		IF ((LOWER(vConfidenceState) = LOWER('Pending') or LOWER(vConfidenceState) = LOWER('building'))
			and (select 1 from payment where extinvoiceid = vExtInvoiceID and PayDate is null)::integer=1) THEN
			vPayDate := now();
		ELSE vPayDate := (select paydate from payment where extinvoiceid = vExtInvoiceID);
		END IF;
		update payment set ConfidenceState = vConfidenceState, Depth = vDepth, bitcointransaction = vbitcointransaction,
		PayDate = vPayDate, updatedat = now(), updatedby = vuseruuid
		where ExtInvoiceID = vExtInvoiceID;

		vPaymentID := (select paymentid from payment where ExtInvoiceID = vExtInvoiceID);
		-- Begin Log if success
		perform public.createlog(0,'END Updated Payment sucessfully', 'SetPayment',
                                'PaymentID: ' || cast(vPaymentID as varchar)
				|| ', PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar)
				|| ', BitcoinTransaction: ' || coalesce(vBitcoinTransaction, 'no BitcoinTransaction')
				|| ', Confidence State: ' || coalesce(vconfidencestate, 'no value')
				|| ', Depth: ' || coalesce(cast(vDepth as varchar), 'no value')
				|| ', ExtInvoiceID: ' || cast(vExtInvoiceId as varchar)
				|| ', CreatedBy: ' || cast(vuseruuid as varchar));

		-- End Log if success

	ELSE
		-- Insert
		 vPaymentID := (select nextval('PaymentID'));
		IF (LOWER(vConfidenceState) = LOWER('Pending') or LOWER(vConfidenceState) = LOWER('building')) THEN
			vPayDate := now();
		ELSE 	vPayDate := null;
		END IF;
		INSERT INTO payment(paymentid, paymentuuid, paymentinvoiceid, paydate, bitcointransaction,
				    createdby, depth, confidencestate, extinvoiceid,
				    createdat)
			VALUES (vPaymentID, vPaymentUUID, vPaymentInvoiceID, vPayDate, vbitcointransaction,
			vuseruuid, vDepth, vConfidenceState, vExtInvoiceID, now());

			-- Update Transactions table
		UPDATE Transactions SET PaymentID = vPaymentID, UpdatedAt = now(), UpdatedBy = vuseruuid
		WHERE TransactionID = vTransactionID;

		-- Begin Log if success
		perform public.createlog(0,'Created Payment sucessfully', 'SetPayment',
                                'PaymentID: ' || cast(vPaymentID as varchar)
				|| ', PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar)
				|| ', BitcoinTransaction: ' || coalesce(vBitcoinTransaction, 'no BitcoinTransaction')
				|| ', Confidence State: ' || coalesce(vconfidencestate, 'no value')
				|| ', Depth: ' || coalesce(cast(vDepth as varchar), 'no value')
				|| ', ExtInvoiceID: ' || cast(vExtInvoiceId as varchar)
				|| ', CreatedBy: ' || cast(vuseruuid as varchar));

		-- End Log if success

		END IF;
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

        -- Return PaymentID
        RETURN QUERY (
			select 	PaymentUUID,
				pi.PaymentInvoiceUUID,
				paydate at time zone 'utc',
				bitcointransaction,
				confidencestate,
				depth,
				extinvoiceid,
				py.CreatedBy as CreatedBy,
				py.createdat at time zone 'utc',
				py.UpdatedBy as UpdatedBy,
				py.updatedat at time zone 'utc'
			from payment py join
			paymentinvoice pi on
			py.paymentinvoiceid = pi.paymentinvoiceid
			where extinvoiceid = vExtInvoiceID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,'SetPayment',
                                'PaymentID: ' || cast(vPaymentID as varchar)
				|| ', PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar)
				|| ', BitcoinTransaction: ' || coalesce(vBitcoinTransaction, 'no BitcoinTransaction')
				|| ', Confidence State: ' || coalesce(vconfidencestate, 'no value')
				|| ', Depth: ' || coalesce(cast(vDepth as varchar), 'no value')
				|| ', ExtInvoiceID: ' || cast(vExtInvoiceId as varchar)
				|| ', CreatedBy: ' || cast(vuseruuid as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetPayment';
        RETURN ;
      END;
  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.setpaymentinvoiceoffer(
    IN vofferrequestuuid uuid,
    IN vinvoice character varying,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(paymentinvoiceuuid uuid, invoice character varying, offeruuid uuid, paymentcreatedat timestamp with time zone, paymentcreatedby uuid, offercreatedat timestamp with time zone, offercreatedby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE
		vPaymentInvoiceID integer;
		vPaymentInvoiceUUID uuid;
		vFunctionName varchar := 'SetPaymentInvoiceOffer';
		vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN
		-- Create PaymentInvoice
		perform createpaymentinvoice(vInvoice,vOfferRequestUUID,vCreatedBy, vRoles);
		vPaymentInvoiceID := (select currval('PaymentInvoiceID'));
		vPaymentInvoiceUUID := (select paymentinvoice.paymentinvoiceuuid from paymentinvoice where paymentinvoiceid = vPaymentInvoiceID);

		-- Create Offer
		perform createoffer(vPaymentInvoiceUUID, vCreatedBy, vRoles);

		-- Begin Log if success
		perform public.createlog(0,'Set SetPaymentInvoiceOffer sucessfully', 'SetPaymentInvoiceOffer',
					'OfferRequestID: ' || cast(vOfferRequestUUID as varchar)
					|| ', invoice: ' || vInvoice
					|| ', CreatedBy: ' || cast(vCreatedBy as varchar));

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;
        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	pi.paymentinvoiceuuid,
			pi.invoice,
			ofr.offeruuid,
			pi.createdat at time zone 'utc' as paymentCreatedAt,
			vCreatedBy as paymentCreatedBy,
			ofr.createdat at time zone 'utc' as offerCreatedAt,
			vCreatedBy as offerCreatedBy
		from paymentinvoice pi
		join offer ofr ON pi.paymentinvoiceid = ofr.paymentinvoiceid
		where pi.paymentinvoiceuuid = vPaymentInvoiceUUID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,'SetPaymentInvoiceOffer',
                                'OfferRequestID: ' || cast(vOfferRequestUUID as varchar)
				|| ', invoice: ' || vInvoice
                                || ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetPaymentInvoiceOffer';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.setpermission(
    vroles text[],
    vfunctionname character varying,
    vuseruuid uuid,
    vrolesuser text[])
  RETURNS void AS
$BODY$
	DECLARE vFunctionID integer := (select nextval('FunctionID'));
		vThisFunctionName varchar := 'SetPermission';
		vIsAllowed boolean := (select public.checkPermissions(vuseruuid, vRolesUser, vThisFunctionName));
		vRoleId integer;
		vRoleName varchar;
		vFunctionExists boolean := (select exists(select 1 from functions where functionname = vfunctionname));
	BEGIN

		if(vIsAllowed) then

			--Proof if the function alread exists
			if(not vFunctionExists) then
				insert into functions (FunctionID, FunctionName)
				values (vFunctionID, vFunctionName);

				FOREACH vRoleName in array vRoles LOOP
					vRoleId := (select roleid from roles where rolename = vRoleName);
					insert into rolespermissions(RoleId,FunctionId)
					values (vRoleId, vFunctionId);
				END LOOP;
			else

				 vFunctionID := (select functionid from functions where functionname = vFunctionName);

				 FOREACH vRoleName in array vRoles LOOP
					vRoleId := (select roleid from roles where rolename = vRoleName);
					insert into rolespermissions(RoleId,FunctionId)
					values (vRoleId, vFunctionId);
				 END LOOP;

			end if;

		else
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
		end if;

	-- Begin Log if success
        perform public.createlog(0,'Created Permission sucessfully', 'SetPermission',
                                'PermissionID: ' || cast(vFunctionID as varchar) || ', Roles: '
                                || cast(vRoles as varchar) || ', FunctionName: ' || vFunctionName);

	 exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'SetPermission',
                                'PermissionID: ' || cast(vFunctionID as varchar) || ', Roles: '
                                || cast(vRoles as varchar) || ', FunctionName: ' || vFunctionName);
        -- End Log if error
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetPermission';
		RETURN;
	END;
$BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
CREATE OR REPLACE FUNCTION public.settechnologydata(
    IN vtechnologydataname character varying,
    IN vtechnologydata character varying,
    IN vtechnologydatadescription character varying,
    IN vtechnologyuuid uuid,
    IN vlicensefee integer,
    IN vproductcode integer,
    IN vtaglist text[],
    IN vcomponentlist text[],
    IN vtechnologydataimgref text,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, licensefee bigint, productcode integer, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, taglist uuid[], componentlist uuid[], createdat timestamp with time zone, createdby uuid) AS
$BODY$
		#variable_conflict use_column
	      DECLARE 	vCompUUID uuid;
					vTagName text;
					vTechnologyDataID int;
					vTechnologyDataUUID uuid;
					vTechnologyID integer := (select technologyID from technologies where technologyUUID = vTechnologyUUID);
					vFunctionName varchar := 'SetTechnologyData';
					vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));
					vAlreadExists integer := (select 1 from technologydata where technologydataname = vtechnologydataname and deleted is null);

		BEGIN

		IF(vIsAllowed) THEN
			-- Proof if all components are avaiable
			FOREACH vCompUUID in array vComponentlist
			LOOP
				 if not exists (select componentid from components where componentuuid = vCompUUID) then
				 raise exception using
				 errcode = 'invalid_parameter_value',
				 message = 'There is no component with ComponentName: ' || cast(vCompUUID as varchar);
				 end if;
			END LOOP;
			-- Proof if all Tags are avaiable
			IF (vTagList != null) THEN
				FOREACH vTagName in array vTagList
				LOOP
					 if not exists (select tagID from tags where tagname = vTagName) then
						perform public.createtag(vTagName,vCreatedby, vRoles);
					 end if;
				END LOOP;
			END IF;
			-- Proof if technology is avaiable
			if not exists (select technologyid from technologies where technologyuuid = vTechnologyUUID) then
				raise exception using
			    errcode = 'invalid_parameter_value',
			    message = 'There is no technology with TechnologyID: ' || coalesce(vTechnologyID::text,'Empty');
			end if;

			-- Create new TechnologyData
				IF(vAlreadExists is null) THEN
					perform public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, 					vTechnologyUUID, vtechnologydataimgref, vCreatedBy, vRoles);
					vTechnologyDataID := (select currval('TechnologyDataID'));
					vTechnologyDataUUID := (select technologydatauuid from technologydata where technologydataid = vTechnologyDataID);

					-- Create relation from Components to TechnologyData
					perform public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList, vCreatedBy, vRoles);

					-- Create relation from Tags to TechnologyData
					IF (vTagList != null) THEN
						perform public.CreateTechnologyDataTags(vTechnologyDataUUID, vTagList, CreatedBy, vRoles);
					END IF;
				ELSE
					RAISE EXCEPTION '%', 'Technologydata already exists';
					RETURN;

			END IF;
			-- Begin Log if success
			perform public.createlog(0,'Set TechnologyData sucessfully', 'SetTechnologyData',
						'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: '
						|| replace(vTechnologyDataName, '''', '''''') || ', TechnologyData: ' || vTechnologyData
						|| ', TechnologyDataDescription: ' || replace(vTechnologyDataDescription, '''', '''''')
						|| ', CreatedBy: ' || cast(vRoles as varchar));

		ELSE
			 RAISE EXCEPTION '%', 'Insufficiency rigths';
			 RETURN;
		END IF;
		-- End Log if success
		-- Return vTechnologyDataUUID
		RETURN QUERY (
			select 	TechnologyDataUUID,
				td.TechnologyDataName,
				vTechnologyUUID,
				TechnologyData,
				LicenseFee,
				ProductCode,
				TechnologyDataDescription,
				TechnologyDataThumbnail,
				TechnologyDataImgRef,
				array_agg(tg.taguuid) as TagList,
				array_agg(co.componentuuid) as ComponentList,
				td.CreatedAt at time zone 'utc',
				vCreatedBy as CreatedBy
			from technologydata td
			left outer join technologydatatags tt on
			td.technologydataid = tt.technologydataid
			left outer join tags tg on tt.tagid = tg.tagid
			join technologydatacomponents tc
			on tc.technologydataid = td.technologydataid
			join components co
			on co.componentid = tc.componentid
			where td.technologydataid = vTechnologyDataID
			group by technologydatauuid, td.technologydataname, technologydata,
				 licensefee, productcode, technologydatadescription, technologydatathumbnail,
				 TechnologyDataImgRef, td.createdat, td.createdby
		);

		exception when others then
		-- Begin Log if error
		perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'SetTechnologyData',
					'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: '
					|| replace(vTechnologyDataName, '''', '''''') || ', TechnologyData: ' || vTechnologyData
					|| ', TechnologyDataDescription: ' || replace(vTechnologyDataDescription, '''', '''''')
					|| ', CreatedBy: ' || cast(vCreatedby as varchar));
		-- End Log if error
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetTechnologyData';
		RETURN;
	      END;
	  $BODY$
  LANGUAGE plpgsql;
-- #########################################################################################################################################
 ----------------------------------------------------------------------------------------------------------------------------------------
        -- UPDATE patch table status value
        UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
        --ERROR HANDLING
        EXCEPTION WHEN OTHERS THEN
            UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
         RETURN;
    END;
$$;