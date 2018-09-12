DO
$$

BEGIN

UPDATE components SET componentdescription = 'the root filament' WHERE componentdescription='Pure PLA according to the purity law';
UPDATE translations SET value = 'Root Filament' WHERE textid = (SELECT textid FROM components WHERE componentdescription ='the root filament');

-- add en translation for root component
INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='en' ),(SELECT textid FROM translations WHERE value = 'Root'),'Root', 'components');

--create root pla
perform public.setcomponent('PLA', 'Root Filament', 'the root PLA', 'components', 'en', '{material}', '{ultimaker}', '05d11003-1155-47f1-9cd6-818abac9d47c', '{TechnologyAdmin}');
UPDATE components SET displaycolor = '#ffffff' WHERE componentdescription = 'the root PLA' AND textid IN (SELECT textid FROM translations WHERE value = 'PLA');
INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de' ),(SELECT textid FROM translations WHERE value = 'PLA'),'PLA', 'components');

--create root Breakaway
perform public.setcomponent('Breakaway', 'Root Filament', 'the root Breakaway', 'components', 'en', '{material}', '{ultimaker}', '05d11003-1155-47f1-9cd6-818abac9d47c', '{TechnologyAdmin}');
UPDATE components SET displaycolor = '#ffffff' WHERE componentdescription = 'the root Breakaway' AND textid IN (SELECT textid FROM translations WHERE value = 'Breakaway');
INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de' ),(SELECT textid FROM translations WHERE value = 'Breakaway'),'Stützmaterial', 'components');

--create root abs
perform public.setcomponent('ABS', 'Root Filament', 'the root ABS', 'components', 'en', '{material}', '{ultimaker}', '05d11003-1155-47f1-9cd6-818abac9d47c', '{TechnologyAdmin}');
UPDATE components SET displaycolor = '#ffffff' WHERE componentdescription = 'the root ABS' AND textid IN (SELECT textid FROM translations WHERE value = 'ABS');
INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de' ),(SELECT textid FROM translations WHERE value = 'ABS'),'ABS', 'components');

--create root CPE
perform public.setcomponent('CPE', 'Root Filament', 'the root CPE', 'components', 'en', '{material}', '{ultimaker}', '05d11003-1155-47f1-9cd6-818abac9d47c', '{TechnologyAdmin}');
UPDATE components SET displaycolor = '#ffffff' WHERE componentdescription = 'the root CPE' AND textid IN (SELECT textid FROM translations WHERE value = 'CPE');
INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de' ),(SELECT textid FROM translations WHERE value = 'CPE'),'CPE', 'components');

--create root TPU
perform public.setcomponent('TPU', 'Root Filament', 'the root TPU', 'components', 'en', '{material}', '{ultimaker}', '05d11003-1155-47f1-9cd6-818abac9d47c', '{TechnologyAdmin}');
UPDATE components SET displaycolor = '#ffffff' WHERE componentdescription = 'the root TPU' AND textid IN (SELECT textid FROM translations WHERE value = 'TPU');
INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de' ),(SELECT textid FROM translations WHERE value = 'TPU'),'TPU', 'components');

--create root PC
perform public.setcomponent('PC', 'Root Filament', 'the root PC', 'components', 'en', '{material}', '{ultimaker}', '05d11003-1155-47f1-9cd6-818abac9d47c', '{TechnologyAdmin}');   
UPDATE components SET displaycolor = '#ffffff' WHERE componentdescription = 'the root PC' AND textid IN (SELECT textid FROM translations WHERE value = 'PC');
INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de' ),(SELECT textid FROM translations WHERE value = 'PC'),'PC', 'components');

--create root PP
perform public.setcomponent('PP', 'Root Filament', 'the root PP', 'components', 'en', '{material}', '{ultimaker}', '05d11003-1155-47f1-9cd6-818abac9d47c', '{TechnologyAdmin}');   
UPDATE components SET displaycolor = '#ffffff' WHERE componentdescription = 'the root PP' AND textid IN (SELECT textid FROM translations WHERE value = 'PP');
INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de' ),(SELECT textid FROM translations WHERE value = 'PP'),'PP', 'components');

