set -e
D="/mnt/d/AI VIDEO EDITOR/dub-nayisa"
V="/mnt/c/Users/teach/Downloads/From_Classroom_to_Battlefield__The_Making_of__Nay_Isa_.mp4"
O="/mnt/d/AI VIDEO EDITOR/Exports/Nay_Isa_Tagalog.mp4"
cd "$D"
python3 - <<'PY'
import json
plan = json.load(open("plan.json", encoding="utf-8"))
args, chains, labels = [], [], []
for k, p in enumerate(plan):
    args += ["-i", p["file"]]
    ms = int(p["start"] * 1000)
    tempo = f",atempo={p['tempo']}" if p["tempo"] > 1 else ""
    chains.append(f"[{k+1}:a]aresample=48000,aformat=channel_layouts=stereo,atrim=start={p['trim']},asetpts=PTS-STARTPTS{tempo},adelay={ms}|{ms}[a{k}]")
    labels.append(f"[a{k}]")
fc = ";".join(chains) + ";" + "".join(labels) + f"amix=inputs={len(plan)}:normalize=0,apad,loudnorm=I=-14:TP=-1:LRA=11[out]"
open("filter.txt", "w").write(fc)
open("inputs.txt", "w").write("\n".join(args))
PY
mapfile -t IN < inputs.txt
ffmpeg -hide_banner -loglevel error -y -i "$V" "${IN[@]}" -filter_complex_script filter.txt \
  -map 0:v -map "[out]" -c:v copy -c:a aac -b:a 192k -ar 48000 -shortest -movflags +faststart "$O"
ffprobe -v error -show_entries format=duration,size:stream=codec_type,codec_name,channels -of compact "$O"
ffmpeg -hide_banner -i "$O" -af ebur128 -f null - 2>&1 | grep -E "^\s+I:" | tail -1
# also an English-free check: extract 3 short clips' loudness windows
ffmpeg -hide_banner -loglevel error -y -ss 160 -t 15 -i "$O" -vn -ac 1 -ar 16000 "$D/check_clip.wav"
