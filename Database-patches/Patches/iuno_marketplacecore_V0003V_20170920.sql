--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2017-09-20
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
--	At the moment it's possible to change recipes from other users. This shouldn't be allowed.
--	The call is going to be catched on the Frontend Side. This is only a further security activity.
--	Furthermore the update functionality is going to be transfer to another function
-- 	2) Which Git Issue Number is this patch solving?
--	#110; #36; #111
-- 	3) Which changes are going to be done?
--	Added a check to proof if the function calling user is owner from the recipe. 
--	On the frontend there is also a check, so that acctually this function is never 
--	going to be called by other user but the owner. But safe is safe. 
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V00003V_20170920';
		PatchNumber int 		 	 := 0003;
		PatchDescription varchar 	 := 'At the moment it is possible to change recipes from other users. This should not be allowed.
										The call is going to be catched on the Frontend Side. This is only a further security activity.
										Furthermore the update functionality is going to be transfer to another function';

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
	  RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, technologyuuid uuid, technologydata character varying, licensefee integer, 
	  productcode integer, technologydatadescription character varying, technologydatathumbnail bytea, technologydataimgref character varying, taglist uuid[],
	  componentlist uuid[], createdat timestamp with time zone, createdby uuid) AS
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
					perform public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription, vLicenseFee, vProductCode, 					vTechnologyUUID, vCreatedBy, vRoles);
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