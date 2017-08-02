-- ##########################################################################
-- Author: Marcel Ely Gomes
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-07
-- Description: Create Base Data for the MarketplaceCode Database
-- Changes:
-- ##########################################################################
insert into roles(roleid, rolename) values (0,'Admin');
insert into functions(functionid, functionname) values (0,'CreateRole');
insert into rolespermissions (roleid,functionid) values (0,0);
insert into functions(functionid, functionname) values (1,'SetPermission');
insert into rolespermissions(roleid, functionid) values (0,1);

DO
$$
	BEGIN
		perform createrole('{Public}','Everyone that visit the marketplace without login. The public role Is only allowed to read a pre defined area (e.g. Landing Page).', null,'{Admin}');
		perform createrole('{MachineOperator}','It can be the machine owner as well as the machine operator.', null,'{Admin}');
		perform createrole('{TechnologyDataOwner}','Is the creator and administrator of Technology Data', null,'{Admin}');
		perform createrole('{MarketplaceComponent}','Is the creator and administrator of Technology Data', null,'{Admin}');
		perform createrole('{TechnologyAdmin}','Administrate technologies.', null,'{Admin}');
		perform createrole('{MarketplaceCore}','Is the only role with access to core functions', null,'{Admin}');
	END;
$$;
--Create Permissions
DO
$$
	BEGIN
		--Public
		perform SetPermission('{Public}', 'GetMostUsedComponents',null,'{Admin}');
		perform SetPermission('{Public}', 'GetRevenuePerDaySince',null,'{Admin}');
		perform SetPermission('{Public}', 'GetWorkLoadSince',null,'{Admin}');

        --MarketplaceCore
		perform SetPermission('{MarketplaceCore}', 'GetTransactionById',null,'{Admin}');
		perform SetPermission('{MarketplaceCore}', 'SetPayment',null,'{Admin}');
		perform SetPermission('{MarketplaceCore}', 'CreateLicenseOrder',null,'{Admin}');
		-- MachineOperator
		--perform SetPermission('{Admin}','CreateAttribute',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponent',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponentsAttribute',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponentsTechnologies',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateLicenseOrder',null,'{Admin}');
		perform SetPermission('{MachineOperator}','CreateOffer',null,'{Admin}');
		perform SetPermission('{MachineOperator}','CreateOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}','CreatePaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTag',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnology',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyDataComponents',null,'{Admin}');
		--perform SetPermission('{Admin}','DeleteTechnologyData',null,'{Admin}');
		perform SetPermission('{MachineOperator}','GetAllAttributes',null,'{Admin}');
		perform SetPermission('{MachineOperator}','GetActivatedLicensesSince',null,'{Admin}');
		perform SetPermission('{MachineOperator}','GetAllComponents',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAllOffers',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAllTags',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllTechnlogies',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAllUsers',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAttributeById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetAttributeByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetComponentById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetComponentByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetComponentsByTechnology',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetComponentsForTechnologyDataId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTransaction',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetMostUsedComponents',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetOfferById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetOfferByRequestId',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetOfferForPaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTicket',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetOfferForTransaction',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetPaymentInvoiceForOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetRevenuePerDaySince',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTagById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTagByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyDataById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyDataByName',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyDataByOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyDataByParams',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTechnologyForOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTopTechnologyDataSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionById',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetTransactionByOfferRequest',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetWorkLoadSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetComponent',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'SetPayment',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'SetPaymentInvoiceOffer',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'SetTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'CreateTechnologyDataTags',null,'{Admin}');
		perform SetPermission('{MachineOperator}', 'GetLicenseFeeByTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataOwnerById',null,'{Admin}');

		--TechnologyDataOwner
		perform SetPermission('{TechnologyDataOwner}','CreateAttribute',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateComponent',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateComponentsAttribute',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateComponentsTechnologies',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateLicenseOrder',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOffer',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}','CreatePaymentInvoice',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateTag',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnology',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateTechnologyData',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','CreateTechnologyDataComponents',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','DeleteTechnologyData',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','GetAllAttributes',null,'{Admin}');
		--perform SetPermission('{Admin}','GetActivatedLicensesSince',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}','GetAllComponents',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllOffers',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAllTags',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAllTechnlogies',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAllUsers',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAttributeById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetAttributeByName',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetComponentById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetComponentByName',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetComponentsByTechnology',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetComponentsForTechnologyDataId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTransaction',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetMostUsedComponents',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferByRequestId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForPaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTicket',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTransaction',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetPaymentInvoiceForOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetRevenuePerDaySince',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTagById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTagByName',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyByName',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyDataById',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyDataByName',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataByOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTechnologyDataByParams',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyForOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetTopTechnologyDataSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionByOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'GetWorkLoadSince',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'SetComponent',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPayment',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPaymentInvoiceOffer',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'SetTechnologyData',null,'{Admin}');
		perform SetPermission('{TechnologyDataOwner}', 'CreateTechnologyDataTags',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataOwnerById',null,'{Admin}');

		--MarketplaceComponent

		--TechnologyAdmin
		perform SetPermission('{TechnologyAdmin}','CreateAttribute',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateComponent',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateComponentsAttribute',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateComponentsTechnologies',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateLicenseOrder',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOffer',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}','CreatePaymentInvoice',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateTag',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','CreateTechnology',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyDataComponents',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}','DeleteTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}','GetAllAttributes',null,'{Admin}');
		--perform SetPermission('{Admin}','GetActivatedLicensesSince',null,'{Admin}');
		--perform SetPermission('{Admin}','GetAllComponents',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllOffers',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllTags',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetAllTechnlogies',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAllUsers',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAttributeById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetAttributeByName',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetComponentById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetComponentByName',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetComponentsByTechnology',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetComponentsForTechnologyDataId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTransaction',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetMostUsedComponents',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferByRequestId',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForPaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTicket',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetOfferForTransaction',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetPaymentInvoiceForOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetRevenuePerDaySince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTagById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTagByName',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyById',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyByName',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyDataById',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyDataByName',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataByOfferRequest',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'GetTechnologyDataByParams',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyForOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTopTechnologyDataSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionById',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTransactionByOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetWorkLoadSince',null,'{Admin}');
		perform SetPermission('{TechnologyAdmin}', 'SetComponent',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPayment',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPaymentInvoiceOffer',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'CreateTechnologyDataTags',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetLicenseFeeByTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'GetTechnologyDataOwnerById',null,'{Admin}');

		--Admin
		--perform SetPermission('{Admin}','CreateAttribute',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponent',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponentsAttribute',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateComponentsTechnologies',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateLicenseOrder',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOffer',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateOfferRequest',null,'{Admin}');
		--perform SetPermission('{Admin}','CreatePaymentInvoice',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTag',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnology',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}','CreateTechnologyDataComponents',null,'{Admin}');
		perform SetPermission('{Admin}','DeleteTechnologyData',null,'{Admin}');
		perform SetPermission('{Admin}','GetAllAttributes',null,'{Admin}');
		perform SetPermission('{Admin}','GetActivatedLicensesSince',null,'{Admin}');
		perform SetPermission('{Admin}','GetAllComponents',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAllOffers',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAllTags',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAllTechnlogies',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAllUsers',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAttributeById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetAttributeByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetComponentById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetComponentByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetComponentsByTechnology',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetComponentsForTechnologyDataId',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetLicenseFeeByTransaction',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetMostUsedComponents',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferByRequestId',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferForPaymentInvoice',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferForTicket',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetOfferForTransaction',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetPaymentInvoiceForOfferRequest',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetRevenuePerDaySince',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTagById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTagByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataByName',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataByOfferRequest',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataByParams',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyForOfferRequest',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTopTechnologyDataSince',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTransactionById',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTransactionByOfferRequest',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetWorkLoadSince',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetComponent',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPayment',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetPaymentInvoiceOffer',null,'{Admin}');
		--perform SetPermission('{Admin}', 'SetTechnologyData',null,'{Admin}');
		--perform SetPermission('{Admin}', 'CreateTechnologyDataTags',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetLicenseFeeByTechnologyData',null,'{Admin}');
		perform SetPermission('{Admin}', 'GetTechnologyDataOwnerById',null,'{Admin}');




	END;
$$;

DO
 $$
    DECLARE vUserUUID uuid := 'adb4c297-45bd-437e-ac90-9179eea41730';
			vCompParentID uuid;
			vRoleName text[] := '{TechnologyAdmin}';
	BEGIN
    	-- Just in case. set all sequences to start point
        ALTER SEQUENCE componentid RESTART WITH 1;
        ALTER SEQUENCE technologyid RESTART WITH 1;
        ALTER SEQUENCE technologydataid RESTART WITH 1;
        ALTER SEQUENCE tagid RESTART WITH 1;
        ALTER SEQUENCE attributeid RESTART WITH 1;

        perform public.createtechnology(
            'Juice Mixer',			-- <technologyname character varying>,
            'Machine to mix juice',	-- <technologydescription character varying>,
            vUserUUID,
	    vRoleName 				-- <createdby integer>
        );
        -- Create Components & Attributes

        perform public.setcomponent(
            'Root',   			-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Root component', 	-- <componentdescription character varying>,
            '{Root}',			-- <attributelist text[]>,
            '{Juice Mixer}',  				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 1 Wasser
        perform public.setcomponent(
            'Mineralwasser',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Mineralwasser', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 2 Apfelsaft
        perform public.setcomponent(
            'Apfelsaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Apfelsaft', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
		 -- 3 Orange
        perform public.setcomponent(
            'Orangensaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Orangensaft', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
		-- 4 Mangosaft
        perform public.setcomponent(
            'Mangosaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Mangosaft', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 5 Kirschsaft
        perform public.setcomponent(
            'Kirschsaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Kirschsaft',  	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 6 Bananensaft
        perform public.setcomponent(
            'Bananensaft',				-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Bananensaft',			 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
         -- 7 Maracujasaft
        perform public.setcomponent(
            'Maracujasaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Maracujasaft', 		-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
	    vRoleName  			-- <createdby integer>
         );
        -- 8 Ananassaft
        perform public.setcomponent(
            'Ananassaft',		-- <componentname character varying>,
            'Root',	      			-- <componentparentid integer>,
            'Ananassaft', 	-- <componentdescription character varying>,
            '{Normal}',			-- <attributelist text[]>,
            '{Juice Mixer}', 				-- <technologylist text[]>,
            vUserUUID,
            vRoleName  			-- <createdby integer>
         );

		update components set componentuuid = '8f0bc514-7219-46d2-999d-c45c930c3e7c'::uuid where componentname = 'Root';
		update components set componentuuid = '570a5df0-a044-4e22-b6e6-b10af872d75c'::uuid where componentname = 'Mineralwasser';
		update components set componentuuid = '198f1571-4846-4467-967a-00427ab0208d'::uuid where componentname = 'Apfelsaft';
		update components set componentuuid = 'f6d361a9-5a6f-42ad-bff7-0913750809e4'::uuid where componentname = 'Orangensaft';
		update components set componentuuid = 'fac1ee6f-185f-47fb-8c56-af57cd428aa8'::uuid where componentname = 'Mangosaft';
		update components set componentuuid = '0425393d-5b84-4815-8eda-1c27d35766cf'::uuid where componentname = 'Kirschsaft';
		update components set componentuuid = '4cfa2890-6abd-4e21-a7ab-17613ed9a5c9'::uuid where componentname = 'Bananensaft';
		update components set componentuuid = '14b72ce5-fec1-48ec-83ff-24b124f98dc8'::uuid where componentname = 'Maracujasaft';
		update components set componentuuid = 'bf2cfd66-5b6f-4655-8e7f-04090308f6db'::uuid where componentname = 'Ananassaft';
   END;
 $$;
COMMIT;

DO
$$
-- Get UserID
        DECLARE  vUserUUID uuid := 'f6552f5c-f15b-4350-b373-418979d4c045';
				 vRoleName text[] := '{Admin}';
				 vTechnologyUUID uuid := (select technologyuuid from technologies where technologyid = 1);
				 vComponents text[];

  BEGIN
  		-- Create TechnologyData
		--
		vComponents := (select array_agg(componentuuid) from components where componentname in ('Orangensaft','Bananensaft','Maracujasaft', 'Ananassaft', 'Mineralwasser'));
		vUserUUID := 'adb4c297-45bd-437e-ac90-9179eea41732';
		vRoleName := '{TechnologyDataOwner}';
        perform public.settechnologydata(
            'Karibiktraum',		     				 -- <technologydataname character varying>,
            '{
			  "recipe": {
					"id": "Karibiktraum",
					"lines": [
					  {
						"components": [
						  {
							"ingredient": "Orangensaft",
							"amount": 32
						  },
						  {
							"ingredient": "Bananensaft",
							"amount": 32
						  },
						  {
							""ingredient"": ""Maracujasaft"",
							""amount"": 32
						  },
						  {
							""ingredient"": ""Ananassaft"",
							""amount"": 32
						  },
						  {
							""ingredient"": ""Mineralwasser"",
							""amount"": 32
						  }
						],
						""timing"": 0,
						""sleep"": 0
					  }
					]
				  }
			}',	     				 -- <technologydata character varying>,
            'Orange, Apfel und Kirsch', 				 -- <technologydatadescription character varying>,
            vTechnologyUUID,    								 -- <vtechnologyid integer>,
            50000,
			150000,
            '{Delicious}', -- <taglist text[]>,            						 		 -- <createdby integer>,
            vComponents,    							 -- <componentlist integer[]>
			vUserUUID,
			vRoleName
		 );
         --
        vComponents := (select array_agg(componentuuid) from components where componentname in ('Mineralwasser','Apfelsaft','Maracujasaft','Ananassaft'));
		vUserUUID := 'adb4c297-45bd-437e-ac90-9179eea41732';
		vRoleName := '{TechnologyDataOwner}';
        perform public.settechnologydata(
            'Anas Big Bang',		     				 -- <technologydataname character varying>,
            '{
			  "recipe": {
					"id": "Anas Big Bang",
					"lines": [
					  {
						"components": [
						  {
							"ingredient": "Mineralwasser",
							"amount": 64
						  },
						  {
							"ingredient": "Apfelsaft",
							"amount": 16
						  },
						  {
							"ingredient": "Maracujasaft",
							"amount": 48
						  },
						  {
							"ingredient": "Ananassaft",
							"amount": 32
						  }
						],
						"timing": 0,
						"sleep": 0
					  }
					]
				  }
			}',	     				 -- <technologydata character varying>,
            'Lassen Sie sich von der Geschmacksexplosion überraschen.', 				 -- <technologydatadescription character varying>,
            vTechnologyUUID,    								 -- <vtechnologyid integer>,
            75000,
			200000,
            '{Delicious, Refreshing}', -- <taglist text[]>,
	    vComponents,    		 -- <componentlist integer[]>
            vUserUUID,    						 -- <createdby integer>,
            vRoleName
         );
          -- Banana, Orange
        vComponents := (select array_agg(componentuuid) from components where componentname in ('Mineralwasser','Apfelsaft'));
		vUserUUID := 'adb4c297-45bd-437e-ac90-9179eea41731';
		vRoleName := '{TechnologyDataOwner}';
        perform public.settechnologydata(
            'Max Apfelschorle',		     				 -- <technologydataname character varying>,
            '{
			  "recipe": {
					"id": "Max Apfelschorle",
					"lines": [
					  {
						"components": [
						  {
							"ingredient": "Mineralwasser",
							"amount": 32
						  }
						],
						"timing": 0,
						"sleep": 0
					  },
					  {
						"components": [
						  {
							"ingredient": "Mineralwasser",
							"amount": 64
						  },
						  {
							"ingredient": "Apfelsaft",
							"amount": 64
						  }
						],
						"timing": 0,
						"sleep": 0
					  }
					]
				  }
			}',	     				 -- <technologydata character varying>,
            'Der klassische Durstlöscher, wie ihn jedes Kind kennt und liebt.', 				 -- <technologydatadescription character varying>,
            vTechnologyUUID,    								 -- <vtechnologyid integer>,
            100000,
			175000,    			 				 -- <licensefee numeric>,
            '{Delicious, Apfelschorle}', -- <taglist text[]>,
            vComponents,
			vUserUUID,
			vRoleName
         );
         -- BaKi küsst Ananass
        vComponents := (select array_agg(componentuuid) from components where componentname in ('Kirschsaft','Bananensaft','Mineralwasser', 'Ananassaft'));
		vUserUUID := 'adb4c297-45bd-437e-ac90-9179eea41731';
		vRoleName := '{TechnologyDataOwner}';
        perform public.settechnologydata(
            'BaKi küsst Ananass',		     				 -- <technologydataname character varying>,
            '{
			  "recipe": {
					"id": "BaKi küsst Ananass",
					"lines": [
					  {
						"components": [
						  {
							"ingredient": "Kirschsaft",
							"amount": 60
						  },
						  {
							"ingredient": "Bananensaft",
							"amount": 60
						  },
						  {
							"ingredient": "Mineralwasser",
							"amount": 32
						  },
						  {
							"ingredient": "Ananassaft",
							"amount": 8
						  }
						],
						"timing": 0,
						"sleep": 0
					  }
					]
				  }
			}',	     				 -- <technologydata character varying>,
            'Der süße Kuss der Ananas trifft auf eine Bananen-Kirsch Kombination.', 				 -- <technologydatadescription character varying>,
            vTechnologyUUID,    								 -- <vtechnologyid integer>,
            50000,
			200000,
            '{Delicious, Banana, Orange, Mango, Tasty}', -- <taglist text[]>,
            vComponents,    								 -- <componentlist integer[]>
			vUserUUID,
			vRoleName
         );
	END;
$$;
COMMIT;

update components set componentuuid = '8f0bc514-7219-46d2-999d-c45c930c3e7c'::uuid where componentname = 'Root';
update components set componentuuid = '570a5df0-a044-4e22-b6e6-b10af872d75c'::uuid where componentname = 'Mineralwasser';
update components set componentuuid = '198f1571-4846-4467-967a-00427ab0208d'::uuid where componentname = 'Apfelsaft';
update components set componentuuid = 'f6d361a9-5a6f-42ad-bff7-0913750809e4'::uuid where componentname = 'Orangensaft';
update components set componentuuid = 'fac1ee6f-185f-47fb-8c56-af57cd428aa8'::uuid where componentname = 'Mangosaft';
update components set componentuuid = '0425393d-5b84-4815-8eda-1c27d35766cf'::uuid where componentname = 'Kirschsaft';
update components set componentuuid = '4cfa2890-6abd-4e21-a7ab-17613ed9a5c9'::uuid where componentname = 'Bananensaft';
update components set componentuuid = '14b72ce5-fec1-48ec-83ff-24b124f98dc8'::uuid where componentname = 'Maracujasaft';
update components set componentuuid = 'bf2cfd66-5b6f-4655-8e7f-04090308f6db'::uuid where componentname = 'Ananassaft';