-- ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-07
-- Description: Script to create MarketplaceCore database functions, sequences, etc.
-- Changes:
-- ##########################################################################

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
      DECLARE UserID integer := (select nextval('UserID'));      
      BEGIN        
        INSERT INTO Users(UserID, UserFirstName, UserLastName, UserEmail, CreatedAt)
        VALUES(UserID, UserFirstName, UserLastName, UserEmail, now());        
        
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
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE TechnologyDataID integer := (select nextval('TechnologyDataID'));
      BEGIN        
        INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataName, TechnologyData, TechnologyDataDescription, CreatedBy, CreatedAt)
        VALUES(TechnologyDataID, TechnologyDataName, TechnologyData, TechnologyDataDescription, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog('Created TechnologyData sucessfully', 'TechnologyData', 
                                'TechnologyDataID: ' || cast(TechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || TechnologyDataName || ', TechnologyData: ' || TechnologyData 
                                || ', TechnologyDataDescription: ' || TechnologyDataDescription);
                                
        -- End Log if success
        -- Return UserID
        RETURN TechnologyDataID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'TechnologyData', 
                                 'TechnologyDataID: ' || cast(TechnologyDataID as varchar) || ', TechnologyDataName: ' 
                                || TechnologyDataName || ', TechnologyData: ' || TechnologyData 
                                || ', TechnologyDataDescription: ' || TechnologyDataDescription);
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
  TagDescription varchar(32672),
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE TagID integer := (select nextval('TagID'));
      BEGIN        
        INSERT INTO Tags(TagID, TagName, TagDescription, CreatedBy, CreatedAt)
        VALUES(TagID, TagName, TagDescription, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog('Created Tag sucessfully', 'CreateTag', 
                                'TagID: ' || cast(TagID as varchar) || ', TagName: ' 
                                || TagName || ', TagDescription: ' || TagDescription);
                                
        -- End Log if success
        -- Return UserID
        RETURN TagID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTag', 
                                'TagID: ' || cast(TagID as varchar) || ', TagName: ' 
                                || TagName || ', TagDescription: ' || TagDescription);
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
  AttributeDescription varchar(32672),
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE AttributeID integer := (select nextval('AttributeID'));
      BEGIN        
        INSERT INTO public.Attributes(AttributeID, AttributeName, AttributeDescription, CreatedBy, CreatedAt)
        VALUES(AttributeID, AttributeName, AttributeDescription, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog('Created Attribute sucessfully', 'CreateAttribute', 
                                'AttributeID: ' || cast(AttributeID as varchar) || ', AttributeName: ' 
                                || AttributeName || ', AttributeDescription: ' || AttributeDescription);
                                
        -- End Log if success
        -- Return UserID
        RETURN AttributeID;
        
        exception when others then 
        -- Begin Log if error
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'CreateAttribute', 
                                'AttributeID: ' || cast(AttributeID as varchar) || ', AttributeName: ' 
                                || AttributeName || ', AttributeDescription: ' || AttributeDescription);
        -- End Log if error
        -- Return Error Code * -1
        RETURN (-1) * cast(SQLSTATE as integer);
      END;
  $$
  LANGUAGE 'plpgsql';