# Free Trial Guide – CSS-Only Style Review

Review of `freeTrialGuide.css` for consistency, maintainability, and best practices. **No HTML or JS changes.**

---

## 1. Color Palette Consistency

### 1.1 Core palette (used consistently)
- **Primary navy:** `#143b58` – headers, borders, accents ✓
- **Secondary blue:** `#1e5a7a` – gradients, current step ✓
- **Gold accent:** `#ba8b2d` – CTAs, highlights ✓
- **Neutral grays:** `#444`, `#706e6b`, `#555`, `#666`, `#333`, `#2c2c2c` – body text ✓
- **Borders/surfaces:** `#e5e5e5`, `#e0e0e0`, `#e8eef3`, `#f8f9fa`, `#f8f9fb` ✓

### 1.2 Inconsistencies to fix

| Issue | Location | Recommendation |
|-------|----------|----------------|
| **Intro accent vs rest of guide** | `.intro-section` uses `#8B6914` and `border-left: 4px solid #8B6914`; `.intro-section strong` uses `#8B6914`. Everywhere else gold is `#ba8b2d`. | Use `#ba8b2d` in `.intro-section` (border + strong) so one gold is used across the guide. |
| **Tip/warning yellow** | `.tip-box`, `.tip-inline`, `.prompt-card` use `#fff8e6`; one typo exists as `#fff8e6` in `.tip-box` (line 951) – verify it’s `#fff8e6`. | Confirm all tip/warning backgrounds use the same hex (e.g. `#fff8e6`). |
| **Em section header** | `.em-section h3` uses `color: #000000` (line 1519); `.em-section-header h3` uses `#143b58`. | Use `#143b58` in `.em-section h3` so Event Monitoring headings match the rest of the guide. |
| **Em section intro** | `.em-section .intro-text` uses `#333333`; `.intro-text` global uses `#444`. | Use `#444` (or the same token) for `.em-section .intro-text` so body text is consistent. |

---

## 2. `!important` usage

These rules use `!important` and can make future overrides harder:

| Selector | Purpose |
|----------|---------|
| `.trial-highlight` | `margin-top: 1rem !important` |
| `.detail-note` | `color: #706e6b !important; margin-top: 0.75rem !important` |
| `.nav-btn-brand` / `.nav-btn-neutral` | Multiple `!important` on background, color, border (likely to override Lightning base) |

**Recommendation:**  
- Keep `!important` on nav buttons only if you must override LWC/SLDS.  
- For `.trial-highlight` and `.detail-note`, try removing `!important` and tightening selectors (e.g. `.intro-section .trial-highlight`, `.object-detail-content .detail-note`) so they win without `!important`.  
- Add a short comment above nav-btn overrides, e.g. `/* Override SLDS button in host context */`.

---

## 3. Duplicate / overlapping rules

### 3.1 Code block naming
- **`code.code-block`** (line ~1143): block-level dark-theme code (background `#1e1e1e`, etc.).
- **`.code-block`** (line ~1296): wrapper for code-block layout (background, padding, overflow).

Same name is used for an element selector vs a layout class, which is easy to misuse.

**Recommendation:** Rename for clarity, e.g.:
- Keep `code.code-block` for the dark-theme block.
- Rename the wrapper to something like `.code-block-wrapper` or `.dark-code-block`, and use that in HTML/CSS.  
(If you want “CSS only,” you can still rename the wrapper class in CSS and document that the HTML must use the new class.)

### 3.2 `action-box` / `action-box-header` headings
- `.action-box-header h4`: `font-size: 1.1rem; font-weight: 700`.
- `.action-box h4`: `font-size: 0.95rem; font-weight: 600; margin: 0 0 0.75rem`.

Both apply to `h4` in different contexts. Fine as-is; ensure no unintended `h4` gets the wrong combo. No change required if markup is consistent.

### 3.3 Redundant rule
- **`.action-box.highlight .action-list li`** (line ~764) sets `font-size: 0.95rem` only, and is the same as `.action-list li` (line ~754).  
**Recommendation:** Remove `.action-box.highlight .action-list li` unless you plan different sizing for highlight boxes.

---

## 4. Dead or ambiguous CSS

| Selector | Note |
|----------|------|
| **`.hero-title`** (in `@media (max-width: 768px)`) | There is no `hero-title` in the template; welcome uses `.hero-section`, `.hero-banner`, `.hero-tagline`. Either add a `.hero-title` in HTML and keep the rule, or remove the `.hero-title` block from the media query to avoid dead CSS. |

---

## 5. MCP / screenshot sizing

**.screenshot-image.mcp-size** (lines ~456–459):

```css
.screenshot-image.mcp-size {
    max-width: 100%;
    width: 100%;
}
```

