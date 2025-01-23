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

	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Script para Reinstalar Servico
	ECHO.
	ECHO           ( SysPDVService )
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	
	:: PARANDO SERVIÇOS DO SYSPDV
ECHO.
ECHO   ==================================
ECHO.
ECHO         PARANDO OS SERVICOS...
ECHO.
ECHO   ==================================
ECHO.
TASKKILL /f /im SysPDVService.exe > NUL 2>&1
TIMEOUT /T 2
CLS

	:: DELETAR O SERVIÇO
ECHO.
ECHO   ==================================
ECHO.
ECHO         DELETANDO O SERVICO...
ECHO.
ECHO   ==================================
ECHO.
SC QUERY ServicoSysPDV > NUL 2>&1
IF ERRORLEVEL 1 (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO         Servico nao encontrado. 
	ECHO             Pulando etapa...
	ECHO.
	ECHO   ==================================
	ECHO.
	) ELSE (
	SC DELETE ServicoSysPDV > NUL 2>&1
)
TIMEOUT /T 2
CLS

	:: NAVEGAR ATÉ A PASTA DO SERVIÇO

CD \SYSPDV\SERVICO

	:: INSTALAR O SERVIÇO NOVAMENTE
ECHO.
ECHO   ==================================
ECHO.
ECHO         INSTALANDO O SERVICO...
ECHO.
ECHO   ==================================
ECHO.
SysPDVService.exe /INSTALL
CLS

	:: INICIAR O SERVIÇO
ECHO.
ECHO   ==================================
ECHO.
ECHO         INICIANDO O SERVICO...
ECHO.
ECHO   ==================================
ECHO.
SC START ServicoSysPDV > NUL 2>&1
TIMEOUT /T 2
CLS

	:: MENSAGEM DE CONCLUSÃO
ECHO.
ECHO   ===================================
ECHO.
ECHO    OPERACAO CONCLUIDA COM SUCESSO...
ECHO.
ECHO   ===================================
ECHO.
PAUSE

:END
EXIT