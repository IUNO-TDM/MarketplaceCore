--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-07-09
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
--  Missing where clause for technologies and attributes in components query
-- 	2) Which Git Issue Number is this patch solving?
-- #198 #199
-- 	3) Which changes are going to be done?
-- Update components functions
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0045V_20180709';
		PatchNumber int 		 	 := 0045;
		PatchDescription varchar 	 := 'Update components functions to work with attributes and technologies';
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
			vPatchNumber int := 0045;
		BEGIN
-- #########################################################################################################################################

   --Delete all components technology relations as they will be renewed
   DELETE from componentstechnologies;

   --Delete all components attribute relations as they will be renewed
   DELETE FROM componentsattribute
   where attributeid NOT IN (SELECT attributeid FROM attributes WHERE attributename = 'Root');

   --Delete all attributes as they will be renewed
   DELETE FROM attributes WHERE attributename != 'Root';

   --Insert new attributes
   select public.createattribute('juice','6df69b13-2d96-4a69-a297-aedba667e710','{TechnologyAdmin}');

   --Insert new technology and attribute relations
   DECLARE
   vComponentUUID uuid;
   vComponentUUIDs uuid[] := ARRAY(SELECT componentuuid FROM components where componentdescription != 'Root component');
   BEGIN
       FOREACH vComponentUUID in array vComponentUUIDs
       LOOP
           perform public.createcomponentstechnologies(vComponentUUID, '{Juice Mixer}', null, '{TechnologyAdmin}');
           perform public.createcomponentattribute(vComponentUUID, '{juice}', null, '{TechnologyAdmin}');
       END LOOP;
   END;


   --Drop deprecated functions
   DROP FUNCTION public.getallcomponents(uuid, text, text[]);
   --Create new getallcomponents
   CREATE OR REPLACE FUNCTION public.getallcomponents(
        vuseruuid uuid,
        vlanguagecode text DEFAULT 'en'::text,
        vtechnologies text[] DEFAULT NULL::text[],
        vattributes text[] DEFAULT NULL::text[],
        vroles text[] DEFAULT NULL::text[])
        RETURNS TABLE   (
                        componentuuid uuid,
                        componentname text,
                        componentparentuuid integer,
                        componentdescription character varying,
                        displaycolor text,
                        createdat timestamp with time zone,
                        createdby uuid,
                        updatedat timestamp with time zone,
                        updatedby uuid
                        )
       LANGUAGE 'plpgsql'

   AS $BODY$

   	DECLARE
   		vFunctionName varchar := 'GetAllComponents';
   		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));
   	BEGIN

   	IF(vIsAllowed) THEN

   	RETURN QUERY (SELECT  cp.componentuuid,
                  		tl.value::text as componentname,
                  		cp.componentparentid,
                  		cp.componentdescription,
                  		cp.displaycolor,
                  		cp.createdat  at time zone 'utc',
                  		cp.createdby,
                  		cp.updatedat  at time zone 'utc',
                  		cp.updatedby
                  		FROM Components cp
                  		JOIN translations tl ON
                  		cp.textid = tl.textid
                  		JOIN languages la ON
                  		tl.languageid = la.languageid
                  		AND la.languagecode = vlanguagecode
                  		LEFT OUTER JOIN componentstechnologies cote ON
                  		cote.componentid = cp.componentid
                  		LEFT OUTER JOIN technologies te ON
                  		te.technologyid = cote.technologyid
                  		LEFT OUTER JOIN componentsattribute coat ON
                  		coat.componentid = cp.componentid
                  		LEFT OUTER JOIN attributes atr ON
                  		atr.attributeid = coat.attributeid
                  		WHERE componentparentid IS NOT NULL
                        AND (te.technologyuuid = ANY (vtechnologies::uuid[]) OR vtechnologies IS NULL)
                        AND (atr.attributeuuid = ANY (vattributes::uuid[]) OR vattributes IS NULL)
   		);

   	ELSE
   		 RAISE EXCEPTION '%', 'Insufficiency rigths';
   		 RETURN;
   	END IF;

   	END;


   $BODY$;

