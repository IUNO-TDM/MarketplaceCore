SELECT public.settechnologydata(
	'Test6', 
	'123413423123412341234', 
	'Sometest', 
    7,
	21.21, 
	'{Tag1,Tag2,Tag3}', 
	33,
	'SomeTechnology', 
	'{1,2,4,5}'
)

select * from technologies;
select * from components;
select * from technologydata;
select * from technologydata;
select * from technologydatacomponents;
select * from technologydatatags;
select * from tags;
select * from logtable;

-- truncate table logtable

select componentid from components where componentid = 2
select componentid from components where (componentid = ANY('{2,3,4,5,6,7,8,9}'))

SELECT public.createcomponents(
	1, -- <componentparentid integer>, 
	'Tech3', -- <componentname character varying>, 
	'Some Tech', -- <componentdescription character varying>, 
	33 -- <createdby integer>
)

 