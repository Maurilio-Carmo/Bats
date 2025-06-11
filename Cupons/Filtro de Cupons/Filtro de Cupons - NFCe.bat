@ECHO OFF
COLOR 6
SETLOCAL ENABLEDELAYEDEXPANSION

	:: Configuracao dos diretorios de origem e destino
SET "ORIGEM=C:\XML\XML Completo"
SET "DESTINO=C:\XML\XML Quebra"
SET "QUEBRA=C:\XML\Quebra.txt"
SET "LOGE=C:\XML\Log Encontrados.txt"
SET "LOGN=C:\XML\Log Nao Encontrados.txt"

	:: Inicio do script - configuracao inicial do diretorio XML
:INI
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO    Crie o diretorio "XML" no disco C:
	ECHO.
	ECHO            1 - Criar
	ECHO.
	ECHO            2 - Ja tenho
	ECHO.
	ECHO   ==================================
	ECHO.

SET /P CHOOSE= Digite a opcao: 
CLS

	:: Validacao de entrada do menu inicial
IF "%CHOOSE%" NEQ "1" IF "%CHOOSE%" NEQ "2" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 2!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO INI
)

	:: Opcao 1: cria o diretorio "XML" se nao existir
IF "%CHOOSE%"=="1" (
	MKDIR "C:\XML"
	GOTO INSTRUCAO
)

	:: Opcao 2: verifica se o diretorio ja existe
IF "%CHOOSE%"=="2" (
	IF NOT EXIST "C:\XML" (
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO       "C:\XML" nao foi encontrado
		ECHO.
		ECHO   ==================================
		ECHO.
		PAUSE
		CLS
		GOTO INI
	)
	GOTO INSTRUCAO
)

:INSTRUCAO
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Crie um arquivo com a Quebra
	ECHO.
	ECHO          "C:\XML\Quebra.txt"
	ECHO.
	ECHO.
	ECHO       Serie (3) + Sequencial (9)
	ECHO           Ex.: 001000005314
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS

	:: Verifica se Quebra.txt existe
:LISTA
	IF NOT EXIST "%QUEBRA%" (
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO    "Quebra.txt" nao foi encontrado
		ECHO.
		ECHO   ==================================
		ECHO.
		PAUSE
		CLS
		GOTO INSTRUCAO
	)
	
	:: Cria o diretorio de destino XML Completo, se nao existir
IF NOT EXIST "%ORIGEM%" MKDIR "%ORIGEM%"

	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Coloque todos XML's na pasta
	ECHO.
	ECHO         "C:\XML\XML Completo"
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS

	:: Limpando arquivos de log's no inicio da execução
> "%LOGE%" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO       Log de Arquivos Encontrados
	ECHO.
	ECHO   ==================================
	ECHO.
)

> "%LOGN%" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Log de Arquivos Não Encontrados
	ECHO.
	ECHO   ==================================
	ECHO.
)

:LOOP

CD "C:\XML"

	:: Limpa o diretorio de destino para garantir que esta vazio
RMDIR /S /Q "%DESTINO%" 2>NUL
MKDIR "%DESTINO%"

	:: Processa cada linha do arquivo Quebra.txt e copia arquivos que correspondem ao ID
FOR /F "usebackq delims=" %%I IN ("%QUEBRA%") DO (
	SET "ID=%%I"
	SET "FOUND=0"
	ECHO Processando ID: !ID!

		:: Varre todos os arquivos XML na pasta Completo e filtra pelo ID
	FOR %%F IN ("%ORIGEM%\*%%I*-nfe.xml") DO (
		SET "FILENAME=%%~nxF"
		SET "SUBSTRING=!FILENAME:~22,12!"

		IF "!SUBSTRING!"=="!ID!" (
			SET "FOUND=1"
			
				:: Extrai o ano, mes e serial do nome do arquivo
			SET "ANO=20!FILENAME:~2,2!"
			SET "MES=!FILENAME:~4,2!"
			SET "SERIAL=!FILENAME:~22,3!"

				:: Define o caminho de destino organizado
			SET "DESTINO_QUEBRA=%DESTINO%\Ano - !ANO!\Mes - !MES!\Serial - !SERIAL!"

				:: Cria o diretorio de destino, se nao existir
			IF NOT EXIST "!DESTINO_QUEBRA!" (
				ECHO.>> "%LOGE%"
				ECHO Criando diretorio de destino: >> "%LOGE%"
				ECHO     !DESTINO_QUEBRA! >> "%LOGE%"
				ECHO.>> "%LOGE%"
				MKDIR "!DESTINO_QUEBRA!"
			)

				:: Copia o arquivo para o diretorio organizado e grava no log
			COPY "%%F" "!DESTINO_QUEBRA!\" >NUL
			ECHO Arquivo copiado: !FILENAME! com ID: !ID! >> "%LOGE%"
		)
	)
		:: Verifica se algum arquivo foi encontrado e, se nao, registra no log de nao encontrados
	IF "!FOUND!"=="0" (
		ECHO ID não encontrado: !ID! >> "%LOGN%
	)
)

	CLS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Verifique os Arquivos na Pasta:
	ECHO.
	ECHO          "C:\XML\XML Quebra"
	ECHO.
	ECHO   ==================================
	ECHO.

:END
	TIMEOUT /T 3
	EXIT
