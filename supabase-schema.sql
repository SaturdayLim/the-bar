-- ============================================================
-- Back Bar — Supabase schema + seed
-- Paste this whole file into the Supabase SQL Editor and run it once.
-- It creates the tables, turns on row-level security with public
-- read-only access (so the app can read but the public cannot write),
-- and loads the 12 classic recipes + 8 glasses the app ships with.
-- ============================================================

-- ---------- Tables ----------
create table if not exists public.recipes (
  id          bigint generated always as identity primary key,
  name        text not null,
  base        text,                 -- e.g. Whiskey, Gin, Rum, Tequila, Vodka
  method      text,                 -- Stirred / Shaken / Built
  glass       text,                 -- must match a glassware.name
  served      text,
  profile     text,
  ingredients jsonb default '[]',   -- [{ "q": "60 ml", "n": "Bourbon" }]
  garnish     text,
  steps       jsonb default '[]',   -- ["step one", "step two", ...]
  notes       text,
  created_at  timestamptz default now()
);

create table if not exists public.glassware (
  id          bigint generated always as identity primary key,
  name        text not null,
  aka         text,
  capacity    text,
  best_for    text,
  description  text,                -- the app maps this to "desc" on read
  created_at  timestamptz default now()
);

-- ---------- Row-level security: public can read, nobody can write ----------
alter table public.recipes   enable row level security;
alter table public.glassware enable row level security;

drop policy if exists "Public read recipes"   on public.recipes;
drop policy if exists "Public read glassware" on public.glassware;

create policy "Public read recipes"
  on public.recipes for select
  to anon, authenticated
  using (true);

create policy "Public read glassware"
  on public.glassware for select
  to anon, authenticated
  using (true);

-- (No insert/update/delete policies are created, so writes are blocked for
--  the public anon key. You update content from the Supabase dashboard, or
--  later via an authenticated admin role.)

-- ---------- Seed: glassware ----------
insert into public.glassware (name, aka, capacity, best_for, description) values
('Rocks','Old Fashioned / lowball','200–300 ml','Spirit-forward & on-the-rocks','A sturdy, short tumbler with a heavy base. Built for stirring spirit-forward drinks over a single large cube.'),
('Coupe','Champagne saucer','150–210 ml','Shaken & stirred drinks served up','A stemmed, shallow bowl. The modern workhorse for ''up'' cocktails — elegant and far less prone to spilling than a martini glass.'),
('Martini','Cocktail glass','120–240 ml','Martinis & Manhattans, up','The iconic stemmed V. Striking on the bar but tippy — fill conservatively and carry with care.'),
('Highball','Tall tumbler','240–350 ml','Spirit + a single mixer','A tall, straight glass that keeps fizz lively and the serve cold. Gin & tonic, Paloma, whisky-soda.'),
('Collins','Tall fizz glass','300–410 ml','Long drinks over crushed ice','Taller and narrower than a highball, ideal for fizzes and churned drinks like the Mojito or Tom Collins.'),
('Nick & Nora','—','120–180 ml','Stirred drinks served up','A small stemmed glass with a rounded bowl. The refined choice for a Manhattan or Martinez — holds aroma, resists spills.'),
('Hurricane','Tiki tulip','440–590 ml','Tropical & blended drinks','A large curved tulip on a short foot. Made for showy, ice-packed tiki serves with plenty of garnish.'),
('Copper Mug','Mule mug','350–500 ml','Moscow & other Mules','Insulating copper keeps the serve frosty and the ginger sharp. Traditional home of the Moscow Mule.');

-- ---------- Seed: recipes ----------
insert into public.recipes (name, base, method, glass, served, profile, ingredients, garnish, steps, notes) values
('Old Fashioned','Whiskey','Stirred','Rocks','On a large cube',
 'The original cocktail — spirit-forward, rich and barely sweet.',
 '[{"q":"60 ml","n":"Bourbon"},{"q":"1 cube","n":"Demerara sugar (or 7.5 ml syrup)"},{"q":"2 dashes","n":"Angostura bitters"},{"q":"Splash","n":"Water"}]'::jsonb,
 'Expressed orange peel; optional brandied cherry',
 '["Saturate the sugar with bitters and a splash of water; muddle to a paste.","Add bourbon and a large ice cube.","Stir 20–30 seconds until chilled and integrated.","Express the orange peel over the surface and drop it in."]'::jsonb,
 'Dates to the early 1800s as the literal definition of a ''cock-tail'': spirit, sugar, water, bitters. When in doubt, under-sweeten.'),