This doesn’t constrain width; it only makes the image span the container. If the design calls for a max width (e.g. 560px) for MCP screenshots, use:

```css
.screenshot-image.mcp-size {
    max-width: 560px;
    width: 100%;
}
```

Adjust the value to match the intended layout; leave as-is if full width is correct.

---

## 6. Responsive breakpoints

- **900px:** Progress step labels hidden, step markers scaled.
- **768px:** Layout (padding, grid, step header, object grid, action rows).
- **640px:** MCP images stack to full width.

**Recommendation:**  
- Add a short comment at the top of the file, e.g. `/* Breakpoints: 900px progress, 768px layout, 640px MCP images */`.  
- If possible, align with SLDS/LWC breakpoints (e.g. 480/768/1024) for future theming.

---

## 7. Typography scale

Body and UI font sizes are mostly consistent:

- **0.8–0.85rem:** Small labels, table headers, code.
- **0.9–0.95rem:** Body, steps, lists, action boxes.
- **1rem:** Step descriptions, summaries, section headings.
- **1.1–1.25rem:** Config/em headers.

**Minor inconsistency:**  
- `.platform-intro p`: `0.9rem`  
- `.intro-text`: `0.95rem`  
- `.config-section p`: `0.9rem`  

Choose one “body” size (e.g. `0.95rem`) for `.platform-intro p` and `.config-section p` and use it everywhere for normal paragraphs, unless a deliberate hierarchy is wanted.

---

## 8. Spacing and layout

- **Section spacing:** Mix of `margin-bottom: 1.5rem`, `1.75rem`, `2rem`. Visually fine; if you want stricter rhythm, standardize to 2–3 values (e.g. `1rem` / `1.5rem` / `2rem`) and use them by section level.
- **`.config-section p:last-child`** (line ~585): `margin-bottom: 0.85rem` is unusually large for a “last” child. Consider `0` or a small value so the next section doesn’t feel overly separated.

---

## 9. Redundant or low-value rules

- **`.action-box.highlight .action-list li`** – Duplicate of `.action-list li` font-size; safe to remove (see 3.3).
- **`.info-box.release-status lightning-icon`** – Uses `display: none` and then `min-height`, `border-radius`, `background-color`. The icon is hidden, so the rest has no effect. Keep only `display: none` (or a single rule that hides it) and drop the decorative properties.

---

## 10. File structure and comments

- Section comments (e.g. `/* Event Monitoring Section Styles */`, `/* Summary Page Styles */`) are helpful.
- **Recommendation:** Add a short table of contents at the top, e.g.:

  ```
  /* Free Trial Guide
   * 1. Container & progress
   * 2. Welcome / hero
   * 3. Step content & instruction panel
   * 4. Config sections, lists, tables
   * 5. Action/tip boxes
   * 6. Event Monitoring
   * 7. Summary
   * 8. Navigation
   * 9. Responsive
   */
  ```

  Group related blocks under these headings so the file is easier to scan and refactor.

---

## 11. Accessibility (CSS-relevant)

- **Focus:** Buttons use `outline: none` via `.progress-step`. Ensure there is a visible focus style (e.g. `:focus-visible`) so keyboard users can see focus. If outline is removed, replace it with a clear ring or border.
- **Contrast:** Navy `#143b58` and blue `#1e5a7a` on white, and gold `#ba8b2d` on white, are generally sufficient; no change needed if you’ve already checked contrast.
- **Reduced motion:** Consider a small block for users who prefer less animation:

  ```css
  @media (prefers-reduced-motion: reduce) {
      .step-content { animation: none; }
      .progress-step:hover { transform: none; }
      .feature-card.clickable:hover { transform: none; }
      /* etc. for transform/animation */
  }
  ```

---

## 12. Summary of recommended CSS-only changes

| Priority | Change |
|----------|--------|
| High | Unify gold: use `#ba8b2d` in `.intro-section` (replace `#8B6914`). |
| High | Unify Event Monitoring headings: set `.em-section h3 { color: #143b58; }` and `.em-section .intro-text { color: #444; }`. |
| Medium | Remove redundant `.action-box.highlight .action-list li` or give it a different value. |
| Medium | Simplify `.info-box.release-status lightning-icon` to only hide the icon (e.g. `display: none`). |
| Medium | Fix or remove dead `.hero-title` in the 768px media query. |
| Low | Add `:focus-visible` (or equivalent) for `.progress-step` if outline is removed. |
| Low | Consider `@media (prefers-reduced-motion: reduce)` for animations/transforms. |
| Low | Add a minimal TOC/segment comments and, if desired, normalize paragraph font-size and last-child margin in config/summary sections. |

---

*Review applies only to `freeTrialGuide.css`. No HTML or JavaScript was modified.*
