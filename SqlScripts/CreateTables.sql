-- Generiert von Oracle SQL Developer Data Modeler 4.0.3.853
--   am/um:        2017-02-14 13:41:18 MEZ
--   Site:      DB2/UDB 8.1
--   Typ:      DB2/UDB 8.1

CREATE
  TABLE Attributes
  (
    AttributeID   INTEGER NOT NULL ,
    AttributeName VARCHAR (250) NOT NULL ,
    CreatedAt     timestamp without time zone NOT NULL ,
    CreatedBy     INTEGER NOT NULL ,
    UpdatedAt     timestamp without time zone ,
    UpdatedBy     INTEGER
  ) ;
ALTER TABLE Attributes ADD CONSTRAINT Attribubes_PK PRIMARY KEY ( AttributeID )
;

CREATE
  TABLE Components
  (
    ComponentID          INTEGER NOT NULL ,
    ComponentName        VARCHAR (250) ,
    ComponentParentID    INTEGER ,
    ComponentDescription VARCHAR (32672) ,
    CreatedAt            timestamp without time zone NOT NULL ,
    CreatedBy            INTEGER NOT NULL ,
    UpdatedAt            timestamp without time zone ,
    UpdatedBy            VARCHAR
  ) ;
ALTER TABLE Components ADD CONSTRAINT Components_PK PRIMARY KEY ( ComponentID );
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
  TABLE LogTable
  (
    LogID         INTEGER NOT NULL ,
    LogMessage    VARCHAR (32672) NOT NULL ,
    LogObjectName VARCHAR (250) ,
    Parameters    VARCHAR (32672) ,
    CreatedAt     timestamp without time zone NOT NULL
  ) ;
ALTER TABLE LogTable ADD CONSTRAINT LogTable_PK PRIMARY KEY ( LogID ) ;

CREATE
  TABLE Tags
  (
    TagID     INTEGER NOT NULL ,
    TagName   VARCHAR (250) NOT NULL ,
    CreatedAt timestamp without time zone NOT NULL ,
    CreatedBy INTEGER NOT NULL ,
    UpdateAt  timestamp without time zone ,
    UpdatedBy INTEGER
  ) ;
ALTER TABLE Tags ADD CONSTRAINT Tags_PK PRIMARY KEY ( TagID ) ;

CREATE
  TABLE Technologies
  (
    TechnologyID          INTEGER NOT NULL ,
    TechnologyName        VARCHAR (250) NOT NULL ,
    TechnologyDescription VARCHAR (32672) ,
    CreatedAt             timestamp without time zone NOT NULL ,
    CreatedBy             INTEGER NOT NULL ,
    UpdatedAt             timestamp without time zone ,
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
    TechnologyDataUUID        CHAR ,
    TechnologyID              INTEGER NOT NULL ,
    TechnologyDataName        VARCHAR (250) NOT NULL ,
    TechnologyData            VARCHAR (32672) NOT NULL ,
    TechnologyDataDescription VARCHAR (32672) ,
    LicenseFee                DECIMAL (21,4) NOT NULL ,
    CreatedAt                 timestamp without time zone NOT NULL ,
    CreatedBy                 INTEGER NOT NULL ,
    UpdateAt                  timestamp without time zone ,
    UpdatedBy                 INTEGER
  ) ;
ALTER TABLE TechnologyData ADD CONSTRAINT TechnologyData_PK PRIMARY KEY (
TechnologyDataID ) ;
ALTER TABLE TechnologyData ADD CONSTRAINT TechnologyData__UN UNIQUE (
TechnologyDataName ) ;

CREATE
  TABLE TechnologyDataComponents
  (
    TechnologyID INTEGER NOT NULL ,
    ComponentID  INTEGER NOT NULL
  ) ;
ALTER TABLE TechnologyDataComponents ADD CONSTRAINT TechnologyDataComponents_PK
PRIMARY KEY ( TechnologyID, ComponentID ) ;

CREATE
  TABLE TechnologyDataTags
  (
    TechnologyDataID INTEGER NOT NULL ,
    TagID            INTEGER NOT NULL
  ) ;
ALTER TABLE TechnologyDataTags ADD CONSTRAINT TechnologyDataTag_PK PRIMARY KEY
( TechnologyDataID, TagID ) ;

CREATE
  TABLE Users
  (
    UserID        INTEGER NOT NULL ,
    UserFirstName VARCHAR (250) NOT NULL ,
    UserLastName  VARCHAR (250) NOT NULL ,
    UserEmail     VARCHAR (250) NOT NULL ,
    CreatedAt     timestamp without time zone NOT NULL ,
    UpdatedAt     timestamp without time zone
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
TechnologyDataComponents_TechnologyData_FK FOREIGN KEY ( TechnologyID )
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


-- Zusammenfassungsbericht für Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            11
-- CREATE INDEX                             0
-- ALTER TABLE                             30
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
