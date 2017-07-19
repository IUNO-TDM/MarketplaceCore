-- ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-07
-- Description: Create Base Data for the MarketplaceCode Database
-- Changes:
-- ##########################################################################
 
 

DO
$$
	BEGIN		
		perform createrole('PaymentService','Service used on the payment','Admin');   --1
		perform createrole('Machine','Role for machines','Admin');   --2
		perform createrole('Api','Role for api functions','Admin');   --3
		perform createrole('TechnologyDataOwner','Owner of technology data','Admin'); --4   
		perform createrole('Consumer','Consumer from technology data','Admin');   --5
	END;
$$;
--Create Permissions
DO
$$
	BEGIN
		perform SetPermission('Admin','CreateAttribute','Admin'); 
		perform SetPermission('Admin','CreateComponent','Admin'); 
		perform SetPermission('Admin','CreateComponentsAttribute','Admin');
		perform SetPermission('Admin','CreateComponentsTechnologies','Admin');
		perform SetPermission('Admin','CreateLicenseOrder','Admin'); 
		perform SetPermission('Admin','CreateOffer','Admin'); 
		perform SetPermission('Admin','CreateOfferRequest','Admin'); 
		perform SetPermission('Admin','CreatePaymentInvoice','Admin'); 
		perform SetPermission('Admin','CreateTag','Admin'); 
		perform SetPermission('Admin','CreateTechnology','Admin'); 
		perform SetPermission('Admin','CreateTechnologyData','Admin'); 
		perform SetPermission('Admin','CreateTechnologyDataComponents','Admin'); 
		perform SetPermission('Admin','DeleteTechnologyData','Admin'); 
		perform SetPermission('Admin','GetAllAttributes','Admin'); 
		perform SetPermission('Admin','GetActivatedLicensesSince','Admin'); 
		perform SetPermission('Admin','GetAllComponents','Admin'); 
		perform SetPermission('Admin', 'GetAllOffers', 'Admin');
		perform SetPermission('Admin', 'GetAllTags', 'Admin');
		perform SetPermission('Admin', 'GetAllTechnlogies', 'Admin');
		perform SetPermission('Admin', 'GetAllUsers', 'Admin');
		perform SetPermission('Admin', 'GetAttributeById', 'Admin');
		perform SetPermission('Admin', 'GetAttributeByName', 'Admin');
		perform SetPermission('Admin', 'GetComponentById', 'Admin');
		perform SetPermission('Admin', 'GetComponentByName', 'Admin');
		perform SetPermission('Admin', 'GetComponentsByTechnology', 'Admin');
		perform SetPermission('Admin', 'GetComponentsForTechnologyDataId', 'Admin');
		perform SetPermission('Admin', 'GetLicenseFeeByTransaction', 'Admin');
		perform SetPermission('Admin', 'GetMostUsedComponents', 'Admin');
		perform SetPermission('Admin', 'GetOfferById', 'Admin');
		perform SetPermission('Admin', 'GetOfferByRequestId', 'Admin');
		perform SetPermission('Admin', 'GetOfferForPaymentInvoice', 'Admin');
		perform SetPermission('Admin', 'GetOfferForTicket', 'Admin');
		perform SetPermission('Admin', 'GetOfferForTransaction', 'Admin');
		perform SetPermission('Admin', 'GetPaymentInvoiceForOfferRequest', 'Admin');
		perform SetPermission('Admin', 'GetRevenuePerDaySince', 'Admin');
		perform SetPermission('Admin', 'GetTagById', 'Admin');
		perform SetPermission('Admin', 'GetTagByName', 'Admin');
		perform SetPermission('Admin', 'GetTechnologyById', 'Admin');
		perform SetPermission('Admin', 'GetTechnologyByName', 'Admin');
		perform SetPermission('Admin', 'GetTechnologyDataById', 'Admin');
		perform SetPermission('Admin', 'GetTechnologyDataByName', 'Admin');
		perform SetPermission('Admin', 'GetTechnologyDataByOfferRequest', 'Admin');
		perform SetPermission('Admin', 'GetTechnologyDataByParams', 'Admin');
		perform SetPermission('Admin', 'GetTechnologyForOfferRequest', 'Admin');
		perform SetPermission('Admin', 'GetTopTechnologyDataSince', 'Admin');
		perform SetPermission('Admin', 'GetTransactionById', 'Admin');
		perform SetPermission('Admin', 'GetTransactionByOfferRequest', 'Admin');
		perform SetPermission('Admin', 'GetWorkLoadSince', 'Admin');
		perform SetPermission('Admin', 'SetComponent', 'Admin');
		perform SetPermission('Admin', 'SetPayment', 'Admin');
		perform SetPermission('Admin', 'SetPaymentInvoiceOffer', 'Admin');
		perform SetPermission('Admin', 'SetTechnologyData', 'Admin');
		perform SetPermission('Admin', 'CreateTechnologyDataTags', 'Admin');
		perform SetPermission('Admin', 'GetLicenseFeeByTechnologyData', 'Admin');
		
		
		
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
  BEGIN
  		-- Create TechnologyData   
		-- Cherry with Mango
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
            '{Cherry Juice,Mango Juice}',    							 -- <componentlist integer[]>
			vUserUUID,
			vRoleName  
		 
		 ); 
		-- Other Juice
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
            '{Orangensaft,Apfelsaft,Johannisbeersaft}',    							 -- <componentlist integer[]>
			vUserUUID,
			vRoleName 
		 );
         -- Cherry with Cola
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
			'{Cherry Juice,Cola}',    		 -- <componentlist integer[]>			
            vUserUUID,    						 -- <createdby integer>, 
            vRoleName
         );
          -- Ginger, Orange
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
            '{Ginger Sirup,Orange Juice}', 
			vUserUUID,
			vRoleName
         );
         -- Banana, Mango, Orange
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
            '{Banana Juice,Mango Juice,Orange Juice}',    								 -- <componentlist integer[]>
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
 