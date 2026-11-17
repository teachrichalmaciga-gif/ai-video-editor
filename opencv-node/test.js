// Quick check that @u4/opencv4nodejs loads and can read project media.
// Run inside WSL:  cd "/mnt/d/AI VIDEO EDITOR/opencv-node" && npm test
const path = require("path");
const cv = require("@u4/opencv4nodejs");

const root = path.resolve(__dirname, "..");
console.log("OpenCV", cv.version ? `${cv.version.major}.${cv.version.minor}.${cv.version.revision}` : "(loaded)");

const img = cv.imread(path.join(root, "dub-nayisa/frames/s_001.jpg"));
console.log("image:", img.rows, "x", img.cols, "channels:", img.channels);

const cap = new cv.VideoCapture(path.join(root, "Exports/Teresa_Magbanua_Teaser.mp4"));
console.log("video fps:", cap.get(cv.CAP_PROP_FPS), "| frames:", cap.get(cv.CAP_PROP_FRAME_COUNT));
const frame = cap.read();
console.log("first frame:", frame.empty ? "EMPTY" : `${frame.cols}x${frame.rows}`);
cap.release();
