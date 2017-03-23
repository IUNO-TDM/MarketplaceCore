-- ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-07
-- Description: Create Base Data for the MarketplaceCode Database
-- Changes:
-- ##########################################################################
-- Create Roles
DO
$$
	BEGIN
		perform createrole('Public','Public users',null);  -- 1
		perform createrole('ExternalService','External services such as WebService',null);  -- 2
		perform createrole('InternalService','Internal services such as PaymentService',null);  -- 4
		perform createrole('Admin','System administrator',null);  -- 8
		perform createrole('DBUser','Database user',null);  -- 16
	END;
$$;
--Create Permissions
DO
$$
	BEGIN
		perform createpermission(16,'uuid_nil',null);
		perform createpermission(16,'uuid_ns_dns',null);
		perform createpermission(16,'uuid_ns_url',null);
		perform createpermission(16,'uuid_ns_oid',null);
		perform createpermission(16,'uuid_ns_x500',null);
		perform createpermission(16,'uuid_generate_v1',null);
		perform createpermission(16,'uuid_generate_v1mc',null);
		perform createpermission(16,'uuid_generate_v3',null);
		perform createpermission(16,'uuid_generate_v4',null);
		perform createpermission(16,'uuid_generate_v5',null);
		perform createpermission(16,'createlog',null);
		perform createpermission(30,'createuser',null);
		perform createpermission(31,'createtechnologydata',null);
		perform createpermission(31,'createtag',null);
		perform createpermission(30,'gettagbyname',null);
		perform createpermission(30,'createtechnologydatatags',null);
		perform createpermission(31,'createattribute',null);
		perform createpermission(30,'createcomponent',null);
		perform createpermission(30,'createtechnology',null);
		perform createpermission(28,'createpaymentinvoice',null);
		perform createpermission(16,'createtechnologydatacomponents',null);
		perform createpermission(16,'createcomponentsattribute',null);
		perform createpermission(16,'createcomponentstechnologies',null);
		perform createpermission(28,'createofferrequest',null);
		perform createpermission(30,'gettagbyid',null);
		perform createpermission(28,'createoffer',null);
		perform createpermission(28,'createlicenseorder',null);
		perform createpermission(28,'createpayment',null);
		perform createpermission(30,'setcomponent',null);
		perform createpermission(16,'settechnologydata',null);
		perform createpermission(28,'setpaymentinvoiceoffer',null);
		perform createpermission(28,'getalltechnologydata',null);
		perform createpermission(28,'gettechnologydatabyid',null);
		perform createpermission(28,'gettechnologydatabyname',null);
		perform createpermission(30,'getallcomponents',null);
		perform createpermission(28,'getcomponentbyid',null);
		perform createpermission(28,'getcomponentbyname',null);
		perform createpermission(30,'getalltags',null);
		perform createpermission(30,'getalltechnologies',null);
		perform createpermission(28,'gettechnologybyid',null);
		perform createpermission(28,'gettechnologybyname',null);
		perform createpermission(28,'gettechnologydatabyparams',null);
		perform createpermission(30,'getallusers',null);
		perform createpermission(28,'getuserbyid',null);
		perform createpermission(28,'getuserbyname',null);
		perform createpermission(28,'getalloffers',null);
		perform createpermission(28,'getallattributes',null);
		perform createpermission(28,'getattributebyid',null);
		perform createpermission(28,'getattributebyname',null);
		perform createpermission(28,'getofferbyrequestid',null);
		perform createpermission(28,'getofferbyid',null);
		perform createpermission(16,'datediff',null);
		perform createpermission(30,'getactivatedlicensessince',null);
		perform createpermission(30,'gettoptechnologydatasince',null);
		perform createpermission(30,'getmostusedcomponents',null);
		perform createpermission(28,'getofferfortransaction',null);
		perform createpermission(30,'getworkloadsince',null);
		perform createpermission(28,'getpaymentinvoiceforofferrequest',null);
		perform createpermission(28,'getofferforpaymentinvoice',null);
		perform createpermission(28,'getcomponentsbytechnology',null);
		perform createpermission(28,'gettechnologyforofferrequest',null);
		perform createpermission(28,'getlicensefeebytransaction',null);
		perform createpermission(28,'gettransactionbyofferrequest',null);
		perform createpermission(28,'gettechnologydatabyofferrequest',null);
		perform createpermission(28,'getofferforticket',null);	
	END;
