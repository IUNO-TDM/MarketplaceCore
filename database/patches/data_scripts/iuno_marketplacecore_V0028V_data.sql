update userkeys set keys = '{2,3,4,7,8,9,10,11,14,15,16,18,20,21,23,25,26,28}' where useruuid = 'adb4c297-45bd-437e-ac90-9179eea41736';

DO 
$$
DECLARE  
			vComp text; vAttr text[];
			
			BEGIN
create table myComp (component text, attribute text[]);
        insert into myComp (component, attribute) values ('Kokosnusssaft', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Maulbeerensaft', '{displayColor: #33001a}');
        insert into myComp (component, attribute) values ('Passionsfruchtsaft', '{displayColor: #ffcc00}');
        insert into myComp (component, attribute) values ('Horngurkesaft', '{displayColor: #ffd11a}');
        insert into myComp (component, attribute) values ('Johannisbeerensaft', '{displayColor: #e60000}');
        insert into myComp (component, attribute) values ('Kumquatssaft', '{displayColor: #ffad33}');
        insert into myComp (component, attribute) values ('Himbeeresaft', '{displayColor: #e60000}');
        insert into myComp (component, attribute) values ('Zitronesaft', '{displayColor: #ffff80}');
        insert into myComp (component, attribute) values ('Brombeerensaft', '{displayColor: #00004d}');
        insert into myComp (component, attribute) values ('Avocadosaft', '{displayColor: #004d00}');
        insert into myComp (component, attribute) values ('Stachelannonesaft', '{displayColor: #339966}');
        insert into myComp (component, attribute) values ('Brotfruchtbaumsaft', '{displayColor: #47d147}');
        insert into myComp (component, attribute) values ('Erdbeeresaft', '{displayColor: #ff1a1a}');
        insert into myComp (component, attribute) values ('Aprikosesaft', '{displayColor: #ffa64d}');
        insert into myComp (component, attribute) values ('Kiwisaft', '{displayColor: #00b33c}');
        insert into myComp (component, attribute) values ('Pfirsichsaft', '{displayColor: #ff9933}');
        insert into myComp (component, attribute) values ('Papayasaft', '{displayColor: #ff8533}');
        insert into myComp (component, attribute) values ('Litschisaft', '{displayColor: #ff9999}');
        insert into myComp (component, attribute) values ('Weintraubesaft', '{displayColor: #b3ffb3}');
        insert into myComp (component, attribute) values ('Granatapfelsaft', '{displayColor: #ff4d4d}');
        insert into myComp (component, attribute) values ('Zuckermelonesaft', '{displayColor: #ffff80}');
        insert into myComp (component, attribute) values ('Honigmelonesaft', '{displayColor: #ffff4d}');
        insert into myComp (component, attribute) values ('Pflaumesaft', '{displayColor: #b300b3}');
        insert into myComp (component, attribute) values ('Wassermelonesaft', '{displayColor: #00802b}');
        insert into myComp (component, attribute) values ('Birnensaft', '{displayColor: #bbff99}');
        insert into myComp (component, attribute) values ('Longansaft', '{displayColor: #e6e600}');
        insert into myComp (component, attribute) values ('Clementinesaft', '{displayColor: #ff9900}');
        insert into myComp (component, attribute) values ('Mandarinesaft', '{displayColor: #ff9900}');
        insert into myComp (component, attribute) values ('Holundersaft', '{displayColor: #4d0026}');
        insert into myComp (component, attribute) values ('Absinth', '{displayColor: #00e600}');
        insert into myComp (component, attribute) values ('Aquavit', '{displayColor: #e6b800}');
        insert into myComp (component, attribute) values ('Brandy', '{displayColor: #804000}');
        insert into myComp (component, attribute) values ('Calvados', '{displayColor: #e6ac00}');
        insert into myComp (component, attribute) values ('Cidre', '{displayColor: #ffcc33}');
        insert into myComp (component, attribute) values ('Cognac', '{displayColor: #805500}');
        insert into myComp (component, attribute) values ('Gin', '{displayColor: #e6ffff}');
        insert into myComp (component, attribute) values ('Grappa', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Korn', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Likör', '{displayColor: #e6e600}');
        insert into myComp (component, attribute) values ('Met', '{displayColor: #ffb366}');
        insert into myComp (component, attribute) values ('Mescal', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Pisco', '{displayColor: #e6ffe6}');
        insert into myComp (component, attribute) values ('Portwein', '{displayColor: #802b00}');
        insert into myComp (component, attribute) values ('Rum', '{displayColor: #86592d}');
        insert into myComp (component, attribute) values ('Sherry', '{displayColor: #b30000}');
        insert into myComp (component, attribute) values ('Vodka', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Weißwein', '{displayColor: #fff7e6}');
        insert into myComp (component, attribute) values ('Rotwein', '{displayColor: #66004d}');
        insert into myComp (component, attribute) values ('Wermut', '{displayColor: #ffcccc}');
        insert into myComp (component, attribute) values ('Whisky', '{displayColor: #802b00}');
        insert into myComp (component, attribute) values ('Campari', '{displayColor: #cc0000}');
        insert into myComp (component, attribute) values ('Vermouth Rosso', '{displayColor: #660000}');
        insert into myComp (component, attribute) values ('Roses Lime Juice', '{displayColor: #dfff80}');
        insert into myComp (component, attribute) values ('Grenadine', '{displayColor: #cc0000}');
        insert into myComp (component, attribute) values ('Pfirsichlikör', '{displayColor: #cccc00}');
        insert into myComp (component, attribute) values ('Sekt',  '{displayColor: #ffffe6}');
        insert into myComp (component, attribute) values ('Champagner', '{displayColor: #ffffe6}');
        insert into myComp (component, attribute) values ('Contreau',  '{displayColor: #b38600}');
        insert into myComp (component, attribute) values ('Frais des Bois', '{displayColor: #e62e00}');
        insert into myComp (component, attribute) values ('Creme de Cassis', '{displayColor: #800080}');
        insert into myComp (component, attribute) values ('Creme de Framboise', '{displayColor: #ff4d88}');
        insert into myComp (component, attribute) values ('Remy Martin', '{displayColor: #e65c00}');
        insert into myComp (component, attribute) values ('Creme de Cacao braun', '{displayColor: #4d4d00}');
        insert into myComp (component, attribute) values ('Brauner Rum', '{displayColor: #664400}');
        insert into myComp (component, attribute) values ('Erdbeersirup', '{displayColor: #ff5050}');
        insert into myComp (component, attribute) values ('Granatapfelsirup', '{displayColor: #ff8080}');
        insert into myComp (component, attribute) values ('Kokossirup', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Maracujasirup', '{displayColor: #ffd11a}');
        insert into myComp (component, attribute) values ('Blue Curacao Sirup', '{displayColor: #3399ff}');
        insert into myComp (component, attribute) values ('Mandelsirup', '{displayColor: #e6ffe6}');
        insert into myComp (component, attribute) values ('Mangosirup', '{displayColor: #ffd11a}');
        insert into myComp (component, attribute) values ('Maracujanektar', '{displayColor: #ffe066}');
        insert into myComp (component, attribute) values ('Mangonektar', '{displayColor: #ffe067}');
        insert into myComp (component, attribute) values ('Tonic Water', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Curacao Triple Sec', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Cherry Brand', '{displayColor: #ff4da6}');
        insert into myComp (component, attribute) values ('Spritzer Angostura', '{displayColor: #804000}');
        insert into myComp (component, attribute) values ('Melon Likör', '{displayColor: #e6ffe6}');
        insert into myComp (component, attribute) values ('Southern Comfort', '{displayColor: #997300}');
        insert into myComp (component, attribute) values ('Preiselbeernektar', '{displayColor: #e65c00}');
        insert into myComp (component, attribute) values ('Benedictine', '{displayColor: #862d2d}');
        insert into myComp (component, attribute) values ('Galliano', '{displayColor: #ffff00}');
        insert into myComp (component, attribute) values ('Creme de Banane', '{displayColor: #ffcc00}');
        insert into myComp (component, attribute) values ('Cream of Coconut', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('weißer Rum', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Wodka', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Bols Grüne Banane', '{displayColor: #99ff66}');
        insert into myComp (component, attribute) values ('Apricot Brandy', '{displayColor: #ffa64d}');
        insert into myComp (component, attribute) values ('Creme de Menthe', '{displayColor: #5cd65c}');
        insert into myComp (component, attribute) values ('Grand Marnier', '{displayColor: #ac3939}');
        insert into myComp (component, attribute) values ('Bols Kontiki Red Orange', '{displayColor: #e60000}');
        insert into myComp (component, attribute) values ('Amaretto', '{displayColor: #994d00}');
        insert into myComp (component, attribute) values ('Batita de Coco', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Kirschlikör', '{displayColor: #661400}');
        insert into myComp (component, attribute) values ('Amarula', '{displayColor: #fff5cc}');
        insert into myComp (component, attribute) values ('Tequila', '{displayColor: #ffffff}');
        insert into myComp (component, attribute) values ('Tia Maria', '{displayColor: #333300}');
        insert into myComp (component, attribute) values ('Kahlua',  '{displayColor: #804000}');
        insert into myComp (component, attribute) values ('Red bull', '{displayColor: #ffeb99}');
        insert into myComp (component, attribute) values ('Drambuie',  '{displayColor: #665200}');
        insert into myComp (component, attribute) values ('Xuxu Erdbeer-Limes', '{displayColor: #ff1a1a}');
        insert into myComp (component, attribute) values ('Pecher Mignon',  '{displayColor: #ffdb4d}');
        insert into myComp (component, attribute) values ('Blended Scotch', '{displayColor: #604020}');
        insert into myComp (component, attribute) values ('Ginger Ale',  '{displayColor: #ffff99}');
        insert into myComp (component, attribute) values ('Prosecco', '{displayColor: #ffffe6}');

		 FOR vComp, vAttr in select component, attribute from myComp LOOP
			perform public.setcomponent(
			    vComp,		-- <componentname character varying>,
			    'Root',	      			-- <componentparentid integer>,
			    vComp, 		-- <componentdescription character varying>,
			    vAttr,			-- <attributelist text[]>,
			    '{Juice Mixer}', 				-- <technologylist text[]>,
			    'adb4c297-45bd-437e-ac90-9179eea41736',
			    '{Admin}'  			-- <createdby integer>
         );
		 END LOOP;
		 drop table myComp;

	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Mineralwasser' and attributeName = 'displayColor: #ffffff';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Apfelsaft' and attributeName = 'displayColor: #fff7e6';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Orangensaft' and attributeName = 'displayColor: #ff9900';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Mangosaft' and attributeName = 'displayColor: #ffcc00';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Kirschsaft' and attributeName = 'displayColor: #cc0000';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Bananensaft' and attributeName = 'displayColor: #ffff99';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Maracujasaft' and attributeName = 'displayColor: #ffcc00';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Ananassaft' and attributeName = 'displayColor: #ffff99';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Advents-Früchtetee' and attributeName = 'displayColor: #ff8080';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Havana Club (RUM)' and attributeName = 'displayColor: #ffffff';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Cachaça' and attributeName = 'displayColor: #ffffff';
	insert into componentsattribute (componentid, attributeid)
	select componentid, attributeid from components, attributes where componentname = 'Glühwein' and attributeName = 'displayColor: #b30000';
	
END;
$$;