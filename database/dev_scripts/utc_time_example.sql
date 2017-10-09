INSERT INTO public.times(
	timestmp,timewithtimezone, timewithtimezone1)
	VALUES (now(),now(), now() at time zone 'utc');
    
SELECT timestmp,timewithtimezone at time zone 'AEST', timewithtimezone1 FROM TIMES  ;

-- TRUNCATE TABLE TIMES