-- ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-07
-- Description: Create Base Data for the MarketplaceCode Database
-- Changes:
-- ##########################################################################
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
            'system@admin.com' -- <EmailAddress>
        );	
		
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
 
-- select * from components;
 
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
            '123456789',	     				 -- <technologydata character varying>, 
            'Cherry with Mango', 				 -- <technologydatadescription character varying>, 
            vTechnologyUUID,    								 -- <vtechnologyid integer>, 
            4.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Cherry, Mango, Yummy}', -- <taglist text[]>,            						 		 -- <createdby integer>, 
            '{Cherry Juice,Mango Juice}',    							 -- <componentlist integer[]>
			-- vUserUUID,
			vUserUUID  
		 
		 );
         -- Cherry with Cola
        perform public.settechnologydata(
            'CheCo',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Cherry with Mango', 				 -- <technologydatadescription character varying>, 
            vTechnologyUUID,    								 -- <vtechnologyid integer>, 
            1.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Cherry, Cola, Refreshing}', -- <taglist text[]>,
			'{Cherry Juice,Cola}',    		 -- <componentlist integer[]>			
            -- vUserUUID,    						 -- <createdby integer>, 
            vUserUUID
         );
          -- Ginger, Orange
        perform public.settechnologydata(
            'Ginge',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Orange with Ginger', 				 -- <technologydatadescription character varying>, 
            vTechnologyUUID,    								 -- <vtechnologyid integer>, 
            2.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Ginger, Orange}', -- <taglist text[]>,               						  
            '{Ginger Sirup,Orange Juice}',    								 -- <componentlist integer[]>
			-- vUserUUID, 
			vUserUUID
         );
         -- Banana, Mango, Orange
        perform public.settechnologydata(
            'Bamao',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Delicious Banana, Mango, Orange juice', 				 -- <technologydatadescription character varying>, 
            vTechnologyUUID,    								 -- <vtechnologyid integer>, 
            3.99,    			 				 -- <licensefee numeric>, 
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
	vtechnologydatauuid uuid := (select technologydatauuid from technologydata where technologydataid = (select max(technologydataid) from technologydata));
	vAmount integer := 5;
	vHSMID text := 'something';
	vUserUUID uuid := (select useruuid from users limit 1);
	vBuyerUUID uuid;
	vInvoice text := '{2,another stuff}';
	vOfferRequestUUID uuid;
	vPaymentInvoiceUUID uuid;
	vBitcoinTransaction text := 'Bitcoin';
	vTickedID text := 'Some Ticket';
	vOfferUUID uuid;

	BEGIN
	  -- Create Buyer 	
	  perform createuser('Buyer','Cool','buyer10.cool@coolinc.com');
	  vBuyerUUID := (select useruuid from users limit 1);
	  -- Create OfferRequest
	  perform createofferrequest(vtechnologydatauuid,vAmount,vHSMID,vUserUUID,vBuyerUUID);
	  -- Get OfferRequestUUID
	  vOfferRequestUUID := (select offerrequestuuid from offerrequest limit 1)::uuid;
	  -- Create PaymentInvoice
	  perform SetPaymentInvoiceOffer(vOfferRequestUUID, vInvoice, vUserUUID);
	  -- Get PaymentInvoiceUUID
	  vPaymentInvoiceUUID := (select paymentinvoiceuuid from paymentinvoice limit 1)::uuid;
	  -- Create Offer
	  --perform createoffer(vPaymentInvoiceUUID,vUserUUID);
	  -- Create Payment
	  perform createpayment(vPaymentInvoiceUUID::uuid, vBitcoinTransaction, vUserUUID);
	  -- Get OfferUUID
	  vOfferUUID := (select offeruuid from offer limit 1)::uuid;
	  -- Create LicenseOrder
	  perform createlicenseorder(vTickedID, vOfferUUID, vUserUUID);
	END;
$$;