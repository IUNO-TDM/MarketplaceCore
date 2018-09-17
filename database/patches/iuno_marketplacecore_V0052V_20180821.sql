--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Manuel Beuttler
--CreateAt: 2018-08-21
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
--  components function does return parent ids instead of uuids
-- 	2) Which Git Issue Number is this patch solving?
--
-- 	3) Which changes are going to be done?
--  Update GetAllComponents
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0052V_20180821';
		PatchNumber int 		 	 := 0052;
		PatchDescription varchar 	 := 'Update GetAllComponents';
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
    vPatchNumber int := 0052;
BEGIN
-- #########################################################################################################################################

    --Drop deprecated functions
       DROP FUNCTION public.getallcomponents(uuid, text, text[], text[], text[]);
       --Create new getallcomponents
       CREATE OR REPLACE FUNCTION public.getallcomponents(
            vuseruuid uuid,
            vlanguagecode text DEFAULT 'en'::text,
            vtechnologies text[] DEFAULT NULL::text[],
            vattributes text[] DEFAULT NULL::text[],
            vroles text[] DEFAULT NULL::text[])
            RETURNS TABLE   (
                            componentuuid uuid,
                            componentname text,
                            componentparentuuid uuid,
                            componentdescription character varying,
                            displaycolor text,
                            createdat timestamp with time zone,
                            createdby uuid,
                            updatedat timestamp with time zone,
                            updatedby uuid
                            )
           LANGUAGE 'plpgsql'

       AS $BODY$

       	DECLARE
       		vFunctionName varchar := 'GetAllComponents';
       		vIsAllowed boolean := (select public.checkPermissions( vRoles, vFunctionName));
       	BEGIN

       	IF(vIsAllowed) THEN

       	RETURN QUERY (SELECT  cp.componentuuid,
                      		tl.value::text as componentname,
                      		parent.componentuuid,
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
                      		JOIN components parent ON
                      		parent.componentid = cp.componentparentid
                      		LEFT OUTER JOIN componentstechnologies cote ON
                      		cote.componentid = cp.componentid
                      		LEFT OUTER JOIN technologies te ON
                      		te.technologyid = cote.technologyid
                      		LEFT OUTER JOIN componentsattribute coat ON
                      		coat.componentid = cp.componentid
                      		LEFT OUTER JOIN attributes atr ON
                      		atr.attributeid = coat.attributeid
                      		WHERE cp.componentparentid IS NOT NULL
                            AND (te.technologyuuid = ANY (vtechnologies::uuid[]) OR vtechnologies IS NULL)
                            AND (atr.attributeuuid = ANY (vattributes::uuid[]) OR vattributes IS NULL)
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