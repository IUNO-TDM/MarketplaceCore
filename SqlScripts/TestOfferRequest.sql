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
	  vBuyerUUID := (select createuser('Buyer','Cool','buyer14.cool@coolinc.com'))::uuid;
	  -- Create OfferRequest
	  perform createofferrequest(vtechnologydatauuid,vAmount,vHSMID,vUserUUID,vBuyerUUID);
	  -- Get OfferRequestUUID
	  vOfferRequestUUID := (select offerrequestuuid from offerrequest limit 1)::uuid;
	  -- Create PaymentInvoice
	  perform createpaymentinvoice(vInvoice,vOfferRequestUUID,vUserUUID);
	  -- Get PaymentInvoiceUUID
	  vPaymentInvoiceUUID := (select paymentinvoiceuuid from paymentinvoice limit 1)::uuid;
	  -- Create Offer
	  perform createoffer(vPaymentInvoiceUUID,vUserUUID);
	  -- Create Payment
	  perform createpayment(vPaymentInvoiceUUID, vBitcoinTransaction, vUserUUID);
	  -- Get OfferUUID
	  vOfferUUID := (select offeruuid from offer limit 1)::uuid;
	  -- Create LicenseOrder
	  perform createlicenseorder(vTickedID, vOfferUUID, vUserUUID);
	END;
$$;

select * from technologydata
select * from technologies
select * from logtable order by 1 desc;
select * from offerrequest;
select * from paymentinvoice;
select * from offer;
select * from transactions;
select * from licenseorder;
select * from payment;
 select * from users;

select getactivatedlicensesafter('2017-02-28 17:32:00');
 