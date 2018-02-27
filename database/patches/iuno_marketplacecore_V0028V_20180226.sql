--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-02-26
--Version: 00.00.01 (Initial)
--#######################################################################################################
-- READ THE INSTRUCTIONS BEFORE CONTINUE - USE ONLY PatchDBTool to deploy patches to existing Databases
-- Describe your patch here
-- Patch Description:
-- 	1) Why is this Patch necessary?
-- 	2) Which Git Issue Number is this patch solving?
-- 	3) Which changes are going to be done?
-- PATCH FILE NAME - THIS IS MANDATORY
-- iuno_<databasename>_V<patchnumber>V_<creation date>.sql
-- PatchNumber Format: 00000 whereas each new Patch increase the patchnumber by 1
-- Example: iuno_marketplacecore_V00001V_20170913.sql
--#######################################################################################################
-- PUT YOUR STATEMENTS HERE:
-- 	1) Why is this Patch necessary?
-- Correct Bug by SetComponent
-- 	2) Which Git Issue Number is this patch solving?
-- 	3) Which changes are going to be done?
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0028V_20180226';
		PatchNumber int 		 	 := 0028;
		PatchDescription varchar 	 := 'Correct Bug by SetComponent.';
		CurrentPatch int 			 := (select max(p.patchnumber) from patches p);

	BEGIN
		--INSERT START VALUES TO THE PATCH TABLE
		IF (PatchNumber <= CurrentPatch) THEN
			RAISE EXCEPTION '%', 'Wrong patch number. Please verify your patches!';
		ELSE
			INSERT INTO PATCHES (patchname, patchnumber, patchdescription, startat) VALUES (PatchName, PatchNumber, PatchDescription, now());
		END IF;
	END;
$$;
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Run the patch itself and update patches table
--##############################################################################################
DO
$$
		DECLARE
			vPatchNumber int := 0028;
			vComp text; vAttr text[];
		BEGIN
-- #########################################################################################################################################



        CREATE OR REPLACE FUNCTION public.setcomponent(
            IN vcomponentname character varying,
            IN vcomponentparentname character varying,
            IN vcomponentdescription character varying,
            IN vattributelist text[],
            IN vtechnologylist text[],
            IN vcreatedby uuid,
            IN vroles text[])
          RETURNS TABLE(componentuuid uuid, componentname character varying, componentparentname character varying, componentparentuuid uuid, componentdescription character varying, attributelist uuid[], technologylist uuid[], createdat timestamp with time zone, createdby uuid) AS
        $BODY$
            #variable_conflict use_column
              DECLARE 	vAttributeName text;
                    vTechName text;
                vCompID integer;
                vCompUUID uuid;
                vCompParentUUID uuid;
                vFunctionName varchar := 'SetComponent';
                vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));

            BEGIN

            IF(vIsAllowed) THEN

                -- Is none ParentComponent -> set Root as Parent
                if (vcomponentparentname is null) then
                    vcomponentparentname := 'Root';
                end if;
                vCompParentUUID := (select case when (vComponentParentName = 'Root' and not exists (select 1 from components where componentName = 'Root')) then uuid_generate_v4() else componentuuid end from components where componentname = vComponentParentName);

                -- Proof if all technologies are avaiable
                if(vTechnologyList is not null OR array_length(vTechnologyList,1)>0) then
                    FOREACH vTechName in array vTechnologyList
                    LOOP
                         if not exists (select technologyid from technologies where technologyname = vTechName) then
                         raise exception using
                         errcode = 'invalid_parameter_value',
                         message = 'There is no technology with TechnologyName: ' || vTechName;
                         end if;
                    END LOOP;

                    -- Create new Component
                    perform public.createcomponent(vCompParentUUID,vComponentName, vComponentdescription, vCreatedby, vRoles);
                    vCompID := (select currval('ComponentID'));
                    vCompUUID := (select componentuuid from components where componentID = vCompID);

                    -- Create relation from Components to TechnologyData
                    perform public.CreateComponentsTechnologies(vCompUUID, vTechnologyList, vcreatedby, vRoles);
                end if;

                -- Proof if all Attributes are avaiable
                if(vAttributeList is not null OR array_length(vAttributeList,1)>0) then
                    FOREACH vAttributeName in array vAttributeList
                    LOOP
                         if not exists (select attributeid from public.attributes where attributename = vAttributeName) then
                            perform public.createattribute(vAttributeName,vCreatedBy, vRoles);
                         end if;
                    END LOOP;

                    -- Create relation from Components to Attribute
                    perform public.CreateComponentsAttribute(vCompUUID, vAttributeList, vcreatedby, vRoles);
                end if;

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
                    left outer join componentsattribute ca
                    on co.componentid = ca.componentid
                    left outer join attributes att
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
  $BODY$
  LANGUAGE plpgsql;

----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;