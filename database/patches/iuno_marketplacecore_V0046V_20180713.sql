--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-07-13
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
--  To handle with different technologies on the reports / dashboard
-- 	2) Which Git Issue Number is this patch solving?
--
-- 	3) Which changes are going to be done?
--  Update reports functions to handle different technologies
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0046V_20180713';
		PatchNumber int 		 	 := 0046;
		PatchDescription varchar 	 := 'Update reports functions to handle different technologies';
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
			vPatchNumber int := 0046;
		BEGIN
-- #########################################################################################################################################

   DROP FUNCTION public.getrevenue(timestamp with time zone, timestamp with time zone, uuid, uuid, text[]);
   DROP FUNCTION public.getrevenueperdayforuser(uuid, text[]);  -- This function is not used anymore
   DROP FUNCTION public.getrevenuehistory(timestamp with time zone, timestamp with time zone, uuid, text[]);
   DROP FUNCTION public.gettoptechnologydata(timestamp with time zone, timestamp with time zone, integer, uuid, text[]);
   DROP FUNCTION public.gettotalrevenue(timestamp with time zone, timestamp with time zone, text, uuid, text[]);
   DROP FUNCTION public.gettotaluserrevenue(timestamp with time zone, timestamp with time zone, uuid, text[]);
   DROP FUNCTION public.gettechnologydatahistory(timestamp with time zone, timestamp with time zone, uuid, text[]);
   DROP FUNCTION public.getactivatedlicensescountforuser(uuid, uuid, text[]);

   CREATE OR REPLACE FUNCTION public.getrevenue(
   	vfrom timestamp with time zone,
   	vto timestamp with time zone,
   	vtechnologydatauuid uuid,
   	vtechnologyuuid uuid,
   	vcreatedby uuid,
   	vroles text[])
       RETURNS TABLE(year text, month text, day text, hour text, technologydatauuid uuid, amount integer, revenue bigint, average bigint)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   			DECLARE
   				vFunctionName varchar := 'GetRevenue';
   				vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));
   				vOwnerUUID uuid := (select case when (vtechnologydatauuid is null) then vCreatedby else (select t.createdby from technologydata t where t.technologydatauuid = vtechnologydatauuid) end);
   				vCheckOwnership boolean := (select public.checkOwnership(vFunctionName, vCreatedby, vOwnerUUID, vRoles));

   			BEGIN

   			IF(vIsAllowed) THEN
   				IF (vCheckOwnership = false) THEN vCreatedBy = null; END IF;

   			RETURN QUERY ( with revenue as (
   				select  case when (to_char(activatedat,'YYYY') is null) then '0' else to_char(activatedat,'YYYY') end as Year,
   					case when (to_char(activatedat,'MM') is null) then '0' else to_char(activatedat,'MM') end as Month,
   					case when (to_char(activatedat,'DD') is null) then '0' else to_char(activatedat,'DD') end as Day,
   					case when (to_char(activatedat,'HH24') is null) then '0' else to_char(activatedat,'HH24') end as Hour,
   					coalesce(td.technologydatauuid,'00000000-0000-0000-0000-000000000000') as technologydatauuid,
   					sum(ri.amount) as amount,
   					(sum(td.licensefee*ri.amount))::bigint as revenue,
   					(AVG(td.licensefee*ri.amount))::bigint as average
   				from transactions ts
   					join licenseorder lo
   					on ts.licenseorderid = lo.licenseorderid
   					join offerrequest oq
   					on oq.offerrequestid = ts.offerrequestid
   					join offerrequestitems ri
   					on ri.offerrequestid = oq.offerrequestid
   					join technologydata td
   					on ri.technologydataid = td.technologydataid
   					join technologies tg
   					on td.technologyid = tg.technologyid
   					where (vcreatedby is null or td.createdby = vcreatedby)
   					and (activatedat between vFrom and vTo)
   					and (vTechnologyUUID is null or tg.technologyuuid = vTechnologyUUID)
   					group by CUBE (to_char(activatedat,'YYYY'),
   							to_char(activatedat,'MM'),
   							to_char(activatedat,'DD'),
   							to_char(activatedat,'HH24'),
   							td.technologydatauuid)
   					order by to_char(activatedat,'YYYY') asc,
   							to_char(activatedat,'MM') asc,
   							to_char(activatedat,'DD') asc,
   							to_char(activatedat,'HH24') asc,
   							td.technologydatauuid asc,
   							amount desc
   				)
   				select	r.year::text,
   					r.month::text,
   					r.day::text,
   					r.hour::text,
   					r.technologydatauuid,
   					r.Amount::integer,
   					r.Revenue::bigint,
   					r.Average::bigint
   				from revenue r
   				where (vTechnologyDataUUID is null or r.technologydatauuid = vTechnologyDataUUID)
   				);
   			ELSE
   				 RAISE EXCEPTION '%', 'Insufficiency rigths';
   				 RETURN;
   			END IF;

   			END;
   $BODY$;



   CREATE OR REPLACE FUNCTION public.getrevenuehistory(
   	vfrom timestamp with time zone,
   	vto timestamp with time zone,
   	vtechnologyuuid uuid,
   	vcreatedby uuid,
   	vroles text[])
       RETURNS TABLE(date date, technologydataname text, revenue bigint)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   			DECLARE
   				vFunctionName varchar := 'GetRevenueHistory';
   				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
   				vPublic text[] := '{Public}';

   			BEGIN

   			IF(vIsAllowed) THEN

   			RETURN QUERY (with basis as (select r.year, r.month, r.day, r.hour, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue, r.average  from public.getrevenue(
   					    vfrom,
   					    vto,
   					    null,
   						vtechnologyuuid,
   					    vcreatedby,
   					    vroles) r
   					join technologydata td on td.technologydatauuid = r.technologydatauuid
   					join technologies tg on td.technologyid = tg.technologyid
   					where r.year <> '0' and r.month <> '0' and r.day <> '0' and r.hour <> '0'
   					and r.technologydatauuid <> uuid_nil()
   					and tg.technologyuuid = vTechnologyUUID
   					order by r.year, r.month, r.day, r.hour, td.technologydatauuid),
   					benchmark as (
   					select r.year, r.month, r.day, 'Benchmark'::text as technologydataname, (r.revenue / r.amount) as revenue from public.getrevenue(
   					    vfrom,
   					    vto,
   					    null,
   						vtechnologyuuid,
   					    null,
   					    vPublic) r
   					where r.year <> '0' and r.month <> '0' and r.day <> '0' and r.hour = '0'
   					and r.technologydatauuid = uuid_nil()
   					group by r.year, r.month, r.day, r.revenue, r.amount
   					),
   					techName as (select distinct a.technologydataname
   							from basis a),
   					dates as (select distinct a.year, a.month, a.day
   							from benchmark a ),
   					allData as (select tn.technologydataname, dt.year, dt.month, dt.day
   							from techname tn, dates dt),
   					totalData as (select ad.year, ad.month, ad.day, ad.technologydataname, case when (ba.revenue is null) then 0::bigint else ba.revenue::bigint end as revenue
   						from allData ad
   						left outer join basis ba
   						on ad.year = ba.year
   						and ad.month = ba.month
   						and ad.day = ba.day
   						and ad.technologydataname = ba.technologydataname),
   					result as (
   					select to_date(t.year || '-' || t.month || '-' || t.day, 'YYYY-MM-DD') as date, t.technologydataname, t.revenue::bigint from totalData t			union all
   					select to_date(b.year || '-' || b.month || '-' || b.day, 'YYYY-MM-DD') as date, b.technologydataname, b.revenue::bigint from benchmark b)
   					select rs.date, rs.technologydataname, sum(rs.revenue)::bigint from result rs
   					group by rs.date, rs.technologydataname
   					order by rs.date asc

   				);
   			ELSE
   				 RAISE EXCEPTION '%', 'Insufficiency rigths';
   				 RETURN;
   			END IF;

   			END;
   $BODY$;



   CREATE OR REPLACE FUNCTION public.gettoptechnologydata(
   	vfrom timestamp with time zone,
   	vto timestamp with time zone,
   	vtechnologyuuid uuid,
   	vlimit integer,
   	vcreatedby uuid,
   	vroles text[])
       RETURNS TABLE(year text, month text, day text, hour text, technologydataname text, amount integer, revenue bigint)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   			DECLARE
   				vFunctionName varchar := 'GetTopTechnologyData';
   				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
   				vOwnerUUID uuid := vcreatedby;
   				vCheckOwnership boolean := (select public.checkOwnership(vFunctionName, vCreatedby, vOwnerUUID, vRoles));

   			BEGIN

   			IF(vIsAllowed) THEN
   				IF (vCheckOwnership = false) THEN vCreatedBy = null; END IF;

   			RETURN QUERY (select r.year, r.month, r.day, r.hour, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from
   					getrevenue(vFrom,
   						   vTo,
   						   null,
   						   vtechnologyuuid,
   						   vcreatedby,
   						   vRoles) r
   						   join technologydata td
   						   on td.technologydatauuid = r.technologydatauuid
   						   join technologies tg
   						   on td.technologyid = tg.technologyid
   							where r.year = '0'
   							and r.month = '0'
   							and r.day = '0'
   							and r.hour = '0'
   							and td.technologydataname <> 'Total'
   							and td.deleted is null
   						    and tg.technologyuuid = vtechnologyuuid
   						order by r.amount desc, td.technologydataname
   						limit vLimit
   				);
   				ELSE
   					 RAISE EXCEPTION '%', 'Insufficiency rigths';
   					 RETURN;
   				END IF;
   			END;


   $BODY$;

   CREATE OR REPLACE FUNCTION public.gettotalrevenue(
   	vfrom timestamp with time zone,
   	vto timestamp with time zone,
   	vtechnologyuuid uuid,
   	vdetail text,
   	vcreatedby uuid,
   	vroles text[])
       RETURNS TABLE(date date, hour text, technologydataname text, amount integer, revenue bigint)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   			DECLARE
   				vFunctionName varchar := 'GetTotalRevenue';
   				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
   				vTechnologyDataUUID uuid := (select uuid_nil())::uuid;

   			BEGIN

   			IF(vIsAllowed) THEN

   			RETURN QUERY (select  to_date(r.year || '-' || r.month || '-' || r.day, 'YYYY-MM-DD') as date, r.hour::text, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from public.getrevenue(
   					    vFrom,
   					    vTo,
   					    vTechnologyDataUUID,
   						vTechnologyUUID,
   					    vCreatedBy,
   					    vRoles) r
   					    left outer join technologydata td on
   					    td.technologydatauuid = r.technologydatauuid
   						left outer join technologies tg
   						on td.technologyid = tg.technologyid
   					    where r.year <> '0'
   					    and r.month <> '0'
   					    and r.day <> '0'
   					    and case when (vDetail = 'hour') then r.hour <> '0' else r.hour = '0' end
   						and (vtechnologyuuid is null or tg.technologyuuid = vtechnologyuuid)
   					    order by r.year asc, r.month asc, r.day asc
   				);
   			ELSE
   				 RAISE EXCEPTION '%', 'Insufficiency rigths';
   				 RETURN;
   			END IF;

   			END;


   $BODY$;

   CREATE OR REPLACE FUNCTION public.gettotaluserrevenue(
   	vfrom timestamp with time zone,
   	vto timestamp with time zone,
   	vtechnologyuuid uuid,
   	vcreatedby uuid,
   	vroles text[])
       RETURNS TABLE(date date, hour text, technologydataname text, amount integer, revenue bigint)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   			DECLARE
   				vFunctionName varchar := 'GetTotalUserRevenue';
   				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
   				vTechnologyDataUUID uuid := (select uuid_nil());
   			BEGIN

   			IF(vIsAllowed) THEN

   			RETURN QUERY (select  to_date(r.year || '-' || r.month || '-' || r.day, 'YYYY-MM-DD') as date, r.hour::text, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from public.getrevenue(
   					    vFrom,
   					    vTo,
   					    vTechnologyDataUUID,
   						null,
   					    vCreatedBy,
   					    vRoles) r
   					    left outer join technologydata td
   					    on td.technologydatauuid = r.technologydatauuid
   					    left outer join technologyuuid tg
   					    on td.technologyid = tg.technologyid
   					    where r.year = '0'
   					    and r.month = '0'
   					    and r.day = '0'
   					    and r.hour = '0'
   					    and r.technologydatauuid = vTechnologyDataUUID
   					    and (vtechnologyuuid is null or tg.technologyuuid = vtechnologyuuid)
   					    order by r.year asc, r.month asc, r.day asc
   				);
   			ELSE
   				 RAISE EXCEPTION '%', 'Insufficiency rigths';
   				 RETURN;
   			END IF;

   			END;
   $BODY$;



   CREATE OR REPLACE FUNCTION public.gettechnologydatahistory(
   	vfrom timestamp with time zone,
   	vto timestamp with time zone,
   	vtechnologyuuid uuid,
   	vcreatedby uuid,
   	vroles text[])
       RETURNS TABLE(year text, month text, day text, hour text, technologydataname text, amount integer, revenue bigint)
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
       ROWS 1000
   AS $BODY$

   			DECLARE
   				vFunctionName varchar := 'GetTechnologyDataHistory';
   				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
   				vTechnologyDataName text := 'Total';

   			BEGIN

   			IF(vIsAllowed) THEN

   			RETURN QUERY (select r.year, r.month, r.day, r.hour, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from public.getrevenue(
   					    vFrom,
   					    vTo,
   					    null,
   						vtechnologyuuid,
   					    null,
   					    vRoles) r
   					left outer join technologydata td
   					on td.technologydatauuid = r.technologydatauuid
   					left outer join technologies tg
   					on td.technologyid = tg.technologyid
   					where r.year <> '0' and r.month <> '0' and r.day <> '0' and r.hour <> '0'
   					and r.technologydatauuid <> uuid_nil()
   					and (vtechnologyuuid is null or tg.technologyuuid = vtechnologyuuid)
   				);
   			ELSE
   				 RAISE EXCEPTION '%', 'Insufficiency rigths';
   				 RETURN;
   			END IF;

   			END;
   $BODY$;

   CREATE OR REPLACE FUNCTION public.getactivatedlicensescountforuser(
   	vtechnologyuuid uuid,
   	vuseruuid uuid,
   	vinquereid uuid,
   	vroles text[])
       RETURNS integer
       LANGUAGE 'plpgsql'

       COST 100
       VOLATILE
   AS $BODY$

   				#variable_conflict use_column
   				DECLARE vFunctionName varchar := 'GetActivatedLicensesCountForUser';
   					vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

   				BEGIN

   					IF(vIsAllowed) THEN

   								RETURN (select sum(amount) from transactions ts
   									join licenseorder lo
   									on ts.licenseorderid = lo.licenseorderid
   									join offerrequest oq
   									on oq.offerrequestid = ts.offerrequestid
   									join offerrequestitems ri
   									on ri.offerrequestid = oq.offerrequestid
   									join technologydata td
   									on ri.technologydataid = td.technologydataid
   									join technologies tg
   									on td.technologyid = tg.technologyid
   									where (vuseruuid is null or td.createdby = vuseruuid)
   									and tg.technologyuuid = vtechnologyuuid
   								);

   					ELSE
   						 RAISE EXCEPTION '%', 'Insufficiency rigths';
   						 RETURN NULL;
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