$$;
-- Insert System User
DO
 $$
    DECLARE vUserID uuid; 
			vCompParentID uuid;
	BEGIN
    	-- Just in case. set all sequences to start point
        ALTER SEQUENCE userid RESTART WITH 1;
        ALTER SEQUENCE componentid RESTART WITH 1;
        ALTER SEQUENCE technologyid RESTART WITH 1;
        ALTER SEQUENCE technologydataid RESTART WITH 1;
        ALTER SEQUENCE tagid RESTART WITH 1;
        ALTER SEQUENCE attributeid RESTART WITH 1;
    	-- Create System User
        perform public.createuser(
            'System', 		-- <UserFirstName>
            'Admin', 		-- <UserLastName>
            'system@admin.com', -- <EmailAddress>
			null
        );	
		
		update users set useruuid = '16f69912-d6be-4ef0-ada8-2c1c75578b51'::uuid where userid = 1;
        -- Create Technologies
            -- Get UserID
            vUserID := (select useruuid from users where userid = 1);            
        perform public.createtechnology(
            'Juice Mixer',			-- <technologyname character varying>, 
            'Machine to mix juice',	-- <technologydescription character varying>, 
            vUserID 				-- <createdby integer>
        );
        -- Create Components & Attributes
						
        perform public.setcomponent(
            'Root',   			-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Root component', 	-- <componentdescription character varying>, 
            '{Root}',			-- <attributelist text[]>, 
            '{Juice Mixer}',  				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Orange
        perform public.setcomponent(
            'Orange Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Orange Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
		 -- Johannisbeersaft
        perform public.setcomponent(
            'Johannisbeersaft',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Johannisbeersaft', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
		  -- Orange
        perform public.setcomponent(
            'Orangensaft',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Orangensaft', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
		-- Apfelsaft
        perform public.setcomponent(
            'Apfelsaft',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Apfelsaft', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Apple
        perform public.setcomponent(
            'Apple Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Apple Juice',  	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Cola
        perform public.setcomponent(
            'Cola',				-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Cola',			 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
         -- Mango
        perform public.setcomponent(
            'Mango Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Mango Juice', 		-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Ginger
        perform public.setcomponent(
            'Ginger Sirup',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Ginger Sirup', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Banana
        perform public.setcomponent(
            'Banana Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Banana Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
         -- Cherry
        perform public.setcomponent(
            'Cherry Juice',		-- <componentname character varying>, 
            'Root',	      			-- <componentparentid integer>, 
            'Cherry Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{Juice Mixer}', 				-- <technologylist text[]>, 
            vUserID 			-- <createdby integer>
         );
   END;
 $$;

DO 
$$
-- Get UserID
        DECLARE  vUserUUID uuid := (select useruuid from users where userid = 1);
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
			-- vUserUUID,
			vUserUUID  
		 
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
			-- vUserUUID,
			vUserUUID 
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
            -- vUserUUID,    						 -- <createdby integer>, 
            vUserUUID
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
            '{Ginger Sirup,Orange Juice}',    								 -- <componentlist integer[]>
			-- vUserUUID, 
			vUserUUID
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
			-- vUserUUID,   
			vUserUUID
         );
	END;
$$;
-- Create offerrequest, paymentinvoice, offer, payment and licenseorder
DO
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

	BEGIN
	FOR i IN 1..250 LOOP 
	  vRandomID := (select (trunc(random() * 3 + 1)));
	  vInvoice := (select uuid_generate_v4())::text;
	  vtechnologydatauuid := (select technologydatauuid from technologydata where technologydataid = vRandomID);
	  -- Create Buyer 	
	  --perform createuser('Buyer','Cool','buyer.cool@coolinc.com', null);
	  vBuyerUUID := (select useruuid from users limit 1);
	  -- Create OfferRequest
	  perform createofferrequest(vtechnologydatauuid,vAmount,vHSMID,vUserUUID,vBuyerUUID);

	  vCurrOfferRequest := (select currval('OfferRequestID')); 
	  -- Get OfferRequestUUID
	  vOfferRequestUUID := (select offerrequestuuid from offerrequest where offerrequestid = vCurrOfferRequest)::uuid;
	  -- Create PaymentInvoice
	  raise info '%', vCurrOfferRequest;
	  perform SetPaymentInvoiceOffer(vOfferRequestUUID, vInvoice, vUserUUID);
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
$$;