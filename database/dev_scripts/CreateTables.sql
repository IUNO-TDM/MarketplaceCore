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
    RetailPrice               INTEGER ,
    LicenseProductCode        INTEGER ,
    TechnologyDataDescription VARCHAR (32672) ,
    TechnologyDataThumbnail Bytea ,
    TechnologyDataImgRef VARCHAR ,
    CreatedAt            TIMESTAMP WITHOUT TIME ZONE NOT NULL ,
    CreatedBy            UUID NOT NULL ,
    UpdatedAt            TIMESTAMP WITHOUT TIME ZONE ,
    UpdatedBy            UUID
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
