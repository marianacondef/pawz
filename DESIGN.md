# Design System Strategy: The Botanical Sanctuary

## 1. Overview & Creative North Star
This design system is built upon the North Star of **"The Digital Sanctuary."** In the context of pet health, we must move away from the sterile, clinical aesthetic of traditional veterinary software and toward an organic, high-end editorial experience. 

The system rejects the "boxed-in" nature of standard apps. Instead of rigid containers, we use **intentional asymmetry** and **tonal layering** to create a sense of calm and breathing room. By utilizing a "Soft Minimalism" approach, we ensure that the interface feels like a premium lifestyle magazine—one that is both authoritative and deeply nurturing.

## 2. Color & Atmospheric Tones
We use a palette rooted in nature to evoke growth, health, and tranquility. 

### The "No-Line" Rule
To achieve a premium editorial feel, **1px solid borders are strictly prohibited for sectioning.** We define boundaries through background color shifts. For example, a `surface-container-low` section sits directly on a `surface` background. The eye should perceive depth through color transitions, not architectural lines.

### Surface Hierarchy & Nesting
Treat the UI as a series of stacked, organic layers—like fine paper on a stone desk.
- **Base:** `surface` (#F5FAF7)
- **Primary Containers:** `surface-container-lowest` (#FFFFFF) for high-priority cards.
- **Secondary Grouping:** `surface-container` (#EAEFEC) for recessed background areas.
- **Tertiary Elements:** `surface-variant` (#DEE4E1) for subtle utility sections.

### The "Glass & Gradient" Rule
Standard flat colors feel static. To provide "soul," use a subtle linear gradient on main CTAs—transitioning from `primary` (#316342) to `primary-container` (#4A7C59) at a 135° angle. For floating overlays, use **Glassmorphism**: a semi-transparent `surface` color with a 20px backdrop-blur to allow the botanical background tones to bleed through softly.

## 3. Typography: Editorial Authority
We utilize **Inter** not as a system font, but as a brand voice. The hierarchy is designed to guide the eye through content with a clear, intentional pace.

*   **Display (Editorial Hero):** `display-md` (2.75rem / 44px). Use this for "Pet Milestones" or "Wellness Scores." Bold and unapologetic.
*   **Headline (The Narrative):** `headline-sm` (1.5rem / 24px). Used for page titles. Bold weight.
*   **Title (The Organizer):** `title-sm` (1rem / 16px). Used for card headings. SemiBold weight.
*   **Body (The Information):** `body-md` (0.875rem / 14px). Regular weight. This is the workhorse for pet health records.
*   **Label (The Detail):** `label-md` (0.75rem / 12px). Medium weight. Used for metadata and button text.

The interplay between `headline-sm` and `body-md` is the core of our identity: high-contrast scale that feels curated, not just "scaled."

## 4. Elevation & Depth
In this system, depth is a feeling, not a shadow.

*   **The Layering Principle:** Place a `surface-container-lowest` card on top of a `surface-container-low` background. This "white-on-off-white" effect creates a natural lift that is far more sophisticated than a heavy drop shadow.
*   **Ambient Shadows:** If a floating element (like a FAB) is required, use an extra-diffused shadow: `rgba(28, 43, 32, 0.06)` with a 12px blur and 4px Y-offset. The shadow is tinted with our `on-surface` color to ensure it looks like a natural shadow cast in a garden, not a grey smudge.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility (e.g., in a high-density table), use `outline-variant` at **15% opacity**. Never use a 100% opaque border.

## 5. Component Logic

### Buttons: The Tactile Interaction
*   **Primary:** Solid `primary` gradient with 12px radius. Height is a fixed 48px to ensure a substantial, premium touch target.
*   **Secondary:** `surface-container-lowest` background with a `primary` text color. No border.
*   **Tertiary:** No background. `primary` text with an 8px padding-x for a "ghost" interaction style.

### Input Fields: The Minimalist Signature
Following our editorial direction, inputs use a **Bottom Border Only** style using the `primary-fixed-dim` token. Upon focus, the border transitions to `primary` (2px thickness), and the label floats with a slight scale-down animation.

### Cards & Lists: The Open Layout
*   **Cards:** 14px radius (`xl` on our scale). Avoid dividers.
*   **Lists:** Separate items using **16px vertical whitespace** rather than lines. To group items, use a `surface-container-low` background block behind the entire list to create a unified "island."
*   **Pet Profile Chips:** Use `secondary-container` (#B9EFC7) backgrounds with `on-secondary-container` (#3E6E4F) text. These should feel like soft pebbles—fully rounded (999px).

### Custom "Health Metrics" Component
A bespoke component for this system is the **Progress Halo**. Instead of a linear bar, use a circular stroke with a variable width (6px) using a gradient from `accent` to `primary`. It feels more organic and less like a "loading" bar.

## 6. Do’s and Don’ts

### Do
*   **Do** use asymmetrical padding (e.g., 24px top, 16px sides) to create an editorial layout.
*   **Do** use "Text Secondary" (`#6B8F71`) for captions to reduce visual noise.
*   **Do** allow for ample whitespace (8px grid base, but 24px-32px between major sections).

### Don’t
*   **Don't** use 1px solid dividers to separate content; use background tone shifts.
*   **Don't** use pure black for text. Always use `on-surface` (#171D1B).
*   **Don't** use sharp 0px corners. This system is botanical and soft; everything should have at least a 4px (`sm`) radius.
*   **Don't** use "Alert Red" for everything. Use `warning` (#E6A817) for non-critical health reminders to keep the user calm. Only use `danger` for immediate medical emergencies.