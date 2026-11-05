--#######################################################################################################
-- Patch 0057: Local marketplace reactivation
--   1) Remove licensing, payment, transaction, offer and product code objects (tables, sequences,
--      stored functions, role grants).
--   2) Remove licensefee and productcode from technologydata. Recipes are stored as plaintext
--      and have no approval status: every valid recipe is immediately retrievable.
--   3) Decouple recipe retrieval (GetTechnologyDataWithContent, ...) from licenses and transactions.
--   4) Remove revenue/top/history reports (they depend on transactions).
--   5) Role grants: authenticated Keycloak users (Public) may create, read and delete their own recipes,
--      Admin may do everything including deleting any recipe.
--   6) CheckOwnership handles users with several roles.
-- PATCH FILE NAME: iuno_<databasename>_V<patchnumber>V_<creation date>.sql
-- A failing statement aborts the initialisation (psql ON_ERROR_STOP), so the database never
-- comes up half migrated.
--#######################################################################################################

INSERT INTO patches (patchname, patchnumber, patchdescription, startat)
VALUES ('iuno_marketplacecore_V0057V_20261105', 57,
        'Remove license/payment/offer objects, plaintext recipes, role grants for local marketplace', now());

--#######################################################################################################
-- 1) Drop functions (all overloads) that depend on licenses, payments, offers, transactions, revenue
--#######################################################################################################
DO
$$
DECLARE
    vFunc record;
BEGIN
    FOR vFunc IN
        SELECT p.oid::regprocedure AS sig
        FROM pg_proc p
        WHERE p.pronamespace = 'public'::regnamespace
          AND p.proname IN (
            'createlicenseorder', 'createofferrequest', 'createoffer', 'createpaymentinvoice',
            'getactivatedlicensescountforuser', 'getalloffers', 'getalltechnologydata',
            'getlicensefeebytechnologydata', 'getlicensefeebytransaction', 'getnewproductcode',
            'getofferbyid', 'getofferforticket', 'getofferfortransaction', 'getofferrequestbyid',
            'getpaymentinvoiceforofferrequest', 'getpurchasedtechnologydataforuser',
            'getrevenuehistory', 'getrevenue', 'gettechnologydatabyofferrequest',
            'gettechnologydatahistory', 'gettechnologyforofferrequest', 'gettopcomponents',
            'gettoptechnologydata', 'gettotalrevenue', 'gettotaluserrevenue',
            'gettransactionbyid', 'gettransactionbyofferrequest', 'gettransactionbyoffer',
            'setpaymentinvoiceoffer', 'setpayment', 'getrevenueperdayforuser',
            -- recreated below without license/product code parameters
            'createtechnologydata', 'settechnologydata', 'gettechnologydatabyid',
            'gettechnologydatabyname', 'gettechnologydatabyparams', 'gettechnologydataforuser',
            'gettechnologydatawithcontent')
    LOOP
        EXECUTE 'DROP FUNCTION ' || vFunc.sig;
    END LOOP;
END;
$$;

--#######################################################################################################
-- 2) Drop tables and sequences
--#######################################################################################################
DROP TABLE IF EXISTS transactions CASCADE;
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS paymentinvoice CASCADE;
DROP TABLE IF EXISTS offer CASCADE;
DROP TABLE IF EXISTS offerrequestitems CASCADE;
DROP TABLE IF EXISTS offerrequest CASCADE;
DROP TABLE IF EXISTS licenseorder CASCADE;

DROP SEQUENCE IF EXISTS transactionid;
DROP SEQUENCE IF EXISTS paymentid;
DROP SEQUENCE IF EXISTS paymentinvoiceid;
DROP SEQUENCE IF EXISTS offerid;
DROP SEQUENCE IF EXISTS offerrequestitemid;
DROP SEQUENCE IF EXISTS offerrequestid;
DROP SEQUENCE IF EXISTS licenseorderid;
DROP SEQUENCE IF EXISTS productcode;

ALTER TABLE technologydata DROP COLUMN IF EXISTS licensefee;
ALTER TABLE technologydata DROP COLUMN IF EXISTS productcode;

