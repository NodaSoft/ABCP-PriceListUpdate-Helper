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

if "%~3"=="" (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0upload.ps1" -DistributorId "%~1" -FilePath "%~2"
) else (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0upload.ps1" -DistributorId "%~1" -FilePath "%~2" -Mode "%~3"
)
