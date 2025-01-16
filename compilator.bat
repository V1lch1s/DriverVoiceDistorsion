@echo off
:: Se ejecuta la ventana como administrador para cargar las herramientas de Visual Studio Build Tools
net session> nul 2>&1
if not %errorlevel%==0 (
    :: Relanza el archivo con privilegios elevados
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)
REM /k indica que la ventana debe permanecer abierta después de ejecutar el comando especificado.
start cmd.exe /k "D:\Visual Studio\IDE\VC\Auxiliary\Build\vcvars64.bat" && cd /d "C:\Users\cmart\OneDrive\Desktop\Prácticas de C++\DriverVoiceDistorsion"