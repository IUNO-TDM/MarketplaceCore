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
        vTechnologyDataID := (select public.createtechnologydata(TechnologyDataName, TechnologyData, TechnologyDataDescription, vTechnologyID, CreatedBy));    
        
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