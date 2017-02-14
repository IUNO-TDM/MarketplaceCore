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
    DECLARE vUserID int; 
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
            vUserID := (select max(userid) from users);            
        perform public.createtechnology(
            'Juice Mixer',			-- <technologyname character varying>, 
            'Machine to mix juice',	-- <technologydescription character varying>, 
            vUserID 				-- <createdby integer>
        );
        -- Create Components & Attributes
        perform public.setcomponent(
            'Root',   			-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Root component', 	-- <componentdescription character varying>, 
            '{Root}',			-- <attributelist text[]>, 
            '{1}',  				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Orange
        perform public.setcomponent(
            'Orange Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Orange Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Apple
        perform public.setcomponent(
            'Apple Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Apple Juice',  	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Cola
        perform public.setcomponent(
            'Cola',				-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Cola',			 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
         -- Mango
        perform public.setcomponent(
            'Mango Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Mango Juice', 		-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Ginger
        perform public.setcomponent(
            'Ginger Sirup',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Ginger Sirup', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
        -- Banana
        perform public.setcomponent(
            'Banana Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Banana Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
         -- Cherry
        perform public.setcomponent(
            'Cherry Juice',		-- <componentname character varying>, 
            1,	      			-- <componentparentid integer>, 
            'Cherry Juice', 	-- <componentdescription character varying>, 
            '{Normal}',			-- <attributelist text[]>, 
            '{1}', 				-- <technologylist integer[]>, 
            vUserID 			-- <createdby integer>
         );
   END;
 $$
 
-- select * from components;
 
DO 
$$
  BEGIN
  		-- Create TechnologyData      
        -- Cherry with Mango
        perform public.settechnologydata(
            'CheMa',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Cherry with Mango', 				 -- <technologydatadescription character varying>, 
            1,    								 -- <vtechnologyid integer>, 
            4.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Cherry, Mango, Yummy}', -- <taglist text[]>, 
            1,    						 		 -- <createdby integer>, 
            '{5,8}'    							 -- <componentlist integer[]>
         );
         -- Cherry with Cola
        perform public.settechnologydata(
            'CheCo',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Cherry with Mango', 				 -- <technologydatadescription character varying>, 
            1,    								 -- <vtechnologyid integer>, 
            1.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Cherry, Cola, Refreshing}', -- <taglist text[]>, 
            1,    						 -- <createdby integer>, 
            '{5,8}'    								 -- <componentlist integer[]>
         );
          -- Ginger, Orange
        perform public.settechnologydata(
            'Ginge',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Orange with Ginger', 				 -- <technologydatadescription character varying>, 
            1,    								 -- <vtechnologyid integer>, 
            2.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Ginger, Orange}', -- <taglist text[]>, 
            1,    						 -- <createdby integer>, 
            '{2,6}'    								 -- <componentlist integer[]>
         );
         -- Banana, Mango, Orange
        perform public.settechnologydata(
            'Bamao',		     				 -- <technologydataname character varying>, 
            '123456789',	     				 -- <technologydata character varying>, 
            'Delicious Banana, Mango, Orange juice', 				 -- <technologydatadescription character varying>, 
            1,    								 -- <vtechnologyid integer>, 
            3.99,    			 				 -- <licensefee numeric>, 
            '{Delicious, Banana, Orange, Mango, Tasty}', -- <taglist text[]>, 
            1,    						 -- <createdby integer>, 
            '{2,5,7}'    								 -- <componentlist integer[]>
         );
	END;
$$