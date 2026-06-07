@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
title Initial D Arcade Stage 8 Infinity - BGM AutoMod

set "SCRIPT_DIR=%~dp0"
set "TMP_DIR=%SCRIPT_DIR%tmp"
set "XACT_PROJECT_DIR=%TMP_DIR%\xact-project"
set "TOOLS_XACT_PROJECT_DIR=%SCRIPT_DIR%tools\xact-project"
set "XACT_WIN_DIR=%XACT_PROJECT_DIR%\Win\"
cd /d "%SCRIPT_DIR%"

set "CONFIG_FILE=%SCRIPT_DIR%initial_d_arcade_stage_8_infinity_bgm_automod.txt"
set "EXPECTED_D8_FILES=11302"
set "UNXWB=%SCRIPT_DIR%tools\unxwb\unxwb.exe"
set "FFMPEG=%SCRIPT_DIR%tools\ffmpeg\ffmpeg.exe"
set "XACT_EXE=%SCRIPT_DIR%tools\xact\Xact3.exe"
set "XACT_BASE=%SCRIPT_DIR%tmp\xact-project\idas8i-base.xap"
set "TOOLS_XACT_BASE=%TOOLS_XACT_PROJECT_DIR%\idas8i-base.xap"
set "TOOLS_XACT_WORK=%TOOLS_XACT_PROJECT_DIR%\idas8i.xap"
set "XACT_WORK=%XACT_PROJECT_DIR%\idas8i.xap"
set "ADPCM_DIR=%SCRIPT_DIR%tmp\wav-adpcm"
set "PCM_DIR=%SCRIPT_DIR%tmp\wav-pcm"
set "NEW_WAV_DIR=%SCRIPT_DIR%tmp\new-wav"
set "NEW_MUSICS_DIR=%SCRIPT_DIR%new-musics"
set "NEW_MUSICS_PREVIEWS_DIR=%SCRIPT_DIR%new-musics-previews"
set "NEW_PREV_DIR=%SCRIPT_DIR%tmp\new-wav-prev"
set "MOD_OUTPUT_DIR=%SCRIPT_DIR%mod-output"
set "TITLE_LOADER_DIR=%SCRIPT_DIR%tools\d8-song-title-loader"
set "TITLE_LOADER_SONGS=%SCRIPT_DIR%tools\d8-song-title-loader\songs.ini"
set "TITLE_LOADER_DLL=%SCRIPT_DIR%tools\d8-song-title-loader\winmm.dll"

cls
echo ============================================================
echo 🚗 Initial D Arcade Stage 8 Infinity BGM AutoMod 🎵
echo ============================================================
echo.

set "LAST_GAME_FOLDER="
if exist "%CONFIG_FILE%" set /p LAST_GAME_FOLDER=<"%CONFIG_FILE%"

if defined LAST_GAME_FOLDER goto ASK_USE_SAVED
goto ASK_GAME_FOLDER

