CREATE OR REPLACE FUNCTION GetActivatedLicensesRanking (vCounter integer)
RETURNS integer AS
$$ 
	;with activatedLinceses as(
		select * from licenseorder lo
		join offer of on lo.offerid = of.offerid
		join paymentinvoice pi on
		of.paymentinvoiceid = pi.paymentinvoiceid
		join offerrequest oq on
		pi.offerrequestid = oq.offerrequestid
		join technologydata td on
		oq.technologydataid = td.technologydataid
		)
	select * from activatedLinceses	where 
	date_part('day',activatedat) = date_part('day',now());
 
$$ LANGUAGE SQL;

select GetActivatedLicensesAfter ('2017-02-28 14:27:20');
 

;with activatedLinceses as(
		select * from licenseorder lo
		join offer of on lo.offerid = of.offerid
		join paymentinvoice pi on
		of.paymentinvoiceid = pi.paymentinvoiceid
		join offerrequest oq on
		pi.offerrequestid = oq.offerrequestid
		join technologydata td on
		oq.technologydataid = td.technologydataid
		)
select *,
(select datediff('second','2017-02-28 15:20:00'::timestamp,activatedat::timestamp))
 from
  activatedLinceses
where 





