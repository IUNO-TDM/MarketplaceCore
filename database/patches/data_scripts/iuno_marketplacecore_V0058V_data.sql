--#######################################################################################################
-- Patch 0058 (data): example recipes in plaintext for the local marketplace.
-- Ingredients (components) are created by the earlier data patches; the recipes use the standard
-- ingredients of the machines (water, apple, orange, mango, cherry, banana, maracuja, pineapple). Recipes follow the website
-- validation (total amount 90-130, sleep 0, timing 2, max 8 lines with max 8 components).
-- The recipes belong to a fixed system user and carry no price or license data.
--#######################################################################################################

INSERT INTO patches (patchname, patchnumber, patchdescription, startat)
VALUES ('iuno_marketplacecore_V0058V_data', 58, 'Seed: example recipes in plaintext', now());

DO
$$
DECLARE
    vTechnology uuid := 'da17a8fc-a5b3-40a4-b6a5-276667db027a';
    vCreator    uuid := '00000000-0000-4000-8000-000000000001';
    vRoles      text[] := '{TechnologyDataOwner}';
    vApple      text := '198f1571-4846-4467-967a-00427ab0208d';
    vOrange     text := 'f6d361a9-5a6f-42ad-bff7-0913750809e4';
    vMango      text := 'fac1ee6f-185f-47fb-8c56-af57cd428aa8';
    vPineapple  text := 'bf2cfd66-5b6f-4655-8e7f-04090308f6db';
    vMaracuja   text := '14b72ce5-fec1-48ec-83ff-24b124f98dc8';
    vWater      text := '570a5df0-a044-4e22-b6e6-b10af872d75c';
    vCherry     text := '0425393d-5b84-4815-8eda-1c27d35766cf';
    vBanana     text := '4cfa2890-6abd-4e21-a7ab-17613ed9a5c9';
    vComp       text;
BEGIN
    FOREACH vComp IN ARRAY ARRAY [vApple, vOrange, vMango, vPineapple, vMaracuja, vWater, vCherry, vBanana]
        LOOP
            IF NOT EXISTS(SELECT 1 FROM components WHERE componentuuid = vComp::uuid) THEN
                RAISE EXCEPTION 'Seed ingredient % is missing', vComp;
            END IF;
        END LOOP;

    PERFORM public.settechnologydata(
            'Tropical Mix',
            format('{"recipe":{"lines":[{"sleep":0,"timing":2,"components":[{"ingredient":"%s","amount":40},{"ingredient":"%s","amount":30}]},{"sleep":0,"timing":2,"components":[{"ingredient":"%s","amount":30}]}]}}',
                   vOrange, vMango, vPineapple),
            'Orange, mango and pineapple juice.',
            vTechnology, NULL, ARRAY [vOrange, vMango, vPineapple], NULL, '#ff9900', false, NULL,
            vCreator, vRoles);

    PERFORM public.settechnologydata(
            'Apple Spritzer',
            format('{"recipe":{"lines":[{"sleep":0,"timing":2,"components":[{"ingredient":"%s","amount":50},{"ingredient":"%s","amount":20}]},{"sleep":0,"timing":2,"components":[{"ingredient":"%s","amount":30}]}]}}',
                   vApple, vWater, vOrange),
            'Light apple juice with mineral water and a splash of orange.',
            vTechnology, NULL, ARRAY [vApple, vWater, vOrange], NULL, '#99cc33', false, NULL,
            vCreator, vRoles);

    PERFORM public.settechnologydata(
            'Cherry Banana',
            format('{"recipe":{"lines":[{"sleep":0,"timing":2,"components":[{"ingredient":"%s","amount":40},{"ingredient":"%s","amount":30}]},{"sleep":0,"timing":2,"components":[{"ingredient":"%s","amount":30}]}]}}',
                   vCherry, vBanana, vApple),
            'Cherry and banana juice on an apple base.',
            vTechnology, NULL, ARRAY [vCherry, vBanana, vApple], NULL, '#cc0033', false, NULL,
            vCreator, vRoles);

    PERFORM public.settechnologydata(
            'Maracuja Sunrise',
            format('{"recipe":{"lines":[{"sleep":0,"timing":2,"components":[{"ingredient":"%s","amount":40},{"ingredient":"%s","amount":30}]},{"sleep":0,"timing":2,"components":[{"ingredient":"%s","amount":30}]}]}}',
                   vMaracuja, vOrange, vWater),
            'Maracuja and orange juice, diluted with mineral water.',
            vTechnology, NULL, ARRAY [vMaracuja, vOrange, vWater], NULL, '#ffcc00', false, NULL,
            vCreator, vRoles);
END;
$$;

UPDATE patches SET status = 'OK', endat = now() WHERE patchnumber = 58;
