# AI VIDEO EDITOR

Video work in several separate parts. Pick skills by the part you are working in. Each part's own
rules come first; the general design and React skills below only add to them and never override them.

| Folder | What it is |
|---|---|
| `hyperframes-project/` | HyperFrames video: HTML, CSS and GSAP, rendered to MP4. Has its own `CLAUDE.md`; read it first. |
| `remotion-project/` | Remotion video in React and TypeScript (`src/TeresaMagbanua.tsx`, `scenes.tsx`, `timeline.ts`). Its own Git repo, ignored by this one. |
| `dub-nayisa/` | Python dubbing pipeline: English transcript → Filipino narration with edge-tts (`dub_voice.py`), then ffmpeg mixing (`mix.sh`). |
| `opencv-node/` | OpenCV for Node.js, built inside WSL. |
| `Raw Footage/`, `References/`, `Exports/` | Source media, reference material and rendered videos. Large files are ignored by Git. |

## Which skill for what

### HyperFrames (`hyperframes-project/`)

1. Follow `hyperframes-project/CLAUDE.md` and its `/hyperframes` skills first. Its rules win over every
   skill below: deterministic code only (no `Date.now()`, `Math.random()` or network fetches), one
   paused root timeline on `window.__timelines`, and `npm run check` plus a snapshot after every change.
2. The `/hyperframes` skills are not installed on this computer yet. Installing them is the user's step:
   tell the user to run `npx hyperframes skills update` inside `hyperframes-project/`. Do not install them yourself.
3. For the look of a scene (layout, type, colour, motion feel): use `impeccable`. To match a known brand,
   copy its `DESIGN.md` from `D:\CRAFT ANYTHING\awesome-design-md\design-md\<brand>\` into the project first.
4. `design-taste-frontend` (Taste Skill) builds websites. Use only its art-direction and typography
   judgement for scenes; skip its website rules (one section per screen, browser finish gate, page effects).
5. The Impeccable hook scans every HTML file Claude edits. Its findings are advice for video frames,
   not blockers; `npm run check` is the real gate.

### Remotion (`remotion-project/`)

- Remotion rules win: animate from `useCurrentFrame()` and `interpolate`/`spring`, never CSS
  transitions or timers; keep rendering deterministic.
- `vercel-composition-patterns` for structuring scenes and reusable components.
- `vercel-react-best-practices` for re-render and bundle advice. Ignore its server, data-fetching and
  Next.js rules; they don't apply to a video.
- Run `npm run lint` after changes. Rendering writes to `../Exports/`.

### Dubbing (`dub-nayisa/`)

- Plain Python and ffmpeg; no design skills apply. Use the `.venv` at the repo root.
- Narration is Filipino (`fil-PH-AngeloNeural`); keep subtitle files in sync with `plan.json` timing.

### Across the project

| Task | Use |
|---|---|
| Mock up a look or storyboard frame before building it | `superdesign` (some steps spend Superdesign credits; get the user's OK on the quoted price first) |
| Review finished HTML or UI for accessibility and polish | `web-design-guidelines` |
| Look at a preview in a real browser, click through it, take screenshots | Playwright MCP tools |
| Find out how another video tool, app or website works | `craft-anything` |
| Review written docs and READMEs | `writing-guidelines` (English only) |

Not relevant here unless the project changes: `vercel-react-native-skills`, `vercel-react-view-transitions`,
`vercel-optimize`, `deploy-to-vercel`.

## Language

The user writes in English, Filipino and Taglish. On-screen text and narration for videos are often in
Filipino: keep the user's wording and don't translate it unless asked.
