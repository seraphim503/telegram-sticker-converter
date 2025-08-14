# Telegram Sticker Converter (Windows)

### Convert GIF, MP4, WEBM, and WEBP files into Telegram-compatible WEBM stickers with a single click using FFmpeg.

## 📌 Features

-  Automatically converts multiple files at once.

- Speeds up clips longer than 3 seconds to meet Telegram’s limit.

- Resizes & pads to 512×512 pixels.

- Warns if output exceeds 256 KB.

- Supports: gif, mp4, webm, webp.

## 📦 Requirements

- Windows (tested on Windows 10/11).

- FFmpeg installed and added to your PATH.

- Basic knowledge of editing the .bat file to set your folder paths.

## 🚀 Setup & Usage

1. Download or clone this repository:

  ```bash
 git clone https://github.com/seraphim503/telegram-sticker-converter/
  ```
Or click Code → Download ZIP.

2. Place your source files (GIF, MP4, etc.) in the same folder as the bat file.

3. Open sticker_converter.bat in a text editor and change:
```bash
set "SRC_DIR=D:\sticker working"
```
to the folder where your files are.

4. Run sticker_converter.bat by double-clicking it.

5. Converted .webm stickers will appear in (by default in the same directory on a new folder named telegram_stickers):
```bash
[SRC_DIR]\telegram_stickers
```


# 📌 Notes

Maximum Telegram sticker length is 3 seconds — the script will speed up longer clips.

Output format is VP9 .webm, ready for upload to Telegram.

File size over 256 KB will still work in Telegram, but may fail for animated sticker packs.

# 🛠 Troubleshooting

"ffmpeg is not recognized" → Install FFmpeg and add it to your system’s PATH.

Wrong folder paths → Make sure SRC_DIR points to your working directory.

# 📄 License

please link me if you use or modify and reupload or just re upload this somewhere. open an issue if u face problems.
