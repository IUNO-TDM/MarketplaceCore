DO
$$

BEGIN
-- Ultimaker 3
perform public.setcomponent('Ultimaker 3', 'Root', 'Basic Ultimaker 3', 'components', 'en', '{machine}', '{ultimaker}', '67e6ceb8-c633-47a9-8c69-f55228cb9676', '{TechnologyAdmin}');
UPDATE components SET componentuuid = '902bd58d-7706-4dad-b592-a33d0f24de7e'::uuid WHERE componentdescription = 'Basic Ultimaker 3' AND textid IN (SELECT textid FROM translations WHERE value = 'Ultimaker 3');

-- Ultimaker 3 Extended
perform public.setcomponent('Ultimaker 3 Extended', 'Root', 'Ultimaker 3 Extended', 'components', 'en', '{machine}', '{ultimaker}', '67e6ceb8-c633-47a9-8c69-f55228cb9676', '{TechnologyAdmin}');
UPDATE components SET componentuuid = '5d12f242-cc8a-4162-b8c2-d25bc3b27968'::uuid WHERE componentdescription = 'Ultimaker 3 Extended' AND textid IN (SELECT textid FROM translations WHERE value = 'Ultimaker 3 Extended');

END
$$;
