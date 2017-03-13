-- ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-27
-- Description: Script to create MarketplaceCore database functions, sequences, etc.
-- Changes: 
-- ##########################################################################
-- Create Database
/*CREATE DATABASE "Test"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;*/
-- Install Extension UUID-OSSP
CREATE EXTENSION "uuid-ossp";
-- Create Sequences
-- UserID
CREATE SEQUENCE UserID START 1;
-- TechnologyDataID
CREATE SEQUENCE TechnologyDataID START 1;
-- TagID
CREATE SEQUENCE TagID START 1;
-- ComponentID
CREATE SEQUENCE ComponentID START 1;
-- TechnologyID
CREATE SEQUENCE TechnologyID START 1;
-- AttributeID
CREATE SEQUENCE AttributeID START 1; 
-- AttributeID
CREATE SEQUENCE LogID START 1; 
-- OfferRequestID
CREATE SEQUENCE OfferRequestID START 1; 
-- OfferID
CREATE SEQUENCE OfferID START 1; 
-- PaymentInvoiceID
CREATE SEQUENCE PaymentInvoiceID START 1; 
-- PaymentID
CREATE SEQUENCE PaymentID START 1; 
-- TransactionID
CREATE SEQUENCE TransactionID START 1;
-- LicenseOderID
CREATE SEQUENCE LicenseOrderID START 1;
-- RoleID
CREATE SEQUENCE RoleID START 1;
-- PermissionID
CREATE SEQUENCE PermissionID START 1;
-- ##########################################################################
-- Create Functions
-- CreateLog
CREATE FUNCTION CreateLog(LogStatusID integer, LogMessage varchar(32672), LogObjectName varchar(250), Parameters varchar(32672))
  RETURNS VOID AS
  $$      
      DECLARE LogID integer:= (select nextval('LogID'));
      BEGIN        
        INSERT INTO LogTable(LogID, LogStatusID, LogMessage, LogObjectName, Parameters,CreatedAt)
        VALUES(LogID, LogStatusID, LogMessage, LogObjectName, Parameters, now());                
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################
-- CreateUser 
CREATE FUNCTION CreateUser(vUserFirstName varchar(250), vUserLastName varchar(250), vUserEmail varchar(250))
  RETURNS TABLE (
	oUserUUID uuid,
	oUserFirstName varchar(250),
	oUserLastName varchar(250), 
	oUserEmail varchar(250),
	oCreatedAt timestamp with time zone,
	oUpdatedAt timestamp with time zone
  )
  
 AS
  $$
      DECLARE 	vUserID integer := (select nextval('UserID'));      
				vUserUUID uuid := (select uuid_generate_v4()); 
      BEGIN        
        INSERT INTO Users(UserID, UserUUID, UserFirstName, UserLastName, UserEmail, CreatedAt)
        VALUES(vUserID, vUserUUID, vUserFirstName, vUserLastName, vUserEmail, now());        
        
        -- Begin Log if success
        perform public.createlog(0,'Created User sucessfully', 'CreateUser', 
                                'UserID: ' || cast(vUserID as varchar) || ', UserFirstName: ' 
                                || vUserFirstName || ', UserLastName: ' || vUserLastName 
                                || ', ' 
                                || vUserEmail);
                                
        -- End Log if success
	-- RETURN
	RETURN QUERY (select 	users.useruuid,
				users.userfirstname,
				users.userlastname,
				users.useremail,
				users.createdat at time zone 'utc',
				users.updatedat at time zone 'utc'
			from users where users.useruuid = vUserUUID);      
         
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateUser', 
                                'UserID: ' || cast(vUserID as varchar) || ', UserFirstName: ' 
                                || vUserFirstName || ', UserLastName: ' || vUserLastName 
                                || ', ' 
                                || vUserEmail);
        -- End Log if error 
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
CREATE FUNCTION CreateTechnologyData (
	  vTechnologyDataName varchar(250), 
	  vTechnologyData varchar(32672), 
	  vTechnologyDataDescription varchar(32672),
	  vLicenseFee integer,  
	  vRetailPrice integer,
	  vTechnologyUUID uuid,
	  vCreatedBy uuid
 )
  RETURNS TABLE (
	oTechnologyDataUUID uuid,
	oTechnologyDataName varchar(250),
	oTechnologyUUID uuid,
	oTechnologyData varchar(32672),
	oLicenseFee integer,
	ORetailPrice integer,
	oTechnologyDataDescription varchar(32672),
	oTechnologyDataThumbnail bytea,
	oTechnologyDataImgRef character varying,
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid
  ) AS
  $$
      DECLARE 	vTechnologyDataID integer := (select nextval('TechnologyDataID'));
		vTechnologyDataUUID uuid := (select uuid_generate_v4());     
		vTechnologyID integer := (select technologyid from technologies where technologyuuid = vTechnologyUUID);
		vUserID integer := (select userid from users where useruuid = vCreatedby);
		-- vTechAuthor integer := (select userid from users where useruuid = vTechnologyDataAuthor);		
      BEGIN        
        INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, RetailPrice, TechnologyID, CreatedBy, CreatedAt)
        VALUES(vTechnologyDataID, vTechnologyDataUUID, vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vRetailPrice, vTechnologyID, vUserID, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created TechnologyData sucessfully', 'CreateTechnologyData', 
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || vTechnologyDataName || ', TechnologyData: ' || vTechnologyData 
                                || ', TechnologyDataDescription: ' || vTechnologyDataDescription
				-- || ', vTechnologyDataAuthor: ' || cast(vTechAuthor as varchar) 
                                || ', TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', LicenseFee: ' || cast(vLicenseFee as varchar)
								|| ', RetailPrice: ' || cast(vRetailPrice as varchar)
                                || ', CreatedBy: ' || vUserID);
                                
        -- End Log if success
        -- Return 
        RETURN QUERY (
		select 	td.TechnologyDataUUID,
			td.TechnologyDataName,
			tc.TechnologyUUID,
			td.TechnologyData,
			td.LicenseFee,
			td.RetailPrice,
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
                                || vTechnologyDataName || ', TechnologyData: ' || vTechnologyData 
                                || ', TechnologyDataDescription: ' || vTechnologyDataDescription
				-- || ', vTechnologyDataAuthor: ' || cast(vTechAuthor as varchar) 
                                || ', TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', LicenseFee: ' || cast(vLicenseFee as varchar)
								|| ', RetailPrice: ' || cast(vRetailPrice as varchar)
                                || ', CreatedBy: ' || vUserID);
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateTag
 CREATE FUNCTION CreateTag (
  vTagName varchar(250),  
  vCreatedBy uuid
 )
  RETURNS TABLE (
	oTagUUID uuid,
	oTagName varchar(250),
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid 
  ) AS
  $$
      DECLARE 	vTagID integer := (select nextval('TagID'));
		vTagUUID uuid := (select uuid_generate_v4());	
		vUserID integer := (select userid from users where useruuid = vCreatedBy);
      BEGIN        
        INSERT INTO Tags(TagID, TagUUID, TagName, CreatedBy, CreatedAt)
        VALUES(vTagID, vTagUUID, vTagName, vUserID, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created Tag sucessfully', 'CreateTag', 
                                'TagID: ' || cast(vTagID as varchar) 
				|| ', TagName: ' || vTagName 
				|| ', CreatedBy: ' || cast(vUserID as varchar));
                                
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
				|| ', CreatedBy: ' || cast(vUserID as varchar));
        -- End Log if error
        -- Return Error Code * -1
       RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################  
