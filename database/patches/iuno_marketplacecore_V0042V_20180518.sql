--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-05-18
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
--  New localization feature for components
-- 	2) Which Git Issue Number is this patch solving?
-- #179
-- 	3) Which changes are going to be done?
-- Update components functions to provide localization functionality
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0042V_20180518';
		PatchNumber int 		 	 := 0042;
		PatchDescription varchar 	 := 'Update components functions to provide localization functionality';
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
			vPatchNumber int := 0042;
		BEGIN
-- #########################################################################################################################################

   --Step 1: Drop deprecated functions
   DROP FUNCTION public.getallcomponents(uuid, text[]);
   DROP FUNCTION public.getcomponentbyid(uuid, uuid, text[]);
   DROP FUNCTION public.getcomponentbyname(character varying, uuid, text[]); -- This function won't be replace
   DROP FUNCTION public.getcomponentsbytechnology(uuid, uuid, text[]); -- This function won't be replace
   DROP FUNCTION public.getcomponentsfortechnologydataid(uuid, uuid, text[]);
   DROP FUNCTION public.gettechnologydatabyparams(text[], uuid, character varying, uuid, uuid, text[]);
   DROP FUNCTION public.gettechnologydataforuser(uuid, uuid, text[]);
   DROP FUNCTION public.gettopcomponents(timestamp with time zone, timestamp with time zone, integer, uuid, text[]);

   --Step 2: create new getallcomponents
   CREATE OR REPLACE FUNCTION public.getallcomponents(
   	vuseruuid uuid,
   	vlanguagecode text DEFAULT 'en'::text,
   	vroles text[] DEFAULT NULL::text[])
       RETURNS TABLE(componentuuid uuid, componentname text, componentparentuuid integer, componentdescription character varying, displaycolor text, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   	DECLARE
   		vFunctionName varchar := 'GetAllComponents';
   		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));
   		vRoot varchar := 'Root';


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
   						WHERE  tl.value != vRoot
   		);

   	ELSE
   		 RAISE EXCEPTION '%', 'Insufficiency rigths';
   		 RETURN;
   	END IF;

   	END;


   $BODY$;

   --Step3: Create new getcomponentbyid function
   CREATE OR REPLACE FUNCTION public.getcomponentbyid(
   	vcompuuid uuid,
   	vuseruuid uuid,
   	vlanguagecode text DEFAULT 'en'::text,
   	vroles text[] DEFAULT NULL::text[])
       RETURNS TABLE(componentuuid uuid, componentname text, componentparentuuid uuid, componentdescription character varying, displaycolor text, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   	DECLARE
   		vFunctionName varchar := 'GetComponentById';
   		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

   	BEGIN

   	IF(vIsAllowed) THEN

   	RETURN QUERY (SELECT  cp.componentuuid,
   				tl.value::text as componentname,
   				cs.componentuuid,
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
   				LEFT OUTER JOIN components cs on
   				cp.componentparentid = cs.componentid
   				WHERE cp.componentuuid = vCompUUID
   		  );
   	ELSE
   		 RAISE EXCEPTION '%', 'Insufficiency rigths';
   		 RETURN;
   	END IF;

   	END;


   $BODY$;

   --Step4: Create new getcomponentsfortechnologydataid funciton
   CREATE OR REPLACE FUNCTION public.getcomponentsfortechnologydataid(
   	vtechnologydatauuid uuid,
   	vuseruuid uuid,
   	vlanguagecode text DEFAULT 'en'::text,
   	vroles text[] DEFAULT NULL::text[])
       RETURNS TABLE(componentuuid uuid, componentname text, componentparentuuid uuid, componentparentname text, componentdescription character varying, displaycolor text, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   	DECLARE
   		vFunctionName varchar := 'GetComponentsForTechnologyDataId';
   		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

   	BEGIN

   	IF(vIsAllowed) THEN

   	RETURN QUERY (with comps as (
   	select 	co.componentuuid, co.componentid, co.textid as comptextid, co.componentDescription,
   			co.displaycolor, co.createdat, co.updatedat,
   			cp.componentuuid as parentuuid, cp.componentid as componentparentid, cp.textid as parenttextid
   	from components co join components cp
   	on co.componentparentid = cp.componentid
   ), texts as (
   	select tl.textid, tl.value from translations tl
   	join languages la on tl.languageid = la.languageid
   	and la.languagecode = vlanguagecode
   )
   select	co.componentuuid,
   				tx.value::text as componentname,
   				co.parentuuid as ComponentParentUUID,
   				tp.value::text as ComponentParentName,
   				co.componentDescription,
   				co.displaycolor,
   				co.createdat at time zone 'utc',
   				td.CreatedBy,
   				co.updatedat at time zone 'utc',
   				td.UpdatedBy
   			from technologydata td
   			join technologydatacomponents tc
   			on td.technologydataid = tc.technologydataid
   			join comps co on
   			co.componentid = tc.componentid
   			join texts tx on
   			co.comptextid = tx.textid
   			join texts tp on
   			co.parenttextid = tp.textid
   			where td.technologydatauuid = vTechnologyDataUUID
   		);
   	ELSE
   		 RAISE EXCEPTION '%', 'Insufficiency rigths';
   		 RETURN;
   	END IF;

   	END;


   $BODY$;

   --Step 5: Create new gettechnologydatabyparams funciton
   CREATE OR REPLACE FUNCTION public.gettechnologydatabyparams(
   	vcomponents text[],
   	vtechnologyuuid uuid,
   	vtechnologydataname character varying,
   	vowneruuid uuid,
   	vuseruuid uuid,
   	vlanguagecode text DEFAULT 'en'::text,
   	vroles text[] DEFAULT NULL::text[])
       RETURNS TABLE(result json)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   	DECLARE
   		vFunctionName varchar := 'GetTechnologyDataByParams';
   		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

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
   					td.technologydata,
   					td.licensefee,
   					td.productcode,
   					td.technologydatadescription,
   					td.technologydatathumbnail,
   					td.technologydataimgref,
   					td.backgroundcolor,
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
   				group by td.technologydatauuid,
   					td.technologydataname,
   					tt.technologyuuid,
   					td.technologydata,
   					td.licensefee,
   					td.productcode,
   					td.technologydatadescription,
   					td.technologydatathumbnail,
   					td.technologydataimgref,
   					td.backgroundcolor,
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

   --Step 6: Create new gettechnologydataforuser funciton
   CREATE OR REPLACE FUNCTION public.gettechnologydataforuser(
   	vuseruuid uuid,
   	vinquirerid uuid,
   	vlanguagecode text DEFAULT 'en'::text,
   	vroles text[] DEFAULT NULL::text[])
       RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, revenue bigint, licensefee bigint, componentlist text[], technologydatadescription character varying)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   				DECLARE
   					vFunctionName varchar := 'GetTechnologyDataForUser';
   					vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

   				BEGIN

   				IF(vIsAllowed) THEN

   				RETURN QUERY (	with revenue as (select td.technologydataname, (sum(td.licensefee*ri.amount))::bigint as revenue from transactions ts
   						join licenseorder lo
   						on ts.licenseorderid = lo.licenseorderid
   						join offerrequest oq
   						on oq.offerrequestid = ts.offerrequestid
   						join offerrequestitems ri
   						on oq.offerrequestid = ri.offerrequestid
   						join technologydata td
   						on ri.technologydataid = td.technologydataid
   						where td.createdby = vUserUUID
   						group by td.technologydataname
   					), result as (
   					select 	td.technologydatauuid,
   						td.technologydataname,
   						coalesce(rv.revenue,0)::bigint as revenue,
   						td.licensefee,
   						array_agg(tl.value)::text[] as componentlist,
   						td.technologydatadescription
   					from technologydata td
   					left outer join revenue rv on td.technologydataname = rv.technologydataname
   					join technologydatacomponents tc
   					on tc.technologydataid = td.technologydataid
   					join components co
   					on tc.componentid = co.componentid
   					JOIN translations tl ON
   					cp.textid = tl.textid
   					JOIN languages la ON
   					tl.languageid = la.languageid
   					AND la.llanguagecode = vlanguagecode
   					where (vuseruuid is null or td.createdby = vuseruuid)
   					and td.deleted is null
   					group by td.technologydatauuid, td.technologydataname, td.licensefee, rv.revenue, td.technologydatadescription)
   					select  r.technologydatauuid,
   						r.technologydataname,
   						sum(r.revenue)::bigint as revenue,
   						r.licensefee::bigint,
   						r.componentlist,
   						r.technologydatadescription
   					from result r
   					group by r.technologydatauuid,
   						r.technologydataname,
   						r.licensefee,
   						r.componentlist,
   						r.technologydatadescription
   					);

   				ELSE
   					 RAISE EXCEPTION '%', 'Insufficiency rigths';
   					 RETURN;
   				END IF;

   				END;

   $BODY$;

   --Step 7: Create new gettopcomponents funciton
   CREATE OR REPLACE FUNCTION public.gettopcomponents(
   	vfrom timestamp with time zone,
   	vto timestamp with time zone,
   	vlimit integer,
   	vuseruuid uuid,
   	vlanguagecode text DEFAULT 'en'::text,
   	vroles text[] DEFAULT NULL::text[])
       RETURNS TABLE(componentname character varying, amount integer)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   	DECLARE
   		vFunctionName varchar := 'GetTopComponents';
   		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));

   	BEGIN

   	IF(vIsAllowed) THEN
   	RETURN QUERY (
   		with activatedLincenses as(
   				select tl.value as componentname, activatedat from licenseorder lo
   				join offer of on lo.offerid = of.offerid
   				join paymentinvoice pi on
   				of.paymentinvoiceid = pi.paymentinvoiceid
   				join offerrequest oq on
   				pi.offerrequestid = oq.offerrequestid
   				join offerrequestitems ri on
   				oq.offerrequestid = ri.offerrequestid
   				join technologydata td on
   				ri.technologydataid = td.technologydataid
   				join technologydatacomponents tc on
   				tc.technologydataid = td.technologydataid
   				join components co on
   				co.componentid = tc.componentid
   				JOIN translations tl ON
   						cp.textid = tl.textid
   						JOIN languages la ON
   						tl.languageid = la.languageid
   						AND la.languagecode = vlanguagecode
   			),
   		rankTable as (
   		select a.componentname, count(a.componentname) as rank from activatedLincenses a
   		where activatedat between vFrom and vTo
   		group by a.componentname)
   		select r.componentname::varchar(250), rank::integer from rankTable r
   		order by rank desc limit vLimit);

   	ELSE
   		 RAISE EXCEPTION '%', 'Insufficiency rigths';
   		 RETURN;
   	END IF;

   	END;
   $BODY$;

-- #########################################################################################################################################
----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;