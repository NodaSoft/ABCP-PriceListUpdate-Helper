@echo off
setlocal

if "%~1"=="" (
  echo Usage: %~nx0 ^<distributor_id^> ^<price_file^> [inc]
  exit /b 2
)
if "%~2"=="" (
  echo Usage: %~nx0 ^<distributor_id^> ^<price_file^> [inc]
  exit /b 2
)

cscript.exe //nologo upload.vbs "%~1" "%~2" "%~3"
