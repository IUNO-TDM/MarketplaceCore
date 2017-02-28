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
CREATE FUNCTION CreateUser(UserFirstName varchar(250), UserLastName varchar(250), UserEmail varchar(250))
  RETURNS INTEGER AS
  $$
      DECLARE 	UserID integer := (select nextval('UserID'));      
		UserUUID uuid := (select uuid_generate_v4()); 
      BEGIN        
        INSERT INTO Users(UserID, UserUUID, UserFirstName, UserLastName, UserEmail, CreatedAt)
        VALUES(UserID, UserUUID, UserFirstName, UserLastName, UserEmail, now());        
        
        -- Begin Log if success
        perform public.createlog(0,'Created User sucessfully', 'CreateUser', 
                                'UserID: ' || cast(UserID as varchar) || ', UserFirstName: ' 
                                || UserFirstName || ', UserLastName: ' || UserLastName 
                                || ', ' 
                                || UserEmail);
                                
        -- End Log if success
        -- Return UserID
        RETURN UserID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateUser', 
                                'UserID: ' || cast(UserID as varchar) || ', UserFirstName: ' 
                                || UserFirstName || ', UserLastName: ' || UserLastName 
                                || ', ' 
                                || UserEmail);
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateTechnologyData
CREATE FUNCTION CreateTechnologyData (
  TechnologyDataName varchar(250), 
  TechnologyData varchar(32672), 
  TechnologyDataDescription varchar(32672), 
  LicenseFee decimal(21,4),  
  vTechnologyID integer,
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE 	TechnologyDataID integer := (select nextval('TechnologyDataID'));
		TechnologyDataUUID uuid := (select uuid_generate_v4());       		   
      BEGIN        
        INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, TechnologyID, CreatedBy, CreatedAt)
        VALUES(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, vTechnologyID, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created TechnologyData sucessfully', 'CreateTechnologyData', 
                                'TechnologyDataID: ' || cast(TechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || TechnologyDataName || ', TechnologyData: ' || TechnologyData 
                                || ', TechnologyDataDescription: ' || TechnologyDataDescription
                                || ', TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', LicenseFee: ' || cast(LicenseFee as varchar)
                                || ', CreatedBy: ' || CreatedBy);
                                
        -- End Log if success
        -- Return UserID
        RETURN TechnologyDataID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTechnologyData', 
                                'TechnologyDataID: ' || cast(TechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || TechnologyDataName || ', TechnologyData: ' || TechnologyData 
                                || ', TechnologyDataDescription: ' || TechnologyDataDescription
                                || ', TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', LicenseFee: ' || cast(LicenseFee as varchar)
                                || ', CreatedBy: ' || CreatedBy);
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateTag
CREATE FUNCTION CreateTag (
  TagName varchar(250),  
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE 	TagID integer := (select nextval('TagID'));
		TagUUID uuid := (select uuid_generate_v4());	
      BEGIN        
        INSERT INTO Tags(TagID, TagUUID, TagName, CreatedBy, CreatedAt)
        VALUES(TagID, TagUUID, TagName, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created Tag sucessfully', 'CreateTag', 
                                'TagID: ' || cast(TagID as varchar) || ', TagName: ' 
                                || TagName);
                                
        -- End Log if success
        -- Return UserID
        RETURN TagID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTag', 
                                'TagID: ' || cast(TagID as varchar) || ', TagName: ' 
                                || TagName);
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateAttribute
CREATE FUNCTION CreateAttribute (
  AttributeName varchar(250), 
  CreatedBy uuid
 )
  RETURNS INTEGER AS
  $$
      DECLARE 	AttributeID integer := (select nextval('AttributeID'));
		AttributeUUID uuid := (select uuid_generate_v4());
		vUserID integer := (select userid from users where useruuid = createdby);
      BEGIN        
        INSERT INTO public.Attributes(AttributeID, AttributeUUID, AttributeName, CreatedBy, CreatedAt)
        VALUES(AttributeID, AttributeUUID, AttributeName, vUserID, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created Attribute sucessfully', 'CreateAttribute', 
                                'AttributeID: ' || cast(AttributeID as varchar) || ', AttributeName: ' 
                                || AttributeName);
                                
        -- End Log if success
        -- Return UserID
        RETURN AttributeID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'CreateAttribute', 
                                'AttributeID: ' || cast(AttributeID as varchar) || ', AttributeName: ' 
                                || AttributeName);
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateComponents
CREATE FUNCTION CreateComponent (
  ComponentParentID integer, 
  ComponentName varchar(250),
  ComponentDescription varchar(250),
  CreatedBy uuid
 )
  RETURNS INTEGER AS
  $$
      DECLARE 	ComponentID integer := (select nextval('ComponentID'));
		ComponentUUID uuid := (select uuid_generate_v4());		
		vUserID integer := (select userid from users where useruuid = createdby);
      BEGIN        
        INSERT INTO components(ComponentID, ComponentUUID, ComponentParentID, ComponentName, ComponentDescription, CreatedBy, CreatedAt)
        VALUES(ComponentID, ComponentUUID, ComponentParentID, ComponentName, ComponentDescription, vUserID, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created Component sucessfully', 'CreateComponent', 
                                'ComponentID: ' || cast(ComponentID as varchar) || ', '  
                                || 'ComponentParentID: ' || cast(ComponentParentID as varchar) 
                                || ', ComponentName: ' 
                                || ComponentName 
                                || ', ComponentDescription: ' 
                                || ComponentDescription 
                                || ', CreatedBy: ' 
                                || cast(vUserID as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN ComponentID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponent', 
                                'ComponentID: ' || cast(ComponentID as varchar) || ', '  
                                || 'ComponentParentID: ' || cast(ComponentParentID as varchar) 
                                || ', ComponentName: ' 
                                || ComponentName 
                                || ', ComponentDescription: ' 
                                || ComponentDescription
                                || ', CreatedBy: ' 
                                || cast(vUserID as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################    
-- CreatePaymentInvoice
CREATE OR REPLACE FUNCTION CreatePaymentInvoice (
  Invoice varchar(32672), 
  vOfferRequestUUID uuid,
  vUserUUID uuid  
 )
  RETURNS INTEGER AS
  $$
      DECLARE 			vPaymentInvoiceID integer := (select nextval('PaymentInvoiceID'));
				PaymentInvoiceUUID uuid := (select uuid_generate_v4()); 
				vOfferReqID integer := (select offerrequestid from offerrequest where offerrequestuuid = vOfferRequestUUID);
				vCreatedBy integer := (select userid from users where useruuid = vUserUUID);
				vTransactionID integer := (select transactionid from transactions where offerrequestid = vOfferReqID);
      BEGIN        
        INSERT INTO PaymentInvoice(PaymentInvoiceID, PaymentInvoiceUUID, OfferRequestID, Invoice, CreatedBy, CreatedAt)
        VALUES(vPaymentInvoiceID, PaymentInvoiceUUID, vOfferReqID, Invoice, vCreatedBy, now());

		-- Update Transactions table
        UPDATE Transactions SET PaymentInvoiceID = vPaymentInvoiceID, UpdatedAt = now(), UpdatedBy = vCreatedBy
        WHERE TransactionID = vTransactionID;
     
        -- Begin Log if success
        perform public.createlog(0,'Created PaymentInvoice sucessfully', 'CreatePaymentInvoice', 
                                'PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar) 
				|| ', OfferRequestID: ' || cast(vOfferReqID as varchar)
				|| ', Invoice: ' || Invoice
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
                                
        -- End Log if success
        -- Return PaymentInvoiceID
        RETURN vPaymentInvoiceID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreatePaymentInvoice', 
                                'PaymentInvoiceID: ' || cast(vPaymentInvoiceID as varchar) 
				|| ', OfferRequestID: ' || cast(vOfferReqID as varchar)
				|| ', Invoice: ' || Invoice
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################    
-- CreatePayment
CREATE FUNCTION CreatePayment(  
  vPaymentInvoiceUUID uuid,
  BitcoinTransaction varchar(32672),
  vUserUUID uuid
 )
  RETURNS INTEGER AS
  $$
      DECLARE 	PaymentID integer := (select nextval('PaymentID')); 
		PaymentInvoiceID integer := (select PaymentInvoiceID from paymentinvoice where PaymentInvoiceUUID = vPaymentInvoiceUUID);
		CreatedBy integer := (select userid from users where useruuid = vUserUUID);
      BEGIN        
        INSERT INTO Payment(PaymentID, PaymentUUID, PaymentInvoiceID, PayDate, BitconTransaction, CreatedBy)
        VALUES(PaymentID, PaymentUUID, PaymentInvoiceID, now(), BitconTransaction, CreatedBy);
     
        -- Begin Log if success
        perform public.createlog(0,'Created PaymentInvoice sucessfully', 'CreatePayment', 
                                'PaymentID: ' || cast(PaymentID as varchar) 
				|| ', PaymentInvoiceID: ' || cast(PaymentInvoiceID as varchar) 
				|| ', BitcoinTransaction: ' || BitconTransaction
				|| ', CreatedBy: ' || cast(CreatedBy as varchar));
                                
        -- End Log if success
        -- Return PaymentID
        RETURN PaymentID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreatePayment', 
                                'PaymentID: ' || cast(PaymentID as varchar) 
				|| ', PaymentInvoiceID: ' || cast(PaymentInvoiceID as varchar) 
				|| ', BitcoinTransaction: ' || BitconTransaction
				|| ', CreatedBy: ' || cast(CreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################    
-- CreateLicenseOrder
CREATE OR REPLACE FUNCTION CreateLicenseOrder (
  vTicketID varchar(4000),
  vOfferUUID uuid 
 )
  RETURNS INTEGER AS
  $$
      DECLARE 			vLicenseOrderID integer := (select nextval('LicenseOrderID'));
				vLicenseOrderUUID uuid := (select uuid_generate_v4()); 
				vOfferID integer := (select offerid from offer where offeruuid = vOfferUUID);
				vCreatedBy integer := (select userid from users where useruuid = vUserUUID);
				vTransactionID integer := (select transactionid from transactions where offerid = vOfferID);
      BEGIN        
        INSERT INTO LicenseOrder(LicenseOrderID, LicenseOrderUUID, TicketID, OfferID, ActivatedAt, CreatedBy, CreatedAt)
        VALUES(vLicenseOrderID, vLicenseOrderUUID, vTicketID, vOfferID, vCreatedBy, now());

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
        -- Return PaymentInvoiceID
        RETURN vPaymentInvoiceID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateLicenseOrder', 
                                'PaymentInvoiceID: ' || cast(vLicenseOrderID as varchar) 
				|| ', TicketID: ' || vTicketID
				|| ', OfferID: ' || cast(vOfferID as varchar)
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################    
-- CreateTechnologies
CREATE FUNCTION createtechnology(
    technologyname character varying,
    technologydescription character varying,
    createdby uuid)
  RETURNS integer AS
$BODY$
      DECLARE 	TechnologyID integer := (select nextval('TechnologyID'));
		TechnologyUUID uuid := (select uuid_generate_v4());
		vUserID integer := (select userid from users where useruuid = createdby);
      BEGIN        
        INSERT INTO Technologies(TechnologyID, TechnologyUUID, TechnologyName, TechnologyDescription, CreatedBy, CreatedAt)
        VALUES(TechnologyID, TechnologyUUID, TechnologyName, TechnologyDescription, vUserID, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created Technology sucessfully', 'CreateTechnology', 
                                'TechnologyID: ' || cast(TechnologyID as varchar) 
                                || ', TechnologyName: ' 
                                || TechnologyName 
                                || ', TechnologyDescription: ' 
                                || TechnologyDescription 
                                || ', CreatedBy: ' 
                                || cast(vUserID as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN TechnologyID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTechnology', 
                                'TechnologyID: ' || cast(TechnologyID as varchar) 
                                || ', TechnologyName: ' 
                                || TechnologyName 
                                || ', TechnologyDescription: ' 
                                || TechnologyDescription 
                                || ', CreatedBy: ' 
                                || cast(vUserID as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $BODY$
  LANGUAGE plpgsql;
-- ##############################################################################    
-- CreateTechnologyDataComponents 
CREATE FUNCTION CreateTechnologyDataComponents (
  TechnologyDataID integer, 
  ComponentList text[]
 )
  RETURNS INTEGER AS
  $$    
  	DECLARE compName text;
		compID integer;
      BEGIN     
         FOREACH compName in array ComponentList 		
        LOOP 
		compID := (select componentID from components where componentName = compName);
		
         	INSERT INTO TechnologyDataComponents(technologydataid, componentid)
		VALUES (technologydataid, compID);
        END LOOP; 
     
        -- Begin Log if success
        perform public.createlog(0,'Created relation from Componets to TechnologyData sucessfully', 'CreateTechnologyDataComponents', 
                                'TechnologyDataID: ' || cast(TechnologyDataID as varchar)
                                || ', ComponentList: ' 
                                || cast(ComponentList as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN TechnologyDataID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTechnologyDataComponents', 
                                'TechnologyDataID: ' || cast(TechnologyDataID as varchar)
                                || ', ComponentList: ' 
                                || cast(ComponentList as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################    
-- CreateTechnologyDataTags
CREATE FUNCTION CreateTechnologyDataTags (
  TechnologyDataID integer, 
  TagList text[]
 )
  RETURNS INTEGER AS
  $$    
  	DECLARE vTagName text;
    DECLARE tagID int;
      BEGIN     
         FOREACH vTagName in array TagList          	
        LOOP 
        	 tagID := (select tags.tagID from tags where tagName = vTagName); 
         	 INSERT INTO TechnologyDataTags(TechnologyDataID, tagID)
             VALUES (TechnologyDataID, tagID);
        END LOOP; 
     
        -- Begin Log if success
        perform public.createlog(0,'Created relation from Tags to TechnologyData sucessfully', 'CreateTechnologyDataTags', 
                                'TechnologyDataID: ' || cast(TechnologyDataID as varchar)
                                || ', TagList: ' 
                                || cast(TagList as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN TechnologyDataID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE || cast(tagID as varchar), 'CreateTechnologyDataTags', 
                                'TechnologyDataID: ' || cast(TechnologyDataID as varchar)
                                || ', TagList: ' 
                                || cast(TagList as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateComponentsAttribute
CREATE FUNCTION CreateComponentsAttribute (
  ComponentID integer, 
  AttributeList text[]
 )
  RETURNS INTEGER AS
  $$    
  	DECLARE vAttributeName text;
    DECLARE vAttrID int;
      BEGIN     
         FOREACH vAttributeName in array AttributeList          	
        LOOP 
        	 vAttrID := (select attributes.attributeID from public.attributes where attributename = vAttributeName); 
         	 INSERT INTO ComponentsAttribute(ComponentID, AttributeID)
             VALUES (ComponentID, vAttrID);
        END LOOP; 
     
        -- Begin Log if success
        perform public.createlog(0,'Created relation from component to attributes sucessfully', 'CreateComponentsAttribute', 
                                'ComponentID: ' || cast(ComponentID as varchar)
                                || ', AttributeList: ' 
                                || cast(AttributeList as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN ComponentID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponentsAttribute', 
                                'ComponentID: ' || cast(ComponentID as varchar)
                                || ', AttributeList: ' 
                                || cast(AttributeList as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateComponentsTechnologies
CREATE FUNCTION CreateComponentsTechnologies (
  ComponentID integer, 
  TechnologyList text[]
 )
  RETURNS INTEGER AS
  $$    
    DECLARE 	vTechName text;
		vTechID integer;
      BEGIN     
         FOREACH vTechName in array TechnologyList          	
        LOOP 
		vTechID := (select technologyid from technologies where technologyname = vTechName);
         	 INSERT INTO ComponentsTechnologies(ComponentID, TechnologyID)
             VALUES (ComponentID, vTechID);
        END LOOP; 
     
        -- Begin Log if success
        perform public.createlog(0,'Created relation from component to attributes sucessfully', 'CreateComponentsTechnologies', 
                                'ComponentID: ' || cast(ComponentID as varchar)
                                || ', TechnologyList: ' 
                                || cast(TechnologyList as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN ComponentID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponentsTechnologies', 
                                'ComponentID: ' || cast(ComponentID as varchar)
                                || ', TechnologyList: ' 
                                || cast(TechnologyList as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';
 -- ##############################################################################    
-- CreateOfferRequest
CREATE FUNCTION CreateOfferRequest (
  vTechnologyDataUUID uuid,
  Amount integer,
  HSMID varchar,
  vUserUUID uuid,
  vBuyerUUID uuid
 )
  RETURNS INTEGER AS
  $$
      DECLARE 	OfferRequestID integer := (select nextval('OfferRequestID'));
		OfferRequestUUID uuid := (select uuid_generate_v4());
		TechnologyDataID integer := (select technologydataid from technologydata where technologydatauuid = vTechnologyDataUUID);	
		RequestedBy integer := (select userid from users where useruuid = vUserUUID);
		TransactionID integer := (select nextval('TransactionID'));
		TransactionUUID uuid := (select uuid_generate_v4());
		BuyerID integer := (select userid from users where useruuid = vBuyerUUID);
      BEGIN        
        INSERT INTO OfferRequest(OfferRequestID, OfferRequestUUID, TechnologyDataID, Amount, HSMID, RequestedBy, CreatedAt)
        VALUES(OfferRequestID, OfferRequestUUID, TechnologyDataID, Amount, HSMID, RequestedBy, now());

        INSERT INTO Transactions(TransactionID, TransactionUUID, OfferRequestID, BuyerID, CreatedBy, CreatedAt)
		VALUES (TransactionID, TransactionUUID, OfferRequestID, BuyerID, RequestedBy, now());
     
        -- Begin Log if success
        perform public.createlog(0,'Created OfferRequest sucessfully', 'CreateOfferRequest', 
                                'OfferRequestID: ' || cast(OfferRequestID as varchar) 
				|| ', TechnologyDataID: ' || cast(TechnologyDataID as varchar)
				|| ', Amount: ' || cast(Amount as varchar) || ', HSMID: ' || HSMID);
                                
        -- End Log if success
        -- Return UserID
        RETURN OfferRequestID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateOfferRequest', 
                                'OfferRequestID: ' || cast(OfferRequestID as varchar) 
				|| ', TechnologyDataID: ' || cast(TechnologyDataID as varchar)
				|| ', Amount: ' || cast(Amount as varchar) || ', HSMID: ' || HSMID);
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################    
-- CreateOffer 
CREATE OR REPLACE FUNCTION CreateOffer(
  vPaymentInvoiceUUID uuid,
  vUserUUID uuid
 )
  RETURNS INTEGER AS
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
        -- Return OfferID
        RETURN vOfferID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateOffer', 
                                'OfferID: ' || cast(vOfferID as varchar) 
				|| ', PaymentInvoiceUUID: ' || cast(vPaymentInvoiceUUID as varchar)
				|| ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
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
CREATE FUNCTION SetComponent (
  vComponentName varchar(250), 
  vComponentParentName varchar(250), 
  ComponentDescription varchar(32672),
  AttributeList text[], 
  TechnologyList text[],
  CreatedBy uuid
 )
  RETURNS INTEGER AS
  $$    
      DECLARE 	vAttributeName text; 
        	vTechName text;
		vCompID integer;
		vCompParentID integer := (select case when (vComponentParentName = 'Root') then 1 else componentparentid end from components where componentname = vComponentParentName);
      BEGIN      
        -- Proof if all technologies are avaiable
        -- Proof if all components are avaiable      
        FOREACH vTechName in array TechnologyList 
        LOOP 
         	 if not exists (select technologyid from technologies where technologyname = vTechName) then
                 raise exception using
                 errcode = 'invalid_parameter_value',
                 message = 'There is no technology with TechnologyName: ' || vTechName; 
         	 end if;
        END LOOP;
        -- Proof if all Attributes are avaiable     
        FOREACH vAttributeName in array AttributeList 
        LOOP 
         	 if not exists (select attributeid from public.attributes where attributename = vAttributeName) then
               perform public.createattribute(vAttributeName,CreatedBy);
        	 end if;
        END LOOP;
        
        -- Create new Component
        vCompID := (select public.createcomponent(vCompParentID,vComponentName, componentdescription, createdby));    
        
        -- Create relation from Components to TechnologyData 
        perform public.CreateComponentsAttribute(vCompID, AttributeList);  
        
        -- Create relation from Components to TechnologyData 
        perform public.CreateComponentsTechnologies(vCompID, TechnologyList); 
     	
        -- Begin Log if success
        perform public.createlog(0,'Set Component sucessfully', 'SetComponent', 
                                'ComponentID: ' || cast(vCompID as varchar) || ', componentname: ' 
                                || vComponentName || ', componentdescription: ' || componentdescription 
                                || ', CreatedBy: ' || cast(CreatedBy as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN vCompID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,'SetComponent', 
                                'ComponentID: ' || cast(vCompID as varchar) || ', componentname: ' 
                                || vComponentName || ', componentdescription: ' || componentdescription 
                                || ', CreatedBy: ' || cast(CreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
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
	- LicenseFee: Decimal (21,4)
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
 CREATE FUNCTION public.settechnologydata(
    technologydataname character varying,
    technologydata character varying,
    technologydatadescription character varying,
    vtechnologyuuid uuid,
    licensefee numeric,
    taglist text[],
    createdby uuid,
    componentlist text[])
  RETURNS integer AS			
$BODY$    
      DECLARE 	vCompName text;
				vTagName text; 
				vTechnologyDataID int; 
				vUSerID integer := (select userid from users where useruuid = createdby);
				vTechnologyID integer := (select technologyID from technologies where technologyUUID = vTechnologyUUID);
      BEGIN        
        -- Proof if all components are avaiable      
        FOREACH vCompName in array componentlist 
        LOOP 
         	 if not exists (select componentid from components where componentname = vCompName) then
                 raise exception using
                 errcode = 'invalid_parameter_value',
                 message = 'There is no component with ComponentName: ' || vCompName; 
         	 end if;
        END LOOP;
        -- Proof if all Tags are avaiable     
        FOREACH vTagName in array TagList 
        LOOP 
         	 if not exists (select tagID from tags where tagname = vTagName) then
			perform public.createtag(vTagName,vUSerID);
        	 end if;
        END LOOP;
        -- Proof if technology is avaiable  
        if not exists (select technologyid from technologies where technologyuuid = vTechnologyUUID) then
        	raise exception using
            errcode = 'invalid_parameter_value',
            message = 'There is no technology with TechnologyID: ' || vTechnologyID::text; 
        end if;
        
        -- Create new TechnologyData
        vTechnologyDataID := (select public.createtechnologydata(TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, vTechnologyID, vUSerID));    
        
        -- Create relation from Components to TechnologyData 
        perform public.CreateTechnologyDataComponents(vTechnologyDataID, ComponentList);
        
        -- Create relation from Tags to TechnologyData 
        perform public.CreateTechnologyDataTags(vTechnologyDataID, TagList);
     	
        -- Begin Log if success
        perform public.createlog(0,'Set TechnologyData sucessfully', 'SetTechnologyData', 
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || TechnologyDataName || ', TechnologyData: ' || TechnologyData 
                                || ', TechnologyDataDescription: ' || TechnologyDataDescription 
                                || ', CreatedBy: ' || cast(vUSerID as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN vTechnologyDataID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'SetTechnologyData', 
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || TechnologyDataName || ', TechnologyData: ' || TechnologyData 
                                || ', TechnologyDataDescription: ' || TechnologyDataDescription 
                                || ', CreatedBy: ' || cast(vUSerID as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $BODY$
  LANGUAGE plpgsql;
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
    technologyid integer,
    technologydataname character varying(250),
    technologydata character varying(32672),
    technologydatadescription character varying(32672),
    licensefee numeric(21, 4),
    createdat timestamp  without time zone,
    createdby integer,
    updateat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
    SELECT  technologydatauuid,
    		technologyid,
    		technologydataname,
    		technologydata,
    		technologydatadescription,
    		licensefee,
    		createdat  at time zone 'utc',
    		createdby,	
    		updateat  at time zone 'utc',
    		updatedby
    FROM TechnologyData $$
    LANGUAGE SQL;
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
CREATE FUNCTION GetTechnologyDataByID(vTechnologyDataUUID uuid, vUserUUID uuid) 
	RETURNS TABLE
    	(
    technologydatauuid uuid,
    technologyid integer,
    technologydataname character varying(250),
    technologydata character varying(32672),
    technologydatadescription character varying(32672),
    licensefee numeric(21, 4),
    createdat timestamp  without time zone,
    createdby integer,
    updateat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
    SELECT  technologydatauuid,
    		technologyid,
    		technologydataname,
    		technologydata,
    		technologydatadescription,
    		licensefee,
    		createdat  at time zone 'utc',
    		createdby,	
    		updateat  at time zone 'utc',
    		updatedby
    FROM TechnologyData WHERE technologydatauuid = vTechnologyDataUUID
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
CREATE FUNCTION GetTechnologyDataByName(vTechnologyDataName varchar(250), vUserUUID uuid) 
	RETURNS TABLE
    	(
    technologydatauuid uuid,
    technologyid integer,
    technologydataname character varying(250),
    technologydata character varying(32672),
    technologydatadescription character varying(32672),
    licensefee numeric(21, 4),
    createdat timestamp  without time zone,
    createdby integer,
    updateat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
    SELECT  technologydatauuid,
    		technologyid,
    		technologydataname,
    		technologydata,
    		technologydatadescription,
    		licensefee,
    		createdat  at time zone 'utc',
    		createdby,	
    		updateat  at time zone 'utc',
    		updatedby
    FROM TechnologyData WHERE TechnologyDataName = vTechnologyDataName
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
    createdat timestamp  without time zone,
    createdby integer,
    updatedat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
	SELECT  componentuuid,
    		componentname,
    		componentparentid,
		componentdescription, 
    		createdat  at time zone 'utc',
    		createdby,
    		updatedat  at time zone 'utc',
    		updatedby 
    FROM Components 
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
    componentparentid integer,
    componentdescription character varying(32672), 
    createdat timestamp  without time zone,
    createdby integer,
    updatedat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
	SELECT  componentuuid,
    		componentname,
    		componentparentid,
		componentdescription, 
    		createdat  at time zone 'utc',
    		createdby,
    		updatedat  at time zone 'utc',
    		updatedby 
    FROM Components WHERE componentuuid = vCompUUID;
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
    componentparentid integer,
    componentdescription character varying(32672), 
    createdat timestamp  without time zone,
    createdby integer,
    updatedat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
	SELECT  componentuuid,
    		componentname,
    		componentparentid,
		componentdescription, 
    		createdat at time zone 'utc',
    		createdby,
    		updatedat at time zone 'utc',
    		updatedby 
    FROM Components WHERE componentname = vCompName;
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
    createdat timestamp  without time zone,
    createdby integer,
    updatedat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
	SELECT  taguuid,
    		tagname, 
    		createdat  at time zone 'utc',
    		createdby,
    		updatedat  at time zone 'utc',
    		updatedby 
    FROM Tags $$
    LANGUAGE SQL;
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
    tagudid uuid,
    tagname character varying(250),    
    createdat timestamp  without time zone,
    createdby integer,
    updatedat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
	SELECT  taguuid,
    		tagname, 
    		createdat  at time zone 'utc',
    		createdby,
    		updatedat  at time zone 'utc',
    		updatedby 
    FROM Tags WHERE tagUUID = vTagID;
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
    createdat timestamp  without time zone,
    createdby integer,
    updatedat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
	SELECT  taguuid,
    		tagname, 
    		createdat at time zone 'utc',
    		createdby,
    		updatedat at time zone 'utc',
    		updatedby 
    FROM Tags WHERE tagName = vTagName;
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
    createdat timestamp  without time zone,
    createdby integer,
    updatedat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
	SELECT  technologyuuid,
    		technologyname, 
		technologydescription, 
    		createdat at time zone 'utc',
    		createdby,
    		updatedat at time zone 'utc',
    		updatedby 
    FROM Technologies $$
    LANGUAGE SQL;
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
    createdat timestamp  without time zone,
    createdby integer,
    updatedat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
	SELECT  technologyuuid,
    		technologyname, 
		technologydescription, 
    		createdat at time zone 'utc',
    		createdby,
    		updatedat at time zone 'utc',
    		updatedby 
    FROM Technologies WHERE technologyuuid = vtechUUID;
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
    technologyguuid uuid,
    technologyname character varying(250),
    technologydescription character varying(32672),            
    createdat timestamp  without time zone,
    createdby integer,
    updatedat timestamp  without time zone,
    updatedby integer
        )
    AS $$ 
	SELECT  technologyuuid,
    		technologyname, 
		technologydescription, 
    		createdat at time zone 'utc',
    		createdby,
    		updatedat at time zone 'utc',
    		updatedby 
    FROM Technologies WHERE technologyname = vtechName;
    $$ LANGUAGE SQL;

/*##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-16
-- Description: Script to get all Technologies
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
            technologydataname character varying,
         	technologyname varchar,
         	tagname character varying,
         	componentname varchar,
            attributename varchar
        )
    AS $$ 
    SELECT 
    	td.technologydataname as technologydataname,
        tc.technologyname as technologyname,
        tg.tagname as tagname,
        ct.componentname as componentname,
        att.attributename
    FROM technologydata td 
    JOIN technologydatatags tdt ON td.technologydataid = tdt.technologydataid
    JOIN tags tg ON tdt.tagid = tg.tagid
    JOIN technologydatacomponents tdc ON tdc.technologydataid = td.technologydataid
    JOIN components ct ON ct.componentid = tdc.componentid
    JOIN technologies tc ON tc.technologyid = td.technologyid
    JOIN componentsattribute cta ON cta.componentid = ct.componentid
    JOIN attributes att ON att.attributeid = cta.attributeid
    WHERE (vtechdata IS NULL OR td.technologydataname IN (vtechdata)) 
    AND (vtechnologies IS NULL OR tc.technologyname IN (vtechnologies)) 
    AND (vtags IS NULL OR tg.tagname IN (vtags)) 
    AND (vcomponents IS NULL OR ct.componentname in (vcomponents))
    AND (vattributes IS NULL OR att.attributename in (vattributes));
    
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
    createdat timestamp  without time zone,       
    updatedat timestamp  without time zone
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
    createdat timestamp  without time zone,       
    updatedat timestamp  without time zone
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
    createdat timestamp  without time zone,       
    updatedat timestamp  without time zone
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
    createdat timestamp without time zone,
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
-- CreatedAt: 2017-02-23
-- Description: Script to get the offer based on the offerrequestid
-- ##########################################################################
Get a offer 
Input paramteres: OfferRequestID uuid		
Return Value: Table with a offer
######################################################
CREATE FUNCTION GetOfferByRequestID(vRequestID uuid) 
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
	JOIN paymentinvoice pm 
	ON ofr.paymentinvoiceid = pm.paymentinvoiceid
	WHERE pm.paymentinvoiceuuid = vRequestID
    $$ LANGUAGE SQL;*/
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-23
-- Description: Script to get the offer based on the offerid
-- ##########################################################################
Get a offer 
Input paramteres: OfferUUID uuid		
Return Value: Table with a offer
######################################################
CREATE FUNCTION GetOfferByOfferID(vOfferID uuid) 
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
	WHERE ofr.offeruuid = vOfferID
    $$ LANGUAGE SQL;*/
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
-- TODO
-- Create OfferRequest

-- Create Payment
-- Create Offer
-- Create LicenseOrder
-- Create Transaction