--#######################################################################################################
-- 3) Remove role grants and function registrations of the dropped functions
--#######################################################################################################
DELETE FROM rolespermissions
WHERE functionid IN (SELECT functionid FROM functions
                     WHERE lower(functionname) IN (
                       'createlicenseorder', 'createofferrequest', 'createoffer', 'createpaymentinvoice',
                       'getactivatedlicensescountforuser', 'getalloffers', 'getalltechnologydata',
                       'getlicensefeebytechnologydata', 'getlicensefeebytransaction', 'getnewproductcode',
                       'getofferbyid', 'getofferforticket', 'getofferfortransaction', 'getofferrequestbyid',
                       'getpaymentinvoiceforofferrequest', 'getpurchasedtechnologydataforuser',
                       'getrevenuehistory', 'getrevenue', 'gettechnologydatabyofferrequest',
                       'gettechnologydatahistory', 'gettechnologyforofferrequest', 'gettopcomponents',
                       'gettoptechnologydata', 'gettotalrevenue', 'gettotaluserrevenue',
                       'gettransactionbyid', 'gettransactionbyofferrequest', 'gettransactionbyoffer',
                       'setpaymentinvoiceoffer', 'setpayment', 'getrevenueperdayforuser'));

DELETE FROM functions
WHERE lower(functionname) IN (
  'createlicenseorder', 'createofferrequest', 'createoffer', 'createpaymentinvoice',
  'getactivatedlicensescountforuser', 'getalloffers', 'getalltechnologydata',
  'getlicensefeebytechnologydata', 'getlicensefeebytransaction', 'getnewproductcode',
  'getofferbyid', 'getofferforticket', 'getofferfortransaction', 'getofferrequestbyid',
  'getpaymentinvoiceforofferrequest', 'getpurchasedtechnologydataforuser',
  'getrevenuehistory', 'getrevenue', 'gettechnologydatabyofferrequest',
  'gettechnologydatahistory', 'gettechnologyforofferrequest', 'gettopcomponents',
  'gettoptechnologydata', 'gettotalrevenue', 'gettotaluserrevenue',
  'gettransactionbyid', 'gettransactionbyofferrequest', 'gettransactionbyoffer',
  'setpaymentinvoiceoffer', 'setpayment', 'getrevenueperdayforuser');

--#######################################################################################################
-- 4) CheckOwnership: a user with several roles must not break the lookup.
--    If any of the roles may call the function without ownership check, no check is done.
--#######################################################################################################
CREATE OR REPLACE FUNCTION public.checkownership(vfunctionname text, vcreatedby uuid, vowneruuid uuid, vroles text[])
    RETURNS boolean
    LANGUAGE plpgsql
AS
$$
DECLARE
    vFunctionID int := (SELECT functionid FROM functions WHERE functionname = vFunctionName);
    vGrants     int;
    vNoCheck    boolean;
BEGIN
    SELECT count(*), coalesce(bool_or(coalesce(rp.checkownership, false) = false), false)
    INTO vGrants, vNoCheck
    FROM rolespermissions rp
             JOIN roles r ON r.roleid = rp.roleid
    WHERE rp.functionid = vFunctionID
      AND r.rolename = ANY (vRoles);

    IF (vGrants = 0) THEN
        RAISE EXCEPTION '%', 'ERROR: You are not allowed to run this procedure: ' || vFunctionName || '.';
    END IF;

    IF (vNoCheck) THEN
        RETURN false;
    END IF;

    IF (vOwnerUUID != vCreatedby OR vCreatedby IS NULL) THEN
        RAISE EXCEPTION '%', 'ERROR: You are not the data owner';
    END IF;

    RETURN true;
END;
$$;

--#######################################################################################################
-- 5) Recipe functions without license fee and product code
--#######################################################################################################
CREATE OR REPLACE FUNCTION public.createtechnologydata(vtechnologydataname character varying,
                                                       vtechnologydata character varying,
                                                       vtechnologydatadescription character varying,
                                                       vtechnologyuuid uuid, vtechnologydataimgref text,
                                                       vbackgroundcolor character varying, visfile boolean,
                                                       vfilepath character varying, vcreatedby uuid,
                                                       vroles text[])
    RETURNS TABLE(technologydatauuid uuid)
    LANGUAGE plpgsql
