# 🦆 Duck Pod
**Automated Podcast Audio Post-Production & Ambient Ducking Tool**

Duck Pod is a high-performance batch script designed to turn raw voice recordings into polished, "radio-ready" podcast segments. It automates noise reduction, voice leveling, and dynamic music/ambience ducking in a single workflow.

## ✨ Key Features
* **Dynamic Sidechain Compression:** Automatically ducks background music and ambience whenever the speaker is talking.
* **Layered Backgrounds:** Supports a secondary looping "Ambience" track (e.g., rain, cafe noise) that ducks in sync with the music.
* **Pro Voice Chain:** Built-in FFT noise reduction (`afftdn`), high-pass filtering (80Hz), and EBU R128 loudness normalization (`loudnorm`).
* **Infinite Looping:** Background tracks automatically loop to match the length of your voice recording.
* **The "Reverse-Fade" Trick:** Uses a multi-pass reversal technique to ensure perfectly smooth 5-second fades at the start and the absolute end of the file, regardless of duration.
* **Automatic Versioning:** Every export is timestamped (`YYYYMMDD_HHMMSS`) to prevent overwriting previous takes.

## 🚀 How to Use
1.  **Setup:** Place your background music in a folder named `/music` and your ambient textures in a folder named `/ambience` (located in the same directory as the script).
2.  **Input:** Drag and drop your raw voice recording (`.wav`, `.mp3`, or `.m4a`) directly onto `DuckPod.bat`.
3.  **Output:** Your finished, mastered file will appear in the same directory as your source file with a unique timestamp.

## 🛠 Requirements
* **FFmpeg:** This script requires FFmpeg to run. You can either:
    * Add `ffmpeg.exe` to your system's **PATH**.
    * **OR** simply place `ffmpeg.exe` and `ffprobe.exe` in the **same folder** as the `DuckPod.bat` script.

## 📁 Folder Structure
```text
/YourProject/
├── DuckPod.bat
├── ffmpeg.exe (optional if not in PATH)
├── music/
│   └── (your background mp3s)
└── ambience/
    └── (your looping ambient mp3s)
