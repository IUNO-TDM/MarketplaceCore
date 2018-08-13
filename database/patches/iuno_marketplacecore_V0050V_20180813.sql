--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-08-13
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
--  OfferRequest uuid is not needed to identify a payed transaction
--  Missing query to get all purchased data sets
-- 	2) Which Git Issue Number is this patch solving?
--
-- 	3) Which changes are going to be done?
--  Updating gettechnologydatawithcontent
--  Adding new function getPurchasedTechnologyDataForUser
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0050V_20180813';
		PatchNumber int 		 	 := 0050;
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
    vPatchNumber int := 0050;
BEGIN
-- #########################################################################################################################################

    DROP FUNCTION public.gettechnologydatawithcontent(uuid, uuid, uuid, uuid, text[]);

    CREATE OR REPLACE FUNCTION public.gettechnologydatawithcontent(
    	vtechnologydatauuid uuid,
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
                            WHERE td.technologydatauuid = vTechnologyDataUUID
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

----------------------------------

CREATE OR REPLACE FUNCTION public.getpurchasedtechnologydataforuser(
    	vcomponents text[],
    	vtechnologyuuid uuid,
    	vtechnologydataname character varying,
    	vowneruuid uuid,
    	vproductcodes integer[],
    	vuseruuid uuid,
    	vclientuuid uuid,
    	vlanguagecode text DEFAULT 'en'::text,
    	vroles text[] DEFAULT NULL::text[])
        RETURNS TABLE(result json)
        LANGUAGE 'plpgsql'

        AS $BODY$

            DECLARE
                vFunctionName varchar := 'GetPurchasedTechnologyDataForUser';
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
                        JOIN offerrequestitems ori ON ori.technologydataid = td.technologydataid
                        JOIN transactions tr ON ori.offerrequestid = tr.offerrequestid
                        WHERE td.deleted IS NULL
                        AND (NOT td.isfile OR td.filepath IS NOT NULL)
                        AND td.technologyid = vTechnologyID
                        AND tr.licenseorderid IS NOT NULL
                        AND tr.buyerid = vClientUUID
                        AND tr.createdby = vUserUUID
                        GROUP BY td.technologydataname

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

insert into functions (functionid, functionname) values ((select nextval('functionid')),'GetPurchasedTechnologyDataForUser');

perform public.setpermission('{MachineOperator}','GetPurchasedTechnologyDataForUser',null,'{Admin}');

update rolespermissions set CheckOwnership = false where functionid = (select functionid from functions where functionname = 'GetPurchasedTechnologyDataForUser');
----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;