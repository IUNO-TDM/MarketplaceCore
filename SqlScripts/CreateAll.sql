-- Generiert von Oracle SQL Developer Data Modeler 4.0.3.853
--   am/um:        2017-02-23 08:31:59 MEZ
--   Site:      DB2/UDB 8.1
--   Typ:      DB2/UDB 8.1
 



CREATE
  TABLE Attributes
  (
    AttributeID   INTEGER NOT NULL ,
    AttributeUUID UUID,
    AttributeName VARCHAR (250) NOT NULL ,
    CreatedAt     timestamp with time zone NOT NULL ,
    CreatedBy     INTEGER NOT NULL ,
    UpdatedAt     timestamp with time zone ,
    UpdatedBy     INTEGER
  ) ;
ALTER TABLE Attributes ADD CONSTRAINT Attribubes_PK PRIMARY KEY ( AttributeID )
;
ALTER TABLE Attributes ADD CONSTRAINT Attributes__UN UNIQUE ( AttributeName ) ;

CREATE
  TABLE Components
  (
    ComponentID          INTEGER NOT NULL ,
    ComponentUUID        UUID,
    ComponentName        VARCHAR (250) ,
    ComponentParentID    INTEGER ,
    ComponentDescription VARCHAR (32672) ,
    CreatedAt            timestamp with time zone NOT NULL ,
    CreatedBy            INTEGER NOT NULL ,
    UpdatedAt            timestamp with time zone ,
    UpdatedBy            INTEGER
  ) ;
ALTER TABLE Components ADD CONSTRAINT Components_PK PRIMARY KEY ( ComponentID )
;
ALTER TABLE Components ADD CONSTRAINT Components__UN UNIQUE ( ComponentName ) ;

CREATE
  TABLE ComponentsAttribute
  (
    ComponentID INTEGER NOT NULL ,
    AttributeID INTEGER NOT NULL
  ) ;
ALTER TABLE ComponentsAttribute ADD CONSTRAINT ComponentsAttribute_PK PRIMARY
KEY ( AttributeID, ComponentID ) ;

CREATE
  TABLE ComponentsTechnologies
  (
    ComponentID  INTEGER NOT NULL ,
    TechnologyID INTEGER NOT NULL
  ) ;
ALTER TABLE ComponentsTechnologies ADD CONSTRAINT ComponentsTechnologies_PK
PRIMARY KEY ( ComponentID, TechnologyID ) ;

CREATE
  TABLE LicenseOrder
  (
    LicenseOrderID   INTEGER NOT NULL ,
    LicenseOrderUUID UUID,
    ActivatedAt      timestamp with time zone ,
    CreatedAt        timestamp with time zone NOT NULL ,
    TicketID         VARCHAR (32672) ,
    OfferID          INTEGER NOT NULL
  ) ;
ALTER TABLE LicenseOrder ADD CONSTRAINT LicenseOrder_PK PRIMARY KEY (
LicenseOrderID ) ;

CREATE
  TABLE LogTable
  (
    LogID         INTEGER NOT NULL ,
    LogMessage    VARCHAR (32672) NOT NULL ,
    LogObjectName VARCHAR (250) ,
    Parameters    VARCHAR (32672) ,
    CreatedAt     timestamp with time zone NOT NULL
  ) ;
ALTER TABLE LogTable ADD CONSTRAINT LogTable_PK PRIMARY KEY ( LogID ) ;

CREATE
  TABLE Offer
  (
    OfferID          INTEGER NOT NULL ,
    OfferUUID        UUID,
    OfferRequestID   INTEGER NOT NULL ,
    PaymentInvoiceID INTEGER NOT NULL
  ) ;
ALTER TABLE Offer ADD CONSTRAINT Offer_PK PRIMARY KEY ( OfferID ) ;

CREATE
  TABLE OfferRequest
  (
    OfferRequestID   INTEGER NOT NULL ,
    OfferRequestUUID UUID,
    TechnologyDataID INTEGER NOT NULL ,
    Amount           INTEGER ,
    HSMID            INTEGER ,
    CreatedAt        timestamp with time zone ,
    RequestedBy      INTEGER NOT NULL
  ) ;
