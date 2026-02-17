@echo off
setlocal enabledelayedexpansion

:: ==== CHECK FFMPEG ====
where ffmpeg >nul 2>&1 || (echo FFmpeg not found in PATH. & pause & exit /b)

:: ==== INPUT FILE ====
set "input=%~1"
if "%input%"=="" (echo Drag and drop an audio file onto this script. & pause & exit /b)

set "name=%~n1"
set "dir=%~dp1"

:: ==== VERSIONING (YYYYMMDD_HHMMSS) ====
set "datestr=%date:~10,4%%date:~4,2%%date:~7,2%"
set "timestr=%time:~0,2%%time:~3,2%%time:~6,2%"
set "timestr=%timestr: =0%"
set "VERSION=_!datestr!_!timestr!"

:: ==== DIRECTORIES ====
set "MUSICDIR=%~dp0music"
set "AMBDIR=%~dp0ambience"

:: ==== RANDOM MUSIC SELECTION ====
set /a count=0
for %%F in ("%MUSICDIR%\*.mp3") do (set /a count+=1)
if %count%==0 (echo No Music found! & pause & exit /b)
set /a randIndex=(%RANDOM% %% %count%) + 1
set /a i=0
for %%F in ("%MUSICDIR%\*.mp3") do (set /a i+=1 & if !i!==%randIndex% set "MUSICPICK=%%F")

:: ==== RANDOM AMBIENCE SELECTION ====
set /a acount=0
for %%F in ("%AMBDIR%\*.mp3") do (set /a acount+=1)
if %acount%==0 (echo No Ambience found! & pause & exit /b)
set /a arand=(%RANDOM% %% %acount%) + 1
set /a j=0
for %%F in ("%AMBDIR%\*.mp3") do (set /a j+=1 & if !j!==%arand% set "AMBPICK=%%F")

set "tmp_ducked=%dir%tmp_ducked.wav"
set "tmp_rev=%dir%tmp_rev.wav"
set "final=%dir%%name%%VERSION%_final.mp3"

echo Processing Mix...
ffmpeg -y -i "%input%" -stream_loop -1 -i "%MUSICPICK%" -stream_loop -1 -i "%AMBPICK%" -filter_complex "[0:a]afftdn=nr=6:nf=-25,highpass=80,loudnorm=I=-16:TP=-1.5:LRA=11,apad=pad_dur=5[speech];[1:a]volume=0.4[mus];[2:a]volume=0.15[amb];[mus][amb]amix=inputs=2:duration=first[bg];[bg][speech]sidechaincompress=threshold=0.02:ratio=20:attack=20:release=2000[ducked];[speech][ducked]amix=inputs=2:duration=first,afade=t=in:st=0:d=5[out]" -map "[out]" "%tmp_ducked%"

echo Applying Reverse Fade-Out...
ffmpeg -y -i "%tmp_ducked%" -af "areverse,afade=t=in:st=0:d=5,areverse" -c:a libmp3lame -b:a 160k -ar 44100 "%final%"

:: ==== CLEANUP ====
del "%tmp_ducked%"

echo.
echo DONE!
echo Final output: %final%
pause