AS
$$
#variable_conflict use_column
DECLARE
    vTechnologyDataID   integer := (SELECT nextval('TechnologyDataID'));
    vTechnologyDataUUID uuid := (SELECT uuid_generate_v4());
    vTechnologyID       integer := (SELECT technologyid FROM technologies WHERE technologyuuid = vTechnologyUUID);
    vFunctionName       varchar := 'CreateTechnologyData';
    vIsAllowed          boolean := (SELECT public.checkPermissions(vRoles, vFunctionName));
BEGIN
    IF (vIsFile IS NULL) THEN
        vIsFile = FALSE;
    END IF;

    IF (vIsAllowed) THEN
        INSERT INTO TechnologyData(TechnologyDataID, TechnologyDataUUID, TechnologyDataName, TechnologyData,
                                   TechnologyDataDescription, TechnologyID, technologydataimgref,
                                   BackgroundColor, isFile, filePath, CreatedBy, CreatedAt)
        VALUES (vTechnologyDataID, vTechnologyDataUUID, vTechnologyDataName, vTechnologyData,
                vTechnologyDataDescription, vTechnologyID, vtechnologydataimgref, vBackgroundColor, vIsFile,
                vFilePath, vCreatedBy, now());
    ELSE
        RAISE EXCEPTION '%', 'Insufficiency rigths';
    END IF;

    RETURN QUERY (SELECT technologydatauuid FROM technologydata WHERE technologydataid = vTechnologyDataID);
END;
$$;

CREATE OR REPLACE FUNCTION public.settechnologydata(vtechnologydataname character varying,
                                                    vtechnologydata character varying,
                                                    vtechnologydatadescription character varying,
                                                    vtechnologyuuid uuid, vtaglist text[],
                                                    vcomponentlist text[], vtechnologydataimgref text,
                                                    vbackgroundcolor character varying, visfile boolean,
                                                    vfilepath character varying, vcreatedby uuid,
                                                    vroles text[])
    RETURNS TABLE(technologydatauuid uuid)
    LANGUAGE plpgsql
AS
$$
#variable_conflict use_column
DECLARE
    vCompUUID           uuid;
    vTechnologyDataID   int;
    vTechnologyDataUUID uuid;
    vFunctionName       varchar := 'SetTechnologyData';
    vIsAllowed          boolean := (SELECT public.checkPermissions(vRoles, vFunctionName));
    vAlreadExists       integer := (SELECT 1
                                    FROM technologydata
                                    WHERE technologydataname = vtechnologydataname
                                      AND deleted IS NULL);
BEGIN
    IF (vIsAllowed) THEN
        -- Proof if all components are available
        FOREACH vCompUUID IN ARRAY vComponentlist
            LOOP
                IF NOT EXISTS(SELECT componentid FROM components WHERE componentuuid = vCompUUID) THEN
                    RAISE EXCEPTION USING
                        errcode = 'invalid_parameter_value',
                        message = 'There is no component with ComponentName: ' || cast(vCompUUID AS varchar);
                END IF;
            END LOOP;

        -- Proof if technology is available
        IF NOT EXISTS(SELECT technologyid FROM technologies WHERE technologyuuid = vTechnologyUUID) THEN
            RAISE EXCEPTION USING
                errcode = 'invalid_parameter_value',
                message = 'There is no technology with TechnologyUUID: ' || coalesce(vTechnologyUUID::text, 'Empty');
        END IF;

        IF (vAlreadExists IS NULL) THEN
            PERFORM public.createtechnologydata(vTechnologyDataName, vTechnologyData, vTechnologyDataDescription,
                                                vTechnologyUUID, vtechnologydataimgref, vBackgroundColor, vIsFile,
                                                vFilePath, vCreatedBy, vRoles);
            vTechnologyDataID := (SELECT currval('TechnologyDataID'));
            vTechnologyDataUUID := (SELECT technologydatauuid FROM technologydata WHERE technologydataid = vTechnologyDataID);

            PERFORM public.CreateTechnologyDataComponents(vTechnologyDataUUID, vComponentList, vCreatedBy, vRoles);
        ELSE
            RAISE EXCEPTION '%', 'Technologydata already exists';
        END IF;
    ELSE
        RAISE EXCEPTION '%', 'Insufficiency rigths';
    END IF;

    RETURN QUERY (SELECT technologydatauuid FROM technologydata WHERE technologydataid = vTechnologyDataID);
