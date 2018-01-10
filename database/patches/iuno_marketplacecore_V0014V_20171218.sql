--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2017-09-13
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
-- Reports data should be in satoshis / cent level
-- 	2) Which Git Issue Number is this patch solving?
--  #141
-- 	3) Which changes are going to be done?
-- Remove conversion from satoshi to bitcoin from all functions (getrevenue, getrevenuehistory, getrevenueperdayforuser,
-- gettechnologydatahistory, gettoptechnologydata, gettotalrevenue, gettotaluserrevenue)
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 := 'iuno_marketplacecore_V0014V_20171218';
		PatchNumber int 		 := 0014;
		PatchDescription varchar 	 := 'Remove conversion from satoshi to bitcoin from all functions (getrevenue, getrevenuehistory, getrevenueperdayforuser, gettechnologydatahistory, gettoptechnologydata, gettotalrevenue, gettotaluserrevenue)';
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
			vPatchNumber int := 0014;
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------
			
		alter table technologydata alter column licensefee type bigint;

		-- Drop Functions
		DROP FUNCTION public.getrevenue(timestamp with time zone, timestamp with time zone, uuid, uuid, text[]);
		DROP FUNCTION public.getrevenuehistory(timestamp with time zone, timestamp with time zone, uuid, text[]);
		DROP FUNCTION public.getrevenueperdayforuser(uuid, text[]);
		DROP FUNCTION public.gettechnologydataforuser(uuid, text[]);
		DROP FUNCTION public.gettechnologydatahistory(timestamp with time zone, timestamp with time zone, uuid, text[]);
		DROP FUNCTION public.gettoptechnologydata(timestamp with time zone, timestamp with time zone, integer, uuid, text[]);
		DROP FUNCTION public.gettotalrevenue(timestamp with time zone, timestamp with time zone, text, uuid, text[]);
		DROP FUNCTION public.gettotaluserrevenue(timestamp with time zone, timestamp with time zone, uuid, text[]);

		--##############################################################################################

		CREATE OR REPLACE FUNCTION public.getrevenue(
		    IN vfrom timestamp with time zone,
		    IN vto timestamp with time zone,
		    IN vtechnologydatauuid uuid,
		    IN vcreatedby uuid,
		    IN vroles text[])
		  RETURNS TABLE(year text, month text, day text, hour text, technologydatauuid uuid, amount integer, revenue bigint, average bigint) AS
		$BODY$

			DECLARE
				vFunctionName varchar := 'GetRevenue';
				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName)); 				
				vPublic text := (select t from unnest(vRoles) as t limit 1);

			BEGIN

			IF(vIsAllowed) THEN

			IF(vPublic = 'Public') THEN vCreatedBy := null; END IF;

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
					where (vcreatedby is null or td.createdby = vcreatedby)
					and (activatedat between vFrom and vTo)			
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
		$BODY$
		  LANGUAGE plpgsql;

		--##############################################################################################
	
		CREATE OR REPLACE FUNCTION public.getrevenuehistory(
		    IN vfrom timestamp with time zone,
		    IN vto timestamp with time zone,
		    IN vcreatedby uuid,
		    IN vroles text[])
		  RETURNS TABLE(date date, technologydataname text, revenue bigint) AS
		$BODY$

			DECLARE
				vFunctionName varchar := 'GetRevenueHistory'; 
				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));		

			BEGIN 

			IF(vIsAllowed) THEN

			RETURN QUERY (with basis as (select r.year, r.month, r.day, r.hour, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue, r.average  from public.getrevenue(
					    vfrom,
					    vto,
					    null,
					    vcreatedby,
					    vroles) r
					join technologydata td on td.technologydatauuid = r.technologydatauuid
					where r.year <> '0' and r.month <> '0' and r.day <> '0' and r.hour <> '0'
					and r.technologydatauuid <> uuid_nil()
					order by r.year, r.month, r.day, r.hour, td.technologydatauuid),
					benchmark as (
					select r.year, r.month, r.day, 'Benchmark'::text as technologydataname, (r.revenue / r.amount) as revenue from public.getrevenue(
					    vfrom,
					    vto,
					    null,
					    null,
					    vroles) r 
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
		$BODY$
		  LANGUAGE plpgsql;

		--##############################################################################################

		CREATE OR REPLACE FUNCTION public.getrevenueperdayforuser(
		    IN vuseruuid uuid,
		    IN vroles text[])
		  RETURNS TABLE(date date, revenue bigint) AS
		$BODY$
			DECLARE
				vFunctionName varchar := 'GetRevenuePerForUSer';
				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

			BEGIN

			IF(vIsAllowed) THEN

			RETURN QUERY (select activatedat::date, (sum(td.licensefee*ri.amount))::bigint as "Revenue (in IUNOs)" from transactions ts
					join licenseorder lo
					on ts.licenseorderid = lo.licenseorderid
					join offerrequest oq
					on oq.offerrequestid = ts.offerrequestid
					join offerrequestitems ri
					on ri.offerrequestid = oq.offerrequestid
					join technologydata td
					on ri.technologydataid = td.technologydataid
					where  activatedat::date = now()::date
					and td.createdby = vUserUUID
					and td.deleted is null
					group by activatedat::date
					order by activatedat::date
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
			$BODY$
		  LANGUAGE plpgsql;

		--##############################################################################################		 

		CREATE OR REPLACE FUNCTION public.gettechnologydataforuser(
			    IN vuseruuid uuid,
			    IN vroles text[])
			  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, revenue bigint, licensefee bigint, componentlist text[], technologydatadescription character varying) AS
			$BODY$
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
						array_agg(co.componentname)::text[] as componentlist,
						td.technologydatadescription
					from technologydata td
					left outer join revenue rv on td.technologydataname = rv.technologydataname
					join technologydatacomponents tc
					on tc.technologydataid = td.technologydataid
					join components co
					on tc.componentid = co.componentid
					where td.createdby = vUserUUID
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
			$BODY$
			  LANGUAGE plpgsql;

		--##############################################################################################		 

		CREATE OR REPLACE FUNCTION public.gettechnologydatahistory(
		    IN vfrom timestamp with time zone,
		    IN vto timestamp with time zone,
		    IN vcreatedby uuid,
		    IN vroles text[])
		  RETURNS TABLE(year text, month text, day text, hour text, technologydataname text, amount integer, revenue bigint) AS
		$BODY$

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
					    null,
					    vRoles) r
					left outer join technologydata td
					on td.technologydatauuid = r.technologydatauuid
					where r.year <> '0' and r.month <> '0' and r.day <> '0' and r.hour <> '0'
					and r.technologydatauuid <> uuid_nil()	
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
		$BODY$
		  LANGUAGE plpgsql;	

		--##############################################################################################

		CREATE OR REPLACE FUNCTION public.gettoptechnologydata(
		    IN vfrom timestamp with time zone,
		    IN vto timestamp with time zone,
		    IN vlimit integer,
		    IN vcreatedby uuid,
		    IN vroles text[])
		  RETURNS TABLE(year text, month text, day text, hour text, technologydataname text, amount integer, revenue bigint) AS
		$BODY$

			DECLARE
				vFunctionName varchar := 'GetTopTechnologyData'; 
				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));		

			BEGIN 

			IF(vIsAllowed) THEN

			RETURN QUERY (select r.year, r.month, r.day, r.hour, coalesce(td.technologydataname,'Total')::text as technologydataname, r.amount, r.revenue from 
					getrevenue(vFrom,
						   vTo,
						   null,
						   vCreatedBy,
						   vRoles) r
						   join technologydata td
						   on td.technologydatauuid = r.technologydatauuid
							where r.year = '0'
							and r.month = '0'
							and r.day = '0'
							and r.hour = '0' 
							and td.technologydataname <> 'Total'
							and td.deleted is null		
						order by r.amount desc, td.technologydataname
						limit vLimit		
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
		$BODY$
		  LANGUAGE plpgsql;

		--##############################################################################################

		CREATE OR REPLACE FUNCTION public.gettotalrevenue(
		    IN vfrom timestamp with time zone,
		    IN vto timestamp with time zone,
		    IN vdetail text,
		    IN vcreatedby uuid,
		    IN vroles text[])
		  RETURNS TABLE(date date, hour text, technologydataname text, amount integer, revenue bigint) AS
		$BODY$

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
					    vCreatedBy,
					    vRoles) r
					    left outer join technologydata td on
					    td.technologydatauuid = r.technologydatauuid
					    where r.year <> '0'
					    and r.month <> '0'
					    and r.day <> '0'
					    and case when (vDetail = 'hour') then r.hour <> '0' else r.hour = '0' end	 			    
					    order by r.year asc, r.month asc, r.day asc
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

			END;
		$BODY$
		  LANGUAGE plpgsql; 

		--##############################################################################################

		CREATE OR REPLACE FUNCTION public.gettotaluserrevenue(
		    IN vfrom timestamp with time zone,
		    IN vto timestamp with time zone,
		    IN vcreatedby uuid,
		    IN vroles text[])
		  RETURNS TABLE(date date, hour text, technologydataname text, amount integer, revenue bigint) AS
		$BODY$

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
					    vCreatedBy,
					    vRoles) r
					    left outer join technologydata td
					    on td.technologydatauuid = r.technologydatauuid
					    where r.year = '0'
					    and r.month = '0'
					    and r.day = '0'
					    and r.hour = '0'
					    and r.technologydatauuid = vTechnologyDataUUID			    
					    order by r.year asc, r.month asc, r.day asc
				);
			ELSE
				 RAISE EXCEPTION '%', 'Insufficiency rigths';
				 RETURN;
			END IF;

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