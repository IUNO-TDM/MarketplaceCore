-- ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-27
-- Description: Script to create MarketplaceCore database functions, sequences, etc.
-- Changes: Last update 2017-04-26
-- ##########################################################################
-- Create Database
/*CREATE DATABASE "Test"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;*/
-- Install Extension UUID-OSSP
CREATE EXTENSION "uuid-ossp";
-- Install Extension dblink
CREATE EXTENSION "dblink";
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
CREATE SEQUENCE FunctionID START 2;  
-- OfferRequestItemID
CREATE SEQUENCE OfferRequestItemID START 1; 
-- ##########################################################################
-- Create Indexes
CREATE UNIQUE INDEX invoice_idx ON paymentinvoice (invoice);
-- ##########################################################################
-- Create Functions
-- CreateLog
CREATE FUNCTION public.createlog(
    vlogstatusid integer,
    vlogmessage character varying,
    vlogobjectname character varying,
    vparameters character varying)
  RETURNS void AS
$BODY$      
      DECLARE vLogID integer:= (select nextval('LogID'));	      
	      vSqlCmd varchar := 'INSERT INTO LogTable(LogID, LogStatusID, LogMessage, LogObjectName, Parameters,CreatedAt)'
				 || 'VALUES( '
				 || cast(vLogID as varchar)
				 || ', ' || cast(vLogStatusID as varchar)
				 || ', ''' || vLogMessage
				 || ''', ''' || vLogObjectName
				 || ''', ''' || vParameters
				 || ''', ' || 'now())';
		 vConnName text := 'conn';
	      vConnExist bool := (select ('{' || vConnName || '}')::text[] <@ (select dblink_get_connections()));
      BEGIN       
		set role dblink_loguser;
		if(not vConnExist or vConnExist is null) then				
				perform dblink_connect(vConnName,'fdtest');  
			else			
				set role dblink_loguser;		 
		end if;	
				perform dblink(vConnName,vSqlCmd);
				perform dblink_disconnect(vConnName); 
				set role postgres;        
      END;
  $BODY$
  LANGUAGE plpgsql;
-- ##############################################################################    
CREATE FUNCTION CreateTechnologyData (
	  vTechnologyDataName varchar(250), 
	  vTechnologyData varchar(32672), 
	  vTechnologyDataDescription varchar(32672),
	  vLicenseFee integer,  
	  vRetailPrice integer,
	  vTechnologyUUID uuid,
	  vCreatedBy uuid,
	  vRoleName varchar
 )
  RETURNS TABLE (
	TechnologyDataUUID uuid,
	TechnologyDataName varchar(250),
	TechnologyUUID uuid,
	TechnologyData varchar(32672),
	LicenseFee integer,
	etailPrice integer,
	TechnologyDataDescription varchar(32672),
	TechnologyDataThumbnail bytea,
	TechnologyDataImgRef character varying,
	CreatedAt timestamp with time zone,
	CreatedBy uuid
  ) AS
  $$
	#variable_conflict use_column
      DECLARE 	vTechnologyDataID integer := (select nextval('TechnologyDataID'));
		vTechnologyDataUUID uuid := (select uuid_generate_v4());     
		vTechnologyID integer := (select technologyid from technologies where technologyuuid = vTechnologyUUID);
		vFunctionName varchar := 'CreateTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
			
      BEGIN       
	IF(vIsAllowed) then
		INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, RetailPrice, TechnologyID, CreatedBy, CreatedAt)
        VALUES(vTechnologyDataID, vTechnologyDataUUID, vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vRetailPrice, vTechnologyID, vCreatedBy, now());
	else 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	end if;	        
     
        -- Begin Log if success
        perform public.createlog(0,'Created TechnologyData sucessfully', 'CreateTechnologyData', 
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || vTechnologyDataName || ', TechnologyData: ' || vTechnologyData 
                                || ', TechnologyDataDescription: ' || vTechnologyDataDescription
				-- || ', vTechnologyDataAuthor: ' || cast(vTechAuthor as varchar) 
                                || ', TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', LicenseFee: ' || cast(vLicenseFee as varchar)
								|| ', RetailPrice: ' || cast(vRetailPrice as varchar)
                                || ', CreatedBy: ' || vCreatedBy);
                                
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
                                || ', CreatedBy: ' || vCreatedBy);
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTechnologyData';
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateTag
 CREATE FUNCTION CreateTag (
  vTagName varchar(250),  
  vCreatedBy uuid,
  vRoleName varchar
 )
  RETURNS TABLE (
	TagUUID uuid,
	TagName varchar(250),
	CreatedAt timestamp with time zone,
	CreatedBy uuid 
  ) AS
  $$
	#variable_conflict use_column
      DECLARE 	vTagID integer := (select nextval('TagID'));
		vTagUUID uuid := (select uuid_generate_v4());	
		vFunctionName varchar := 'CreateTag';
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
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
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################  
-- CreateTechnologyDataTags 
CREATE FUNCTION CreateTechnologyDataTags (
  vTechnologyDataUUID uuid, 
  vTagList text[],
  vCreatedBy uuid,
  vRoleName varchar
 )
  RETURNS TABLE (
	TechnologyDataUUID uuid,
	TagList uuid[]
  ) AS
  $$
	#variable_conflict use_column
  	DECLARE vTagName text;
		vtagID integer;
		vTechnologyDataID integer := (select technologydataid from technologydata where technologydatauuid = vTechnologyDataUUID);
		vFunctionName varchar := 'CreateTechnologyDataTags';
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
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
  $$
  LANGUAGE 'plpgsql';  
-- ##############################################################################    
-- CreateAttribute
CREATE FUNCTION CreateAttribute (
  vAttributeName varchar(250), 
  vCreatedBy uuid,
  vRoleName varchar
 )
  RETURNS TABLE (
	AttributeUUID uuid,
	AttributeName varchar(250),
	CreatedAt timestamp with time zone,
	CreatedBy uuid 
  ) AS
  $$
	#variable_conflict use_column
      DECLARE 	vAttributeID integer := (select nextval('AttributeID'));
		vAttributeUUID uuid := (select uuid_generate_v4());
		vFunctionName varchar := 'CreateAttribute';
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
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
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateComponents
CREATE OR REPLACE FUNCTION CreateComponent (
  vComponentParentUUID uuid, 
  vComponentName varchar(250),
  vComponentDescription varchar(250),
  vCreatedBy uuid,
  vRoleName varchar
 )
  RETURNS TABLE (
	ComponentUUID uuid,
	ComponentName varchar(250),
	ComponentParentName varchar(250),
	ComponentParentUUID uuid,
	ComponentDecription varchar(32672),
	CreatedAt timestamp with time zone,
	CreatedBy uuid
  ) AS
  $$
	#variable_conflict use_column
      DECLARE 	vComponentID integer := (select nextval('ComponentID'));
		vComponentUUID uuid := (select uuid_generate_v4());		 
		vComponentParentID integer := (select componentid from components where componentuuid = vComponentParentUUID);	
		vFunctionName varchar := 'CreateComponent';
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
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
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################    
-- CreateTechnologies
CREATE FUNCTION createtechnology(
    vTechnologyname character varying,
    vTechnologydescription character varying,
    vCreatedby uuid,
    vRoleName varchar
    )
  RETURNS TABLE (
	TechnologyUUID uuid,
	TechnologyName varchar(250),
	TechnologyDescription varchar(32672),
	CreatedAt timestamp with time zone,
	CreatedBy uuid
  ) AS
$$
	#variable_conflict use_column
      DECLARE 	vTechnologyID integer := (select nextval('TechnologyID'));
		vTechnologyUUID uuid := (select uuid_generate_v4());
		vFunctionName varchar := 'CreateTechnology';
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
  $$
  LANGUAGE plpgsql;
-- ##############################################################################    
-- CreateTechnologyDataComponents 
CREATE FUNCTION CreateTechnologyDataComponents (
  vTechnologyDataUUID uuid, 
  vComponentList text[],
  vRoleName varchar 
 )
  RETURNS TABLE (
	TechnologyDataUUID uuid,
	ComponentList uuid[]
  ) AS
  $$
	#variable_conflict use_column
  	DECLARE vCompName text;
		vCompID integer;
		vTechnologyDataID integer := (select technologydataid from technologydata where technologydatauuid = vTechnologyDataUUID);
		vFunctionName varchar := 'CreateTechnologyDataComponents';
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
      BEGIN  
	IF(vIsAllowed) THEN 
		FOREACH vCompName in array vComponentList 		
		LOOP 
			vCompID := (select componentID from components where componentName = vCompName);
			
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
  $$
  LANGUAGE 'plpgsql'; 
-- ##############################################################################       
-- CreateComponentsTechnologies
CREATE OR REPLACE FUNCTION CreateComponentsTechnologies (
  vComponentUUID uuid, 
  vTechnologyList text[],
  vRoleName varchar 
 )
  RETURNS TABLE (
	ComponentUUID uuid,
	TechnologyList uuid[]
  ) AS
  $$
	#variable_conflict use_column
    DECLARE 	vTechName text;
		vTechID integer;
		vComponentID integer := (select componentid from components where componentuuid = vComponentUUID);
		vFunctionName varchar := 'CreateComponentsTechnologies';
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateComponentsTechnologies
CREATE OR REPLACE FUNCTION CreateComponentsTechnologies (
  vComponentUUID uuid, 
  vTechnologyList text[],
  vRoleName varchar 
 )
  RETURNS TABLE (
	ComponentUUID uuid,
	TechnologyList uuid[]
  ) AS
  $$
	#variable_conflict use_column
    DECLARE 	vTechName text;
		vTechID integer;
		vComponentID integer := (select componentid from components where componentuuid = vComponentUUID);
		vFunctionName varchar := 'CreateComponentsTechnologies';
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################
--  CreateOfferRequest 
CREATE OR REPLACE FUNCTION public.createofferrequest(
    IN vitems jsonb,
    IN vhsmid character varying,
    IN vuseruuid uuid,
    IN vbuyeruuid uuid,
    IN vrolename character varying)
  RETURNS table(result json) AS
$BODY$
	#variable_conflict use_column 
      DECLARE 	vOfferRequestItemID integer := (select nextval('OfferRequestItemID'));
		vOfferRequestID integer := (select nextval('OfferRequestID'));
		vOfferRequestUUID uuid := (select uuid_generate_v4()); 
		vTransactionID integer := (select nextval('TransactionID'));
		vTransactionUUID uuid := (select uuid_generate_v4());
		vFunctionName varchar := 'CreateOfferRequest'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN          
		INSERT INTO OfferRequest(OfferRequestID, OfferRequestUUID, HSMID, RequestedBy, CreatedAt)
		VALUES(vOfferRequestID, vOfferRequestUUID, vHSMID, vbuyeruuid, now());

		INSERT INTO Transactions(TransactionID, TransactionUUID, OfferRequestID, BuyerID, CreatedBy, CreatedAt)
		VALUES (vTransactionID, vTransactionUUID, vOfferRequestID, vbuyeruuid, vbuyeruuid, now());

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
  LANGUAGE plpgsql VOLATILE
  COST 100;
-- ##############################################################################    
-- CreatePaymentInvoice
CREATE FUNCTION CreatePaymentInvoice (
  vInvoice varchar(32672), 
  vOfferRequestUUID uuid,
  vUserUUID uuid,
  vRoleName varchar  
 )
  RETURNS TABLE (
	PaymentInvoiceUUID uuid,
	OfferRequestUUID uuid,
	Invoice varchar(32672),
	CreatedAt timestamp with time zone,
	CreatedBy uuid
  ) AS
  $$
	#variable_conflict use_column
	DECLARE vPaymentInvoiceID integer := (select nextval('PaymentInvoiceID'));
		vPaymentInvoiceUUID uuid := (select uuid_generate_v4()); 
		vOfferReqID integer := (select offerrequestid from offerrequest where offerrequestuuid = vOfferRequestUUID);		
		vTransactionID integer := (select transactionid from transactions where offerrequestid = vOfferReqID);
		vFunctionName varchar := 'CreatePaymentInvoice'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreatePaymentInvoice';
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateOffer   
CREATE FUNCTION CreateOffer(
  vPaymentInvoiceUUID uuid,
  vUserUUID uuid,
  vRoleName varchar
 )
  RETURNS TABLE (
	OfferUUID uuid,
	PaymentInvoiceUUID uuid,
	CreatedAt timestamp with time zone,
	CreatedBy uuid	
  ) AS
  $$
	#variable_conflict use_column
      DECLARE 	vOfferID integer := (select nextval('OfferID'));
		vOfferUUID uuid := (select uuid_generate_v4());
		vPaymentInvoiceID integer := (select paymentinvoiceid from paymentinvoice where paymentinvoiceuuid = vPaymentInvoiceUUID);	
		vTransactionID integer := (select transactionid from transactions where paymentinvoiceid = vPaymentInvoiceID); 
		vFunctionName varchar := 'CreateOffer'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN  
              
		INSERT INTO Offer(OfferID, OfferUUID, PaymentInvoiceID, CreatedBy, CreatedAt)
		VALUES(vOfferID, vOfferUUID, vPaymentInvoiceID, vUserUUID, now());

		-- Update Transactions table
		UPDATE Transactions SET OfferId = vOfferID, UpdatedAt = now(), UpdatedBy = vCreatedBy
		WHERE TransactionID = vTransactionID;

	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF;
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
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateOffer';
        RETURN;
      END;
  $$
  LANGUAGE 'plpgsql';   
-- ##############################################################################
-- CreateLicenseOrder  
CREATE FUNCTION CreateLicenseOrder (
  vTicketID varchar(4000),
  vOfferUUID uuid,
  vUserUUID uuid,
  vRoleName varchar
 )
  RETURNS TABLE (
	LicenseOrderUUID uuid,
	TicketID varchar(4000),
	OfferUUID uuid,
	ActivatedAt timestamp with time zone,
	CreatedAt timestamp with time zone,
	CreatedBy uuid
  ) AS
  $$
	#variable_conflict use_column
      DECLARE 			vLicenseOrderID integer := (select nextval('LicenseOrderID'));
				vLicenseOrderUUID uuid := (select uuid_generate_v4()); 
				vOfferID integer := (select offerid from offer where offeruuid = vOfferUUID); 
				vTransactionID integer := (select transactionid from transactions where offerid = vOfferID);
				FunctionName varchar := 'CreateLicenseOrder'; 
				vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN         
		INSERT INTO LicenseOrder(LicenseOrderID, LicenseOrderUUID, TicketID, OfferID, ActivatedAt, CreatedBy, CreatedAt)
		VALUES(vLicenseOrderID, vLicenseOrderUUID, vTicketID, vOfferID, now(), vUserUUID, now());

		-- Update Transactions table
		UPDATE Transactions SET LicenseOrderID = vLicenseOrderID, UpdatedAt = now(), UpdatedBy = vCreatedBy
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
  $$
  LANGUAGE 'plpgsql';      
-- ##############################################################################     
CREATE FUNCTION public.setpayment(
    IN vtransactionuuid uuid,
    IN vbitcointransaction character varying,
    IN vconfidencestate character varying,
    IN vdepth integer,
    IN vextinvoiceid uuid,
    IN vuseruuid uuid,
    IN vRoleName varchar)
  RETURNS TABLE(paymentuuid uuid, paymentinvoiceuuid uuid, paydate timestamp with time zone, bitcointransation character varying, confidencestate character varying, depth integer, extinvoiceid uuid, createdby uuid, createdat timestamp with time zone, updatedby uuid, updatedat timestamp with time zone) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vPaymentID integer;
		vPaymentUUID uuid := (select uuid_generate_v4());
		vPaymentInvoiceID integer := (select PaymentInvoiceID from transactions where transactionuuid = vTransactionUUID);		
		vPayDate timestamp without time zone := null;
		vTransactionID integer := (select transactionid from transactions where transactionuuid = vtransactionuuid);
		vFunctionName varchar := 'SetPayment'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
				us.useruuid as CreatedBy,
				py.createdat at time zone 'utc',
				ur.useruuid as UpdatedBy,
				py.updatedat at time zone 'utc'
			from payment py join
			paymentinvoice pi on
			py.paymentinvoiceid = pi.paymentinvoiceid
			join users us on us.userid = py.createdby
			left outer join 
			users ur on ur.userid = py.updatedby
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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
-- ###########################################################################     
-- CreateComponentsAttribute
CREATE FUNCTION CreateComponentsAttribute (
  vComponentUUID uuid, 
  vAttributeList text[], 
  vRoleName varchar
 )
  RETURNS TABLE (
	ComponentUUID uuid,
	AttributeList uuid[]
  ) AS
  $$
	#variable_conflict use_column
  	DECLARE vAttributeName text;
		vAttrID int;
		vComponentID integer := (select componentid from components where componentuuid = vComponentUUID);       
		vFunctionName varchar := 'SetComponent'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
CREATE FUNCTION public.setcomponent(
    IN vcomponentname character varying,
    IN vcomponentparentname character varying,
    IN vcomponentdescription character varying,
    IN vattributelist text[],
    IN vtechnologylist text[],
    IN vcreatedby uuid,
    IN vRoleName varchar)
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentname character varying, componentparentuuid uuid, componentdescription character varying, attributelist uuid[], technologylist uuid[], createdat timestamp with time zone, createdby uuid) AS
$$
	#variable_conflict use_column
      DECLARE 	vAttributeName text; 
        	vTechName text;
		vCompID integer;
		vCompUUID uuid;
		vCompParentUUID uuid := (select case when (vComponentParentName = 'Root' and not exists (select 1 from components where componentName = 'Root')) then uuid_generate_v4() else componentuuid end from components where componentname = vComponentParentName);
		vFunctionName varchar := 'SetComponent'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN       
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
		       perform public.createattribute(vAttributeName,vCreatedBy, vRoleName);
			 end if;
		END LOOP;
		
		-- Create new Component
		perform public.createcomponent(vCompParentUUID,vComponentName, vComponentdescription, vCreatedby, vRoleName);
			vCompID := (select currval('ComponentID')); 
			vCompUUID := (select componentuuid from components where componentID = vCompID);
		
		-- Create relation from Components to TechnologyData 
		perform public.CreateComponentsAttribute(vCompUUID, vAttributeList, vRoleName);  
		
		-- Create relation from Components to TechnologyData 
		perform public.CreateComponentsTechnologies(vCompUUID, vTechnologyList, vRoleName); 
		
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
			join componentsattribute ca 	
			on co.componentid = ca.componentid	
			join attributes att 
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
 CREATE FUNCTION public.settechnologydata(  
	vTechnologyDataName varchar(250), 
	vTechnologyData varchar(32672), 
	vTechnologyDataDescription varchar(32672), 
	vtechnologyuuid uuid,
	vLicensefee integer,
	vRetailPrice integer,
	vTaglist text[],	
	vComponentlist text[],
	vCreatedby uuid,
	vRoleName varchar)
  RETURNS TABLE (
	TechnologyDataUUID uuid,
	TechnologyDataName varchar(250),
	TechnologyUUID uuid,
	TechnologyData varchar(32672),
	LicenseFee integer,
	RetailPrice integer,
	TechnologyDataDescription varchar(32672),
	TechnologyDataThumbnail bytea,
	TechnologyDataImgRef character varying,
	TagList uuid[],
	ComponentList uuid[],
	CreatedAt timestamp with time zone,
	CreatedBy uuid
  ) AS	  
$$    
	#variable_conflict use_column
      DECLARE 	vCompName text;
				vTagName text; 
				vTechnologyDataID int; 
				vTechnologyDataUUID uuid;
				vTechnologyID integer := (select technologyID from technologies where technologyUUID = vTechnologyUUID);
				vFunctionName varchar := 'SetTechnologyData'; 
				vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN         
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
				perform public.createtag(vTagName,vCreatedby, vRoleName);
			 end if;
		END LOOP;
		-- Proof if technology is avaiable  
		if not exists (select technologyid from technologies where technologyuuid = vTechnologyUUID) then
			raise exception using
		    errcode = 'invalid_parameter_value',
		    message = 'There is no technology with TechnologyID: ' || vTechnologyID::text; 
		end if;
		
		-- Create new TechnologyData  
			perform public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vRetailPrice, vTechnologyUUID, vCreatedBy, vRoleName); 		
		vTechnologyDataID := (select currval('TechnologyDataID'));
		vTechnologyDataUUID := (select technologydatauuid from technologydata where technologydataid = vTechnologyDataID);
		-- Create relation from Components to TechnologyData 
		perform public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList, vRoleName);
		
		-- Create relation from Tags to TechnologyData 
		perform public.CreateTechnologyDataTags(vTechnologyDataUUID, vTagList, CreatedBy, vRoleName);
		
		-- Begin Log if success
		perform public.createlog(0,'Set TechnologyData sucessfully', 'SetTechnologyData', 
					'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: ' 
					|| vTechnologyDataName || ', TechnologyData: ' || vTechnologyData 
					|| ', TechnologyDataDescription: ' || vTechnologyDataDescription 
					|| ', CreatedBy: ' || cast(vRoleName as varchar));

	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 				
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
                                || ', CreatedBy: ' || cast(vCreatedby as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetTechnologyData';
        RETURN;
      END;
  $$
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
CREATE FUNCTION SetPaymentInvoiceOffer ( 
	vOfferRequestUUID uuid,
	vInvoice varchar(32672),
	vCreatedBy uuid,
	vRoleName varchar	
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
	#variable_conflict use_column
      DECLARE  
		vPaymentInvoiceID integer;
		vPaymentInvoiceUUID uuid; 
		vFunctionName varchar := 'SetPaymentInvoiceOffer'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN        
		-- Create PaymentInvoice
		perform createpaymentinvoice(vInvoice,vOfferRequestUUID,vCreatedBy, vRoleName);
		vPaymentInvoiceID := (select currval('PaymentInvoiceID'));
		vPaymentInvoiceUUID := (select paymentinvoice.paymentinvoiceuuid from paymentinvoice where paymentinvoiceid = vPaymentInvoiceID);
			
		-- Create Offer
		perform createoffer(vPaymentInvoiceUUID, vCreatedBy, vRoleName);

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
CREATE OR REPLACE FUNCTION GetAllTechnologyData(vUserUUID uuid, vRoleName varchar) 
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
	DECLARE vFunctionName varchar := 'GetAllTechnologyData'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN  
	
		RETURN QUERY (SELECT 	technologydatauuid,
					tc.technologyuuid,    		
					technologydataname,
					technologydata,
					technologydatadescription,
					licensefee,				
					retailprice,
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
	$$
	LANGUAGE 'plpgsql';
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
	vUserUUID uuid,
    vRoleName varchar)
  RETURNS TABLE(technologydatauuid uuid, 
		technologyuuid uuid, 
		technologydataname character varying, 
		technologydata character varying, 
		technologydatadescription character varying, 
		licensefee integer, 
		retailprice integer, 
		technologydatathumbnail bytea, 
		technologydataimgref character varying, 
		createdat timestamp with time zone, 
		createdby uuid, 
		updatedat timestamp with time zone,
		updatedyby uuid) AS
$$ 
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByID'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN 
	
	RETURN QUERY (	SELECT 	technologydatauuid,
				tc.technologyuuid,    		
				technologydataname,
				technologydata,
				technologydatadescription,
				licensefee,
				retailprice,
				technologydatathumbnail,
				technologydataimgref,
				td.createdat  at time zone 'utc',
				td.createdby,	
				td.updatedat  at time zone 'utc',
				td.updatedby
				FROM TechnologyData td
				join technologies tc 
				on td.technologyid = tc.technologyid
				where technologydatauuid = vtechnologydatauuid
		);

	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
$$ LANGUAGE 'plpgsql';
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
		vUserUUID uuid,
		vRoleName varchar
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
			updatedBy uuid
        )
    AS $$ 
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByName'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN 
	
    	RETURN QUERY (SELECT 	technologydatauuid,
				tc.technologyuuid,    		
				technologydataname,
				technologydata,
				technologydatadescription,
				licensefee,
				retailprice,
				technologydatathumbnail,
				technologydataimgref,
				td.createdat  at time zone 'utc',
				td.createdby,	
				td.updatedat  at time zone 'utc',
				td.updatedBy
			FROM TechnologyData td
			join technologies tc 
			on td.technologyid = tc.technologyid 
			where technologydataname = vTechnologyDataName
		);
		
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
	$$ LANGUAGE 'plpgsql';
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-15
-- Description: Script to get all Components
-- ##########################################################################
Get all Components
Input paramteres: vRoleName	
Return Value: Table with all Components 
######################################################*/ 
CREATE FUNCTION public.getallcomponents(vUserUUID uuid, vrolename character varying)
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid integer, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$ 
	DECLARE
		vFunctionName varchar := 'GetAllComponents'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
		);

	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
    $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION public.getallcomponents(character varying)
  OWNER TO postgres;

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
CREATE FUNCTION public.getcomponentbyid(
    IN vcompuuid uuid,
	IN vUserUUID uuid,
    IN vRoleName varchar)
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid uuid, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$$ 
	DECLARE
		vFunctionName varchar := 'GetComponentById'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetComponentByName(vCompName varchar(250), vUserUUID uuid, vRoleName varchar) 
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

	DECLARE
		vFunctionName varchar := 'GetComponentByName'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN  
	
	RETURN QUERY (SELECT  	componentuuid,
				componentname,
				componentparentid,
				componentdescription, 
				cp.createdat  at time zone 'utc',
				cp.createdby,
				cp.updatedat  at time zone 'utc',
				cp.updatedby 
		    FROM Components cp
		    WHERE componentname = vCompName
		 );

	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
    $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetAllTags(vUserUUID uuid, vRoleName varchar) 
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

	DECLARE
		vFunctionName varchar := 'GetAllTags'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetTagByID(vTagID uuid, vUserUUID uuid, vRoleName varchar) 
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

	DECLARE
		vFunctionName varchar := 'GetTagByID'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetTagByName(vTagName varchar(250), vUserUUID uuid, vRoleName varchar) 
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

	DECLARE
		vFunctionName varchar := 'GetTagByName'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetAllTechnologies(vUserUUID uuid, vRoleName varchar) 
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

	DECLARE
		vFunctionName varchar := 'GetAllTechnologies'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetTechnologyByID(vtechUUID uuid, vUserUUID uuid, vRoleName varchar) 
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
	DECLARE
		vFunctionName varchar := 'GetTechnologyByName'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetTechnologyByName(vtechName varchar, vUserUUID uuid, vRoleName varchar) 
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

	DECLARE
		vFunctionName varchar := 'GetTechnologyByName'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
		    WHERE technologyname = vtechName
		 );

	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
    $$ LANGUAGE 'plpgsql';
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
CREATE OR REPLACE FUNCTION public.gettechnologydatabyparams(
    vcomponents text[], 
    vtechnologyuuid uuid,
    vCreatedBy uuid,
    out result json)
	AS
$BODY$	 

	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByParams'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN   

	IF(vIsAllowed) THEN  
	
	 	 with tg as (
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
			select co.componentuuid, co.componentid, co.componentname, array_to_json(array_agg(t.*)) as attributes from att t
			join componentsattribute ca on t.attributeid = ca.attributeid
			join components co on co.componentid = ca.componentid
			group by co.componentname, co.componentid, co.componentuuid
			),
			techData as (	
				select td.technologydatauuid,
					td.technologydataname,
					tt.technologyuuid,
					td.technologydata,
					td.licensefee,
					td.retailprice,
					td.licenseproductcode,
					td.technologydatadescription,
					td.technologydatathumbnail,
					td.technologydataimgref,
					td.createdat at time zone 'utc',
					co.CreatedBy,
					td.updatedat at time zone 'utc',
					co.UpdatedBy,
					array_to_json(array_agg(co.*)) ComponentsWithAttribute
				from comp co join technologydatacomponents tc
				on co.componentid = tc.componentid
				join technologydata td on
				td.technologydataid = tc.technologydataid
				join components cm on cm.componentid = co.componentid  
				join technologies tt on 
				tt.technologyid = td.technologyid
				group by td.technologydatauuid,
					td.technologydataname,
					tt.technologyuuid,
					td.technologydata,
					td.licensefee,
					td.retailprice,
					td.licenseproductcode,
					td.technologydatadescription,
					td.technologydatathumbnail,
					td.technologydataimgref,
					td.createdat,				
					co.useruuid,
					td.updatedat,
					co.useruuid	
			),
			compIn as (
				select	technologydataname, array_agg(componentuuid order by componentuuid asc) comp 
				from components co
				join technologydatacomponents tc
				on co.componentid = tc.componentid
				join technologydata td on
				td.technologydataid = tc.technologydataid
				group by technologydataname	 			
			)
			select array_to_json(array_agg(td.*)) from techData	td
			join compIn co on co.technologydataname = td.technologydataname
			where co.comp::text[] <@ vComponents;
		 
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
		$BODY$
  LANGUAGE 'plpgsql';   
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
CREATE FUNCTION GetAllOffers(vUserUUID varchar, vRoleName varchar) 
	RETURNS TABLE
    	(
    offeruuid uuid,    
    paymentinvoiceuuid uuid,
    createdat timestamp with time zone,
    createdby uuid
        )
    AS $$ 

	DECLARE
		vFunctionName varchar := 'GetAllOffers'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';  
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
CREATE FUNCTION GetAllAttributes(vUserUUID uuid, vRoleName varchar) 
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

	DECLARE
		vFunctionName varchar := 'GetAllAttributes'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-28
-- Description: Script to get attribute by given ID
-- ##########################################################################
Input paramteres: attributeUUID uuid		
Return Value: Table with a attribute
######################################################*/
CREATE FUNCTION GetAttributeByID(vAttrUUID uuid, vUserUUID uuid, vRoleName varchar) 
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

	DECLARE
		vFunctionName varchar := 'GetAttributeByID'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-28
-- Description: Script to get attribute by given Name
-- ##########################################################################
Input paramteres: attributeName varchar(250)
Return Value: Table with a attribute
######################################################*/
CREATE FUNCTION GetAttributeByName(vAttrName varchar(250), vUserUUID uuid, vRoleName varchar) 
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

	DECLARE
		vFunctionName varchar := 'GetAttributeByName'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetOfferByRequestID(vRequestID uuid, vUserUUID uuid, vRoleName varchar) 
	RETURNS TABLE
    	(
    offeruuid uuid, 
    paymentinvoiceuuid uuid,
    createdat timestamp with time zone,
    createdby uuid 
        )
    AS $$ 

	DECLARE
		vFunctionName varchar := 'GetOfferByRequestID'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN 
	
	RETURN QUERY (SELECT  ofr.offeruuid,                
				pm.paymentinvoiceuuid,
				ofr.createdat at time zone 'utc',
				ofr.createdby
			FROM offer ofr 	
			JOIN paymentinvoice pm 
			ON ofr.paymentinvoiceid = pm.paymentinvoiceid
			WHERE pm.offerrequestid = (select offerrequest.offerrequestid from offerrequest where offerrequestuuid = vRequestID)
		);
		
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
   $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetOfferByID(vOfferID uuid, vUserUUID uuid, vRoleName varchar) 
	RETURNS TABLE
    	(
    offeruuid uuid, 
    paymentinvoiceuuid uuid,
    createdat timestamp with time zone, 
    createdby uuid
        )
    AS $$ 

	DECLARE
		vFunctionName varchar := 'GetOfferByID'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
    $$ LANGUAGE 'plpgsql';
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
CREATE FUNCTION GetActivatedLicensesSince (vTime timestamp, vUserUUID uuid, vRoleName varchar)
RETURNS integer AS
$$ 
	DECLARE
		vFunctionName varchar := 'GetActivatedLicensesSince'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN 
	
		with activatedLinceses as(
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
	
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN null;
	END IF; 

	END;
 
$$ LANGUAGE 'plpgsql';
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
CREATE OR REPLACE FUNCTION public.gettoptechnologydatasince(
    IN vsincedate timestamp without time zone,
    IN vtopvalue integer,
	IN vUserUUID uuid,
    IN vRoleName varchar)
  RETURNS TABLE(technologydataname character varying, rank integer, revenue numeric) AS
$BODY$	

	DECLARE
		vFunctionName varchar := 'GetTopTechnologyDataSince'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN  

	RETURN QUERY (	select technologydataname, count(ts.offerid)::integer, (sum(td.retailprice)/100000)::numeric(21,2) as "Revenue (in IUNOs)" from transactions ts
			join licenseorder lo
			on ts.offerid = lo.offerid
			join offerrequest oq 
			on oq.offerrequestid = ts.offerrequestid
			join technologydata td
			on oq.technologydataid = td.technologydataid
			where (select datediff('second',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('minute',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('hour',vSinceDate::timestamp,activatedat::timestamp)) >= 0
			group by technologydataname
			order by count(ts.offerid) desc limit vTopValue
		);

	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF;

	END;
			
	$BODY$
	  LANGUAGE 'plpgsql';  
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
		vTopValue integer,
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
	ComponentName varchar(250),
	Amount integer
) AS
$$

	DECLARE
		vFunctionName varchar := 'GetMostUsedComponents'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN  
	
		with activatedLinceses as(
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

	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
 $$ LANGUAGE 'plpgsql';
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
		vSinceDate timestamp without time zone,
		vUserUUID uuid,
		vRoleName varchar	
	)
RETURNS TABLE (
	  TechnologyDataName varchar(250),
	  Date date,
	  Amount integer,
	  DayHour integer
	) AS
$$

	DECLARE
		vFunctionName varchar := 'GetWorkloadSince'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN 

			with activatedLicenses as(
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
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF;

	END;
$$ LANGUAGE 'plpgsql'; 
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Payment for given OfferRequest
-- ##########################################################################
Input paramteres: vOfferRequestUUID uuid 
######################################################*/
CREATE FUNCTION GetPaymentInvoiceForOfferRequest(
		vOfferRequestUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
	PaymentInvoiceUUID uuid,
	OfferRequestUUID uuid,
	Invoice varchar(32672),
	CreatedAt timestamp with time zone,
	CreatedBy uuid
	) AS 
$$	 

	DECLARE
		vFunctionName varchar := 'GetPaymentInvoiceForOfferRequest'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Offer for given PaymentInvoice
-- ##########################################################################
Input paramteres: vPaymentInvoiceUUID uuid 
######################################################*/
CREATE FUNCTION GetOfferForPaymentInvoice(
		vPaymentInvoiceUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
	OfferUUID uuid,
	PaymentInvoiceUUID uuid,	
	CreatedAt timestamp with time zone,
	CreatedBy uuid
	) AS 
$$	 
	DECLARE
		vFunctionName varchar := 'GetOfferForPaymentInvoice'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN 
	
	RETURN QUERY (select 	ofr.offerUUID,
				pi.PaymentInvoiceUUID,			
				pi.createdat at time zone 'utc',
				ofr.createdby
			from Offer ofr
			join paymentinvoice pi 
			on ofr.paymentinvoiceid = pi.paymentinvoiceid 
		);
		
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF;

	END;
$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Components for given TechnologyUUID
-- ##########################################################################
Input paramteres: vTechnologyUUID uuid 
######################################################*/
CREATE FUNCTION GetComponentsByTechnology(
		vTechnologyUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
		ComponentUUID uuid,		
		ComponentName varchar(250),
		ComponentParentUUID uuid, 
		ComponentParentName varchar(250),
		ComponentDescription varchar(32672),
		Createdat timestamp with time zone,
		Createdby uuid,
		Updatedat timestamp with time zone,
		Useruuid uuid
	) AS 
$$	 
	DECLARE
		vFunctionName varchar := 'GetComponentsByTechnology'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Technology for given OfferRequestUUID
-- ##########################################################################
Input paramteres: vOfferRequestUUID uuid 
######################################################*/
CREATE FUNCTION GetTechnologyForOfferRequest(
		vOfferRequestUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
		Technologyuuid uuid,
		TechnologyName varchar(250),
		TechnologyDescription varchar(32672),
		Createdat timestamp with time zone,
		Createdby uuid,
		Updatedat timestamp with time zone,
		Updatedby uuid
	) AS 
$$	 
	DECLARE
		vFunctionName varchar := 'GetTechnologyForOfferRequest'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get LicenseFee for given TransactionUUID
-- ##########################################################################
Input paramteres: vTransactionUUID uuid 
######################################################*/
CREATE FUNCTION GetLicenseFeeByTransaction(
		vTransactionUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
	) 
RETURNS TABLE (
		LicenseFee integer
	) AS 
$$	 
	DECLARE
		vFunctionName varchar := 'GetLicenseFeeByTransaction'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN 

	RETURN QUERY (select	td.licenseFee
			from transactions ts
			join offerrequest oq
			on oq.offerrequestid = ts.offerrequestid
			join technologydata td
			on oq.technologydataid = td.technologydataid
			where ts.transactionuuid = vTransactionUUID
		);
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
$$ LANGUAGE 'plpgsql';  
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Transaction for given OfferRequestUUID
-- ##########################################################################
Input paramteres: vOfferRequestUUID uuid 
######################################################*/ 
CREATE OR REPLACE FUNCTION GetTransactionByOfferRequest(
		vOfferRequestUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
		Transactionuuid uuid,
		Buyer uuid,
		Offeruuid uuid,
		Offerrequestuuid uuid,
		Paymentuuid uuid,
		Paymentinvoiceid uuid,
		Licenseorderuuid uuid,
		Createdat timestamp with time zone,
		Createdby uuid,
		Updatedat timestamp with time zone,
		Updatedby uuid
	) AS 
$$	 
	DECLARE
		vFunctionName varchar := 'GetTransactionByOfferRequest'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get TechnologyData for given OfferRequestUUID
-- ##########################################################################
Input paramteres: vOfferRequestUUID uuid 
######################################################*/
CREATE FUNCTION GetTechnologyDataByOfferRequest(
		vOfferRequestUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
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
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByOfferRequest'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN 
	
    	RETURN QUERY (SELECT 	technologydatauuid,
			tc.technologyuuid,    		
			technologydataname,
			technologydata,
			technologydatadescription,
			licensefee,
			retailprice,
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
		);
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 

	END;
	$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Offer for given TransactionUUID
-- ##########################################################################
Input paramteres: vTransactionUUID uuid 
######################################################*/	
CREATE FUNCTION GetOfferForTransaction(
		vTransactionUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
		OfferUUID uuid,
		PaymentInvoiceUUID uuid,	
		CreatedAt timestamp with time zone,
		CreatedBy uuid
	) AS 
$$	 
	DECLARE
		vFunctionName varchar := 'GetOfferForTransaction'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Offer for given TicketID
-- ##########################################################################
Input paramteres: vTicketID varchar(4000) 
######################################################*/	
CREATE FUNCTION GetOfferForTicket(
		vTicketID varchar(4000),
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
		OfferUUID uuid,
		PaymentInvoiceUUID uuid,	
		CreatedAt timestamp with time zone,
		CreatedBy uuid
	) AS 
$$	 
	DECLARE
		vFunctionName varchar := 'GetOfferForTicket'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-13
-- Description: Create Roles
-- ##########################################################################
Input paramteres: vRoleName varchar(250)
				  vRoleDescription varchar(32672)
######################################################*/
create function createrole(vRoleName varchar(250), vRoleDescription varchar(32672), vUserUUID uuid, vRoleNameUser varchar) 
returns void as
$$
	Declare vRoleID integer := (select nextval('RoleID')); 
		vFunctionName varchar := 'CreateRole';
		vIsAllowed boolean := (select public.checkPermissions(vRoleNameUser, vFunctionName));
		
		
	BEGIN 
		if(vIsAllowed) then
			insert into roles (RoleID, RoleName, RoleDescription)
			values (vRoleID, vRoleName, vRoleDescription);
		else 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
		end if;

	 -- Begin Log if success
        perform public.createlog(0,'Created Role sucessfully', 'CreateRole', 
                                'RoleID: ' || cast(vRoleID as varchar)  
                                || ', vRoleName: ' || vRoleName 
                                || ', RoleDescription: ' 
                                || vRoleDescription);

	 exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateRole', 
                                'RoleID: ' || cast(vRoleID as varchar)  
                                || ', vRoleName: ' || vRoleName 
                                || ', RoleDescription: ' 
                                || vRoleDescription);
        -- End Log if error
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateRole';	
		RETURN;
	END;
$$ LANGUAGE PLPGSQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-13
-- Description: Create permissions for Roles
-- ##########################################################################
Input paramteres: vRoleName varchar, 
				  vFunctionName varchar(250),
				  vRoleNameUser varchar
######################################################*/
create function SetPermission(
		vRoleName varchar, 
		vFunctionName varchar(250),
		vUserUUID uuid,
		vRoleNameUser varchar		
	) 
RETURNS void AS
$$
	DECLARE vFunctionID integer := (select nextval('FunctionID'));				
		vThisFunctionName varchar := 'SetPermission';
		vIsAllowed boolean := (select public.checkPermissions(vRoleNameUser, vThisFunctionName));
		vRoleId integer := (select roleid from roles where rolename = vRoleName);
	BEGIN
		if(vIsAllowed) then		
			insert into functions (FunctionID, FunctionName)
			values (vFunctionID, vFunctionName);

			insert into rolespermissions(RoleId,FunctionId)
			values (vRoleId, vFunctionId);
		else 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
		end if;

	-- Begin Log if success
        perform public.createlog(0,'Created Permission sucessfully', 'SetPermission', 
                                'PermissionID: ' || cast(vFunctionID as varchar) || ', Role: ' 
                                || vRoleName || ', FunctionName: ' || vFunctionName);

	 exception when others then 
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'SetPermission', 
                                'PermissionID: ' || cast(vFunctionID as varchar) || ', Roles ' 
                                || vRoleName || ', FunctionName: ' || vFunctionName);
        -- End Log if error 
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetPermission';
		RETURN;
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
		vTransactionUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
		Transactionuuid uuid,
		Buyer uuid,
		Offeruuid uuid,
		Offerrequestuuid uuid,
		Paymentuuid uuid,
		Paymentinvoiceid uuid,
		Licenseorderuuid uuid,
		Createdat timestamp with time zone,
		Createdby uuid,
		Updatedat timestamp with time zone,
		Updatedby uuid
	) AS 
$$	  
	DECLARE
		vFunctionName varchar := 'GetTransactionByID'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN  

	RETURN QUERY (select	ts.transactionuuid,
				ts.buyer,
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
$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Components for given TechnologyDataUUID
-- ##########################################################################
Input paramteres: vTechnologyDataUUID uuid 
######################################################*/
CREATE FUNCTION GetComponentsForTechnologyDataID(
		vTechnologyDataUUID uuid,
		vUserUUID uuid,
		vRoleName varchar
	)
RETURNS TABLE (
		ComponentUUID uuid,		
		ComponentName varchar(250),
		ComponentParentUUID uuid, 
		ComponentParentName varchar(250),
		ComponentDescription varchar(32672),
		Createdat timestamp with time zone,
		Createdby uuid,
		Updatedat timestamp with time zone,
		Useruuid uuid
	) AS 
$$	 
	DECLARE
		vFunctionName varchar := 'GetComponentsForTechnologyDataID'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
	$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Revenue per day
-- ##########################################################################
Input paramteres: vDate timestamp
				  vUserUUID uuid
######################################################*/
-- Get Revenue per Day
create function GetRevenuePerDaySince(vDate timestamp, vUserUUID uuid, vRoleName varchar)
returns table (date date, revenue numeric(21,2))
as 
$$	
	DECLARE
		vFunctionName varchar := 'GetRevenuePerDaySince'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN  

	RETURN QUERY (select activatedat::date, (sum(td.retailprice)/100000)::numeric(21,2) as "Revenue (in IUNOs)" from transactions ts
			join licenseorder lo
			on ts.licenseorderid = lo.licenseorderid
			join offerrequest oq 
			on oq.offerrequestid = ts.offerrequestid
			join technologydata td
			on oq.technologydataid = td.technologydataid 
			where (select datediff('second',vDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('minute',vDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('hour',vDate::timestamp,activatedat::timestamp)) >= 0 	 
			group by activatedat::date 
			order by activatedat::date
		);
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 
	
	END;
	$$ LANGUAGE 'plpgsql'; 
/* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Revenue per hour
-- ##########################################################################
Input paramteres: vDate timestamp
				  vUserUUID uuid
######################################################*/
CREATE FUNCTION public.getrevenueperhoursince(
    vdate timestamp without time zone,
	vUserUUID uuid,
    vRoleName varchar)
  RETURNS TABLE(date date, hour double precision, revenue numeric) AS
$$
	DECLARE
		vFunctionName varchar := 'GetRevenuePerHourSince'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

	IF(vIsAllowed) THEN 

	RETURN QUERY (select activatedat::date, date_part('hour',activatedat) , (sum(td.retailprice)/100000)::numeric(21,2) as "Revenue (in IUNOs)" from transactions ts
			join licenseorder lo
			on ts.licenseorderid = lo.licenseorderid
			join offerrequest oq 
			on oq.offerrequestid = ts.offerrequestid
			join technologydata td
			on oq.technologydataid = td.technologydataid 
			where (select datediff('second',vDate::timestamp,activatedat::timestamp)) >= 0 AND
			      (select datediff('minute',vDate::timestamp,activatedat::timestamp)) >= 0 AND
			      (select datediff('hour',vDate::timestamp,activatedat::timestamp)) >= 0 	 
			group by activatedat::date, date_part('hour',activatedat) 
			order by activatedat::date, date_part('hour',activatedat)
		);
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF; 
	
	END;
	$$ LANGUAGE 'plpgsql'; 
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-31
-- Description: Delete given TechnologyData
-- ##########################################################################
Input paramteres: vTechnologyDataName varchar(250)
				  vUserUUID uuid
######################################################*/ 
create or replace function DeleteTechnologyData(vTechnologyDataName varchar(250), vUserUUID uuid, vRoleName varchar)
RETURNS void AS
$$
	DECLARE 
		vTechnologyDataId integer := (select TechnologyDataId from technologydata where technologydataname = vTechnologyDataName);
		vFunctionName varchar := 'DeleteTechnologyData'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
	BEGIN     

		IF(vIsAllowed) THEN  
		create TEMP table vDeleteValues (technologydataid integer, offerid integer, offerrequestid integer, transactionid integer, paymentinvoiceid integer, paymentid integer, licenseorderid integer);
		-- Get all necessary IDs
		insert into vDeleteValues (technologydataid, offerid, offerrequestid, transactionid, paymentinvoiceid, paymentid, licenseorderid)
		select td.technologydataid, ofr.offerid, oq.offerrequestid, transactionid, pi.paymentinvoiceid, py.paymentid, lo.licenseorderid 
		from technologydata td		
		join offerrequest oq on td.technologydataid = oq.technologydataid
		join paymentinvoice pi on pi.offerrequestid = oq.offerrequestid			
		left outer join offer ofr on ofr.paymentinvoiceid = pi.paymentinvoiceid
		left outer join payment py on py.paymentinvoiceid = pi.paymentinvoiceid
		left outer join licenseorder lo on lo.offerid = ofr.offerid	
		left outer join transactions ts on ts.paymentinvoiceid = pi.paymentinvoiceid	
		where td.technologydataid = vTechnologyDataId;

		-- delete transactions
		delete from transactions where transactionid in (select transactionid from vDeleteValues);

		-- delete licenseorder
		delete from licenseorder where licenseorderid  in (select licenseorderid from vDeleteValues);

		-- delete offerid
		delete from offer where offerid in (select offerid from vDeleteValues);			

		-- delete payment
		delete from payment where paymentid in (select paymentid from vDeleteValues);		
		
		-- delete paymentinvoice
		delete from paymentinvoice where paymentinvoiceid in (select paymentinvoiceid from vDeleteValues);

		-- delete offerrequest
		delete from offerrequest where TechnologyDataId = vTechnologyDataID;
		
		-- delete technologydatacomponents
		delete from technologydatacomponents where TechnologyDataId = vTechnologyDataID;

		-- delete technologydatatags
		delete from technologydatatags where TechnologyDataId = vTechnologyDataID;		

		-- delete technologydata
		delete from technologydata where TechnologyDataId = vTechnologyDataID;

		--Drop Temp Table
		drop table vDeleteValues;
	ELSE 
		 RAISE EXCEPTION '%', 'Insufficiency rigths';	
		 RETURN;
	END IF;
	
	END;
$$
LANGUAGE PLPGSQL;
 /* ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-07-12
-- Description: Proof the role permissions
-- ##########################################################################
Input paramteres: vRoleName varchar
				  vFunctionName varchar
######################################################*/ 
CREATE OR REPLACE FUNCTION checkPermissions(
		vRoleName varchar,
		vFunctionName varchar
	)
RETURNS BOOLEAN AS
$$
	#variable_conflict use_column
	DECLARE	vIsAllowed boolean;
		vRoleId integer := (select roleid from roles where rolename = vRoleName);
		vFunctionId integer := (select functionId from functions where functionname = vFunctionName);
	BEGIN
		vIsAllowed := (select exists(select 1 from rolespermissions where roleid=vRoleId and functionId = vFunctionId));
		if(vIsAllowed) then
			return true;
		else
			return false;
		end if;
	END;
$$
LANGUAGE PLPGSQL;
--######################################################
--GetLicenseFeeByTechnologyData
CREATE FUNCTION public.GetLicenseFeeByTechnologyData(
    IN vTechnologyDataUUID uuid,
    IN vUserUUID uuid,
    IN vrolename character varying
    )
  RETURNS TABLE(licensefee integer) AS
$BODY$	 
	DECLARE
		vFunctionName varchar := 'GetLicenseFeeByTechnologyData'; 
		vIsAllowed boolean := (select public.checkPermissions(vRoleName, vFunctionName));
		
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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000; 

  
  