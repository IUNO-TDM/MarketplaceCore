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

    ALTER TABLE translations ADD CONSTRAINT uniquetext UNIQUE (languageid, value);

    -- English
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Mineralwasser'),'Mineral Water', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Apfelsaft'),'Apple Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Orangensaft'),'Orange Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Mangosaft'),'Mango Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Kirschsaft'),'Cherry Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Bananensaft'),'Banana Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Maracujasaft'),'Maracuja Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Ananassaft'),'Pineapple Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Kokosnusssaft'),'Coconut Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Maulbeerensaft'),'Mulberry Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Passionsfruchtsaft'),'Passion Fruit Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Horngurkesaft'),'Horned Cucumber Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Kumquatssaft'),'Cumquat Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Himbeeresaft'),'Raspberry Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Zitronesaft'),'Lemon Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Brombeerensaft'),'Blackberry Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Avocadosaft'),'Avocado Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Stachelannonesaft'),'Prickly Annon Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Brotfruchtbaumsaft'),'Breadfruit Tree Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Erdbeeresaft'),'Strawberry Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Aprikosesaft'),'Apricot Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Kiwisaft'),'Kiwi Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Pfirsichsaft'),'Peach Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Papayasaft'),'Papaya Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Litschisaft'),'Lychee Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Weintraubesaft'),'Wine Grape Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Granatapfelsaft'),'Pomegranate Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Zuckermelonesaft'),'Sugar Melon Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Honigmelonesaft'),'Honeydew Melon Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Pflaumesaft'),'Plum Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Wassermelonesaft'),'Watermelon Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Birnensaft'),'Pear Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Longansaft'),'Longan Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Clementinesaft'),'Clementine Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Mandarinesaft'),'Mandarin Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Holundersaft'),'Elderberry Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Absinth'),'Absinthe', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Aquavit'),'Aquavit', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Brandy'),'Brandy', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Calvados'),'Calvados', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Cidre'),'Cidre', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Cognac'),'Cognac', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Gin'),'Gin', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Grappa'),'Grappa', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Korn'),'Grain', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Likör'),'Liqueur', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Met'),'Mead', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Mescal'),'Mescal', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Pisco'),'Pisco', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Portwein'),'Port Wine', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Rum'),'Rum', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Sherry'),'Sherry', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Vodka'),'Vodka', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Weißwein'),'White wine', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Rotwein'),'Red Wine', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Wermut'),'Wormwood', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Whisky'),'Whiskey', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Campari'),'Campari', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Vermouth Rosso'),'Vermouth Rosso', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Roses Lime Juice'),'Roses Lime Juice', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Grenadine'),'Grenadine', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Pfirsichlikör'),'Peach Liqueur', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Sekt'),'Sparkling Wine', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Champagner'),'Champagne', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Contreau'),'Contreau', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Frais des Bois'),'Frais des Bois', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Creme de Cassis'),'Creme de Cassis', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Creme de Framboise'),'Creme de Framboise', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Remy Martin'),'Remy Martin', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Creme de Cacao braun'),'Creme de Cacao Brown', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Brauner Rum'),'Brown rum', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Erdbeersirup'),'Strawberry Syrup', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Granatapfelsirup'),'Pomegranate Syrup', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Kokossirup'),'Coconut Syrup', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Maracujasirup'),'Passion Fruit Syrup', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Blue Curacao Sirup'),'Blue Curacao Syrup', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Mandelsirup'),'Almond Syrup', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Mangosirup'),'Mango Syrup', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Maracujanektar'),'Passion Fruit Nectar', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Mangonektar'),'Mango Nectar', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Tonic Water'),'Tonic Water', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Curacao Triple Sec'),'Curacao Triple Sec', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Cherry Brand'),'Cherry Brand', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Spritzer Angostura'),'Splash Angostura', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Melon Likör'),'Melon Liqueur', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Southern Comfort'),'Southern Comfort', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Preiselbeernektar'),'Cranberry Nectar', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Benedictine'),'Benedictine', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Galliano'),'Galliano', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Creme de Banane'),'Creme de Banana', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Cream of Coconut'),'Cream of Coconut', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Weißer Rum'),'White Rum', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Wodka'),'Wodka', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Bols Grüne Banane'),'Bol''s Green Banana', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Apricot Brandy'),'Apricot Brandy', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Creme de Menthe'),'Creme de Menthe', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Grand Marnier'),'Grand Marnier', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Bols Kontiki Red Orange'),'Bols Kontiki Red Orange', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Amaretto'),'Amaretto', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Batita de Coco'),'Batita de Coco', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Kirschlikör'),'Cherry Liqueur', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Amarula'),'Amarula', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Tequila'),'Tequila', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Tia Maria'),'Tia Maria', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Kahlua'),'Kahlua', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Red bull'),'Red Bull', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Drambuie'),'Drambuie', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Xuxu Erdbeer-Limes'),'Xuxu Strawberry Limes', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Pecher Mignon'),'Pecher Mignon', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Blended Scotch'),'Blended Scotch', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Ginger Ale'),'Ginger Ale', 'components');
    INSERT INTO translations (translationid, languageid, textid, value, context)
    VALUES ((SELECT nextval('translationid')),1,(SELECT textid FROM translations WHERE value = 'Prosecco'),'Prosecco', 'components');



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