('Negroni','Gin','Stirred','Rocks','On the rocks',
 'Equal parts, bittersweet and bracing — an aperitivo benchmark.',
 '[{"q":"30 ml","n":"London dry gin"},{"q":"30 ml","n":"Campari"},{"q":"30 ml","n":"Sweet vermouth"}]'::jsonb,
 'Orange peel or half-wheel',
 '["Combine all over ice in a mixing glass.","Stir until well chilled, about 20 seconds.","Strain over a large cube in a rocks glass.","Express orange peel and garnish."]'::jsonb,
 'Born in Florence around 1919 when Count Negroni asked for an Americano with gin instead of soda. Swap gin for prosecco to make a Sbagliato.'),

('Daiquiri','Rum','Shaken','Coupe','Up',
 'The three-ingredient sour that tests a bartender — clean, bright, balanced.',
 '[{"q":"60 ml","n":"White rum"},{"q":"22.5 ml","n":"Fresh lime juice"},{"q":"15 ml","n":"Simple syrup (1:1)"}]'::jsonb,
 'Lime wheel',
 '["Combine all in a shaker with ice.","Shake hard for 10–12 seconds.","Double-strain into a chilled coupe.","Garnish with a lime wheel."]'::jsonb,
 'Named for a beach near Santiago de Cuba. Always fresh lime, always cold glass — there is nowhere to hide.'),

('Margarita','Tequila','Shaken','Rocks','Salt rim, on the rocks',
 'Tequila sour with orange — crisp, savoury, citrus-driven.',
 '[{"q":"50 ml","n":"Blanco tequila"},{"q":"25 ml","n":"Cointreau"},{"q":"20 ml","n":"Fresh lime juice"}]'::jsonb,
 'Half salt rim, lime wheel',
 '["Salt half the rim so guests can choose.","Shake tequila, Cointreau and lime with ice.","Strain over fresh ice (or serve up).","Garnish with a lime wheel."]'::jsonb,
 'A member of the Margarita/Sidecar family of sours sweetened with orange liqueur. Salt only half the rim — it sharpens the citrus without overwhelming it.'),

('Manhattan','Whiskey','Stirred','Nick & Nora','Up',
 'Rye and sweet vermouth — silky, warming, classically elegant.',
 '[{"q":"60 ml","n":"Rye whiskey"},{"q":"30 ml","n":"Sweet vermouth"},{"q":"2 dashes","n":"Angostura bitters"}]'::jsonb,
 'Brandied cherry',
 '["Combine all over ice in a mixing glass.","Stir until well chilled.","Strain into a chilled Nick & Nora.","Garnish with a brandied cherry."]'::jsonb,
 'A New York classic from the late 1800s. Rye keeps it dry; bourbon makes it rounder. A 2:1 ratio is the modern standard.'),

('Whiskey Sour','Whiskey','Shaken','Rocks','On the rocks',
 'Bourbon, lemon and a silky egg-white cap — tart, plush, easy to love.',
 '[{"q":"60 ml","n":"Bourbon"},{"q":"22.5 ml","n":"Fresh lemon juice"},{"q":"15 ml","n":"Simple syrup"},{"q":"15 ml","n":"Egg white (optional)"}]'::jsonb,
 'Angostura dots; lemon and cherry',
 '["If using egg white, dry-shake all without ice first.","Add ice and shake hard until frothy.","Strain over fresh ice in a rocks glass.","Dot bitters on the foam and drag a pick through."]'::jsonb,
 'The egg white is optional but transforms the texture. No egg? A short, harder shake still gives a respectable cap.'),

('Mojito','Rum','Built','Collins','Over crushed ice',
 'Mint, lime and soda over rum — long, cooling, effortless in heat.',
 '[{"q":"60 ml","n":"White rum"},{"q":"22.5 ml","n":"Fresh lime juice"},{"q":"2 tsp","n":"Caster sugar"},{"q":"8 leaves","n":"Fresh mint"},{"q":"Top","n":"Soda water"}]'::jsonb,
 'Mint sprig, lime wheel',
 '["Gently press mint with sugar and lime — bruise, don''t shred.","Add rum and fill with crushed ice.","Top with soda and churn briefly to lift the mint.","Cap with more ice and a generous mint sprig."]'::jsonb,
 'A Cuban highball. Slap the garnish mint between your palms to release oils before serving — aroma is half the drink.'),

