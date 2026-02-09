@echo off
setlocal
echo ==========================================
echo       MONTAGEM DO INSTALADOR SSLS
echo ==========================================

REM Garante que estamos no diretorio do script
cd /d "%~dp0"

REM Limpeza de builds anteriores
if exist payload.zip del payload.zip
if exist SSLS_Setup.exe del SSLS_Setup.exe

echo [1/3] Criando arquivo compactado (src)...
powershell -NoProfile -Command "Compress-Archive -Path '..\src\*' -DestinationPath 'payload.zip' -Force"

if not exist payload.zip (
    echo [ERRO] Falha ao criar payload.zip. Verifique se a pasta src existe.
    pause
    exit /b 1
)

echo [2/3] Localizando compilador C#...
set "CSC=%WINDIR%\Microsoft.NET\Framework64\v4.0.30319\csc.exe"

if not exist "%CSC%" (
    echo [ERRO] Compilador C# nao encontrado em:
    echo %CSC%
    echo Verifique se o .NET Framework 4.5+ esta instalado.
    pause
    exit /b 1
)

echo [3/3] Compilando Setup.exe...
"%CSC%" /target:winexe /out:SSLS_Setup.exe /win32icon:..\src\icon.ico /resource:payload.zip Setup.cs /reference:System.IO.Compression.FileSystem.dll

if exist SSLS_Setup.exe (
    echo.
    echo ==========================================
    echo             SUCESSO!
    echo ==========================================
    echo Arquivo criado: Setup\SSLS_Setup.exe
    echo Voce pode fechar esta janela ou testar o instalador agora.
) else (
    echo [ERRO] Falha na compilacao. Verifique o codigo fonte.
)

pause
endlocal