-- CreateTechnologyDataTags 
CREATE FUNCTION CreateTechnologyDataTags (
  vTechnologyDataUUID uuid, 
  vTagList text[]
 )
  RETURNS TABLE (
	oTechnologyDataUUID uuid,
	oTagList uuid[]
  ) AS
  $$    
  	DECLARE vTagName text;
		vtagID integer;
		vTechnologyDataID integer := (select technologydataid from technologydata where technologydatauuid = vTechnologyDataUUID);
		
      BEGIN     
         FOREACH vTagName in array vTagList          	
        LOOP 
        	 vtagID := (select tags.tagID from tags where tagName = vTagName); 
         	 INSERT INTO TechnologyDataTags(TechnologyDataID, tagID)
			VALUES (vTechnologyDataID, vtagID);
			
        END LOOP; 
     
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
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';  
-- ##############################################################################    
-- CreateAttribute
CREATE FUNCTION CreateAttribute (
  vAttributeName varchar(250), 
  vCreatedBy uuid
 )
  RETURNS TABLE (
	oAttributeUUID uuid,
	oAttributeName varchar(250),
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid 
  ) AS
  $$
      DECLARE 	vAttributeID integer := (select nextval('AttributeID'));
		vAttributeUUID uuid := (select uuid_generate_v4());
		vUserID integer := (select userid from users where useruuid = vCreatedby);
      BEGIN        
        INSERT INTO public.Attributes(AttributeID, AttributeUUID, AttributeName, CreatedBy, CreatedAt)
        VALUES(vAttributeID, vAttributeUUID, vAttributeName, vUserID, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created Attribute sucessfully', 'CreateAttribute', 
                                'AttributeID: ' || cast(vAttributeID as varchar) 
				|| ', AttributeName: ' || vAttributeName
				|| ', CreatedBy: ' || cast(vUserID as varchar));
                                
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
				|| ', CreatedBy: ' || cast(vUserID as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateComponents
CREATE OR REPLACE FUNCTION CreateComponent (
  vComponentParentUUID uuid, 
  vComponentName varchar(250),
  vComponentDescription varchar(250),
  vCreatedBy uuid
 )
  RETURNS TABLE (
	oComponentUUID uuid,
	oComponentName varchar(250),
	oComponentParentName varchar(250),
	oComponentParentUUID uuid,
	oComponentDecription varchar(32672),
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid
  ) AS
  $$
      DECLARE 	vComponentID integer := (select nextval('ComponentID'));
		vComponentUUID uuid := (select uuid_generate_v4());		
		vUserID integer := (select userid from users where useruuid = vCreatedBy);
		vComponentParentID integer := (select componentid from components where componentuuid = vComponentParentUUID);
      BEGIN        
        INSERT INTO components(ComponentID, ComponentUUID, ComponentParentID, ComponentName, ComponentDescription, CreatedBy, CreatedAt)
        VALUES(vComponentID, vComponentUUID, vComponentParentID, vComponentName, vComponentDescription, vUserID, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created Component sucessfully', 'CreateComponent', 
                                'ComponentID: ' || cast(vComponentID as varchar) || ', '  
                                || 'ComponentParentID: ' || cast(vComponentParentID as varchar) 
                                || ', ComponentName: ' 
                                || vComponentName 
                                || ', ComponentDescription: ' 
                                || vComponentDescription 
                                || ', CreatedBy: ' 
                                || cast(vUserID as varchar));
                                
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
                                || cast(vUserID as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################    
-- CreateTechnologies
CREATE FUNCTION createtechnology(
    vTechnologyname character varying,
    vTechnologydescription character varying,
    vCreatedby uuid)
  RETURNS TABLE (
	oTechnologyUUID uuid,
	oTechnologyName varchar(250),
	oTechnologyDescription varchar(32672),
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid
  ) AS
$$
      DECLARE 	vTechnologyID integer := (select nextval('TechnologyID'));
		vTechnologyUUID uuid := (select uuid_generate_v4());
		vUserID integer := (select userid from users where useruuid = vCreatedby);
      BEGIN        
        INSERT INTO Technologies(TechnologyID, TechnologyUUID, TechnologyName, TechnologyDescription, CreatedBy, CreatedAt)
        VALUES(vTechnologyID, vTechnologyUUID, vTechnologyName, vTechnologyDescription, vUserID, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created Technology sucessfully', 'CreateTechnology', 
                                'TechnologyID: ' || cast(vTechnologyID as varchar) 
                                || ', TechnologyName: ' 
                                || vTechnologyName 
                                || ', TechnologyDescription: ' 
                                || vTechnologyDescription 
                                || ', CreatedBy: ' 
                                || cast(vUserID as varchar));
                                
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
                                || cast(vUserID as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE plpgsql;
-- ##############################################################################    
-- CreateTechnologyDataComponents 
CREATE FUNCTION CreateTechnologyDataComponents (
  vTechnologyDataUUID uuid, 
  vComponentList text[]
 )
  RETURNS TABLE (
	oTechnologyDataUUID uuid,
	oComponentList uuid[]
  ) AS
  $$    
  	DECLARE vCompName text;
		vCompID integer;
		vTechnologyDataID integer := (select technologydataid from technologydata where technologydatauuid = vTechnologyDataUUID);
      BEGIN     
         FOREACH vCompName in array vComponentList 		
        LOOP 
		vCompID := (select componentID from components where componentName = vCompName);
		
         	INSERT INTO TechnologyDataComponents(technologydataid, componentid)
		VALUES (vTechnologyDataID, vCompID);
        END LOOP; 
     
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
        -- Return 
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################       
-- CreateComponentsAttribute
CREATE FUNCTION CreateComponentsAttribute (
  vComponentUUID uuid, 
  vAttributeList text[]
 )
  RETURNS TABLE (
	oComponentUUID uuid,
	oAttributeList uuid[]
  ) AS
  $$    
  	DECLARE vAttributeName text;
		vAttrID int;
		vComponentID integer := (select componentid from components where componentuuid = vComponentUUID);
      BEGIN     
         FOREACH vAttributeName in array vAttributeList          	
        LOOP 
        	 vAttrID := (select attributes.attributeID from public.attributes where attributename = vAttributeName); 
         	 INSERT INTO ComponentsAttribute(ComponentID, AttributeID)
             VALUES (vComponentID, vAttrID);
        END LOOP; 
     
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
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateComponentsTechnologies
CREATE FUNCTION CreateComponentsTechnologies (
  vComponentUUID uuid, 
  vTechnologyList text[]
 )
  RETURNS TABLE (
	oComponentUUID uuid,
	oTechnologyList uuid[]
  ) AS
  $$    
    DECLARE 	vTechName text;
		vTechID integer;
		vComponentID integer := (select componentid from components where componentuuid = vComponentUUID);
      BEGIN     
         FOREACH vTechName in array vTechnologyList          	
        LOOP 
		vTechID := (select technologyid from technologies where technologyname = vTechName);
         	 INSERT INTO ComponentsTechnologies(ComponentID, TechnologyID)
             VALUES (vComponentID, vTechID);
        END LOOP; 
     
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
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################
--  CreateOfferRequest
CREATE FUNCTION CreateOfferRequest (
  vTechnologyDataUUID uuid,
  vAmount integer,
  vHSMID varchar,
  vUserUUID uuid,
  vBuyerUUID uuid
 )
  RETURNS TABLE (
	OfferRequestUUID uuid,
	TechnologyDataUUID uuid,
	Amount integer,
	HMSID varchar(32672),
	CreatedAt timestamp with time zone,
	RequestedBy uuid	
  )	
 AS
  $$
      DECLARE 	vOfferRequestID integer := (select nextval('OfferRequestID'));
		vOfferRequestUUID uuid := (select uuid_generate_v4());
		vTechnologyDataID integer := (select technologydata.technologydataid from technologydata where technologydata.technologydatauuid = vTechnologyDataUUID);	
		vRequestedBy integer := (select userid from users where useruuid = vUserUUID);
		vTransactionID integer := (select nextval('TransactionID'));
		vTransactionUUID uuid := (select uuid_generate_v4());
		vBuyerID integer := (select userid from users where useruuid = vBuyerUUID);
      BEGIN        
        INSERT INTO OfferRequest(OfferRequestID, OfferRequestUUID, TechnologyDataID, Amount, HSMID, RequestedBy, CreatedAt)
        VALUES(vOfferRequestID, vOfferRequestUUID, vTechnologyDataID, vAmount, vHSMID, vRequestedBy, now());

        INSERT INTO Transactions(TransactionID, TransactionUUID, OfferRequestID, BuyerID, CreatedBy, CreatedAt)
		VALUES (vTransactionID, vTransactionUUID, vOfferRequestID, vBuyerID, vRequestedBy, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created OfferRequest sucessfully', 'CreateOfferRequest', 
                                'OfferRequestID: ' || cast(vOfferRequestID as varchar) 
				|| ', TechnologyDataID: ' || cast(vTechnologyDataID as varchar)
				|| ', Amount: ' || cast(vAmount as varchar) || ', HSMID: ' || vHSMID);
                                
        -- End Log if success
        -- Return OfferRequestUUID
        RETURN QUERY (
				select	ofr.OfferRequestUUID,
						td.TechnologyDataUUID,
						ofr.Amount,
						ofr.HSMID,
						ofr.CreatedAt at time zone 'utc',
						us.useruuid as RequestedBy
						from offerrequest ofr 
						join technologydata td 
						on ofr.technologydataid = td.technologydataid
						join users us on us.userid = ofr.requestedby
				where ofr.offerrequestuuid = vOfferRequestUUID
        );
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateOfferRequest', 
                                'OfferRequestID: ' || cast(vOfferRequestID as varchar) 
				|| ', TechnologyDataID: ' || cast(vTechnologyDataID as varchar)
				|| ', Amount: ' || cast(vAmount as varchar) || ', HSMID: ' || vHSMID);
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################    
-- CreatePaymentInvoice
CREATE FUNCTION CreatePaymentInvoice (
  vInvoice varchar(32672), 
  vOfferRequestUUID uuid,
  vUserUUID uuid  
 )
  RETURNS TABLE (
	oPaymentInvoiceUUID uuid,
	oOfferRequestUUID uuid,
	oInvoice varchar(32672),
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid
  ) AS
  $$
	DECLARE vPaymentInvoiceID integer := (select nextval('PaymentInvoiceID'));
		vPaymentInvoiceUUID uuid := (select uuid_generate_v4()); 
		vOfferReqID integer := (select offerrequestid from offerrequest where offerrequestuuid = vOfferRequestUUID);
		vCreatedBy integer := (select userid from users where useruuid = vUserUUID);
		vTransactionID integer := (select transactionid from transactions where offerrequestid = vOfferReqID);
      BEGIN        
        INSERT INTO PaymentInvoice(PaymentInvoiceID, PaymentInvoiceUUID, OfferRequestID, Invoice, CreatedBy, CreatedAt)
        VALUES(vPaymentInvoiceID, vPaymentInvoiceUUID, vOfferReqID, vInvoice, vCreatedBy, now());

		-- Update Transactions table
        UPDATE Transactions SET PaymentInvoiceID = vPaymentInvoiceID, UpdatedAt = now(), UpdatedBy = vCreatedBy
        WHERE TransactionID = vTransactionID;
     
        -- Begin Log if success
        perform public.createlog(0,'Created PaymentInvoice sucessfully', 'CreatePaymentInvoice', 
                                'PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar) 
				|| ', OfferRequestID: ' || cast(vOfferReqID as varchar)
				|| ', Invoice: ' || vInvoice
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
                                
        -- End Log if success
        -- Return 
        RETURN QUERY (
		select	pi.PaymentInvoiceUUID,
			oq.OfferRequestUUID,
			pi.Invoice,
			pi.CreatedAt at time zone 'utc',
			ur.useruuid as CreatedBy
		from paymentinvoice pi
		join offerrequest oq 
		on pi.offerrequestid = oq.offerrequestid
		join users ur on ur.userid = pi.createdby		
		where pi.paymentinvoiceuuid = vPaymentInvoiceUUID
        );
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreatePaymentInvoice', 
                                'PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar) 
				|| ', OfferRequestID: ' || cast(vOfferReqID as varchar)
				|| ', Invoice: ' || vInvoice
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateOffer   
CREATE FUNCTION CreateOffer(
  vPaymentInvoiceUUID uuid,
  vUserUUID uuid
 )
  RETURNS TABLE (
	oOfferUUID uuid,
	oPaymentInvoiceUUID uuid,
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid	
  ) AS
  $$
      DECLARE 	vOfferID integer := (select nextval('OfferID'));
		vOfferUUID uuid := (select uuid_generate_v4());
		vPaymentInvoiceID integer := (select paymentinvoiceid from paymentinvoice where paymentinvoiceuuid = vPaymentInvoiceUUID);	
		vCreatedBy integer := (select userid from users where useruuid = vUserUUID); 
		vTransactionID integer := (select transactionid from transactions where paymentinvoiceid = vPaymentInvoiceID); 
      BEGIN        
        INSERT INTO Offer(OfferID, OfferUUID, PaymentInvoiceID, CreatedBy, CreatedAt)
        VALUES(vOfferID, vOfferUUID, vPaymentInvoiceID, vCreatedBy, now());

        -- Update Transactions table
        UPDATE Transactions SET OfferId = vOfferID, UpdatedAt = now(), UpdatedBy = vCreatedBy
        WHERE TransactionID = vTransactionID;
     
        -- Begin Log if success
        perform public.createlog(0,'Created Offer sucessfully', 'CreateOffer', 
                                'OfferID: ' || cast(vOfferID as varchar) 
				|| ', PaymentInvoiceUUID: ' || cast(vPaymentInvoiceUUID as varchar)
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
                                
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
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';   
-- ##############################################################################
-- CreateLicenseOrder  
CREATE FUNCTION CreateLicenseOrder (
  vTicketID varchar(4000),
  vOfferUUID uuid,
  vUserUUID uuid
 )
  RETURNS TABLE (
	oLicenseOrderUUID uuid,
	oTicketID varchar(4000),
	oOfferUUID uuid,
	oActivatedAt timestamp with time zone,
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid
  ) AS
  $$
      DECLARE 			vLicenseOrderID integer := (select nextval('LicenseOrderID'));
				vLicenseOrderUUID uuid := (select uuid_generate_v4()); 
				vOfferID integer := (select offerid from offer where offeruuid = vOfferUUID);
				vCreatedBy integer := (select userid from users where useruuid = vUserUUID);
				vTransactionID integer := (select transactionid from transactions where offerid = vOfferID);
      BEGIN        
        INSERT INTO LicenseOrder(LicenseOrderID, LicenseOrderUUID, TicketID, OfferID, ActivatedAt, CreatedBy, CreatedAt)
        VALUES(vLicenseOrderID, vLicenseOrderUUID, vTicketID, vOfferID, now(), vCreatedBy, now());

		-- Update Transactions table
        UPDATE Transactions SET LicenseOrderID = vLicenseOrderID, UpdatedAt = now(), UpdatedBy = vCreatedBy
        WHERE TransactionID = vTransactionID;
     
        -- Begin Log if success
        perform public.createlog(0,'Created CreateLicenseOrder sucessfully', 'CreateLicenseOrder', 
                                'PaymentInvoiceID: ' || cast(vLicenseOrderID as varchar) 
				|| ', TicketID: ' || vTicketID
				|| ', OfferID: ' || cast(vOfferID as varchar)
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
                                
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
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';     
-- ##############################################################################    
-- CreatePayment  
CREATE FUNCTION CreatePayment(  
  vPaymentInvoiceUUID uuid,
  vBitcoinTransaction varchar(32672),
  vUserUUID uuid
 )
  RETURNS TABLE (
	oPaymentUUID uuid,
	oPaymentInvoiceUUID uuid,
	oPayDate timestamp with time zone,
	oBitcoinTransation varchar(32672),
	oCreatedBy uuid
  ) AS
  $$
      DECLARE 	vPaymentID integer := (select nextval('PaymentID')); 
				vPaymentUUID uuid := (select uuid_generate_v4());
				vPaymentInvoiceID integer := (select PaymentInvoiceID from paymentinvoice where PaymentInvoiceUUID = vPaymentInvoiceUUID);
				vCreatedBy integer := (select userid from users where useruuid = vUserUUID);
      BEGIN        
        INSERT INTO Payment(PaymentID, PaymentUUID, PaymentInvoiceID, PayDate, BitcoinTransaction, CreatedBy)
        VALUES(vPaymentID, vPaymentUUID, vPaymentInvoiceID, now(), vBitcoinTransaction, vCreatedBy);
     
        -- Begin Log if success
        perform public.createlog(0,'Created PaymentInvoice sucessfully', 'CreatePayment', 
                                'PaymentID: ' || cast(vPaymentID as varchar) 
				|| ', PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar) 
				|| ', BitcoinTransaction: ' || vBitcoinTransaction
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
                                
        -- End Log if success
        -- Return PaymentID
        RETURN QUERY (
		select 	PaymentUUID,
			vPaymentInvoiceUUID,
			paydate at time zone 'utc',
			bitcointransaction,
			vUserUUID
		from payment where paymentuuid = vPaymentUUID
			
        );
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,'CreatePayment', 
                                'PaymentID: ' || cast(vPaymentID as varchar) 
				|| ', PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar) 
				|| ', BitcoinTransaction: ' || vBitcoinTransaction
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN ;
      END;
  $$
  LANGUAGE 'plpgsql'; 
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-14
-- Description: Script to set a new Component
-- ##########################################################################
Create a complete Componente with Attributes
Input paramteres: 
	- ComponentName: varchar(250)
  	- ComponentParentID: integer
  	- ComponentDescription: varchar(32672),
  	- AttributeList: text[] 
  	- TechnologyList: int[]
  	- CreatedBy: integer
Return Value:
 ***********************************************
 Step 1: Proof if all attributes are avaiable, if not create them 
 Step 2: Insert values into the Component Table  
 Step 3: Set components to attributes relation
 Step 4: Set components to technologies relation
 TODO: Rollback in Exception | Exception from Subfunctions | Change Return Value
######################################################*/
-- SetComponent   
CREATE OR REPLACE FUNCTION SetComponent (
  vComponentName varchar(250), 
  vComponentParentName varchar(250), 
  vComponentDescription varchar(32672),
  vAttributeList text[], 
  vTechnologyList text[],
  vCreatedBy uuid
 )
  RETURNS TABLE (
	oComponentUUID uuid,
	oComponentName varchar(250),
	oComponentParentName varchar(250),
	oComponentParentUUID uuid,
	oComponentDescription varchar(32672),
	oAttributeList uuid[],
	oTechnologyList uuid[],
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid	
  ) AS
  $$    
      DECLARE 	vAttributeName text; 
        	vTechName text;
		vCompID integer;
		vCompUUID uuid;
		vCompParentUUID uuid := (select case when (vComponentParentName = 'Root') then uuid_generate_v4() else componentuuid end from components where componentname = vComponentParentName);
      BEGIN      
        -- Proof if all technologies are avaiable
        -- Proof if all components are avaiable      
        FOREACH vTechName in array vTechnologyList 
        LOOP 
         	 if not exists (select technologyid from technologies where technologyname = vTechName) then
                 raise exception using
                 errcode = 'invalid_parameter_value',
                 message = 'There is no technology with TechnologyName: ' || vTechName; 
         	 end if;
        END LOOP;
        -- Proof if all Attributes are avaiable     
        FOREACH vAttributeName in array vAttributeList 
        LOOP 
         	 if not exists (select attributeid from public.attributes where attributename = vAttributeName) then
               perform public.createattribute(vAttributeName,vCreatedBy);
        	 end if;
        END LOOP;
        
        -- Create new Component
        perform public.createcomponent(vCompParentUUID,vComponentName, vComponentdescription, vCreatedby);
		vCompID := (select currval('ComponentID')); 
		vCompUUID := (select componentuuid from components where componentID = vCompID);
        
        -- Create relation from Components to TechnologyData 
        perform public.CreateComponentsAttribute(vCompUUID, vAttributeList);  
        
        -- Create relation from Components to TechnologyData 
        perform public.CreateComponentsTechnologies(vCompUUID, vTechnologyList); 
     	
        -- Begin Log if success
        perform public.createlog(0,'Set Component sucessfully','SetComponent', 
                                'ComponentID: ' || cast(vCompID as varchar) || ', componentname: ' 
                                || vComponentName || ', componentdescription: ' || vComponentDescription 
                                || ', CreatedBy: ' || cast(vCreatedBy as varchar));
                                
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
		left outer join components cs
		on co.componentparentid = cs.componentid
		join componentsattribute ca 
		on cs.componentid = ca.componentid
		join attributes att 
		on ca.attributeid = att.attributeid
		join componentstechnologies ct 
		on cs.componentid = ct.componentid
		join technologies tc 
		on tc.technologyid = ct.technologyid		
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
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-14
-- Description: Script to set a new Technology Data
-- ##########################################################################
Create a complete Technology Data
Input paramteres: 
	- TechnologyDataName: String
    - TechnologyData: String
    - TechnologyDataDescription: String
	- LicenseFee: integer
    - TagList: List of Strings
    - UserID: UUID
    - TechnologyName: String
    - ComponentList: List of Integers
Return Value: 
 ***********************************************
 Step 1: Proof if all Components are avaiable, if not return error
 Step 2: Proof if all Tags are avaiable, if not create them
 Step 3: Proof if the thechnology exists
 Step 4: Insert values into the TechnologyData Table  
 Step 5: Set components to technologydata relation
 Step 6: Set tags to technologydata relation
 TODO: Rollback in Exception | Exception from Subfunctions | Change Return Value
######################################################*/
-- Set TechnologyData  
 CREATE OR REPLACE FUNCTION public.settechnologydata(  
	vTechnologyDataName varchar(250), 
	vTechnologyData varchar(32672), 
	vTechnologyDataDescription varchar(32672), 
	vtechnologyuuid uuid,
	vLicensefee integer,
	vRetailPrice integer,
	vTaglist text[],	
	vComponentlist text[],
	-- vTechnologyDataAuthor uuid,
	vCreatedby uuid)
  RETURNS TABLE (
	oTechnologyDataUUID uuid,
	oTechnologyDataName varchar(250),
	oTechnologyUUID uuid,
	oTechnologyData varchar(32672),
	oLicenseFee integer,
	oRetailPrice integer,
	oTechnologyDataDescription varchar(32672),
	oTechnologyDataThumbnail bytea,
	oTechnologyDataImgRef character varying,
	oTagList uuid[],
	oComponentList uuid[],
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid
  ) AS	  
$BODY$    
      DECLARE 	vCompName text;
				vTagName text; 
				vTechnologyDataID int; 
				vTechnologyDataUUID uuid;
				vUserID integer := (select userid from users where useruuid = vCreatedby);
				vTechnologyID integer := (select technologyID from technologies where technologyUUID = vTechnologyUUID);
      BEGIN        
        -- Proof if all components are avaiable      
        FOREACH vCompName in array vComponentlist 
        LOOP 
         	 if not exists (select componentid from components where componentname = vCompName) then
                 raise exception using
                 errcode = 'invalid_parameter_value',
                 message = 'There is no component with ComponentName: ' || vCompName; 
         	 end if;
        END LOOP;
        -- Proof if all Tags are avaiable     
        FOREACH vTagName in array vTagList 
        LOOP 
         	 if not exists (select tagID from tags where tagname = vTagName) then
			perform public.createtag(vTagName,vCreatedby);
        	 end if;
        END LOOP;
        -- Proof if technology is avaiable  
        if not exists (select technologyid from technologies where technologyuuid = vTechnologyUUID) then
        	raise exception using
            errcode = 'invalid_parameter_value',
            message = 'There is no technology with TechnologyID: ' || vTechnologyID::text; 
        end if;
        
        -- Create new TechnologyData  
		perform public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vRetailPrice, vTechnologyUUID, vCreatedBy); 		
        vTechnologyDataID := (select currval('TechnologyDataID'));
        vTechnologyDataUUID := (select technologydatauuid from technologydata where technologydataid = vTechnologyDataID);
        -- Create relation from Components to TechnologyData 
        perform public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList);
        
        -- Create relation from Tags to TechnologyData 
        perform public.CreateTechnologyDataTags(vTechnologyDataUUID, vTagList);
     	
        -- Begin Log if success
        perform public.createlog(0,'Set TechnologyData sucessfully', 'SetTechnologyData', 
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || vTechnologyDataName || ', TechnologyData: ' || vTechnologyData 
                                || ', TechnologyDataDescription: ' || vTechnologyDataDescription 
                                || ', CreatedBy: ' || cast(vUserID as varchar));
                                
        -- End Log if success
        -- Return vTechnologyDataUUID
        RETURN QUERY (
		select 	TechnologyDataUUID,
			TechnologyDataName,
			vTechnologyUUID,
			TechnologyData,
			LicenseFee,
			RetailPrice,
			TechnologyDataDescription,
			TechnologyDataThumbnail,
			TechnologyDataImgRef,
			array_agg(tg.taguuid) as TagList,
			array_agg(co.componentuuid) as ComponentList,
			td.CreatedAt at time zone 'utc',
			vCreatedBy as CreatedBy
		from technologydata td
		join technologydatatags tt on
		td.technologydataid = tt.technologydataid
		join tags tg on tt.tagid = tg.tagid
		join technologydatacomponents tc 
		on tc.technologydataid = td.technologydataid
		join components co 
		on co.componentid = tc.componentid
		where td.technologydataid = vTechnologyDataID
		group by technologydatauuid, technologydataname, technologydata,
			 licensefee, retailprice, technologydatadescription, technologydatathumbnail,
			 TechnologyDataImgRef, td.createdat, td.createdby
        );
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'SetTechnologyData', 
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || vTechnologyDataName || ', TechnologyData: ' || vTechnologyData 
                                || ', TechnologyDataDescription: ' || vTechnologyDataDescription 
                                || ', CreatedBy: ' || cast(vUserID as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql;
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-14
-- Description: Script to set a new PaymentInvoice inclusiv Offer
-- ##########################################################################
Create a complete PaymentInvoice with Offer
Input paramteres:  
Return Value:
 ***********************************************
 Step 1:  
 TODO: Rollback in Exception | Exception from Subfunctions | Change Return Value
######################################################*/
-- SetPaymentInvoiceOffer  
CREATE OR REPLACE FUNCTION SetPaymentInvoiceOffer ( 
	vOfferRequestUUID uuid,
	vInvoice varchar(32672),
	vCreatedBy uuid	
 )
  RETURNS TABLE (
	paymentinvoiceuuid uuid, 
	invoice varchar(32672),
	offeruuid uuid,	
	paymentcreatedat timestamp with time zone,
	paymentcreatedby uuid,
	offercreatedat timestamp with time zone,
	offercreatedby uuid
	)
  
   AS
  $$    
      DECLARE  
		vPaymentInvoiceID integer;
		vPaymentInvoiceUUID uuid;
		vUserID integer := (select userid from users where useruuid = vCreatedBy);
      BEGIN      
        -- Create PaymentInvoice
        perform createpaymentinvoice(vInvoice,vOfferRequestUUID,vCreatedBy);
        vPaymentInvoiceID := (select currval('PaymentInvoiceID'));
        vPaymentInvoiceUUID := (select paymentinvoice.paymentinvoiceuuid from paymentinvoice where paymentinvoiceid = vPaymentInvoiceID);
		
	-- Create Offer
	perform createoffer(vPaymentInvoiceUUID, vCreatedBy);

        -- Begin Log if success
        perform public.createlog(0,'Set SetPaymentInvoiceOffer sucessfully', 'SetPaymentInvoiceOffer', 
                                'OfferRequestID: ' || cast(vOfferRequestUUID as varchar)
				|| ', invoice: ' || vInvoice  
                                || ', CreatedBy: ' || cast(vUserID as varchar));
                                
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
                                || ', CreatedBy: ' || cast(vUserID as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-15
-- Description: Script to get all Technology Data
-- ##########################################################################
Create a complete Technology Data
Input paramteres: none	
Return Value: Table with all TechnologyData 
######################################################*/
CREATE FUNCTION GetAllTechnologyData() 
	RETURNS TABLE
    	(
			technologydatauuid uuid,
			technologyuuid uuid,    		
			technologydataname varchar(250),
			technologydata varchar(32672),
			technologydatadescription varchar(32672),
			licensefee integer,
			retailprice integer,
			technologydatathumbnail bytea,
			technologydataimgref varchar(4000),
			createdat timestamp with time zone,
			createdby uuid,	
			updatedat timestamp with time zone,
			useruuid uuid
        )
    AS $$ 
    	SELECT 	technologydatauuid,
				tc.technologyuuid,    		
				technologydataname,
				technologydata,
				technologydatadescription,
				licensefee,				
				retailprice,
				technologydatathumbnail,
				technologydataimgref,
				td.createdat  at time zone 'utc',
				ur.useruuid as createdby,	
				td.updatedat  at time zone 'utc',
				us.useruuid as UpdatedBy
		FROM TechnologyData td
		join technologies tc 
		on td.technologyid = tc.technologyid
		join users ur on td.createdby = ur.userid
		left outer join users us 
		on td.updatedby = us.userid
	$$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-15
-- Description: Script to get a Technology Data by given UUID
-- ##########################################################################
GEt a Technology Data
Input paramteres: technologyUUID uuid
				  userUUID uuid
Return Value: Table with all TechnologyData 
######################################################*/
  CREATE FUNCTION public.GetTechnologyDataByID(
    vtechnologydatauuid uuid,
    vuseruuid uuid)
RETURNS TABLE
    	(
			technologydatauuid uuid,
			technologyuuid uuid,    		
			technologydataname varchar(250),
			technologydata varchar(32672),
			technologydatadescription varchar(32672),
			licensefee integer,
			retailprice integer,
			technologydatathumbnail bytea,
			technologydataimgref varchar(4000),
			createdat timestamp with time zone,
			createdby uuid,	
			updatedat timestamp with time zone,
			useruuid uuid
        )
    AS $$ 
    	SELECT 	technologydatauuid,
				tc.technologyuuid,    		
				technologydataname,
				technologydata,
				technologydatadescription,
				licensefee,
				retailprice,
				technologydatathumbnail,
				technologydataimgref,
				td.createdat  at time zone 'utc',
				ur.useruuid as createdby,	
				td.updatedat  at time zone 'utc',
				us.useruuid as UpdatedBy
		FROM TechnologyData td
		join technologies tc 
		on td.technologyid = tc.technologyid
		join users ur on td.createdby = ur.userid
		left outer join users us 
		on td.updatedby = us.userid
		where technologydatauuid = vtechnologydatauuid;
	$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-15
-- Description: Script to get a Technology Data by given Name
-- ##########################################################################
GEt a Technology Data
Input paramteres: technologyDataNane varchar(250)
				  userUUID uuid
Return Value: Table with all TechnologyData 
######################################################*/
CREATE FUNCTION GetTechnologyDataByName(
		vTechnologyDataName varchar(250),
		vUserUUID uuid
		) 
RETURNS TABLE
    	(
			technologydatauuid uuid,
			technologyuuid uuid,    		
			technologydataname varchar(250),
			technologydata varchar(32672),
			technologydatadescription varchar(32672),
			licensefee integer,
			retailprice integer,
			technologydatathumbnail bytea,
			technologydataimgref varchar(4000),
			createdat timestamp with time zone,
			createdby uuid,	
			updatedat timestamp with time zone,
			useruuid uuid
        )
    AS $$ 
    	SELECT 	technologydatauuid,
				tc.technologyuuid,    		
				technologydataname,
				technologydata,
				technologydatadescription,
				licensefee,
				retailprice,
				technologydatathumbnail,
				technologydataimgref,
				td.createdat  at time zone 'utc',
				ur.useruuid as createdby,	
				td.updatedat  at time zone 'utc',
				us.useruuid as UpdatedBy
		FROM TechnologyData td
		join technologies tc 
		on td.technologyid = tc.technologyid
		join users ur on td.createdby = ur.userid
		left outer join users us 
		on td.updatedby = us.userid
		where technologydataname = vTechnologyDataName;
	$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-15
-- Description: Script to get all Components
-- ##########################################################################
Get all Components
Input paramteres: none	
Return Value: Table with all Components 
######################################################*/
CREATE FUNCTION GetAllComponents() 
	RETURNS TABLE
    	(
    componentuuid uuid,
    componentname character varying(250),
    componentparentuuid integer,
    componentdescription character varying(32672), 
    createdat timestamp  with time zone,
    createdby uuid,
    updatedat timestamp  with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  componentuuid,
    		componentname,
    		componentparentid,
		componentdescription, 
    		cp.createdat  at time zone 'utc',
    		ur.useruuid as createdby,
    		cp.updatedat  at time zone 'utc',
    		us.useruuid as updatedby 
    FROM Components cp
    join users ur on cp.createdby = ur.userid
    left outer join users us on cp.updatedby = ur.userid
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-21
-- Description: Script to get a Component based on the ComponentUUID
-- ##########################################################################
Get a Component
Input paramteres: componentuuid: uuid
Return Value: Table with all Components 
######################################################*/
CREATE FUNCTION GetComponentByID(vCompUUID uuid) 
	RETURNS TABLE
    	(
    componentuuid uuid,
    componentname character varying(250),
    componentparentuuid integer,
    componentdescription character varying(32672), 
    createdat timestamp  with time zone,
    createdby uuid,
    updatedat timestamp  with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  componentuuid,
    		componentname,
    		componentparentid,
		componentdescription, 
    		cp.createdat  at time zone 'utc',
    		ur.useruuid as createdby,
    		cp.updatedat  at time zone 'utc',
    		us.useruuid as updatedby 
    FROM Components cp
    join users ur on cp.createdby = ur.userid
    left outer join users us on cp.updatedby = ur.userid 
    WHERE componentuuid = vCompUUID;
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-21
-- Description: Script to get a Component based on the ComponentName
-- ##########################################################################
Get a Component
Input paramteres: componentname: string
Return Value: Table with all Components 
######################################################*/
CREATE FUNCTION GetComponentByName(vCompName varchar(250)) 
	RETURNS TABLE
    	(
    componentuuid uuid,
    componentname character varying(250),
    componentparentuuid integer,
    componentdescription character varying(32672), 
    createdat timestamp  with time zone,
    createdby uuid,
    updatedat timestamp  with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  componentuuid,
    		componentname,
    		componentparentid,
		componentdescription, 
    		cp.createdat  at time zone 'utc',
    		ur.useruuid as createdby,
    		cp.updatedat  at time zone 'utc',
    		us.useruuid as updatedby 
    FROM Components cp
    join users ur on cp.createdby = ur.userid
    left outer join users us on cp.updatedby = ur.userid
    WHERE componentname = vCompName;
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-16
-- Description: Script to get all Tags
-- ##########################################################################
Get all Tags
Input paramteres: none	
Return Value: Table with all Tags 
######################################################*/
CREATE FUNCTION GetAllTags() 
	RETURNS TABLE
    	(
    taguuid uuid,
    tagname character varying(250),    
    createdat timestamp  with time zone,
    createdby uuid,
    updatedat timestamp  with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  taguuid,
    		tagname, 
    		tg.createdat  at time zone 'utc',
    		ur.useruuid as createdby,
    		tg.updatedat  at time zone 'utc',
    		us.useruuid as updatedby 
    FROM tags tg
    join users ur on tg.createdby = ur.userid
    left outer join users us on tg.updatedby = ur.userid
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-21
-- Description: Script to get a Tag based on the taguuid
-- ##########################################################################
Get a Tag
Input paramteres: TagUUID: uuid	
Return Value: Table with all Tags 
######################################################*/
CREATE FUNCTION GetTagByID(vTagID uuid) 
	RETURNS TABLE
    	(
    taguuid uuid,
    tagname character varying(250),    
    createdat timestamp  with time zone,
    createdby uuid,
    updatedat timestamp  with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  taguuid,
    		tagname, 
    		tg.createdat  at time zone 'utc',
    		ur.useruuid as createdby,
    		tg.updatedat  at time zone 'utc',
    		us.useruuid as updatedby 
    FROM tags tg
    join users ur on tg.createdby = ur.userid
    left outer join users us on tg.updatedby = ur.userid
    WHERE tagUUID = vTagID;
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-21
-- Description: Script to get a Tag based on the tagName
-- ##########################################################################
Get a Tag
Input paramteres: TagName: string
Return Value: Table with all Tags 
######################################################*/
CREATE FUNCTION GetTagByName(vTagName varchar(250)) 
	RETURNS TABLE
    	(
    taguuid uuid,
    tagname character varying(250),    
    createdat timestamp  with time zone,
    createdby uuid,
    updatedat timestamp  with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  taguuid,
    		tagname, 
    		tg.createdat  at time zone 'utc',
    		ur.useruuid as createdby,
    		tg.updatedat  at time zone 'utc',
    		us.useruuid as updatedby 
    FROM tags tg
    join users ur on tg.createdby = ur.userid
    left outer join users us on tg.updatedby = ur.userid
	WHERE tagName = vTagName;
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-16
-- Description: Script to get all Technologies
-- ##########################################################################
Get all Technologies
Input paramteres: none	
Return Value: Table with all Technologies
######################################################*/
CREATE FUNCTION GetAllTechnologies() 
	RETURNS TABLE
    	(
    technologyuuid uuid,
    technologyname character varying(250),
    technologydescription character varying(32672),            
    createdat timestamp  with time zone,
    createdby uuid,
    updatedat timestamp  with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  technologyuuid,
    		technologyname, 
		technologydescription, 
    		tg.createdat at time zone 'utc',
    		ur.useruuid as createdby,
    		tg.updatedat at time zone 'utc',
    		us.useruuid as updatedby 
    FROM Technologies tg
    JOIN users ur ON tg.createdby = ur.userid
    LEFT OUTER JOIN users us ON tg.updatedby = us.userid
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-21
-- Description: Script to get a Technology based on the technologyUUID
-- ##########################################################################
Get all Technologies
Input paramteres: TechnologyUUID: uuid	
Return Value: Table with the Technology filter by TechnologyUUID
######################################################*/
CREATE FUNCTION GetTechnologyByID(vtechUUID uuid) 
	RETURNS TABLE
    	(
    technologyuuid uuid,
    technologyname character varying(250),
    technologydescription character varying(32672),            
    createdat timestamp  with time zone,
    createdby uuid,
    updatedat timestamp  with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  technologyuuid,
    		technologyname, 
		technologydescription, 
    		tg.createdat at time zone 'utc',
    		ur.useruuid as createdby,
    		tg.updatedat at time zone 'utc',
    		us.useruuid as updatedby 
    FROM Technologies tg
    JOIN users ur ON tg.createdby = ur.userid
    LEFT OUTER JOIN users us ON tg.updatedby = us.userid
	WHERE technologyuuid = vtechUUID;
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-21
-- Description: Script to get a Technology based on the technologyname
-- ##########################################################################
Get all Technologies
Input paramteres: TechnologyName: string
Return Value: Table with the Technology filter by TechnologyName
######################################################*/
CREATE FUNCTION GetTechnologyByName(vtechName varchar) 
	RETURNS TABLE
    	(
    technologyuuid uuid,
    technologyname character varying(250),
    technologydescription character varying(32672),            
    createdat timestamp  with time zone,
    createdby uuid,
    updatedat timestamp  with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  technologyuuid,
    		technologyname, 
		technologydescription, 
    		tg.createdat at time zone 'utc',
    		ur.useruuid as createdby,
    		tg.updatedat at time zone 'utc',
    		us.useruuid as updatedby 
    FROM Technologies tg
    JOIN users ur ON tg.createdby = ur.userid
    LEFT OUTER JOIN users us ON tg.updatedby = us.userid
	WHERE technologyname = vtechName;
    $$ LANGUAGE SQL;
/*##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-16
-- Description: Script to get all Technologies
-- Change: insert new output values
-- ##########################################################################
Get all Technologies
Input paramteres: none	
Return Value: Table with all Technologies
######################################################*/
CREATE FUNCTION GetTechnologyDataByParams(
    	userUUID varchar, vtechdata varchar, vtechnologies varchar, vtags varchar, vcomponents varchar, vattributes varchar
		) 
	RETURNS TABLE
    	(	
		technologydatauuid uuid,		
		technologydataname character varying,
		technologydatadescription varchar,
		technologydata varchar(32672),
		licensefee integer,
		retailprice integer,
		technologydatathumbnail bytea,
		technologydataimgRef varchar,
		useruuid uuid,
		createdat timestamp with time zone,
		updatedat timestamp with time zone,
		technologyname varchar,
        tagname varchar[],
        componentname varchar[],
		attributename varchar
        )
    AS $$ 
    SELECT 	
	td.technologydatauuid,
    	td.technologydataname as technologydataname,
    	td.technologydatadescription,
    	td.technologydata,
    	td.licensefee,
		td.retailprice,
    	td.technologydatathumbnail,
    	td.technologydataimgref,
    	us.useruuid,
    	td.createdat at time zone 'utc',
    	td.updatedat at time zone 'utc',
        tc.technologyname as technologyname,
        array_agg(tg.tagname) as tagname,
        array_agg(ct.componentname) as componentname,
        att.attributename
    FROM technologydata td 
    JOIN technologydatatags tdt ON td.technologydataid = tdt.technologydataid
    JOIN tags tg ON tdt.tagid = tg.tagid
    JOIN technologydatacomponents tdc ON tdc.technologydataid = td.technologydataid
    JOIN components ct ON ct.componentid = tdc.componentid
    JOIN technologies tc ON tc.technologyid = td.technologyid
    JOIN componentsattribute cta ON cta.componentid = ct.componentid
    JOIN attributes att ON att.attributeid = cta.attributeid
    JOIN users us ON us.userid = td.createdby
    WHERE (vtechdata IS NULL OR td.technologydataname IN (vtechdata)) 
    AND (vtechnologies IS NULL OR tc.technologyname IN (vtechnologies)) 
    AND (vtags IS NULL OR tg.tagname IN (vtags)) 
    AND (vcomponents IS NULL OR ct.componentname in (vcomponents))
    AND (vattributes IS NULL OR att.attributename in (vattributes))
    GROUP BY 	td.technologydatauuid,
		td.technologydataname,
		td.technologydatadescription,
		td.technologydata,
		td.licensefee,
		td.retailprice,
		td.technologydatathumbnail,
		td.technologydataimgref,
		us.useruuid,
		td.createdat,
		td.updatedat,
		tc.technologyname,
		att.attributename;
    
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-23
-- Description: Script to get all users
-- ##########################################################################
Get all Users
Input paramteres: none
Return Value: Table with all users
######################################################*/
CREATE FUNCTION GetAllUsers() 
	RETURNS TABLE
    	(
    useruuid uuid,
    userfirstname character varying(250),
    userlastname character varying(250),            
    useremail character varying(250),            
    createdat timestamp  with time zone,       
    updatedat timestamp  with time zone
        )
    AS $$ 
	SELECT  useruuid uuid,
		userfirstname,
		userlastname,            
		useremail,            
		createdat at time zone 'utc',       
		updatedat at time zone 'utc'
    FROM Users;
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-23
-- Description: Script to user by useruuid
-- ##########################################################################
Get a User based on the given useruuid
Input paramteres: UserUUID uuid
Return Value: Table with a user
######################################################*/
CREATE FUNCTION GetUserByID(vUserUUID uuid) 
	RETURNS TABLE
    	(
    useruuid uuid,
    userfirstname character varying(250),
    userlastname character varying(250),            
    useremail character varying(250),            
    createdat timestamp  with time zone,       
    updatedat timestamp  with time zone
        )
    AS $$ 
	SELECT  useruuid uuid,
		userfirstname,
		userlastname,            
		useremail,            
		createdat at time zone 'utc',       
		updatedat at time zone 'utc'
    FROM Users WHERE UserUUID = vUserUUID;
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-23
-- Description: Script to user by user name
-- ##########################################################################
Get all Users based on the given user fistname or lastname
Input paramteres: UserFirstName  varchar(250) OR
		  UserLastName  varchar(250) 		
Return Value: Table with all users that match the input parameters
######################################################*/
CREATE FUNCTION GetUserByName(vUserFirstName varchar(250), vUserLastName varchar(250)) 
	RETURNS TABLE
    	(
    useruuid uuid,
    userfirstname character varying(250),
    userlastname character varying(250),            
    useremail character varying(250),            
    createdat timestamp  with time zone,       
    updatedat timestamp  with time zone
        )
    AS $$ 
	SELECT  useruuid uuid,
		userfirstname,
		userlastname,            
		useremail,            
		createdat at time zone 'utc',       
		updatedat at time zone 'utc'
	FROM Users
	WHERE 	(vUserFirstName IS NULL OR users.userfirstname = vUserFirstName)
	AND 	(vUserLastName IS NULL OR users.userlastname = vUserLastName);
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-23
-- Description: Script to get all offers
-- ##########################################################################
Get all offers 
Input paramteres: none		
Return Value: Table with all offers
######################################################*/
CREATE FUNCTION GetAllOffers() 
	RETURNS TABLE
    	(
    offeruuid uuid,    
    paymentinvoiceuuid uuid,
    createdat timestamp with time zone,
    createdby uuid
        )
    AS $$ 
	SELECT  offeruuid,                
	        paymentinvoiceuuid,
	        offr.createdat at time zone 'utc',
	        ur.useruuid as createdby
	FROM offer offr JOIN
	paymentinvoice pi ON offr.paymentinvoiceid = pi.paymentinvoiceid	 
	JOIN Users ur ON offr.createdby = ur.userid
    $$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-28
-- Description: Script to get all attributes
-- ##########################################################################
Get all attributes
Input paramteres: none		
Return Value: Table with all attributes
######################################################*/
CREATE FUNCTION GetAllAttributes() 
	RETURNS TABLE
    	(
    attributeuuid uuid,    
    attributename varchar(250),
    createdat timestamp with time zone,
    createdby uuid,
    updatedat timestamp with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  attributeuuid,                
	        attributename,
	        att.createdat at time zone 'utc',
	        ur.useruuid as createdby,
	        att.updatedat at time zone 'utc',
	        us.useruuid as updatedby
	FROM attributes att
	JOIN users ur ON att.createdby = ur.userid 
	LEFT OUTER JOIN users us ON att.updatedby = us.userid    
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-28
-- Description: Script to get attribute by given ID
-- ##########################################################################
Input paramteres: attributeUUID uuid		
Return Value: Table with a attribute
######################################################*/
CREATE FUNCTION GetAttributeByID(vAttrUUID uuid) 
	RETURNS TABLE
    	(
    attributeuuid uuid,    
    attributename varchar(250),
    createdat timestamp with time zone,
    createdby uuid,
    updatedat timestamp with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  attributeuuid,                
	        attributename,
	        att.createdat at time zone 'utc',
	        ur.useruuid as createdby,
	        att.updatedat at time zone 'utc',
	        us.useruuid as updatedby
	FROM attributes att
	JOIN users ur ON att.createdby = ur.userid 
	LEFT OUTER JOIN users us ON att.updatedby = us.userid 
	WHERE attributeUUID = vAttrUUID;
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-28
-- Description: Script to get attribute by given Name
-- ##########################################################################
Input paramteres: attributeName varchar(250)
Return Value: Table with a attribute
######################################################*/
CREATE FUNCTION GetAttributeByName(vAttrName varchar(250)) 
	RETURNS TABLE
    	(
    attributeuuid uuid,    
    attributename varchar(250),
    createdat timestamp with time zone,
    createdby uuid,
    updatedat timestamp with time zone,
    updatedby uuid
        )
    AS $$ 
	SELECT  attributeuuid,                
	        attributename,
	        att.createdat at time zone 'utc',
	        ur.useruuid as createdby,
	        att.updatedat at time zone 'utc',
	        us.useruuid as updatedby
	FROM attributes att
	JOIN users ur ON att.createdby = ur.userid 
	LEFT OUTER JOIN users us ON att.updatedby = us.userid 
	WHERE attributeName = vAttrName;
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-28
-- Description: Script to get the offer based on the offerrequestid
-- ##########################################################################
Get a offer 
Input paramteres: OfferRequestID uuid		
Return Value: Table with a offer
######################################################*/
CREATE FUNCTION GetOfferByRequestID(vRequestID uuid) 
	RETURNS TABLE
    	(
    offeruuid uuid, 
    paymentinvoiceuuid uuid,
    createdat timestamp with time zone,
    createdby uuid 
        )
    AS $$ 
	SELECT  ofr.offeruuid,                
	        pm.paymentinvoiceuuid,
	        ofr.createdat at time zone 'utc',
	        ur.useruuid
	FROM offer ofr 	
	JOIN paymentinvoice pm 
	ON ofr.paymentinvoiceid = pm.paymentinvoiceid
	JOIN users ur 
	ON ofr.createdby = ur.userid	
	WHERE pm.offerrequestid = (select offerrequest.offerrequestid from offerrequest where offerrequestuuid = vRequestID)
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-28
-- Description: Script to get the offer based on the offerid
-- ##########################################################################
Get a offer 
Input paramteres: OfferUUID uuid		
Return Value: Table with a offer
######################################################*/
CREATE FUNCTION GetOfferByID(vOfferID uuid) 
	RETURNS TABLE
    	(
    offeruuid uuid, 
    paymentinvoiceuuid uuid,
    createdat timestamp with time zone, 
    createdby uuid
        )
    AS $$ 
	SELECT  ofr.offeruuid,                
	        pm.paymentinvoiceuuid,
	        ofr.createdat at time zone 'utc',
	        ur.useruuid
	FROM offer ofr 	
	JOIN paymentinvoice pm 
	ON ofr.paymentinvoiceid = pm.paymentinvoiceid
	JOIN users ur 
	ON ofr.createdby = ur.userid	
	WHERE ofr.offeruuid = vOfferID
    $$ LANGUAGE SQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-23
-- Description: Script to get the offer based on the technologydata
-- ##########################################################################
Get a offer 
Input paramteres: TechnologyData uuid
Return Value: Table with a offer
######################################################
CREATE FUNCTION GetOfferByTechDataID(vTechDataID uuid) 
	RETURNS TABLE
    	(
    offeruuid uuid,
    offerrequestuuid uuid,
    paymentinvoiceuuid uuid 
        )
    AS $$ 
	SELECT  ofr.offeruuid,
                ofq.offerrequestuuid,
	        paymentinvoiceuuid 
	FROM offer ofr 
	JOIN OfferRequest ofq
	ON ofr.offerrequestid = ofq.offerrequestid
	JOIN payment pm 
	ON ofr.paymentinvoiceid = pm.paymentinvoiceid
	JOIN technologydata td 
	ON ofq.technologydataid = td.technologydataid
	WHERE td.technologydatauuid = vTechDataID
    $$ LANGUAGE SQL;*/
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-23
-- Description: Script to get the offer based on the payment invoce id
-- ##########################################################################
Get a offer 
Input paramteres: PaymentInvoceUUID uuid
Return Value: Table with a offer
######################################################
CREATE FUNCTION GetOfferByPaymentInvoiceID(vPayInvID uuid) 
	RETURNS TABLE
    	(
    offeruuid uuid,
    offerrequestuuid uuid,
    paymentinvoiceuuid uuid 
        )
    AS $$ 
	SELECT  ofr.offeruuid,
                ofq.offerrequestuuid,
	        paymentinvoiceuuid 
	FROM offer ofr 
	JOIN OfferRequest ofq
	ON ofr.offerrequestid = ofq.offerrequestid
	JOIN payment pm 
	ON ofr.paymentinvoiceid = pm.paymentinvoiceid 
	WHERE pm.paymentinvoiceuuid = vPayInvID
    $$ LANGUAGE SQL;*/

/* ##########################################################################
-- Source: http://www.sqlines.com/postgresql/how-to/datediff   
-- Description: Get the diff between two dates
-- ##########################################################################
Input paramteres: units 	varchar(30)
				  start_t 	timestamp
				  end_t		timestamp	
Return Value: Difference between dates in Seconds, Minutes, Hours, Months or Years
######################################################*/
CREATE FUNCTION DateDiff (units VARCHAR(30), start_t TIMESTAMP, end_t TIMESTAMP) 
     RETURNS INT AS $$
   DECLARE
     diff_interval INTERVAL; 
     diff INT = 0;
     years_diff INT = 0;
   BEGIN
     IF units IN ('yy', 'yyyy', 'year', 'mm', 'm', 'month') THEN
       years_diff = DATE_PART('year', end_t) - DATE_PART('year', start_t);
 
       IF units IN ('yy', 'yyyy', 'year') THEN
         -- SQL Server does not count full years passed (only difference between year parts)
         RETURN years_diff;
       ELSE
         -- If end month is less than start month it will subtracted
         RETURN years_diff * 12 + (DATE_PART('month', end_t) - DATE_PART('month', start_t)); 
       END IF;
     END IF;
 
     -- Minus operator returns interval 'DDD days HH:MI:SS'  
     diff_interval = end_t - start_t;
 
     diff = diff + DATE_PART('day', diff_interval);
 
     IF units IN ('wk', 'ww', 'week') THEN
       diff = diff/7;
       RETURN diff;
     END IF;
 
     IF units IN ('dd', 'd', 'day') THEN
       RETURN diff;
     END IF;
 
     diff = diff * 24 + DATE_PART('hour', diff_interval); 
 
     IF units IN ('hh', 'hour') THEN
        RETURN diff;
     END IF;
 
     diff = diff * 60 + DATE_PART('minute', diff_interval);
 
     IF units IN ('mi', 'n', 'minute') THEN
        RETURN diff;
     END IF;
 
     diff = diff * 60 + DATE_PART('second', diff_interval);
 
     RETURN diff;
   END;
   $$ LANGUAGE plpgsql;
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-28
-- Description: Script Get amount of activated licenses by given time
-- ##########################################################################
Input paramteres: vTime  timestamp
Return Value: Amount of activated licenses 
######################################################*/
CREATE FUNCTION GetActivatedLicensesSince (vTime timestamp)
RETURNS integer AS
$$ 
	;with activatedLinceses as(
		select * from licenseorder lo
		join offer of on lo.offerid = of.offerid
		join paymentinvoice pi on
		of.paymentinvoiceid = pi.paymentinvoiceid
		join offerrequest oq on
		pi.offerrequestid = oq.offerrequestid
		join technologydata td on
		oq.technologydataid = td.technologydataid
		)
	select count(*)::integer from activatedLinceses	where 
	(select datediff('second',vTime::timestamp,activatedat::timestamp)) >= 0 AND
	(select datediff('minute',vTime::timestamp,activatedat::timestamp)) >= 0 AND
	(select datediff('hour',vTime::timestamp,activatedat::timestamp)) >= 0;
 
$$ LANGUAGE SQL;
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-07
-- Description: Script Get Top x since given Date
-- ##########################################################################
Input paramteres: vSinceDate  timestamp
				  vTopValue integer
Return Value: TechnologyDataName, Rank value 
######################################################*/
CREATE FUNCTION GetTopTechnologyDataSince(
		vSinceDate timestamp without time zone,
		vTopValue integer
	)
RETURNS TABLE (
	oTechnologyDataName varchar(250),
	oRank integer
	) AS 
$$	 
	;with activatedLinceses as(
		select * from licenseorder lo
		join offer of on lo.offerid = of.offerid
		join paymentinvoice pi on
		of.paymentinvoiceid = pi.paymentinvoiceid
		join offerrequest oq on
		pi.offerrequestid = oq.offerrequestid
		join technologydata td on
		oq.technologydataid = td.technologydataid
		),
	rankTable as (
	select technologydataname, count(technologydataname) as rank from activatedLinceses where 
	(select datediff('second',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
	(select datediff('minute',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
	(select datediff('hour',vSinceDate::timestamp,activatedat::timestamp)) >= 0
	group by technologydataname)
	select technologydataname::varchar(250), rank::integer from rankTable
	order by rank desc limit vTopValue;	
$$ LANGUAGE SQL; 
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-07
-- Description: Script Get most used components since given Date
-- ##########################################################################
Input paramteres: vSinceDate  timestamp
				  vTopValue integer
Return Value: ComponentName, Amount
######################################################*/
CREATE FUNCTION GetMostUsedComponents(
		vSinceDate timestamp without time zone,
		vTopValue integer
	)
RETURNS TABLE (
	oComponentName varchar(250),
	oAmount integer
) AS
$$
	;with activatedLinceses as(
		select * from licenseorder lo
		join offer of on lo.offerid = of.offerid
		join paymentinvoice pi on
		of.paymentinvoiceid = pi.paymentinvoiceid
		join offerrequest oq on
		pi.offerrequestid = oq.offerrequestid
		join technologydata td on
		oq.technologydataid = td.technologydataid
		join technologydatacomponents tc on 
		tc.technologydataid = td.technologydataid
		join components co on 
		co.componentid = tc.componentid
		),
	rankTable as (
	select componentname, count(componentname) as rank from activatedLinceses where 
	(select datediff('second',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
	(select datediff('minute',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
	(select datediff('hour',vSinceDate::timestamp,activatedat::timestamp)) >= 0
	group by componentname)
	select componentname::varchar(250), rank::integer from rankTable
	order by rank desc limit vTopValue;	
 $$ LANGUAGE SQL;
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-07
-- Description: Script Get workload since given time
-- ##########################################################################
Input paramteres: vSinceDate  timestamp 
Return Value: TechnologyDataName, Date, Amount, DayHour
######################################################*/
 CREATE OR REPLACE FUNCTION GetWorkloadSince(
		vSinceDate timestamp without time zone		
	)
RETURNS TABLE (
	  oTechnologyDataName varchar(250),
	  oDate date,
	  oAmount integer,
	  oDayHour integer
	) AS
$$
	;with activatedLicenses as(
		select * from licenseorder lo
		join offer of on lo.offerid = of.offerid
		join paymentinvoice pi on
		of.paymentinvoiceid = pi.paymentinvoiceid
		join offerrequest oq on
		pi.offerrequestid = oq.offerrequestid
		join technologydata td on
		oq.technologydataid = td.technologydataid
		join technologydatacomponents tc on 
		tc.technologydataid = td.technologydataid
		),
	rankTable as (
	select technologydataname, activatedat, 
	activatedat::date as dateValue, 
	date_part('hour',activatedat) as dayhour from activatedLicenses where 
	(select datediff('second',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
	(select datediff('minute',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
	(select datediff('hour',vSinceDate::timestamp,activatedat::timestamp)) >= 0
	group by technologydataname, activatedat )
	select technologydataname, dateValue, count(dayhour)::integer as amount, dayhour::integer from rankTable		
	group by technologydataname,dateValue, dayhour	 
	order by dayhour asc;	
$$ LANGUAGE SQL; 
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Payment for given OfferRequest
-- ##########################################################################
Input paramteres: vOfferRequestUUID uuid 
######################################################*/
CREATE FUNCTION GetPaymentInvoiceForOfferRequest(
		vOfferRequestUUID uuid
	)
RETURNS TABLE (
	oPaymentInvoiceUUID uuid,
	oOfferRequestUUID uuid,
	oInvoice varchar(32672),
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid
	) AS 
$$	 
	select 	pi.paymentinvoiceuuid,
		oq.offerrequestuuid,
		pi.invoice,		
		pi.createdat at time zone 'utc',
		us.useruuid as createdby
	from PaymentInvoice pi
	join offerrequest oq 
	on pi.offerrequestid = oq.offerrequestid
	join users us on us.userid = pi.createdby
	where oq.offerRequestUUID = vOfferRequestUUID
$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Offer for given PaymentInvoice
-- ##########################################################################
Input paramteres: vPaymentInvoiceUUID uuid 
######################################################*/
CREATE FUNCTION GetOfferForPaymentInvoice(
		vPaymentInvoiceUUID uuid
	)
RETURNS TABLE (
	oOfferUUID uuid,
	oPaymentInvoiceUUID uuid,	
	oCreatedAt timestamp with time zone,
	oCreatedBy uuid
	) AS 
$$	 
	select 	ofr.offerUUID,
		pi.PaymentInvoiceUUID,			
		pi.createdat at time zone 'utc',
		us.useruuid as createdby
	from Offer ofr
	join paymentinvoice pi 
	on ofr.paymentinvoiceid = pi.paymentinvoiceid
	join users us on us.userid = ofr.createdby	
$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Components for given TechnologyUUID
-- ##########################################################################
Input paramteres: vTechnologyUUID uuid 
######################################################*/
CREATE FUNCTION GetComponentsByTechnology(
		vTechnologyUUID uuid
	)
RETURNS TABLE (
		oComponentUUID uuid,		
		oComponentName varchar(250),
		oComponentParentUUID uuid, 
		oComponentParentName varchar(250),
		oComponentDescription varchar(32672),
		oCreatedat timestamp with time zone,
		oCreatedby uuid,
		oUpdatedat timestamp with time zone,
		oUseruuid uuid
	) AS 
$$	 
	select 	co.componentUUID,		
		co.componentName,
		cs.componentUUID as componentParentUUID, 
		cs.componentName as componentParentName,
		co.componentDescription,
		co.createdat at time zone 'utc',
		us.useruuid as createdby,
		co.updatedat at time zone 'utc',
		ur.useruuid as updatedby
	from components co
	join componentstechnologies ct
	on co.componentid = ct.componentid
	join technologies tc
	on tc.technologyid = ct.technologyid
	join users us on us.userid = co.createdby
	left outer join users ur on ur.userid = co.updatedby
	left outer join components cs 
	on co.componentparentid = cs.componentid
	where tc.technologyuuid = vTechnologyUUID	
$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Technology for given OfferRequestUUID
-- ##########################################################################
Input paramteres: vOfferRequestUUID uuid 
######################################################*/
CREATE FUNCTION GetTechnologyForOfferRequest(
		vOfferRequestUUID uuid
	)
RETURNS TABLE (
		oTechnologyuuid uuid,
		oTechnologyName varchar(250),
		oTechnologyDescription varchar(32672),
		oCreatedat timestamp with time zone,
		oCreatedby uuid,
		oUpdatedat timestamp with time zone,
		oUpdatedby uuid
	) AS 
$$	 
	select 	tc.technologyuuid,
		tc.technologyName,
		tc.technologyDescription,
		tc.createdat at time zone 'utc',
		us.useruuid as createdby,
		tc.updatedat at time zone 'utc',
		ur.useruuid as updatedby
	from technologydata td	
	join offerrequest oq
	on oq.technologydataid = td.technologydataid
	join technologies tc
	on tc.technologyid = td.technologyid
	join users us on us.userid = tc.createdby
	left outer join users ur on ur.userid = tc.updatedby
	where oq.offerrequestuuid = vOfferRequestUUID
$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get LicenseFee for given TransactionUUID
-- ##########################################################################
Input paramteres: vTransactionUUID uuid 
######################################################*/
CREATE FUNCTION GetLicenseFeeByTransaction(
		vTransactionUUID uuid
	) 
RETURNS TABLE (
		oLicenseFee integer
	) AS 
$$	 
	select	td.licenseFee
	from transactions ts
	join offerrequest oq
	on oq.offerrequestid = ts.offerrequestid
	join technologydata td
	on oq.technologydataid = td.technologydataid
	where ts.transactionuuid = vTransactionUUID
$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Transaction for given OfferRequestUUID
-- ##########################################################################
Input paramteres: vOfferRequestUUID uuid 
######################################################*/
CREATE OR REPLACE FUNCTION GetTransactionByOfferRequest(
		vOfferRequestUUID uuid
	)
RETURNS TABLE (
		oTransactionuuid uuid,
		oBuyer uuid,
		oOfferuuid uuid,
		oOfferrequestuuid uuid,
		oPaymentuuid uuid,
		oPaymentinvoiceid uuid,
		oLicenseorderuuid uuid,
		oCreatedat timestamp with time zone,
		oCreatedby uuid,
		oUpdatedat timestamp with time zone,
		oUpdatedby uuid
	) AS 
$$	 
	select	ts.transactionuuid,
		us.useruuid as buyer,
		ofr.offeruuid,
		oq.offerrequestuuid,
		py.paymentuuid,
		pi.paymentinvoiceuuid,
		li.licenseorderuuid,
		ts.createdat at time zone 'utc',
		ur.useruuid as createdby,
		ts.updatedat at time zone 'utc',
		uu.useruuid as updatedby
	from transactions ts
	join offerrequest oq
	on ts.offerrequestid = oq.offerrequestid
	and oq.offerrequestuuid = vOfferRequestUUID
	left outer join users us on us.userid = ts.buyerid
	left outer join offer ofr on ofr.offerid = ts.offerid
	left outer join payment py on py.paymentid = ts.paymentid
	left outer join paymentinvoice pi 
	on pi.paymentinvoiceid = ts.paymentinvoiceid
	left outer join licenseorder li 
	on li.licenseorderid = ts.licenseorderid
	left outer join users ur on ur.userid = ts.createdby
	left outer join users uu on uu.userid = ts.updatedby
$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get TechnologyData for given OfferRequestUUID
-- ##########################################################################
Input paramteres: vOfferRequestUUID uuid 
######################################################*/
CREATE FUNCTION GetTechnologyDataByOfferRequest(
		vOfferRequestUUID uuid
		) 
RETURNS TABLE
    	(
			technologydatauuid uuid,
			technologyuuid uuid,    		
			technologydataname varchar(250),
			technologydata varchar(32672),
			technologydatadescription varchar(32672),
			licensefee integer,
			retailprice integer,
			technologydatathumbnail bytea,
			technologydataimgref varchar(4000),
			createdat timestamp with time zone,
			createdby uuid,	
			updatedat timestamp with time zone,
			useruuid uuid
        )
    AS $$ 
    	SELECT 	technologydatauuid,
		tc.technologyuuid,    		
		technologydataname,
		technologydata,
		technologydatadescription,
		licensefee,
		retailprice,
		technologydatathumbnail,
		technologydataimgref,
		td.createdat  at time zone 'utc',
		ur.useruuid as createdby,	
		td.updatedat  at time zone 'utc',
		us.useruuid as UpdatedBy
		FROM TechnologyData td
		join technologies tc 
		on td.technologyid = tc.technologyid
		join offerrequest oq 
		on oq.technologydataid = td.technologydataid
		and oq.offerrequestuuid = vOfferRequestUUID
		join users ur on td.createdby = ur.userid
		left outer join users us 
		on td.updatedby = us.userid;
	$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Offer for given TransactionUUID
-- ##########################################################################
Input paramteres: vTransactionUUID uuid 
######################################################*/	
CREATE FUNCTION GetOfferForTransaction(
		vTransactionUUID uuid
	)
RETURNS TABLE (
		oOfferUUID uuid,
		oPaymentInvoiceUUID uuid,	
		oCreatedAt timestamp with time zone,
		oCreatedBy uuid
	) AS 
$$	 
	select 	ofr.offerUUID,
		pi.PaymentInvoiceUUID,			
		pi.createdat at time zone 'utc',
		us.useruuid as createdby
	from Offer ofr
	join paymentinvoice pi 
	on ofr.paymentinvoiceid = pi.paymentinvoiceid
	join transactions ts 
	on ts.offerid = ofr.offerid
	and ts.transactionuuid = vTransactionUUID
	join users us on us.userid = ofr.createdby	
$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Offer for given TicketID
-- ##########################################################################
Input paramteres: vTicketID varchar(4000) 
######################################################*/	
CREATE FUNCTION GetOfferForTicket(
		vTicketID varchar(4000)
	)
RETURNS TABLE (
		oOfferUUID uuid,
		oPaymentInvoiceUUID uuid,	
		oCreatedAt timestamp with time zone,
		oCreatedBy uuid
	) AS 
$$	 
	select 	ofr.offerUUID,
		pi.PaymentInvoiceUUID,			
		pi.createdat at time zone 'utc',
		us.useruuid as createdby
	from Offer ofr
	join paymentinvoice pi 
	on ofr.paymentinvoiceid = pi.paymentinvoiceid
	join licenseorder lo
	on lo.offerid = ofr.offerid
	and lo.ticketid = vTicketID
	join users us on us.userid = ofr.createdby	
$$ LANGUAGE SQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-13
-- Description: Create Roles
-- ##########################################################################
Input paramteres: vRoleName varchar(250)
				  vRoleDescription varchar(32672)
######################################################*/
create function createrole(vRoleName varchar(250), vRoleDescription varchar(32672)) 
returns void as
$$
	Declare vRoleID integer := (select nextval('RoleID'));
		vRoleUUID uuid := (select uuid_generate_v4());
		vRoleBit integer := (select max(RoleBit)*2 from Roles);
		
	BEGIN
		vRoleBit  := (select case when(vRoleBit is null) then 1 else vRoleBit end);
		insert into roles (RoleID, RoleUUID, RoleBit, RoleName, RoleDescription)
		values (vRoleID, vRoleUUID, vRoleBit, vRoleName, vRoleDescription);

	 -- Begin Log if success
        perform public.createlog(0,'Created Role sucessfully', 'CreateRole', 
                                'RoleID: ' || cast(vRoleID as varchar) || ', RoleBit: ' 
                                || cast(vRoleBit as varchar) || ', vRoleName: ' || vRoleName 
                                || ', RoleDescription: ' 
                                || vRoleDescription);

	 exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateRole', 
                                'RoleID: ' || cast(vRoleID as varchar) || ', RoleBit: ' 
                                || cast(vRoleBit as varchar) || ', vRoleName: ' || vRoleName 
                                || ', RoleDescription: ' 
                                || vRoleDescription);
        -- End Log if error 
	END;
$$ LANGUAGE PLPGSQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-13
-- Description: Create permissions for Roles
-- ##########################################################################
Input paramteres: vRoles integer, 
				  vFunctionName varchar(250)
######################################################*/
create function CreatePermission(
		vRoles integer, 
		vFunctionName varchar(250)
	) 
RETURNS void AS
$$
	DECLARE
		vPermissionID integer := (select nextval('PermissionID'));
		vPermissionUUID uuid := (select uuid_generate_v4());
	BEGIN
		insert into permissions (PermissionID, PermissionUUID, Roles, FunctionName)
		values (vPermissionID, vPermissionUUID, vRoles, vFunctionName);

	-- Begin Log if success
        perform public.createlog(0,'Created Permission sucessfully', 'CreatePermission', 
                                'PermissionID: ' || cast(vPermissionID as varchar) || ', Roles: ' 
                                || vRoles || ', FunctionName: ' || vFunctionName);

	 exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreatePermission', 
                                'PermissionID: ' || cast(vPermissionID as varchar) || ', Roles: ' 
                                || vRoles || ', FunctionName: ' || vFunctionName);
        -- End Log if error 
	END;
$$ LANGUAGE PLPGSQL; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-13
-- Description: Get Transaction by TransactionUUID
-- ##########################################################################
Input paramteres: vTransactionUUID uuid
######################################################*/
CREATE FUNCTION GetTransactionByID(
		vTransactionUUID uuid
	)
RETURNS TABLE (
		oTransactionuuid uuid,
		oBuyer uuid,
		oOfferuuid uuid,
		oOfferrequestuuid uuid,
		oPaymentuuid uuid,
		oPaymentinvoiceid uuid,
		oLicenseorderuuid uuid,
		oCreatedat timestamp with time zone,
		oCreatedby uuid,
		oUpdatedat timestamp with time zone,
		oUpdatedby uuid
	) AS 
$$	 
	select	ts.transactionuuid,
		us.useruuid as buyer,
		ofr.offeruuid,
		oq.offerrequestuuid,
		py.paymentuuid,
		pi.paymentinvoiceuuid,
		li.licenseorderuuid,
		ts.createdat at time zone 'utc',
		ur.useruuid as createdby,
		ts.updatedat at time zone 'utc',
		uu.useruuid as updatedby
	from transactions ts
	join offerrequest oq
	on ts.offerrequestid = oq.offerrequestid
	and ts.transactionuuid = vTransactionUUID
	left outer join users us on us.userid = ts.buyerid
	left outer join offer ofr on ofr.offerid = ts.offerid
	left outer join payment py on py.paymentid = ts.paymentid
	left outer join paymentinvoice pi 
	on pi.paymentinvoiceid = ts.paymentinvoiceid
	left outer join licenseorder li 
	on li.licenseorderid = ts.licenseorderid
	left outer join users ur on ur.userid = ts.createdby
	left outer join users uu on uu.userid = ts.updatedby
$$ LANGUAGE SQL; 