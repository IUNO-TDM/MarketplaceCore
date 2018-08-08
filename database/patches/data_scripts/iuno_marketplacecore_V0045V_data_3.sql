DO
$$

BEGIN
-- Ultimaker 3
perform public.setcomponent('Ultimaker 3', 'Root', 'Basic Ultimaker 3', 'components', 'en', '{machine}', '{ultimaker}', 'adb4c297-45bd-437e-ac90-f55228cb9676', '{TechnologyAdmin}');
UPDATE components SET componentuuid = 'adb4c297-45bd-437e-ac90-a33d0f24de7e'::uuid WHERE componentdescription = 'Basic Ultimaker 3' AND textid IN (SELECT textid FROM translations WHERE value = 'Ultimaker 3');

-- Ultimaker 3 Extended
perform public.setcomponent('Ultimaker 3 Extended', 'Root', 'Ultimaker 3 Extended', 'components', 'en', '{machine}', '{ultimaker}', 'adb4c297-45bd-437e-ac90-f55228cb9676', '{TechnologyAdmin}');
UPDATE components SET componentuuid = 'adb4c297-45bd-437e-ac90-d25bc3b27968'::uuid WHERE componentdescription = 'Ultimaker 3 Extended' AND textid IN (SELECT textid FROM translations WHERE value = 'Ultimaker 3 Extended');

UPDATE attributes SET attributeuuid = 'adb4c297-45bd-437e-ac90-19442dfd4eb8' WHERE attributename = 'material';
UPDATE attributes SET attributeuuid = 'adb4c297-45bd-437e-ac90-fd6d0660d0f4' WHERE attributename = 'machine';
UPDATE attributes SET attributeuuid = 'adb4c297-45bd-437e-ac90-f16b1b227b3f' WHERE attributename = 'juice';

UPDATE technologies SET technologyuuid = 'adb4c297-45bd-437e-ac90-2aed14f6b882' WHERE technologyname = 'ultimaker';

END
$$;
