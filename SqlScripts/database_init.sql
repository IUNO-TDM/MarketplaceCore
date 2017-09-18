-- Generiert von Oracle SQL Developer Data Modeler 4.0.3.853
--   am/um:        2017-07-14 11:28:05 MESZ
--   Site:      DB2/UDB 8.1
--   Typ:      DB2/UDB 8.1

CREATE
  TABLE Attributes
  (
    AttributeID   INTEGER NOT NULL ,
    AttributeUUID UUID ,
    AttributeName VARCHAR (250) NOT NULL ,
    CreatedAt     TIMESTAMP WITHOUT TIME ZONE NOT NULL ,
    CreatedBy     UUID NOT NULL ,
    UpdatedAt     TIMESTAMP WITHOUT TIME ZONE ,
    UpdatedBy     UUID
  ) ;
ALTER TABLE Attributes ADD CONSTRAINT Attribubes_PK PRIMARY KEY ( AttributeID )
;
ALTER TABLE Attributes ADD CONSTRAINT Attributes__UN UNIQUE ( AttributeName ) ;

CREATE
  TABLE Components
  (
    ComponentID          INTEGER NOT NULL ,
    ComponentUUID        UUID ,
    ComponentName        VARCHAR (250) ,
    ComponentParentID    INTEGER ,
    ComponentDescription VARCHAR (32672) ,
    CreatedAt            TIMESTAMP WITHOUT TIME ZONE NOT NULL ,
    CreatedBy            UUID NOT NULL ,
    UpdatedAt            TIMESTAMP WITHOUT TIME ZONE ,
    UpdatedBy            UUID
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
    LicenseOrderUUID UUID ,
    TicketID         VARCHAR (32672) ,
    OfferID          INTEGER NOT NULL ,
    ActivatedAt      TIMESTAMP WITHOUT TIME ZONE ,
    CreatedAt        TIMESTAMP WITHOUT TIME ZONE NOT NULL ,
    CreatedBy        UUID NOT NULL
  ) ;
ALTER TABLE LicenseOrder ADD CONSTRAINT LicenseOrder_PK PRIMARY KEY (
LicenseOrderID ) ;

CREATE
  TABLE LogStatus
  (
    LogStatusID          INTEGER NOT NULL ,
    LogStatus            VARCHAR (50) ,
    LogStatusDescription VARCHAR (250)
  ) ;
ALTER TABLE LogStatus ADD CONSTRAINT LogStatus_PK PRIMARY KEY ( LogStatusID ) ;

CREATE
  TABLE LogTable
  (
    LogID         INTEGER NOT NULL ,
    LogStatusID   INTEGER NOT NULL ,
    LogMessage    VARCHAR (32672) NOT NULL ,
    LogObjectName VARCHAR (250) ,
    Parameters    VARCHAR (32672) ,
    CreatedAt     TIMESTAMP WITHOUT TIME ZONE NOT NULL
  ) ;
ALTER TABLE LogTable ADD CONSTRAINT LogTable_PK PRIMARY KEY ( LogID ) ;

INSERT INTO LogStatus VALUES (0,'Sucessed','Operation has successed');
INSERT INTO LogStatus VALUES (1,'ERROR','Operation has failed');
INSERT INTO LogStatus VALUES (2,'PENDING','Operation is pending');

CREATE
  TABLE Offer
  (
    OfferID          INTEGER NOT NULL ,
    OfferUUID        UUID ,
    PaymentInvoiceID INTEGER NOT NULL ,
    CreatedAt        TIMESTAMP WITHOUT TIME ZONE ,
    CreatedBy        UUID NOT NULL
  ) ;
ALTER TABLE Offer ADD CONSTRAINT Offer_PK PRIMARY KEY ( OfferID ) ;

CREATE
  TABLE OfferRequest
  (
    OfferRequestID   INTEGER NOT NULL ,
    OfferRequestUUID UUID ,
    HSMID            VARCHAR ,
    CreatedAt        TIMESTAMP WITHOUT TIME ZONE ,
    RequestedBy      UUID NOT NULL
  ) ;
ALTER TABLE OfferRequest ADD CONSTRAINT OfferRequest_PK PRIMARY KEY (
OfferRequestID ) ;

CREATE TABLE OfferRequestItems
  (
    OfferRequestItemID INTEGER NOT NULL ,
    OfferRequestID     INTEGER,
    TechnologyDataID	INTEGER,
    Amount INTEGER NOT NULL
  ) ;


CREATE
  TABLE Payment
  (
    PaymentID          INTEGER NOT NULL ,
    PaymentUUID        UUID ,
    PaymentInvoiceID   INTEGER NOT NULL ,
    PayDate            TIMESTAMP WITHOUT TIME ZONE ,
    ConfidenceState    VARCHAR (250) ,
    Depth              INTEGER ,
    BitcoinTransaction VARCHAR (32672) ,
    ExtInvoiceID       UUID ,
    CreatedAt          TIMESTAMP WITHOUT TIME ZONE ,
    CreatedBy          UUID NOT NULL ,
    UpdatedBy          UUID ,
    UpdatedAt          TIMESTAMP WITHOUT TIME ZONE
  ) ;
ALTER TABLE Payment ADD CONSTRAINT Payment_PK PRIMARY KEY ( PaymentID ) ;

CREATE
  TABLE PaymentInvoice
  (
    PaymentInvoiceID   INTEGER NOT NULL ,
    PaymentInvoiceUUID UUID ,
    OfferRequestID     INTEGER NOT NULL ,
    Invoice            VARCHAR (32672) ,
    CreatedAt          TIMESTAMP WITHOUT TIME ZONE ,
    CreatedBy          UUID NOT NULL
  ) ;
ALTER TABLE PaymentInvoice ADD CONSTRAINT PaymentInvoice_PK PRIMARY KEY (
PaymentInvoiceID ) ;

CREATE
  TABLE Tags
  (
    TagID     INTEGER NOT NULL ,
    TagUUID   UUID ,
    TagName   VARCHAR (250) NOT NULL ,
    CreatedAt TIMESTAMP WITHOUT TIME ZONE NOT NULL ,
    CreatedBy UUID NOT NULL ,
    UpdatedAt TIMESTAMP WITHOUT TIME ZONE ,
    UpdatedBy UUID
  ) ;
ALTER TABLE Tags ADD CONSTRAINT Tags_PK PRIMARY KEY ( TagID ) ;

CREATE
  TABLE Technologies
  (
    TechnologyID          INTEGER NOT NULL ,
    TechnologyUUID        UUID ,
    TechnologyName        VARCHAR (250) NOT NULL ,
    TechnologyDescription VARCHAR (32672) ,
    CreatedAt             TIMESTAMP WITHOUT TIME ZONE NOT NULL ,
    CreatedBy             UUID NOT NULL ,
    UpdatedAt             TIMESTAMP WITHOUT TIME ZONE ,
    UpdatedBy             UUID
  ) ;
ALTER TABLE Technologies ADD CONSTRAINT Technologies_PK PRIMARY KEY (
TechnologyID ) ;
ALTER TABLE Technologies ADD CONSTRAINT Technologies__UN UNIQUE (
TechnologyName ) ;

