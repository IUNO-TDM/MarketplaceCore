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
-- Create new language and translations table + Update components table
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0041V_20180518';
		PatchNumber int 		 	 := 0041;
		PatchDescription varchar 	 := 'Add localization functionality to components - Update Database Schema';
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
			vPatchNumber int := 0041;
		BEGIN
-- #########################################################################################################################################

    --Step 1: Create languages table
    create table languages(
    		languageid int not null,
    		languagecode text not null,
    		lcid text not null
    );
    alter table languages add constraint languages_pk PRIMARY KEY (languageid);

    --Step 2: Create translations table
    create table translations (
    		translationid int not null,
    		languageid int not null,
    		textid int not null,
    		value text,
    		context text
    );
    alter table translations add constraint translations_pk PRIMARY KEY (translationid, languageid, textid);
    alter table translations add constraint translations_fk FOREIGN KEY (languageid) REFERENCES languages (languageid);
    create index translations_idx on translations (translationid, languageid, textid, value);

    --Step 3: Create sequence for languageid - Start from 4 due to preset languages
    create sequence languageid start with 4;
    --Step 4: Insert values into languages table
    insert into languages (languageid, languagecode, lcid)
    select 1, 'en', 'en-EN' union all
    select 2, 'de', 'de-DE' union all
    select 3, 'fr', 'fr-FR';
    --Step 5: Create sequence for translations
    create sequence translationid start with 1;
    --Step 6: Migration components to translations
    insert into translations (translationid, languageid, textid, value, context)
    select row_number() over(order by componentid),
    		2, -- Language de-DE
    		row_number() over(order by componentid),
    		componentname,
    		'components' from components order by componentid;
    --Step 7: Add new column textid and constraints to components table
    alter table components add column textid int;
    alter table components add constraint components_textid_fk FOREIGN KEY (textid) REFERENCES translations (textid);
    --Step 8: insert textid into components
    update components set textid = componentid;
    --Step 9: Drop componentname column from components table
    alter table components drop column componentname;


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