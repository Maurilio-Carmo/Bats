::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::: Elevate.cmd :::::::::::::::::
:: Automatically check & get admin rights ::
::::::::::::::::::::::::::::::::::::::::::::

@ECHO OFF

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
set "vbsGetPrivileges=%BAT%\OEgetPriv_%batchName%.vbs"
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
SETLOCAL ENABLEDELAYEDEXPANSION
SET HORARIO=%TIME:~0,5%
SET HORARIO=%HORARIO: =0%
SET HORARIO=%HORARIO::= %
SET DATA_ATUAL=%date:~0,2% %date:~3,2% %date:~6,4%
SET DATA_HORA=%DATA_ATUAL% - %HORARIO%

SET ISC_USER=SYSDBA
SET ISC_PASSWORD=masterkey
SET BACKUP_PATH=BKP Reparacao
SET BAT_PATH=BAT Reparacao
SET LOG_PATH="%BACKUP_PATH%\Log_Reparo.txt"

SET NEW_PORT=3055
SET BAT_FIREBIRD_CONF="%BAT_PATH%\firebird.conf"
IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\" (
	SET FIREBIRD_CONF="C:\Program Files (x86)\Firebird\Firebird_2_5\firebird.conf"
	) ELSE (
	SET FIREBIRD_CONF="C:\Program Files\Firebird\Firebird_2_5\firebird.conf"
	)

:INI

	:: Menu de seleção do sistema
ECHO.
ECHO   ==================================
ECHO.
ECHO           Escolha o Sistema!
ECHO.
ECHO.
ECHO              1 - SysPDV
ECHO.
ECHO              2 - Midi 4
ECHO.
ECHO              3 - Midi 5
ECHO.
ECHO.
ECHO              0 - Sair
ECHO.
ECHO   ==================================
ECHO.
SET /P SYSTEM=" Digite a opcao do sistema: "
CLS

	:: Validação de entrada do sistema
IF "%SYSTEM%" NEQ "1" IF "%SYSTEM%" NEQ "2" IF "%SYSTEM%" NEQ "3" IF "%SYSTEM%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO INI
)

	:: Definindo banco de dados e caminhos
IF "%SYSTEM%" EQU "1" (
	SET SYSTEM_NAME=syspdv
	SET PATH_BASE=C:\SYSPDV
)
IF "%SYSTEM%" EQU "2" (
	SET SYSTEM_NAME=midi
	SET PATH_BASE=C:\MIDIPDV
)
IF "%SYSTEM%" EQU "3" (
	SET SYSTEM_NAME=midi
	SET PATH_BASE=C:\MIDI
)
IF "%SYSTEM%" EQU "0" (
	EXIT
)

	:: Menu de seleção do banco
:CHOOSE_DB
ECHO.
ECHO   ==================================
ECHO.
ECHO        Escolha o Banco de Dados!
ECHO.
ECHO.
ECHO            1 - %SYSTEM_NAME%_srv
ECHO.
ECHO            2 - %SYSTEM_NAME%_mov
ECHO.
ECHO            3 - %SYSTEM_NAME%_cad
ECHO.
ECHO.
ECHO            0 - Voltar
ECHO.
ECHO   ==================================
ECHO.
SET /P DATA_BASE=" Digite a opcao do banco: "
CLS

	:: Validação de entrada do banco
IF "%DATA_BASE%" NEQ "1" IF "%DATA_BASE%" NEQ "2" IF "%DATA_BASE%" NEQ "3" IF "%DATA_BASE%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO CHOOSE_DB
)

IF "%DATA_BASE%" EQU "1" SET DB_FILE=%SYSTEM_NAME%_SRV
IF "%DATA_BASE%" EQU "2" SET DB_FILE=%SYSTEM_NAME%_MOV
IF "%DATA_BASE%" EQU "3" SET DB_FILE=%SYSTEM_NAME%_CAD
IF "%DATA_BASE%" EQU "0" GOTO INI

	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO          Iniciando Reparacao
	ECHO.
	ECHO              %DB_FILE%
	ECHO.
	ECHO          Local: %PATH_BASE%
	ECHO.
	ECHO   ==================================
	ECHO.
	TIMEOUT /T 3
	CLS
	
	:: REPARAÇÃO DE BANCO
:PREPARACAO

CD "%PATH_BASE%"
	
	:: Criando diretorios necessarios