ALTER TABLE OfferRequest ADD CONSTRAINT OfferRequest_PK PRIMARY KEY (
OfferRequestID ) ;

CREATE
  TABLE Payment
  (
    PaymentInvoiceID   INTEGER NOT NULL ,
    PaymentInvoiceUUID UUID,
    PayDate            timestamp with time zone ,
    BitcoinTransaction VARCHAR (32672)
  ) ;
ALTER TABLE Payment ADD CONSTRAINT Payment_PK PRIMARY KEY ( PaymentInvoiceID )
;

CREATE
  TABLE Tags
  (
    TagID     INTEGER NOT NULL ,
    TagUUID   UUID,
    TagName   VARCHAR (250) NOT NULL ,
    CreatedAt timestamp with time zone NOT NULL ,
    CreatedBy INTEGER NOT NULL ,
    UpdatedAt timestamp with time zone ,
    UpdatedBy INTEGER
  ) ;
ALTER TABLE Tags ADD CONSTRAINT Tags_PK PRIMARY KEY ( TagID ) ;

CREATE
  TABLE Technologies
  (
    TechnologyID          INTEGER NOT NULL ,
    TechnologyUUID        UUID,
    TechnologyName        VARCHAR (250) NOT NULL ,
    TechnologyDescription VARCHAR (32672) ,
    CreatedAt             timestamp with time zone NOT NULL ,
    CreatedBy             INTEGER NOT NULL ,
    UpdatedAt             timestamp with time zone ,
    UpdatedBy             INTEGER
  ) ;
ALTER TABLE Technologies ADD CONSTRAINT Technologies_PK PRIMARY KEY (
TechnologyID ) ;
ALTER TABLE Technologies ADD CONSTRAINT Technologies__UN UNIQUE (
TechnologyName ) ;

CREATE
  TABLE TechnologyData
  (
    TechnologyDataID          INTEGER NOT NULL ,
    TechnologyDataUUID        UUID,
    TechnologyDataName        VARCHAR (250) NOT NULL ,
    TechnologyID              INTEGER NOT NULL ,
    TechnologyData            VARCHAR (32672) NOT NULL ,
    TechnologyDataDescription VARCHAR (32672) ,
    LicenseFee                DECIMAL (21,4) NOT NULL ,
    CreatedAt                 timestamp with time zone NOT NULL ,
    CreatedBy                 INTEGER NOT NULL ,
    UpdateAt                  timestamp with time zone ,
    UpdatedBy                 INTEGER
  ) ;
ALTER TABLE TechnologyData ADD CONSTRAINT TechnologyData_PK PRIMARY KEY (
TechnologyDataID ) ;
ALTER TABLE TechnologyData ADD CONSTRAINT TechnologyData__UN UNIQUE (
TechnologyDataName ) ;

CREATE
  TABLE TechnologyDataComponents
  (
    TechnologyDataID INTEGER NOT NULL ,
    ComponentID      INTEGER NOT NULL
  ) ;
ALTER TABLE TechnologyDataComponents ADD CONSTRAINT TechnologyDataComponents_PK
PRIMARY KEY ( TechnologyDataID, ComponentID ) ;

CREATE
  TABLE TechnologyDataTags
  (
    TechnologyDataID INTEGER NOT NULL ,
    TagID            INTEGER NOT NULL
  ) ;
ALTER TABLE TechnologyDataTags ADD CONSTRAINT TechnologyDataTag_PK PRIMARY KEY
( TechnologyDataID, TagID ) ;

CREATE
  TABLE Transactions
  (
    TransactionID    INTEGER NOT NULL ,
    TransactionUUID  UUID,
    BuyerID          INTEGER NOT NULL ,
    OfferID          INTEGER NOT NULL ,
    OfferRequestID   INTEGER NOT NULL ,
    PaymentInvoiceID INTEGER NOT NULL ,
    LicenseOrderID   INTEGER NOT NULL ,
    CreatedAt        timestamp with time zone
  ) ;
ALTER TABLE Transactions ADD CONSTRAINT Transactions_PK PRIMARY KEY (
TransactionID ) ;

