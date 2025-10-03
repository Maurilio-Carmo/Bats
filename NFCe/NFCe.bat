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

SET ISC_USER=SYSDBA
SET ISC_PASSWORD=masterkey
SET SYSPDV_SRV_PATH=C:\SYSPDV\SYSPDV_SRV.FDB
SET SYSPDV_CAD_PATH=C:\SYSPDV\SYSPDV_CAD.FDB
SET SYSPDV_MOV_PATH=C:\SYSPDV\SYSPDV_MOV.FDB
SET BAT_PATH=C:\SYSPDV\BAT
SET MIGR_ARQ=%BAT_PATH%\REQUISITOS.SQL
SET LOG_PATH=%BAT_PATH%\Log_Auto_Config.txt

	:: Verifica se o diretório existe
IF EXIST "%BAT_PATH%" (
    RD /S /Q "%BAT_PATH%"
)

	:: Cria o diretório
MD "%BAT_PATH%"

	:: Configura Caminho do Firebird
IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin" (
	SET FIREBIRD_PATH="C:\Program Files (x86)\Firebird\Firebird_2_5\bin"
) ELSE (
	SET FIREBIRD_PATH="C:\Program Files\Firebird\Firebird_2_5\bin"
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
ECHO     Deseja NFC-e para todos PDV's!
ECHO.
ECHO               1 - Sim
ECHO.
ECHO               2 - Nao
ECHO.
ECHO.
ECHO               0 - Sair
ECHO.
ECHO   ==================================
ECHO.
SET /P NFCE=" Digite a opcao: "
CLS

	:: Validação de entrada Menu Inicial
IF "%NFCE%" NEQ "1" IF "%NFCE%" NEQ "2" IF "%NFCE%" NEQ "0" (
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

	:: Processar a escolha do usuário
IF "%NFCE%"=="1" (
	SET "CXAESP=NFC"
	GOTO ATIVAR
)

IF "%NFCE%"=="2" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Mude manualmente para NFC!
	ECHO.
	ECHO       CADASTRO ^> CAIXA ^> CAIXA
	ECHO.
	ECHO        Emissor de Documento!
	ECHO.
	ECHO   ==================================
	ECHO.
	SET "CXAESP=CFE"
	PAUSE
	CLS
)

IF "%NFCE%"=="0" GOTO END

	:: Ativa a NFC-e
:ATIVAR

:CFOP
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO       Qual o CFOP para o NFC-e?
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P CFOP=" Digite o CFOP: "
	CLS

:ID_TOKEN
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        Qual o numero ID Token?
	ECHO.
	ECHO               1 ou 2
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P ID_TOKEN=" Digite o ID: "
	CLS
	
	IF "%ID_TOKEN%" NEQ "1" IF "%ID_TOKEN%" NEQ "2" (
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO             Opcao invalida!
		ECHO      Por favor, escolha 1 ou 2!
		ECHO.
		ECHO   ==================================
		ECHO.
		PAUSE
		CLS
		GOTO ID_TOKEN
	)

:CSC_TOKEN
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           Qual o CSC Token?
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P CSC_TOKEN=" Digite o CSC: "
	CLS

		:: Resultado
	ECHO.
	ECHO   ========================================
	ECHO.
	ECHO                [CFOP - %CFOP%]
	ECHO.
	ECHO                [ID Token - %ID_TOKEN%]
	ECHO.
	ECHO                 [CSC Token]
	ECHO.
	ECHO    [%CSC_TOKEN%]
	ECHO.
	ECHO   ========================================
	ECHO.
	TIMEOUT /T 2
	CLS
	(
		ECHO.
		ECHO   ========================================
		ECHO.
		ECHO                [CFOP - %CFOP%]
		ECHO.
		ECHO                [ID Token - %ID_TOKEN%]
		ECHO.
		ECHO                 [CSC Token]
		ECHO.
		ECHO    [%CSC_TOKEN%]
		ECHO.
		ECHO   ========================================
		ECHO.
	) >> "%LOG_PATH%"

:SERVER
	:: Verifica SGBD do Server
FOR /F "TOKENS=2*" %%A IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432NODE\SYSPDV_SERVER\UNICONNECTION" /V "PROVIDERNAME" ^| MORE') DO SET SGBD_SERVER=%%B

	:: Verificar IP do Server
FOR /F "TOKENS=3" %%A IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432NODE\SYSPDV_SERVER\UNICONNECTION" /V "SERVER" ^| MORE') DO SET IP_SERVER=%%A

	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [SERVER]
	ECHO.
	ECHO             [!SGBD_SERVER!]
	ECHO.
	ECHO             [!IP_SERVER!]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO               [SERVER]
		ECHO.
		ECHO             [!SGBD_SERVER!]
		ECHO.
		ECHO             [!IP_SERVER!]
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> "%LOG_PATH%"
	TIMEOUT /T 2
	CLS

	:: Gera arquivo para importacao
IF "!SGBD_SERVER!"=="InterBase" (
	ECHO SET HEADING OFF;
	ECHO.
	ECHO OUTPUT "%BAT_PATH%\CONFIG_SRV.SQL";
	ECHO SELECT 
	ECHO 	'UPDATE PROPRIO SET ' ^|^| 
	ECHO 	'PRPNFCECFOP = ''' ^|^| SUBSTRING^(CAST^('%CFOP%' AS VARCHAR^(5^)^) ^|^| '00000' FROM 1 FOR 5^) ^|^| ''', ' ^|^| 
	ECHO 	'PRPFUSHOR = ''-03:00'', ' ^|^| 
	ECHO 	'PRPVERQRCODENFCE = ''2.00'', ' ^|^| 
	ECHO 	'PRPIDTOKENNFCE = ''' ^|^| '%ID_TOKEN%'  ^|^| ''', ' ^|^| 
	ECHO 	'PRPTOKENNFCE = ''' ^|^| TRIM^('%CSC_TOKEN%'^) ^|^| '''; COMMIT;' 
	ECHO FROM RDB$DATABASE;
	ECHO.
	ECHO OUTPUT "%BAT_PATH%\CONFIG_SRV.SQL";
	ECHO SELECT
	ECHO 	'UPDATE TRIBUTACAO SET ' ^|^|
	ECHO 	'TRBCFOP = ''' ^|^| SUBSTRING^(CAST^('%CFOP%' AS VARCHAR^(5^)^) ^|^| '00000' FROM 1 FOR 5^) ^|^| ''' ' ^|^| 
	ECHO 	'WHERE TRBTABBCFE = ''60''' ^|^| '; COMMIT;'
	ECHO FROM TRIBUTACAO
	ECHO 	WHERE TRBTABBCFE = '60';
	ECHO.
	ECHO OUTPUT "%BAT_PATH%\CONFIG_SRV.SQL";
	ECHO SELECT 
	ECHO 	'INSERT INTO SERIE_NOTA_FISCAL ^(SERTIP, SERDATCAD, SERNUMINI, SERNUMFIN, SERNUMATU, SERPERALT, SERMODNOTA, SERIDMODNOT, SERSTA^) VALUES ^(' ^|^| 
	ECHO 	'''' ^|^| REPLACE^(CXANUM, '0', ''^) ^|^| '''' ^|^| ', ' ^|^| 
	ECHO 	'''' ^|^| CURRENT_TIMESTAMP ^|^| '''' ^|^| ', ' ^|^| 
	ECHO 	'''0000000001''' ^|^| ', ' ^|^| 
	ECHO 	'''9999999999''' ^|^| ', ' ^|^| 
	ECHO 	'''0000000000''' ^|^| ', ' ^|^| 
	ECHO 	'''N''' ^|^| ', ' ^|^| 
	ECHO 	'''NFCe''' ^|^| ', ' ^|^| 
	ECHO 	'27' ^|^| ', ' ^|^| 
	ECHO 	'''A''' ^|^| 
	ECHO 	'^); COMMIT;'
	ECHO FROM CAIXA C
	ECHO 	WHERE NOT EXISTS
	ECHO 		^(SELECT 1 FROM SERIE_NOTA_FISCAL S
	ECHO 		WHERE S.SERTIP = REPLACE^(C.CXANUM, '0', ''^)
	ECHO 			AND SERMODNOTA = 'NFCe'^);
	ECHO.
	ECHO OUTPUT "%BAT_PATH%\CONFIG_SRV.SQL";
	ECHO SELECT 
	ECHO 	'UPDATE CAIXA SET ' ^|^|
	ECHO 	'CXAESP = ''%CXAESP%'', CXANFCESER = ''' ^|^| REPLACE^(CXANUM, '0', ''^) ^|^|
	ECHO 	''' WHERE CXANUM = ''' ^|^| CXANUM ^|^|
	ECHO 	'''; COMMIT;'
	ECHO FROM CAIXA;
	ECHO.
	ECHO OUTPUT "%BAT_PATH%\IP_CAIXAS.TXT";
	ECHO SELECT 
	ECHO 	CXANUM,
	ECHO 	REPLACE^(REPLACE^(TRIM^(CXANOMMAQ^), ':', ''^), 'C', ''^)  
	ECHO FROM CAIXA;
	) > "%MIGR_ARQ%"

IF "!SGBD_SERVER!"=="SQL Server" (
	ECHO SET NOCOUNT ON;
	ECHO.
	ECHO SELECT 
	ECHO 	'UPDATE PROPRIO SET ' + 
	ECHO 	'PRPNFCECFOP = ''' + SUBSTRING^(CAST^('%CFOP%' AS VARCHAR^(5^)^) + '00000', 1, 5^) + ''', ' + 
	ECHO 	'PRPFUSHOR = ''-03:00'', ' + 
	ECHO 	'PRPVERQRCODENFCE = ''2.00'', ' + 
	ECHO 	'PRPIDTOKENNFCE = ''' + '%ID_TOKEN%'  + ''', ' + 
	ECHO 	'PRPTOKENNFCE = ''' + TRIM^('%CSC_TOKEN%'^) + ''';' 
	ECHO FROM PROPRIO;
	ECHO.
	ECHO SELECT
	ECHO 	'UPDATE TRIBUTACAO SET ' +
	ECHO 	'TRBCFOP = ''' + SUBSTRING^(CAST^('%CFOP%' AS VARCHAR^(5^)^) + '00000', 1, 5^) + ''' ' + 
	ECHO 	'WHERE TRBTABBCFE = ''60''' + ';'
	ECHO FROM TRIBUTACAO
	ECHO 	WHERE TRBTABBCFE = '60';
	ECHO.
	ECHO SELECT 
	ECHO 	'INSERT INTO SERIE_NOTA_FISCAL ^(SERTIP, SERDATCAD, SERNUMINI, SERNUMFIN, SERNUMATU, SERPERALT, SERMODNOTA, SERIDMODNOT, SERSTA^) VALUES ^(' + 
	ECHO 	'''' + REPLACE^(CXANUM, '0', ''^) + '''' + ', ' + 
	ECHO 	'''' + CAST^(CURRENT_TIMESTAMP AS VARCHAR^(30^)^) + '''' + ', ' + 
	ECHO 	'''0000000001''' + ', ' + 
	ECHO 	'''9999999999''' + ', ' + 
	ECHO 	'''0000000000''' + ', ' + 
	ECHO 	'''N''' + ', ' + 
	ECHO 	'''NFCe''' + ', ' + 
	ECHO 	'27' + ', ' + 
	ECHO 	'''A''' + 
	ECHO 	'^);'
	ECHO FROM CAIXA C
	ECHO 	WHERE NOT EXISTS
	ECHO 		^(SELECT 1 FROM SERIE_NOTA_FISCAL S
	ECHO 		WHERE S.SERTIP = REPLACE^(C.CXANUM, '0', ''^)
	ECHO 			AND SERMODNOTA = 'NFCe'^);
	ECHO.
	ECHO SELECT 
	ECHO 	'UPDATE CAIXA SET ' +
	ECHO 	'CXAESP = ''NFC'', CXANFCESER = ''' + REPLACE^(CXANUM, '0', ''^) +
	ECHO 	''' WHERE CXANUM = ''' + CXANUM +
	ECHO 	''';'
	ECHO FROM CAIXA;
	ECHO.
	ECHO GO
	) > "%MIGR_ARQ%"

	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [EXPORTANDO ALTERACOES]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [EXPORTANDO ALTERACOES]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	IF "!SGBD_SERVER!"=="InterBase" (
	ECHO INPUT '%MIGR_ARQ%'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% !IP_SERVER!:%SYSPDV_SRV_PATH% >> "%LOG_PATH%" 2>&1
	) ELSE (
		SQLCMD -s !IP_SERVER! -d syspdv -e -i "%MIGR_ARQ%" -o "%BAT_PATH%\CONFIG_SRV.SQL" -h -1 -s "," >> "%LOG_PATH%" 2>&1
		SQLCMD -s !IP_SERVER! -d syspdv -e -Q "SET NOCOUNT ON; SELECT CXANUM, REPLACE(REPLACE(CXANOMMAQ, ':', ''), 'C', '') FROM CAIXA;" -o "%BAT_PATH%\IP_CAIXAS.TXT" -h -1 -s " " >> "%LOG_PATH%" 2>&1
		(ECHO GO) >> "%BAT_PATH%\CONFIG_SRV.SQL"
	)
	TIMEOUT /T 2
	CLS
	)

	(
	ECHO DELETE FROM WEBSERVICES; COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx', 'RECEPCAOEVENTO_1.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl', 'NFERECEPCAO_2.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl', 'NFERETRECEPCAO_2.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx', 'NFEINUTILIZACAO_2.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx', 'NFEINUTILIZACAO_3.10', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx', 'NFECONSULTAPROTOCOLO_2.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx', 'NFECONSULTAPROTOCOLO_3.10', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx', 'NFESTATUSSERVICO_2.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx', 'NFESTATUSSERVICO_3.10', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx', 'NFECONSULTACADASTRO_2.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl', 'NFECONSULTACADASTRO_3.10', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl', 'NFEDOWNLOADNF_1.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx', 'NFEAUTORIZACAO_3.10', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx', 'NFERETAUTORIZACAO_3.10', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx', 'NFEAUTORIZACAO_4.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx', 'NFERETAUTORIZACAO_4.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx', 'NFEINUTILIZACAO_4.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx', 'NFECONSULTAPROTOCOLO_4.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx', 'NFESTATUSSERVICO_4.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx', 'RECEPCAOEVENTO_4.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx', 'NFECONSULTACADASTRO_4.00', 'NFE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx', 'RECEPCAOEVENTO_1.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl', 'NFERECEPCAO_2.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl', 'NFERETRECEPCAO_2.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx', 'NFEINUTILIZACAO_2.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx', 'NFEINUTILIZACAO_3.10', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx', 'NFECONSULTAPROTOCOLO_2.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx', 'NFECONSULTAPROTOCOLO_3.10', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx', 'NFESTATUSSERVICO_2.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx', 'NFESTATUSSERVICO_3.10', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://cad-homologacao.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx', 'NFECONSULTACADASTRO_2.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfeh.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl', 'NFECONSULTACADASTRO_3.10', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl', 'NFEDOWNLOADNF_1.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx', 'NFEAUTORIZACAO_3.10', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx', 'NFERETAUTORIZACAO_3.10', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx', 'NFEINUTILIZACAO_4.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx', 'NFECONSULTAPROTOCOLO_4.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx', 'NFESTATUSSERVICO_4.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx', 'RECEPCAOEVENTO_4.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx', 'NFEAUTORIZACAO_4.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx', 'NFERETAUTORIZACAO_4.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://cad-homologacao.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx', 'NFECONSULTACADASTRO_4.00', 'NFE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeAutorizacao4?WSDL', 'NFEAUTORIZACAO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeRetAutorizacao4?WSDL', 'NFERETAUTORIZACAO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeConsultaProtocolo4?WSDL', 'NFECONSULTAPROTOCOLO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeInutilizacao4?WSDL', 'NFEINUTILIZACAO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeStatusServico4?WSDL', 'NFESTATUSSERVICO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/CadConsultaCadastro4?WSDL', 'NFECONSULTACADASTRO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx', 'NFEAUTORIZACAO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx', 'NFERETAUTORIZACAO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx', 'NFECONSULTAPROTOCOLO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx', 'NFEINUTILIZACAO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx', 'NFESTATUSSERVICO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx', 'RECEPCAOEVENTO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/CadConsultaCadastro4?WSDL', 'NFECONSULTACADASTRO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeRecepcaoEvento4?WSDL', 'RECEPCAOEVENTO_1.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-QRCODE', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-CONSULTANFCE', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-CONSULTANFCE_2.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeAutorizacao4?WSDL', 'NFEAUTORIZACAO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeRetAutorizacao4?WSDL', 'NFERETAUTORIZACAO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeConsultaProtocolo4?WSDL', 'NFECONSULTAPROTOCOLO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeInutilizacao4?WSDL', 'NFEINUTILIZACAO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeStatusServico4?WSDL', 'NFESTATUSSERVICO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/CadConsultaCadastro4?WSDL', 'NFECONSULTACADASTRO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeRecepcaoEvento4?WSDL', 'RECEPCAOEVENTO_1.00', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-QRCODE', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'www.sefaz.ce.gov.br/nfce/consulta', 'URL-CONSULTANFCE', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'www.sefaz.ce.gov.br/nfce/consulta', 'URL-CONSULTANFCE_2.00', 'NFCE', 'H'^); COMMIT;
	) > %BAT_PATH%\INSERT_WEBSERVICES.SQL

IF "!SGBD_SERVER!"=="SQL Server" (
	ECHO SET NOCOUNT ON;
	ECHO DELETE FROM WEBSERVICES;
	ECHO GO
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx', 'RECEPCAOEVENTO_1.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl', 'NFERECEPCAO_2.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl', 'NFERETRECEPCAO_2.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx', 'NFEINUTILIZACAO_2.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx', 'NFEINUTILIZACAO_3.10', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx', 'NFECONSULTAPROTOCOLO_2.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx', 'NFECONSULTAPROTOCOLO_3.10', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx', 'NFESTATUSSERVICO_2.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx', 'NFESTATUSSERVICO_3.10', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx', 'NFECONSULTACADASTRO_2.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl', 'NFECONSULTACADASTRO_3.10', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl', 'NFEDOWNLOADNF_1.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx', 'NFEAUTORIZACAO_3.10', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx', 'NFERETAUTORIZACAO_3.10', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx', 'NFEAUTORIZACAO_4.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx', 'NFERETAUTORIZACAO_4.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx', 'NFEINUTILIZACAO_4.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx', 'NFECONSULTAPROTOCOLO_4.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx', 'NFESTATUSSERVICO_4.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx', 'RECEPCAOEVENTO_4.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://cad.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx', 'NFECONSULTACADASTRO_4.00', 'NFE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento.asmx', 'RECEPCAOEVENTO_1.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRecepcao2?wsdl', 'NFERECEPCAO_2.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeRetRecepcao2?wsdl', 'NFERETRECEPCAO_2.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx', 'NFEINUTILIZACAO_2.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao2.asmx', 'NFEINUTILIZACAO_3.10', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx', 'NFECONSULTAPROTOCOLO_2.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta2.asmx', 'NFECONSULTAPROTOCOLO_3.10', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx', 'NFESTATUSSERVICO_2.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico2.asmx', 'NFESTATUSSERVICO_3.10', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://cad-homologacao.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro2.asmx', 'NFECONSULTACADASTRO_2.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfeh.sefaz.ce.gov.br/nfe2/services/CadConsultaCadastro2?wsdl', 'NFECONSULTACADASTRO_3.10', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfeh.sefaz.ce.gov.br/nfe2/services/NfeDownloadNF?wsdl', 'NFEDOWNLOADNF_1.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao.asmx', 'NFEAUTORIZACAO_3.10', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao.asmx', 'NFERETAUTORIZACAO_3.10', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx', 'NFEINUTILIZACAO_4.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx', 'NFECONSULTAPROTOCOLO_4.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx', 'NFESTATUSSERVICO_4.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx', 'RECEPCAOEVENTO_4.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx', 'NFEAUTORIZACAO_4.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfe-homologacao.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx', 'NFERETAUTORIZACAO_4.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://cad-homologacao.svrs.rs.gov.br/ws/cadconsultacadastro/cadconsultacadastro4.asmx', 'NFECONSULTACADASTRO_4.00', 'NFE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeAutorizacao4?WSDL', 'NFEAUTORIZACAO_3.10', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeRetAutorizacao4?WSDL', 'NFERETAUTORIZACAO_3.10', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeConsultaProtocolo4?WSDL', 'NFECONSULTAPROTOCOLO_3.10', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeInutilizacao4?WSDL', 'NFEINUTILIZACAO_3.10', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeStatusServico4?WSDL', 'NFESTATUSSERVICO_3.10', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/CadConsultaCadastro4?WSDL', 'NFECONSULTACADASTRO_3.10', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/NfeAutorizacao/NFeAutorizacao4.asmx', 'NFEAUTORIZACAO_4.00', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/NfeRetAutorizacao/NFeRetAutorizacao4.asmx', 'NFERETAUTORIZACAO_4.00', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/NfeConsulta/NfeConsulta4.asmx', 'NFECONSULTAPROTOCOLO_4.00', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/nfeinutilizacao/nfeinutilizacao4.asmx', 'NFEINUTILIZACAO_4.00', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/NfeStatusServico/NfeStatusServico4.asmx', 'NFESTATUSSERVICO_4.00', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.svrs.rs.gov.br/ws/recepcaoevento/recepcaoevento4.asmx', 'RECEPCAOEVENTO_4.00', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/CadConsultaCadastro4?WSDL', 'NFECONSULTACADASTRO_4.00', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeRecepcaoEvento4?WSDL', 'RECEPCAOEVENTO_1.00', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-QRCODE', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-CONSULTANFCE', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-CONSULTANFCE_2.00', 'NFCE', 'P'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeAutorizacao4?WSDL', 'NFEAUTORIZACAO_3.10', 'NFCE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeRetAutorizacao4?WSDL', 'NFERETAUTORIZACAO_3.10', 'NFCE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeConsultaProtocolo4?WSDL', 'NFECONSULTAPROTOCOLO_3.10', 'NFCE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeInutilizacao4?WSDL', 'NFEINUTILIZACAO_3.10', 'NFCE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeStatusServico4?WSDL', 'NFESTATUSSERVICO_3.10', 'NFCE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/CadConsultaCadastro4?WSDL', 'NFECONSULTACADASTRO_3.10', 'NFCE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeRecepcaoEvento4?WSDL', 'RECEPCAOEVENTO_1.00', 'NFCE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-QRCODE', 'NFCE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'www.sefaz.ce.gov.br/nfce/consulta', 'URL-CONSULTANFCE', 'NFCE', 'H'^);
	ECHO INSERT INTO [WEBSERVICES] ^([WSUF], [WSENDERECO], [WSCHAVE], [WSDOCUMENTO], [WSAMBIENTE]^) VALUES ^('CE', 'www.sefaz.ce.gov.br/nfce/consulta', 'URL-CONSULTANFCE_2.00', 'NFCE', 'H'^);
	) > %BAT_PATH%\INSERT_WEBSERVICES_SQL.SQL

		:: Inicia Alterações no Banco do Servidor
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [IMPORTANDO ALTERACOES]
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO   Processando...
	(
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO        [IMPORTANDO ALTERACOES]
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> "%LOG_PATH%"
	IF "!SGBD_SERVER!"=="InterBase" (
		ECHO INPUT '%BAT_PATH%\CONFIG_SRV.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% !IP_SERVER!:%SYSPDV_SRV_PATH% >> "%LOG_PATH%" 2>&1 
	) ELSE (
		SQLCMD -s !IP_SERVER! -d syspdv -e -i %BAT_PATH%\CONFIG_SRV.SQL >> "%LOG_PATH%" 2>&1 
	)
	TIMEOUT /T 2
	CLS

	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO          [WEB_SERVICES SRV]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO          [WEB_SERVICES SRV]
		ECHO.
		ECHO   ==================================
		ECHO.
	)  >> "%LOG_PATH%"
	IF "!SGBD_SERVER!"=="InterBase" (
		ECHO INPUT '%BAT_PATH%\INSERT_WEBSERVICES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% !IP_SERVER!:%SYSPDV_SRV_PATH% >> "%LOG_PATH%" 2>&1
	) ELSE (
		SQLCMD -s !IP_SERVER! -d syspdv -e -i %BAT_PATH%\INSERT_WEBSERVICES_SQL.SQL >> "%LOG_PATH%" 2>&1 
	)
	TIMEOUT /T 2
	CLS


	:: Verifica se o arquivo com os IPs existe
IF NOT EXIST %BAT_PATH%\IP_CAIXAS.TXT (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO    Arquivo IP_CAIXAS nao encontrado! 
	ECHO.
	ECHO   ==================================
	ECHO.
	(
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO    Arquivo IP_CAIXAS nao encontrado! 
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> %LOG_PATH%
	PAUSE
	GOTO END
)

	:: Configura leitura do Arquivo de IP's
IF "!SGBD_SERVER!"=="InterBase" (
	SET LINHA=1
) ELSE (
	SET LINHA=0
)

	:: Percorre cada linha do arquivo e executa o SQL no Firebird remoto
FOR /F "TOKENS=1,2 DELIMS= " %%I IN (%BAT_PATH%\IP_CAIXAS.TXT) DO (
    SET /A LINHA+=1
    IF !LINHA! GTR 1 (
        SET "CAIXA=%%I"
        SET "IP=%%J"

	:: Executa a alteração remota via ISQL no CAD
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [WEB_SERVICES CAD]
	ECHO.
	ECHO         Alterando CAIXA - !CAIXA!
	ECHO.
	ECHO            [!IP!]
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO   Processando...
	(
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO           [WEB_SERVICES CAD]
		ECHO.
		ECHO         Alterando CAIXA - !CAIXA!
		ECHO.
		ECHO            [!IP!]
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> %LOG_PATH%
	ECHO INPUT '%BAT_PATH%\INSERT_WEBSERVICES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% !IP!:%SYSPDV_CAD_PATH% >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS	

	:: Executa a alteração remota via ISQL no MOV
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [WEB_SERVICES MOV]
	ECHO.
	ECHO         Alterando CAIXA - !CAIXA!
	ECHO.
	ECHO            [!IP!]
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO   Processando...
	(
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO           [WEB_SERVICES MOV]
		ECHO.
		ECHO         Alterando CAIXA - !CAIXA!
		ECHO.
		ECHO            [!IP!]
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> %LOG_PATH%
	ECHO INPUT '%BAT_PATH%\INSERT_WEBSERVICES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% !IP!:%SYSPDV_MOV_PATH% >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
)

:END

	START %LOG_PATH%

EXIT