('Dry Martini','Gin','Stirred','Martini','Up',
 'Cold, clean and aromatic — the most personal drink on the list.',
 '[{"q":"60 ml","n":"London dry gin"},{"q":"10 ml","n":"Dry vermouth"},{"q":"1 dash","n":"Orange bitters (optional)"}]'::jsonb,
 'Lemon twist or olives',
 '["Combine gin and vermouth over plenty of ice.","Stir 30 seconds — you want it ice-cold and lightly diluted.","Strain into a frozen glass.","Express a lemon twist or add olives."]'::jsonb,
 'Ratios are a matter of faith, from 2:1 to a whisper of vermouth. Keep the glass and the gin in the freezer for the coldest possible serve.'),

('Espresso Martini','Vodka','Shaken','Coupe','Up',
 'Vodka, coffee and liqueur — bittersweet, glossy, wide awake.',
 '[{"q":"50 ml","n":"Vodka"},{"q":"30 ml","n":"Fresh espresso"},{"q":"20 ml","n":"Coffee liqueur"},{"q":"10 ml","n":"Simple syrup (to taste)"}]'::jsonb,
 'Three coffee beans',
 '["Pull the espresso fresh and combine all with ice.","Shake very hard — the crema comes from aeration.","Double-strain into a chilled coupe.","Float three coffee beans on the foam."]'::jsonb,
 'Created by Dick Bradsell in 1980s London. Hot, fresh espresso and a hard shake are non-negotiable for that signature foam.'),

('Aviation','Gin','Shaken','Coupe','Up',
 'Floral and tart with a sky-blue tint from crème de violette.',
 '[{"q":"45 ml","n":"Gin"},{"q":"15 ml","n":"Maraschino liqueur"},{"q":"15 ml","n":"Fresh lemon juice"},{"q":"7.5 ml","n":"Crème de violette"}]'::jsonb,
 'Brandied cherry',
 '["Combine all in a shaker with ice.","Shake until well chilled.","Double-strain into a chilled coupe.","Sink a brandied cherry."]'::jsonb,
 'A pre-Prohibition classic from Hugo Ensslin. Go light on the violette — too much and it turns soapy rather than floral.'),

('Mai Tai','Rum','Shaken','Rocks','Over crushed ice',
 'Rum, lime, orange and almond — the benchmark tiki drink, not a sugar bomb.',
 '[{"q":"30 ml","n":"Aged Jamaican rum"},{"q":"30 ml","n":"Rhum agricole (or dark rum)"},{"q":"15 ml","n":"Orange curaçao"},{"q":"15 ml","n":"Orgeat"},{"q":"22.5 ml","n":"Fresh lime juice"}]'::jsonb,
 'Spent lime shell, mint sprig',
 '["Shake everything briefly with crushed ice.","Pour unstrained into a double rocks glass.","Add more crushed ice to fill.","Garnish with the lime shell and a mint bouquet."]'::jsonb,
 'Trader Vic''s 1944 original is a sour, not a fruit punch. A blend of rums gives it the funk and backbone that define the drink.'),

('Cosmopolitan','Vodka','Shaken','Martini','Up',
 'Citron vodka and cranberry — tart, dry and a vivid pink.',
 '[{"q":"45 ml","n":"Citron vodka"},{"q":"15 ml","n":"Cointreau"},{"q":"15 ml","n":"Cranberry juice"},{"q":"7.5 ml","n":"Fresh lime juice"}]'::jsonb,
 'Lime wheel or flamed orange peel',
 '["Combine all in a shaker with ice.","Shake until well chilled.","Double-strain into a chilled glass.","Garnish with a lime wheel or flamed orange."]'::jsonb,
 'A 1980s–90s icon. Use just enough cranberry for colour and tartness — it''s a citrus drink, not a sweet one.');

-- ---------- Table: techniques ----------
create table if not exists public.techniques (
  id         bigint generated always as identity primary key,
  name       text not null,
  category   text,                 -- 'Method' or 'Prep'
  summary    text,
  steps      jsonb default '[]',
  tip        text,
  created_at timestamptz default now()
);

alter table public.techniques enable row level security;
drop policy if exists "Public read techniques" on public.techniques;
create policy "Public read techniques"
  on public.techniques for select
  to anon, authenticated
  using (true);

insert into public.techniques (name, category, summary, steps, tip) values
('Stir','Method','Chill and dilute spirit-forward drinks with silk and clarity.',
 '["Combine the ingredients in a mixing glass filled with ice.","Stir smoothly with a bar spoon for 20–30 seconds.","Strain into the chilled serving glass."]'::jsonb,
 'If every ingredient is a spirit — Martini, Negroni, Manhattan — stir, never shake, or it turns cloudy and flat.'),
