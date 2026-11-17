"""Generate Filipino narration per block, fitted to the original English timing.
Outputs vo/bNN.mp3, plan.json (start/duration/tempo per block) and nayisa_fil.srt."""
import asyncio, json, re, sys
from pathlib import Path
import edge_tts
from mutagen.mp3 import MP3

D = Path(__file__).parent
VOICE, PITCH = "fil-PH-AngeloNeural", "-6Hz"
VIDEO_END = 377.4
segs = json.load(open(D / "transcript_en.json", encoding="utf-8"))
blocks = json.load(open(D / "blocks_fil.json", encoding="utf-8"))
(D / "vo").mkdir(exist_ok=True)

async def tts(text, rate, path):
    words = []
    com = edge_tts.Communicate(text, VOICE, rate=f"{rate:+d}%", pitch=PITCH, boundary="WordBoundary")
    with open(path, "wb") as f:
        async for c in com.stream():
            if c["type"] == "audio": f.write(c["data"])
            elif c["type"] == "WordBoundary": words.append((c["offset"] / 1e7, (c["offset"] + c["duration"]) / 1e7))
    # speech span (edge adds a little padding at both ends)
    return words[0][0], words[-1][1], MP3(path).info.length

async def main():
    plan = []
    for i, b in enumerate(blocks):
        start = segs[b["seg"][0]]["start"]
        nxt = segs[blocks[i + 1]["seg"][0]]["start"] if i + 1 < len(blocks) else VIDEO_END
        window = nxt - start - 0.2
        path = D / "vo" / f"b{i:02d}.mp3"
        rate = -4
        for _ in range(4):
            s0, s1, total = await tts(b["fil"], rate, path)
            speech = s1 - s0
            if speech <= window or rate >= 25: break
            rate = min(25, rate + int((speech / window - 1) * 100) + 3)
        tempo = max(1.0, speech / window)  # residual squeeze via ffmpeg atempo
        plan.append({"i": i, "file": f"vo/b{i:02d}.mp3", "start": round(start, 3), "trim": round(max(0, s0 - 0.05), 3),
                     "speech": round(speech, 3), "window": round(window, 3), "rate": rate, "tempo": round(tempo, 3), "text": b["fil"]})
        flag = "  <-- tempo %.2f" % tempo if tempo > 1 else ""
        print(f"b{i:02d} @{start:6.2f} speech {speech:5.2f}/{window:5.2f}s rate {rate:+d}%{flag}")
    json.dump(plan, open(D / "plan.json", "w", encoding="utf-8"), indent=1, ensure_ascii=False)
    # subtitles
    def ts(t):
        h, r = divmod(t, 3600); m, s = divmod(r, 60)
        return f"{int(h):02d}:{int(m):02d}:{int(s):02d},{int(round((s % 1) * 1000)):03d}"
    with open(D / "nayisa_fil.srt", "w", encoding="utf-8") as f:
        for p in plan:
            end = p["start"] + p["speech"] / p["tempo"] + 0.3
            f.write(f"{p['i'] + 1}\n{ts(p['start'])} --> {ts(end)}\n{p['text']}\n\n")

asyncio.run(main())