END;
$$;

CREATE OR REPLACE FUNCTION public.gettechnologydatabyid(vtechnologydatauuid uuid, vuseruuid uuid, vroles text[])
    RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying,
                  technologydatadescription character varying, technologydataimgref character varying,
                  backgroundcolor character varying, isfile boolean, filepath character varying,
                  createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone,
                  updatedby uuid)
    LANGUAGE plpgsql
AS
$$
DECLARE
    vFunctionName varchar := 'GetTechnologyDataById';
    vIsAllowed    boolean := (SELECT public.checkPermissions(vRoles, vFunctionName));
BEGIN
    IF (vIsAllowed) THEN
        RETURN QUERY (SELECT td.technologydatauuid,
                             tc.technologyuuid,
                             td.technologydataname,
                             td.technologydatadescription,
                             td.technologydataimgref,
                             td.backgroundcolor,
                             td.isfile,
                             td.filePath,
                             td.createdat AT TIME ZONE 'utc',
                             td.createdby,
                             td.updatedat AT TIME ZONE 'utc',
                             td.updatedby
                      FROM TechnologyData td
                               JOIN technologies tc ON td.technologyid = tc.technologyid
                      WHERE td.technologydatauuid = vtechnologydatauuid
                        AND td.deleted IS NULL);
    ELSE
        RAISE EXCEPTION '%', 'Insufficiency rigths';
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.gettechnologydatabyname(vtechnologydataname character varying, vuseruuid uuid,
                                                          vroles text[])
    RETURNS TABLE(technologydatauuid uuid, technologyuuid uuid, technologydataname character varying,
                  technologydatadescription character varying, technologydataimgref character varying,
                  backgroundcolor character varying, isfile boolean, filepath character varying,
                  createdat timestamp with time zone, createdby uuid, updatedat timestamp with time zone,
                  updatedby uuid)
    LANGUAGE plpgsql
AS
$$
DECLARE
    vFunctionName varchar := 'GetTechnologyDataByName';
    vIsAllowed    boolean := (SELECT public.checkPermissions(vRoles, vFunctionName));
BEGIN
    IF (vIsAllowed) THEN
        RETURN QUERY (SELECT td.technologydatauuid,
                             tc.technologyuuid,
                             td.technologydataname,
                             td.technologydatadescription,
                             td.technologydataimgref,
                             td.backgroundcolor,
                             td.isfile,
                             td.filePath,
                             td.createdat AT TIME ZONE 'utc',
                             td.createdby,
                             td.updatedat AT TIME ZONE 'utc',
                             td.updatedBy
                      FROM TechnologyData td
                               JOIN technologies tc ON td.technologyid = tc.technologyid
                      WHERE lower(td.technologydataname) = lower(vTechnologyDataName)
                        AND td.deleted IS NULL
                        AND (NOT td.isfile OR td.filepath IS NOT NULL));
    ELSE
        RAISE EXCEPTION '%', 'Insufficiency rigths';
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.gettechnologydatabyparams(vcomponents text[], vtechnologyuuid uuid,
                                                            vtechnologydataname character varying,
                                                            vowneruuid uuid, vuseruuid uuid,
                                                            vlanguagecode text DEFAULT 'en'::text,
                                                            vroles text[] DEFAULT NULL::text[])
    RETURNS TABLE(result json)
    LANGUAGE plpgsql
AS
$$
DECLARE
    vFunctionName varchar := 'GetTechnologyDataByParams';
    vIsAllowed    boolean := (SELECT public.checkPermissions(vRoles, vFunctionName));
    vTechnologyID int := (SELECT technologyid FROM technologies WHERE technologyuuid = vTechnologyUUID);
