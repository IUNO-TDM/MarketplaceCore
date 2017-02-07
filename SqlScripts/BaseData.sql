-- ##########################################################################
-- Author: Marcel Ely Gomes 
-- Company: Trumpf Werkzeugmaschine GmbH & Co KG
-- CreatedAt: 2017-02-07
-- Description: Create Base Data for the MarketplaceCode Database
-- Changes:
-- ##########################################################################
-- Insert System User
SELECT public.createuser(
	'System', 
	'Admin', 
	'system@admin.com'
)