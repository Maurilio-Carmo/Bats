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

:INI
	:: Verifica se existe a Rota
ECHO.
ECHO   ==================================
ECHO.
ECHO         Verificando a rota...
ECHO.
ECHO   ==================================
ECHO.
TIMEOUT /T 3
CLS
ROUTE PRINT 172.19.0.0 | FIND "172.19.0.0" >NUL && (
	GOTO MENU
	) || (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        Rota Nao Encontrada...
	ECHO.
	ECHO   ==================================
	ECHO.
	TIMEOUT /T 3
	CLS
	GOTO ADICIONAR
	)
	
:MENU
ECHO.
ECHO   ==================================
ECHO.
ECHO           Rota Encontrada...
ECHO.
ECHO              1 - Recriar
ECHO.
ECHO              2 - Testar
ECHO.
ECHO.
ECHO              0 - Sair
ECHO.
ECHO   ==================================
ECHO.
SET /P CHOOSE=" Digite a opcao: "
CLS

	:: Validação de entrada
IF NOT "%CHOOSE%"=="1" IF NOT "%CHOOSE%"=="2" IF NOT "%CHOOSE%"=="0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO      Por favor, escolha 1, 2 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MENU
	)
		
IF "%CHOOSE%"=="1" GOTO DELETAR
IF "%CHOOSE%"=="2" GOTO TESTAR
IF "%CHOOSE%"=="0" EXIT

:DELETAR
	:: Deltar Rota Existente
ECHO.
ECHO   ==================================
ECHO.
ECHO           Deletando Rota...
ECHO.
ECHO   ==================================
ECHO.
ROUTE DELETE 172.19.0.0
CLS

:ADICIONAR
	:: Perguta o IP da Rota
ECHO.
ECHO   ==================================
ECHO.
ECHO              ROTA MARTINS
ECHO.
ECHO   ==================================
ECHO.
SET /P IP_PATH=" Informe o IP: "
CLS
	
	:: A diciona a rota
ECHO.
ECHO   ==================================
ECHO.
ECHO           Adicionando Rota...
ECHO.
ECHO   ==================================
ECHO.
ROUTE ADD 172.19.0.0 MASK 255.255.0.0 %IP_PATH% -P
TIMEOUT /T 3
CLS
IF ERRORLEVEL 1 (
	CLS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                [ERRO]
	ECHO      Falha ao adicionar a rota...
	ECHO.
	ECHO   ==================================
	ECHO.
	GOTO END
)

:TESTAR
	:: Teste a Rota
ECHO.
ECHO   ==================================
ECHO.
ECHO       Testando conectividade...
ECHO.
ECHO   ==================================
ECHO.
PING 172.19.2.2 >NUL && (
	CLS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Conectividade bem-sucedida!
	ECHO.
	ECHO   ==================================
	ECHO.
	) || (
	CLS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                [ERRO]
	ECHO        Falha na conectividade...
	ECHO.
	ECHO   ==================================
	ECHO.
	)

:END
ECHO.
ECHO   ==================================
ECHO.
ECHO           Script Finalizado.
ECHO.
ECHO   ==================================
ECHO.
PAUSE