# Magic — Artist Deck

An interactive, web-based presentation deck for Magic's artist partnerships. Built as a single-page HTML application with animations, a revenue simulator, and bilingual (EN/FR) support.

## Features

- **14 slides** covering Magic's value proposition for artists
- **EN / FR language toggle** with full translations
- **Fullscreen presentation mode** with keyboard navigation (arrow keys)
- **Interactive revenue simulator** (slide 11) — input your artist reach and see projected earnings
- **Animated transitions** including a Fanverse solar system, engagement charts, and scroll-triggered reveals
- **Clickable slide dots** and editable slide counter for quick navigation

## Structure

```
index.html                  # The full deck (single-file HTML/CSS/JS)
brand elements/fonts/       # Gilroy font files (.woff)
artifacts/                  # Supporting assets
preview-server.js           # Local preview server (Node.js)
```

## Usage

Open `index.html` in a browser, or run locally:

```bash
node preview-server.js
```

### Keyboard shortcuts

| Key | Action |
|-----|--------|
| `→` / `↓` | Next slide |
| `←` / `↑` | Previous slide |
| `ESC` | Exit fullscreen |

### URL parameters

- `?lang=fr` — open the deck in French

## Customisation

- **Swap panel images on slide 6:** look for elements with IDs `s5-img-fanverse`, `s5-img-gamification`, `s5-img-fanchat`, `s5-img-sales`
- **Update CTA link:** search for the Calendly URL on the final slide
- **Add new slides:** follow the existing `<section class="slide" id="sN">` pattern and update the `totalSlides` variable