IF NOT EXIST "%BACKUP_PATH%" MKDIR "%BACKUP_PATH%"
IF EXIST "%BAT_PATH%" RMDIR /S /Q "%BAT_PATH%"
MKDIR "%BAT_PATH%"
ATTRIB +H "%BAT_PATH%"

		:: Parando o serviço Firebird
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Trocando Porta do Firebird...
	ECHO.
	ECHO   ==================================
	ECHO.
	NET STOP FirebirdGuardianDefaultInstance >NUL
	TASKKILL /F /IM firebird* >NUL
	CLS

		:: Alterar a porta no arquivo de configuração
	COPY %FIREBIRD_CONF% %BAT_FIREBIRD_CONF% >NUL
	FINDSTR /V /R "^RemoteServicePort=" %BAT_FIREBIRD_CONF% > "%BAT_PATH%\BAT_config.conf"
	ECHO RemoteServicePort = %NEW_PORT% >> "%BAT_PATH%\BAT_config.conf"
	COPY /Y "%BAT_PATH%\BAT_config.conf" %FIREBIRD_CONF% >NUL

		:: Copia de Seguraça e arquivos para reparo
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Realizando Copia de Seguraca
	ECHO.
	ECHO   ==================================
	ECHO.
	COPY "%DB_FILE%.FDB" "%BACKUP_PATH%\%DB_FILE% - %DATA_HORA%.FDB" >NUL
	MOVE "%DB_FILE%.FDB" "%BAT_PATH%" >NUL
	IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin" (
		COPY "C:\Program Files (x86)\Firebird\Firebird_2_5\bin\fbclient.dll" "%BAT_PATH%" >NUL
		COPY "C:\Program Files (x86)\Firebird\Firebird_2_5\bin\gfix.exe" "%BAT_PATH%" >NUL
		COPY "C:\Program Files (x86)\Firebird\Firebird_2_5\bin\gbak.exe" "%BAT_PATH%" >NUL
		) ELSE (
		COPY "C:\Program Files\Firebird\Firebird_2_5\bin\fbclient.dll" "%BAT_PATH%" >NUL
		COPY "C:\Program Files\Firebird\Firebird_2_5\bin\gfix.exe" "%BAT_PATH%" >NUL
		COPY "C:\Program Files\Firebird\Firebird_2_5\bin\gbak.exe" "%BAT_PATH%" >NUL
		)
	CLS

		:: Iniciando o serviço Firebird
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Iniciando o servico Firebird...
	ECHO.
	ECHO   ==================================
	ECHO.	
	NET START FirebirdGuardianDefaultInstance >NUL
	CLS

:REPARACAO

	:: Limpando o arquivo de Log
> %LOG_PATH% (ECHO.)
	
	:: Corrige Corrupção no Banco
ECHO.
ECHO   ==================================
ECHO.
ECHO         Corrigindo Corrupcao...
ECHO.
ECHO   ==================================
ECHO.
"%BAT_PATH%\"GFIX -M -I "%BAT_PATH%\%DB_FILE%.FDB" || GOTO ROLLBACK
CLS

	:: Alterando para somente leitura...
"%BAT_PATH%\"GFIX -MO READ_ONLY "%BAT_PATH%\%DB_FILE%.FDB" || GOTO ROLLBACK
	
	:: Criando Arquivo de Reparacao...
ECHO.
ECHO   ==================================
ECHO.
ECHO     Criando Arquivo de Reparacao...
ECHO.
ECHO   ==================================
ECHO.

	(
	ECHO   ==================================
	ECHO.
	ECHO     Criando Arquivo de Reparacao...
	ECHO.
	ECHO   ==================================
	ECHO.
	) >> %LOG_PATH%

"%BAT_PATH%\"GBAK -B -V -I -G -L -O "%BAT_PATH%\%DB_FILE%.FDB" "%BAT_PATH%\%DB_FILE% - %DATA_ATUAL%.GBK" >> %LOG_PATH% || GOTO ROLLBACK
TIMEOUT /T 2
CLS
	
	:: Reparando a partir do Arquivo...
ECHO.
ECHO   ==================================
ECHO.
ECHO    Reparando apartir do Arquivo...
ECHO.
ECHO   ==================================
ECHO.

	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO    Reparando apartir do Arquivo...
	ECHO.
	ECHO   ==================================
	ECHO.
	) >> %LOG_PATH%
	
"%BAT_PATH%\"GBAK -C -V "%BAT_PATH%\%DB_FILE% - %DATA_ATUAL%.GBK" "%DB_FILE%.FDB" >> %LOG_PATH% || GOTO ROLLBACK
TIMEOUT /T 2
CLS

		:: Alterando para leitura e escrita...
"%BAT_PATH%\"GFIX -MO READ_WRITE "%DB_FILE%.FDB" || GOTO ROLLBACK
SET "FOUND=0"
GOTO END

:ROLLBACK
		:: Restaurando o backup mais recente
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            Falha no Reparo! 
	ECHO.
	ECHO          Restaurando Backup...
	ECHO.
	ECHO   ==================================
	ECHO.
	SET "FOUND=1"
	COPY "%BACKUP_PATH%\%DB_FILE% - %DATA_ATUAL%.FDB" "%DB_FILE%.FDB" >NUL
	CLS

:END
		:: Retoma a Porta original do firebird
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Retomando Porta do Firebird...
	ECHO.
	ECHO   ==================================
	ECHO.
	NET STOP FirebirdGuardianDefaultInstance >NUL
	TASKKILL /F /IM firebird* >NUL
	COPY /Y %BAT_FIREBIRD_CONF% %FIREBIRD_CONF% >NUL
	CLS
	
		:: Iniciando o serviço Firebird
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Iniciando o servico Firebird...
	ECHO.
	ECHO   ==================================
	ECHO.	
	NET START FirebirdGuardianDefaultInstance >NUL
	CLS
	
	:: Limpando diretorio BATorario
IF EXIST "%BAT_PATH%" RMDIR /S /Q "%BAT_PATH%"
IF "!FOUND!"=="0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        EXECUTADO COM SUCESSO!
	ECHO.
	ECHO   ==================================
	ECHO.
	) ELSE (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO         EXECUTADO COM FALHA!
	ECHO.
	ECHO   ==================================
	ECHO.
	)
	PAUSE
	EXIT
