# Zenith-X Design System
**Version:** neuform-top-creators-featured  
**Author:** Aksonvady Phomhome (@aksonvady)  
**Source:** Aura / Neuform Featured — Core Systems Content Section

> A full-width, production-ready design language built for landing pages and component libraries. Dark-mode-first, high-contrast, technically precise. The visual tone is mission-critical systems UI: dense, purposeful, no decorative noise.

---

## Color

All tokens are defined for dark-mode. Do not invert or swap the color mode unless a source variant explicitly supports it.

| Token            | Value       | Role                                      |
|------------------|-------------|-------------------------------------------|
| `primary`        | `#F4FF2B`   | Brand accent — CTAs, highlights, active states |
| `secondary`      | `#0F191E`   | Deep background — page base               |
| `accent`         | `#F4FF2B`   | Same as primary; used for icon fills, badges |
| `background`     | `#0F191E`   | Page/canvas background                    |
| `surface`        | `#E2F1F2`   | Card surfaces, elevated containers        |
| `text-primary`   | `#FFFFFF`   | Body copy, headings on dark               |
| `text-secondary` | `#A1A1AA`   | Metadata, captions, muted labels          |
| `border`         | `#27272A`   | Dividers, card outlines, input borders    |

**Rules:**
- `background` and `surface` must remain distinct — never collapse them into the same value.
- `primary` / `accent` (`#F4FF2B`) is the only warm tone in the palette; use it sparingly and deliberately.
- `text-secondary` on `background` is a low-contrast pairing — reserve for non-essential metadata only.

---

## Typography

### Typefaces

| Role             | Family           | Notes                                      |
|------------------|------------------|--------------------------------------------|
| Display / Headings | `Inter`        | All display moments, hero text, section headers |
| Body / Copy      | `Inter`          | Paragraphs, descriptions, UI text          |
| Labels / Mono    | `JetBrains Mono` | Technical metadata, badges, system labels, counters, code |

### Scale

| Token        | Size    | Weight | Line Height | Usage                          |
|--------------|---------|--------|-------------|--------------------------------|
| `display-lg` | `~48px` | 700    | 1.1         | Hero headings, project designations |
| `body-md`    | `~16px` | 400    | 1.6         | Body paragraphs, descriptions  |
| `label-md`   | `~12px` | 500    | 1.4         | Badges, tags, system labels (mono) |

**Rules:**
- Technical metadata (IDs, counters, system node labels) always use `JetBrains Mono`.
- Do not introduce decorative or serif faces. Inter + JetBrains Mono is the full type system.

---

## Spacing

Base unit: `8px`. All spacing should be a multiple of this base.

| Token             | Value  | Usage                                   |
|-------------------|--------|-----------------------------------------|
| `base`            | `8px`  | Minimum spacing unit                    |
| `gap`             | `16px` | Inline gaps, flex/grid item spacing     |
| `card-padding`    | `24px` | Internal card padding                   |
| `section-padding` | `80px` | Top/bottom padding for full-width sections |

---

## Border Radius

| Token     | Value    | Usage                                   |
|-----------|----------|-----------------------------------------|
| `card`    | `16px`   | Cards, panels, containers               |
| `control` | `8px`    | Buttons, inputs, dropdowns              |
| `pill`    | `9999px` | Tags, badges, toggle chips             |

All interactive controls share the same radius language. Do not mix radii within a single component family.

---

## Layout

- **Grid:** Full-width sections with a constrained inner max-width. Cards use a consistent grid direction — do not switch axis per section.
- **First viewport:** The first screen must carry the focal object and primary heading. Never push the lead element below the fold.
- **Responsive stacking:** Multi-column layouts collapse to single-column at mobile. Maintain the same card density — do not switch to a carousel.
- **Section rhythm:** `section-padding` (`80px`) top/bottom on every full-width block. Maintain this rhythm; do not tighten sections to feel "compact."
- **Visual density:** High density is intentional. Keep card content rich. Do not whitespace-inflate to feel "airy" — that contradicts the system aesthetic.

### Composition Hierarchy

The source defines these key heading levels in order:

1. **Project Designation** — top-level identity label
2. **Zenith-7** — focal object / hero identifier
3. **System Library** — section category
4. **Symbol / Structure / Identity** — sub-section labels

Preserve this hierarchy when mapping to new content. Do not flatten to a single heading level.

