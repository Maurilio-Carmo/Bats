@ECHO OFF
COLOR 6
SETLOCAL ENABLEDELAYEDEXPANSION

	:: Definindo o caminho dos bancos de dados em variáveis
SET DB_PATH_SYSPDV=C:\SYSPDV\
SET DB_PATH_MIDI_4=C:\MIDIPDV\
SET DB_PATH_MIDI_5=C:\MIDI\

	:: Definindo Usuario e Senha
SET ISC_USER=SYSDBA
SET ISC_PASSWORD=masterkey


:INI

CLS
		:: Menu Inicial
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO     Escolha o Gerenciador do Banco!
	ECHO.
	ECHO        1 - Firebird 2.5
	ECHO.
	ECHO        2 - SQL Server
	ECHO.
	ECHO.
	ECHO        0 - Sair
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P CHOOSE=" Digite a opcao: "
	CLS

		:: Validação de entrada Menu Inicial
	IF "%CHOOSE%" NEQ "1" IF "%CHOOSE%" NEQ "2" IF "%CHOOSE%" NEQ "0" (
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO             Opcao invalida!
		ECHO     Por favor, escolha 1, 2 ou 0!
		ECHO.
		ECHO   ==================================
		ECHO.
		PAUSE
		CLS
		GOTO INI
	)

		:: Escolher Firebird 64 ou 86 automaticamente
	IF %CHOOSE% EQU 1 (
		IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin" (
			SET FIREBIRD_PATH="C:\Program Files (x86)\Firebird\Firebird_2_5\bin"
		) ELSE (
			SET FIREBIRD_PATH="C:\Program Files\Firebird\Firebird_2_5\bin"
		)
		GOTO SISTEMA_FIREBIRD_MENU
	)

	IF %CHOOSE% EQU 2 (
		GOTO SQLSERVER
	)

	IF %CHOOSE% EQU 0 (
		GOTO END
	)

:SISTEMA_FIREBIRD_MENU
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO       Escolha o Sistema de Venda
	ECHO.
	ECHO          1 - SysPDV
	ECHO.
	ECHO          2 - Midi 4
	ECHO.
	ECHO          3 - Midi 5
	ECHO.
	ECHO.
	ECHO          0 - Voltar
	ECHO.
	ECHO   ==================================
	ECHO.

	SET /P DB_CHOICE= Digite a opcao: 
	CLS

	IF "%DB_CHOICE%" NEQ "1" IF "%DB_CHOICE%" NEQ "2" IF "%DB_CHOICE%" NEQ "3" IF "%DB_CHOICE%" NEQ "0" (
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO             Opcao invalida!
		ECHO     Por favor, escolha 1, 2, 3 ou 0!
		ECHO.
		ECHO   ==================================
		ECHO.
		PAUSE
		CLS
		GOTO SISTEMA_FIREBIRD_MENU
)

	IF %DB_CHOICE% EQU 1 SET SISTEM_PATH=%DB_PATH_SYSPDV%SYSPDV
	IF %DB_CHOICE% EQU 2 SET SISTEM_PATH=%DB_PATH_MIDI_4%MIDI
	IF %DB_CHOICE% EQU 3 SET SISTEM_PATH=%DB_PATH_MIDI_5%MIDI

	IF %DB_CHOICE% EQU 0 GOTO INI

:BANCO_FIREBIRD_MENU
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO       Escolha o Banco de Dados
	ECHO.
	ECHO          1 - SRV
	ECHO.
	ECHO          2 - CAD
	ECHO.
	ECHO          3 - MOV
	ECHO.
	ECHO.
	ECHO          0 - Voltar
	ECHO.
	ECHO   ==================================
	ECHO.

	SET /P DB_CHOICE= Digite a opcao: 
	CLS

	IF "%DB_CHOICE%" NEQ "1" IF "%DB_CHOICE%" NEQ "2" IF "%DB_CHOICE%" NEQ "3" IF "%DB_CHOICE%" NEQ "0" (
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO             Opcao invalida!
		ECHO     Por favor, escolha 1, 2, 3 ou 0!
		ECHO.
		ECHO   ==================================
		ECHO.
		PAUSE
		CLS
		GOTO BANCO_FIREBIRD_MENU
)

	IF %DB_CHOICE% EQU 1 SET DB_PATH=%SISTEM_PATH%_SRV.FDB
	IF %DB_CHOICE% EQU 2 SET DB_PATH=%SISTEM_PATH%_CAD.FDB
	IF %DB_CHOICE% EQU 3 SET DB_PATH=%SISTEM_PATH%_MOV.FDB

	IF %DB_CHOICE% EQU 0 GOTO INI

	CD %FIREBIRD_PATH%
	CLS
	ISQL -user %ISC_USER% -password %ISC_PASSWORD% %DB_PATH%
	GOTO INI

:SQLSERVER
	CLS
	SQLCMD -s localhost -d syspdv -e 
	GOTO INI

:END
	EXIT
