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
		perform createrole('PaymentService','Service used on the payment', null,'Admin');   --1
		perform createrole('Machine','Role for machines', null,'Admin');   --2
		perform createrole('Api','Role for api functions', null,'Admin');   --3
		perform createrole('TechnologyDataOwner','Owner of technology data', null,'Admin'); --4   
		perform createrole('Consumer','Consumer from technology data',null,'Admin');   --5
	END;
$$;
--Create Permissions
DO
$$
	BEGIN
		perform SetPermission('Admin','CreateAttribute',null,'Admin'); 
		perform SetPermission('Admin','CreateComponent',null,'Admin'); 
		perform SetPermission('Admin','CreateComponentsAttribute',null,'Admin');
		perform SetPermission('Admin','CreateComponentsTechnologies',null,'Admin');
		perform SetPermission('Admin','CreateLicenseOrder',null,'Admin'); 
		perform SetPermission('Admin','CreateOffer',null,'Admin'); 
		perform SetPermission('Admin','CreateOfferRequest',null,'Admin'); 
		perform SetPermission('Admin','CreatePaymentInvoice',null,'Admin'); 
		perform SetPermission('Admin','CreateTag',null,'Admin'); 
		perform SetPermission('Admin','CreateTechnology',null,'Admin'); 
		perform SetPermission('Admin','CreateTechnologyData',null,'Admin'); 
		perform SetPermission('Admin','CreateTechnologyDataComponents',null,'Admin'); 
		perform SetPermission('Admin','DeleteTechnologyData',null,'Admin'); 
		perform SetPermission('Admin','GetAllAttributes',null,'Admin'); 
		perform SetPermission('Admin','GetActivatedLicensesSince',null,'Admin'); 
		perform SetPermission('Admin','GetAllComponents',null,'Admin'); 
		perform SetPermission('Admin', 'GetAllOffers',null,'Admin');
		perform SetPermission('Admin', 'GetAllTags',null,'Admin');
		perform SetPermission('Admin', 'GetAllTechnlogies',null,'Admin');
		perform SetPermission('Admin', 'GetAllUsers',null,'Admin');
		perform SetPermission('Admin', 'GetAttributeById',null,'Admin');
		perform SetPermission('Admin', 'GetAttributeByName',null,'Admin');
		perform SetPermission('Admin', 'GetComponentById',null,'Admin');
		perform SetPermission('Admin', 'GetComponentByName',null,'Admin');
		perform SetPermission('Admin', 'GetComponentsByTechnology',null,'Admin');
		perform SetPermission('Admin', 'GetComponentsForTechnologyDataId',null,'Admin');
		perform SetPermission('Admin', 'GetLicenseFeeByTransaction',null,'Admin');
		perform SetPermission('Admin', 'GetMostUsedComponents',null,'Admin');
		perform SetPermission('Admin', 'GetOfferById',null,'Admin');
		perform SetPermission('Admin', 'GetOfferByRequestId',null,'Admin');
		perform SetPermission('Admin', 'GetOfferForPaymentInvoice',null,'Admin');
		perform SetPermission('Admin', 'GetOfferForTicket',null,'Admin');
		perform SetPermission('Admin', 'GetOfferForTransaction',null,'Admin');
		perform SetPermission('Admin', 'GetPaymentInvoiceForOfferRequest',null,'Admin');
		perform SetPermission('Admin', 'GetRevenuePerDaySince',null,'Admin');
		perform SetPermission('Admin', 'GetTagById',null,'Admin');
		perform SetPermission('Admin', 'GetTagByName',null,'Admin');
		perform SetPermission('Admin', 'GetTechnologyById',null,'Admin');
		perform SetPermission('Admin', 'GetTechnologyByName',null,'Admin');
		perform SetPermission('Admin', 'GetTechnologyDataById',null,'Admin');
		perform SetPermission('Admin', 'GetTechnologyDataByName',null,'Admin');
		perform SetPermission('Admin', 'GetTechnologyDataByOfferRequest',null,'Admin');
		perform SetPermission('Admin', 'GetTechnologyDataByParams',null,'Admin');
		perform SetPermission('Admin', 'GetTechnologyForOfferRequest',null,'Admin');
		perform SetPermission('Admin', 'GetTopTechnologyDataSince',null,'Admin');
		perform SetPermission('Admin', 'GetTransactionById',null,'Admin');
		perform SetPermission('Admin', 'GetTransactionByOfferRequest',null,'Admin');
		perform SetPermission('Admin', 'GetWorkLoadSince',null,'Admin');
		perform SetPermission('Admin', 'SetComponent',null,'Admin');
		perform SetPermission('Admin', 'SetPayment',null,'Admin');
		perform SetPermission('Admin', 'SetPaymentInvoiceOffer',null,'Admin');
		perform SetPermission('Admin', 'SetTechnologyData',null,'Admin');
		perform SetPermission('Admin', 'CreateTechnologyDataTags',null,'Admin');
		perform SetPermission('Admin', 'GetLicenseFeeByTechnologyData',null,'Admin');
		perform SetPermission('Admin', 'GetTechnologyDataOwnerById',null,'Admin');
		
		
	END;