BEGIN
    IF (vIsAllowed) THEN
        RETURN QUERY (WITH att AS (
            SELECT ab.attributeid, attributename
            FROM components co
                     JOIN componentsattribute ca ON co.componentid = ca.componentid
                     JOIN attributes ab ON ca.attributeid = ab.attributeid
                     JOIN technologydatacomponents tc ON tc.componentid = co.componentid
            GROUP BY ab.attributeid
        ),
                           comp AS (
                               SELECT co.componentuuid,
                                      co.componentid,
                                      tl.value AS componentname,
                                      CASE WHEN t.* IS NULL THEN '[]' ELSE array_to_json(array_agg(t.*)) END AS attributes
                               FROM att t
                                        JOIN componentsattribute ca ON t.attributeid = ca.attributeid
                                        RIGHT OUTER JOIN components co ON co.componentid = ca.componentid
                                        JOIN translations tl ON co.textid = tl.textid
                                        JOIN languages la ON tl.languageid = la.languageid
                                   AND la.languagecode = vlanguagecode
                               GROUP BY tl.value, co.componentid, co.componentuuid, t.*
                           ),
                           techData AS (
                               SELECT td.technologydatauuid,
                                      td.technologydataname,
                                      tt.technologyuuid,
                                      td.technologydatadescription,
                                      td.technologydataimgref,
                                      td.backgroundcolor,
                                      td.isfile,
                                      td.filepath,
                                      td.createdat AT TIME ZONE 'utc',
                                      td.CreatedBy,
                                      td.updatedat AT TIME ZONE 'utc',
                                      td.UpdatedBy,
                                      array_to_json(array_agg(co.*)) componentlist
                               FROM comp co
                                        JOIN technologydatacomponents tc ON co.componentid = tc.componentid
                                        JOIN technologydata td ON td.technologydataid = tc.technologydataid
                                        JOIN components cm ON cm.componentid = co.componentid
                                        JOIN technologies tt ON tt.technologyid = td.technologyid
                               WHERE (vOwnerUUID IS NULL OR td.createdby = vOwnerUUID)
                                 AND td.deleted IS NULL
                               GROUP BY td.technologydatauuid,
                                        td.technologydataname,
                                        tt.technologyuuid,
                                        td.technologydatadescription,
                                        td.technologydataimgref,
                                        td.backgroundcolor,
                                        td.isfile,
                                        td.filepath,
                                        td.createdat,
                                        td.createdby,
                                        td.updatedat,
                                        td.updatedby
                           ),
                           compIn AS (
                               SELECT td.technologydataname, array_agg(componentuuid ORDER BY componentuuid ASC) comp
                               FROM components co
                                        JOIN technologydatacomponents tc ON co.componentid = tc.componentid
                                        JOIN technologydata td ON td.technologydataid = tc.technologydataid
                               WHERE td.deleted IS NULL
                                 AND (NOT td.isfile OR td.filepath IS NOT NULL)
                                 AND (vTechnologyUUID IS NULL OR td.technologyid = vTechnologyID)
                               GROUP BY td.technologydataname
                           )
                      SELECT array_to_json(array_agg(td.*))
                      FROM techData td
                               JOIN compIn co ON co.technologydataname = td.technologydataname
                      WHERE (co.comp::text[] <@ vComponents OR vComponents IS NULL)
                        AND (vTechnologyDataName IS NULL OR td.technologydataname = vTechnologyDataName));
    ELSE
        RAISE EXCEPTION '%', 'Insufficiency rigths';
    END IF;
END;
$$;

CREATE OR REPLACE FUNCTION public.gettechnologydataforuser(vuseruuid uuid, vinquirerid uuid,
                                                           vlanguagecode text DEFAULT 'en'::text,
                                                           vroles text[] DEFAULT NULL::text[])
    RETURNS TABLE(technologydatauuid uuid, technologydataname character varying, componentlist text[],
                  technologydatadescription character varying)
    LANGUAGE plpgsql
AS
$$
DECLARE
    vFunctionName varchar := 'GetTechnologyDataForUser';
    vIsAllowed    boolean := (SELECT public.checkPermissions(vRoles, vFunctionName));