--create root Nylon
perform public.setcomponent('Nylon', 'Root Filament', 'the root Nylon', 'components', 'en', '{material}', '{ultimaker}', '05d11003-1155-47f1-9cd6-818abac9d47c', '{TechnologyAdmin}');   
UPDATE components SET displaycolor = '#ffffff' WHERE componentdescription = 'the root Nylon' AND textid IN (SELECT textid FROM translations WHERE value = 'Nylon');
INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de' ),(SELECT textid FROM translations WHERE value = 'Nylon'),'Nylon', 'components');

--set PLA parent IDs
UPDATE components SET componentparentid = (SELECT componentid FROM components WHERE componentdescription='the root PLA') 
    WHERE components.componentuuid = '9cfe5bf1-bdc5-4beb-871a-52c70777842d'
    OR components.componentuuid = 'fe3982c8-58f4-4d86-9ac0-9ff7a3ab9cbc'
    OR components.componentuuid = 'e509f649-9fe6-4b14-ac45-d441438cb4ef'
    OR components.componentuuid = 'd9549dba-b9df-45b9-80a5-f7140a9a2f34'
    OR components.componentuuid = '0e01be8c-e425-4fb1-b4a3-b79f255f1db9'
    OR components.componentuuid = '506c9f0d-e3aa-4bd4-b2d2-23e2425b1aa9'
    OR components.componentuuid = '3ee70a86-77d8-4b87-8005-e4a1bc57d2ce'
    OR components.componentuuid = '9c1959d0-f597-46ec-9131-34020c7a54fc'
    OR components.componentuuid = '2433b8fb-dcd6-4e36-9cd5-9f4ee551c04c'
    OR components.componentuuid = '44a029e6-e31b-4c9e-a12f-9282e29a92ff'
    OR components.componentuuid = '9d5d2d7c-4e77-441c-85a0-e9eefd4aa68c'
    OR components.componentuuid = 'd9fc79db-82c3-41b5-8c99-33b3747b8fb3'
    OR components.componentuuid = '532e8b3d-5fd4-4149-b936-53ada9bd6b85'
    OR components.componentuuid = '6d71f4ad-29ab-4b50-8f65-22d99af294dd'
    OR components.componentuuid = '851427a0-0c9a-4d7c-a9a8-5cc92f84af1f'
    OR components.componentuuid = '2db25566-9a91-4145-84a5-46c90ed22bdf'
    OR components.componentuuid = '03f24266-0291-43c2-a6da-5211892a2699';

--set ABS parent IDs
UPDATE components SET componentparentid = (SELECT componentid FROM components WHERE componentdescription='the root ABS') 
    WHERE components.componentuuid = '60636bb4-518f-42e7-8237-fe77b194ebe0'
    OR components.componentuuid = '7c9575a6-c8d6-40ec-b3dd-18d7956bfaae'
    OR components.componentuuid = '3400c0d1-a4e3-47de-a444-7b704f287171'
    OR components.componentuuid = 'e873341d-d9b8-45f9-9a6f-5609e1bcff68'
    OR components.componentuuid = '5253a75a-27dc-4043-910f-753ae11bc417'
    OR components.componentuuid = '2f9d2279-9b0e-4765-bf9b-d1e1e13f3c49'
    OR components.componentuuid = '0b4ca6ef-eac8-4b23-b3ca-5f21af00e54f'
    OR components.componentuuid = '8b75b775-d3f2-4d0f-8fb2-2a3dd53cf673'
    OR components.componentuuid = '7cbdb9ca-081a-456f-a6ba-f73e4e9cb856'
    OR components.componentuuid = '763c926e-a5f7-4ba0-927d-b4e038ea2735'
    OR components.componentuuid = '5df7afa6-48bd-4c19-b314-839fe9f08f1f';