:ASK_USE_SAVED
echo 📁 Saved game folder found:
echo(!LAST_GAME_FOLDER!
echo.
set "USE_SAVED="
set /p USE_SAVED=Use this folder? [Yn]: 
if "!USE_SAVED!"=="" set "USE_SAVED=y"
if /i "!USE_SAVED!"=="y" set "GAME_FOLDER=!LAST_GAME_FOLDER!" & goto VALIDATE_GAME_FOLDER
if /i "!USE_SAVED!"=="yes" set "GAME_FOLDER=!LAST_GAME_FOLDER!" & goto VALIDATE_GAME_FOLDER
goto ASK_GAME_FOLDER

:ASK_GAME_FOLDER
echo 📁 Select your Initial D Arcade Stage 8 Infinity game folder.
set "GAME_FOLDER="
set /p GAME_FOLDER=Game folder: 

:VALIDATE_GAME_FOLDER
if not exist "!GAME_FOLDER!\data\SOUND\IniD8.xsb" goto BAD_GAME_FOLDER_XSB
if not exist "!GAME_FOLDER!\data\SOUND\IniD8.xwb" goto BAD_GAME_FOLDER_XWB
goto SAVE_GAME_FOLDER

:BAD_GAME_FOLDER_XSB
echo.
echo ❌ Invalid game folder.
echo Could not find:
echo(!GAME_FOLDER!\data\SOUND\IniD8.xsb
echo.
goto ASK_GAME_FOLDER

:BAD_GAME_FOLDER_XWB
echo.
echo ❌ Invalid game folder.
echo Could not find:
echo(!GAME_FOLDER!\data\SOUND\IniD8.xwb
echo.
goto ASK_GAME_FOLDER

:SAVE_GAME_FOLDER
>"%CONFIG_FILE%" echo(!GAME_FOLDER!
echo.
echo ✅ Game folder saved.
echo.

call :ENSURE_DIR "backup"
call :ENSURE_DIR "backup\data"
call :ENSURE_DIR "backup\data\SOUND"
call :ENSURE_DIR "tmp"
call :ENSURE_DIR "tmp\wav-adpcm"
call :ENSURE_DIR "tmp\wav-pcm"
call :ENSURE_DIR "new-musics"
call :ENSURE_DIR "new-musics-previews"
call :ENSURE_DIR "tmp\new-wav"
call :ENSURE_DIR "tmp\new-wav-prev"
call :ENSURE_DIR "%XACT_PROJECT_DIR%"
call :ENSURE_DIR "mod-output"
call :ENSURE_DIR "mod-output\data"
call :ENSURE_DIR "mod-output\data\SOUND"
call :ENSURE_DIR "%XACT_PROJECT_DIR%"
call :ENSURE_DIR "%XACT_WIN_DIR%"

if not exist "!UNXWB!" goto MISSING_UNXWB
if not exist "!FFMPEG!" goto MISSING_FFMPEG

goto BACKUP_STEP

:MISSING_UNXWB
echo ❌ Missing tool:
echo(!UNXWB!
pause
exit /b 1

:MISSING_FFMPEG
echo ❌ Missing tool:
echo(!FFMPEG!
pause
exit /b 1

:BACKUP_STEP
set "BACKUP_OK=1"
if not exist "backup\data\SOUND\IniD8.xsb" set "BACKUP_OK=0"
if not exist "backup\data\SOUND\IniD8.xwb" set "BACKUP_OK=0"

if "!BACKUP_OK!"=="1" goto BACKUP_EXISTS

echo 💾 Creating backup...
copy /y "!GAME_FOLDER!\data\SOUND\IniD8.xsb" "backup\data\SOUND\IniD8.xsb" >nul
if errorlevel 1 goto BACKUP_FAILED
copy /y "!GAME_FOLDER!\data\SOUND\IniD8.xwb" "backup\data\SOUND\IniD8.xwb" >nul
if errorlevel 1 goto BACKUP_FAILED
echo ✅ Backup created.
goto EXTRACT_STEP

:BACKUP_EXISTS
echo 💾 Backup already exists.
set "DO_BACKUP="
set /p DO_BACKUP=Overwrite backup? [yN]: 
if /i "!DO_BACKUP!"=="y" goto DO_BACKUP_OVERWRITE
if /i "!DO_BACKUP!"=="yes" goto DO_BACKUP_OVERWRITE
goto EXTRACT_STEP

:DO_BACKUP_OVERWRITE
echo 💾 Overwriting backup...
copy /y "!GAME_FOLDER!\data\SOUND\IniD8.xsb" "backup\data\SOUND\IniD8.xsb" >nul
if errorlevel 1 goto BACKUP_FAILED
copy /y "!GAME_FOLDER!\data\SOUND\IniD8.xwb" "backup\data\SOUND\IniD8.xwb" >nul
if errorlevel 1 goto BACKUP_FAILED
echo ✅ Backup overwritten.
goto EXTRACT_STEP

:BACKUP_FAILED
echo ❌ Backup failed.
pause
exit /b 1

:EXTRACT_STEP
call :COUNT_FILES "!ADPCM_DIR!" ADPCM_COUNT

echo.
echo ============================================================
echo 📦 ADPCM extraction
echo ============================================================
echo Existing ADPCM files: !ADPCM_COUNT!

if "!ADPCM_COUNT!"=="!EXPECTED_D8_FILES!" goto ASK_SKIP_EXTRACT
goto DO_EXTRACT

:ASK_SKIP_EXTRACT
set "SKIP_EXTRACT="
set /p SKIP_EXTRACT=Found !EXPECTED_D8_FILES! files. Skip extraction? [Yn]: 
if "!SKIP_EXTRACT!"=="" set "SKIP_EXTRACT=y"
if /i "!SKIP_EXTRACT!"=="y" goto CHECK_PCM
if /i "!SKIP_EXTRACT!"=="yes" goto CHECK_PCM
goto DO_EXTRACT

:DO_EXTRACT
echo ♻️ Rebuilding ADPCM extraction folder...
rmdir /s /q "!ADPCM_DIR!" 2>nul
mkdir "!ADPCM_DIR!" 2>nul
pushd "tools\unxwb"
"!UNXWB!" -d "!ADPCM_DIR!" -b "!GAME_FOLDER!\data\SOUND\IniD8.xsb" 284528 "!GAME_FOLDER!\data\SOUND\IniD8.xwb"
set "UNXWB_ERROR=!ERRORLEVEL!"
popd
if not "!UNXWB_ERROR!"=="0" goto EXTRACT_FAILED
goto CHECK_PCM

:EXTRACT_FAILED
echo ❌ unxwb extraction failed.
pause
exit /b 1

:CHECK_PCM
call :COUNT_FILES "!PCM_DIR!" PCM_COUNT
echo.
echo ============================================================
echo 🎧 PCM WAV conversion
echo ============================================================
echo Existing PCM WAV files: !PCM_COUNT!

if "!PCM_COUNT!"=="!EXPECTED_D8_FILES!" goto ASK_SKIP_PCM
goto DO_PCM

:ASK_SKIP_PCM
set "SKIP_PCM="
set /p SKIP_PCM=Found !EXPECTED_D8_FILES! files. Skip PCM conversion? [Yn]: 
if "!SKIP_PCM!"=="" set "SKIP_PCM=y"
if /i "!SKIP_PCM!"=="y" goto XACT_RESET
if /i "!SKIP_PCM!"=="yes" goto XACT_RESET
goto DO_PCM

:DO_PCM
echo ♻️ Rebuilding PCM WAV folder...
rmdir /s /q "!PCM_DIR!" 2>nul
mkdir "!PCM_DIR!" 2>nul
for %%I in ("!ADPCM_DIR!\*") do (
    if exist "%%~fI" (
        "!FFMPEG!" -y -i "%%~fI" "!PCM_DIR!\%%~nI.wav"
    )
)
goto XACT_RESET

:XACT_RESET
echo.
echo ============================================================
echo 🧩 XACT project setup
echo ============================================================

call :ENSURE_DIR "%XACT_PROJECT_DIR%"

if exist "!XACT_BASE!" goto TMP_BASE_READY
if not exist "!TOOLS_XACT_BASE!" goto TMP_BASE_READY
copy /y "!TOOLS_XACT_BASE!" "!XACT_BASE!" >nul
if errorlevel 1 goto XACT_COPY_FAILED
echo ✅ Created tmp\xact-project\idas8i-base.xap from tools\xact-project\idas8i-base.xap.

:TMP_BASE_READY
if exist "!TOOLS_XACT_WORK!" goto TOOLS_WORK_READY
if exist "!TOOLS_XACT_BASE!" (
    copy /y "!TOOLS_XACT_BASE!" "!TOOLS_XACT_WORK!" >nul
    echo ✅ Created tools\xact-project\idas8i.xap from tools\xact-project\idas8i-base.xap.
)

:TOOLS_WORK_READY
if exist "!XACT_WORK!" goto TMP_WORK_READY
if exist "!TOOLS_XACT_WORK!" (
    copy /y "!TOOLS_XACT_WORK!" "!XACT_WORK!" >nul
    if errorlevel 1 goto XACT_COPY_FAILED
    echo ✅ Created tmp\xact-project\idas8i.xap from tools\xact-project\idas8i.xap.
    goto TMP_WORK_READY
)

if exist "!XACT_BASE!" (
    copy /y "!XACT_BASE!" "!XACT_WORK!" >nul
    if errorlevel 1 goto XACT_COPY_FAILED
    echo ✅ Created tmp\xact-project\idas8i.xap from tmp\xact-project\idas8i-base.xap.
    goto TMP_WORK_READY
)

:TMP_WORK_READY

if exist "!XACT_WORK!" goto ASK_XACT_PROJECT_MODE
echo No existing XACT project found.
goto CREATE_FRESH_XACT

:ASK_XACT_PROJECT_MODE
echo Existing XACT project found:
echo(!XACT_WORK!
echo.
set "XACT_PROJECT_MODE="
set /p "XACT_PROJECT_MODE=Use fresh project file? [yN]: "
if /i "!XACT_PROJECT_MODE!"=="y" goto CREATE_FRESH_XACT
if /i "!XACT_PROJECT_MODE!"=="yes" goto CREATE_FRESH_XACT
goto KEEP_EXISTING_XACT

:CREATE_FRESH_XACT
if not exist "!XACT_BASE!" goto NO_XACT_BASE
copy /y "!XACT_BASE!" "!XACT_WORK!" >nul
if errorlevel 1 goto XACT_COPY_FAILED
echo ✅ Reset tmp\xact-project\idas8i.xap from idas8i-base.xap.
goto XACT_PROJECT_READY

:KEEP_EXISTING_XACT
echo Keeping existing XACT project.
goto XACT_PROJECT_READY

:NO_XACT_BASE
echo ⚠️ Missing clean base project:
echo(!XACT_BASE!
echo Continuing with existing XACT project if present.
goto XACT_PROJECT_READY

:XACT_COPY_FAILED
echo ❌ Could not reset XACT project.
pause
exit /b 1

:XACT_PROJECT_READY
goto MAIN_WAV_STEP


:MAIN_WAV_STEP
echo.
echo ============================================================
echo 🎚️ Main replacement WAV processing
echo ============================================================
echo Source songs:
echo(!NEW_MUSICS_DIR!
echo Main replacement WAVs:
echo(!NEW_WAV_DIR!
echo.

call :COUNT_FILES "!NEW_WAV_DIR!" NEW_WAV_COUNT
call :COUNT_FILES "!NEW_MUSICS_DIR!" SOURCE_MUSIC_COUNT

echo Found main replacement WAV files: !NEW_WAV_COUNT!
echo Found source music files: !SOURCE_MUSIC_COUNT!
echo.

if not "!NEW_WAV_COUNT!"=="0" call :NORMALIZE_MAIN_WAV_FILENAMES
call :COUNT_FILES "!NEW_WAV_DIR!" NEW_WAV_COUNT
if not "!NEW_WAV_COUNT!"=="0" goto USE_EXISTING_MAIN_WAVS

:MAIN_MANUAL_AUDIO_STEP
echo ============================================================
echo 🎚️ Manual Audio Processing Step
echo ============================================================
echo.
echo Option 1 - manual ^(recommended for loudness^):
echo Before pressing ENTER, use Adobe Audition, Audacity, or another editor.
echo Convert/loudness-fix the files from new-musics, then export WAV files to:
echo !NEW_WAV_DIR!
echo.
echo Recommended loudness target for manual work:
echo -6 LUFS / -0.1 dBTP
echo.
echo WAV filenames may keep names similar to your music files.
echo Example:
echo 01 Artist - Song Title.wav
echo 02 Artist - Another Song.wav
echo.
echo The tool will then rename those WAVs to the original D8 game filenames.
echo If a WAV already starts with avex, it will be left as-is.
echo.
echo Option 2 - automatic:
echo Leave !NEW_WAV_DIR! empty and press ENTER.
echo The tool will convert files from new-musics directly to the original D8 filenames.
echo.
pause

echo Cleaning Adobe Audition cache files...
del /q "!NEW_WAV_DIR!\*.pkf" >nul 2>nul

call :NORMALIZE_MAIN_WAV_FILENAMES
call :COUNT_FILES "!NEW_WAV_DIR!" NEW_WAV_COUNT
if not "!NEW_WAV_COUNT!"=="0" goto USE_EXISTING_MAIN_WAVS

if "!SOURCE_MUSIC_COUNT!"=="0" goto NO_MAIN_WAV_INPUTS
goto BUILD_MAIN_WAVS_FROM_SOURCE

:USE_EXISTING_MAIN_WAVS
echo Using existing WAVs from tmp\new-wav.
echo Make sure they are named exactly like the original D8 files.
goto PREVIEW_STEP

:NO_MAIN_WAV_INPUTS
echo ❌ No WAV files in tmp\new-wav and no source songs in new-musics.
echo Add manually processed WAVs to tmp\new-wav or source audio files to new-musics, then run again.
pause
exit /b 1

:BUILD_MAIN_WAVS_FROM_SOURCE
echo Rebuilding tmp\new-wav from new-musics...
rmdir /s /q "!NEW_WAV_DIR!" 2>nul
mkdir "!NEW_WAV_DIR!" 2>nul
call :MAKE_MAIN_WAV "01" "avex_01_breakin_out.wav"
call :MAKE_MAIN_WAV "02" "avex_02_notings_gonna_stop_us_tonight.wav"
call :MAKE_MAIN_WAV "03" "avex_03_come_on_baby.wav"
call :MAKE_MAIN_WAV "04" "avex_04_sunlight.wav"
call :MAKE_MAIN_WAV "05" "avex_05_prayer.wav"
call :MAKE_MAIN_WAV "06" "avex_06_your_love_is_like_a_medicine.wav"
call :MAKE_MAIN_WAV "07" "avex_07_when_the_sun_goes_down.wav"
call :MAKE_MAIN_WAV "08" "avex_08_super_driver.wav"
call :MAKE_MAIN_WAV "09" "avex_09_kiss.wav"
call :MAKE_MAIN_WAV "10" "avex_10_far_from_the_light.wav"
call :MAKE_MAIN_WAV "11" "avex_11_the_race_of_the_night.wav"
call :MAKE_MAIN_WAV "12" "avex_12_nonsense_sensation.wav"
call :MAKE_MAIN_WAV "13" "avex_13_hearts_on_fire.wav"
call :MAKE_MAIN_WAV "14" "avex_14_adrenaline.wav"
call :MAKE_MAIN_WAV "15" "avex_15_never_say_never.wav"
call :MAKE_MAIN_WAV "16" "avex_16_i_just_wanna_stay_with_you.wav"
call :MAKE_MAIN_WAV "17" "avex_17_burn_inside.wav"
call :MAKE_MAIN_WAV "18" "avex_18_outsoar_the_rainbow.wav"
call :MAKE_MAIN_WAV "19" "avex_19_raise_up.wav"
call :MAKE_MAIN_WAV "20" "avex_20_raise_up_ed.wav"
goto PREVIEW_STEP

:PREVIEW_STEP
echo.
echo ============================================================
echo 🎼 Replacement WAV folders
echo ============================================================
echo Main replacements:
echo(!NEW_WAV_DIR!
echo Preview replacements:
echo(!NEW_PREV_DIR!
echo Optional preview sources:
echo(!NEW_MUSICS_PREVIEWS_DIR!
echo.

call :COUNT_FILES "!NEW_PREV_DIR!" NEW_PREV_COUNT
call :COUNT_FILES "!NEW_MUSICS_PREVIEWS_DIR!" SOURCE_PREV_COUNT

echo Found preview replacement WAV files: !NEW_PREV_COUNT! ^(D8 uses 19 preview slots^)
echo Found source preview music files: !SOURCE_PREV_COUNT!

if "!SOURCE_PREV_COUNT!"=="0" goto NO_SOURCE_PREVIEWS

echo.
set "USE_SOURCE_PREVIEWS="
set /p "USE_SOURCE_PREVIEWS=Convert files from new-musics-previews to tmp\new-wav-prev? [Yn]: "
if "!USE_SOURCE_PREVIEWS!"=="" set "USE_SOURCE_PREVIEWS=y"
if /i "!USE_SOURCE_PREVIEWS!"=="y" goto BUILD_PREVIEWS_FROM_SOURCE
if /i "!USE_SOURCE_PREVIEWS!"=="yes" goto BUILD_PREVIEWS_FROM_SOURCE
goto CHECK_EXISTING_PREVIEW_WAVS

:NO_SOURCE_PREVIEWS
if "!NEW_PREV_COUNT!"=="0" goto ASK_GENERATE_PREVIEWS
echo Using existing preview WAVs from tmp\new-wav-prev.
goto MOD_OUTPUT_STEP

:CHECK_EXISTING_PREVIEW_WAVS
if "!NEW_PREV_COUNT!"=="0" goto ASK_GENERATE_PREVIEWS
echo Using existing preview WAVs from tmp\new-wav-prev.
goto MOD_OUTPUT_STEP

:BUILD_PREVIEWS_FROM_SOURCE
echo Rebuilding tmp\new-wav-prev from new-musics-previews...
rmdir /s /q "!NEW_PREV_DIR!" 2>nul
mkdir "!NEW_PREV_DIR!" 2>nul
call :MAKE_SOURCE_PREVIEW "01" "select_avex_01_breakin_out.wav"
call :MAKE_SOURCE_PREVIEW "02" "select_avex_02_notings_gonna_stop_us_tonight.wav"
call :MAKE_SOURCE_PREVIEW "03" "select_avex_03_come_on_baby.wav"
call :MAKE_SOURCE_PREVIEW "04" "select_avex_04_sunlight.wav"
call :MAKE_SOURCE_PREVIEW "05" "select_avex_05_prayer.wav"
call :MAKE_SOURCE_PREVIEW "06" "select_avex_06_your_love_is_like_a_medicine.wav"
call :MAKE_SOURCE_PREVIEW "07" "select_avex_07_when_the_sun_goes_down.wav"
call :MAKE_SOURCE_PREVIEW "08" "select_avex_08_super_driver.wav"
call :MAKE_SOURCE_PREVIEW "09" "select_avex_09_kiss.wav"
call :MAKE_SOURCE_PREVIEW "10" "select_avex_10_far_from_the_light.wav"
call :MAKE_SOURCE_PREVIEW "11" "select_avex_11_the_race_of_the_night.wav"
call :MAKE_SOURCE_PREVIEW "12" "select_avex_12_nonsense_sensation.wav"
call :MAKE_SOURCE_PREVIEW "13" "select_avex_13_hearts_on_fire.wav"
call :MAKE_SOURCE_PREVIEW "14" "select_avex_14_adrenaline.wav"
call :MAKE_SOURCE_PREVIEW "15" "select_avex_15_never_say_never.wav"
call :MAKE_SOURCE_PREVIEW "16" "select_avex_16_i_just_wanna_stay_with_you.wav"
call :MAKE_SOURCE_PREVIEW "17" "select_avex_17_burn_inside.wav"
call :MAKE_SOURCE_PREVIEW "18" "select_avex_18_outsoar_the_rainbow.wav"
call :MAKE_SOURCE_PREVIEW "19" "select_avex_19_raise_up.wav"
goto MOD_OUTPUT_STEP

:ASK_GENERATE_PREVIEWS
echo.
set "GENERATE_PREVIEWS="
set /p "GENERATE_PREVIEWS=No previews found. Generate 50s previews from tmp\new-wav? [Yn]: "
if "!GENERATE_PREVIEWS!"=="" set "GENERATE_PREVIEWS=y"
if /i not "!GENERATE_PREVIEWS!"=="y" if /i not "!GENERATE_PREVIEWS!"=="yes" goto MOD_OUTPUT_STEP

echo Rebuilding tmp\new-wav-prev from tmp\new-wav...
rmdir /s /q "!NEW_PREV_DIR!" 2>nul
mkdir "!NEW_PREV_DIR!" 2>nul
call :GENERATE_PREVIEW "avex_01_breakin_out.wav" "select_avex_01_breakin_out.wav"
call :GENERATE_PREVIEW "avex_02_notings_gonna_stop_us_tonight.wav" "select_avex_02_notings_gonna_stop_us_tonight.wav"
call :GENERATE_PREVIEW "avex_03_come_on_baby.wav" "select_avex_03_come_on_baby.wav"
call :GENERATE_PREVIEW "avex_04_sunlight.wav" "select_avex_04_sunlight.wav"
call :GENERATE_PREVIEW "avex_05_prayer.wav" "select_avex_05_prayer.wav"
call :GENERATE_PREVIEW "avex_06_your_love_is_like_a_medicine.wav" "select_avex_06_your_love_is_like_a_medicine.wav"
call :GENERATE_PREVIEW "avex_07_when_the_sun_goes_down.wav" "select_avex_07_when_the_sun_goes_down.wav"
call :GENERATE_PREVIEW "avex_08_super_driver.wav" "select_avex_08_super_driver.wav"
call :GENERATE_PREVIEW "avex_09_kiss.wav" "select_avex_09_kiss.wav"
call :GENERATE_PREVIEW "avex_10_far_from_the_light.wav" "select_avex_10_far_from_the_light.wav"
call :GENERATE_PREVIEW "avex_11_the_race_of_the_night.wav" "select_avex_11_the_race_of_the_night.wav"
call :GENERATE_PREVIEW "avex_12_nonsense_sensation.wav" "select_avex_12_nonsense_sensation.wav"
call :GENERATE_PREVIEW "avex_13_hearts_on_fire.wav" "select_avex_13_hearts_on_fire.wav"
call :GENERATE_PREVIEW "avex_14_adrenaline.wav" "select_avex_14_adrenaline.wav"
call :GENERATE_PREVIEW "avex_15_never_say_never.wav" "select_avex_15_never_say_never.wav"
call :GENERATE_PREVIEW "avex_16_i_just_wanna_stay_with_you.wav" "select_avex_16_i_just_wanna_stay_with_you.wav"
call :GENERATE_PREVIEW "avex_17_burn_inside.wav" "select_avex_17_burn_inside.wav"
call :GENERATE_PREVIEW "avex_18_outsoar_the_rainbow.wav" "select_avex_18_outsoar_the_rainbow.wav"
call :GENERATE_PREVIEW "avex_19_raise_up.wav" "select_avex_19_raise_up.wav"
goto MOD_OUTPUT_STEP

:MOD_OUTPUT_STEP

echo.
echo ============================================================
echo 🛠️ XACT build
echo ============================================================

echo Opening XACT project:
echo %XACT_WORK%
echo.
echo Build/save the project in XACT, then return here.
echo Expected output:
echo %XACT_WIN_DIR%IniD8.xsb
echo %XACT_WIN_DIR%IniD8.xwb
echo.

if exist "%XACT_WORK%" goto LAUNCH_XACT_PROJECT
echo ⚠️ XACT project file not found:
echo %XACT_WORK%
goto WAIT_FOR_XACT_OUTPUT_MANUAL

:LAUNCH_XACT_PROJECT
if not exist "%XACT_EXE%" goto XACT_EXE_MISSING
start "" "%XACT_EXE%" "%XACT_WORK%"
goto WAIT_FOR_XACT_OUTPUT_MANUAL

:XACT_EXE_MISSING
echo ⚠️ Xact3.exe not found:
echo %XACT_EXE%
echo Open XACT manually and build the project.

:WAIT_FOR_XACT_OUTPUT_MANUAL
echo.
echo The script is paused while you edit/build in XACT.
echo Press ENTER only after XACT has generated both output files.
echo Type S then ENTER to skip waiting and package whatever exists.
set "WAIT_XACT_CHOICE="
set /p "WAIT_XACT_CHOICE=Continue? [Enter/S]: "
if /i "!WAIT_XACT_CHOICE!"=="S" goto XACT_OUTPUT_READY

if not exist "%XACT_WIN_DIR%IniD8.xsb" goto XACT_OUTPUT_MISSING
if not exist "%XACT_WIN_DIR%IniD8.xwb" goto XACT_OUTPUT_MISSING
goto XACT_OUTPUT_READY

:XACT_OUTPUT_MISSING
echo.
echo ⚠️ XACT output files are still missing.
echo Expected:
echo %XACT_WIN_DIR%IniD8.xsb
echo %XACT_WIN_DIR%IniD8.xwb
goto WAIT_FOR_XACT_OUTPUT_MANUAL

:XACT_OUTPUT_READY
echo.
echo ✅ XACT output check complete.

echo.
echo ============================================================
echo 📤 Mod output package
echo ============================================================

set "MOD_OUTPUT_DIR=%SCRIPT_DIR%mod-output\"
set "MOD_SOUND_DIR=%MOD_OUTPUT_DIR%data\SOUND\"
set "XACT_WIN_DIR=%XACT_PROJECT_DIR%\Win\"
set "TITLE_LOADER_DIR=%SCRIPT_DIR%tools\d8-song-title-loader\"

if not exist "%MOD_OUTPUT_DIR%" mkdir "%MOD_OUTPUT_DIR%"
if not exist "%MOD_SOUND_DIR%" mkdir "%MOD_SOUND_DIR%"

if exist "%XACT_WIN_DIR%IniD8.xsb" goto COPY_XSB
echo ⚠️ XACT output IniD8.xsb not found yet. Build XACT first, then rerun packaging.
goto AFTER_COPY_XSB

:COPY_XSB
copy /y "%XACT_WIN_DIR%IniD8.xsb" "%MOD_SOUND_DIR%IniD8.xsb" >nul
echo ✅ Added data\SOUND\IniD8.xsb to mod-output.

:AFTER_COPY_XSB
if exist "%XACT_WIN_DIR%IniD8.xwb" goto COPY_XWB
echo ⚠️ XACT output IniD8.xwb not found yet. Build XACT first, then rerun packaging.
goto AFTER_COPY_XWB

:COPY_XWB
copy /y "%XACT_WIN_DIR%IniD8.xwb" "%MOD_SOUND_DIR%IniD8.xwb" >nul
echo ✅ Added data\SOUND\IniD8.xwb to mod-output.

:AFTER_COPY_XWB
if exist "%TITLE_LOADER_DIR%winmm.dll" goto COPY_WINMM
echo ⚠️ winmm.dll not found:
echo %TITLE_LOADER_DIR%winmm.dll
goto AFTER_COPY_WINMM

:COPY_WINMM
copy /y "%TITLE_LOADER_DIR%winmm.dll" "%MOD_OUTPUT_DIR%winmm.dll" >nul
echo ✅ Added winmm.dll to mod-output.

:AFTER_COPY_WINMM
call :GENERATE_SONGS_INI
if errorlevel 1 goto PACKAGE_FAIL

echo.
echo ✅ Mod output package ready:
echo %MOD_OUTPUT_DIR%

echo.
echo ============================================================
echo 🚚 Applying patch to game folder
echo ============================================================

if exist "%MOD_SOUND_DIR%IniD8.xsb" copy /y "%MOD_SOUND_DIR%IniD8.xsb" "!GAME_FOLDER!\data\SOUND\IniD8.xsb" >nul
if exist "%MOD_SOUND_DIR%IniD8.xwb" copy /y "%MOD_SOUND_DIR%IniD8.xwb" "!GAME_FOLDER!\data\SOUND\IniD8.xwb" >nul
if exist "%MOD_OUTPUT_DIR%winmm.dll" copy /y "%MOD_OUTPUT_DIR%winmm.dll" "!GAME_FOLDER!\winmm.dll" >nul
if exist "%MOD_OUTPUT_DIR%songs.ini" copy /y "%MOD_OUTPUT_DIR%songs.ini" "!GAME_FOLDER!\songs.ini" >nul

echo ✅ Patch files copied to game folder.
goto PACKAGE_DONE

:PACKAGE_FAIL
pause
exit /b 1

:PACKAGE_DONE
exit /b 0

:COUNT_FILES
set "COUNT_DIR=%~1"
set "%~2=0"
if not exist "%COUNT_DIR%" exit /b 0
for /f %%C in ('dir /b /a-d "%COUNT_DIR%\*" 2^>nul ^| find /c /v ""') do set "%~2=%%C"
exit /b 0


:NORMALIZE_MAIN_WAV_FILENAMES
echo Checking tmp\new-wav filenames...
call :NORMALIZE_MAIN_WAV "01" "avex_01_breakin_out.wav"
call :NORMALIZE_MAIN_WAV "02" "avex_02_notings_gonna_stop_us_tonight.wav"
call :NORMALIZE_MAIN_WAV "03" "avex_03_come_on_baby.wav"
call :NORMALIZE_MAIN_WAV "04" "avex_04_sunlight.wav"
call :NORMALIZE_MAIN_WAV "05" "avex_05_prayer.wav"
call :NORMALIZE_MAIN_WAV "06" "avex_06_your_love_is_like_a_medicine.wav"
call :NORMALIZE_MAIN_WAV "07" "avex_07_when_the_sun_goes_down.wav"
call :NORMALIZE_MAIN_WAV "08" "avex_08_super_driver.wav"
call :NORMALIZE_MAIN_WAV "09" "avex_09_kiss.wav"
call :NORMALIZE_MAIN_WAV "10" "avex_10_far_from_the_light.wav"
call :NORMALIZE_MAIN_WAV "11" "avex_11_the_race_of_the_night.wav"
call :NORMALIZE_MAIN_WAV "12" "avex_12_nonsense_sensation.wav"
call :NORMALIZE_MAIN_WAV "13" "avex_13_hearts_on_fire.wav"
call :NORMALIZE_MAIN_WAV "14" "avex_14_adrenaline.wav"
call :NORMALIZE_MAIN_WAV "15" "avex_15_never_say_never.wav"
call :NORMALIZE_MAIN_WAV "16" "avex_16_i_just_wanna_stay_with_you.wav"
call :NORMALIZE_MAIN_WAV "17" "avex_17_burn_inside.wav"
call :NORMALIZE_MAIN_WAV "18" "avex_18_outsoar_the_rainbow.wav"
call :NORMALIZE_MAIN_WAV "19" "avex_19_raise_up.wav"
call :NORMALIZE_MAIN_WAV "20" "avex_20_raise_up_ed.wav"
exit /b 0

:NORMALIZE_MAIN_WAV
set "TRACK_NUM=%~1"
set "MAIN_FILE=%~2"
if exist "!NEW_WAV_DIR!\!MAIN_FILE!" exit /b 0
call :FIND_TRACK_SOURCE "!TRACK_NUM!" "!NEW_WAV_DIR!"
if not defined FOUND_SOURCE exit /b 0
for %%A in ("!FOUND_SOURCE!") do set "FOUND_NAME=%%~nxA"
if /i "!FOUND_NAME:~0,4!"=="avex" exit /b 0
echo 📝 !FOUND_NAME! → !MAIN_FILE!
move /y "!FOUND_SOURCE!" "!NEW_WAV_DIR!\!MAIN_FILE!" >nul
if errorlevel 1 (
    echo ❌ ERROR: rename failed for !FOUND_SOURCE!
    exit /b 1
)
exit /b 0

:FIND_TRACK_SOURCE
set "TRACK_NUM=%~1"
set "SEARCH_DIR=%~2"
set "FOUND_SOURCE="
if not exist "!SEARCH_DIR!" exit /b 0
for %%F in ("!SEARCH_DIR!\!TRACK_NUM! *.*" "!SEARCH_DIR!\!TRACK_NUM!_*.*" "!SEARCH_DIR!\!TRACK_NUM!-*.*") do (
    if not defined FOUND_SOURCE if exist "%%~fF" set "FOUND_SOURCE=%%~fF"
)
exit /b 0

:MAKE_MAIN_WAV
set "TRACK_NUM=%~1"
set "MAIN_FILE=%~2"
call :FIND_TRACK_SOURCE "!TRACK_NUM!" "!NEW_MUSICS_DIR!"
if not defined FOUND_SOURCE (
    echo ⚠️ Missing source track !TRACK_NUM! - !MAIN_FILE! not generated.
    exit /b 0
)

echo 🎵 !TRACK_NUM! → !MAIN_FILE!
"!FFMPEG!" -y -i "!FOUND_SOURCE!" "!NEW_WAV_DIR!\!MAIN_FILE!" >nul 2>nul
if errorlevel 1 (
    echo ❌ ERROR: ffmpeg failed for !FOUND_SOURCE!
    exit /b 1
)
exit /b 0

:MAKE_SOURCE_PREVIEW
set "TRACK_NUM=%~1"
set "PREV_FILE=%~2"
call :FIND_TRACK_SOURCE "!TRACK_NUM!" "!NEW_MUSICS_PREVIEWS_DIR!"
if not defined FOUND_SOURCE (
    echo ⚠️ Missing custom preview source !TRACK_NUM! - !PREV_FILE! not generated.
    exit /b 0
)

echo 🎧 !TRACK_NUM! → !PREV_FILE! ^(custom preview source^)
"!FFMPEG!" -y -i "!FOUND_SOURCE!" -t 50 "!NEW_PREV_DIR!\!PREV_FILE!" >nul 2>nul
if errorlevel 1 (
    echo ❌ ERROR: ffmpeg failed for !FOUND_SOURCE!
    exit /b 1
)
exit /b 0

:GENERATE_PREVIEW
set "MAIN_FILE=%~1"
set "PREV_FILE=%~2"

if not exist "!NEW_WAV_DIR!\!MAIN_FILE!" (
    echo ⚠️ Missing !MAIN_FILE! - preview not generated.
    exit /b 0
)

if not exist "!FFMPEG!" (
    echo ❌ ERROR: Missing ffmpeg:
    echo !FFMPEG!
    pause
    exit /b 1
)

echo 🎧 Creating !PREV_FILE! ^(50s^)
"!FFMPEG!" -y -i "!NEW_WAV_DIR!\!MAIN_FILE!" -t 50 "!NEW_PREV_DIR!\!PREV_FILE!" >nul 2>nul

if errorlevel 1 (
    echo ❌ ERROR: ffmpeg failed for !MAIN_FILE!
    exit /b 1
)

exit /b 0






:GENERATE_SONGS_INI
set "SONGS_OUTPUT=%MOD_OUTPUT_DIR%songs.ini"
set "SONGS_PS1=%TMP_DIR%\generate_songs_ini.ps1"

echo Generating songs.ini from new-musics...

if not exist "!NEW_MUSICS_DIR!" (
    echo ⚠️ new-musics folder not found:
    echo !NEW_MUSICS_DIR!
    echo Creating blank songs.ini.
)

> "!SONGS_PS1!" echo $ErrorActionPreference = 'Stop'
>> "!SONGS_PS1!" echo $musicDir = $env:NEW_MUSICS_DIR
>> "!SONGS_PS1!" echo $output = $env:SONGS_OUTPUT
>> "!SONGS_PS1!" echo $lines = New-Object System.Collections.Generic.List[string]
>> "!SONGS_PS1!" echo $lines.Add('[songs]')
>> "!SONGS_PS1!" echo for ($i = 1; $i -le 20; $i++) {
>> "!SONGS_PS1!" echo   $artist = ''
>> "!SONGS_PS1!" echo   $title = ''
>> "!SONGS_PS1!" echo   $num = '{0:D2}' -f $i
>> "!SONGS_PS1!" echo   if ($musicDir -and (Test-Path -LiteralPath $musicDir)) {
>> "!SONGS_PS1!" echo     $file = Get-ChildItem -LiteralPath $musicDir -File ^| Where-Object { $_.BaseName -like ($num + ' *') } ^| Select-Object -First 1
>> "!SONGS_PS1!" echo     if ($file) {
>> "!SONGS_PS1!" echo       $name = $file.BaseName.Substring(3).Trim()
>> "!SONGS_PS1!" echo       $parts = $name -split '\s+-\s+', 2
>> "!SONGS_PS1!" echo       if ($parts.Count -eq 2) {
>> "!SONGS_PS1!" echo         $artist = $parts[0].Trim()
>> "!SONGS_PS1!" echo         $title = $parts[1].Trim()
>> "!SONGS_PS1!" echo       } else {
>> "!SONGS_PS1!" echo         $title = $name
>> "!SONGS_PS1!" echo       }
>> "!SONGS_PS1!" echo     }
>> "!SONGS_PS1!" echo   }
>> "!SONGS_PS1!" echo   $lines.Add(('song{0}={1}' -f $i, $title))
>> "!SONGS_PS1!" echo   $lines.Add(('artist{0}={1}' -f $i, $artist))
>> "!SONGS_PS1!" echo }
>> "!SONGS_PS1!" echo Set-Content -LiteralPath $output -Value $lines -Encoding UTF8

powershell -NoProfile -ExecutionPolicy Bypass -File "!SONGS_PS1!"
if errorlevel 1 (
    echo ❌ ERROR: Failed to generate songs.ini.
    pause
    exit /b 1
)

echo ✅ Generated songs.ini in mod-output.
exit /b 0

:ENSURE_DIR
if not exist "%~1" mkdir "%~1"
exit /b 0

