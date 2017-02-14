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