-- #########################################################################################################################################


    DROP FUNCTION public.createcomponent(uuid, character varying, character varying, text, uuid, text[]);

    CREATE OR REPLACE FUNCTION public.createcomponent(
        vcomponentparentuuid uuid,
        vtextid integer,
        vcomponentdescription character varying,
        vdisplaycolor text,
        vcreatedby uuid,
        vroles text[])
        RETURNS TABLE(componentuuid uuid, componentparentuuid uuid, componentdecription character varying, createdat timestamp with time zone, createdby uuid)
        LANGUAGE 'plpgsql'

    AS $BODY$

        #variable_conflict use_column
        DECLARE
            vComponentID integer := (select nextval('ComponentID'));
            vComponentUUID uuid := (select uuid_generate_v4());
            vComponentParentID integer := (select componentid from components where componentuuid = vComponentParentUUID);
            vFunctionName varchar := 'CreateComponent';
            vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
        BEGIN

        IF(vIsAllowed) THEN
            INSERT INTO components(ComponentID, ComponentUUID, ComponentParentID, textid, ComponentDescription, DisplayColor, CreatedBy, CreatedAt)
            VALUES(vComponentID, vComponentUUID, vComponentParentID, vTextid, vComponentDescription, vDisplayColor, vCreatedBy, now());
        ELSE
            RAISE EXCEPTION '%', 'Insufficiency rigths';
            RETURN;
        END IF;
        -- Begin Log if success
        perform public.createlog(0,'Created Component sucessfully', 'CreateComponent',
                                'ComponentID: ' || cast(vComponentID as varchar) || ', '
                                || 'ComponentParentID: ' || cast(vComponentParentID as varchar)
                                || ', ComponentDescription: '
                                || vComponentDescription
                                || ', CreatedBy: '
                                || cast(vCreatedBy as varchar));

        -- End Log if success
        -- Return
        RETURN QUERY (
        select
            co.ComponentUUID,
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
                                || ', ComponentDescription: '
                                || vComponentDescription
                                || ', CreatedBy: '
                                || cast(vCreatedBy as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateComponent';
        RETURN;
        END;


    $BODY$;

    CREATE SEQUENCE TextID start with 150;

    select public.createtechnology(
        'ultimaker',
        null,
        '67e6ceb8-c633-47a9-8c69-f55228cb9676',
        '{TechnologyAdmin}');

    CREATE OR REPLACE FUNCTION public.createtext(
        vlanguageid int,
        vText text,
        vContext text)
        RETURNS integer
        LANGUAGE 'plpgsql'
    AS $BODY$
        DECLARE vTranslationid integer := (select nextval('TranslationID'));
                vTextId integer := (select nextval('TextID'));
        BEGIN
            insert into translations (translationid, languageid, textid, value, context) values
            (vTranslationid, vLanguageid, vTextId, vText, vContext);

            RETURN vTextId;

        END
    $BODY$;

    DROP FUNCTION public.setcomponent(character varying, character varying, character varying, text[], text[], uuid, text[]);

    CREATE OR REPLACE FUNCTION public.setcomponent(
        vcomponentname character varying,
        vcomponentparentname character varying,
        vcomponentdescription character varying,
        vcontext text,
        vlanguage text,
        vattributelist text[],
        vtechnologylist text[],
        vcreatedby uuid,
        vroles text[])
        RETURNS TABLE(componentuuid uuid, componentparentuuid uuid)
        LANGUAGE 'plpgsql'

    AS $BODY$

    #variable_conflict use_column
    DECLARE
        vAttributeName text;
        vTechName text;
        vCompID integer;
        vCompUUID uuid;
        vComponentParentUUID uuid;
        vFunctionName varchar := 'SetComponent';
        vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
        vLanguageID integer := (select languageid from languages where languagecode = vlanguage);
        vTextID integer;
    BEGIN

        IF(vIsAllowed) THEN
            -- Is none ParentComponent -> set Root as Parent
            if (vcomponentparentname is null) then
                vcomponentparentname := 'Root';
            END if;

            vComponentParentUUID :=   (SELECT c.componentuuid
                                FROM components c
                                JOIN translations t
                                ON t.textid = c.textid
                                WHERE t.value = vComponentParentName
                                LIMIT 1);

            IF (vComponentParentUUID is NULL) THEN
                vComponentParentUUID := (SELECT componentuuid FROM components WHERE textid = 1);
            END IF;

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

                -- Create new translation
                perform public.createtext(vLanguageid, vcomponentname, vContext);
                vTextID := (select currval('TextID'));
                -- Create new Component
                perform public.createcomponent(vComponentParentUUID,vTextID, vComponentdescription, null, vCreatedby, vRoles);
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
                        'ComponentID: ' || cast(vCompID as varchar) || ', componentdescription: ' || vComponentDescription
                        || ', CreatedBy: ' || cast(vCreatedBy as varchar));
        ELSE
            RAISE EXCEPTION '%', 'Insufficiency rigths';
            RETURN;
        END IF;
        -- End Log if success
        -- Return UserID
        RETURN QUERY (
            select 	co.ComponentUUID,
                cs.ComponentUUID as componentParentUUID
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
            group by co.ComponentUUID,
                cs.ComponentUUID, co.ComponentDescription, co.createdat
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,'SetComponent',
                                'ComponentID: ' || cast(vCompID as varchar) || ', componentdescription: ' || vComponentDescription
                                || ', CreatedBy: ' || cast(vCreatedBy as varchar));
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetComponent';
        RETURN;
    END;


$BODY$;

----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;