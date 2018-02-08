--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-02-08
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
--  Create Keys for functions and apply then to users
-- 	2) Which Git Issue Number is this patch solving?
--  #127
-- 	3) Which changes are going to be done?
--  Create UserKey table, insert key value for functions, add key and isowner columns to the function table. Update checkpermission function
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0024V_20180208';
		PatchNumber int 		 	 := 0024;
		PatchDescription varchar 	 := 'Added new column in technologydata table and updated functions to hold background color information.';
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
			vPatchNumber int := 0024;
		BEGIN
-- #########################################################################################################################################


ALTER TABLE technologydata ADD COLUMN BackgroundColor varchar(9);


----------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION public.settechnologydata(character varying, character varying, character varying, uuid, integer, integer, text[], text[], text, uuid, text[]);

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
	vcreatedby uuid,
	vroles text[])
    RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, licensefee bigint, productcode integer, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, backgroundcolor character varying, taglist uuid[], componentlist uuid[], createdat timestamp with time zone, createdby uuid)
    LANGUAGE 'plpgsql'

AS $BODY$

		#variable_conflict use_column
	      DECLARE 	vCompUUID uuid;
					vTagName text;
					vTechnologyDataID int;
					vTechnologyDataUUID uuid;
					vTechnologyID integer := (select technologyID from technologies where technologyUUID = vTechnologyUUID);
					vFunctionName varchar := 'SetTechnologyData';
					vIsAllowed boolean := (select public.checkPermissions(vcreatedby, vRoles, vFunctionName));
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
					perform public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, 					vTechnologyUUID, vtechnologydataimgref, vCreatedBy, vRoles);
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
			-- Begin Log if success
			perform public.createlog(0,'Set TechnologyData sucessfully', 'SetTechnologyData',
						'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: '
						|| replace(vTechnologyDataName, '''', '''''') || ', TechnologyData: ' || vTechnologyData
						|| ', TechnologyDataDescription: ' || replace(vTechnologyDataDescription, '''', '''''')
						|| ', CreatedBy: ' || cast(vRoles as varchar));

		ELSE
			 RAISE EXCEPTION '%', 'Insufficiency rigths';
			 RETURN;
		END IF;
		-- End Log if success
		-- Return vTechnologyDataUUID
		RETURN QUERY (
			select 	TechnologyDataUUID,
				td.TechnologyDataName,
				vTechnologyUUID,
				TechnologyData,
				LicenseFee,
				ProductCode,
				TechnologyDataDescription,
				TechnologyDataThumbnail,
				TechnologyDataImgRef,
				BackgroundColor,
				array_agg(tg.taguuid) as TagList,
				array_agg(co.componentuuid) as ComponentList,
				td.CreatedAt at time zone 'utc',
				vCreatedBy as CreatedBy
			from technologydata td
			left outer join technologydatatags tt on
			td.technologydataid = tt.technologydataid
			left outer join tags tg on tt.tagid = tg.tagid
			join technologydatacomponents tc
			on tc.technologydataid = td.technologydataid
			join components co
			on co.componentid = tc.componentid
			where td.technologydataid = vTechnologyDataID
			group by technologydatauuid, td.technologydataname, technologydata,
				 licensefee, productcode, technologydatadescription, technologydatathumbnail,
				 TechnologyDataImgRef, BackgroundColor, td.createdat, td.createdby
		);

		exception when others then
		-- Begin Log if error
		perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE,  'SetTechnologyData',
					'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: '
					|| replace(vTechnologyDataName, '''', '''''') || ', TechnologyData: ' || vTechnologyData
					|| ', TechnologyDataDescription: ' || replace(vTechnologyDataDescription, '''', '''''')
					|| ', CreatedBy: ' || cast(vCreatedby as varchar));
		-- End Log if error
		RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at SetTechnologyData';
		RETURN;
	      END;

$BODY$;
----------------------------------------------------------------------------------------------------------------------------------------
DROP FUNCTION public.createtechnologydata(character varying, character varying, character varying, integer, integer, uuid, text, uuid, text[]);

CREATE OR REPLACE FUNCTION public.createtechnologydata(
	vtechnologydataname character varying,
	vtechnologydata character varying,
	vtechnologydatadescription character varying,
	vlicensefee integer,
	vproductcode integer,
	vtechnologyuuid uuid,
	vtechnologydataimgref text,
	vbackgroundcolor character varying,
	vcreatedby uuid,
	vroles text[])
    RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, productcode integer, licensefee bigint, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, backgroundcolor character varying, createdat timestamp with time zone, createdby uuid)
    LANGUAGE 'plpgsql'

AS $BODY$

	#variable_conflict use_column
      DECLARE 	vTechnologyDataID integer := (select nextval('TechnologyDataID'));
		vTechnologyDataUUID uuid := (select uuid_generate_v4());
		vTechnologyID integer := (select technologyid from technologies where technologyuuid = vTechnologyUUID);
		vFunctionName varchar := 'CreateTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

      BEGIN
	IF(vIsAllowed) then
		INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, ProductCode, TechnologyID, technologydataimgref, BackgroundColor, CreatedBy, CreatedAt)
        VALUES(vTechnologyDataID, vTechnologyDataUUID, vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, vTechnologyID, vtechnologydataimgref, vBackgroundColor, vCreatedBy, now());
	else
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	end if;

        -- Begin Log if success
        perform public.createlog(0,'Created TechnologyData sucessfully', 'CreateTechnologyData',
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: '
                                || replace(vTechnologyDataName, '''', '''''') || ', TechnologyData: ' || vTechnologyData
                                || ', TechnologyDataDescription: ' || replace(vTechnologyDataDescription, '''', '''''')
				-- || ', vTechnologyDataAuthor: ' || cast(vTechAuthor as varchar)
                                || ', TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', LicenseFee: ' || cast(vLicenseFee as varchar)
                                || ', ProductCode: ' || cast(vProductCode as varchar)
                                || ', CreatedBy: ' || vCreatedBy);

        -- End Log if success
        -- Return
        RETURN QUERY (
		select 	td.TechnologyDataUUID,
			td.TechnologyDataName,
			tc.TechnologyUUID,
			td.TechnologyData,
			td.ProductCode,
			td.LicenseFee,
			td.TechnologyDataDescription,
			td.TechnologyDataThumbnail,
			td.TechnologyDataImgRef,
			td.BackgroundColor,
			td.CreatedAt at time zone 'utc',
			vCreatedby as CreateBy
		from technologydata td
		join technologies tc on
		td.technologyid = tc.technologyid
		where td.technologydatauuid = vTechnologyDataUUID
        );

        exception when others then
        -- Begin Log if error
        perform public.createlog(1,'ERROR: ' || SQLERRM || ' ' || SQLSTATE, 'CreateTechnologyData',
                                'TechnologyDataID: ' || cast(vTechnologyDataID as varchar) || ', TechnologyDataName: '
                                || replace(vTechnologyDataName, '''', '''''') || ', TechnologyData: ' || vTechnologyData
                                || ', TechnologyDataDescription: ' || replace(vTechnologyDataDescription, '''', '''''')
				-- || ', vTechnologyDataAuthor: ' || cast(vTechAuthor as varchar)
                                || ', TechnologyID: ' || cast(vTechnologyID as varchar)
                                || ', LicenseFee: ' || cast(vLicenseFee as varchar)
                                || ', ProductCode: ' || cast(vProductCode as varchar)
                                || ', CreatedBy: ' || vCreatedBy);
        -- End Log if error
        RAISE EXCEPTION '%', 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || ' at CreateTechnologyData';
        RETURN;
      END;

$BODY$;

----------------------------------------------------------------------------------------------------------------------------------------

DROP FUNCTION public.gettechnologydatabyid(uuid, uuid, text[]);

CREATE OR REPLACE FUNCTION public.gettechnologydatabyid(
	vtechnologydatauuid uuid,
	vuseruuid uuid,
	vroles text[])
    RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, backgroundcolor character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedyby uuid)
    LANGUAGE 'plpgsql'

AS $BODY$

	DECLARE
		vFunctionName varchar := 'GetTechnologyDataById';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (	SELECT 	td.technologydatauuid,
				tc.technologyuuid,
				td.technologydataname,
				td.technologydata,
				td.technologydatadescription,
				td.productcode,
				td.licensefee,
				td.technologydatathumbnail,
				td.technologydataimgref,
				td.backgroundcolor,
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

----------------------------------------------------------------------------------------------------------------------------------------

DROP FUNCTION public.gettechnologydatabyname(character varying, uuid, text[]);

CREATE OR REPLACE FUNCTION public.gettechnologydatabyname(
	vtechnologydataname character varying,
	vuseruuid uuid,
	vroles text[])
    RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, backgroundcolor character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid)
    LANGUAGE 'plpgsql'

AS $BODY$

	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByName';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

    	RETURN QUERY (SELECT 	td.technologydatauuid,
				tc.technologyuuid,
				td.technologydataname,
				td.technologydata,
				td.technologydatadescription,
				td.productcode,
				td.licensefee,
				td.technologydatathumbnail,
				td.technologydataimgref,
				td.backgroundcolor,
				td.createdat  at time zone 'utc',
				td.createdby,
				td.updatedat  at time zone 'utc',
				td.updatedBy
			FROM TechnologyData td
			join technologies tc
			on td.technologyid = tc.technologyid
			where lower(td.technologydataname) = lower(vTechnologyDataName)
			and td.deleted is null
		);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;

$BODY$;

----------------------------------------------------------------------------------------------------------------------------------------

DROP FUNCTION public.gettechnologydatabyofferrequest(uuid, uuid, text[]);

CREATE OR REPLACE FUNCTION public.gettechnologydatabyofferrequest(
	vofferrequestuuid uuid,
	vuseruuid uuid,
	vroles text[])
    RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, backgroundcolor character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid)
    LANGUAGE 'plpgsql'

AS $BODY$

	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByOfferRequest';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

    	RETURN QUERY (SELECT 	technologydatauuid,
			tc.technologyuuid,
			td.technologydataname,
			technologydata,
			technologydatadescription,
			licensefee,
			technologydatathumbnail,
			technologydataimgref,
			backgroundcolor,
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
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;

$BODY$;

----------------------------------------------------------------------------------------------------------------------------------------

DROP FUNCTION public.gettechnologydatabyparams(text[], uuid, character varying, uuid, uuid, text[]);

CREATE OR REPLACE FUNCTION public.gettechnologydatabyparams(
	vcomponents text[],
	vtechnologyuuid uuid,
	vtechnologydataname character varying,
	vowneruuid uuid,
	vuseruuid uuid,
	vroles text[])
    RETURNS TABLE(result json)
    LANGUAGE 'plpgsql'

AS $BODY$

	DECLARE
		vFunctionName varchar := 'GetTechnologyDataByParams';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

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
			select co.componentuuid, co.componentid, co.componentname,
			case when t.* is null then '[]' else array_to_json(array_agg(t.*)) end as attributes from att t
			join componentsattribute ca on t.attributeid = ca.attributeid
			right outer join components co on co.componentid = ca.componentid
			group by co.componentname, co.componentid, co.componentuuid, t.*
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

----------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------
    -- UPDATE patch table status value
    UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
    --ERROR HANDLING
    EXCEPTION WHEN OTHERS THEN
        UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
     RETURN;
END;
$$;
 




