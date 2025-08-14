@echo off
setlocal enabledelayedexpansion

rem === CONFIGURATION ===
set "SRC_DIR=D:\sticker working"
set "OUT_DIR=%SRC_DIR%\telegram_stickers"
set "EXTS=gif mp4 webm webp"

rem Create output folder if not exists
if not exist "%OUT_DIR%" mkdir "%OUT_DIR%"

cls
echo Converting files to Telegram .webm stickers...
echo.

rem === MAIN LOOP ===
for %%x in (%EXTS%) do (
    set "found=false"
    echo Searching for *%%x files...

    pushd "%SRC_DIR%"
    for %%f in (*%%x) do (
        if exist "%%f" (
            set "found=true"
            echo Converting: %%f
            call :process_file "%%~f"
        )
    )
    popd

    if "!found!"=="false" echo No *%%x files found.
    echo.
)

echo All files converted. Check the '%OUT_DIR%' folder.
pause
exit /b

:process_file
set "input=%~1"

for %%a in ("%input%") do set "filename=%%~na"
set "output=%OUT_DIR%\%filename%.webm"

rem Get file extension lowercase
for %%e in ("%input%") do set "ext=%%~xe"
set "ext=!ext:~1!"
set "ext=!ext:~0,3!"

rem --- Get duration in seconds ---
for /f "usebackq tokens=*" %%d in (`ffprobe -v error -show_entries format^=duration -of default^=nokey^=1:noprint_wrappers^=1 "%input%"`) do set "duration=%%d"

rem === SPEED-UP LOGIC ===
set "speed_filter="
for /f "tokens=1 delims=." %%A in ("!duration!") do set /a "dur_int=%%A"

if !dur_int! GTR 3 (
    rem Calculate speed factor (invariant decimal dot)
    for /f "usebackq delims=" %%s in (`powershell -NoProfile -Command "[math]::Round((%duration%/3),3).ToString([System.Globalization.CultureInfo]::InvariantCulture)"`) do set "speed_factor=%%s"

    if defined speed_factor (
        set "speed_filter=,setpts=(PTS-STARTPTS)/!speed_factor!"
        echo Clip is longer than 3s. Speeding up by factor: !speed_factor!
    ) else (
        echo ERROR: Speed factor calculation failed. Skipping speed change.
    )
) else (
    echo Clip is 3s or shorter. No speed change applied.
)

rem --- Scaling & padding to 512x512 ---
set "vf_filter=fps=15,scale='if(gt(iw,ih),512,trunc(iw*512/ih/2)*2)':'if(gt(ih,iw),512,trunc(ih*512/iw/2)*2)',pad=512:512:(ow-iw)/2:(oh-ih)/2:color=black"

rem === Conversion command (force max 2.99s) ===
if /I "!ext!"=="webp" (
    ffmpeg -y -loop 1 -i "%input%" -vf "!vf_filter!!speed_filter!" -r 15 -t 2.99 -c:v libvpx-vp9 -crf 38 -b:v 0 -an -tile-columns 0 -frame-parallel 1 -auto-alt-ref 0 "%output%"
) else (
    ffmpeg -y -i "%input%" -vf "!vf_filter!!speed_filter!" -r 15 -t 2.99 -c:v libvpx-vp9 -crf 38 -b:v 0 -an -tile-columns 0 -frame-parallel 1 -auto-alt-ref 0 "%output%"
)

rem === Size check ===
for %%s in ("%output%") do (
    if %%~zs GTR 262144 (
        echo WARNING: %%~nxs exceeds 256KB (%%~zs bytes)
    )
)

echo Done: %output%
exit /b

