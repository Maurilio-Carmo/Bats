@ECHO OFF

COLOR 6
SETLOCAL ENABLEDELAYEDEXPANSION

	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Script para Organizar XML's
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE

:INI
		:: Diretórios de origem
	CLS
	ECHO.
	SET /P ORIGEM=" Digite o caminho de ORIGEM dos arquivos XML: "
	ECHO.

		:: Verifica se o diretório de origem existe
	IF NOT EXIST "%ORIGEM%" (
		CLS
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO    O diretorio de ORIGEM nao existe.
		ECHO.
		ECHO   ==================================
		ECHO.
		PAUSE
		GOTO INI
)	

		:: Diretórios de destino
	SET /P DESTINO=" Digite o caminho de DESTINO dos arquivos XML: "
	ECHO.

		:: Cria o diretório de destino, se não existir
	IF NOT EXIST "%DESTINO%" (
		MKDIR "%DESTINO%"
		)

	:: Processa cada arquivo xml no diretório de origem
FOR %%F IN ("%ORIGEM%\*.xml") DO (
	SET "ARQUIVO=%%~NXF"
	
		:: Extrai o ano, mês e serial do nome do arquivo
	SET "ANO=20!ARQUIVO:~2,2!"
	SET "MES=!ARQUIVO:~4,2!"
	SET "SERIAL=!ARQUIVO:~22,9!"
	
		:: Cria o caminho de destino
	SET "DESTINO_COMPLETO=%DESTINO%\!ANO!\!MES!\!SERIAL!"

		:: Cria o diretório de destino, se não existir
	IF NOT EXIST "!DESTINO_COMPLETO!" (
		MKDIR "!DESTINO_COMPLETO!"
		)
	
		:: Copia o arquivo para o diretório de destino
	COPY "%%F" "!DESTINO_COMPLETO!\"  >NUL
	)

ENDLOCAL

	CLS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO    Arquivos organizados com sucesso.
	ECHO.
	ECHO   ==================================
	ECHO.

:END
	PAUSE