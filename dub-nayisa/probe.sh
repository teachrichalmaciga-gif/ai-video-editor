set -e
V="/mnt/c/Users/teach/Downloads/From_Classroom_to_Battlefield__The_Making_of__Nay_Isa_.mp4"
D="/mnt/d/AI VIDEO EDITOR/dub-nayisa"
ffprobe -v error -show_entries format=duration,size:stream=index,codec_type,codec_name,width,height,r_frame_rate,sample_rate,channels -of compact "$V"
ffmpeg -hide_banner -loglevel error -y -i "$V" -vn -ac 1 -ar 16000 "$D/audio16k.wav"
ffmpeg -hide_banner -loglevel error -y -i "$V" -vn -c:a copy "$D/original_audio.m4a" || true
# scene-change frames for visual analysis
ffmpeg -hide_banner -loglevel error -y -i "$V" -vf "select='gt(scene,0.3)',scale=480:-1,showinfo" -vsync vfr "$D/frames/s_%03d.jpg" 2>&1 | grep -o "pts_time:[0-9.]*" > "$D/frames/times.txt" || true
ls "$D/frames" | wc -l
python3 -m pip --version 2>&1; python3 --version
python3 -c "import faster_whisper" 2>&1 | tail -1
