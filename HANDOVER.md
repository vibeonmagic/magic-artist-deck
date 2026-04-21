# Magic Artist Deck — Handover

_Last updated: 2026-04-20. Written by Claude Code for the next session._

## Quick start

You're in `/Users/laura/AI Projects/Magic Slides/magic-artist-deck-main-2`.

- **Start preview:** `node preview-server.js` → http://localhost:4173/magic_artist_deck_v3.html
- **Public GitHub Pages (main branch):**
  - Generic: https://lolacolafola.github.io/magic-artist-deck/
  - Celine Dion: https://lolacolafola.github.io/magic-artist-deck/celine-dion/
- **Three modes per URL** (same HTML, different params):
  - no param → presentation mode (keyboard nav, for Laura presenting)
  - `?lang=en` → EN scroll client mode (PDF-like, phone-readable)
  - `?lang=fr` → FR scroll client mode

## Repo structure

```
magic-artist-deck-main-2/
├── index.html                    ← generic WIP, served by GH Pages at /
├── magic_artist_deck_v3.html     ← same content, kept for history
├── celine-dion/
│   ├── index.html                ← frozen Celine version
│   └── Assets/Deck Edits/        ← Celine-specific phone screen swaps
├── brand elements/
│   ├── Fonts/                    ← CAPITAL F, fonts live here (case matters, see below)
│   └── Magic brand images copy/  ← all deck images + welcome-crowd.mp4
└── lolacolafola_A_crowd_of_people_..._8fd6a484.mp4  ← original source for the welcome video
```

## Per-customer convention

When Laura asks to ship a deck for a new artist (e.g. Bad Bunny):

1. Copy current root `index.html` → `<artist-slug>/index.html`
2. Adjust asset paths: any `src="brand elements/..."` → `src="../brand elements/..."` (they now reference from a subfolder).
3. Customise per the artist's Figma (usually phone-screen swaps in `<artist-slug>/Assets/Deck Edits/`).
4. Commit + merge to `main` (what Pages serves). Optionally tag the commit `<artist-slug>` for local recovery.

## Current state (as of 2026-04-20)

Branch: `artist-deck-restructure`. `main` is up-to-date with the latest merged work. Tag `celine-dion` points at current main HEAD.

## Work done today

### Welcome slide (s1)
- Video swapped to new MJ crowd-with-phones clip (`brand elements/Magic brand images copy/welcome-crowd.mp4`)
- Video trimmed (`-ss 4` cut first 4s of original), then slowed 2× with `minterpolate` for smooth slow-mo, then cropped top 62% via `crop=iw:ih*0.62:0:0` to remove the "two-headed person" artifact
- CSS: `object-fit:cover; object-position:center 25%`, no transform hacks
- Left mask fade lives on the parent `#s1-hero-media` (container-anchored, not on video) — this survived a translateX experiment
- Purple-blue overlay: `<div ... mix-blend-mode:color; background:rgba(95,80,255,0.22)>` — its own mask-image was **removed** (caused render issue in scroll-mode's composited context; parent's mask clips it anyway)

### Magic AI slide (s-ai) — reframed from artist-automation → fan-facing companion
- Hero: **"A companion in every fan's pocket"** (FR: "Un compagnon dans la poche de chaque fan")
- 4 cards:
  1. **Saves their faves** / Garde leurs favoris — heart-bookmark icon (cyan)
  2. **Knows you inside out** / Tout sur vous, à portée de main — chat bubble via `<use href="#ss-i-chat"/>` (purple)
  3. **Plays with them** / Joue avec eux — gamepad SVG (cyan, moved from old card 2)
  4. **Never miss a beat** / Aux premières loges — bell icon (blue)
