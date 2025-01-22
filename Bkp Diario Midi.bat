::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::: Elevate.cmd :::::::::::::::::
:: Automatically check & get admin rights ::
::::::::::::::::::::::::::::::::::::::::::::

@echo off

CLS

ECHO.
ECHO   =============================
ECHO   ==== Running Admin shell ====
ECHO   =============================

:init
setlocal DisableDelayedExpansion
set cmdInvoke=1
set winSysFolder=System32
set "batchPath=%~0"
for %%k in (%0) do set batchName=%%~nk
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
ECHO.
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation
ECHO **************************************

ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO args = "ELEV " >> "%vbsGetPrivileges%"
ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
ECHO Next >> "%vbsGetPrivileges%"

if '%cmdInvoke%'=='1' goto InvokeCmd 

ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
goto ExecElevation

:InvokeCmd
ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
"%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
exit /B

:gotPrivileges
setlocal & cd /d %~dp0
if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

cls

::::::::::::::::::::::::::::
:::::::::: START :::::::::::
::::::::::::::::::::::::::::

@ECHO OFF
COLOR 6

	:: Definindo Variáveis
SET ISC_USER=SYSDBA
SET ISC_PASSWORD=masterkey
SET DB_FILE=MIDI_SRV.FDB
SET SERVICE_NAME=FirebirdGuardianDefaultInstance

IF EXIST "C:\Midipdv" (
	SET DB_PATH=C:\MidiPDV
	SET TEMP_PATH=C:\MidiPDV\Temp
) ELSE (
	SET DB_PATH=C:\Midi
	SET TEMP_PATH=C:\Midi\Temp
)

	:: Verificação do diretorio
IF NOT EXIST "%TEMP_PATH%" MKDIR "%TEMP_PATH%"

	:: Configuração do arquivo de caminho de backup
SET CONFIG_FILE=%TEMP_PATH%\config_backup.ini

	:: Verificar se o caminho de backup já foi configurado
IF EXIST "%CONFIG_FILE%" (
	SET /P BACKUP_PATH=<"%CONFIG_FILE%"
	) ELSE (
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO    Configurando o Caminho do Backup.
		ECHO.
		ECHO   ==================================
		ECHO.
		
		SET /P BACKUP_PATH="Digite o caminho de onde deseja salvar os backups: "
		IF NOT EXIST "!BACKUP_PATH!" MKDIR "!BACKUP_PATH!"
		ECHO !BACKUP_PATH!>"%CONFIG_FILE%"
		CLS
		
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO            Caminho salvo em:
		ECHO    %CONFIG_FILE%
		ECHO.
		ECHO   ==================================
		ECHO.
		TIMEOUT /T 2
		CLS
	)

	:: Verificar novamente se BACKUP_PATH está configurado corretamente
IF NOT DEFINED BACKUP_PATH (
	ECHO.
	ECHO   ===================================
	ECHO.
	ECHO                 [ERRO] 
	ECHO    Caminho do backup nao configurado
	ECHO.
	ECHO   ===================================
	ECHO.
	PAUSE
	EXIT /B
)

		:: Mensagem inicial
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Iniciando Proceso de Backup...
	ECHO.
	ECHO             Midi_srv.fdb
	ECHO.
	ECHO   ==================================
	ECHO.
	TIMEOUT /T 2
	CLS

	:: Mudando para o diretório do banco de dados
CD %TEMP_PATH%

	:: Verificação dos arquivos necessarios
IF NOT EXIST "%TEMP_PATH%\fbclient.dll" (
	IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin" (
		COPY "C:\Program Files (x86)\Firebird\Firebird_2_5\bin\fbclient.dll" "%TEMP_PATH%" >NUL
		) ELSE (
		COPY "C:\Program Files\Firebird\Firebird_2_5\bin\fbclient.dll" "%TEMP_PATH%" >NUL
		))
		
IF NOT EXIST "%TEMP_PATH%\gbak.exe" (
	IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin" (
		COPY "C:\Program Files (x86)\Firebird\Firebird_2_5\bin\gbak.exe" "%TEMP_PATH%" >NUL
		) ELSE (
		COPY "C:\Program Files\Firebird\Firebird_2_5\bin\gbak.exe" "%TEMP_PATH%" >NUL
		))

	:: Captura o nome do dia da semana em português
FOR /F "tokens=2 delims==" %%D IN ('WMIC Path Win32_LocalTime Get DayOfWeek /value') DO SET DAY_NUM=%%D
	SET DAY_NAME=
		IF "%DAY_NUM%"=="0" SET DAY_NAME=Domingo
		IF "%DAY_NUM%"=="1" SET DAY_NAME=Segunda
		IF "%DAY_NUM%"=="2" SET DAY_NAME=Terca
		IF "%DAY_NUM%"=="3" SET DAY_NAME=Quarta
		IF "%DAY_NUM%"=="4" SET DAY_NAME=Quinta
		IF "%DAY_NUM%"=="5" SET DAY_NAME=Sexta
		IF "%DAY_NUM%"=="6" SET DAY_NAME=Sabado

	:: Ajuste no nome do arquivo de backup para cada dia da semana
SET BACKUP_FILE=%BACKUP_PATH%\Midi_srv_%DAY_NAME%.gbk

		:: Parando o serviço Firebird
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Parando o servico Firebird...
	ECHO.
	ECHO   ==================================
	ECHO.
	NET STOP "%SERVICE_NAME%" >NUL
	CLS

		:: Removendo backup anterior, se existir
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Removendo backup anterior...
	ECHO.
	ECHO   ==================================
	ECHO.
	IF EXIST "%TEMP_PATH%\%DB_FILE%" DEL "%TEMP_PATH%\%DB_FILE%"	
	COPY "%DB_PATH%\%DB_FILE%" "%TEMP_PATH%" >NUL
	IF EXIST "%BACKUP_FILE%" DEL "%BACKUP_FILE%"
	CLS

		:: Iniciando o serviço Firebird
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Iniciando o servico Firebird...
	ECHO.
	ECHO   ==================================
	ECHO.
	NET START "%SERVICE_NAME%" >NUL
	CLS

	:: Realizando backup com gbak
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO       Iniciando Backup Diario...
	ECHO.
	ECHO   ==================================
	ECHO.
	TIMEOUT /T 2
	CLS
	
	GBAK -B -V -I -G -L -O "%DB_FILE%" "%BACKUP_FILE%"
	TIMEOUT /T 2
	CLS
	
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO       Backup Diario Finalizado...
	ECHO.
	ECHO   ==================================
	ECHO.
	IF EXIST "%TEMP_PATH%\%DB_FILE%" DEL "%TEMP_PATH%\%DB_FILE%"
	IF EXIST "%TEMP_PATH%\fbclient.dll" DEL "%TEMP_PATH%\fbclient.dll"
	IF EXIST "%TEMP_PATH%\gbak.exe" DEL "%TEMP_PATH%\gbak.exe"

:END
	TIMEOUT /T 3 
	EXIT
