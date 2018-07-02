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
   values ((select nextval('translationid')),1,1,'Root component', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,2,'Mineral water', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,3,'Apple juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,4,'orange juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,5,'mango juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,6,'cherry juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,7,'banana juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,8,'passion fruit juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,9,'pineapple juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,10,'Advent Fruit', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,11,'Havana Club Rum', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,12,'Cachaça from Brazil', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,13,'mulled wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,15,'coconut juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,16,'Mulberry juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,17,'Passion fruit juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,18,'Horn pickle juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,19,'currant juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,20,'Kumquatssaft', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,21,'raspberry juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,22,'lemon juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,23,'blackberry juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,24,'avocado juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,25,'Soursop Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,26,'Breadfruit tree sap', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,27,'strawberry juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,28,'Aprikosesaft', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,29,'kiwi juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,30,'peach juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,31,'Papaya juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,32,'lychee', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,33,'Grape juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,34,'pomegranate juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,35,'Melon juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,36,'Honeydew melon juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,37,'prune juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,38,'Watermelon juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,39,'pear juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,40,'Longansaft', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,41,'Clementine juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,42,'Mandarinesaft', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,43,'elderberry juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,44,'absinthe', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,45,'Aquavit', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,46,'brandy', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,47,'Calvados', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,48,'Cidre', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,49,'cognac', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,50,'gin', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,51,'grappa', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,52,'grain', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,53,'liqueur', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,54,'mead', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,55,'Mescal', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,56,'Pisco', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,57,'port wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,58,'rum', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,59,'sherry', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,60,'Vodka', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,61,'White wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,62,'red wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,63,'wormwood', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,64,'whiskey', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,65,'Campari', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,66,'Vermouth Rosso', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,67,'Roses Lime Juice', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,68,'Grenadine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,69,'peach liqueur', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,70,'sparkling wine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,71,'champagne', 'components');
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
   values ((select nextval('translationid')),1,77,'Creme de Cacao brown', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,78,'Brown rum', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,79,'Strawberry syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,80,'pomegranate syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,81,'coconut syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,82,'passion fruit syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,83,'Blue Curacao syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,84,'almond syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,85,'Mango syrup', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,86,'passion fruit nectar', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,87,'Mango nectar', 'components');
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
   values ((select nextval('translationid')),1,94,'Preiselbeernektar', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,95,'Benedictine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,96,'Galliano', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,97,'Creme de banana', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,98,'Cream of Coconut', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,99,'white rum', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,100,'vodka', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,101,'Bol''s green banana', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,102,'Apricot brandy', 'components');
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
   values ((select nextval('translationid')),1,108,'Cherry liqueur', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,109,'Amarula', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,110,'tequila', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,111,'Tia Maria', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,112,'Kahlua', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,113,'Red bull', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,114,'Drambuie', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,115,'Xuxu strawberry limes', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,116,'Pecher Mignon', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,117,'Blended scotch', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,118,'Ginger ale', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')),1,119,'Prosecco', 'components');

   --French
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	1, 'Composant racine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	2, 'eau minérale', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	3, 'jus de pomme', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	4, 'jus d''orange', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	5, 'jus de mangue', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	6, 'jus de cerise', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	7, 'jus de banane', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	8, 'passion jus de fruits', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	9, 'jus d''ananas', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	10, 'Fruit de l''Avent', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	11, 'Rhum Havana Club', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	12, 'Cachaça du Brésil', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	13, 'vin chaud', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	15, 'jus de noix de coco', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	16, 'jus de mûre', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	17, 'Passion jus de fruits', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	18, 'Corne de jus de cornichon', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	19, 'jus de cassis', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	20, 'Kumquatssaft', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	21, 'jus de framboise', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	22, 'jus de citron', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	23, 'jus de mûre', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	24, 'jus d''avocat', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	25, 'jus corossol', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	26, 'sève d''arbre à pain', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	27, 'jus de fraise', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	28, 'Aprikosesaft', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	29, 'jus de kiwi', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	30, 'jus de pêche', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	31, 'jus de papaye', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	32, 'litchi', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	33, 'Le jus de raisin', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	34, 'jus de grenade', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	35, 'jus de melon', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	36, 'Miellat jus de melon', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	37, 'jus de pruneau', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	38, 'jus de pastèque', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	39, 'jus de poire', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	40, 'Longansaft', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	41, 'jus de clémentine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	42, 'Mandarinesaft', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	43, 'jus de sureau', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	44, 'absinthe', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	45, 'Aquavit', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	46, 'brandy', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	47, 'Calvados', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	48, 'Cidre', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	49, 'cognac', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	50, 'gin', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	51, 'Grappa', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	52, 'grain', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	53, 'liqueur', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	54, 'hydromel', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	55, 'mescal', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	56, 'Pisco', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	57, 'port', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	58, 'rhum', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	59, 'sherry', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	60, 'vodka', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	61, 'vin blanc', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	62, 'vin rouge', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	63, 'armoise', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	64, 'whisky', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	65, 'Campari', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	66, 'Vermouth Rosso', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	67, 'Jus de citron vert', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	68, 'grenadine', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	69, 'liqueur de pêche', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	70, 'champagne', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	71, 'champagne', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	72, 'Contreau', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	73, 'Frais des Bois', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	74, 'Crème de Cassis', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	75, 'Crème de Framboise', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	76, 'Rémy Martin', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	77, 'Crème de Cacao marron', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	78, 'Rhum brun', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	79, 'sirop de fraise', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	80, 'sirop de grenade', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	81, 'sirop de noix de coco', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	82, 'passion sirop de fruit', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	83, 'Sirop de Curaçao bleu', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	84, 'sirop d''amande', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	85, 'sirop de mangue', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	86, 'passion nectar de fruits', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	87, 'nectar de mangue', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	88, 'Eau tonique', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	89, 'Curaçao Triple Sec', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	90, 'Marque de cerise', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	91, 'Splash Angostura', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	92, 'Liqueur de melon', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	93, 'Southern Comfort', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	94, 'Preiselbeernektar', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	95, 'bénédictin', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	96, 'Galliano', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	97, 'Crème de banane', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	98, 'Crème de noix de coco', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	99, 'rhum blanc', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	100, 'vodka', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	101, 'La banane verte de Bol', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	102, 'Brandy d''abricot', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	103, 'Crème de Menthe', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	104, 'Grand Marnier', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	105, 'Bols Kontiki Rouge Orange', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	106, 'Amaretto', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	107, 'Batita de Coco', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	108, 'cherry brandy', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	109, 'Amarula', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	110, 'tequila', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	111, 'Tia Maria', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	112, 'Kahlua', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	113, 'Red Bull', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	114, 'Drambuie', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	115, 'Xuxu limes aux fraises', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	116, 'Pecher Mignon', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	117, 'Scotch mélangé', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	118, 'Ginger ale', 'components');
   insert into translations (translationid, languageid, textid, value, context)
   values ((select nextval('translationid')), 3, 	119, 'Prosecco', 'components');



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