- No em-dashes (Laura's feedback: avoid them everywhere)

### Recap slide (s13)
- Point 2: "first-time ticket buyer" → "first-time listener" (festival residue removed); FR synced to EN
- Point 3: restored original artist "Your revenue, growing" copy + extended with festival-inspired partner angle:
  > "from every fan who joins your Fanverse, and the label, brand and tour deals your data unlocks"

### Other slides
- Experiences + Magic AI: all em-dashes removed (6 total across EN+FR)
- Revenue slide body copy: max-width 720px → 1100px (two lines instead of three)
- Fanverse sun text: "THE ARTIST" / "L'ARTISTE" → "ARTIST" / "ARTISTE" (fits inside 90px sun without crowding)
- Stream Connect (Celine) card: softer blur, purple tint tuned

## Gotchas — DO NOT FORGET

### Case sensitivity trap (burned us once)
macOS is case-insensitive; GitHub Pages (Linux) is case-sensitive. Before any push that touches asset references, verify every path matches git's tracked case:

```bash
grep -oE "brand elements/[^\"')]*" magic_artist_deck_v3.html | sort -u | while read f; do
  git ls-files --error-unmatch "$f" >/dev/null 2>&1 && echo "OK $f" || echo "MISS $f"
done
```

Any `MISS` is either a case mismatch or a never-committed file — fix before pushing.

### Celine subfolder asset paths
Any new asset referenced from `celine-dion/index.html` needs `../brand elements/...` (one level up) or `Assets/Deck Edits/...` (colocated). Local `brand elements/...` without the `../` will 404 from the subfolder.

### Scroll/client mode quirks
- `?lang=en` / `?lang=fr` triggers `body.scroll-mode.client-mode` + stacks slides vertically.
- In scroll-mode, `.si` gets a JS `transform:scale()` + `will-change:transform` + `backface-visibility:hidden` → creates a compositing context. Elements inside that use `mix-blend-mode:color` combined with their own `mask-image` have rendered unreliably. If adding new blended overlays, skip the child-level mask and let the parent's mask clip.

## Open / likely-next items

### Celine deck — next session (2026-04-21)
- **Slide 7 (s5, "Always on")**: reframe from *"Keep them coming back between concerts"* to a **"Keep rewarding them"** framing. The current heading is engagement-oriented; Laura wants it closer to reward/recognition of loyalty.
- **Slide 6 (s7, momentum graph "Make every moment bigger")** — **keep the graph, reload it with fan-count meaning.** Rework plan:
  - Change Y axis from abstract "engagement" to **fans reached** (1M → 9M markers)
  - Magic curve sits flat at 9M across the whole arc
  - Traditional curve hugs venue capacity — near-zero most of the time, spiking to 480K only during the 16 concert nights, falling back after
  - The *gap* between the two curves = the **8.5M extra fans Magic brings into every peak** — that's the visual story
  - New heading: *"Room for 9 million at every peak"* / *"De la place pour 9 millions à chaque sommet"*
  - New body: *"At every moment of the tour, the venue has a capacity — 480,000. Magic doesn't. Every peak, every milestone, every announcement reaches all 9 million fans."*
  - Peak labels (Eiffel teaser, Lottery, Opening night, Final encore, Monthly drops) stay as-is but now carry implicit 9M scale
  - Tag change: "The Paris 2026 arc" → "Capacity" / "Capacité" (or similar)
- **Alternative still on the table:** move the Fanverse solar system to the momentum slot with the "480K seats / Fanverse for 9M" framing and drop to 9 slides. Decide tomorrow whether this or the momentum-reframe is stronger (or do both — solar system at original position with capacity framing, *plus* the reframed momentum graph).
- **"Your" vs "Céline" audit**: the deck still uses second-person "your fans / your return to Paris" in many places. Since this is pitched to Céline's manager (not to Céline directly), Laura wants a later pass to shift to third-person ("Céline's fans", "her return to Paris") where it reads better.
- Slide 5 (s-experiences) phase-card copy is currently ~25-30 words per card and shows all 4 at once — Laura approved this density. Further tuning TBD.

### Older items (still open)
- If a new artist request comes in: follow the per-customer convention above. Example tag name: `bad-bunny`.
- The original MJ source video for the current welcome still lives at the repo root (~5.5MB, untracked). Laura may want to delete or `.gitignore` it eventually.
- Phone mockup PNG in `celine-dion/Assets/Deck Edits/` has "Celine Dion" (no accent) baked into the Fanverse image. Needs a new Figma export to fix the accent.

## Key commands we used a lot

```bash
# Trim / slow / crop welcome video
/opt/homebrew/bin/ffmpeg -y -ss 4 -i "lolacolafola_..._2.mp4" \
  -filter:v "setpts=2*PTS,minterpolate=fps=24:mi_mode=mci:mc_mode=aobmc:me_mode=bidir:vsbmc=1,crop=iw:ih*0.62:0:0" \
  -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -movflags +faststart -an \
  "brand elements/Magic brand images copy/welcome-crowd.mp4"

# Standard push flow
git add <specific files>
git commit -m "..."
git push origin artist-deck-restructure
git checkout main
git merge artist-deck-restructure --no-ff -m "Merge: ..."
git push origin main
git tag -f celine-dion              # only if Celine content updated
git push -f origin celine-dion
git checkout artist-deck-restructure
```

## Contact

Laura — the founder building this. See user memory at `~/.claude/projects/-Users-laura-AI-Projects-Website/memory/user_laura.md`. Stakeholder Aurelien has a strong POV on Magic AI framing (fan-companion, not artist-automation).
