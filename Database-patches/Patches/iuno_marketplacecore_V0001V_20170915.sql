--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2017-09-15
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
--	It is not possible to create TechnologyData with TechnologyDataName containing a quote ('),
--	because the quote means "end of string" while writing the log content to the logtable.
-- 	2) Which Git Issue Number is this patch solving?
--	#91
-- 	3) Which changes are going to be done?
--	Update the functions CreateTechnologyData and SetTechnologyData
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V00001V_20170913';
		PatchNumber int 		 	 := '0001';
		PatchDescription varchar 	 := 'It is not possible to create TechnologyData with TechnologyDataName containing a quote, 
		because the quote means "end of string" while writing the log content to the logtable. ';

	BEGIN	
		--INSERT START VALUES TO THE PATCH TABLE
		INSERT INTO PATCHES (patchname, patchnumber, patchdescription, startat) VALUES (PatchName, PatchNumber, PatchDescription, now());		
	END;
$$;
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Run the patch itself and update patches table
--##############################################################################################
DO
$$
		DECLARE
			vPatchNumber int := (select max(patchnumber) from patches);
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------
			
			CREATE OR REPLACE FUNCTION public.createtechnologydata(
    IN vtechnologydataname character varying,
    IN vtechnologydata character varying,
    IN vtechnologydatadescription character varying,
    IN vlicensefee integer,
    IN vproductcode integer,
    IN vtechnologyuuid uuid,
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, productcode integer, licensefee integer, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vTechnologyDataID integer := (select nextval('TechnologyDataID'));
		vTechnologyDataUUID uuid := (select uuid_generate_v4());
		vTechnologyID integer := (select technologyid from technologies where technologyuuid = vTechnologyUUID);
		vFunctionName varchar := 'CreateTechnologyData';
		vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));

      BEGIN
	IF(vIsAllowed) then
		INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData, TechnologyDataDescription, LicenseFee, ProductCode, TechnologyID, CreatedBy, CreatedAt)
        VALUES(vTechnologyDataID, vTechnologyDataUUID, vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, vTechnologyID, vCreatedBy, now());
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
			td.LicenseFee,
			td.ProductCode,
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
  LANGUAGE plpgsql VOLATILE;


CREATE OR REPLACE FUNCTION public.settechnologydata(
    IN vtechnologydataname character varying,
    IN vtechnologydata character varying,
    IN vtechnologydatadescription character varying,
    IN vtechnologyuuid uuid,
    IN vlicensefee integer,
    IN vproductcode integer,
    IN vtaglist text[],
    IN vcomponentlist text[],
    IN vcreatedby uuid,
    IN vroles text[])
  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, licensefee integer, productcode integer, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, taglist uuid[], componentlist uuid[], createdat timestamp with time zone, createdby uuid) AS
$BODY$
	#variable_conflict use_column
      DECLARE 	vCompUUID uuid;
				vTagName text;
				vTechnologyDataID int;
				vTechnologyDataUUID uuid;
				vTechnologyID integer := (select technologyID from technologies where technologyUUID = vTechnologyUUID);
				vFunctionName varchar := 'SetTechnologyData';
				vIsAllowed boolean := (select public.checkPermissions(vRoles, vFunctionName));
				vAlreadExists integer := (select 1 from technologydata where technologydataname = vtechnologydataname);

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
			perform public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, vTechnologyUUID, vCreatedBy, vRoles);
			vTechnologyDataID := (select currval('TechnologyDataID'));
			vTechnologyDataUUID := (select technologydatauuid from technologydata where technologydataid = vTechnologyDataID);

			RAISE NOTICE '%', vTechnologyDataID;
			-- Create relation from Components to TechnologyData
			perform public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList, vRoles);

			-- Create relation from Tags to TechnologyData
			IF (vTagList != null) THEN
				perform public.CreateTechnologyDataTags(vTechnologyDataUUID, vTagList, CreatedBy, vRoles);
			END IF;
		ELSE
			UPDATE technologydata set
				TechnologyData = vTechnologyData,
				TechnologyDataDescription = vTechnologyDataDescription,
				TechnologyID = vTechnologyID,
				LicenseFee = vLicenseFee,
				ProductCode = vProductCode,
				updatedby = vCreatedBy,
				updatedat = now(),
				deleted = null
			WHERE technologydataname = vtechnologydataname;

			vTechnologyDataID := (select technologydataid from technologydata where technologydataname = vtechnologydataname);
			vTechnologyDataUUID := (select technologydatauuid from technologydata where technologydataname = vtechnologydataname);

			--update tags  (delete and create it again)
			delete from technologydatatags where technologydataid = vTechnologyDataID;
			IF (vTagList != null) THEN
				perform public.CreateTechnologyDataTags(vTechnologyDataUUID, vTagList, CreatedBy, vRoles);
			END IF;
			--update components (delete and create it again)
			delete from technologydatacomponents where technologydataid = vTechnologyDataID;
			perform public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList, vRoles);
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
  LANGUAGE plpgsql VOLATILE;
			
	----------------------------------------------------------------------------------------------------------------------------------------
		-- UPDATE patch table status value
		UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
		--ERROR HANDLING
		EXCEPTION WHEN OTHERS THEN
			UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;	 
		 RETURN;
	END;
$$; 