('Shake','Method','Chill, dilute and aerate any drink with juice, egg or dairy.',
 '["Add the ingredients and ice to a shaker tin.","Shake hard for 10–15 seconds, until the tin frosts over.","Strain — double-strain if there''s fruit pulp or egg."]'::jsonb,
 'Rule of thumb: if it has citrus, juice or egg, give it a shake.'),
('Build','Method','Assemble the drink directly in the glass it''s served in.',
 '["Add the ingredients to the serving glass over fresh ice.","Stir briefly to combine.","Top any carbonated mixer last, and stir minimally."]'::jsonb,
 'Used for Old Fashioneds and highballs. Keep the stir short on fizzy drinks to keep the bubbles.'),
('Muddle','Method','Press fresh ingredients to release their oils, juice and aroma.',
 '["Put the fruit, herbs or sugar in the base of the glass or tin.","Press firmly a few times with a muddler.","Stop once it''s aromatic — don''t pulverise."]'::jsonb,
 'Press, don''t shred. Torn mint and herbs give off bitter, grassy notes.'),
('Layer / Float','Method','Stack visually distinct strata by density.',
 '["Start with the densest, sweetest liquid in the glass.","Rest a bar spoon rounded-side up just above the surface.","Pour the next liquid slowly over the spoon so it spreads gently."]'::jsonb,
 'More sugar means denser, so it sinks lower. Pour slowest for the sharpest line.'),
('Swizzle','Method','Churn a drink over crushed ice until the glass frosts.',
 '["Fill the glass with crushed ice and add the ingredients.","Spin a swizzle stick or bar spoon between your palms.","Churn until frost forms on the outside of the glass."]'::jsonb,
 'A swizzle mixes and chills hard at once — top with fresh crushed ice and garnish generously.'),
('Simple syrup','Prep','The base sweetener behind countless cocktails.',
 '["Combine equal parts sugar and hot water (1:1), or 2:1 for ''rich'' syrup.","Stir until fully dissolved, then cool.","Bottle and refrigerate."]'::jsonb,
 '1:1 keeps about two weeks; 2:1 a little longer. A splash of vodka extends its life.'),
('Infusion','Prep','Steep flavour — chilli, fruit, herbs, tea — into a spirit.',
 '["Combine the flavouring and the spirit in a sealed jar.","Steep at room temperature, tasting often.","Strain out the solids once the flavour is right."]'::jsonb,
 'Timing varies wildly: chilli takes minutes, vanilla takes days. You can''t undo over-infusion, so taste early.'),
('Steeping','Prep','A gentler, shorter extraction for delicate botanicals.',
 '["Add tea, flowers or soft herbs to spirit or warm syrup.","Leave only briefly — minutes, not days.","Strain promptly to avoid bitterness."]'::jsonb,
 'Reach for steeping over full infusion for anything that turns bitter fast, like tea or floral botanicals.'),
('Fat-wash','Prep','Carry savoury, fatty flavour into a clear spirit.',
 '["Stir melted fat — bacon, brown butter, coconut oil — into the spirit.","Rest a few hours so the flavour transfers.","Freeze until the fat sets, then lift or filter it off."]'::jsonb,
 'All the flavour, none of the grease — freezing is what lets you remove the fat cleanly.'),
('Clarification','Prep','Strip out solids for a crystal-clear, silky drink.',
 '["Warm the milk, then pour the acidic cocktail into it — not the other way.","Let it curdle as the acid splits the milk.","Filter slowly through a coffee filter until it runs clear."]'::jsonb,
 'Milk-washing also rounds off harsh edges and adds texture, not just clarity.'),
('Oleo-saccharum','Prep','An oily citrus sugar — the soul of a good punch.',
 '["Peel citrus and muddle the peels with sugar.","Leave one to two hours; the sugar pulls the oils into a syrup.","Strain off the peels before using."]'::jsonb,
 'Latin for ''oil-sugar''. It captures bright peel oils that juice alone can''t give you.'),
('Garnish prep','Prep','The finishing aroma and look of the drink.',
 '["Cut twists from unwaxed citrus, avoiding the bitter white pith.","Express the peel over the drink to spray its oils, then perch or drop it.","Prep dehydrated wheels and cherries ahead of service."]'::jsonb,
 'Express, don''t just place it. A twist''s aroma reaches the nose before the first sip.'),
('Blanching','Prep','Briefly boil then ice-shock herbs to set colour and flavour.',
 '["Plunge herbs like mint or basil into boiling water for a few seconds.","Move them straight to iced water to stop the cooking.","Blend into syrups or oils for a vivid, clean green."]'::jsonb,
 'Blanching locks in bright colour and tames raw, grassy notes — ideal for green syrups and herb oils.');