$$;  

DO
 $$
    DECLARE vUserUUID uuid := 'f6552f5c-f15b-4350-b373-418979d4c045';
			vCompParentID uuid;
			vRoleName varchar := 'Admin';
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
        -- Orange
        perform public.setcomponent(
            'Orange Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Orange Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserUUID,
			vRoleName  			-- <createdby integer>
         );
		 -- Johannisbeersaft
        perform public.setcomponent(
            'Johannisbeersaft',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Johannisbeersaft', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserUUID,
			vRoleName  			-- <createdby integer>
         );
		  -- Orange
        perform public.setcomponent(
            'Orangensaft',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Orangensaft', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserUUID,
			vRoleName  			-- <createdby integer>
         );
		-- Apfelsaft
        perform public.setcomponent(
            'Apfelsaft',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Apfelsaft', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserUUID,
			vRoleName  			-- <createdby integer>
         );
        -- Apple
        perform public.setcomponent(
            'Apple Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Apple Juice',  	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserUUID,
			vRoleName  			-- <createdby integer>
         );
        -- Cola
        perform public.setcomponent(
            'Cola',				-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Cola',			 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserUUID,
			vRoleName  			-- <createdby integer>
         );
         -- Mango
        perform public.setcomponent(
            'Mango Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Mango Juice', 		-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserUUID,
			vRoleName  			-- <createdby integer>
         );
        -- Ginger
        perform public.setcomponent(
            'Ginger Sirup',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Ginger Sirup', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserUUID,
			vRoleName  			-- <createdby integer>
         );
        -- Banana
        perform public.setcomponent(
            'Banana Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Banana Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserUUID,
			vRoleName 			 
         );
         -- Cherry
        perform public.setcomponent(
            'Cherry Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Cherry Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
			vUserUUID,
            vRoleName 			-- <createdby integer>
         );
   END;
 $$;

