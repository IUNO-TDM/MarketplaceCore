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
  LicenseFee decimal(21,4),  
  vTechnologyID integer,
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE TechnologyDataID integer := (select nextval('TechnologyDataID'));      		   
      BEGIN        
        INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, TechnologyID, CreatedBy, CreatedAt)
        VALUES(TechnologyDataID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, vTechnologyID, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog('Created TechnologyData sucessfully', 'TechnologyData', 
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
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'TechnologyData', 
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
      DECLARE TagID integer := (select nextval('TagID'));
      BEGIN        
        INSERT INTO Tags(TagID, TagName, CreatedBy, CreatedAt)
        VALUES(TagID, TagName, CreatedBy, now());
     
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
      DECLARE AttributeID integer := (select nextval('AttributeID'));
      BEGIN        
        INSERT INTO public.Attributes(AttributeID, AttributeName, CreatedBy, CreatedAt)
        VALUES(AttributeID, AttributeName, CreatedBy, now());
     
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
CREATE FUNCTION CreateComponents (
  ComponentParentID integer, 
  ComponentName varchar(250),
  ComponentDescription varchar(250),
  CreatedBy integer
 )
  RETURNS INTEGER AS
  $$
      DECLARE ComponentID integer := (select nextval('ComponentID'));
      BEGIN        
        INSERT INTO components(ComponentID, ComponentParentID, ComponentName, ComponentDescription, CreatedBy, CreatedAt)
        VALUES(ComponentID, ComponentParentID, ComponentName, ComponentDescription, CreatedBy, now());
     
        -- Begin Log if success
        perform public.createlog('Created Component sucessfully', 'CreateComponents', 
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
        perform public.createlog('ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateComponents', 
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
      DECLARE TechnologyID integer := (select nextval('TechnologyID'));
      BEGIN        
        INSERT INTO Technologies(TechnologyID, TechnologyName, TechnologyDescription, CreatedBy, CreatedAt)
        VALUES(TechnologyID, TechnologyName, TechnologyDescription, CreatedBy, now());
     
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
-- SetTechnologyData
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
        vCompID := (select public.createcomponents(componentparentid,componentname, componentdescription, createdby));    
        
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