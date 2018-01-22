--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-01-22
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
--  At the moment there are function which have to many permissions. This patch correct it.
-- 	2) Which Git Issue Number is this patch solving?
--  #111
-- 	3) Which changes are going to be done?
--  Delete role permissions for diverse functions
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0019V_20180122';
		PatchNumber int 		 	 := 0019;
		PatchDescription varchar 	 := 'Fixes #110: Delete role permissions for diverse functions';
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
			vPatchNumber int := 0019;
			vTechnologyDataOwnerID int := (select roleid from roles where rolename = 'TechnologyDataOwner');
			vMachineOperatorID int := (select roleid from roles where rolename = 'MachineOperator');
			vTechnologyAdminID int := (select roleid from roles where rolename = 'TechnologyAdmin');
		BEGIN
	----------------------------------------------------------------------------------------------------------------------------------------

                -- DELETE TechnologyDataOwner Permissions for the functions:
                -- 1: CreateComponent
                -- 2: CreateComponentsAttribute
                -- 3: CreateComponentsTechnologies
                -- 4: GetAllUsers
                -- 5: GetComponentsByTechnology
                -- 6: GetComponentsForTechnologyDataId
                -- 7: SetComponent

                delete from rolespermissions where roleid = vTechnologyDataOwnerID and
                functionid in (select functionid from functions where functionname in (
                'CreateComponent',
                'CreateComponentsAttribute',
                'CreateComponentsTechnologies',
                'GetAllUsers',
                'GetComponentsByTechnology',
                'GetComponentsForTechnologyDataId',
                'SetComponent'
                ));

                -- DELETE TechnologyAdmin Permissions for the functions:
                -- 1: DeleteTechnologyData

                delete from rolespermissions where roleid = vTechnologyAdminID and
                functionid in (select functionid from functions where functionname in (
                'DeleteTechnologyData'
                ));

                -- DELETE MachineOperator Permissions for the functions:
                -- 1: DeleteTechnologyData
                -- 2: GetAllUsers
                -- 3: SetPayment
                -- 4: SetTechnologyData

                delete from rolespermissions where roleid = vMachineOperatorID and
                functionid in (select functionid from functions where functionname in (
                'DeleteTechnologyData',
                'GetAllUsers',
                'SetPayment',
                'SetTechnologyData'
                ));

        ----------------------------------------------------------------------------------------------------------------------------------------
        -- UPDATE patch table status value
        UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = vPatchNumber;
        --ERROR HANDLING
        EXCEPTION WHEN OTHERS THEN
            UPDATE patches SET status = 'ERROR: ' || SQLERRM || ' ' || SQLSTATE || 'while creating patch.'	WHERE patchnumber = vPatchNumber;
         RETURN;
    END;
$$;