CREATE
  TABLE TechnologyData
  (
    TechnologyDataID          INTEGER NOT NULL ,
    TechnologyDataUUID        UUID ,
    TechnologyDataName        VARCHAR (250) NOT NULL ,
    TechnologyID              INTEGER NOT NULL ,
    TechnologyData            VARCHAR (32672) NOT NULL ,
    LicenseFee                INTEGER NOT NULL ,
    ProductCode               INTEGER ,
    TechnologyDataDescription VARCHAR (32672) ,
    TechnologyDataThumbnail Bytea ,
    TechnologyDataImgRef VARCHAR ,
    CreatedAt            TIMESTAMP WITHOUT TIME ZONE NOT NULL ,
    CreatedBy            UUID NOT NULL ,
    UpdatedAt            TIMESTAMP WITHOUT TIME ZONE ,
    UpdatedBy            UUID,
    Deleted              BOOLEAN
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
    TransactionUUID  UUID ,
    BuyerID          UUID,
    OfferID          INTEGER ,
    OfferRequestID   INTEGER NOT NULL ,
    PaymentID        INTEGER ,
    PaymentInvoiceID INTEGER ,
    LicenseOrderID   INTEGER ,
    CreatedAt        TIMESTAMP WITHOUT TIME ZONE ,
    CreatedBy        UUID NOT NULL ,
    UpdatedAt        TIMESTAMP WITHOUT TIME ZONE ,
    UpdatedBy        UUID
  ) ;
ALTER TABLE Transactions ADD CONSTRAINT Transactions_PK PRIMARY KEY (
TransactionID ) ;

CREATE
  TABLE Functions
  (
    FunctionID   INTEGER NOT NULL ,
    FunctionName VARCHAR (250)
  ) ;
ALTER TABLE Functions ADD CONSTRAINT Functions_PK PRIMARY KEY ( FunctionID ) ;

CREATE
  TABLE Roles
  (
    RoleId           INTEGER NOT NULL ,
    RoleName         VARCHAR ,
    RoleDescription VARCHAR
  ) ;

ALTER TABLE Roles ADD CONSTRAINT Roles_PK PRIMARY KEY ( RoleId ) ;

CREATE
  TABLE RolesPermissions
  (
    RoleId     INTEGER NOT NULL ,
    FunctionId INTEGER NOT NULL
  ) ;

ALTER TABLE RolesPermissions ADD CONSTRAINT RolesPermissions_PK PRIMARY KEY (
RoleId, FunctionId ) ;

ALTER TABLE RolesPermissions ADD CONSTRAINT RolesPermissions_Functions_FK

FOREIGN KEY ( FunctionId ) REFERENCES Functions ( FunctionID ) ON
DELETE
  NO ACTION;

ALTER TABLE RolesPermissions ADD CONSTRAINT RolesPermissions_Roles_FK FOREIGN
KEY ( RoleId ) REFERENCES Roles ( RoleId ) ON
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

ALTER TABLE LicenseOrder ADD CONSTRAINT LicenseOrder_Offer_FK FOREIGN KEY (
OfferID ) REFERENCES Offer ( OfferID ) ON
DELETE
  NO ACTION;

ALTER TABLE LogTable ADD CONSTRAINT LogTable_LogStatus_FK FOREIGN KEY (
LogStatusID ) REFERENCES LogStatus ( LogStatusID ) ON
DELETE
  NO ACTION;

ALTER TABLE OfferRequestItems ADD CONSTRAINT OfferRequestItems_OfferRequest_FK
FOREIGN KEY ( OfferRequestID ) REFERENCES OfferRequest ( OfferRequestID ) ON
DELETE
  NO ACTION;

ALTER TABLE OfferRequestItems ADD CONSTRAINT
OfferRequestItems_TechnologyData_FK FOREIGN KEY ( TechnologyDataID ) REFERENCES
TechnologyData ( TechnologyDataID ) ON
DELETE
  NO ACTION;

ALTER TABLE Offer ADD CONSTRAINT Offer_PaymentInvoice_FK FOREIGN KEY (
PaymentInvoiceID ) REFERENCES PaymentInvoice ( PaymentInvoiceID ) ON
DELETE
  NO ACTION;

ALTER TABLE PaymentInvoice ADD CONSTRAINT PaymentInvoice_OfferRequest_FK
FOREIGN KEY ( OfferRequestID ) REFERENCES OfferRequest ( OfferRequestID ) ON
DELETE
  NO ACTION;

ALTER TABLE Payment ADD CONSTRAINT Payment_PaymentInvoice_FK FOREIGN KEY (
PaymentInvoiceID ) REFERENCES PaymentInvoice ( PaymentInvoiceID ) ON
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

ALTER TABLE Transactions ADD CONSTRAINT Transactions_PaymentInvoice_FK FOREIGN
KEY ( PaymentInvoiceID ) REFERENCES PaymentInvoice ( PaymentInvoiceID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_Payment_FK FOREIGN KEY (
PaymentID ) REFERENCES Payment ( PaymentID ) ON
DELETE
  NO ACTION;

ALTER TABLE OfferRequestItems ADD CONSTRAINT OfferRequestItems_PK PRIMARY KEY ( OfferRequestItemID, OfferRequestID, TechnologyDataID ) ;


-- Zusammenfassungsbericht für Oracle SQL Developer Data Modeler:
--
-- CREATE TABLE                            19
-- CREATE INDEX                             0
-- ALTER TABLE                             45
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


-- Create LogUser
DO
$$
BEGIN
	IF ((SELECT 1 FROM pg_roles WHERE rolname='core_loguser') is null) THEN
	CREATE USER core_loguser WITH PASSWORD 'PASSWORD';  -- PUT YOUR PWD HERE
	END IF;
	CREATE FOREIGN DATA WRAPPER core_fwd VALIDATOR postgresql_fdw_validator;
	CREATE SERVER core FOREIGN DATA WRAPPER core_fwd OPTIONS (hostaddr '127.0.0.1', dbname 'MarketplaceCore'); -- PUT YOUR DATABASENAME HERE
	CREATE USER MAPPING FOR core_loguser SERVER core OPTIONS (user 'core_loguser', password 'PASSWORD'); -- PUT YOUR PWD HERE
	GRANT USAGE ON FOREIGN SERVER core TO core_loguser;
	GRANT INSERT ON TABLE logtable TO core_loguser;
END;
$$;
COMMIT;

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
-- ProductID
CREATE SEQUENCE ProductCode START 1000;
-- ##########################################################################
-- Create Indexes
--CREATE UNIQUE INDEX invoice_idx ON paymentinvoice (invoice);
-- There is a problem in PostgreSql see: https://hcmc.uvic.ca/blogs/index.php?blog=22&p=8105&more=1&c=1&tb=1&pb=1
-- Indexes and sequences may run out of sync
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
		 vConnString text := 'dbname=MarketplaceCore port=5432 host=localhost user=core_loguser password=PASSWORD';
	      vConnExist bool := (select ('{' || vConnName || '}')::text[] <@ (select dblink_get_connections()));
      BEGIN

		if(not vConnExist or vConnExist is null) then
				perform dblink_connect(vConnName,vConnString);
		end if;
				perform dblink(vConnName,vSqlCmd);
				perform dblink_disconnect(vConnName);
				set role postgres;
      END;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
-- ##############################################################################
CREATE FUNCTION CreateTechnologyData (
	  vTechnologyDataName varchar(250),
	  vTechnologyData varchar(32672),
	  vTechnologyDataDescription varchar(32672),
	  vLicenseFee integer,
	  vProductCode integer,
	  vTechnologyUUID uuid,
	  vCreatedBy uuid,
	  vRoles text[]
 )
  RETURNS TABLE (
	TechnologyDataUUID uuid,
	TechnologyDataName varchar(250),
	TechnologyUUID uuid,
	TechnologyData varchar(32672),
	ProductCode integer,
	LicenseFee integer,
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

      BEGIN
	IF(vIsAllowed) then
		INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, ProductCode, TechnologyID, CreatedBy, CreatedAt)
        VALUES(vTechnologyDataID, vTechnologyDataUUID, vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, vTechnologyID, vCreatedBy, now());
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
                                || ', ProductCode: ' || cast(vProductCode as varchar)
                                || ', CreatedBy: ' || vCreatedBy);

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	td.TechnologyDataUUID,
			td.TechnologyDataName,
			tc.TechnologyUUID,
			td.TechnologyData,
			td.LicenseFee,
			td.ProductCode,
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
                                || ', ProductCode: ' || cast(vProductCode as varchar)
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
  vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
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
  vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
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
  vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
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
CREATE FUNCTION CreateComponent (
  vComponentParentUUID uuid,
  vComponentName varchar(250),
  vComponentDescription varchar(250),
  vCreatedBy uuid,
  vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
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
    vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
  vRoles text[]
 )
  RETURNS TABLE (
	TechnologyDataUUID uuid,
	ComponentList uuid[]
  ) AS
  $$
	#variable_conflict use_column
  	DECLARE vCompUUID uuid;
		vCompID integer;
		vTechnologyDataID integer := (select technologydataid from technologydata where technologydatauuid = vTechnologyDataUUID);
		vFunctionName varchar := 'CreateTechnologyDataComponents';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
  $$
  LANGUAGE 'plpgsql';
