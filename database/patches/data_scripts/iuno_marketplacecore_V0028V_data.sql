update userkeys set keys = '{2,3,4,7,8,9,10,11,14,15,16,18,20,21,23,25,26,28}' where useruuid = 'adb4c297-45bd-437e-ac90-9179eea41736';

DO 
$$
DECLARE  
			vComp text; vDisplayColor text; vcomponentparentuuid uuid;

			BEGIN

create table myComp (component text, attribute text);
        insert into myComp (component, attribute) values ('Kokosnusssaft', '#ffffff');
        insert into myComp (component, attribute) values ('Maulbeerensaft', '#33001a');
        insert into myComp (component, attribute) values ('Passionsfruchtsaft', '#ffcc00');
        insert into myComp (component, attribute) values ('Horngurkesaft', '#ffd11a');
        insert into myComp (component, attribute) values ('Johannisbeerensaft', '#e60000');
        insert into myComp (component, attribute) values ('Kumquatssaft', '#ffad33');
        insert into myComp (component, attribute) values ('Himbeeresaft', '#e60000');
        insert into myComp (component, attribute) values ('Zitronesaft', '#ffff80');
        insert into myComp (component, attribute) values ('Brombeerensaft', '#00004d');
        insert into myComp (component, attribute) values ('Avocadosaft', '#004d00');
        insert into myComp (component, attribute) values ('Stachelannonesaft', '#339966');
        insert into myComp (component, attribute) values ('Brotfruchtbaumsaft', '#47d147');
        insert into myComp (component, attribute) values ('Erdbeeresaft', '#ff1a1a');
        insert into myComp (component, attribute) values ('Aprikosesaft', '#ffa64d');
        insert into myComp (component, attribute) values ('Kiwisaft', '#00b33c');
        insert into myComp (component, attribute) values ('Pfirsichsaft', '#ff9933');
        insert into myComp (component, attribute) values ('Papayasaft', '#ff8533');
        insert into myComp (component, attribute) values ('Litschisaft', '#ff9999');
        insert into myComp (component, attribute) values ('Weintraubesaft', '#b3ffb3');
        insert into myComp (component, attribute) values ('Granatapfelsaft', '#ff4d4d');
        insert into myComp (component, attribute) values ('Zuckermelonesaft', '#ffff80');
        insert into myComp (component, attribute) values ('Honigmelonesaft', '#ffff4d');
        insert into myComp (component, attribute) values ('Pflaumesaft', '#b300b3');
        insert into myComp (component, attribute) values ('Wassermelonesaft', '#00802b');
        insert into myComp (component, attribute) values ('Birnensaft', '#bbff99');
        insert into myComp (component, attribute) values ('Longansaft', '#e6e600');
        insert into myComp (component, attribute) values ('Clementinesaft', '#ff9900');
        insert into myComp (component, attribute) values ('Mandarinesaft', '#ff9900');
        insert into myComp (component, attribute) values ('Holundersaft', '#4d0026');
        insert into myComp (component, attribute) values ('Absinth', '#00e600');
        insert into myComp (component, attribute) values ('Aquavit', '#e6b800');
        insert into myComp (component, attribute) values ('Brandy', '#804000');
        insert into myComp (component, attribute) values ('Calvados', '#e6ac00');
        insert into myComp (component, attribute) values ('Cidre', '#ffcc33');
        insert into myComp (component, attribute) values ('Cognac', '#805500');
        insert into myComp (component, attribute) values ('Gin', '#e6ffff');
        insert into myComp (component, attribute) values ('Grappa', '#ffffff');
        insert into myComp (component, attribute) values ('Korn', '#ffffff');
        insert into myComp (component, attribute) values ('Likör', '#e6e600');
        insert into myComp (component, attribute) values ('Met', '#ffb366');
        insert into myComp (component, attribute) values ('Mescal', '#ffffff');
        insert into myComp (component, attribute) values ('Pisco', '#e6ffe6');
        insert into myComp (component, attribute) values ('Portwein', '#802b00');
        insert into myComp (component, attribute) values ('Rum', '#86592d');
        insert into myComp (component, attribute) values ('Sherry', '#b30000');
        insert into myComp (component, attribute) values ('Vodka', '#ffffff');
        insert into myComp (component, attribute) values ('Weißwein', '#fff7e6');
        insert into myComp (component, attribute) values ('Rotwein', '#66004d');
        insert into myComp (component, attribute) values ('Wermut', '#ffcccc');
        insert into myComp (component, attribute) values ('Whisky', '#802b00');
        insert into myComp (component, attribute) values ('Campari', '#cc0000');
        insert into myComp (component, attribute) values ('Vermouth Rosso', '#660000');
        insert into myComp (component, attribute) values ('Roses Lime Juice', '#dfff80');
        insert into myComp (component, attribute) values ('Grenadine', '#cc0000');
        insert into myComp (component, attribute) values ('Pfirsichlikör', '#cccc00');
        insert into myComp (component, attribute) values ('Sekt',  '#ffffe6');
        insert into myComp (component, attribute) values ('Champagner', '#ffffe6');
        insert into myComp (component, attribute) values ('Contreau',  '#b38600');
        insert into myComp (component, attribute) values ('Frais des Bois', '#e62e00');
        insert into myComp (component, attribute) values ('Creme de Cassis', '#800080');
        insert into myComp (component, attribute) values ('Creme de Framboise', '#ff4d88');
        insert into myComp (component, attribute) values ('Remy Martin', '#e65c00');
        insert into myComp (component, attribute) values ('Creme de Cacao braun', '#4d4d00');
        insert into myComp (component, attribute) values ('Brauner Rum', '#664400');
        insert into myComp (component, attribute) values ('Erdbeersirup', '#ff5050');
        insert into myComp (component, attribute) values ('Granatapfelsirup', '#ff8080');
        insert into myComp (component, attribute) values ('Kokossirup', '#ffffff');
        insert into myComp (component, attribute) values ('Maracujasirup', '#ffd11a');
        insert into myComp (component, attribute) values ('Blue Curacao Sirup', '#3399ff');
        insert into myComp (component, attribute) values ('Mandelsirup', '#e6ffe6');
        insert into myComp (component, attribute) values ('Mangosirup', '#ffd11a');
        insert into myComp (component, attribute) values ('Maracujanektar', '#ffe066');
        insert into myComp (component, attribute) values ('Mangonektar', '#ffe067');
        insert into myComp (component, attribute) values ('Tonic Water', '#ffffff');
        insert into myComp (component, attribute) values ('Curacao Triple Sec', '#ffffff');
        insert into myComp (component, attribute) values ('Cherry Brand', '#ff4da6');
        insert into myComp (component, attribute) values ('Spritzer Angostura', '#804000');
        insert into myComp (component, attribute) values ('Melon Likör', '#e6ffe6');
        insert into myComp (component, attribute) values ('Southern Comfort', '#997300');
        insert into myComp (component, attribute) values ('Preiselbeernektar', '#e65c00');
        insert into myComp (component, attribute) values ('Benedictine', '#862d2d');
        insert into myComp (component, attribute) values ('Galliano', '#ffff00');
        insert into myComp (component, attribute) values ('Creme de Banane', '#ffcc00');
        insert into myComp (component, attribute) values ('Cream of Coconut', '#ffffff');
        insert into myComp (component, attribute) values ('weißer Rum', '#ffffff');
        insert into myComp (component, attribute) values ('Wodka', '#ffffff');
        insert into myComp (component, attribute) values ('Bols Grüne Banane', '#99ff66');
        insert into myComp (component, attribute) values ('Apricot Brandy', '#ffa64d');
        insert into myComp (component, attribute) values ('Creme de Menthe', '#5cd65c');
        insert into myComp (component, attribute) values ('Grand Marnier', '#ac3939');
        insert into myComp (component, attribute) values ('Bols Kontiki Red Orange', '#e60000');
        insert into myComp (component, attribute) values ('Amaretto', '#994d00');
        insert into myComp (component, attribute) values ('Batita de Coco', '#ffffff');
        insert into myComp (component, attribute) values ('Kirschlikör', '#661400');
        insert into myComp (component, attribute) values ('Amarula', '#fff5cc');
        insert into myComp (component, attribute) values ('Tequila', '#ffffff');
        insert into myComp (component, attribute) values ('Tia Maria', '#333300');
        insert into myComp (component, attribute) values ('Kahlua',  '#804000');
        insert into myComp (component, attribute) values ('Red bull', '#ffeb99');
        insert into myComp (component, attribute) values ('Drambuie',  '#665200');
        insert into myComp (component, attribute) values ('Xuxu Erdbeer-Limes', '#ff1a1a');
        insert into myComp (component, attribute) values ('Pecher Mignon',  '#ffdb4d');
        insert into myComp (component, attribute) values ('Blended Scotch', '#604020');
        insert into myComp (component, attribute) values ('Ginger Ale',  '#ffff99');
        insert into myComp (component, attribute) values ('Prosecco', '#ffffe6');

		vcomponentparentuuid := (select componentuuid from components where lower(componentname) = lower('Root'));

		 FOR vComp, vDisplayColor in select component, attribute from myComp LOOP
			perform public.createcomponent(
				vcomponentparentuuid,
				vComp,
				vComp,
				vDisplayColor::text,
				'adb4c297-45bd-437e-ac90-9179eea41736',
				'{Admin}');
		 END LOOP;
		 drop table myComp;

	update components set displaycolor = '#00BFFF' where componentname = 'Mineralwasser';
	update components set displaycolor = '#fff7e6' where componentname = 'Apfelsaft';
	update components set displaycolor = '#ff9900' where componentname = 'Orangensaft';
	update components set displaycolor = '#ffcc00' where componentname = 'Mangosaft';
	update components set displaycolor = '#cc0000' where componentname = 'Kirschsaft';
	update components set displaycolor = '#ffff99' where componentname = 'Bananensaft';
	update components set displaycolor = '#ffcc00' where componentname = 'Maracujasaft';
	update components set displaycolor = '#ffff99' where componentname = 'Ananassaft';
	update components set displaycolor = '#ff8080' where componentname = 'Advents-Früchtetee';
	update components set displaycolor = '#ffffff' where componentname = 'Havana Club (RUM)';
	update components set displaycolor = '#ffffff' where componentname = 'Cachaça';
	update components set displaycolor = '#b30000' where componentname = 'Glühwein';
	
END;
$$;