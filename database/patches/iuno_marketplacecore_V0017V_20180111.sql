--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-01-11
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
--  Since the LicenseFee Data Type has been changed to big int, all functions using this columns must be adapted
-- 	2) Which Git Issue Number is this patch solving?
--  #
-- 	3) Which changes are going to be done?
--  Change Return value for diverse functions.
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0017V_20180111';
		PatchNumber int 		 	 := 0017;
		PatchDescription varchar 	 := 'BugFix Return Data Type for licensefee at diverse functions';
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
			vPatchNumber int := 0017;
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------

    DROP FUNCTION public.createtechnologydata(character varying, character varying, character varying, integer, integer, uuid, text, uuid, text[]);
DROP FUNCTION public.getalltechnologydata(uuid, text[]);
DROP FUNCTION public.getlicensefeebytechnologydata(uuid, uuid, text[]);
DROP FUNCTION public.getlicensefeebytransaction(uuid, uuid, text[]);
DROP FUNCTION public.gettechnologydatabyid(uuid, uuid, text[]);
DROP FUNCTION public.gettechnologydatabyname(character varying, uuid, text[]);
DROP FUNCTION public.gettechnologydatabyofferrequest(uuid, uuid, text[]);
DROP FUNCTION public.settechnologydata(character varying, character varying, character varying, uuid, integer, integer, text[], text[], text, uuid, text[]);

--#############################################################################################################################################
CREATE OR REPLACE FUNCTION public.createtechnologydata(
    IN vtechnologydataname character varying,
    IN vtechnologydata character varying,
    IN vtechnologydatadescription character varying,
    IN vlicensefee integer,
    IN vproductcode integer,
    IN vtechnologyuuid uuid,
    IN vtechnologydataimgref text,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, productcode integer, licensefee bigint, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vTechnologyDataID integer := (select nextval('TechnologyDataID'));
		vTechnologyDataUUID uuid := (select uuid_generate_v4());
		vTechnologyID integer := (select technologyid from technologies where technologyuuid = vTechnologyUUID);
		vFunctionName varchar := 'CreateTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

      BEGIN
	IF(vIsAllowed) then
		INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, ProductCode, TechnologyID, technologydataimgref, CreatedBy, CreatedAt)
        VALUES(vTechnologyDataID, vTechnologyDataUUID, vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, vTechnologyID, vtechnologydataimgref, vCreatedBy, now());
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
  $BODY$
  LANGUAGE plpgsql;

--#############################################################################################################################################

CREATE OR REPLACE FUNCTION public.getalltechnologydata(
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid) AS
$BODY$
	DECLARE vFunctionName varchar := 'GetAllTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

		RETURN QUERY (SELECT 	technologydatauuid,
					tc.technologyuuid,
					td.technologydataname,
					technologydata,
					technologydatadescription,
					licensefee,
					td.productcode,
					technologydatathumbnail,
					technologydataimgref,
					td.createdat  at time zone 'utc',
					td.createdBy,
					td.updatedat  at time zone 'utc',
					td.UpdatedBy
			FROM TechnologyData td
			join technologies tc
			on td.technologyid = tc.technologyid
			);

	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
	$BODY$
  LANGUAGE plpgsql;

--#############################################################################################################################################

CREATE OR REPLACE FUNCTION public.getlicensefeebytechnologydata(
    IN vtechnologydatauuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(licensefee bigint) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetLicenseFeeByTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select	td.licenseFee
			from technologydata td
			where td.technologydatauuid = vTechnologyDataUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;

--#############################################################################################################################################

CREATE OR REPLACE FUNCTION public.getlicensefeebytransaction(
    IN vtransactionuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(licensefee bigint) AS
$BODY$
	DECLARE
		vFunctionName varchar := 'GetLicenseFeeByTransaction';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

	BEGIN

	IF(vIsAllowed) THEN

	RETURN QUERY (select	td.licenseFee
			from transactions ts
			join offerrequest oq
			on oq.offerrequestid = ts.offerrequestid
			join offerrequestitems ri
			on oq.offerrequestid = ri.offerrequestid
			join technologydata td
			on ri.technologydataid = td.technologydataid
			where ts.transactionuuid = vTransactionUUID
		);
	ELSE
		 RAISE EXCEPTION '%', 'Insufficiency rigths';
		 RETURN;
	END IF;

	END;
$BODY$
  LANGUAGE plpgsql;

--#############################################################################################################################################

CREATE OR REPLACE FUNCTION public.gettechnologydatabyid(
    IN vtechnologydatauuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedyby uuid) AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql;

--#############################################################################################################################################

CREATE OR REPLACE FUNCTION public.gettechnologydatabyname(
    IN vtechnologydataname character varying,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, productcode integer, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, updatedby uuid) AS
$BODY$
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
	$BODY$
  LANGUAGE plpgsql;

--#############################################################################################################################################

CREATE OR REPLACE FUNCTION public.gettechnologydatabyofferrequest(
    IN vofferrequestuuid uuid,
    IN vuseruuid uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying, technologydata character varying, technologydatadescription character varying, licensefee bigint, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone, useruuid uuid) AS
$BODY$
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
	$BODY$
  LANGUAGE plpgsql;

--#############################################################################################################################################

CREATE OR REPLACE FUNCTION public.settechnologydata(
    IN vtechnologydataname character varying,
    IN vtechnologydata character varying,
    IN vtechnologydatadescription character varying,
    IN vtechnologyuuid uuid,
    IN vlicensefee integer,
    IN vproductcode integer,
    IN vtaglist text[],
    IN vcomponentlist text[],
    IN vtechnologydataimgref text,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, licensefee bigint, productcode integer, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, taglist uuid[], componentlist uuid[], createdat timestamp with time zone, createdby uuid) AS
$BODY$
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
					perform public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, 					vTechnologyUUID, vtechnologydataimgref, vCreatedBy, vRoles);
					vTechnologyDataID := (select currval('TechnologyDataID'));
					vTechnologyDataUUID := (select technologydatauuid from technologydata where technologydataid = vTechnologyDataID);

					-- Create relation from Components to TechnologyData
					perform public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList, vRoles);

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
				 TechnologyDataImgRef, td.createdat, td.createdby
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