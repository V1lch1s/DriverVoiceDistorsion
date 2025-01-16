::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::                                                          :::
:::       EDITAR SEGÚN LAS NECESIDADES DE COMPILADO          :::
:::                                                          :::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
:: Se ejecuta la ventana como administrador para cargar las herramientas de Visual Studio Build Tools
net session> nul 2>&1
if not %errorlevel%==0 (
    :: Relanza el archivo con privilegios elevados
    powershell -Command "Start-Process '%~0' -Verb RunAs"
    exit /b
)
REM /k indica que la ventana debe permanecer abierta después de ejecutar el comando especificado.

rem Inicializamos el entorno
call "D:\Visual Studio\IDE\VC\Auxiliary\Build\vcvars64.bat"

rem Compilamos el código fuente
:: Usamos ^ para extender el comando a varias lineas  
cl.exe /Zi /W3 /WX- /D WIN32 /D _KERNEL_MODE /D _WDM_DRIVER_ /Gz ^
:: Incluimos todo lo necesario del Windows Software Development Kit (/km, /shared y /um)
/I "D:\Windows Kits\10\Include\10.0.26100.0\km" ^
/I "D:\Windows Kits\10\Include\10.0.26100.0\shared" ^
/I "D:\Windows Kits\10\Include\10.0.26100.0\um" ^
:: Ahora vinculamos al archivo fuente con link.exe
easyKeyloggerKernelDriver.c /link /OUT:PrimerDriver.sys /SUBSYSTEM:NATIVE /NODEFAULTLIB

rem Con este condicional agregamos tolerancia a los errores
if %ERRORLEVEL% neq 0 (
    echo Error al compilar el driver.
    exit /b %ERRORLEVEL%
) else (
    echo Driver compilado correctamente: PrimerDriver.sys
)

:: Habilitar el modo de prueba con este comando para omitir la firma del driver: bcdedit /set testsigning on
