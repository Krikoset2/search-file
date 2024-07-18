@echo off
color 4
echo                               __       _____ __   
echo    ________  ____ ___________/ /_     / __(_) /__ 
echo   / ___/ _ \/ __ `/ ___/ ___/ __ \   / /_/ / / _ \
echo  (__  )  __/ /_/ / /  / /__/ / / /  / __/ / /  __/
echo /____/\___/\__,_/_/   \___/_/ /_/  /_/ /_/_/\___/ 
echo.
setlocal enabledelayedexpansion
set /p searchText="?->> "
set folderPath=file
powershell -Command "Get-ChildItem -Path '%folderPath%' -Directory | ForEach-Object {Write-Output $_.Name}"
set /p userFolder="?->>: "
set searchFolder=%folderPath%\%userFolder%
color c
set outputFile=%searchText%.txt
powershell -Command ^
    "Remove-Item '%outputFile%' -ErrorAction SilentlyContinue;" ^
    "Get-ChildItem -Path '%searchFolder%' -Recurse -File | ForEach-Object { " ^
    "    $filePath = $_.FullName; " ^
    "    $fileName = $_.Name; " ^
    "    try { " ^
    "        Get-Content -Path $filePath -ErrorAction SilentlyContinue | ForEach-Object { " ^
    "            if ($_ -match '(?i)%searchText%') { " ^
    "                $output = '->> ' + $fileName + ': ' + $_.Trim(); " ^
    "                Write-Output $output; " ^
    "                Add-Content -Path '%outputFile%' -Value $output; " ^
    "            } " ^
    "        } " ^
    "    } catch { " ^
    "        $errorOutput = 'Could not read file ' + $fileName + ': ' + $_.Exception.Message; " ^
    "        Write-Output $errorOutput; " ^
    "        Add-Content -Path '%outputFile%' -Value $errorOutput; " ^
    "    } " ^
    "} "

color a
echo !->> %outputFile%
pause
