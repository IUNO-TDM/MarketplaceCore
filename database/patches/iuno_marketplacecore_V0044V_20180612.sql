--#######################################################################################################
--TRUMPF Werkzeugmaschinen GmbH & Co KG
--TEMPLATE FOR DATABASE PATCHES, HOT FIXES and SCHEMA CHANGES
--Author: Marcel Ely Gomes
--CreateAt: 2018-06-12
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
--  Translation for Components (english and french)
-- 	2) Which Git Issue Number is this patch solving?
-- #179
-- 	3) Which changes are going to be done?
-- Insert values to the translation table
--: Run Patches
------------------------------------------------------------------------------------------------
--##############################################################################################
-- Write into the patch table: patchname, patchnumber, patchdescription and start time
--##############################################################################################
DO
$$
	DECLARE
		PatchName varchar		 	 := 'iuno_marketplacecore_V0044V_20180612';
		PatchNumber int 		 	 := 0044;
		PatchDescription varchar 	 := 'Insert values to the translation table';
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
			vPatchNumber int := 0044;
		BEGIN
-- #########################################################################################################################################

    -- English
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,1,'Root Component', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,2,'Mineral Water', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,3,'Apple Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,4,'Orange Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,5,'Mango Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,6,'Cherry Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,7,'Banana Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,8,'Passion Fruit Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,9,'Pineapple Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,10,'Advent Fruit', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,11,'Havana Club Rum', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,12,'Cachaça from Brazil', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,13,'Mulled wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,15,'Coconut Water', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,16,'Mulberry Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,17,'Passion Fruit Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,18,'Horn Pickle Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,19,'Currant Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,20,'Kumquat Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,21,'Raspberry Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,22,'Lemon Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,23,'Blackberry Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,24,'Avocado Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,25,'Soursop Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,26,'BreadFruit Tree Sap', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,27,'Strawberry Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,28,'Apricot Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,29,'Kiwi Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,30,'Peach Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,31,'Papaya Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,32,'Lychee', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,33,'Grape Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,34,'Pomegranate Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,35,'Melon Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,36,'Honeydew Melon Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,37,'Prune Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,38,'Watermelon Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,39,'Pear Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,40,'Longan Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,41,'Clementine Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,42,'Mandarin Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,43,'Elderberry Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,44,'Absinthe', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,45,'Aquavit', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,46,'Brandy', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,47,'Calvados', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,48,'Cidre', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,49,'Cognac', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,50,'Gin', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,51,'Grappa', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,52,'Grain', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,53,'Liqueur', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,54,'Mead', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,55,'Mescal', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,56,'Pisco', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,57,'Port Wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,58,'Rum', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,59,'Sherry', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,60,'Vodka', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,61,'White wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,62,'Red Wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,63,'Wormwood', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,64,'Whiskey', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,65,'Campari', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,66,'Vermouth Rosso', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,67,'Roses Lime Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,68,'Grenadine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,69,'Peach Liqueur', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,70,'Sparkling Wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,71,'Champagne', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,72,'Contreau', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,73,'Frais des Bois', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,74,'Creme de Cassis', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,75,'Creme de Framboise', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,76,'Remy Martin', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,77,'Creme de Cacao Brown', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,78,'Brown rum', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,79,'Strawberry Syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,80,'Pomegranate Syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,81,'Coconut Syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,82,'Passion Fruit Syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,83,'Blue Curacao Syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,84,'Almond Syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,85,'Mango Syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,86,'Passion Fruit Nectar', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,87,'Mango Nectar', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,88,'Tonic Water', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,89,'Curacao Triple Sec', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,90,'Cherry Brand', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,91,'Splash Angostura', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,92,'Melon liqueur', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,93,'Southern Comfort', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,94,'Cranberry Nectar', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,95,'Benedictine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,96,'Galliano', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,97,'Creme de Banana', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,98,'Cream of Coconut', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,99,'White Rum', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,100,'Vodka', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,101,'Bol''s Green Banana', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,102,'Apricot Brandy', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,103,'Creme de Menthe', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,104,'Grand Marnier', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,105,'Bols Kontiki Red Orange', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,106,'Amaretto', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,107,'Batita de Coco', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,108,'Cherry Liqueur', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,109,'Amarula', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,110,'Tequila', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,111,'Tia Maria', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,112,'Kahlua', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,113,'Red Bull', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,114,'Drambuie', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,115,'Xuxu Strawberry Limes', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,116,'Pecher Mignon', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,117,'Blended Scotch', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,118,'Ginger Ale', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,119,'Prosecco', 'components');



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