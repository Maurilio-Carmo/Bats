@ECHO OFF
COLOR 6
SETLOCAL ENABLEDELAYEDEXPANSION

SET ISC_USER=SYSDBA
SET ISC_PASSWORD=masterkey
SET SYSPDV_SRV_PATH=C:\SYSPDV\SYSPDV_SRV.FDB
SET SYSPDV_CAD_PATH=C:\SYSPDV\SYSPDV_CAD.FDB
SET SYSPDV_MOV_PATH=C:\SYSPDV\SYSPDV_MOV.FDB
SET TEMP_PATH=C:\SYSPDV\
SET LOG_PATH=%TEMP_PATH%\Log_WebServices.txt

	:: Verifica Caminho Temporario
IF NOT EXIST "%TEMP_PATH%" (
	MD "%TEMP_PATH%"
	ATTRIB +H "%TEMP_PATH%"
	)

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
ECHO        Escolha a Opcao da NFC-e!
ECHO.
ECHO             1 - Ativar
ECHO.
ECHO             2 - Desativar
ECHO.
ECHO.
ECHO               0 - Sair
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

	:: Processar a escolha do usuário
IF "%CHOOSE%"=="1" GOTO ATIVAR
IF "%CHOOSE%"=="2" GOTO DESATIVAR
IF "%CHOOSE%"=="0" GOTO END

	:: Ativa a NFC-e
:ATIVAR
	
	(
	ECHO UPDATE PROPRIO SET PRPNFCECFOP = '54050', PRPFUSHOR = '-03:00', PRPVERQRCODENFCE = '2.00'
	) >> %TEMP_PATH%\CONFIG_NFCE.SQL 

	(
	ECHO DELETE FROM WEBSERVICES; COMMIT;
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
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce/services/NfeAutorizacao?WSDL', 'NFEAUTORIZACAO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce/services/NfeRetAutorizacao?WSDL', 'NFERETAUTORIZACAO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce/services/NfeConsulta2?WSDL', 'NFECONSULTAPROTOCOLO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce/services/NfeInutilizacao2?WSDL', 'NFEINUTILIZACAO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce/services/NfeStatusServico2?WSDL', 'NFESTATUSSERVICO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce/services/CadConsultaCadastro2?WSDL', 'NFECONSULTACADASTRO_3.10', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce/services/RecepcaoEvento?WSDL', 'RECEPCAOEVENTO_1.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-QRCODE', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-CONSULTANFCE', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfce.sefaz.ce.gov.br/pages/ShowNFCe.html', 'URL-CONSULTANFCE_2.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeAutorizacao4?WSDL', 'NFEAUTORIZACAO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeRetAutorizacao4?WSDL', 'NFERETAUTORIZACAO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeConsultaProtocolo4?WSDL', 'NFECONSULTAPROTOCOLO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeInutilizacao4?WSDL', 'NFEINUTILIZACAO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeStatusServico4?WSDL', 'NFESTATUSSERVICO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/CadConsultaCadastro4?WSDL', 'NFECONSULTACADASTRO_3.10', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfceh.sefaz.ce.gov.br/nfce4/services/NFeRecepcaoEvento4?WSDL', 'RECEPCAOEVENTO_1.00', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html?...', 'URL-QRCODE', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html?...', 'URL-CONSULTANFCE', 'NFCE', 'H'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'http://nfceh.sefaz.ce.gov.br/pages/ShowNFCe.html?...', 'URL-CONSULTANFCE_2.00', 'NFCE', 'H'^); COMMIT;
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
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/CadConsultaCadastro4?WSDL', 'NFECONSULTACADASTRO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeAutorizacao4?WSDL', 'NFEAUTORIZACAO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeConsultaProtocolo4?WSDL', 'NFECONSULTAPROTOCOLO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeInutilizacao4?WSDL', 'NFEINUTILIZACAO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeRetAutorizacao4?WSDL', 'NFERETAUTORIZACAO_4.00', 'NFCE', 'P'^); COMMIT;
	ECHO INSERT INTO "WEBSERVICES" ^("WSUF", "WSENDERECO", "WSCHAVE", "WSDOCUMENTO", "WSAMBIENTE"^) VALUES ^('CE', 'https://nfce.sefaz.ce.gov.br/nfce4/services/NFeStatusServico4?WSDL', 'NFESTATUSSERVICO_4.00', 'NFCE', 'P'^); COMMIT;
	) >> %TEMP_PATH%\INSERT_WEBSERVICES.SQL

IF EXIST "%SYSPDV_SRV_PATH%" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                 [SRV]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                 [SRV]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%TEMP_PATH%\INSERT_WEBSERVICES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%SYSPDV_SRV_PATH%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)

IF EXIST "%SYSPDV_CAD_PATH%" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                 [CAD]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                 [CAD]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%TEMP_PATH%\INSERT_WEBSERVICES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%SYSPDV_CAD_PATH%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)

IF EXIST "%SYSPDV_MOV_PATH%" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                 [MOV]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                 [MOV]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%TEMP_PATH%\INSERT_WEBSERVICES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%SYSPDV_MOV_PATH%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)

:END
EXIT