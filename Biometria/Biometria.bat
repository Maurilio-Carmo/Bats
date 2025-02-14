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
SETLOCAL ENABLEDELAYEDEXPANSION

SET ISC_USER=SYSDBA
SET ISC_PASSWORD=masterkey
SET SYSPDV_CAD_PATH=C:\SYSPDV\SYSPDV_CAD.FDB
SET SYSPDV_MOV_PATH=C:\SYSPDV\SYSPDV_MOV.FDB
SET TEMP_PATH=C:\SYSPDV\TEMP
SET LOG_PATH=%TEMP_PATH%\Log_Biometria.txt

	:: Configura Caminho do Firebird
IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin" (
	SET FIREBIRD_PATH="C:\Program Files (x86)\Firebird\Firebird_2_5\bin"
) ELSE (
	SET FIREBIRD_PATH="C:\Program Files\Firebird\Firebird_2_5\bin"
)

	:: Configura Caminho do Aplicativo
IF EXIST "C:\SYSPDV\SYSPDV_PDV.EXE" (
	SET SYSPDV_EXE=SYSPDV_PDV.EXE
	SET SYSPDV_EXE_PATH=C:\SYSPDV\SYSPDV_PDV.EXE
) ELSE (
	SET SYSPDV_EXE=SYSPDV_SCI.EXE
	SET SYSPDV_EXE_PATH=C:\SYSPDV\SYSPDV_SCI.EXE
)

	:: Verifica Caminho Temporario
IF NOT EXIST "%TEMP_PATH%" (
	MD "%TEMP_PATH%"
	ATTRIB +H "%TEMP_PATH%"
	)

	:: Verifica Caminho Arquivos
IF NOT EXIST %SYSPDV_CAD_PATH% (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [ERRO]
	ECHO.
	ECHO     Banco SYSPDV_CAD nao Encontrado!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO END
	)
IF NOT EXIST %SYSPDV_MOV_PATH% (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [ERRO]
	ECHO.
	ECHO     Banco SYSPDV_MOV nao Encontrado!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO END
	)

(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [INICIADO]
	ECHO.
	ECHO       %DATE% as %TIME%
	ECHO.
	ECHO   ==================================
	ECHO.
) > "%LOG_PATH%"

:INI
CD /D %FIREBIRD_PATH%

		:: Menu Inicial
ECHO.
ECHO   ==================================
ECHO.
ECHO      Escolha a Opcao da Biometria!
ECHO.
ECHO             1 - Desativar
ECHO.
ECHO             2 - Reativar
ECHO.
ECHO   ==================================
ECHO.
SET /P CHOOSE=" Digite a opcao: "
CLS

	:: Validação de entrada Menu Inicial
IF "%CHOOSE%" NEQ "1" IF "%CHOOSE%" NEQ "2" IF "%CHOOSE%" NEQ "9" IF "%CHOOSE%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO        Por favor, escolha 1 ou 2!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO INI
)

	:: Processar a escolha do usuário
IF "%CHOOSE%"=="1" GOTO DESATIVAR
IF "%CHOOSE%"=="2" GOTO REATIVAR

:DESATIVAR
ECHO.
ECHO   ==================================
ECHO.
ECHO        Desativando Biometria...
ECHO.
ECHO   ==================================
ECHO.
TASKKILL /F /IM %SYSPDV_EXE% > NUL
TIMEOUT /T 2
CLS

	:: Cria arquivos SQL na pasta TEMP para remover biometria
IF EXIST "%TEMP_PATH%\Locdigsen_Original.txt" DEL "%TEMP_PATH%\Locdigsen_Original.txt"
(
	ECHO SET HEADING OFF;
	ECHO OUTPUT "%TEMP_PATH%\Locdigsen_Original.txt";
	ECHO SELECT COALESCE^(LOCDIGSEN, 'T'^) FROM CONFIGPDV;
	ECHO UPDATE CONFIGPDV SET LOCDIGSEN = 'T'; 
	ECHO EXIT;
) > "%TEMP_PATH%\Desativar_cad.sql"

IF EXIST "%TEMP_PATH%\Cxalocdigsen_Original.txt" DEL "%TEMP_PATH%\Cxalocdigsen_Original.txt"
(
	ECHO SET HEADING OFF;
	ECHO OUTPUT "%TEMP_PATH%\Cxalocdigsen_Original.txt";
	ECHO SELECT COALESCE^(CXALOCDIGSEN, '0'^) FROM CAIXA;
	ECHO UPDATE CAIXA SET CXALOCDIGSEN = '0';
	ECHO EXIT;
) > "%TEMP_PATH%\Desativar_mov.sql"

	:: Executa os arquivos SQL
ECHO INPUT '%TEMP_PATH%\Desativar_cad.sql'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%SYSPDV_CAD_PATH%" >> "%LOG_PATH%" 2>&1
	(ECHO [SUCESSO]) >> "%LOG_PATH%"
IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [ERRO]
	ECHO.
	ECHO      Ao Desativar Biometria _cad!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO INI
)
ECHO INPUT '%TEMP_PATH%\Desativar_mov.sql'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%SYSPDV_MOV_PATH%" >> "%LOG_PATH%" 2>&1
	(ECHO [SUCESSO]
	 ECHO.
	) >> "%LOG_PATH%"
IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [ERRO]
	ECHO.
	ECHO      Ao Desativar Biometria _mov!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO INI
)

ECHO.
ECHO   ==================================
ECHO.
ECHO               [SUCESSO]
ECHO.
ECHO          Biometria Desativada!
ECHO.
ECHO   ==================================
ECHO.
START "" "%SYSPDV_EXE_PATH%" > NUL
TIMEOUT /T 3
IF EXIST "%TEMP_PATH%\Desativar_cad.sql" DEL "%TEMP_PATH%\Desativar_cad.sql"
IF EXIST "%TEMP_PATH%\Desativar_mov.sql" DEL "%TEMP_PATH%\Desativar_mov.sql"
CLS
GOTO INI

:REATIVAR
ECHO.
ECHO   ==================================
ECHO.
ECHO        Restaurando Biometria...
ECHO.
ECHO   ==================================
ECHO.
TASKKILL /F /IM %SYSPDV_EXE% > NUL
TIMEOUT /T 2
CLS

	:: Recupera valores originais dos arquivos temporários
IF EXIST "%TEMP_PATH%\Locdigsen_Original.txt" (
FOR /F "usebackq tokens=*" %%A IN ("%TEMP_PATH%\Locdigsen_Original.txt") DO SET LOCDIGSEN_ORIGINAL=%%A
	::SET LOCDIGSEN_ORIGINAL=%LOCDIGSEN_ORIGINAL:~0,1%
	IF "%LOCDIGSEN_ORIGINAL%"=="" (
		SET LOCDIGSEN_ORIGINAL=B
		)
	) ELSE (
		SET LOCDIGSEN_ORIGINAL=B
	)	
	
IF EXIST "%TEMP_PATH%\Cxalocdigsen_Original.txt" (
FOR /F "usebackq tokens=*" %%A IN ("%TEMP_PATH%\Cxalocdigsen_Original.txt") DO SET CXALOCDIGSEN_ORIGINAL=%%A
	SET CXALOCDIGSEN_ORIGINAL=%CXALOCDIGSEN_ORIGINAL:~0,1%
	IF "%CXALOCDIGSEN_ORIGINAL%"=="" (
		SET CXALOCDIGSEN_ORIGINAL=1
		)
	) ELSE (
		SET CXALOCDIGSEN_ORIGINAL=1
	)

	:: Cria arquivos SQL para restaurar
(
	ECHO UPDATE CONFIGPDV SET LOCDIGSEN = '!LOCDIGSEN_ORIGINAL!';
	ECHO EXIT;
) > "%TEMP_PATH%\Restaurar_cad.sql"

(
	ECHO UPDATE CAIXA SET CXALOCDIGSEN = '!CXALOCDIGSEN_ORIGINAL!';
	ECHO EXIT;
) > "%TEMP_PATH%\Restaurar_mov.sql"

	:: Executa os arquivos SQL
ECHO INPUT '%TEMP_PATH%\Restaurar_cad.sql'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%SYSPDV_CAD_PATH%" >> "%LOG_PATH%" 2>&1
	(ECHO [SUCESSO]) >> "%LOG_PATH%"
IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [ERRO]
	ECHO.
	ECHO      Ao Restaurar Biometria _cad!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO INI
)
ECHO INPUT '%TEMP_PATH%\Restaurar_mov.sql'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%SYSPDV_MOV_PATH%" >> "%LOG_PATH%" 2>&1
	(ECHO [SUCESSO]
	 ECHO. ) >> "%LOG_PATH%"
IF %ERRORLEVEL% NEQ 0 (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [ERRO]
	ECHO.
	ECHO      Ao Restaurar Biometria _mov!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO INI
)

ECHO.
ECHO   ==================================
ECHO.
ECHO               [SUCESSO]
ECHO.
ECHO          Biometria Restaurada!
ECHO.
ECHO   ==================================
ECHO.
START "" "%SYSPDV_EXE_PATH%" > NUL
TIMEOUT /T 5
IF EXIST "%TEMP_PATH%\Restaurar_cad.sql" DEL "%TEMP_PATH%\Restaurar_cad.sql"
IF EXIST "%TEMP_PATH%\Restaurar_mov.sql" DEL "%TEMP_PATH%\Restaurar_mov.sql"
IF EXIST "%TEMP_PATH%\Locdigsen_Original.txt" DEL "%TEMP_PATH%\Locdigsen_Original.txt"
IF EXIST "%TEMP_PATH%\Cxalocdigsen_Original.txt" DEL "%TEMP_PATH%\Cxalocdigsen_Original.txt"
CLS
GOTO END

:END
	:: Comando para excluir o próprio script
DEL "%~F0" /F /Q
EXIT