BEGIN
    IF (vIsAllowed) THEN
        RETURN QUERY (SELECT td.technologydatauuid,
                             td.technologydataname,
                             array_agg(tl.value)::text[] AS componentlist,
                             td.technologydatadescription
                      FROM technologydata td
                               JOIN technologydatacomponents tc ON tc.technologydataid = td.technologydataid
                               JOIN components co ON tc.componentid = co.componentid
                               JOIN translations tl ON co.textid = tl.textid
                               JOIN languages la ON tl.languageid = la.languageid
                          AND la.languagecode = vlanguagecode
                      WHERE (vuseruuid IS NULL OR td.createdby = vuseruuid)
                        AND td.deleted IS NULL
                      GROUP BY td.technologydatauuid, td.technologydataname, td.technologydatadescription);
    ELSE
        RAISE EXCEPTION '%', 'Insufficiency rigths';
    END IF;
END;
$$;

-- Recipe content is plaintext and available to every role that may read recipes.
CREATE OR REPLACE FUNCTION public.gettechnologydatawithcontent(vtechnologydatauuid uuid, vuseruuid uuid,
                                                               vroles text[])
    RETURNS TABLE(technologydatauuid uuid, technologydata character varying, isfile boolean,
                  filepath character varying)
    LANGUAGE plpgsql
AS
$$
DECLARE
    vFunctionName varchar := 'GetTechnologyDataWithContent';
    vIsAllowed    boolean := (SELECT public.checkPermissions(vRoles, vFunctionName));
BEGIN
    IF (vIsAllowed) THEN
        RETURN QUERY (SELECT td.technologydatauuid, td.technologydata, td.isfile, td.filepath
                      FROM technologydata td
                      WHERE td.technologydatauuid = vTechnologyDataUUID
                        AND td.deleted IS NULL);
    ELSE
        RAISE EXCEPTION '%', 'Insufficiency rigths';
    END IF;
END;
$$;

--#######################################################################################################
-- 6) Role grants
--    Public: every authenticated marketplace user. Reads recipes and creates/changes/deletes own recipes.
--    Admin: everything the other roles may do; may delete any recipe (no ownership check).
--#######################################################################################################
INSERT INTO rolespermissions (roleid, functionid, checkownership)
SELECT (SELECT roleid FROM roles WHERE rolename = 'Public'), rp.functionid, rp.checkownership
FROM rolespermissions rp
WHERE rp.roleid = (SELECT roleid FROM roles WHERE rolename = 'TechnologyDataOwner')
  AND NOT EXISTS(SELECT 1
                 FROM rolespermissions x
                 WHERE x.roleid = (SELECT roleid FROM roles WHERE rolename = 'Public')
                   AND x.functionid = rp.functionid);

INSERT INTO rolespermissions (roleid, functionid, checkownership)
SELECT (SELECT roleid FROM roles WHERE rolename = 'Public'), functionid, false
FROM functions
WHERE functionname = 'GetTechnologyDataWithContent'
  AND NOT EXISTS(SELECT 1
                 FROM rolespermissions x
                 WHERE x.roleid = (SELECT roleid FROM roles WHERE rolename = 'Public')
                   AND x.functionid = functions.functionid);

-- Admin gets every function that any other role has (no ownership restriction)
INSERT INTO rolespermissions (roleid, functionid, checkownership)
SELECT DISTINCT (SELECT roleid FROM roles WHERE rolename = 'Admin'), rp.functionid, false
FROM rolespermissions rp
WHERE rp.roleid <> (SELECT roleid FROM roles WHERE rolename = 'Admin')
  AND NOT EXISTS(SELECT 1
                 FROM rolespermissions x
                 WHERE x.roleid = (SELECT roleid FROM roles WHERE rolename = 'Admin')
                   AND x.functionid = rp.functionid);

-- MachineOperator may read recipe content (already granted before; keep explicit)
INSERT INTO rolespermissions (roleid, functionid, checkownership)
SELECT (SELECT roleid FROM roles WHERE rolename = 'MachineOperator'), functionid, false
FROM functions
WHERE functionname = 'GetTechnologyDataWithContent'
  AND NOT EXISTS(SELECT 1
                 FROM rolespermissions x
                 WHERE x.roleid = (SELECT roleid FROM roles WHERE rolename = 'MachineOperator')
                   AND x.functionid = functions.functionid);

UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = 57;
