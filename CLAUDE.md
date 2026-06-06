# CLAUDE.md — The Bar

Context for Claude Code working in this repo. This is the working agreement.

## What this is
**The Bar** is a cocktail reference tool for use behind the bar: recipe browser,
glassware, techniques, ice guide, garnish reference, unit conversions.
It also has a stub for a Build / Balance / Batch tab (not yet built).

**Sister app: The Lab** — ingredient pairing engine.
Both share the same Supabase backend and `tokens.css`.

---

## File layout

```
index.html        ← Landing page (Zenith-X design, links to app.html and The Lab)
app.html          ← The Bar tool  ← THIS IS THE FILE TO EDIT
tokens.css        ← Shared design tokens (sage-teal accent, Fraunces/Inter)
design.md         ← Zenith-X design system spec (for the landing page)
recipes-iba.sql   ← SQL to seed Supabase with IBA recipes
supabase-schema.sql ← Full Supabase schema definition
CLAUDE.md         ← This file
```

**When editing the tool, edit `app.html`. Never edit `index.html` for tool changes.**

The landing page (`index.html`) is identical to The Lab's — keep both in sync when
making landing page changes. The only difference is which door's Enter button links
to `./app.html` vs to the sister Vercel URL.

---

## Stack & conventions
- **Single file: `app.html`** — HTML + CSS + vanilla JS. No framework, no build step.
- **Styling:** `tokens.css`. CSS variables only. Dark by default (`data-theme="dark"`).
- **JS style:** `$()` selector helper, `esc()` HTML-escaper, `const` / arrow functions,
  small render functions, plain event listeners.
- App name in all user-facing text: **The Bar.**

---

## Backend — shared Supabase project

```js
const SUPABASE_URL      = "https://zmflwqfebartfnjrsvpv.supabase.co";
const SUPABASE_ANON_KEY = "sb_publishable_paTGMPndKkktfbuqxpdLCA_pkPmHkYB";
```

**Auth header — critical:** The key is a publishable key, not a JWT.
Send it in `apikey` only. `Authorization: Bearer` returns 401.

```js
// CORRECT
{ apikey: SUPABASE_ANON_KEY }

// WRONG — returns 401
{ apikey: SUPABASE_ANON_KEY, Authorization: "Bearer " + SUPABASE_ANON_KEY }
```

**Tables used by The Bar:**
```
recipes      — 102 IBA cocktails (name, base, method, glass, profile,
               flavours[], ingredients jsonb, steps[], garnish, notes)
glassware    — standard bar glasses
techniques   — prep + assembly methods
```

**FlavorGraph tables** (`flavor_nodes`, `flavor_pairings`) are in the same project.
The Bar has a `FG` client (with `pair()` and `tags()`) but no UI wired to it yet.
Do not recreate these tables or RPCs.

---

## What's built (app.html)

| Tab | Status |
|---|---|
| Recipes | ✅ Complete — search, spirit chips, flavour chips, group-by, detail view with glass art |
| Glassware | ✅ Complete — illustrated library with specs |
| Ice | ✅ Complete — selector + detailed cards with dilution data |
| Prep | ✅ Complete — techniques with expandable steps |
| Assembly | ✅ Complete — build methods |
| Garnish | ✅ Complete — grid with placement tips |
| Pairings | ⚠️ Stub — search input exists, `fgExplore()` function needs wiring |
| Conversions | ✅ Complete — bar measures, volume, weight, temperature |
| Favourites | ✅ Complete — localStorage starred recipes |
| Settings | ✅ Complete — dark/light theme, ml/oz unit toggle |

**Responsive:** Full cross-platform layout (mobile 560px, tablet 640px, desktop 960px).

---

## What's NOT built — next priority

### Build tab (replace the "Add" stub in the nav)
Full spec below. One session should cover the whole thing.

**Ingredient table**
- Rows: name | ml | role (from `flavor_nodes.bar_role`, manually overrideable) | ABV%
- Add ingredients via autocomplete from `flavor_nodes`
- Ratio template picker: family dropdown + base spirit volume → auto-fills rows
  - Families: Sour/Daiquiri (2:1:1), Classic Sour (2:¾:¾), Stirred/Manhattan (2:1),
    Equal-parts/Negroni (1:1:1), Highball (1:3), Collins/Fizz
- Method selector: Shaken / Stirred / Built / Thrown / Highball

**Balance panel** (live, within Build tab)
- Buckets: Strong (spirit, fortified) / Sweet (syrup, liqueur) / Sour (citrus) /
  Aromatic (bitters, herb, spice) / Water (mixer)
- Sweet:Sour ratio display + target range (0.8–1.2)
- Strong% + plain-English suggestion when out of range

**ABV & Dilution panel** (live, within Build tab)
- Per ingredient: `alcohol_ml = ml × (abv / 100)`
- `final_volume = pre_dilution_volume × (1 + dilution_fraction)`
- `final_ABV = total_alcohol / final_volume × 100`
- Label everything **ESTIMATE**

**Constants to keep at top of script, clearly commented:**
```js
const ABV_DEFAULTS   = { spirit:40, fortified:17, liqueur:24, bitters:44 };
const DILUTION_FRAC  = { shaken:.28, stirred:.22, built:.10, thrown:.20, highball:.00 };
const BALANCE_TARGET = { sweetSour:[0.8,1.2], strongPct:[28,42] };
// Ratio families: name → [spirit, sweet, sour] proportions
const RATIO_FAMILIES = {
  'Sour / Daiquiri':    [2, 1,    1],
  'Classic Sour':       [2, 0.75, 0.75],
  'Stirred / Manhattan':[2, 1,    0],
  'Equal Parts':        [1, 1,    1],
  'Highball':           [1, 0,    0], // spirit only; topper added separately
};
```

### Pairings tab (already stubbed — small task)
The `fgExplore()` function in `app.html` is empty. The `FG.pair()` client is ready.
Just needs the search-input handler and a result renderer (score bars + click-to-add).

### Batch tab (after Build)
- Scale build by N servings
- Pre-add dilution water: `water_ml = dilution_fraction × pre_dilution_volume × N`
- Output: total volume, water to add, bottle yield (÷ 750 ml)

---

## Don't
- Don't add accounts or a build toolchain.
- Don't recreate FlavorGraph tables/RPCs — only read them.
- Don't commit real Supabase keys (current key is read-only publishable — safe).
- Don't add the Pairings / Ingredient List / Info experience here — that belongs in The Lab.

---

## Deployments
- **Live:** https://the-bar-kappa.vercel.app (auto-deploys from `main`)
- Landing page: `/` (index.html)
- Tool: `/app.html`
- **Repo:** https://github.com/SaturdayLim/the-bar
