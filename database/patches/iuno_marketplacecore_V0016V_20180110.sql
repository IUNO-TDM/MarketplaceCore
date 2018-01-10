--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-01-10
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
--	At createlog it is possible to inject sql
-- 	2) Which Git Issue Number is this patch solving?
--	#144
-- 	3) Which changes are going to be done?
--	The createlog function will be updated
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0016V_20180110';
		PatchNumber int 		 	 := 0016;
		PatchDescription varchar 	 := 'The createlog function will be updated due to sql injection problem';
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
			vPatchNumber int := 0016;
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------

    CREATE OR REPLACE FUNCTION public.createlog(
        vlogstatusid integer,
        vlogmessage character varying,
        vlogobjectname character varying,
        vparameters character varying)
        RETURNS void
        LANGUAGE 'plpgsql'
    AS $BODY$

          DECLARE vLogID integer:= (select nextval('LogID'));
              vSqlCmd varchar :=  concat(
                                            'INSERT INTO LogTable(LogID, LogStatusID, LogMessage, LogObjectName, Parameters,CreatedAt)',
                                            'VALUES( ',
                                            cast(vLogID as varchar),
                                            ', ',
                                            cast(vLogStatusID as varchar),
                                            ', ''',
                                            vLogMessage,
                                            ''', ''',
                                            vLogObjectName,
                                            ''', ''',
                                            vParameters,
                                            ''', ''',
                                            now(),
                                            ''')'
                                       );

             vConnName text := 'conn';
             vConnString text := 'dbname=oauthdb port=5432 host=localhost user=oauthdb_loguser password=PASSWORD';
             vConnExist bool := (select ('{' || vConnName || '}')::text[] <@ (select dblink_get_connections()));
          BEGIN

            if(not vConnExist or vConnExist is null) then
                    perform dblink_connect(vConnName,vConnString);
            end if;
                    perform dblink(vConnName,vSqlCmd);
                    perform dblink_disconnect(vConnName);
                    set role postgres;
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