-- ##############################################################################
-- CreateComponentsTechnologies
CREATE FUNCTION CreateComponentsTechnologies (
  vComponentUUID uuid,
  vTechnologyList text[],
  vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION public.createofferrequest(
    IN vitems jsonb,
    IN vhsmid character varying,
    IN vuseruuid uuid,
    IN vbuyeruuid uuid,
    IN vRoles text[])
  RETURNS table(result json) AS
$BODY$
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
CREATE FUNCTION public.createpaymentinvoice(
    IN vinvoice character varying,
    IN vofferrequestuuid uuid,
    IN vuseruuid uuid,
    IN vRoles text[])
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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
-- ##############################################################################
-- CreateOffer
CREATE FUNCTION public.createoffer(
    IN vpaymentinvoiceuuid uuid,
    IN vuseruuid uuid,
    IN vRoles text[])
  RETURNS TABLE(offeruuid uuid, paymentinvoiceuuid uuid, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vOfferID integer := (select nextval('OfferID'));
		vOfferUUID uuid := (select uuid_generate_v4());
		vPaymentInvoiceID integer := (select paymentinvoiceid from paymentinvoice where paymentinvoiceuuid = vPaymentInvoiceUUID);
		vTransactionID integer := (select transactionid from transactions where paymentinvoiceid = vPaymentInvoiceID);
		vFunctionName varchar := 'CreateOffer';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
-- ##############################################################################
-- CreateLicenseOrder
CREATE FUNCTION CreateLicenseOrder (
  vTicketID varchar(4000),
  vOfferUUID uuid,
  vUserUUID uuid,
  vRoles text[]
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
				vFunctionName varchar := 'CreateLicenseOrder';
				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
    IN vRoles text[])
  RETURNS TABLE(paymentuuid uuid, paymentinvoiceuuid uuid, paydate timestamp with time zone, bitcointransation character varying, confidencestate character varying, depth integer, extinvoiceid uuid, createdby uuid, createdat timestamp with time zone, updatedby uuid, updatedat timestamp with time zone) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vPaymentID integer;
		vPaymentUUID uuid := (select uuid_generate_v4());
		vPaymentInvoiceID integer := (select PaymentInvoiceID from transactions where transactionuuid = vTransactionUUID);
		vPayDate timestamp without time zone := null;
		vTransactionID integer := (select transactionid from transactions where transactionuuid = vtransactionuuid);
		vFunctionName varchar := 'SetPayment';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
-- ###########################################################################
-- CreateComponentsAttribute
CREATE FUNCTION CreateComponentsAttribute (
  vComponentUUID uuid,
  vAttributeList text[],
  vRoles text[]
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
		vFunctionName varchar := 'CreateComponentsAttribute';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
    IN vRoles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentname character varying, componentparentuuid uuid, componentdescription character varying, attributelist uuid[], technologylist uuid[], createdat timestamp with time zone, createdby uuid) AS
$$
	#variable_conflict use_column
      DECLARE 	vAttributeName text;
        	vTechName text;
		vCompID integer;
		vCompUUID uuid;
		vCompParentUUID uuid := (select case when (vComponentParentName = 'Root' and not exists (select 1 from components where componentName = 'Root')) then uuid_generate_v4() else componentuuid end from components where componentname = vComponentParentName);
		vFunctionName varchar := 'SetComponent';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
		       perform public.createattribute(vAttributeName,vCreatedBy, vRoles);
			 end if;
		END LOOP;

		-- Create new Component
		perform public.createcomponent(vCompParentUUID,vComponentName, vComponentdescription, vCreatedby, vRoles);
			vCompID := (select currval('ComponentID'));
			vCompUUID := (select componentuuid from components where componentID = vCompID);

		-- Create relation from Components to TechnologyData
		perform public.CreateComponentsAttribute(vCompUUID, vAttributeList, vRoles);

		-- Create relation from Components to TechnologyData
		perform public.CreateComponentsTechnologies(vCompUUID, vTechnologyList, vRoles);

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
CREATE OR REPLACE FUNCTION public.settechnologydata(
    IN vtechnologydataname character varying,
    IN vtechnologydata character varying,
    IN vtechnologydatadescription character varying,
    IN vtechnologyuuid uuid,
    IN vlicensefee integer,
    IN vproductcode integer,
    IN vtaglist text[],
    IN vcomponentlist text[],
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, licensefee integer, productcode integer, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, taglist uuid[], componentlist uuid[], createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vCompUUID uuid;
				vTagName text;
				vTechnologyDataID int;
				vTechnologyDataUUID uuid;
				vTechnologyID integer := (select technologyID from technologies where technologyUUID = vTechnologyUUID);
				vFunctionName varchar := 'SetTechnologyData';
				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
				vAlreadExists integer := (select 1 from technologydata where technologydataname = vtechnologydataname);

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
			perform public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, vTechnologyUUID, vCreatedBy, vRoles);
			vTechnologyDataID := (select currval('TechnologyDataID'));
			vTechnologyDataUUID := (select technologydatauuid from technologydata where technologydataid = vTechnologyDataID);

			RAISE NOTICE '%', vTechnologyDataID;
			-- Create relation from Components to TechnologyData
			perform public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList, vRoles);

			-- Create relation from Tags to TechnologyData
			IF (vTagList != null) THEN
				perform public.CreateTechnologyDataTags(vTechnologyDataUUID, vTagList, CreatedBy, vRoles);
			END IF;
		ELSE
			UPDATE technologydata set
				TechnologyData = vTechnologyData,
				TechnologyDataDescription = vTechnologyDataDescription,
				TechnologyID = vTechnologyID,
				LicenseFee = vLicenseFee,
				ProductCode = vProductCode,
				updatedby = vCreatedBy,
				updatedat = now(),
				deleted = null
			WHERE technologydataname = vtechnologydataname;

			vTechnologyDataID := (select technologydataid from technologydata where technologydataname = vtechnologydataname);
			vTechnologyDataUUID := (select technologydatauuid from technologydata where technologydataname = vtechnologydataname);

			--update tags  (delete and create it again)
			delete from technologydatatags where technologydataid = vTechnologyDataID;
			IF (vTagList != null) THEN
				perform public.CreateTechnologyDataTags(vTechnologyDataUUID, vTagList, CreatedBy, vRoles);
			END IF;
			--update components (delete and create it again)
			delete from technologydatacomponents where technologydataid = vTechnologyDataID;
			perform public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList, vRoles);
		END IF;
		-- Begin Log if success
		perform public.createlog(0,'Set TechnologyData sucessfully', 'SetTechnologyData',
					'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: '
					|| vTechnologyDataName || ', TechnologyData: ' || vTechnologyData
					|| ', TechnologyDataDescription: ' || vTechnologyDataDescription
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
                                || vTechnologyDataName || ', TechnologyData: ' || vTechnologyData
                                || ', TechnologyDataDescription: ' || vTechnologyDataDescription
                                || ', CreatedBy: ' || cast(vCreatedby as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetTechnologyData';
        RETURN;
      END;
  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
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
CREATE FUNCTION public.setpaymentinvoiceoffer(
    IN vofferrequestuuid uuid,
    IN vinvoice character varying,
    IN vcreatedby uuid,
    IN vRoles text[])
  RETURNS TABLE(paymentinvoiceuuid uuid, invoice character varying, offeruuid uuid, paymentcreatedat timestamp with time zone, paymentcreatedby uuid, offercreatedat timestamp with time zone, offercreatedby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE
		vPaymentInvoiceID integer;
		vPaymentInvoiceUUID uuid;
		vFunctionName varchar := 'SetPaymentInvoiceOffer';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
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
CREATE FUNCTION GetAllTechnologyData(vUserUUID uuid, vRoles text[])
	RETURNS TABLE
    	(
			technologydatauuid uuid,
			technologyuuid uuid,
			technologydataname varchar(250),
			technologydata varchar(32672),
			technologydatadescription varchar(32672),
			productcode integer,
			licensefee integer,
			technologydatathumbnail bytea,
			technologydataimgref varchar(4000),
			createdat timestamp with time zone,
			createdby uuid,
			updatedat timestamp with time zone,
			useruuid uuid
        )
    AS $$
	DECLARE vFunctionName varchar := 'GetAllTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
 CREATE FUNCTION public.gettechnologydatabyid(
    IN vtechnologydatauuid uuid,
    IN vuseruuid uuid,
    IN vRoles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee integer, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedyby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
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
		vRoles text[]
		)
RETURNS TABLE
    	(
			technologydatauuid uuid,
			technologyuuid uuid,
			technologydataname varchar(250),
			technologydata varchar(32672),
			technologydatadescription varchar(32672),
			productcode integer,
			licensefee integer,
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

    	RETURN QUERY (SELECT 	technologydatauuid,
				tc.technologyuuid,
				td.technologydataname,
				technologydata,
				technologydatadescription,
				productcode,
				licensefee,
				technologydatathumbnail,
				technologydataimgref,
				td.createdat  at time zone 'utc',
				td.createdby,
				td.updatedat  at time zone 'utc',
				td.updatedBy
			FROM TechnologyData td
			join technologies tc
			on td.technologyid = tc.technologyid
			where td.technologydataname = vTechnologyDataName
			and td.deleted is null
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
Input paramteres: vRoles
Return Value: Table with all Components
######################################################*/
CREATE OR REPLACE FUNCTION public.getallcomponents(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid integer, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetAllComponents';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;

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
    IN vRoles text[])
  RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentuuid uuid, componentdescription character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$$
	DECLARE
		vFunctionName varchar := 'GetComponentById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetComponentByName(vCompName varchar(250), vUserUUID uuid, vRoles text[])
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetAllTags(vUserUUID uuid, vRoles text[])
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
CREATE FUNCTION GetTagByID(vTagID uuid, vUserUUID uuid, vRoles text[])
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
CREATE FUNCTION GetTagByName(vTagName varchar(250), vUserUUID uuid, vRoles text[])
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
CREATE FUNCTION GetAllTechnologies(vUserUUID uuid, vRoles text[])
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetTechnologyByID(vtechUUID uuid, vUserUUID uuid, vRoles text[])
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
		vFunctionName varchar := 'GetTechnologyById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetTechnologyByName(vtechName varchar, vUserUUID uuid, vRoles text[])
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION public.gettechnologydatabyparams(
    IN vcomponents text[],
    IN vtechnologyuuid uuid,
    IN vtechnologydataname character varying,
    IN vOwnerUUID uuid,
    IN vUserUUID uuid,
    IN vRoles text[])
  RETURNS TABLE(result json) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByParams';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
					td.productcode,
					td.technologydatadescription,
					td.technologydatathumbnail,
					td.technologydataimgref,
					td.createdat at time zone 'utc',
					td.CreatedBy,
					td.updatedat at time zone 'utc',
					td.UpdatedBy,
					array_to_json(array_agg(co.*)) ComponentsWithAttribute
				from comp co join technologydatacomponents tc
				on co.componentid = tc.componentid
				join technologydata td on
				td.technologydataid = tc.technologydataid
				join components cm on cm.componentid = co.componentid
				join technologies tt on
				tt.technologyid = td.technologyid
				where (vOwnerUUID is null OR td.createdby = vOwnerUUID)
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
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
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
CREATE FUNCTION GetAllOffers(vUserUUID varchar, vRoles text[])
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetAllAttributes(vUserUUID uuid, vRoles text[])
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetAttributeByID(vAttrUUID uuid, vUserUUID uuid, vRoles text[])
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
		vFunctionName varchar := 'GetAttributeById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetAttributeByName(vAttrName varchar(250), vUserUUID uuid, vRoles text[])
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetOfferByRequestID(vRequestID uuid, vUserUUID uuid, vRoles text[])
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetOfferByID(vOfferID uuid, vUserUUID uuid, vRoles text[])
	RETURNS TABLE
    	(
    offeruuid uuid,
    paymentinvoiceuuid uuid,
    createdat timestamp with time zone,
    createdby uuid
        )
    AS $$

	DECLARE
		vFunctionName varchar := 'GetOfferById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
CREATE FUNCTION GetActivatedLicensesSince (vTime timestamp, vUserUUID uuid, vRoles text[])
RETURNS integer AS
$$
	DECLARE
		vFunctionName varchar := 'GetActivatedLicensesSince';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

		with activatedLincenses as(
			select * from licenseorder lo
			join offer of on lo.offerid = of.offerid
			join paymentinvoice pi on
			of.paymentinvoiceid = pi.paymentinvoiceid
			join offerrequest oq on
			pi.offerrequestid = oq.offerrequestid
			join offerrequestitems ri on
			oq.offerrequestid = ri.offerrequestid
			join technologydata td on
			ri.technologydataid = td.technologydataid
			)
		select count(*)::integer from activatedLincenses where
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
-- CreatedAt: 2017-02-28
-- Description: Script Get amount of activated licenses by given time
-- ##########################################################################
Input paramteres: vTime  timestamp
Return Value: Amount of activated licenses
######################################################*/
CREATE FUNCTION GetActivatedLicensesSinceForUser (vTime timestamp, vUserUUID uuid, vRoles text[])
RETURNS SETOF integer AS
$$
	DECLARE
		vFunctionName varchar := 'GetActivatedLicensesSinceForUser';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY(
        with activatedLincenses as(
			select * from licenseorder lo
			join offer of on lo.offerid = of.offerid
			join paymentinvoice pi on
			of.paymentinvoiceid = pi.paymentinvoiceid
			join offerrequest oq on
			pi.offerrequestid = oq.offerrequestid
			join offerrequestitems ri on
			oq.offerrequestid = ri.offerrequestid
			join technologydata td on
			ri.technologydataid = td.technologydataid
			where td.createdby = vUserUUID
			)
		select count(*)::integer from activatedLincenses where
		(select datediff('second',vTime::timestamp,activatedat::timestamp)) >= 0 AND
		(select datediff('minute',vTime::timestamp,activatedat::timestamp)) >= 0 AND
		(select datediff('hour',vTime::timestamp,activatedat::timestamp)) >= 0
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
-- CreatedAt: 2017-03-07
-- Description: Script Get Top x since given Date
-- ##########################################################################
Input paramteres: vSinceDate  timestamp
				  vTopValue integer
Return Value: TechnologyDataName, Rank value
######################################################*/
CREATE FUNCTION public.gettoptechnologydatasince(
    IN vsincedate timestamp without time zone,
    IN vtopvalue integer,
	IN vUserUUID uuid,
    IN vRoles text[])
  RETURNS TABLE(technologydataname character varying, rank integer, revenue numeric) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetTopTechnologyDataSince';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (	select td.technologydataname, count(ts.offerid)::integer, (sum(td.licensefee*ri.amount))/100000::numeric(21,4) as "Revenue (in IUNOs)" from transactions ts
			join licenseorder lo
			on ts.offerid = lo.offerid
			join offerrequest oq
			on oq.offerrequestid = ts.offerrequestid
			join offerrequestitems ri on
			oq.offerrequestid = ri.offerrequestid
			join technologydata td
			on ri.technologydataid = td.technologydataid
			where (select datediff('second',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('minute',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('hour',vSinceDate::timestamp,activatedat::timestamp)) >= 0
			AND td.deleted is null
			group by td.technologydataname
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
-- Description: Script Get Top x since given Date
-- ##########################################################################
Input paramteres: vSinceDate  timestamp
				  vTopValue integer
Return Value: TechnologyDataName, Rank value
######################################################*/
CREATE OR REPLACE FUNCTION public.gettoptechnologydatasinceforuser(
    IN vsincedate timestamp without time zone,
    IN vtopvalue integer,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydataname character varying, rank integer, revenue numeric) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetTopTechnologyDataSinceForUser';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (	select td.technologydataname, count(ts.offerid)::integer, (sum(td.licensefee*ri.amount))/100000::numeric(21,4) as "Revenue (in IUNOs)" from transactions ts
			join licenseorder lo
			on ts.offerid = lo.offerid
			join offerrequest oq
			on oq.offerrequestid = ts.offerrequestid
			join offerrequestitems ri on
			oq.offerrequestid = ri.offerrequestid
			join technologydata td
			on ri.technologydataid = td.technologydataid
			where (select datediff('second',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('minute',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('hour',vSinceDate::timestamp,activatedat::timestamp)) >= 0
			AND td.deleted is null
			group by td.technologydataname
			order by count(ts.offerid) desc limit vTopValue
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;

	$BODY$
  LANGUAGE plpgsql VOLATILE;
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
		vRoles text[]
	)
RETURNS TABLE (
	ComponentName varchar(250),
	Amount integer
) AS
$$

	DECLARE
		vFunctionName varchar := 'GetMostUsedComponents';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

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
				where td.deleted is null
			),
		rankTable as (
		select componentname, count(componentname) as rank from activatedLincenses where
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
-- Description: Script Get most used components since given Date for one particular user
-- ##########################################################################
Input paramteres: vSinceDate  timestamp
				  vTopValue integer
Return Value: ComponentName, Amount
######################################################*/
CREATE FUNCTION public.GetMostUsedComponentsForUser(
    IN vsincedate timestamp without time zone,
    IN vtopvalue integer,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(componentname character varying, amount integer) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetMostUsedComponentsForUser';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY(
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
			where td.createdby = vUserUUID
			),
		rankTable as (
		select al.componentname, count(al.componentname) as rank from activatedLincenses al
		where
		(select datediff('second',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
		(select datediff('minute',vSinceDate::timestamp,activatedat::timestamp)) >= 0 AND
		(select datediff('hour',vSinceDate::timestamp,activatedat::timestamp)) >= 0
		group by al.componentname)
		select a.componentname::varchar(250) as componentname, a.rank::integer as rank from rankTable a
		order by rank desc limit vTopValue
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
 /* ##########################################################################
-- Author: Marcel Ely Gomes
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-07
-- Description: Script Get workload since given time
-- ##########################################################################
Input paramteres: vSinceDate  timestamp
Return Value: TechnologyDataName, Date, Amount, DayHour
######################################################*/
CREATE FUNCTION public.GetWorkloadSince(
    IN vsincedate timestamp without time zone,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydataname character varying, date date, amount integer, dayhour integer) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetWorkloadSince';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

			with activatedLicenses as(
				select td.technologydataname, activatedat from licenseorder lo
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
				where td.deleted is null
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
 /* ##########################################################################
-- Author: Marcel Ely Gomes
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-07
-- Description: Script Get workload since given time
-- ##########################################################################
Input paramteres: vSinceDate  timestamp
Return Value: TechnologyDataName, Date, Amount, DayHour
######################################################*/
CREATE FUNCTION public.GetWorkloadSinceForUser(
    IN vsincedate timestamp without time zone,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydataname character varying, date date, amount integer, dayhour integer) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetWorkloadSinceForUser';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

			with activatedLicenses as(
				select td.technologydataname, activatedat from licenseorder lo
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
				where td.createdby = vUserUUID
				and td.deleted is null
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
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
		vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
		vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
		vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
		vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
		vRoles text[]
	)
RETURNS TABLE (
		LicenseFee integer
	) AS
$$
	DECLARE
		vFunctionName varchar := 'GetLicenseFeeByTransaction';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
$$ LANGUAGE 'plpgsql';
/* ##########################################################################
-- Author: Marcel Ely Gomes
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-09
-- Description: Script Get Transaction for given OfferRequestUUID
-- ##########################################################################
Input paramteres: vOfferRequestUUID uuid
######################################################*/
CREATE FUNCTION GetTransactionByOfferRequest(
		vOfferRequestUUID uuid,
		vUserUUID uuid,
		vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
		vRoles text[]
		)
RETURNS TABLE
    	(
			technologydatauuid uuid,
			technologyuuid uuid,
			technologydataname varchar(250),
			technologydata varchar(32672),
			technologydatadescription varchar(32672),
			licensefee integer,
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
		vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
		vRoles text[]
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
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
Input paramteres: vRoles text[](250)
				  vRoleDescription varchar(32672)
######################################################*/
create function createrole(vRoles text[], vRoleDescription varchar(32672), vUserUUID uuid, vRolesUser text[])
returns void as
$$
	Declare vRoleID integer;
		vFunctionName varchar := 'CreateRole';
		vIsAllowed boolean := (select public.checkPermissions(vRolesUser, vFunctionName));
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
$$ LANGUAGE PLPGSQL;
/* ##########################################################################
-- Author: Marcel Ely Gomes
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-13
-- Description: Create permissions for Roles
-- ##########################################################################
Input paramteres: vRoles text[],
				  vFunctionName varchar(250),
				  vRolesUser varchar
######################################################*/
CREATE FUNCTION public.setpermission(
    vRoles text[],
    vfunctionname character varying,
    vuseruuid uuid,
    vRolesuser text[])
  RETURNS void AS
$BODY$
	DECLARE vFunctionID integer := (select nextval('FunctionID'));
		vThisFunctionName varchar := 'SetPermission';
		vIsAllowed boolean := (select public.checkPermissions(vRolesUser, vThisFunctionName));
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
  LANGUAGE plpgsql VOLATILE
  COST 100;
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
		vRoles text[]
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
		vFunctionName varchar := 'GetTransactionById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
		vRoles text[]
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
		vFunctionName varchar := 'GetComponentsForTechnologyDataId';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
create function GetRevenuePerDaySince(vDate timestamp, vUserUUID uuid, vRoles text[])
returns table (date date, revenue numeric(21,2))
as
$$
	DECLARE
		vFunctionName varchar := 'GetRevenuePerDaySince';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select activatedat::date, (sum(td.licensefee*ri.amount))/100000::numeric(21,2) as "Revenue (in IUNOs)" from transactions ts
			join licenseorder lo
			on ts.licenseorderid = lo.licenseorderid
			join offerrequest oq
			on oq.offerrequestid = ts.offerrequestid
			join offerrequestitems ri
			on ri.offerrequestid = oq.offerrequestid
			join technologydata td
			on ri.technologydataid = td.technologydataid
			where (select datediff('second',vDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('minute',vDate::timestamp,activatedat::timestamp)) >= 0 AND
			(select datediff('hour',vDate::timestamp,activatedat::timestamp)) >= 0
			AND td.deleted is null
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
    vRoles text[])
  RETURNS TABLE(date date, hour double precision, revenue numeric) AS
$$
	DECLARE
		vFunctionName varchar := 'GetRevenuePerHourSince';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select activatedat::date, date_part('hour',activatedat) , (sum(td.licensefee*ri.amount)/100000)::numeric(21,2) as "Revenue (in IUNOs)" from transactions ts
			join licenseorder lo
			on ts.licenseorderid = lo.licenseorderid
			join offerrequest oq
			on oq.offerrequestid = ts.offerrequestid
			join offerrequestitems ri
			on ri.offerrequestid = oq.offerrequestid
			join technologydata td
			on ri.technologydataid = td.technologydataid
			where (select datediff('second',vDate::timestamp,activatedat::timestamp)) >= 0 AND
			      (select datediff('minute',vDate::timestamp,activatedat::timestamp)) >= 0 AND
			      (select datediff('hour',vDate::timestamp,activatedat::timestamp)) >= 0
			AND td.deleted is null
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
-- CreatedAt: 2017-03-09
-- Description: Script Get Revenue for given user
-- ##########################################################################
Input paramteres: vDate timestamp
				  vUserUUID uuid
######################################################*/
-- Get Revenue for given user
CREATE FUNCTION public.getrevenueforuser(
    IN vdate timestamp without time zone,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(date date, technologydataname character varying, revenue numeric) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetRevenueForUser';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (with basis as (select activatedat::date, td.technologydataname, (sum(td.licensefee*ri.amount))/100000::numeric(21,2) as revenue from transactions ts
			join licenseorder lo
			on ts.licenseorderid = lo.licenseorderid
			join offerrequest oq
			on oq.offerrequestid = ts.offerrequestid
			join offerrequestitems ri
			on oq.offerrequestid = ri.offerrequestid
			join technologydata td
			on ri.technologydataid = td.technologydataid
			group by activatedat::date, td.technologydataname, ri.amount
			order by activatedat::date
			),
			techName as (select distinct a.technologydataname
					from basis a),
			dates as (select distinct a.activatedat
					from basis a),
			allData as (select tn.technologydataname, dt.activatedat
					from techname tn, dates dt

			), benchmark as
			(select activatedat::date, (sum(td.licensefee*ri.amount))/100000::numeric(21,2) as revenue from transactions ts
				join licenseorder lo
				on ts.licenseorderid = lo.licenseorderid
				join offerrequest oq
				on oq.offerrequestid = ts.offerrequestid
				join offerrequestitems ri
				on oq.offerrequestid = ri.offerrequestid
				join technologydata td
				on ri.technologydataid = td.technologydataid
				group by activatedat::date
				order by activatedat::date
			), totalBench as (
			select ad.activatedat, ad.technologydataname, case when (ba.revenue is null) then 0::numeric(21,2) else ba.revenue end as revenue
				from allData ad
				left outer join basis ba
				on ad.activatedat = ba.activatedat
				and ad.technologydataname = ba.technologydataname
			),
			result as (
			select ad.activatedat, ad.technologydataname, case when (ba.revenue is null) then 0::numeric(21,2) else ba.revenue end as revenue
				from allData ad
				join technologydata td
				on ad.technologydataname = td.technologydataname
				left outer join basis ba
				on ad.activatedat = ba.activatedat
				and ad.technologydataname = ba.technologydataname
				where td.createdby = vuseruuid
				and td.deleted is null
			union all
			select bm.activatedat, 'Benchmark' as technologydataname, avg(bm.revenue) as revenue from totalBench bm
			group by bm.activatedat)
			select r.activatedat, r.technologydataname, r.revenue from result r
			order by r.activatedat, r.technologydataname );
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
	$BODY$
  LANGUAGE plpgsql VOLATILE;
 /* ##########################################################################
-- Author: Marcel Ely Gomes
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-03-31
-- Description: Delete given TechnologyData
-- ##########################################################################
Input paramteres: vTechnologyDataName varchar(250)
				  vUserUUID uuid
######################################################*/
CREATE OR REPLACE FUNCTION public.deletetechnologydata(
    IN vtechnologydatauuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS boolean AS
$BODY$

	DECLARE
		vFunctionName varchar := 'DeleteTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	 update technologydata set deleted = true
	 where technologydatauuid = vTechnologyDataUUID;

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
  LANGUAGE plpgsql VOLATILE
  COST 100;
 /* ##########################################################################
-- Author: Marcel Ely Gomes
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-07-12
-- Description: Proof the role permissions
-- ##########################################################################
Input paramteres: vRoles text[]
				  vFunctionName varchar
######################################################*/
CREATE FUNCTION public.checkpermissions(
    vroles text[],
    vfunctionname character varying)
  RETURNS boolean AS
$$
	#variable_conflict use_column
	DECLARE	vIsAllowed boolean;
		vFunctionId integer := (select functionId from functions where functionname = vFunctionName);
	BEGIN
		vIsAllowed := (select exists(select 1 from rolespermissions rp
									 join roles ro on ro.roleid = ro.roleid
									 where ro.rolename = ANY(vRoles)
									 and functionId = vFunctionId));
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
    IN vRoles text[]
    )
  RETURNS TABLE(licensefee integer) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetLicenseFeeByTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
--######################################################
--GetTechnologyDataOwnerById
CREATE FUNCTION public.gettechnologydataownerbyid(
    IN vtechnologydatauuid uuid,
    IN vUserUUID uuid,
    IN vRoles text[]
    )
  RETURNS TABLE(createdby varchar) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataOwnerById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (	SELECT 	td.createdby
				FROM TechnologyData td
				where technologydatauuid = vtechnologydatauuid
				and td.deleted is null
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
-- ##########################################################################
-- Create new ProductID
create function GetNewProductCode(vRoles text[])
RETURNS SetOf Integer AS
$$
	DECLARE
		vFunctionName varchar := 'GetNewProductCode';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN
		IF(vIsAllowed) then
			RETURN QUERY (select nextval('ProductCode')::integer);
		else
			RAISE EXCEPTION '%', 'Insufficiency rigths';
			RETURN;
	END IF;

	END;
$$
language plpgsql;

-- #########################################################################
create function getofferrequestbyid(vOfferRequestUUID uuid, vUserUUID uuid, vRoles text[])
 returns table(result json) AS
 $$
	declare
		vFunctionName varchar := 'GetOfferRequestById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
$$ language plpgsql;
-- ##########################################################################
CREATE FUNCTION public.gettotalrevenueforuser(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(revenue numeric) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTotalRevenueForUser';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select (sum(td.licensefee*ri.amount))/100000::numeric(21,2) as "Revenue (in IUNOs)" from transactions ts
			join licenseorder lo
			on ts.licenseorderid = lo.licenseorderid
			join offerrequest oq
			on oq.offerrequestid = ts.offerrequestid
			join offerrequestitems ri
			on oq.offerrequestid = ri.offerrequestid
			join technologydata td
			on ri.technologydataid = td.technologydataid
			where td.createdby = vUserUUID
			and td.deleted is null
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
-- ##########################################################################
-- GetTechnologyDataForUser
CREATE OR REPLACE FUNCTION public.gettechnologydataforuser(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, revenue numeric, licensefee integer, componentlist text[], technologydatadescription character varying) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetTechnologyDataForUser';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (	with revenue as (select td.technologydataname, (sum(td.licensefee*ri.amount))/100000::numeric(21,2) as revenue from transactions ts
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
			coalesce(rv.revenue,0) as revenue,
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
			sum(r.revenue) as revenue,
			r.licensefee,
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
  LANGUAGE plpgsql VOLATILE;
-- ##########################################################################
CREATE FUNCTION public.getrevenueperdayforuser(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(date date, revenue numeric) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetRevenuePerForUSer';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select activatedat::date, (sum(td.licensefee*ri.amount))/100000::numeric(21,2) as "Revenue (in IUNOs)" from transactions ts
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
  LANGUAGE plpgsql VOLATILE;
-- ##########################################################################
CREATE FUNCTION public.GetTopTechnologyDataForUser(
    IN vtopvalue integer,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydataname character varying, rank integer, revenue numeric) AS
$BODY$

	DECLARE
		vFunctionName varchar := 'GetTopTechnologyDataForUser';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (	with result as (
				select 	td.technologydataname,
					count(ts.offerid)::integer as rank,
					(sum(td.licensefee*ri.amount))/100000::numeric(21,4) as revenue from transactions ts
				join licenseorder lo
				on ts.offerid = lo.offerid
				join offerrequest oq
				on oq.offerrequestid = ts.offerrequestid
				join offerrequestitems ri on
				oq.offerrequestid = ri.offerrequestid
				join technologydata td
				on ri.technologydataid = td.technologydataid
				where td.createdby = vuseruuid
				AND td.deleted is null
				group by td.technologydataname
			)
				select r.technologydataname, r.rank, r.revenue
				from result r
				order by r.rank desc, r.revenue desc limit vTopValue
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
	$BODY$
  LANGUAGE plpgsql;
-- ##########################################################################
-- Author: Marcel Ely Gomes
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-07
-- Description: Create Base Data for the MarketplaceCode Database
-- Changes:
-- ##########################################################################
insert into roles(roleid, rolename) values (0,'Admin');
insert into functions(functionid, functionname) values (0,'CreateRole');
insert into rolespermissions (roleid,functionid) values (0,0);
insert into functions(functionid, functionname) values (1,'SetPermission');
insert into rolespermissions(roleid, functionid) values (0,1);

DO
$$
	BEGIN
		perform createrole('{Public}','Everyone that visit the marketplace without login. The public role Is only allowed to read a pre defined area (e.g. Landing Page).', null,'{Admin}');
		perform createrole('{MachineOperator}','It can be the machine owner as well as the machine operator.', null,'{Admin}');
		perform createrole('{TechnologyDataOwner}','Is the creator and administrator of Technology Data', null,'{Admin}');
		perform createrole('{MarketplaceComponent}','Is the creator and administrator of Technology Data', null,'{Admin}');
		perform createrole('{TechnologyAdmin}','Administrate technologies.', null,'{Admin}');
		perform createrole('{MarketplaceCore}','Is the only role with access to core functions', null,'{Admin}');
	END;
$$;
--Create Permissions
DO
$$
	BEGIN
		--Public
		perform SetPermission('{Public}', 'GetMostUsedComponents',null,'{Admin}');
		perform SetPermission('{Public}', 'GetRevenuePerDaySince',null,'{Admin}');
		perform SetPermission('{Public}', 'GetWorkLoadSince',null,'{Admin}');
        perform SetPermission('{Public}', 'GetRevenuePerHourSince',null,'{Admin}');

        --MarketplaceCore
		perform SetPermission('{MarketplaceCore}', 'GetTransactionById',null,'{Admin}');
		perform SetPermission('{MarketplaceCore}', 'SetPayment',null,'{Admin}');
		perform SetPermission('{MarketplaceCore}', 'CreateLicenseOrder',null,'{Admin}');
		perform SetPermission('{MarketplaceCore}', 'GetNewProductCode',null,'{Admin}');
		perform SetPermission('{MarketplaceCore}', 'GetOfferRequestById',null,'{Admin}');
		-- MachineOperator
		--perform SetPermission('{Admin}','CreateAttribute',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponent',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponentsAttribute',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponentsTechnologies',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateLicenseOrder',null,'{Admin}');
		perform SetPermission('{MachineOperator}','CreateOffer',null,'{Admin}');
		perform SetPermission('{MachineOperator}','CreateOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}','CreatePaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTag',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnology',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyDataComponents',null,'{Admin}');
		--perform SetPermission('{Admin}','DeleteTechnologyData',null,'{Admin}');
		perform SetPermission('{MachineOperator}','GetAllAttributes',null,'{Admin}');
		perform SetPermission('{MachineOperator}','GetActivatedLicensesSince',null,'{Admin}');
		perform SetPermission('{MachineOperator}','GetAllComponents',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAllOffers',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAllTags',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllTechnlogies',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAllUsers',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAttributeById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAttributeByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetComponentById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetComponentByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetComponentsByTechnology',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetComponentsForTechnologyDataId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTransaction',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetMostUsedComponents',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetOfferById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetOfferByRequestId',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetOfferForPaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTicket',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetOfferForTransaction',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetPaymentInvoiceForOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetRevenuePerDaySince',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTagById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTagByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyDataById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyDataByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyDataByOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyDataByParams',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyForOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTopTechnologyDataSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTransactionByOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetWorkLoadSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetComponent',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'SetPayment',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'SetPaymentInvoiceOffer',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'SetTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'CreateTechnologyDataTags',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetLicenseFeeByTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataOwnerById',null,'{Admin}');

		--TechnologyDataOwner
		perform SetPermission('{TechnologyDataOwner}','CreateAttribute',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateComponent',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateComponentsAttribute',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateComponentsTechnologies',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateLicenseOrder',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOffer',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}','CreatePaymentInvoice',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateTag',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnology',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateTechnologyData',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateTechnologyDataComponents',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','DeleteTechnologyData',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','GetAllAttributes',null,'{Admin}');
		--perform SetPermission('{Admin}','GetActivatedLicensesSince',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','GetAllComponents',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllOffers',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAllTags',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAllTechnlogies',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAllUsers',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAttributeById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAttributeByName',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetComponentById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetComponentByName',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetComponentsByTechnology',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetComponentsForTechnologyDataId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTransaction',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetMostUsedComponents',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferByRequestId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForPaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTicket',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTransaction',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetPaymentInvoiceForOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetRevenuePerDaySince',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTagById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTagByName',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyByName',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyDataById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyDataByName',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataByOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyDataByParams',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyForOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTopTechnologyDataSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionByOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetWorkLoadSince',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'SetComponent',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPayment',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPaymentInvoiceOffer',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'SetTechnologyData',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'CreateTechnologyDataTags',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataOwnerById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTopTechnologyDataSinceForUser',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetActivatedLicensesSinceForUser',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetMostUsedComponentsForUser',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetWorkloadSinceForUser',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetRevenueForUser',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTotalRevenueForUser',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','GetTechnologyDataForUser',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetRevenuePerForUSer',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTopTechnologyDataForUser',null,'{Admin}');

		--MarketplaceComponent

		--TechnologyAdmin
		perform SetPermission('{TechnologyAdmin}','CreateAttribute',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateComponent',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateComponentsAttribute',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateComponentsTechnologies',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateLicenseOrder',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOffer',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}','CreatePaymentInvoice',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateTag',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateTechnology',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyDataComponents',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','DeleteTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}','GetAllAttributes',null,'{Admin}');
		--perform SetPermission('{Admin}','GetActivatedLicensesSince',null,'{Admin}');
		--perform SetPermission('{Admin}','GetAllComponents',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllOffers',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllTags',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetAllTechnlogies',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllUsers',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAttributeById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAttributeByName',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetComponentById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetComponentByName',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetComponentsByTechnology',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetComponentsForTechnologyDataId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTransaction',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetMostUsedComponents',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferByRequestId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForPaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTicket',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTransaction',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetPaymentInvoiceForOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetRevenuePerDaySince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTagById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTagByName',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyById',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyByName',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyDataById',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyDataByName',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataByOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyDataByParams',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyForOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTopTechnologyDataSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionByOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetWorkLoadSince',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'SetComponent',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPayment',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPaymentInvoiceOffer',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'CreateTechnologyDataTags',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataOwnerById',null,'{Admin}');

		--Admin
		--perform SetPermission('{Admin}','CreateAttribute',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponent',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponentsAttribute',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponentsTechnologies',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateLicenseOrder',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOffer',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}','CreatePaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTag',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnology',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyDataComponents',null,'{Admin}');
		perform SetPermission('{Admin}','DeleteTechnologyData',null,'{Admin}');
		perform SetPermission('{Admin}','GetAllAttributes',null,'{Admin}');
		perform SetPermission('{Admin}','GetActivatedLicensesSince',null,'{Admin}');
		perform SetPermission('{Admin}','GetAllComponents',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAllOffers',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAllTags',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAllTechnlogies',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAllUsers',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAttributeById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAttributeByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetComponentById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetComponentByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetComponentsByTechnology',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetComponentsForTechnologyDataId',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetLicenseFeeByTransaction',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetMostUsedComponents',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferByRequestId',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferForPaymentInvoice',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferForTicket',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferForTransaction',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetPaymentInvoiceForOfferRequest',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetRevenuePerDaySince',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTagById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTagByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataByOfferRequest',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataByParams',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyForOfferRequest',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTopTechnologyDataSince',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTransactionById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTransactionByOfferRequest',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetWorkLoadSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetComponent',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPayment',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPaymentInvoiceOffer',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'CreateTechnologyDataTags',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetLicenseFeeByTechnologyData',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataOwnerById',null,'{Admin}');




	END;
$$;

DO
 $$
    DECLARE vUserUUID uuid := 'adb4c297-45bd-437e-ac90-9179eea41730';
			vCompParentID uuid;
			vRoleName text[] := '{TechnologyAdmin}';
	BEGIN
    	-- Just in case. set all sequences to start point
        ALTER SEQUENCE componentid RESTART WITH 1;
        ALTER SEQUENCE technologyid RESTART WITH 1;
        ALTER SEQUENCE technologydataid RESTART WITH 1;
        ALTER SEQUENCE tagid RESTART WITH 1;
        ALTER SEQUENCE attributeid RESTART WITH 1;

        perform public.createtechnology(
            'Juice Mixer',			-- <technologyname character varying>,
            'Machine to mix juice',	-- <technologydescription character varying>,
            vUserUUID,
	    vRoleName 				-- <createdby integer>
        );

        update technologies set technologyUUID = 'da17a8fc-a5b3-40a4-b6a5-276667db027a'
        where technologyname = 'Juice Mixer';
        -- Create Components & Attributes

        perform public.setcomponent(
            'Root',   			-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Root component', 	-- <componentdescription character varying>,
            '{Root}',			-- <attributelist text[]>,
            '{Juice Mixer}',  				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 1 Wasser
        perform public.setcomponent(
            'Mineralwasser',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Mineralwasser', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 2 Apfelsaft
        perform public.setcomponent(
            'Apfelsaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Apfelsaft', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
		 -- 3 Orange
        perform public.setcomponent(
            'Orangensaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Orangensaft', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
		-- 4 Mangosaft
        perform public.setcomponent(
            'Mangosaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Mangosaft', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 5 Kirschsaft
        perform public.setcomponent(
            'Kirschsaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Kirschsaft',  	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 6 Bananensaft
        perform public.setcomponent(
            'Bananensaft',				-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Bananensaft',			 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
         -- 7 Maracujasaft
        perform public.setcomponent(
            'Maracujasaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Maracujasaft', 		-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 8 Ananassaft
        perform public.setcomponent(
            'Ananassaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Ananassaft', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
            vRoleName  			-- <createdby integer>
         );

		update components set componentuuid = '8f0bc514-7219-46d2-999d-c45c930c3e7c'::uuid where componentname = 'Root';
		update components set componentuuid = '570a5df0-a044-4e22-b6e6-b10af872d75c'::uuid where componentname = 'Mineralwasser';
		update components set componentuuid = '198f1571-4846-4467-967a-00427ab0208d'::uuid where componentname = 'Apfelsaft';
		update components set componentuuid = 'f6d361a9-5a6f-42ad-bff7-0913750809e4'::uuid where componentname = 'Orangensaft';
		update components set componentuuid = 'fac1ee6f-185f-47fb-8c56-af57cd428aa8'::uuid where componentname = 'Mangosaft';
		update components set componentuuid = '0425393d-5b84-4815-8eda-1c27d35766cf'::uuid where componentname = 'Kirschsaft';
		update components set componentuuid = '4cfa2890-6abd-4e21-a7ab-17613ed9a5c9'::uuid where componentname = 'Bananensaft';
		update components set componentuuid = '14b72ce5-fec1-48ec-83ff-24b124f98dc8'::uuid where componentname = 'Maracujasaft';
		update components set componentuuid = 'bf2cfd66-5b6f-4655-8e7f-04090308f6db'::uuid where componentname = 'Ananassaft';
   END;
 $$;
COMMIT;

update components set componentuuid = '8f0bc514-7219-46d2-999d-c45c930c3e7c'::uuid where componentname = 'Root';
update components set componentuuid = '570a5df0-a044-4e22-b6e6-b10af872d75c'::uuid where componentname = 'Mineralwasser';
update components set componentuuid = '198f1571-4846-4467-967a-00427ab0208d'::uuid where componentname = 'Apfelsaft';
update components set componentuuid = 'f6d361a9-5a6f-42ad-bff7-0913750809e4'::uuid where componentname = 'Orangensaft';
update components set componentuuid = 'fac1ee6f-185f-47fb-8c56-af57cd428aa8'::uuid where componentname = 'Mangosaft';
update components set componentuuid = '0425393d-5b84-4815-8eda-1c27d35766cf'::uuid where componentname = 'Kirschsaft';
update components set componentuuid = '4cfa2890-6abd-4e21-a7ab-17613ed9a5c9'::uuid where componentname = 'Bananensaft';
update components set componentuuid = '14b72ce5-fec1-48ec-83ff-24b124f98dc8'::uuid where componentname = 'Maracujasaft';
update components set componentuuid = 'bf2cfd66-5b6f-4655-8e7f-04090308f6db'::uuid where componentname = 'Ananassaft';