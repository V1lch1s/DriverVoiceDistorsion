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
:: Desglose de los comandos necesarios:
:: 'cl.exe': Llama al compilador de C/C++ de Microsoft Visual Studio IDE (No me gustó y me lo traje al Editor de código para potenciar el aprendizaje con un producto más "Artesanal").
:: '/Zi': Genera información de depuración.
:: '/W3': Establece el nivel de advertencias (/W<n> donde el predeterminado es n=1).
:: '/WX-': Desactiva el tratamiento de advertencias como errores.
:: '/D': Define macros para el preprocesador.
:: 'WIN32': Es una definición de macro para el preprocesador que indica que el código se compila para la API de Windows de 32 bits.
:: '_WDM_DRIVER_': Es una definición de macro que indica que se está escribiendo un driver basado en el modelo Windows Driver Model.
:: '/I': Especifica directorios de inclusión para los archivos de encabezado.
:: '<NombreDelArchivo>.c': Es el archivo fuente que deseas compilar.
:: 'link': Indica que los siguientes parámetros son para el enlazador.
:: '/OUT:driver.sys': Especifica el nombre del archivo de salida.
:: '/SUBSYSTEM:NATIVE': Indica que se está creando un controlador de modo nativo.
:: '/NODEFAULTLIB': Evita que se vinculen bibliotecas predeterminadas.

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
:: Para Firmar el Driver: signtool sign /v /s "Nombre del certificado" /tr http://timestamp.digicert.com /fd SHA256 <NombreDelDriver>.sys

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Macro en programación: es una definición utilizada para asignar nombres a valores constantes o ::
::                        bloques de código antes de la compilación, para cambiar la forma en que ::
::                        el compilador traduce el código fuente (de C) al binario (0 y 1 que en  ::
::                        el notepad se interpretan como caracteres ilegibles).   ~ChatGPT        ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::