DO 
$$
-- Get UserID
        DECLARE  vUserUUID uuid := 'f6552f5c-f15b-4350-b373-418979d4c045';
				 vRoleName varchar := 'Admin';
				 vTechnologyUUID uuid := (select technologyuuid from technologies where technologyid = 1);
		vComponents uuid[];
	
  BEGIN
  		-- Create TechnologyData   
		-- Cherry with Mango	

	vComponents := (select array_agg(componentuuid) from components where componentname in ('Cherry Juice','Mango Juice'));
        perform public.settechnologydata(
            'CheMa',		     				 -- <technologydataname character varying>, 
            '{
			  ""recipe"": {
				""id"": ""TestProgram"",
				""lines"": [
				  {
					""components"": [
					  {
						""ingredient"": ""Orangensaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Apfelsaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Johannisbeersaft"",
						""amount"": 5
					  }
					],
					""timing"": 1,
					""sleep"": 0
				  }
				]
			  }
			}',	     				 -- <technologydata character varying>, 
            'Cherry with Mango', 				 -- <technologydatadescription character varying>, 
            vTechnologyUUID,    								 -- <vtechnologyid integer>, 
            50000,
			150000,
            '{Delicious, Cherry, Mango, Yummy}', -- <taglist text[]>,            						 		 -- <createdby integer>, 
            vComponents,    							 -- <componentlist integer[]>
			vUserUUID,
			vRoleName  
		 
		 ); 
		-- Other Juice
	vComponents := (select array_agg(componentuuid) from components where componentname in ('Orangensaft','Apfelsaft','Johannisbeersaft'));
        perform public.settechnologydata(
            'CSaefte',		     				 -- <technologydataname character varying>, 
            '{
			  ""recipe"": {
				""id"": ""TestProgram"",
				""lines"": [
				  {
					""components"": [
					  {
						""ingredient"": ""Orangensaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Apfelsaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Johannisbeersaft"",
						""amount"": 5
					  }
					],
					""timing"": 1,
					""sleep"": 0
				  }
				]
			  }
			}',	     				 -- <technologydata character varying>, 
            'Cherry with Mango', 				 -- <technologydatadescription character varying>, 
            vTechnologyUUID,    								 -- <vtechnologyid integer>, 
            50000,
			150000,
            '{Delicious}', -- <taglist text[]>,            						 		 -- <createdby integer>, 
            vComponents,    							 -- <componentlist integer[]>
			vUserUUID,
			vRoleName 
		 );
         -- Cherry with Cola
        vComponents := (select array_agg(componentuuid) from components where componentname in ('Cherry Juice','Cola'));
        perform public.settechnologydata(
            'CheCo',		     				 -- <technologydataname character varying>, 
            '{
			  ""recipe"": {
				""id"": ""TestProgram"",
				""lines"": [
				  {
					""components"": [
					  {
						""ingredient"": ""Orangensaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Apfelsaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Johannisbeersaft"",
						""amount"": 5
					  }
					],
					""timing"": 1,
					""sleep"": 0
				  }
				]
			  }
			}',	     				 -- <technologydata character varying>, 
            'Cherry with Cola', 				 -- <technologydatadescription character varying>, 
            vTechnologyUUID,    								 -- <vtechnologyid integer>, 
            75000,
			200000,  			 			 
            '{Delicious, Cherry, Cola, Refreshing}', -- <taglist text[]>,
	    vComponents,    		 -- <componentlist integer[]>			
            vUserUUID,    						 -- <createdby integer>, 
            vRoleName
         );
          -- Ginger, Orange
        vComponents := (select array_agg(componentuuid) from components where componentname in ('Ginger Sirup','Orange Juice'));
        perform public.settechnologydata(
            'Ginge',		     				 -- <technologydataname character varying>, 
            '{
			  ""recipe"": {
				""id"": ""TestProgram"",
				""lines"": [
				  {
					""components"": [
					  {
						""ingredient"": ""Orangensaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Apfelsaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Johannisbeersaft"",
						""amount"": 5
					  }
					],
					""timing"": 1,
					""sleep"": 0
				  }
				]
			  }
			}',	     				 -- <technologydata character varying>, 
            'Orange with Ginger', 				 -- <technologydatadescription character varying>, 
            vTechnologyUUID,    								 -- <vtechnologyid integer>, 
            100000,
			175000,    			 				 -- <licensefee numeric>, 
            '{Delicious, Ginger, Orange}', -- <taglist text[]>,               						  
            vComponents, 
			vUserUUID,
			vRoleName
         );
         -- Banana, Mango, Orange
        vComponents := (select array_agg(componentuuid) from components where componentname in ('Banana Juice','Mango Juice','Orange Juice'));
        perform public.settechnologydata(
            'Bamao',		     				 -- <technologydataname character varying>, 
            '{
			  ""recipe"": {
				""id"": ""TestProgram"",
				""lines"": [
				  {
					""components"": [
					  {
						""ingredient"": ""Orangensaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Apfelsaft"",
						""amount"": 5
					  },
					  {
						""ingredient"": ""Johannisbeersaft"",
						""amount"": 5
					  }
					],
					""timing"": 1,
					""sleep"": 0
				  }
				]
			  }
			}',	     				 -- <technologydata character varying>, 
            'Delicious Banana, Mango, Orange juice', 				 -- <technologydatadescription character varying>, 
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
-- Create offerrequest, paymentinvoice, offer, payment and licenseorder
/*DO
$$
DECLARE 
	vtechnologydatauuid uuid; 
	vAmount integer := 5; 
	vHSMID text := 'something';
	vUserUUID uuid := (select useruuid from users limit 1);
	vBuyerUUID uuid;
	vInvoice text; 
	vOfferRequestUUID uuid;
	vPaymentInvoiceUUID uuid;
	vBitcoinTransaction text := 'Bitcoin';
	vTickedID text := 'Some Ticket';
	vOfferUUID uuid;
	vCurrOfferRequest integer;
	vCurrPaymentInvoiceID integer;
	vCurrOfferID integer;
	vRandomID integer;
	vRoleName varchar := 'Admin';

	BEGIN
	FOR i IN 1..250 LOOP 
	  vRandomID := (select (trunc(random() * 3 + 1)));
	  vInvoice := (select uuid_generate_v4())::text;
	  vtechnologydatauuid := (select technologydatauuid from technologydata where technologydataid = vRandomID);
	  -- Create Buyer 	
	  --perform createuser('Buyer','Cool','buyer.cool@coolinc.com', null);
	  vBuyerUUID := (select useruuid from users limit 1);
	  -- Create OfferRequest
	  perform createofferrequest(vtechnologydatauuid,vAmount,vHSMID,vUserUUID,vBuyerUUID, vRoleName);

	  vCurrOfferRequest := (select currval('OfferRequestID')); 
	  -- Get OfferRequestUUID
	  vOfferRequestUUID := (select offerrequestuuid from offerrequest where offerrequestid = vCurrOfferRequest)::uuid;
	  -- Create PaymentInvoice
	  raise info '%', vCurrOfferRequest;
	  perform SetPaymentInvoiceOffer(vOfferRequestUUID, vInvoice, vUserUUID, vRoleName);
	  -- Get PaymentInvoiceUUID
	  vCurrPaymentInvoiceID := (select currval('PaymentInvoiceID'));
	  vPaymentInvoiceUUID := (select paymentinvoiceuuid from paymentinvoice where paymentinvoiceid =  vCurrPaymentInvoiceID)::uuid;
	  -- Create Offer
	  --perform createoffer(vPaymentInvoiceUUID,vUserUUID);
	  -- Create Payment
	  --perform createpayment(vPaymentInvoiceUUID::uuid, vBitcoinTransaction, vUserUUID);
	  -- Get OfferUUID
	  --vCurrOfferID := (select currval('OfferID'));
	  -- vOfferUUID := (select offeruuid from offer where offerid = vCurrOfferID)::uuid;
	  -- Create LicenseOrder
	  --perform createlicenseorder(vTickedID, vOfferUUID, vUserUUID);
	END LOOP;
	END;
$$;*/
 