CREATE
  TABLE Users
  (
    UserID        INTEGER NOT NULL ,
    UserUUID      UUID ,
    UserFirstName VARCHAR (250) NOT NULL ,
    UserLastName  VARCHAR (250) NOT NULL ,
    UserEmail     VARCHAR (250) NOT NULL ,
    CreatedAt     timestamp with time zone NOT NULL ,
    UpdatedAt     timestamp with time zone
  ) ;
ALTER TABLE Users ADD CONSTRAINT Users_PK PRIMARY KEY ( UserID ) ;
ALTER TABLE Users ADD CONSTRAINT Users__UN UNIQUE ( UserEmail ) ;

ALTER TABLE Attributes ADD CONSTRAINT Attribubes_Users_FK FOREIGN KEY (
CreatedBy ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;

ALTER TABLE ComponentsAttribute ADD CONSTRAINT
ComponentsAttribute_Attribubes_FK FOREIGN KEY ( AttributeID ) REFERENCES
Attributes ( AttributeID ) ON
DELETE
  NO ACTION;

ALTER TABLE ComponentsAttribute ADD CONSTRAINT
ComponentsAttribute_Components_FK FOREIGN KEY ( ComponentID ) REFERENCES
Components ( ComponentID ) ON
DELETE
  NO ACTION;

ALTER TABLE ComponentsTechnologies ADD CONSTRAINT
ComponentsTechnologies_Components_FK FOREIGN KEY ( ComponentID ) REFERENCES
Components ( ComponentID ) ON
DELETE
  NO ACTION;

ALTER TABLE ComponentsTechnologies ADD CONSTRAINT
ComponentsTechnologies_Technologies_FK FOREIGN KEY ( TechnologyID ) REFERENCES
Technologies ( TechnologyID ) ON
DELETE
  NO ACTION;

ALTER TABLE Components ADD CONSTRAINT Components_Components_FK FOREIGN KEY (
ComponentParentID ) REFERENCES Components ( ComponentID ) ON
DELETE
  NO ACTION;

ALTER TABLE Components ADD CONSTRAINT Components_Users_FK FOREIGN KEY (
CreatedBy ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;

ALTER TABLE LicenseOrder ADD CONSTRAINT LicenseOrder_Offer_FK FOREIGN KEY (
OfferID ) REFERENCES Offer ( OfferID ) ON
DELETE
  NO ACTION;

ALTER TABLE OfferRequest ADD CONSTRAINT OfferRequest_TechnologyData_FK FOREIGN
KEY ( TechnologyDataID ) REFERENCES TechnologyData ( TechnologyDataID ) ON
DELETE
  NO ACTION;

ALTER TABLE OfferRequest ADD CONSTRAINT OfferRequest_Users_FK FOREIGN KEY (
RequestedBy ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;

ALTER TABLE Offer ADD CONSTRAINT Offer_OfferRequest_FK FOREIGN KEY (
OfferRequestID ) REFERENCES OfferRequest ( OfferRequestID ) ON
DELETE
  NO ACTION;

ALTER TABLE Offer ADD CONSTRAINT Offer_Payment_FK FOREIGN KEY (
PaymentInvoiceID ) REFERENCES Payment ( PaymentInvoiceID ) ON
DELETE
  NO ACTION;

ALTER TABLE Tags ADD CONSTRAINT Tags_Users_FK FOREIGN KEY ( CreatedBy )
REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;

ALTER TABLE Technologies ADD CONSTRAINT Technologies_Users_FK FOREIGN KEY (
CreatedBy ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;

ALTER TABLE TechnologyDataComponents ADD CONSTRAINT
TechnologyDataComponents_Components_FK FOREIGN KEY ( ComponentID ) REFERENCES
Components ( ComponentID ) ON
DELETE
  NO ACTION;

ALTER TABLE TechnologyDataComponents ADD CONSTRAINT
TechnologyDataComponents_TechnologyData_FK FOREIGN KEY ( TechnologyDataID )
REFERENCES TechnologyData ( TechnologyDataID ) ON
DELETE
  NO ACTION;

ALTER TABLE TechnologyDataTags ADD CONSTRAINT TechnologyDataTags_Tags_FK
FOREIGN KEY ( TagID ) REFERENCES Tags ( TagID ) ON
DELETE
  NO ACTION;

ALTER TABLE TechnologyDataTags ADD CONSTRAINT
TechnologyDataTags_TechnologyData_FK FOREIGN KEY ( TechnologyDataID )
REFERENCES TechnologyData ( TechnologyDataID ) ON
DELETE
  NO ACTION;

ALTER TABLE TechnologyData ADD CONSTRAINT TechnologyData_Technologies_FK
FOREIGN KEY ( TechnologyID ) REFERENCES Technologies ( TechnologyID ) ON
DELETE
  NO ACTION;

ALTER TABLE TechnologyData ADD CONSTRAINT TechnologyData_Users_FK FOREIGN KEY (
CreatedBy ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_LicenseOrder_FK FOREIGN
KEY ( LicenseOrderID ) REFERENCES LicenseOrder ( LicenseOrderID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_OfferRequest_FK FOREIGN
KEY ( OfferRequestID ) REFERENCES OfferRequest ( OfferRequestID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_Offer_FK FOREIGN KEY (
OfferID ) REFERENCES Offer ( OfferID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_Payment_FK FOREIGN KEY (
PaymentInvoiceID ) REFERENCES Payment ( PaymentInvoiceID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_Users_FK FOREIGN KEY (
BuyerID ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;


-- Zusammenfassungsbericht für Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            16
-- CREATE INDEX                             0
-- ALTER TABLE                             46
-- CREATE VIEW                              0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE STRUCTURED TYPE                   0
-- CREATE ALIAS                             0
-- CREATE BUFFERPOOL                        0
-- CREATE DATABASE                          0
-- CREATE DISTINCT TYPE                     0
-- CREATE INSTANCE                          0
-- CREATE DATABASE PARTITION GROUP          0
-- CREATE SCHEMA                            0
-- CREATE SEQUENCE                          0
-- CREATE TABLESPACE                        0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0


-- ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-07
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
-- ##########################################################################
-- Create Functions
-- CreateLog
CREATE FUNCTION CreateLog(LogMessage varchar(32672), LogObjectName varchar(250), Parameters varchar(32672))
  RETURNS VOID AS
  $$      
      DECLARE LogID integer:= (select nextval('LogID'));
      BEGIN        
        INSERT INTO LogTable(LogID, LogMessage, LogObjectName, Parameters,CreatedAt)
        VALUES(LogID, LogMessage, LogObjectName, Parameters, now());                
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
        perform public.createlog('Created User sucessfully', 'CreateUser', 
                                'UserID: ' || cast(UserID as varchar) || ', UserFirstName: ' 
                                || UserFirstName || ', UserLastName: ' || UserLastName 
                                || ', ' 
                                || UserEmail);
                                
        -- End Log if success
        -- Return UserID
        RETURN UserID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateUser', 
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
        perform public.createlog('Created TechnologyData sucessfully', 'CreateTechnologyData', 
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
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTechnologyData', 
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
        perform public.createlog('Created Tag sucessfully', 'CreateTag', 
                                'TagID: ' || cast(TagID as varchar) || ', TagName: ' 
                                || TagName);
                                
        -- End Log if success
        -- Return UserID
        RETURN TagID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTag', 
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
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE 	AttributeID integer := (select nextval('AttributeID'));
		AttributeUUID uuid := (select uuid_generate_v4());
      BEGIN        
        INSERT INTO public.Attributes(AttributeID, AttributeUUID, AttributeName, CreatedBy, CreatedAt)
        VALUES(AttributeID, AttributeUUID, AttributeName, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog('Created Attribute sucessfully', 'CreateAttribute', 
                                'AttributeID: ' || cast(AttributeID as varchar) || ', AttributeName: ' 
                                || AttributeName);
                                
        -- End Log if success
        -- Return UserID
        RETURN AttributeID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'CreateAttribute', 
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
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE 	ComponentID integer := (select nextval('ComponentID'));
		ComponentUUID uuid := (select uuid_generate_v4());
      BEGIN        
        INSERT INTO components(ComponentID, ComponentUUID, ComponentParentID, ComponentName, ComponentDescription, CreatedBy, CreatedAt)
        VALUES(ComponentID, ComponentUUID, ComponentParentID, ComponentName, ComponentDescription, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog('Created Component sucessfully', 'CreateComponent', 
                                'ComponentID: ' || cast(ComponentID as varchar) || ', '  
                                || 'ComponentParentID: ' || cast(ComponentParentID as varchar) 
                                || ', ComponentName: ' 
                                || ComponentName 
                                || ', ComponentDescription: ' 
                                || ComponentDescription 
                                || ', CreatedBy: ' 
                                || cast(CreatedBy as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN ComponentID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponent', 
                                'ComponentID: ' || cast(ComponentID as varchar) || ', '  
                                || 'ComponentParentID: ' || cast(ComponentParentID as varchar) 
                                || ', ComponentName: ' 
                                || ComponentName 
                                || ', ComponentDescription: ' 
                                || ComponentDescription
                                || ', CreatedBy: ' 
                                || cast(CreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateTechnologies
CREATE FUNCTION CreateTechnology (
  TechnologyName varchar(250), 
  TechnologyDescription varchar(32672),
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE 	TechnologyID integer := (select nextval('TechnologyID'));
		TechnologyUUID uuid := (select uuid_generate_v4());
      BEGIN        
        INSERT INTO Technologies(TechnologyID, TechnologyUUID, TechnologyName, TechnologyDescription, CreatedBy, CreatedAt)
        VALUES(TechnologyID, TechnologyUUID, TechnologyName, TechnologyDescription, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog('Created Technology sucessfully', 'CreateTechnology', 
                                'TechnologyID: ' || cast(TechnologyID as varchar) 
                                || ', TechnologyName: ' 
                                || TechnologyName 
                                || ', TechnologyDescription: ' 
                                || TechnologyDescription 
                                || ', CreatedBy: ' 
                                || cast(CreatedBy as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN TechnologyID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTechnology', 
                                'TechnologyID: ' || cast(TechnologyID as varchar) 
                                || ', TechnologyName: ' 
                                || TechnologyName 
                                || ', TechnologyDescription: ' 
                                || TechnologyDescription 
                                || ', CreatedBy: ' 
                                || cast(CreatedBy as varchar));
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################    
-- CreateTechnologyDataComponents
CREATE FUNCTION CreateTechnologyDataComponents (
  TechnologyDataID integer, 
  ComponentList int[]
 )
  RETURNS INTEGER AS
  $$    
  	DECLARE compID integer;
      BEGIN     
         FOREACH compID in array ComponentList 
        LOOP 
         	 INSERT INTO TechnologyDataComponents(technologydataid, componentid)
             VALUES (technologydataid, compID);
        END LOOP; 
     
        -- Begin Log if success
        perform public.createlog('Created relation from Componets to TechnologyData sucessfully', 'CreateTechnologyDataComponents', 
                                'TechnologyDataID: ' || cast(TechnologyDataID as varchar)
                                || ', ComponentList: ' 
                                || cast(ComponentList as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN TechnologyDataID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTechnologyDataComponents', 
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
        perform public.createlog('Created relation from Tags to TechnologyData sucessfully', 'CreateTechnologyDataTags', 
                                'TechnologyDataID: ' || cast(TechnologyDataID as varchar)
                                || ', TagList: ' 
                                || cast(TagList as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN TechnologyDataID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE || cast(tagID as varchar), 'CreateTechnologyDataTags', 
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
        perform public.createlog('Created relation from component to attributes sucessfully', 'CreateComponentsAttribute', 
                                'ComponentID: ' || cast(ComponentID as varchar)
                                || ', AttributeList: ' 
                                || cast(AttributeList as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN ComponentID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponentsAttribute', 
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
  TechnologyList int[]
 )
  RETURNS INTEGER AS
  $$    
    DECLARE vTechID int;
      BEGIN     
         FOREACH vTechID in array TechnologyList          	
        LOOP 
         	 INSERT INTO ComponentsTechnologies(ComponentID, TechnologyID)
             VALUES (ComponentID, vTechID);
        END LOOP; 
     
        -- Begin Log if success
        perform public.createlog('Created relation from component to attributes sucessfully', 'CreateComponentsTechnologies', 
                                'ComponentID: ' || cast(ComponentID as varchar)
                                || ', TechnologyList: ' 
                                || cast(TechnologyList as varchar));
                                
        -- End Log if success
        -- Return UserID
        RETURN ComponentID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponentsTechnologies', 
                                'ComponentID: ' || cast(ComponentID as varchar)
                                || ', TechnologyList: ' 
                                || cast(TechnologyList as varchar));
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
  ComponentName varchar(250), 
  ComponentParentID integer, 
  ComponentDescription varchar(32672),
  AttributeList text[], 
  TechnologyList int[],
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$    
      DECLARE vAttributeName text; 
      DECLARE vTechID integer;
      DECLARE vCompID integer;
      BEGIN      
        -- Proof if all technologies are avaiable
        -- Proof if all components are avaiable      
        FOREACH vTechID in array TechnologyList 
        LOOP 
         	 if not exists (select technologyid from technologies where technologyid = vTechID) then
                 raise exception using
                 errcode = 'invalid_parameter_value',
                 message = 'There is no technology with TechnologyID: ' || vTechID::text; 
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
        vCompID := (select public.createcomponent(componentparentid,componentname, componentdescription, createdby));    
        
        -- Create relation from Components to TechnologyData 
        perform public.CreateComponentsAttribute(vCompID, AttributeList);  
        
        -- Create relation from Components to TechnologyData 
        perform public.CreateComponentsTechnologies(vCompID, TechnologyList); 
     	
        -- Begin Log if success
        perform public.createlog('Set Component sucessfully', 'SetComponent', 
                                'ComponentID: ' || cast(vCompID as varchar) || ', componentname: ' 
                                || componentname || ', componentdescription: ' || componentdescription 
                                || ', CreatedBy: ' || CreatedBy);
                                
        -- End Log if success
        -- Return UserID
        RETURN vCompID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE,'SetComponent', 
                                'ComponentID: ' || cast(vCompID as varchar) || ', componentname: ' 
                                || componentname || ', componentdescription: ' || componentdescription 
                                || ', CreatedBy: ' || CreatedBy);
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
-- SetTechnologyData
CREATE FUNCTION SetTechnologyData (
  TechnologyDataName varchar(250), 
  TechnologyData varchar(32672), 
  TechnologyDataDescription varchar(32672),
  vTechnologyID integer,
  LicenseFee decimal(21,4),
  TagList text[],  
  CreatedBy integer,
  ComponentList int[]
 )
  RETURNS INTEGER AS
  $$    
      DECLARE compID integer;
      DECLARE vTagName text; 
      DECLARE vTechnologyDataID int;
      BEGIN        
        -- Proof if all components are avaiable      
        FOREACH compID in array componentlist 
        LOOP 
         	 if not exists (select componentid from components where componentid = compID) then
                 raise exception using
                 errcode = 'invalid_parameter_value',
                 message = 'There is no component with ComponentID: ' || compID::text; 
         	 end if;
        END LOOP;
        -- Proof if all Tags are avaiable     
        FOREACH vTagName in array TagList 
        LOOP 
         	 if not exists (select tagID from tags where tagname = vTagName) then
               perform public.createtag(vTagName,CreatedBy);
        	 end if;
        END LOOP;
        -- Proof if technology is avaiable  
        if not exists (select technologyid from technologies where technologyid = vTechnologyID) then
        	raise exception using
            errcode = 'invalid_parameter_value',
            message = 'There is no technology with TechnologyID: ' || vTechnologyID::text; 
        end if;
        
        -- Create new TechnologyData
        vTechnologyDataID := (select public.createtechnologydata(TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, vTechnologyID, CreatedBy));    
        
        -- Create relation from Components to TechnologyData 
        perform public.CreateTechnologyDataComponents(vTechnologyDataID, ComponentList);
        
        -- Create relation from Tags to TechnologyData 
        perform public.CreateTechnologyDataTags(vTechnologyDataID, TagList);
     	
        -- Begin Log if success
        perform public.createlog('Set TechnologyData sucessfully', 'SetTechnologyData', 
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || TechnologyDataName || ', TechnologyData: ' || TechnologyData 
                                || ', TechnologyDataDescription: ' || TechnologyDataDescription 
                                || ', CreatedBy: ' || CreatedBy);
                                
        -- End Log if success
        -- Return UserID
        RETURN vTechnologyDataID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'SetTechnologyData', 
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || TechnologyDataName || ', TechnologyData: ' || TechnologyData 
                                || ', TechnologyDataDescription: ' || TechnologyDataDescription 
                                || ', CreatedBy: ' || CreatedBy);
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
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
/* TODO
##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-16
-- Description: Script to get all Technologies
-- ##########################################################################
Get all Technologies
Input paramteres: none	
Return Value: Table with all Technologies
######################################################
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
    
    $$ LANGUAGE SQL;*/
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

-- ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-07
-- Description: Create Base Data for the MarketplaceCode Database
-- Changes:
-- ##########################################################################
-- Insert System User
DO
 $$
    DECLARE vUserID int; 
	BEGIN
    	-- Just in case. set all sequences to start point
        ALTER SEQUENCE userid RESTART WITH 1;
        ALTER SEQUENCE componentid RESTART WITH 1;
        ALTER SEQUENCE technologyid RESTART WITH 1;
        ALTER SEQUENCE technologydataid RESTART WITH 1;
        ALTER SEQUENCE tagid RESTART WITH 1;
        ALTER SEQUENCE attributeid RESTART WITH 1;
    	-- Create System User
        perform public.createuser(
            'System', 		-- <UserFirstName>
            'Admin', 		-- <UserLastName>
            'system@admin.com' -- <EmailAddress>
        );
        -- Create Technologies
            -- Get UserID
            vUserID := (select max(userid) from users);            
        perform public.createtechnology(
            'Juice Mixer',			-- <technologyname character varying>, 
            'Machine to mix juice',	-- <technologydescription character varying>, 
            vUserID 				-- <createdby integer>
        );
        -- Create Components & Attributes
        perform public.setcomponent(
            'Root',   			-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Root component', 	-- <componentdescription character varying>, 
            '{Root}',			-- <attributelist text[]>, 
            '{1}',  				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Orange
        perform public.setcomponent(
            'Orange Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Orange Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Apple
        perform public.setcomponent(
            'Apple Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Apple Juice',  	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Cola
        perform public.setcomponent(
            'Cola',				-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Cola',			 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
         -- Mango
        perform public.setcomponent(
            'Mango Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Mango Juice', 		-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Ginger
        perform public.setcomponent(
            'Ginger Sirup',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Ginger Sirup', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Banana
        perform public.setcomponent(
            'Banana Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Banana Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
         -- Cherry
        perform public.setcomponent(
            'Cherry Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Cherry Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
   END;
 $$;
 
-- select * from components;
 
DO 
$$
  BEGIN
  		-- Create TechnologyData      
        -- Cherry with Mango
        perform public.settechnologydata(
            'CheMa',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Cherry with Mango', 				 -- <technologydatadescription character varying>, 
            1,    								 -- <vtechnologyid integer>, 
            4.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Cherry, Mango, Yummy}', -- <taglist text[]>, 
            1,    						 		 -- <createdby integer>, 
            '{5,8}'    							 -- <componentlist integer[]>
         );
         -- Cherry with Cola
        perform public.settechnologydata(
            'CheCo',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Cherry with Mango', 				 -- <technologydatadescription character varying>, 
            1,    								 -- <vtechnologyid integer>, 
            1.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Cherry, Cola, Refreshing}', -- <taglist text[]>, 
            1,    						 -- <createdby integer>, 
            '{5,8}'    								 -- <componentlist integer[]>
         );
          -- Ginger, Orange
        perform public.settechnologydata(
            'Ginge',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Orange with Ginger', 				 -- <technologydatadescription character varying>, 
            1,    								 -- <vtechnologyid integer>, 
            2.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Ginger, Orange}', -- <taglist text[]>, 
            1,    						 -- <createdby integer>, 
            '{2,6}'    								 -- <componentlist integer[]>
         );
         -- Banana, Mango, Orange
        perform public.settechnologydata(
            'Bamao',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Delicious Banana, Mango, Orange juice', 				 -- <technologydatadescription character varying>, 
            1,    								 -- <vtechnologyid integer>, 
            3.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Banana, Orange, Mango, Tasty}', -- <taglist text[]>, 
            1,    						 -- <createdby integer>, 
            '{2,5,7}'    								 -- <componentlist integer[]>
         );
	END;
$$