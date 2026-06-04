# CLAUDE.md — The Bar

Context for Claude Code working in this repo. This is the working agreement.

## What this is
**The Bar** (previously "Back Bar") is the floor-facing cocktail app: recipe browser,
glassware, techniques, and cocktail-specific R&D tools (Build, Balance, Batch).

**Sister app: The Lab** (`flavour-studio/`) — ingredient pairing R&D. The two apps
share one Supabase backend and the same `tokens.css`.

## Stack & conventions
- **Single file: `cocktail-app.html`** — HTML + CSS + vanilla JS. No framework, no build step.
- **Styling:** `tokens.css` (shared with The Lab). CSS variables, dark by default.
- **JS style:** `$()` selector helper, `esc()` HTML-escaper, small `render*()` functions,
  plain event listeners. Keep readable for a non-developer owner.
- App name in all user-facing text: **The Bar**.

## Backend — shared Supabase project
```js
const SUPABASE_URL      = "";   // shared with The Lab
const SUPABASE_ANON_KEY = "";   // anon key — safe in client (RLS read-only)
```
Tables used by The Bar: `recipes`, `glassware`, `techniques`.
FlavorGraph tables (`flavor_nodes`, `flavor_pairings`) are also in this project;
The Bar may read them for the Build tab but does not write or recreate them.

## Features already built
- Recipe browser (search, spirit filters, group-by, detail view with line-art)
- Glassware library
- Techniques library (prep + assembly)
- Ice guide
- Garnish grid
- Conversions (bar measures, volume, weight, temperature)
- FlavorGraph pairing explorer (FG client with `pair()` and `tags()`)
- Favourites (localStorage)
- Settings (theme, units)

## Features to add (from The Lab pivot)
The following were prototyped in `flavour-studio/index.html` and should be ported here:

### Build tab
- Ingredient table: name | ml | role (from flavor_nodes.bar_role, manual override) | ABV%
- Ratio template picker: family dropdown + base spirit volume → auto-fills rows
  Families: Sour/Daiquiri (2:1:1), Classic Sour (2:¾:¾), Spirit-forward, Stirred/Manhattan,
  Equal-parts/Negroni, Highball (1:3), Collins/Fizz
- Method selector: Shaken / Stirred / Built / Thrown / Highball

### Balance panel (live, within Build tab)
- Buckets: Strong (spirit, fortified) / Sweet (syrup, liqueur) / Sour (citrus) /
  Aromatic (bitters, herb, spice) / Water (mixer)
- Sweet:Sour ratio + target range (0.8–1.2)
- Strong% + plain-English suggestion

### ABV & Dilution panel (live, within Build tab)
- Per ingredient: `alcohol_ml = ml × (abv / 100)`
- `final_volume = pre_dilution_volume × (1 + dilution_fraction)`
- `final_ABV = total_alcohol / final_volume × 100`
- Dilution fractions: shaken 0.28, stirred 0.22, built 0.10, thrown 0.20, highball 0.00
- Label everything **ESTIMATE**

### Batch tab
- Scale build by N servings
- Pre-add dilution water: `water_ml = dilution_fraction × pre_dilution_volume × N`
- Output: total batch volume, water to add, bottle yield (÷ 750 ml)

### Constants (keep at the top of the script, clearly commented)
- ABV defaults by role: spirit 40, fortified 17, liqueur 24, bitters 44, others 0
- Dilution fractions (see above)
- Balance targets (Sweet:Sour, Strong%)
- Ratio family definitions

## Don't
- Don't add accounts or a build toolchain.
- Don't recreate FlavorGraph tables/RPCs — only read them.
- Don't commit real Supabase keys.
- Don't add the Pairings / Ingredient List / Info experience here — that belongs in The Lab.