--set TPU parent IDs
UPDATE components SET componentparentid = (SELECT componentid FROM components WHERE componentdescription='the root TPU') 
    WHERE components.componentuuid = '5f4a826c-7bfe-460f-8650-a9178b180d34'
    OR components.componentuuid = '07a4547f-d21f-41a0-8eee-bc92125221b3'
    OR components.componentuuid = '6a2573e6-c8ee-4c66-8029-3ebb3d5adc5b'
    OR components.componentuuid = 'eff40bcf-588d-420d-a3bc-a5ffd8c7f4b3'
    OR components.componentuuid = '1d52b2be-a3a2-41de-a8b1-3bcdb5618695';
   
--set PC parent IDs
UPDATE components SET componentparentid = (SELECT componentid FROM components WHERE componentdescription='the root PC') 
    WHERE components.componentuuid = '8a38a3e9-ecf7-4a7d-a6a9-e7ac35102968'
    OR components.componentuuid = 'e92b1f0b-a069-4969-86b4-30127cfb6f7b'
    OR components.componentuuid = '5e786b05-a620-4a87-92d0-f02becc1ff98'
    OR components.componentuuid = '98c05714-bf4e-4455-ba27-57d74fe331e4';


--set Nylon parent IDs
UPDATE components SET componentparentid = (SELECT componentid FROM components WHERE componentdescription='the root Nylon') 
    WHERE components.componentuuid = '28fb4162-db74-49e1-9008-d05f1e8bef5c'
    OR components.componentuuid = 'c64c2dbe-5691-4363-a7d9-66b2dc12837f'
    OR components.componentuuid = 'e256615d-a04e-4f53-b311-114b90560af9';


--set PP parent IDs
UPDATE components SET componentparentid = (SELECT componentid FROM components WHERE componentdescription='the root PP') 
    WHERE components.componentuuid = 'aa22e9c7-421f-4745-afc2-81851694394a'
    OR components.componentuuid = 'c7005925-2a41-4280-8cdd-4029e3fe5253';

--set CPE parent IDs
UPDATE components SET componentparentid = (SELECT componentid FROM components WHERE componentdescription='the root CPE') 
    WHERE components.componentuuid = '6df69b13-2d96-4a69-a297-aedba667e710'
    OR components.componentuuid = 'e2409626-b5a0-4025-b73e-b58070219259'
    OR components.componentuuid = '10961c00-3caf-48e9-a598-fa805ada1e8d'
    OR components.componentuuid = 'a8955dc3-9d7e-404d-8c03-0fd6fee7f22d'
    OR components.componentuuid = '4d816290-ce2e-40e0-8dc8-3f702243131e'
    OR components.componentuuid = '1aca047a-42df-497c-abfb-0e9cb85ead52'
    OR components.componentuuid = '881c888e-24fb-4a64-a4ac-d5c95b096cd7'
    OR components.componentuuid = 'b9176a2a-7a0f-4821-9f29-76d882a88682'
    OR components.componentuuid = '7ff6d2c8-d626-48cd-8012-7725fa537cc9'
    OR components.componentuuid = '173a7bae-5e14-470e-817e-08609c61e12b'
    OR components.componentuuid = '00181d6c-7024-479a-8eb7-8a2e38a2619a'
    OR components.componentuuid = '12f41353-1a33-415e-8b4f-a775a6c70cc6'
    OR components.componentuuid = 'bd0d9eb3-a920-4632-84e8-dcd6086746c5'
    OR components.componentuuid = 'a9c340fe-255f-4914-87f5-ec4fcb0c11ef';


--set Breakaway parent IDs
UPDATE components SET componentparentid = (SELECT componentid FROM components WHERE componentdescription='the root Breakaway') 
    WHERE components.componentuuid = '7e6207c4-22ff-441a-b261-ff89f166d6a0'
    OR components.componentuuid = '7e6207c4-22ff-441a-b261-ff89f166d5f9'    
    OR components.componentuuid = '86a89ceb-4159-47f6-ab97-e9953803d70f'
    OR components.componentuuid = 'fe15ed8a-33c3-4f57-a2a7-b4b78a38c3cb';


INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='en'),(SELECT textid FROM translations WHERE value = 'Johannisbeerensaft'),'currant juice', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA White'),'Ultimaker PLA White', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic PP Generic'),'Generic PP Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Magenta'),'Ultimaker PLA Magenta', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic ABS Generic'),'Generic ABS Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PC Transparent'),'Ultimaker PC Transparent', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE+ White'),'Ultimaker CPE+ White', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker TPU 95A Blue'),'Ultimaker TPU 95A Blue', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Red'),'Ultimaker PLA Red', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Root Filament'),'Root Filament', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic Breakaway Generic'),'Generic Breakaway Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE Blue'),'Ultimaker CPE Blue', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PC White'),'Ultimaker PC White', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic PLA Generic'),'Generic PLA Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE Black'),'Ultimaker CPE Black', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE Dark Grey'),'Ultimaker CPE Dark Grey', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic CPE+ Generic'),'Generic CPE+ Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker Tough PLA Green'),'Ultimaker Tough PLA Green', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PC Black'),'Ultimaker PC Black', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Silver Metallic'),'Ultimaker PLA Silver Metallic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Orange'),'Ultimaker PLA Orange', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS Green'),'Ultimaker ABS Green', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker TPU 95A Red'),'Ultimaker TPU 95A Red', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic Nylon Generic'),'Generic Nylon Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE+ Black'),'Ultimaker CPE+ Black', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS Blue'),'Ultimaker ABS Blue', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE Yellow'),'Ultimaker CPE Yellow', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic PVA Generic'),'Generic PVA Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE White'),'Ultimaker CPE White', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS Black'),'Ultimaker ABS Black', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker Nylon Black'),'Ultimaker Nylon Black', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS White'),'Ultimaker ABS White', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Black'),'Ultimaker PLA Black', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS Yellow'),'Ultimaker ABS Yellow', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker Tough PLA Black'),'Ultimaker Tough PLA Black', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic Tough PLA Generic'),'Generic Tough PLA Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic TPU 95A Generic'),'Generic TPU 95A Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic CPE Generic'),'Generic CPE Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE Red'),'Ultimaker CPE Red', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker Tough PLA Red'),'Ultimaker Tough PLA Red', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Blue'),'Ultimaker PLA Blue', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker TPU 95A Black'),'Ultimaker TPU 95A Black', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker Tough PLA White'),'Ultimaker Tough PLA White', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker TPU 95A White'),'Ultimaker TPU 95A White', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Green'),'Ultimaker PLA Green', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS Orange'),'Ultimaker ABS Orange', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker Breakaway White'),'Ultimaker Breakaway White', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE Light Grey'),'Ultimaker CPE Light Grey', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE Green'),'Ultimaker CPE Green', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Generic PC Generic'),'Generic PC Generic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Yellow'),'Ultimaker PLA Yellow', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS Silver Metallic'),'Ultimaker ABS Silver Metallic', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS Pearl Gold'),'Ultimaker ABS Pearl Gold', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS Grey'),'Ultimaker ABS Grey', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PP Transparent'),'Ultimaker PP Transparent', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE+ Transparent'),'Ultimaker CPE+ Transparent', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker Nylon Transparent'),'Ultimaker Nylon Transparent', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Pearl-White'),'Ultimaker PLA Pearl-White', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker CPE Transparent'),'Ultimaker CPE Transparent', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker 3 Extended'),'Ultimaker 3 Extended', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker 3'),'Ultimaker 3', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker ABS Red'),'Ultimaker ABS Red', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PVA Natural'),'Ultimaker PVA Natural', 'components');

INSERT INTO translations (translationid, languageid, textid, value, context)
VALUES ((SELECT nextval('translationid')),(SELECT languageid FROM languages WHERE languagecode='de'),(SELECT textid FROM translations WHERE value = 'Ultimaker PLA Transparent'),'Ultimaker PLA Transparent', 'components');

END;
$$;