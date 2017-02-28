-- Generiert von Oracle SQL Developer Data Modeler 4.0.3.853
--   am/um:        2017-02-27 08:03:59 MEZ
--   Site:      DB2/UDB 8.1
--   Typ:      DB2/UDB 8.1




CREATE
  TABLE Attributes
  (
    AttributeID   INTEGER NOT NULL ,
    AttributeUUID UUID ,
    AttributeName VARCHAR (250) NOT NULL ,
    CreatedAt     TIMESTAMP WITH TIME ZONE NOT NULL ,
    CreatedBy     INTEGER NOT NULL ,
    UpdatedAt     TIMESTAMP WITH TIME ZONE ,
    UpdatedBy     INTEGER
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
    CreatedAt            TIMESTAMP WITH TIME ZONE NOT NULL ,
    CreatedBy            INTEGER NOT NULL ,
    UpdatedAt            TIMESTAMP WITH TIME ZONE ,
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
    LicenseOrderUUID UUID ,
    TicketID         VARCHAR (32672) ,
    OfferID          INTEGER NOT NULL ,
    ActivatedAt      TIMESTAMP WITH TIME ZONE ,
    CreatedAt        TIMESTAMP WITH TIME ZONE NOT NULL ,
    CreatedBy        INTEGER NOT NULL
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
    CreatedAt     TIMESTAMP WITH TIME ZONE NOT NULL
  ) ;
  
/*TODO: Stammdata into other file 
*/
insert into logstatus(LogStatusID, LogStatus) values(0,'SUCESS');
insert into logstatus(LogStatusID, LogStatus) values(1,'ERROR');
insert into logstatus(LogStatusID, LogStatus) values(2,'PENDING');

ALTER TABLE LogTable ADD CONSTRAINT LogTable_PK PRIMARY KEY ( LogID ) ;

CREATE
  TABLE Offer
  (
    OfferID          INTEGER NOT NULL ,
    OfferUUID        UUID ,
    PaymentInvoiceID INTEGER NOT NULL ,
    CreatedAt        TIMESTAMP WITH TIME ZONE ,
    CreatedBy        INTEGER NOT NULL
  ) ;
ALTER TABLE Offer ADD CONSTRAINT Offer_PK PRIMARY KEY ( OfferID ) ;

CREATE
  TABLE OfferRequest
  (
    OfferRequestID   INTEGER NOT NULL ,
    OfferRequestUUID UUID ,
    TechnologyDataID INTEGER NOT NULL ,
    Amount           INTEGER ,
    HSMID            VARCHAR ,
    CreatedAt        TIMESTAMP WITH TIME ZONE ,
    RequestedBy      INTEGER NOT NULL
  ) ;
ALTER TABLE OfferRequest ADD CONSTRAINT OfferRequest_PK PRIMARY KEY (
OfferRequestID ) ;

CREATE
  TABLE Payment
  (
    PaymentID          INTEGER NOT NULL ,
    PaymentUUID        UUID ,
    PaymentInvoiceID   INTEGER NOT NULL ,
    PayDate            TIMESTAMP WITH TIME ZONE ,
    BitcoinTransaction VARCHAR (32672)
  ) ;
ALTER TABLE Payment ADD CONSTRAINT Payment_PK PRIMARY KEY ( PaymentID ) ;

CREATE
  TABLE PaymentInvoice
  (
    PaymentInvoiceID   INTEGER NOT NULL ,
    PaymentInvoiceUUID UUID ,
    OfferRequestID     INTEGER NOT NULL ,
    Invoice            VARCHAR (32672) ,
    CreatedAt          TIMESTAMP WITH TIME ZONE ,
    CreatedBy          INTEGER
  ) ;
ALTER TABLE PaymentInvoice ADD CONSTRAINT PaymentInvoice_PK PRIMARY KEY (
PaymentInvoiceID ) ;

CREATE
  TABLE Tags
  (
    TagID     INTEGER NOT NULL ,
    TagUUID   UUID ,
    TagName   VARCHAR (250) NOT NULL ,
    CreatedAt TIMESTAMP WITH TIME ZONE NOT NULL ,
    CreatedBy INTEGER NOT NULL ,
    UpdatedAt TIMESTAMP WITH TIME ZONE ,
    UpdatedBy INTEGER
  ) ;
ALTER TABLE Tags ADD CONSTRAINT Tags_PK PRIMARY KEY ( TagID ) ;

CREATE
  TABLE Technologies
  (
    TechnologyID          INTEGER NOT NULL ,
    TechnologyUUID        UUID ,
    TechnologyName        VARCHAR (250) NOT NULL ,
    TechnologyDescription VARCHAR (32672) ,
    CreatedAt             TIMESTAMP WITH TIME ZONE NOT NULL ,
    CreatedBy             INTEGER NOT NULL ,
    UpdatedAt             TIMESTAMP WITH TIME ZONE ,
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
    TechnologyDataUUID        UUID ,
    TechnologyDataName        VARCHAR (250) NOT NULL ,
    TechnologyID              INTEGER NOT NULL ,
    TechnologyData            VARCHAR (32672) NOT NULL ,
    TechnologyDataDescription VARCHAR (32672) ,
    LicenseFee                DECIMAL (21,4) NOT NULL ,
    CreatedAt                 TIMESTAMP WITH TIME ZONE NOT NULL ,
    CreatedBy                 INTEGER NOT NULL ,
    UpdateAt                  TIMESTAMP WITH TIME ZONE ,
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
    TransactionUUID  UUID ,
    BuyerID          INTEGER NOT NULL ,
    OfferID          INTEGER ,
    OfferRequestID   INTEGER NOT NULL ,
    PaymentID        INTEGER ,
    PaymentInvoiceID INTEGER ,
    LicenseOrderID   INTEGER ,
    CreatedAt        TIMESTAMP WITH TIME ZONE ,
    CreatedBy        INTEGER NOT NULL ,
    UpdatedAt        TIMESTAMP WITH TIME ZONE ,
    UpdatedBy        INTEGER
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
    Thumbnail Bytea,
    ImgPath   VARCHAR ,
    CreatedAt TIMESTAMP WITH TIME ZONE NOT NULL ,
    UpdatedAt TIMESTAMP WITH TIME ZONE
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

ALTER TABLE LicenseOrder ADD CONSTRAINT LicenseOrder_Users_FK FOREIGN KEY (
CreatedBy ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;

ALTER TABLE LogTable ADD CONSTRAINT LogTable_LogStatus_FK FOREIGN KEY (
LogStatusID ) REFERENCES LogStatus ( LogStatusID ) ON
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

ALTER TABLE Offer ADD CONSTRAINT Offer_Users_FK FOREIGN KEY ( CreatedBy )
REFERENCES Users ( UserID ) ON
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

ALTER TABLE Transactions ADD CONSTRAINT Transactions_PaymentInvoice_FK FOREIGN
KEY ( PaymentInvoiceID ) REFERENCES PaymentInvoice ( PaymentInvoiceID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_Payment_FK FOREIGN KEY (
PaymentID ) REFERENCES Payment ( PaymentID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_Users_FK FOREIGN KEY (
BuyerID ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_Users_FKv1 FOREIGN KEY (
CreatedBy ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;

ALTER TABLE Transactions ADD CONSTRAINT Transactions_Users_FKv2 FOREIGN KEY (
UpdatedBy ) REFERENCES Users ( UserID ) ON
DELETE
  NO ACTION;


-- Zusammenfassungsbericht für Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            18
-- CREATE INDEX                             0
-- ALTER TABLE                             54
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
