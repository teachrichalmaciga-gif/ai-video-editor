set -e
D="/mnt/d/AI VIDEO EDITOR/dub-nayisa"
python3 -m pip install --user -q faster-whisper 2>&1 | tail -2
cat > /tmp/tr.py <<'PY'
import json, sys
from faster_whisper import WhisperModel
m = WhisperModel("small.en", device="cpu", compute_type="int8", cpu_threads=10)
segs, info = m.transcribe(sys.argv[1], language="en", vad_filter=True, word_timestamps=True, beam_size=5)
out = []
for s in segs:
    out.append({"start": round(s.start,2), "end": round(s.end,2), "text": s.text.strip(),
                "words": [{"w": w.word, "s": round(w.start,2), "e": round(w.end,2)} for w in s.words]})
json.dump(out, open(sys.argv[2], "w"), indent=1, ensure_ascii=False)
print(len(out), "segments")
PY
python3 /tmp/tr.py "$D/audio16k.wav" "$D/transcript_en.json"