---

## Components

### Card

```
background:  var(--surface)         // #E2F1F2
border:      1px solid var(--border) // #27272A
border-radius: var(--radius-card)   // 16px
padding:     var(--card-padding)    // 24px
```

- Cards carry dense content: heading, metadata, tags, and a body element.
- Do not reduce card content to a title + CTA only — that loses the system's information density.
- Hover: subtle lift (translate Y -2px to -4px) with a smooth ease-out (~200ms).

### Button

```
background:  var(--primary)         // #F4FF2B
color:       var(--secondary)       // #0F191E  (dark text on bright bg)
border-radius: var(--radius-control) // 8px
padding:     8px 20px
font-family: Inter
font-weight: 600
```

**Secondary / Ghost variant:**
```
background:  transparent
border:      1px solid var(--border)
color:       var(--text-primary)
```

- Button text is always dark (`#0F191E`) on primary, and white on ghost.
- Do not use rounded-pill radius on buttons unless explicitly tagged as a pill variant.

### Badge / Tag

```
background:  var(--border)          // #27272A
color:       var(--text-secondary)  // #A1A1AA
border-radius: var(--radius-pill)   // 9999px
padding:     4px 10px
font-family: JetBrains Mono
font-size:   11px
font-weight: 500
text-transform: uppercase
letter-spacing: 0.05em
```

**Active / highlighted badge:**
```
background:  var(--primary)         // #F4FF2B
color:       var(--secondary)       // #0F191E
```

### Navigation

- Top-aligned horizontal nav on desktop, drawer/hamburger on mobile.
- Active state: `primary` underline or background pill.
- Links: `text-primary` default, `primary` on hover.
- No drop-shadows on the nav bar. Use a `border-bottom: 1px solid var(--border)` separator only.

---

## Motion

All motion should feel deliberate and system-like — not playful. Easing is smooth and restrained.

| Pattern              | Timing       | Easing              | Notes                                     |
|----------------------|--------------|---------------------|-------------------------------------------|
| Masked reveal        | 600–800ms    | `cubic-bezier(.4,0,.2,1)` | Clip-path or opacity reveal on enter |
| Staggered entrance   | 80–120ms delay per item | same | Apply to card lists and grid items   |
| Hover lift (card)    | 200ms        | `ease-out`          | `translateY(-3px)` + optional shadow      |
| Hover lift (button)  | 150ms        | `ease-out`          | `translateY(-1px)`                        |
| Scroll-triggered     | 500ms        | `ease-in-out`       | Trigger at 80% viewport entry             |
| Ambient / idle       | 4–8s loop    | `ease-in-out`       | Subtle background gradient drift or pulse |

**Rules:**
- Never use `ease-in` alone for reveals — it feels abrupt.
- Keep ambient motion below 3% opacity delta or 4px movement so it doesn't compete with content.
- No bounce, spring, or overshoot easing in this system.

---

## Guardrails

These constraints are non-negotiable when skinning this system over a new app:

1. **Do not flatten** the layout into a generic symmetric card grid. The source uses deliberate asymmetry and density.
2. **Do not swap color mode.** This is a dark-mode-first system. Light mode is not a variant unless explicitly built.
3. **Preserve the first viewport signal.** The hero frame must carry the primary focal element — do not push it below the fold with nav + banner stacking.
4. **Maintain radius consistency.** Cards at `16px`, controls at `8px`, pills at `9999px`. Do not mix.
5. **Keep border language.** `1px solid #27272A` is the universal border. Do not use box-shadow as a substitute for borders on cards.
6. **Preserve mono type for technical content.** Any counter, ID, system label, or code snippet uses `JetBrains Mono`, not Inter.
7. **Do not inflate whitespace.** High density is a design choice, not a problem to fix.

---

## Skinning Checklist

When applying this system to a new app, verify:

- [ ] CSS custom properties set for all color tokens
- [ ] Inter loaded (weights 400, 600, 700)
- [ ] JetBrains Mono loaded (weight 500)
- [ ] Spacing scale applied as CSS variables
- [ ] Border-radius tokens applied as CSS variables
- [ ] Card, button, and badge components match spec above
- [ ] Motion timings and easings match the table
- [ ] First viewport contains the primary focal element
- [ ] No light-mode styles introduced unless intentional
- [ ] All technical/metadata text rendered in mono face
