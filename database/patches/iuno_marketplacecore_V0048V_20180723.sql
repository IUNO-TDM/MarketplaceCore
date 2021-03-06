﻿--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-07-23
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
--  Missing function to update technology data table
-- 	2) Which Git Issue Number is this patch solving?
--  #206 #207
-- 	3) Which changes are going to be done?
-- Create Function UpdateTechnologyData and update create and get technologydata functions
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0048V_20180723';
		PatchNumber int 		 	 := 0048;
		PatchDescription varchar 	 := 'Create Function UpdateTechnologyData';
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
    vPatchNumber int := 0048;
BEGIN
-- #########################################################################################################################################


    --- update technology data table add and remove columns
    ALTER TABLE TechnologyData ADD COLUMN isFile boolean DEFAULT false NOT NULL;
    ALTER TABLE TechnologyData ADD COLUMN filePath CHARACTER VARYING;
    ALTER TABLE TechnologyData DROP COLUMN technologyDataThumbnail;
    --

    --- create new function to update technology data entries
    CREATE OR REPLACE FUNCTION public.updatetechnologydata(
        vTechnologyDataUUID uuid,
        vTechnologyData character varying,
        vIsFile boolean,
        vFilePath character varying,
        vUserUUID uuid,
        vRoles text[] DEFAULT NULL::text[])
        RETURNS VOID
        LANGUAGE 'plpgsql'

        AS $BODY$

            DECLARE
                vFunctionName varchar := 'UpdateTechnologyData';
                vFunctionID int := (select functionid from functions where functionname = vFunctionName);
                vOwnerUUID uuid := (select createdby from technologydata where technologydatauuid = vTechnologyDataUUID);
                vCheckOwnership boolean := (select public.checkOwnership(vFunctionName, vUserUUID, vOwnerUUID, vRoles));
                vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

            BEGIN

                IF(vIsAllowed) THEN

                    UPDATE technologydata
                    SET technologydata = COALESCE(vTechnologyData, technologydata),
                        isfile = COALESCE(vIsFile, isfile),
                        filepath = COALESCE(vFilePath, filepath),
                        updatedAt = now(),
                        updatedby = vUserUUID
                    WHERE technologydatauuid = vTechnologyDataUUID
                    AND createdby = vUserUUID;

                ELSE
                    RAISE EXCEPTION '%', 'Insufficiency rigths';
                END IF;

            END;

        $BODY$;

    INSERT INTO functions (functionid, functionname) VALUES ((SELECT nextval('functionid')),'UpdateTechnologyData');
    perform SetPermission('{TechnologyDataOwner}','UpdateTechnologyData',NULL,'{Admin}');
    UPDATE rolespermissions SET CheckOwnership = TRUE WHERE functionid = (SELECT functionid FROM functions WHERE functionname = 'UpdateTechnologyData');

    --- update create function

    DROP FUNCTION public.createtechnologydata(character varying, character varying, character varying, integer, integer, uuid, text, character varying, uuid, text[]);

    CREATE OR REPLACE FUNCTION public.createtechnologydata(
    	vtechnologydataname character varying,
    	vtechnologydata character varying,
    	vtechnologydatadescription character varying,
    	vlicensefee integer,
    	vproductcode integer,
    	vtechnologyuuid uuid,
    	vtechnologydataimgref text,
    	vbackgroundcolor character varying,
    	visfile boolean,
        vfilepath character varying,
    	vcreatedby uuid,
    	vroles text[])
        RETURNS TABLE (technologydatauuid uuid)
        LANGUAGE 'plpgsql'

        AS $BODY$

            #variable_conflict use_column
            DECLARE 	vTechnologyDataID integer := (select nextval('TechnologyDataID'));
            vTechnologyDataUUID uuid := (select uuid_generate_v4());
            vTechnologyID integer := (select technologyid from technologies where technologyuuid = vTechnologyUUID);
            vFunctionName varchar := 'CreateTechnologyData';
            vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

            BEGIN

                IF (vIsFile IS NULL) THEN
                    vIsFile = FALSE;
                END IF;

                IF(vIsAllowed) THEN
                    INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, ProductCode, TechnologyID, technologydataimgref, BackgroundColor, isFile, filePath, CreatedBy, CreatedAt)
                    VALUES(vTechnologyDataID, vTechnologyDataUUID, vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, vTechnologyID, vtechnologydataimgref, vBackgroundColor, vIsFile, vFilePath, vCreatedBy, now());
                ELSE
                    RAISE EXCEPTION '%', 'Insufficiency rigths';
                    RETURN;
                END IF;

                RETURN QUERY (SELECT technologydatauuid FROM technologydata WHERE technologydataid = vTechnologyDataID);
            END;

        $BODY$;

    --- update set function

    DROP FUNCTION public.settechnologydata(character varying, character varying, character varying, uuid, integer, integer, text[], text[], text, character varying, uuid, text[]);

    CREATE OR REPLACE FUNCTION public.settechnologydata(
        vtechnologydataname character varying,
        vtechnologydata character varying,
        vtechnologydatadescription character varying,
        vtechnologyuuid uuid,
        vlicensefee integer,
        vproductcode integer,
        vtaglist text[],
        vcomponentlist text[],
        vtechnologydataimgref text,
        vbackgroundcolor character varying,
        visfile boolean,
        vfilepath character varying,
        vcreatedby uuid,
        vroles text[])
        RETURNS TABLE(technologydatauuid uuid)
        LANGUAGE 'plpgsql'

        AS $BODY$
            #variable_conflict use_column
            DECLARE 	vCompUUID uuid;
                        vTagName text;
                        vTechnologyDataID int;
                        vTechnologyDataUUID uuid;
                        vTechnologyID integer := (select technologyID from technologies where technologyUUID = vTechnologyUUID);
                        vFunctionName varchar := 'SetTechnologyData';
                        vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
                        vAlreadExists integer := (select 1 from technologydata where technologydataname = vtechnologydataname and deleted is null);
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
                        perform public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, vTechnologyUUID, vtechnologydataimgref, vBackgroundColor, vIsFile, vFilePath, vCreatedBy, vRoles);
                        vTechnologyDataID := (select currval('TechnologyDataID'));
                        vTechnologyDataUUID := (select technologydatauuid from technologydata where technologydataid = vTechnologyDataID);

                        -- Create relation from Components to TechnologyData
                        perform public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList, vCreatedBy, vRoles);

                        -- Create relation from Tags to TechnologyData
                        IF (vTagList != null) THEN
                            perform public.CreateTechnologyDataTags(vTechnologyDataUUID, vTagList, CreatedBy, vRoles);
                        END IF;
                    ELSE
                        RAISE EXCEPTION '%', 'Technologydata already exists';
                        RETURN;

                    END IF;
                ELSE
                     RAISE EXCEPTION '%', 'Insufficiency rigths';
                     RETURN;
                END IF;

            -- End Log if success
            -- Return vTechnologyDataUUID
            RETURN QUERY (SELECT technologydatauuid FROM technologydata WHERE technologydataid = vTechnologyDataID);
            END;

        $BODY$;

    --- update get by id
    DROP FUNCTION public.gettechnologydatabyid(uuid, uuid, text[]);

    CREATE OR REPLACE FUNCTION public.gettechnologydatabyid(
    	vtechnologydatauuid uuid,
    	vuseruuid uuid,
    	vroles text[])
        RETURNS TABLE(  technologydatauuid uuid,
                        technologyuuid uuid,
                        technologydataname character varying,
                        technologydatadescription character varying,
                        productcode integer,
                        licensefee bigint,
                        technologydataimgref character varying,
                        backgroundcolor character varying,
                        isfile boolean,
                        filepath character varying,
                        createdat timestamp with time zone,
                        createdby uuid,
                        updatedat timestamp with time zone,
                        updatedyby uuid
                        )
        LANGUAGE 'plpgsql'

        AS $BODY$

            DECLARE
                vFunctionName varchar := 'GetTechnologyDataById';
                vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

            BEGIN

            IF(vIsAllowed) THEN

            RETURN QUERY (	SELECT 	td.technologydatauuid,
                        tc.technologyuuid,
                        td.technologydataname,
                        td.technologydatadescription,
                        td.productcode,
                        td.licensefee,
                        td.technologydataimgref,
                        td.backgroundcolor,
                        td.isfile,
                        td.filePath,
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

        $BODY$;

    --- update get by name
    DROP FUNCTION public.gettechnologydatabyname(character varying, uuid, text[]);

    CREATE OR REPLACE FUNCTION public.gettechnologydatabyname(
    	vtechnologydataname character varying,
    	vuseruuid uuid,
    	vroles text[])
        RETURNS TABLE(  technologydatauuid uuid,
                        technologyuuid uuid,
                        technologydataname character varying,
                        technologydatadescription character varying,
                        productcode integer,
                        licensefee bigint,
                        technologydataimgref character varying,
                        backgroundcolor character varying,
                        isfile boolean,
                        filepath character varying,
                        createdat timestamp with time zone,
                        createdby uuid,
                        updatedat timestamp with time zone,
                        updatedby uuid
                        )
        LANGUAGE 'plpgsql'

        AS $BODY$

            DECLARE
                vFunctionName varchar := 'GetTechnologyDataByName';
                vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

            BEGIN

            IF(vIsAllowed) THEN

                RETURN QUERY (SELECT 	td.technologydatauuid,
                        tc.technologyuuid,
                        td.technologydataname,
                        td.technologydatadescription,
                        td.productcode,
                        td.licensefee,
                        td.technologydataimgref,
                        td.backgroundcolor,
                        td.isfile,
                        td.filePath,
                        td.createdat  at time zone 'utc',
                        td.createdby,
                        td.updatedat  at time zone 'utc',
                        td.updatedBy
                    FROM TechnologyData td
                    join technologies tc
                    on td.technologyid = tc.technologyid
                    where lower(td.technologydataname) = lower(vTechnologyDataName)
                    and td.deleted is null
                    AND (NOT td.isfile OR td.filepath IS NOT NULL)
                );

            ELSE
                 RAISE EXCEPTION '%', 'Insufficiency rigths';
                 RETURN;
            END IF;

            END;

        $BODY$;

    --- update get by offer request

    DROP FUNCTION public.gettechnologydatabyofferrequest(uuid, uuid, text[]);

    CREATE OR REPLACE FUNCTION public.gettechnologydatabyofferrequest(
    	vofferrequestuuid uuid,
    	vuseruuid uuid,
    	vroles text[])
        RETURNS TABLE(  technologydatauuid uuid,
                        technologyuuid uuid,
                        technologydataname character varying,
                        technologydatadescription character varying,
                        licensefee bigint,
                        technologydataimgref character varying,
                        backgroundcolor character varying,
                        isfile boolean,
                        filepath character varying,
                        createdat timestamp with time zone,
                        createdby uuid,
                        updatedat timestamp with time zone,
                        useruuid uuid
                        )
        LANGUAGE 'plpgsql'

    AS $BODY$

    	DECLARE
    		vFunctionName varchar := 'GetTechnologyDataByOfferRequest';
    		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

    	BEGIN

    	IF(vIsAllowed) THEN

        	RETURN QUERY (SELECT 	technologydatauuid,
    			tc.technologyuuid,
    			td.technologydataname,
    			technologydatadescription,
    			licensefee,
    			technologydataimgref,
    			backgroundcolor,
    			td.isfile,
    			td.filepath,
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
    			AND (NOT td.isfile OR td.filepath IS NOT NULL)
    		);
    	ELSE
    		 RAISE EXCEPTION '%', 'Insufficiency rigths';
    		 RETURN;
    	END IF;

    	END;

    $BODY$;

    --- update by params

    DROP FUNCTION public.gettechnologydatabyparams(text[], uuid, character varying, uuid, integer[], uuid, text, text[]);

    CREATE OR REPLACE FUNCTION public.gettechnologydatabyparams(
    	vcomponents text[],
    	vtechnologyuuid uuid,
    	vtechnologydataname character varying,
    	vowneruuid uuid,
    	vproductcodes integer[],
    	vuseruuid uuid,
    	vlanguagecode text DEFAULT 'en'::text,
    	vroles text[] DEFAULT NULL::text[])
        RETURNS TABLE(result json)
        LANGUAGE 'plpgsql'

        AS $BODY$

            DECLARE
                vFunctionName varchar := 'GetTechnologyDataByParams';
                vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));
                vTechnologyID int := (select technologyid from technologies where technologyuuid = vTechnologyUUID);

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
                    select co.componentuuid, co.componentid, tl.value as componentname,
                    case when t.* is null then '[]' else array_to_json(array_agg(t.*)) end as attributes from att t
                    join componentsattribute ca on t.attributeid = ca.attributeid
                    right outer join components co on co.componentid = ca.componentid
                    join translations tl on
                    co.textid = tl.textid
                    join languages la on
                    tl.languageid = la.languageid
                    and la.languagecode = vlanguagecode
                    group by tl.value, co.componentid, co.componentuuid, t.*
                    ),
                    techData as (
                        select td.technologydatauuid,
                            td.technologydataname,
                            tt.technologyuuid,
                            td.licensefee,
                            td.productcode,
                            td.technologydatadescription,
                            td.technologydataimgref,
                            td.backgroundcolor,
                            td.isfile,
                            td.filepath,
                            td.createdat at time zone 'utc',
                            td.CreatedBy,
                            td.updatedat at time zone 'utc',
                            td.UpdatedBy,
                            array_to_json(array_agg(co.*)) componentlist
                        from comp co join technologydatacomponents tc
                        on co.componentid = tc.componentid
                        join technologydata td on
                        td.technologydataid = tc.technologydataid
                        join components cm on cm.componentid = co.componentid
                        join technologies tt on
                        tt.technologyid = td.technologyid
                        where (vOwnerUUID is null OR td.createdby = vOwnerUUID)
                        and td.deleted is null
                        and (vProductCodes is null or td.productcode = any (vProductCodes::int[]))
                        group by td.technologydatauuid,
                            td.technologydataname,
                            tt.technologyuuid,
                            td.licensefee,
                            td.productcode,
                            td.technologydatadescription,
                            td.technologydataimgref,
                            td.backgroundcolor,
                            td.isfile,
                            td.filepath,
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
                        AND (NOT td.isfile OR td.filepath IS NOT NULL)
                        AND td.technologyid = vTechnologyID
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


        $BODY$;

    --- update get with content

    DROP FUNCTION public.gettechnologydatawithcontent(uuid, uuid, uuid, uuid, text[]);

    CREATE OR REPLACE FUNCTION public.gettechnologydatawithcontent(
    	vtechnologydatauuid uuid,
    	vofferuuid uuid,
    	vclientuuid uuid,
    	vuseruuid uuid,
    	vroles text[])
        RETURNS TABLE(  technologydatauuid uuid,
                        technologydata character varying,
                        productcode integer,
                        isfile boolean,
                        filepath character varying
                        )
        LANGUAGE 'plpgsql'

        AS $BODY$

            DECLARE
                vFunctionName varchar := 'GetTechnologyDataWithContent';
                vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

            BEGIN

            IF(vIsAllowed) THEN

            RETURN QUERY (
                            SELECT td.technologydatauuid,td.technologydata,td.productcode,td.isfile,td.filepath
                            FROM offer o
                            JOIN transactions tr
                            ON tr.offerid = o.offerid
                            JOIN offerrequestitems ori
                            ON ori.offerrequestid = tr.offerrequestid
                            JOIN technologydata td
                            ON td.technologydataid = ori.technologydataid
                            WHERE o.offeruuid = vOfferUUID
                            AND td.technologydatauuid = vTechnologyDataUUID
                            AND td.deleted IS NULL
                            AND tr.licenseorderid IS NOT NULL
                            AND tr.buyerid = vClientUUID
                            AND tr.createdby = vUserUUID
            );

            ELSE
                 RAISE EXCEPTION '%', 'Insufficiency rigths';
                 RETURN;
            END IF;

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