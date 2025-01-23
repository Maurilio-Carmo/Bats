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

SET DB_SYSPDV=C:\SYSPDV\SYSPDV_SRV.FDB
SET DB_MIDIPDV=C:\MIDI\MIDI_SRV.FDB
SET ISC_USER=SYSDBA
SET ISC_PASSWORD=masterkey
SET MIGR_PATH=C:\MIGR
SET EXP_PATH=%MIGR_PATH%\EXP
SET MIGR_ARQ=%MIGR_PATH%\Arquivo_Exportacao.sql
SET LOG_PATH=%MIGR_PATH%\Log_Migracao.txt

	:: Configura Caminho do Firebird
IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin" (
	SET FIREBIRD_PATH="C:\Program Files (x86)\Firebird\Firebird_2_5\bin"
) ELSE (
	SET FIREBIRD_PATH="C:\Program Files\Firebird\Firebird_2_5\bin"
)

CD /D %FIREBIRD_PATH%

	:: Validação da pasta MIGR
IF EXIST "%MIGR_PATH%" (
	GOTO DIRETORIO 
	) ELSE (
	MKDIR "%EXP_PATH%"
	GOTO INI
	)
	
:DIRETORIO
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO       Deseja Limpar Diretorio!
	ECHO.
	ECHO               1 - Sim
	ECHO.
	ECHO               0 - Nao
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P DIRETORIO=" Digite a opcao: "
	CLS

	
			:: Validação de entrada
	IF "%DIRETORIO%" NEQ "1" IF "%DIRETORIO%" NEQ "0" (
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO             Opcao invalida!
		ECHO       Por favor, escolha 1 ou 0!
		ECHO.
		ECHO   ==================================
		ECHO.
		PAUSE
		CLS
		GOTO DIRETORIO
		)

	IF "%DIRETORIO%"=="1" (
		RMDIR /S /Q "%MIGR_PATH%"
		MKDIR "%EXP_PATH%"
		)
	IF "%DIRETORIO%"=="0" GOTO INI

:INI
	:: Menu Indenticar Sistema de Origem
ECHO.
ECHO   ==================================
ECHO.
ECHO       Qual sistema deseja migrar:
ECHO.
ECHO          1 - SysPDV to MIDI_5
ECHO.
ECHO          2 - MIDI_5 to SysPDV
ECHO.
ECHO.
ECHO               0 - Sair
ECHO.
ECHO   ==================================
ECHO.
SET /P SYSTEM=" Digite a opcao: "
CLS

	:: Validação de entrada Menu Inicial
IF "%SYSTEM%" NEQ "1" IF "%SYSTEM%" NEQ "2" IF "%SYSTEM%" NEQ "0" (
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

IF "%SYSTEM%"=="1" GOTO SYS_TO_MIDI_INI
IF "%SYSTEM%"=="2" GOTO MIDI_TO_SYS_INI
IF "%SYSTEM%"=="0" GOTO END

:SYS_TO_MIDI_INI

(
	ECHO SET HEADING OFF;
	ECHO.
) > "%MIGR_ARQ%"

:SYS_EMPRESA

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar PROPRIO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_EMPRESA=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_EMPRESA%" NEQ "1" IF "%SYS_EMPRESA%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_EMPRESA
)

IF "%SYS_EMPRESA%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_EMPRESA.SQL";
	ECHO SELECT
	ECHO 	'UPDATE EMPRESA SET ' ^|^|
	ECHO 	'CIDADE = ''' ^|^| PRPMUN ^|^| ''', ' ^|^|
	ECHO 	'COMPLEMENTO = ''' ^|^| '' ^|^| ''', ' ^|^|
	ECHO 	'NUMERO = ' ^|^| TRIM^(PRPNUM^) ^|^| ', ' ^|^|
	ECHO 	'STATE = ''' ^|^| PRPUF ^|^| ''', ' ^|^|
	ECHO 	'LOGRADOURO = ''' ^|^| PRPEND ^|^| ''', ' ^|^|
	ECHO 	'LOGRADOURO_TIPO = ''' ^|^| 'R' ^|^| ''', ' ^|^|
	ECHO 	'CEP = ''' ^|^| PRPCEP ^|^| ''', ' ^|^|
	ECHO 	'BAIRRO = ''' ^|^| PRPBAI ^|^| ''', ' ^|^|
	ECHO 	'RAZAOSOCIAL = ''' ^|^| PRPDES ^|^| ''', ' ^|^|
	ECHO 	'DOCUMENTO = ''' ^|^| PRPCGC ^|^| ''', ' ^|^|
	ECHO 	'NOMEFANTASIA = ''' ^|^| COALESCE^(PRPFAN, PRPDES^) ^|^| ''', ' ^|^|
	ECHO 	'TIPOPESSOA = ' ^|^| IIF^(PRPPFPJ = 'F', '1', '2'^) ^|^| ', ' ^|^|
	ECHO 	'TELEFONE = ''' ^|^| PRPTEL ^|^| ''', ' ^|^|
	ECHO 	'TELEFONE2 = ''' ^|^| PRPFAX ^|^| ''', ' ^|^|
	ECHO 	'LICENCA = ''' ^|^| '' ^|^| ''', ' ^|^|
	ECHO 	'VERSAO = ' ^|^| 'NULL' ^|^| ', ' ^|^|
	ECHO 	'ULTIMA_ABERTURA = ''' ^|^| CURRENT_DATE ^|^| ''' ' ^|^|
	ECHO 	'WHERE ^(CODIGO = ''' ^|^| '0001' ^|^| '''^);' ^|^| ' COMMIT;'
	ECHO FROM PROPRIO;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_EMPRESA%"=="0" GOTO SYS_FUNCIONARIO

:SYS_FUNCIONARIO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar FUNCIONARIO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_FUNCIONARIO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_FUNCIONARIO%" NEQ "1" IF "%SYS_FUNCIONARIO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_FUNCIONARIO
)

IF "%SYS_FUNCIONARIO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_FUNCIONARIO.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO USUARIO ^(ID, COMISSAO, DESCONTO_MAXIMO, NOME, SENHA, CARGO, SEXO^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| FUNCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'0' ^|^| ',' ^|^|
	ECHO 	'0' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| FUNAPE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'QCUU' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'0' ^|^| ',' ^|^|
	ECHO 	'0' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM FUNCIONARIO;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_FUNCIONARIO%"=="0" GOTO SYS_FINALIZADORA

:SYS_FINALIZADORA

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar FINALIZADORA!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_FINALIZADORA=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_FINALIZADORA%" NEQ "1" IF "%SYS_FINALIZADORA%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_FINALIZADORA
)

IF "%SYS_FINALIZADORA%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_FINALIZADORA.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO FINALIZADORA ^(ID, PERMITE_TROCO, VERIFICA_LIMITE, DESCRICAO, GERA_FINANCEIRO, ESPECIE, PONTO_SANGRIA, PERMITE_PAGAMENTO, PERMITE_RECEBIMENTO, PERMITE_TROCA^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| FZDCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	IIF^(FZDPERTRC ^= 'S', '1', '0'^) ^|^| ',' ^|^|
	ECHO 	FZDVERLIM ^|^| ',' ^|^|
	ECHO 	'''' ^|^| FZDDES ^|^| '''' ^|^| ',' ^|^|
	ECHO 	IIF^(FZDGERCTAREC ^= 'S', '1', '0'^) ^|^| ',' ^|^|
	ECHO 	IIF^(FZDESP ^= '0', '0', '4'^) ^|^| ',' ^|^|
	ECHO 	FZDPNTSAN ^|^| ',' ^|^|
	ECHO 	IIF^(FZDACEPGT ^= 'S', '1', '0'^) ^|^| ',' ^|^|
	ECHO 	IIF^(FZDACEREC ^= 'S', '1', '0'^) ^|^| ',' ^|^|
	ECHO 	IIF^(FZDTRC ^= 'S', '1', '0'^) ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM FINALIZADORA
	ECHO 	WHERE FZDCOD ^<^> '001'
	ECHO 	AND FZDCOD ^<^> '987';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_FINALIZADORA%"=="0" GOTO SYS_SECAO

:SYS_SECAO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar SECAO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_SECAO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_SECAO%" NEQ "1" IF "%SYS_SECAO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_SECAO
)

IF "%SYS_SECAO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_SECAO.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO SECAO ^(ID, DESCRICAO^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| SECCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SECDES ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM SECAO
	ECHO 	WHERE SECCOD ^<^> '00';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_SECAO%"=="0" GOTO SYS_FORNECEDOR

:SYS_GRUPO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar GRUPO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_GRUPO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_GRUPO%" NEQ "1" IF "%SYS_GRUPO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_GRUPO
)

IF "%SYS_GRUPO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_GRUPO.SQL";
	ECHO SELECT 
	ECHO 	'INSERT INTO GRUPO ^(SECAO_ID, GRUPO_ID, DESCRICAO^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| SECCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| GRPCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| GRPDES ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM GRUPO
	ECHO 	WHERE SECCOD ^<^> '00';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_GRUPO%"=="0" GOTO SYS_PRODUTO

:SYS_SUBGRUPO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar SUBGRUPO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_SUBGRUPO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_SUBGRUPO%" NEQ "1" IF "%SYS_SUBGRUPO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_SUBGRUPO
)

IF "%SYS_SUBGRUPO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_SUBGRUPO.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO SUBGRUPO ^(SECAO_ID, GRUPO_ID, SUBGRUPO_ID, DESCRICAO^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| SECCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| GRPCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SGRCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SGRDES ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM SUBGRUPO
	ECHO 	WHERE SECCOD ^<^> '00';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_SUBGRUPO%"=="0" GOTO SYS_PRODUTO

:SYS_PRODUTO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar PRODUTO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_PRODUTO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_PRODUTO%" NEQ "1" IF "%SYS_PRODUTO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_PRODUTO
)
IF "%SYS_PRODUTO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_PRODUTO.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO PRODUTO ^(CODIGO, CUSTO, DESCRICAO, MARKUP, MARKUP_POR_QUANTIDADE, DESCONTO_MAXIMO, QUANTIDADE_MINIMA, OFERTA, FORA_DE_LINHA, DATA_FORA_DE_LINHA, PRECO, PRECO_POR_QUANTIDADE, ENVIA_BALANCA, ITEM_EMBALAGEM, FRACIONADO, SECAO_ID, GRUPO_ID, SUBGRUPO_ID, UNIDADE, ULTIMA_ALTERACAO, PRECO_VARIAVEL, PERMITE_DESCONTO^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| PROCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	COALESCE^(PROPRCCST, 0^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| TRIM^(PRODES^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	COALESCE^(PROMRG1, 0^) ^|^| ',' ^|^|
	ECHO 	COALESCE^(PROMRG2, 0^) ^|^| ',' ^|^|
	ECHO 	COALESCE^(PRODCNMAX, 0^) ^|^| ',' ^|^|
	ECHO 	COALESCE^(PROESTMIN, 0^) ^|^| ',' ^|^|
	ECHO 	COALESCE^(PROPRCOFEVAR, 0^) ^|^| ',' ^|^|
	ECHO 	IIF^(PROFORLIN = 'S', '1', '0'^) ^|^| ',' ^|^|
	ECHO 	IIF^(PROFORLIN = 'S', '''' ^|^| PRODATFORLIN ^|^| '''', 'NULL'^) ^|^| ',' ^|^|
	ECHO 	COALESCE^(PROPRCVDAVAR, 0^) ^|^| ',' ^|^|
	ECHO 	COALESCE^(PROPRCVDA2, 0^) ^|^| ',' ^|^|
	ECHO 	IIF^(PROENVBAL = 'S', '1', '0'^) ^|^| ',' ^|^|
	ECHO 	COALESCE^(PROITEEMB, 0^) ^|^| ',' ^|^|
	ECHO 	IIF^(PROPESVAR = 'S', '1', '0'^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SECCOD ^|^| '''' ^|^| ',' ^|^|
	ECHO 	IIF^(GRPCOD = '000' OR GRPCOD = '', 'NULL', '''' ^|^| TRIM^(GRPCOD^) ^|^| ''''^) ^|^| ',' ^|^|
	ECHO 	IIF^(SGRCOD = '000' OR SGRCOD = '', 'NULL', '''' ^|^| TRIM^(SGRCOD^) ^|^| ''''^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| TRIM^(PROUNID^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	IIF^(PROPRCDATALT IS NULL, 'NULL', '''' ^|^| PROPRCDATALT ^|^| ''''^) ^|^| ',' ^|^|
	ECHO 	IIF^(PROPRCVAR = 'S', '1', '0'^) ^|^| ',' ^|^|
	ECHO 	IIF^(PROPERDCN = 'S', '1', '0'^) ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM PRODUTO;
	ECHO.	
	ECHO SELECT
	ECHO 	'INSERT INTO ESTOQUE ^(SALDO, PRODUTO^) VALUES ^(' ^|^|
	ECHO 	'0' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| PROCOD ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM PRODUTO;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_PRODUTO%"=="0" GOTO SYS_FORNECEDOR

:SYS_EAN

IF "%SYS_PRODUTO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_EAN.SQL";
	ECHO SELECT 
	ECHO 	'INSERT INTO EAN ^(EAN, FATOR, PRODUTO_ID^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| LPAD^(TRIM^(PROCODAUX^), 14, '0'^) ^|^| '''' ^|^| ',' ^|^| 
	ECHO 	PROFATORMULT ^|^| ',' ^|^|
	ECHO 	'''' ^|^| PROCOD ^|^| '''' ^|^| 
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM PRODUTOAUX PA
	ECHO 	WHERE EXISTS
	ECHO 		^(SELECT 1 FROM PRODUTO P 
	ECHO 			WHERE P.PROCOD = PA.PROCOD^);
	ECHO.
	) >> "%MIGR_ARQ%"

GOTO SYS_ESTOQUE

:SYS_ESTOQUE

	:: AO EXPORTAR NA ESTOQUE_MOVIMENTACAO, A TRIGGER FICA RESPONSAVEL DE GERAR O VALOR DA TABELA ESTOQUE, ASSIM EVITANDO O ERRO DE DIVERGENCIA DE VALORES ENTRE A ESTOQUE E ESTOQUE_MOVIMENTACAO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar ESTOQUE!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_ESTOQUE=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_ESTOQUE%" NEQ "1" IF "%SYS_ESTOQUE%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_ESTOQUE
)
IF "%SYS_ESTOQUE%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_ESTOQUE.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO ESTOQUE_MOVIMENTACAO ^(MOVIMENTO, DATA, MOTIVO, PRODUTO^) VALUES ^(' ^|^|
	ECHO 	ESTATU ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CURRENT_DATE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'A' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| PROCOD ^|^| '''' ^|^| 
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM ESTOQUE E
	ECHO 	WHERE EXISTS
	ECHO 		^(SELECT 1 FROM PRODUTO P 
	ECHO 			WHERE P.PROCOD = E.PROCOD^)
	ECHO 	AND ESTATU ^> 0;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_ESTOQUE%"=="0" GOTO SYS_SIMILARES

:SYS_SIMILARES

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar SIMILARES!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_SIMILARES=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_SIMILARES%" NEQ "1" IF "%SYS_SIMILARES%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_SIMILARES
)
IF "%SYS_SIMILARES%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_SIMILARES.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO SIMILARES ^(ID, NOME^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| SUBSTRING^(PROCODSIM FROM 3 FOR 6^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SIMILARESDES ^|^| '''' ^|^| 
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM SIMILARES;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_SIMILARES%"=="0" GOTO SYS_FORNECEDOR

:SYS_ITEM_SIMILARES

IF "%SYS_SIMILARES%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_ITEM_SIMILARES.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO SIMILARES_ITEM ^(SIMILAR_ID, PRODUTO^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| SUBSTRING^(PROCODSIM FROM 3 FOR 6^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| PROCOD ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM ITEM_SIMILARES I
	ECHO 	WHERE EXISTS
	ECHO 		^(SELECT 1 FROM PRODUTO P 
	ECHO 			WHERE P.PROCOD = I.PROCOD^);
	ECHO.
	) >> "%MIGR_ARQ%"

GOTO SYS_FORNECEDOR

:SYS_FORNECEDOR

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar FORNECEDOR!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_FORNECEDOR=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_FORNECEDOR%" NEQ "1" IF "%SYS_FORNECEDOR%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_FORNECEDOR
)
IF "%SYS_FORNECEDOR%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_FORNECEDOR.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO FORNECEDOR ^(CODIGO, CIDADE, COMPLEMENTO, NUMERO, STATE, LOGRADOURO, CEP, BAIRRO, RAZAOSOCIAL, DOCUMENTO, NOMEFANTASIA, TIPOPESSOA, TELEFONE, TELEFONE2^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| LPAD^(FORCOD, 15, '0'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| FORCID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| FORCMP ^|^| '''' ^|^| ',' ^|^|
	ECHO 	CAST^(COALESCE^(NULLIF^(REPLACE^(REPLACE^(REPLACE^(REPLACE^(TRIM^(FORNUM^), 'S', ''^), '/', ''^), '-', ''^), 'N', ''^), ''^), 0^) AS INTEGER^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| FOREST ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SUBSTRING^(FOREND FROM 1 FOR 40^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	REPLACE^(FORCEP, '-', ''^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| FORBAI ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| FORDES ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| FORCGC ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| COALESCE^(FORFAN, FORDES^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	IIF^(FORPFPJ = 'J', '2', '1'^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| REPLACE^(REPLACE^(REPLACE^(COALESCE^(FORTEL, ''^), '^(', ''^), '^)', ''^), '-', ''^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| REPLACE^(REPLACE^(REPLACE^(COALESCE^(FORFAX, ''^), '^(', ''^), '^)', ''^), '-', ''^) ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM FORNECEDOR
	ECHO 	WHERE FORCOD ^<^> '0000';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_FORNECEDOR%"=="0" GOTO SYS_PRODUTO_FORNECEDOR


:SYS_PRODUTO_FORNECEDOR

 ::	***

:SYS_CLIENTES

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar CLIENTES!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_CLIENTES=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_CLIENTES%" NEQ "1" IF "%SYS_CLIENTES%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_CLIENTES
)
IF "%SYS_CLIENTES%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_CLIENTES.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO CLIENTE ^(CODIGO, CIDADE, COMPLEMENTO, NUMERO, STATE, LOGRADOURO, CEP, BAIRRO, RAZAOSOCIAL, DOCUMENTO, NOMEFANTASIA, TIPOPESSOA, TELEFONE, TELEFONE2, LIMITE, LIMITEUTILIZADO, STATUS^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| LPAD^(CLICOD, 15, '0'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CLICID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CLICMP ^|^| '''' ^|^| ',' ^|^|
	ECHO 	CAST^(COALESCE^(NULLIF^(REPLACE^(REPLACE^(REPLACE^(REPLACE^(TRIM^(CLINUM^), 'S', ''^), '/', ''^), '-', ''^), 'N', ''^), ''^), 0^) AS INTEGER^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CLIEST ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SUBSTRING^(CLIEND FROM 1 FOR 40^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| REPLACE^(CLICEP, '-', ''^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CLIBAI ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CLIDES ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CLICPFCGC ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| COALESCE^(CLIFAN, CLIDES^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	IIF^(CLIPFPJ = 'F', '1', '2'^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| REPLACE^(REPLACE^(REPLACE^(COALESCE^(CLITEL, ''^), '^(', ''^), '^)', ''^), '-', ''^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| REPLACE^(REPLACE^(REPLACE^(COALESCE^(CLITEL2, ''^), '^(', ''^), '^)', ''^), '-', ''^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	COALESCE^(CLILIMCRE, 0^) ^|^| ',' ^|^|
	ECHO 	COALESCE^(CLILIMUTL, 0^) ^|^| ',' ^|^|
	ECHO 	IIF^(STACOD = '000', '1', '0'^) ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM CLIENTE
	ECHO 	WHERE CLICOD ^<^> '000000000000000';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_CLIENTES%"=="0" GOTO SYS_TO_MIDI_END

:SYS_CONTA_RECEBER

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar CONTA_RECEBER!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P SYS_CONTA_RECEBER=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%SYS_CONTA_RECEBER%" NEQ "1" IF "%SYS_CONTA_RECEBER%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO SYS_CONTA_RECEBER
)
IF "%SYS_CONTA_RECEBER%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\SYS_CONTA_RECEBER.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO CONTA_RECEBER ^(ID, OBSERVACAO, VENCIMENTO, DOC, EMISSAO, TIPO, VALOR, VALOR_RECEBIDO, VALOR_RESTANTE, CLIENTE^) VALUES ^(' ^|^|
	ECHO 	CTRID ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SUBSTRING^(CTROBS FROM 1 FOR 120^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CAST^(CTRDATVNC AS DATE^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CTRNUM ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CAST^(CTRDATEMI AS DATE^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'0' ^|^| ',' ^|^|
	ECHO 	CTRVLRNOM ^|^| ',' ^|^|
	ECHO 	^(CTRVLRNOM - CTRVLRDEV^) ^|^| ',' ^|^|
	ECHO 	CTRVLRDEV ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CLICOD ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM CONTARECEBER CR
	ECHO 	WHERE EXISTS
	ECHO 		^(SELECT 1 FROM CLIENTE C 
	ECHO 			WHERE CR.CLICOD = C.CLICOD^)
	ECHO 	AND CTRTIPPAG = 'A';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%SYS_CONTA_RECEBER%"=="0" (ECHO.)
	
:SYS_TO_MIDI_END
	(ECHO EXIT;) >> "%MIGR_ARQ%"
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [SUCESSO]
	ECHO.
	ECHO     Arquivo de Exportacao Gerado!
	ECHO.
	ECHO   ==================================
	ECHO.
	TIMEOUT /T 2
	CLS


	:: Exportando os Dados do SysPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [Exportando os Dados]
	ECHO.
	ECHO               SysPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [Exportando os Dados]
	ECHO.
	ECHO               SysPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
ECHO INPUT '%MIGR_ARQ%'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
(ECHO [SUCESSO]) >> "%LOG_PATH%"
TIMEOUT /T 2
CLS

	:: Importando os Dados no Midi 5
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [Importando os Dados]
	ECHO.
	ECHO               MidiPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [Importando os Dados]
	ECHO.
	ECHO               MidiPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	TIMEOUT /T 2
	CLS
	
IF EXIST "%EXP_PATH%\SYS_EMPRESA.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [EMPRESA]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [EMPRESA]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_EMPRESA.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)

IF EXIST "%EXP_PATH%\SYS_FUNCIONARIO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            [FUNCIONARIO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            [FUNCIONARIO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_FUNCIONARIO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)

IF EXIST "%EXP_PATH%\SYS_FINALIZADORA.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [FINALIZADORA]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [FINALIZADORA]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_FINALIZADORA.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_SECAO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [SECAO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [SECAO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_SECAO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_GRUPO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [GRUPO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [GRUPO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_GRUPO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_SUBGRUPO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [SUBGRUPO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [SUBGRUPO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_SUBGRUPO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_PRODUTO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [PRODUTO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [PRODUTO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_PRODUTO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	IF "%SYS_GRUPO%"=="0" (ECHO UPDATE PRODUTO SET GRUPO_ID = NULL; UPDATE PRODUTO SET SUBGRUPO_ID = NULL; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" > NUL)
	IF "%SYS_SUBGRUPO%"=="0" (ECHO UPDATE PRODUTO SET SUBGRUPO_ID = NULL; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" > NUL)
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_EAN.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                [EAN]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO                [EAN]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_EAN.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_ESTOQUE.SQL" (	
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [ESTOQUE]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [ESTOQUE]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_ESTOQUE.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_SIMILARES.SQL" (	
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [SIMILARES]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [SIMILARES]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_SIMILARES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_ITEM_SIMILARES.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [ITEM_SIMILARES]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [ITEM_SIMILARES]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_ITEM_SIMILARES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_FORNECEDOR.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [FORNECEDOR]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [FORNECEDOR]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_FORNECEDOR.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_CLIENTES.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [CLIENTES]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [CLIENTES]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_CLIENTES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\SYS_CONTA_RECEBER.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [CONTA_RECEBER]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [CONTA_RECEBER]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\SYS_CONTA_RECEBER.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)

START C:\Midi\MidiServer.exe
START %LOG_PATH%
ECHO.
ECHO   ==================================
ECHO.
ECHO         [Migracao Concluida]
ECHO.
ECHO      Verifique o Log de Migracao
ECHO.
ECHO       %LOG_PATH%
ECHO.
ECHO   ==================================
ECHO.
	
PAUSE
GOTO END

:MIDI_TO_SYS_INI

SET "IBGE=0"
SET "REGIME=0"

(
	ECHO SET HEADING OFF;
	ECHO.
) > "%MIGR_ARQ%"

:MIDI_REGIME

ECHO.
ECHO   ==================================
ECHO.
ECHO        Qual Regime do Cliente!
ECHO.
ECHO          1 - Lucro Real
ECHO.
ECHO          2 - Lucro Presumido
ECHO.
ECHO          3 - Simples Nacional
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_REGIME=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_REGIME%" NEQ "1" IF "%MIDI_REGIME%" NEQ "2" IF "%MIDI_REGIME%" NEQ "3" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO     Por favor, escolha 1, 2 ou 3!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_REGIME
)

IF "%MIDI_REGIME%"=="1" (
	SET "FONTE=NULL"
	SET "ISENTO=NULL"
	SET "NAO_TRIBUTADO=NULL"
	SET "TRIBUTADO=NULL"
	SET "ALQ_PIS=1.65"
	SET "ALQ_COFINS=7.6"
	SET "REGIME=1"
	)
	
IF "%MIDI_REGIME%"=="2" (
	SET "FONTE=NULL"
	SET "ISENTO=NULL"
	SET "NAO_TRIBUTADO=NULL"
	SET "TRIBUTADO=NULL"
	SET "ALQ_PIS=0.65"
	SET "ALQ_COFINS=3"
	SET "REGIME=1"
	)
	
IF "%MIDI_REGIME%"=="3" (
	SET "FONTE='500'"
	SET "ISENTO='300'"
	SET "NAO_TRIBUTADO='400'"
	SET "TRIBUTADO='102'"
	)

:MIDI_FUNCIONARIO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar FUNCIONARIO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_FUNCIONARIO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_FUNCIONARIO%" NEQ "1" IF "%MIDI_FUNCIONARIO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_FUNCIONARIO
)

IF "%MIDI_FUNCIONARIO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_FUNCIONARIO.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO FUNCIONARIO ^(FUNCOD, FUNDES, FUNAPE, FUNACE, FUNCAR, FUNCOM, FUNTPRC, FUNLIMDCN, FUNINATIVO, FUNCOMMT^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| ID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| NOME ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| NOME ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '342334237...../7/012++++++7....7' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '2' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	COMISSAO ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'V' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	DESCONTO_MAXIMO ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'N' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'N' ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM USUARIO
	ECHO 	WHERE ID ^<^> '000001'
	ECHO 	AND ID ^<^> '999999';
	ECHO.
	) >> "%MIGR_ARQ%"
	
IF "%MIDI_FUNCIONARIO%"=="0" GOTO MIDI_SECAO

:MIDI_SECAO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar SECAO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_SECAO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_SECAO%" NEQ "1" IF "%MIDI_SECAO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_SECAO
)

IF "%MIDI_SECAO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_SECAO.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO SECAO ^(SECCOD, SECDES^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| ID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| DESCRICAO ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM SECAO
	ECHO 	WHERE ID ^<^> '00';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%MIDI_SECAO%"=="0" GOTO MIDI_FORNECEDOR

:MIDI_GRUPO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar GRUPO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_GRUPO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_GRUPO%" NEQ "1" IF "%MIDI_GRUPO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_GRUPO
)

IF "%MIDI_GRUPO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_GRUPO.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO GRUPO ^(SECCOD, GRPCOD, GRPDES^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| SECAO_ID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| GRUPO_ID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| DESCRICAO ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM GRUPO
	ECHO 	WHERE SECAO_ID ^<^> '00';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%MIDI_GRUPO%"=="0" GOTO MIDI_PRODUTO

:MIDI_SUBGRUPO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar SUBGRUPO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_SUBGRUPO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_SUBGRUPO%" NEQ "1" IF "%MIDI_SUBGRUPO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_SUBGRUPO
)

IF "%MIDI_SUBGRUPO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_SUBGRUPO.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO SUBGRUPO ^(SECCOD, GRPCOD, SGRCOD, SGRDES, SGRPARTREGESP^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| SECAO_ID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| GRUPO_ID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SUBGRUPO_ID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| DESCRICAO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'N' ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM SUBGRUPO
	ECHO 	WHERE SECAO_ID ^<^> '00';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%MIDI_SUBGRUPO%"=="0" GOTO MIDI_PRODUTO

:MIDI_PRODUTO

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar PRODUTO!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_PRODUTO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_PRODUTO%" NEQ "1" IF "%MIDI_PRODUTO%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_PRODUTO
)
IF "%MIDI_PRODUTO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_PRODUTO.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO PRODUTO ^(PROCOD, PRODES, PRODESRDZ, SECCOD, TRBID, PROUNID, PROPESVAR, PRODCNMAX, PROPRCVDAVAR, PROPRCOFEVAR, LOCCOD, PROPRCVAR, PROPRCDATALT, PROPRCCST, PROPRCVDA2, PROPRCOFE2, PROFLGALT, PROTABA, PROPRC1, PROPRC2, PROCTREST, PROPERDCN, PROCOMP, PROENVBAL, PROMRG1, PROMRG2, PRODATCADINC, PRODATCADALT, FUNCOD, PROQTDMINPRC2, GRPCOD, SGRCOD, PROITEEMB, PROPESBRT, PROPESLIQ, PROFORLIN, PRODATFORLIN, PROUNDCMP, PROIAT, PROIPPT, PROUNDREF, PROMEDREF, PROPRCCSTMED, PROPRCCSTFIS, PROFIN, PRONCM, GENCODIGO, NATCODIGO, PROCEST^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| CODIGO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SUBSTRING^(REPLACE^(DESCRICAO, '''', ''^) FROM 1 FOR 80^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SUBSTRING^(REPLACE^(DESCRICAO, '''', ''^) FROM 1 FOR 20^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| SECAO_ID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'F00' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| UNIDADE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(FRACIONADO = '1', 'S', 'N'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	DESCONTO_MAXIMO ^|^| ',' ^|^|
	ECHO 	PRECO ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '0' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '00' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(PRECO_VARIAVEL = '1', 'S', 'N'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	COALESCE^('''' ^|^| ULTIMA_ALTERACAO ^|^| '''', 'NULL'^) ^|^| ',' ^|^|
	ECHO 	CUSTO ^|^| ',' ^|^|
	ECHO 	PRECO_POR_QUANTIDADE ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '0' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'A' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '0' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	PRECO ^|^| ',' ^|^|
	ECHO 	PRECO_POR_QUANTIDADE ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'S' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(PERMITE_DESCONTO = '1', 'S', 'N'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'N' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(ENVIA_BALANCA = '1', 'S', 'N'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	MARKUP ^|^| ',' ^|^|
	ECHO 	MARKUP_POR_QUANTIDADE ^|^| ',' ^|^|
	ECHO 	COALESCE^('''' ^|^| ULTIMA_ALTERACAO ^|^| '''', 'NULL'^) ^|^| ',' ^|^|
	ECHO 	COALESCE^('''' ^|^| ULTIMA_ALTERACAO ^|^| '''', 'NULL'^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '000001' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	QUANTIDADE_MINIMA ^|^| ',' ^|^|
	ECHO 	'''' ^|^| COALESCE^(GRUPO_ID, '000'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| COALESCE^(SUBGRUPO_ID, '000'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '1' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '1' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '1' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(FORA_DE_LINHA = '1', 'S', 'N'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	IIF^(FORA_DE_LINHA = '1', '''' ^|^| DATA_FORA_DE_LINHA ^|^| '''', 'NULL'^) ^|^| ',' ^|^|
	ECHO 	'''' ^|^| UNIDADE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'A' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'T' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| UNIDADE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '1' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	CUSTO ^|^| ',' ^|^|
	ECHO 	CUSTO ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '1' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '39249000' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '39' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '000' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '1400500' ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM PRODUTO;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%MIDI_PRODUTO%"=="0" GOTO MIDI_FORNECEDOR

:MIDI_PRODUTOAUX

IF "%MIDI_PRODUTO%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_PRODUTOAUX.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO PRODUTOAUX ^(PROCODAUX, PROCOD, PROFATORMULT, PROMODALIDADETAB1, PROTIPOTAB1, PROEANTRIB^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| EAN ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| PRODUTO_ID ^|^| '''' ^|^| ',' ^|^|
	ECHO 	FATOR ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'D' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'P' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'P' ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM EAN AUX
	ECHO 	WHERE EXISTS
	ECHO 		^(SELECT 1 FROM PRODUTO P 
	ECHO 			WHERE P.CODIGO = AUX.PRODUTO_ID^);
	ECHO.
	) >> "%MIGR_ARQ%"
	
IF "%REGIME%"=="1" GOTO MIDI_IMPOSTOS_FEDERAIS_PRODUTO
IF "%REGIME%"=="0" GOTO MIDI_ESTOQUE

:MIDI_IMPOSTOS_FEDERAIS_PRODUTO

ECHO.
ECHO   ==================================
ECHO.
ECHO       IMPOSTOS FEDERAIS PRODUTO!
ECHO.
ECHO           1 - Tributado
ECHO.
ECHO           2 - Monofasico
ECHO.
ECHO           3 - Aliquota 0
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_IMPOSTOS_FEDERAIS_PRODUTO=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_IMPOSTOS_FEDERAIS_PRODUTO%" NEQ "1" IF "%MIDI_IMPOSTOS_FEDERAIS_PRODUTO%" NEQ "2" IF "%MIDI_IMPOSTOS_FEDERAIS_PRODUTO%" NEQ "3" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO      Por favor, escolha 1,2 ou 3!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_IMPOSTOS_FEDERAIS_PRODUTO
)
IF "%MIDI_IMPOSTOS_FEDERAIS_PRODUTO%"=="1" (
	SET "IMPFEDSIM_PIS=01"
	SET "IMPFEDSIM_COFINS=02"
	)

IF "%MIDI_IMPOSTOS_FEDERAIS_PRODUTO%"=="2" (
	SET "IMPFEDSIM_PIS=03"
	SET "IMPFEDSIM_COFINS=04"
	)

IF "%MIDI_IMPOSTOS_FEDERAIS_PRODUTO%"=="3" (
	SET "IMPFEDSIM_PIS=05"
	SET "IMPFEDSIM_COFINS=06"
	)

:MIDI_ESTOQUE

	:: AO INSERIR NA ESTOQUE_MOVIMENTACAO, A TRIGGER FICA RESPONSAVEL DE GERAR O VALOR DA TABELA ESTOQUE, ASSIM EVITANDO O ERRO DE DIVERGENCIA DE VALORES ENTRE A ESTOQUE E ESTOQUE_MOVIMENTACAO;

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar ESTOQUE!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_ESTOQUE=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_ESTOQUE%" NEQ "1" IF "%MIDI_ESTOQUE%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_ESTOQUE
)
IF "%MIDI_ESTOQUE%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_ESTOQUE.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO ESTOQUE_MOVIMENTACAO ^(LOCCOD, PROCOD, MOVDAT, MOVQTD, MOVDOC, MOVMTV, MOVTIP, MOVESP, FATCOD, FUNCOD, MOVPRC^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| '01' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| PRODUTO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CURRENT_TIMESTAMP ^|^| '''' ^|^| ',' ^|^|
	ECHO 	SALDO ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'AJUSTE MANUAL' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'ESTOQUE INICIAL' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'A' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'AJU' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '016' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '000001' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'N' ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM ESTOQUE E
	ECHO 	WHERE EXISTS
	ECHO 		^(SELECT 1 FROM PRODUTO P 
	ECHO 			WHERE P.CODIGO = E.PRODUTO^)
	ECHO 	AND SALDO ^> 0;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%MIDI_ESTOQUE%"=="0" GOTO MIDI_SIMILARES

:MIDI_SIMILARES

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar SIMILARES!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_SIMILARES=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_SIMILARES%" NEQ "1" IF "%MIDI_SIMILARES%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_SIMILARES
)
IF "%MIDI_SIMILARES%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_SIMILARES.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO SIMILARES ^(PROCODSIM, SIMILARESDES, SIMILARESHABVDAQTD^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| LPAD^(ID, 8, '0'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| NOME ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'N' ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM SIMILARES;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%MIDI_SIMILARES%"=="0" GOTO MIDI_FORNECEDOR

:MIDI_ITEM_SIMILARES

IF "%MIDI_SIMILARES%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_ITEM_SIMILARES.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO ITEM_SIMILARES ^(PROCODSIM, PROCOD^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| LPAD^(SIMILAR_ID, 8, '0'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| PRODUTO ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM SIMILARES_ITEM;
	ECHO.
	) >> "%MIGR_ARQ%"

GOTO MIDI_FORNECEDOR

:MIDI_FORNECEDOR

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar FORNECEDOR!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_FORNECEDOR=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_FORNECEDOR%" NEQ "1" IF "%MIDI_FORNECEDOR%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_FORNECEDOR
)
IF "%MIDI_FORNECEDOR%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_FORNECEDOR.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO FORNECEDOR ^(FORCOD, FORDES, FOREND, FORBAI, FORCID, FOREST, FORTEL, FORCEP, FORNUM, FORCON, FORFAN, FORCGC, FORCGF, CLICOD, FORPFPJ, FORPAIS, FORPRZENT, FORSINCLD, FORPRODRUR, FORSTSDESON^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| SUBSTRING^(CODIGO FROM 12 FOR 4^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| RAZAOSOCIAL ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| TRIM^(COALESCE^(LOGRADOURO_TIPO, ''^) ^|^| ' ' ^|^| LOGRADOURO^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| BAIRRO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CIDADE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| COALESCE^(STATE, ''^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| TELEFONE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CEP ^|^| '''' ^|^| ',' ^|^|
	ECHO 	NUMERO ^|^| ',' ^|^|
	ECHO 	'''' ^|^| COMPLEMENTO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| COALESCE^(NOMEFANTASIA, RAZAOSOCIAL^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| DOCUMENTO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(TIPOPESSOA = '1', 'ISENTO', TRIM^(''^)^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '000000000000000' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(TIPOPESSOA = '1', 'F', 'J'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '01058' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '0' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'A' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(TIPOPESSOA = '1', 'S', 'N'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'N' ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM FORNECEDOR;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%MIDI_FORNECEDOR%"=="0" GOTO MIDI_PRODUTO_FORNECEDOR

:MIDI_PRODUTO_FORNECEDOR

	:: ***

:MIDI_CLIENTE

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar CLIENTES!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_CLIENTE=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_CLIENTE%" NEQ "1" IF "%MIDI_CLIENTE%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_CLIENTE
)
IF "%MIDI_CLIENTE%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_CLIENTE.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO CLIENTE ^(CLICOD, CLIDES, CLIEND, CLICPFCGC, CLIBAI, CLITEL, CLICEP, CLICID, CLINUM, CLIEST, CLILIMCRE, CLILIMUTL, STACOD, CLITABPRZ, CLIFAN, CLIRGCGF, CLIDTCAD, CLIPFPJ, CLIDTALT, CLISEX, RAMCOD, CLIGERLOG, FUNCOD, CLIRETEMISS, CLIPAIS, CLIORGPUB, CLIINDCINSCEST^) VALUES ^(' ^|^|
	ECHO 	'''' ^|^| CODIGO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| RAZAOSOCIAL ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| TRIM^(COALESCE^(LOGRADOURO_TIPO, ''^) ^|^| ' ' ^|^| LOGRADOURO^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| DOCUMENTO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| BAIRRO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| TELEFONE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CEP ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CIDADE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	NUMERO ^|^| ',' ^|^|
	ECHO 	'''' ^|^| COALESCE^(STATE, ''^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	LIMITE ^|^| ',' ^|^|
	ECHO 	LIMITEUTILIZADO ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(STATUS = '1', '001', '002'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'PRZ' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| COALESCE^(NOMEFANTASIA, RAZAOSOCIAL^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(TIPOPESSOA = '1', 'ISENTO', TRIM^(''^)^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CURRENT_DATE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(TIPOPESSOA = '1', 'F', 'J'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CURRENT_DATE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| IIF^(TIPOPESSOA = '1', 'M', 'E'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '000' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'A' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '000000' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'N' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '01058' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'N' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'0' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM CLIENTE;
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%MIDI_CLIENTE%"=="0" GOTO MIDI_TO_SYS_END

:MIDI_CONTARECEBER

ECHO.
ECHO   ==================================
ECHO.
ECHO       Deseja Migrar CONTA_RECEBER!
ECHO.
ECHO              1 - Sim
ECHO.
ECHO              0 - Nao
ECHO.
ECHO   ==================================
ECHO.
SET /P MIDI_CONTARECEBER=" Digite a opcao: "
CLS

	:: Validação de entrada
IF "%MIDI_CONTARECEBER%" NEQ "1" IF "%MIDI_CONTARECEBER%" NEQ "0" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             Opcao invalida!
	ECHO       Por favor, escolha 1 ou 0!
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	CLS
	GOTO MIDI_CONTARECEBER
)
IF "%MIDI_CONTARECEBER%"=="1" (
	ECHO OUTPUT "%EXP_PATH%\MIDI_CONTARECEBER.SQL";
	ECHO SELECT
	ECHO 	'INSERT INTO CONTARECEBER ^(CTRID, CTRNUM, CTROBS, CTRTIPPAG, AGECOD, CLICOD, CTRDATEMI, CTRDATVNC, CTRVLRNOM, CTRVLRDEV, CTRDATINC, CTRBAXLIM^) VALUES ^(' ^|^|
	ECHO 	ID ^|^| ',' ^|^|
	ECHO 	'''' ^|^| LPAD^(ID, 10, '0'^) ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| DOC ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| 'A' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '0000' ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| CLIENTE ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| EMISSAO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| VENCIMENTO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	VALOR ^|^| ',' ^|^|
	ECHO 	VALOR_RESTANTE ^|^| ',' ^|^|
	ECHO 	'''' ^|^| EMISSAO ^|^| '''' ^|^| ',' ^|^|
	ECHO 	'''' ^|^| '1' ^|^| '''' ^|^|
	ECHO 	'^)' ^|^| ';' ^|^| ' COMMIT;'
	ECHO FROM CONTA_RECEBER CR
	ECHO 	WHERE EXISTS
	ECHO 		^(SELECT 1 FROM CLIENTE C
	ECHO 			WHERE C.CODIGO = CR.CLIENTE^)
	ECHO 	AND TIPO = '0' 
	ECHO 	OR TIPO = '1';
	ECHO.
	) >> "%MIGR_ARQ%"

IF "%MIDI_CONTARECEBER%"=="0" (ECHO.)

:MIDI_TO_SYS_END
	(ECHO EXIT;) >> "%MIGR_ARQ%"
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [SUCESSO]
	ECHO.
	ECHO     Arquivo de Exportacao Gerado!
	ECHO.
	ECHO   ==================================
	ECHO.
	TIMEOUT /T 2
	CLS

	:: Outras Informações
:COD_IBGE

IF "%MIDI_FORNECEDOR%"=="1" (SET "IBGE=1")

IF "%MIDI_CLIENTE%"=="1" (SET "IBGE=1")

IF "%IBGE%"=="1" (
	ECHO CREATE TABLE MIGR_ESTADOS ^(
	ECHO 	CODUF	CHAR^(2^) NOT NULL,
	ECHO 	SIGLA	CHAR^(2^) NOT NULL,
	ECHO 	ESTADO	VARCHAR^(30^) NOT NULL^);
	ECHO COMMIT;
	ECHO.
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('11', 'RO', 'RONDONIA'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('12', 'AC', 'ACRE'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('13', 'AM', 'AMAZONAS'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('14', 'RR', 'RORAIMA'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('15', 'PA', 'PARA'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('16', 'AP', 'AMAPA'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('17', 'TO', 'TOCANTINS'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('21', 'MA', 'MARANHAO'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('22', 'PI', 'PIAUI'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('23', 'CE', 'CEARA'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('24', 'RN', 'RIO GRANDE DO NORTE'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('25', 'PB', 'PARAIBA'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('26', 'PE', 'PERNAMBUCO'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('27', 'AL', 'ALAGOAS'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('28', 'SE', 'SERGIPE'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('29', 'BA', 'BAHIA'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('31', 'MG', 'MINAS GERAIS'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('32', 'ES', 'ESPIRITO SANTO'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('33', 'RJ', 'RIO DE JANEIRO'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('35', 'SP', 'SAO PAULO'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('41', 'PR', 'PARANA'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('42', 'SC', 'SANTA CATARINA'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('43', 'RS', 'RIO GRANDE DO SUL'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('50', 'MS', 'MATO GROSSO DO SUL'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('51', 'MT', 'MATO GROSSO'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('52', 'GO', 'GOIAS'^);
	ECHO INSERT INTO MIGR_ESTADOS ^(CODUF, SIGLA, ESTADO^) VALUES ^('53', 'DF', 'DISTRITO FEDERAL'^);
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"

IF "%MIDI_FORNECEDOR%"=="1" (
	ECHO UPDATE FORNECEDOR F
	ECHO SET FORCODIBGE = ^(
	ECHO 	SELECT E.CODUF ^|^| M.CODIBGE
	ECHO 	FROM FISCO_CODIGOIBGE M
	ECHO 		JOIN MIGR_ESTADOS E ON E.SIGLA = M.CODIBGEUF
	ECHO 		WHERE F.FOREST = M.CODIBGEUF
	ECHO 		AND F.FORCID = M.CODIBGECID^);
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"

IF "%MIDI_CLIENTE%"=="1" (
	ECHO UPDATE CLIENTE C
	ECHO SET CLICODIGOIBGE = ^(
	ECHO 	SELECT E.CODUF ^|^| M.CODIBGE
	ECHO 	FROM FISCO_CODIGOIBGE M
	ECHO 		JOIN MIGR_ESTADOS E ON E.SIGLA = M.CODIBGEUF
	ECHO 		WHERE C.CLIEST = M.CODIBGEUF
	ECHO 		AND C.CLICID = M.CODIBGECID^);
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"
	
IF "%IBGE%"=="1" (
	ECHO DROP TABLE MIGR_ESTADOS;
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"
	
:SERIE

	(
	ECHO INSERT INTO SERIE_NOTA_FISCAL ^(ID, SERTIP, SERDATCAD, SERNUMINI, SERNUMFIN, SERNUMATU, SERPERALT, SERMODNOTA, SERQTDEITENS, SERIDMODNOT, SERSTA, SERHASHSEQ^) VALUES ^(1, '1', '2025-01-01 00:00:00', '0000000001', '9999999999', '0000000000', NULL, 'NFe', NULL, 23, 'A', NULL^);
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"	

:OPERACAO

	(
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0001', 'ENTRADA - COMPRA / IMOBILIZADO / BONIFICACAO', 'N', '3', NULL, NULL, NULL, 'E', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0002', 'ENTRADA - USO E CONSUMO', 'N', '3', NULL, NULL, NULL, 'E', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0003', 'ENTRADA - DEVOLUCAO', 'N', '3', NULL, NULL, NULL, 'E', NULL, NULL, NULL, NULL, 'S', NULL, 'D', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0004', 'ENTRADA - RECLASSIFICACAO', 'N', '3', NULL, NULL, NULL, 'E', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0005', 'ENTRADA - OUTRAS', 'N', '3', NULL, NULL, NULL, 'E', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0011', 'SAIDA - VENDA / IMOBILIZADO / BONIFICACAO', 'N', '3', NULL, NULL, NULL, 'S', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0012', 'SAIDA - USO E CONSUMO', 'N', '3', NULL, NULL, NULL, 'S', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0013', 'SAIDA - DEVOLUCAO', 'N', '3', NULL, NULL, NULL, 'S', NULL, NULL, NULL, NULL, 'S', NULL, 'D', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0014', 'SAIDA - RECLASSIFICACAO', 'N', '3', NULL, NULL, NULL, 'S', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0015', 'SAIDA - PERDA E AVARIA', 'N', '3', NULL, NULL, NULL, 'S', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0016', 'SAIDA - ACOBERTAMENTO', 'N', '3', NULL, NULL, NULL, 'S', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO INSERT INTO OPERACAO ^(OPECOD, OPEDESC, OPEGESCRITA, OPEGFINANC, OPETIPO, OPEIPINFV, OPEOUTRAS, OPETIP, OPEPRCCUSTO, OPEBASEIPI, OPEOUTRAICMS, OPEIPIPISCOFINS, OPEBASEFRETE, OPEBASDESC, OPEMODALIDADE, OPEICMSSTPISCOF, OPEFRETEPISCOF, OPESEGPISCOF, OPECSTSAIDA, OPEGERAFIS, OPEGERABC^) VALUES ^('0017', 'SAIDA - OUTRAS', 'N', '3', NULL, NULL, NULL, 'S', NULL, NULL, NULL, NULL, 'S', NULL, 'N', NULL, 'S', NULL, NULL, NULL, NULL^);
	ECHO COMMIT;
	ECHO.
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(1, '0001', '11010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(2, '0001', '21010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(3, '0001', '11020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(4, '0001', '21020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(5, '0001', '14010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(6, '0001', '24010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(7, '0001', '14030'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(8, '0001', '24030'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(9, '0001', '14060'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(10, '0001', '24060'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(11, '0001', '15510'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(12, '0001', '25510'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(13, '0001', '15550'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(14, '0001', '25550'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(15, '0001', '19100'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(16, '0001', '29100'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(17, '0001', '19110'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(18, '0001', '29110'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(19, '0002', '14070'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(20, '0002', '24070'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(21, '0002', '15560'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(22, '0002', '25560'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(23, '0003', '12010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(24, '0003', '22010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(25, '0003', '12020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(26, '0003', '22020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(27, '0003', '14100'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(28, '0003', '24100'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(29, '0003', '14110'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(30, '0003', '24110'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(31, '0004', '19260'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(32, '0005', '19490'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(33, '0005', '29490'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(34, '0005', '19080'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(35, '0005', '29080'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(36, '0005', '19120'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(37, '0005', '29120'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(38, '0005', '19160'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(39, '0005', '29160'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(40, '0005', '19200'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(41, '0005', '29200'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(42, '0011', '51010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(43, '0011', '61010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(44, '0011', '51020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(45, '0011', '61020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(46, '0011', '54010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(47, '0011', '64010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(48, '0011', '54020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(49, '0011', '64020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(50, '0011', '54030'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(51, '0011', '64030'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(52, '0011', '54050'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(53, '0011', '55510'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(54, '0011', '65510'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(55, '0011', '59100'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(56, '0011', '69100'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(57, '0011', '59110'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(58, '0011', '69110'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(59, '0012', '55560'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(60, '0012', '65560'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(61, '0013', '52010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(62, '0013', '62010'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(63, '0013', '52020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(64, '0013', '62020'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(65, '0013', '54100'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(66, '0013', '64100'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(67, '0013', '54110'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(68, '0013', '64110'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(69, '0013', '54120'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(70, '0013', '64120'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(71, '0013', '54130'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(72, '0013', '64130'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(73, '0013', '55530'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(74, '0013', '65530'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(75, '0013', '55550'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(76, '0013', '65550'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(77, '0013', '55560'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(78, '0013', '65560'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(79, '0014', '59260'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(80, '0015', '59270'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(81, '0016', '59290'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(82, '0016', '69290'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(83, '0017', '59490'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(84, '0017', '69490'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(85, '0017', '59090'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(86, '0017', '69090'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(87, '0017', '59130'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(88, '0017', '69130'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(89, '0017', '59150'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(90, '0017', '69150'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(91, '0017', '59210'^);
	ECHO INSERT INTO OPERACAO_CFOP ^(ID, OPECOD, CFOCOD^) VALUES ^(92, '0017', '69210'^);
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"
	
:TRIBUTACAO

	(
	ECHO DELETE FROM TRIBUTACAO;
	ECHO DELETE FROM ECF;
	ECHO COMMIT;
	ECHO.
	ECHO INSERT INTO TRIBUTACAO ^(TRBID, TRBSIM, TRBCOD, TRBDES, TRBALQ, TRBRED, TRBTABB, TRBINC, TRBOBS, TRBREDINT, TRBOBSINT, TRBSISIF, TRBREDSISIF, TRBOBSSISIF, TRBSIMECF, TRBALQECF, TRBCFOP, TRBCFOPINTER, TRBCSOSN, TRBALQINTER, TRBBASE, TRBBASESAI, TRBBASEST, TRBBASESTSAI, TRBALQENT, TRBREDENT, TRBTABBENT, TRBCFOPENT, TRBCFOPENTINTER, TRBCSOSNENT, TRBINCENT, TRBCFOPSAI, TRBTABBINT, TRBOPENFSE, TRBTABBCUP, TRBCSOSNCUP, TRBALQFCP, TRBREDCUP, TRBCONREDSTSAI, TRBTABBCFE, TRBALQCFE, TRBDIFNFE, TRBDIFNFCE, TRBSOMICMSUBPROD, TRBALQST, TRBCONALQST, TRBSOMABCNOICMS^) VALUES ^('F00', 'F', '00', 'FONTE', 0, 0, '60', 0, '', 0, '', NULL, NULL, NULL, 'F', 0, '54030', '64030', %FONTE%, 0, NULL, NULL, NULL, NULL, 0, 0, '60', '14030', '24030', %FONTE%, 0, '54030', '60', '', '60', %FONTE%, 0, 0, NULL, '60', 0, 0, 0, NULL, 0, NULL, NULL^);
	ECHO INSERT INTO TRIBUTACAO ^(TRBID, TRBSIM, TRBCOD, TRBDES, TRBALQ, TRBRED, TRBTABB, TRBINC, TRBOBS, TRBREDINT, TRBOBSINT, TRBSISIF, TRBREDSISIF, TRBOBSSISIF, TRBSIMECF, TRBALQECF, TRBCFOP, TRBCFOPINTER, TRBCSOSN, TRBALQINTER, TRBBASE, TRBBASESAI, TRBBASEST, TRBBASESTSAI, TRBALQENT, TRBREDENT, TRBTABBENT, TRBCFOPENT, TRBCFOPENTINTER, TRBCSOSNENT, TRBINCENT, TRBCFOPSAI, TRBTABBINT, TRBOPENFSE, TRBTABBCUP, TRBCSOSNCUP, TRBALQFCP, TRBREDCUP, TRBCONREDSTSAI, TRBTABBCFE, TRBALQCFE, TRBDIFNFE, TRBDIFNFCE, TRBSOMICMSUBPROD, TRBALQST, TRBCONALQST, TRBSOMABCNOICMS^) VALUES ^('I00', 'I', '00', 'ISENTO', 0, 0, '40', 0, '', 0, '', NULL, NULL, NULL, 'I', 0, '51020', '61020', %ISENTO%, 0, NULL, NULL, NULL, NULL, 0, 0, '40', '11020', '21020', %ISENTO%, 0, '51020', '40', '', '40', %ISENTO%, 0, 0, NULL, '40', 0, 0, 0, NULL, 0, NULL, NULL^);
	ECHO INSERT INTO TRIBUTACAO ^(TRBID, TRBSIM, TRBCOD, TRBDES, TRBALQ, TRBRED, TRBTABB, TRBINC, TRBOBS, TRBREDINT, TRBOBSINT, TRBSISIF, TRBREDSISIF, TRBOBSSISIF, TRBSIMECF, TRBALQECF, TRBCFOP, TRBCFOPINTER, TRBCSOSN, TRBALQINTER, TRBBASE, TRBBASESAI, TRBBASEST, TRBBASESTSAI, TRBALQENT, TRBREDENT, TRBTABBENT, TRBCFOPENT, TRBCFOPENTINTER, TRBCSOSNENT, TRBINCENT, TRBCFOPSAI, TRBTABBINT, TRBOPENFSE, TRBTABBCUP, TRBCSOSNCUP, TRBALQFCP, TRBREDCUP, TRBCONREDSTSAI, TRBTABBCFE, TRBALQCFE, TRBDIFNFE, TRBDIFNFCE, TRBSOMICMSUBPROD, TRBALQST, TRBCONALQST, TRBSOMABCNOICMS^) VALUES ^('N00', 'N', '00', 'NAO TRIBUTADO', 0, 0, '41', 0, '', 0, '', NULL, NULL, NULL, 'N', 0, '51020', '61020', %NAO_TRIBUTADO%, 0, NULL, NULL, NULL, NULL, 0, 0, '41', '11020', '21020', %NAO_TRIBUTADO%, 0, '51020', '41', '', '41', %NAO_TRIBUTADO%, 0, 0, NULL, '41', 0, 0, 0, NULL, 0, NULL, NULL^);
	ECHO INSERT INTO TRIBUTACAO ^(TRBID, TRBSIM, TRBCOD, TRBDES, TRBALQ, TRBRED, TRBTABB, TRBINC, TRBOBS, TRBREDINT, TRBOBSINT, TRBSISIF, TRBREDSISIF, TRBOBSSISIF, TRBSIMECF, TRBALQECF, TRBCFOP, TRBCFOPINTER, TRBCSOSN, TRBALQINTER, TRBBASE, TRBBASESAI, TRBBASEST, TRBBASESTSAI, TRBALQENT, TRBREDENT, TRBTABBENT, TRBCFOPENT, TRBCFOPENTINTER, TRBCSOSNENT, TRBINCENT, TRBCFOPSAI, TRBTABBINT, TRBOPENFSE, TRBTABBCUP, TRBCSOSNCUP, TRBALQFCP, TRBREDCUP, TRBCONREDSTSAI, TRBTABBCFE, TRBALQCFE, TRBDIFNFE, TRBDIFNFCE, TRBSOMICMSUBPROD, TRBALQST, TRBCONALQST, TRBSOMABCNOICMS^) VALUES ^('T07', 'T', '07', 'TRIBUTADO 7', 7, 0, '00', 0, '', 0, '', 'N', 0, NULL, 'T', 7, '51020', '61020', %TRIBUTADO%, 0, 'N', 'N', 'N', 'N', 7, 0, '00', '11020', '21020', %TRIBUTADO%, 0, '51020', '00', '', '00', %TRIBUTADO%, 0, 0, 'S', '00', 7, 0, 0, 'N', 0, NULL, NULL^);
	ECHO INSERT INTO TRIBUTACAO ^(TRBID, TRBSIM, TRBCOD, TRBDES, TRBALQ, TRBRED, TRBTABB, TRBINC, TRBOBS, TRBREDINT, TRBOBSINT, TRBSISIF, TRBREDSISIF, TRBOBSSISIF, TRBSIMECF, TRBALQECF, TRBCFOP, TRBCFOPINTER, TRBCSOSN, TRBALQINTER, TRBBASE, TRBBASESAI, TRBBASEST, TRBBASESTSAI, TRBALQENT, TRBREDENT, TRBTABBENT, TRBCFOPENT, TRBCFOPENTINTER, TRBCSOSNENT, TRBINCENT, TRBCFOPSAI, TRBTABBINT, TRBOPENFSE, TRBTABBCUP, TRBCSOSNCUP, TRBALQFCP, TRBREDCUP, TRBCONREDSTSAI, TRBTABBCFE, TRBALQCFE, TRBDIFNFE, TRBDIFNFCE, TRBSOMICMSUBPROD, TRBALQST, TRBCONALQST, TRBSOMABCNOICMS^) VALUES ^('T12', 'T', '12', 'TRIBUTADO 12', 12, 0, '00', 0, '', 0, '', 'N', 0, NULL, 'T', 12, '51020', '61020', %TRIBUTADO%, 0, 'N', 'N', 'N', 'N', 12, 0, '00', '11020', '21020', %TRIBUTADO%, 0, '51020', '00', '', '00', %TRIBUTADO%, 0, 0, 'S', '00', 12, 0, 0, 'N', 0, NULL, NULL^);
	ECHO INSERT INTO TRIBUTACAO ^(TRBID, TRBSIM, TRBCOD, TRBDES, TRBALQ, TRBRED, TRBTABB, TRBINC, TRBOBS, TRBREDINT, TRBOBSINT, TRBSISIF, TRBREDSISIF, TRBOBSSISIF, TRBSIMECF, TRBALQECF, TRBCFOP, TRBCFOPINTER, TRBCSOSN, TRBALQINTER, TRBBASE, TRBBASESAI, TRBBASEST, TRBBASESTSAI, TRBALQENT, TRBREDENT, TRBTABBENT, TRBCFOPENT, TRBCFOPENTINTER, TRBCSOSNENT, TRBINCENT, TRBCFOPSAI, TRBTABBINT, TRBOPENFSE, TRBTABBCUP, TRBCSOSNCUP, TRBALQFCP, TRBREDCUP, TRBCONREDSTSAI, TRBTABBCFE, TRBALQCFE, TRBDIFNFE, TRBDIFNFCE, TRBSOMICMSUBPROD, TRBALQST, TRBCONALQST, TRBSOMABCNOICMS^) VALUES ^('T20', 'T', '20', 'TRIBUTADO 20', 20, 0, '00', 0, '', 0, '', 'N', 0, NULL, 'T', 20, '51020', '61020', %TRIBUTADO%, 0, 'N', 'N', 'N', 'N', 20, 0, '00', '11020', '21020', %TRIBUTADO%, 0, '51020', '00', '', '00', %TRIBUTADO%, 0, 0, 'S', '00', 20, 0, 0, 'N', 0, NULL, NULL^);
	ECHO INSERT INTO TRIBUTACAO ^(TRBID, TRBSIM, TRBCOD, TRBDES, TRBALQ, TRBRED, TRBTABB, TRBINC, TRBOBS, TRBREDINT, TRBOBSINT, TRBSISIF, TRBREDSISIF, TRBOBSSISIF, TRBSIMECF, TRBALQECF, TRBCFOP, TRBCFOPINTER, TRBCSOSN, TRBALQINTER, TRBBASE, TRBBASESAI, TRBBASEST, TRBBASESTSAI, TRBALQENT, TRBREDENT, TRBTABBENT, TRBCFOPENT, TRBCFOPENTINTER, TRBCSOSNENT, TRBINCENT, TRBCFOPSAI, TRBTABBINT, TRBOPENFSE, TRBTABBCUP, TRBCSOSNCUP, TRBALQFCP, TRBREDCUP, TRBCONREDSTSAI, TRBTABBCFE, TRBALQCFE, TRBDIFNFE, TRBDIFNFCE, TRBSOMICMSUBPROD, TRBALQST, TRBCONALQST, TRBSOMABCNOICMS^) VALUES ^('T25', 'T', '25', 'TRIBUTADO 25', 25, 0, '00', 0, '', 0, '', 'N', 0, NULL, 'T', 25, '51020', '61020', %TRIBUTADO%, 0, 'N', 'N', 'N', 'N', 25, 0, '00', '11020', '21020', %TRIBUTADO%, 0, '51020', '00', '', '00', %TRIBUTADO%, 0, 0, 'S', '00', 25, 0, 0, 'N', 0, NULL, NULL^);
	ECHO INSERT INTO TRIBUTACAO ^(TRBID, TRBSIM, TRBCOD, TRBDES, TRBALQ, TRBRED, TRBTABB, TRBINC, TRBOBS, TRBREDINT, TRBOBSINT, TRBSISIF, TRBREDSISIF, TRBOBSSISIF, TRBSIMECF, TRBALQECF, TRBCFOP, TRBCFOPINTER, TRBCSOSN, TRBALQINTER, TRBBASE, TRBBASESAI, TRBBASEST, TRBBASESTSAI, TRBALQENT, TRBREDENT, TRBTABBENT, TRBCFOPENT, TRBCFOPENTINTER, TRBCSOSNENT, TRBINCENT, TRBCFOPSAI, TRBTABBINT, TRBOPENFSE, TRBTABBCUP, TRBCSOSNCUP, TRBALQFCP, TRBREDCUP, TRBCONREDSTSAI, TRBTABBCFE, TRBALQCFE, TRBDIFNFE, TRBDIFNFCE, TRBSOMICMSUBPROD, TRBALQST, TRBCONALQST, TRBSOMABCNOICMS^) VALUES ^('T27', 'T', '27', 'TRIBUTADO 27', 27, 0, '00', 0, '', 0, '', 'N', 0, NULL, 'T', 27, '51020', '61020', %TRIBUTADO%, 0, 'N', 'N', 'N', 'N', 27, 0, '00', '11020', '21020', %TRIBUTADO%, 0, '51020', '00', '', '00', %TRIBUTADO%, 0, 0, 'S', '00', 27, 0, 0, 'N', 0, NULL, NULL^);
	ECHO INSERT INTO TRIBUTACAO ^(TRBID, TRBSIM, TRBCOD, TRBDES, TRBALQ, TRBRED, TRBTABB, TRBINC, TRBOBS, TRBREDINT, TRBOBSINT, TRBSISIF, TRBREDSISIF, TRBOBSSISIF, TRBSIMECF, TRBALQECF, TRBCFOP, TRBCFOPINTER, TRBCSOSN, TRBALQINTER, TRBBASE, TRBBASESAI, TRBBASEST, TRBBASESTSAI, TRBALQENT, TRBREDENT, TRBTABBENT, TRBCFOPENT, TRBCFOPENTINTER, TRBCSOSNENT, TRBINCENT, TRBCFOPSAI, TRBTABBINT, TRBOPENFSE, TRBTABBCUP, TRBCSOSNCUP, TRBALQFCP, TRBREDCUP, TRBCONREDSTSAI, TRBTABBCFE, TRBALQCFE, TRBDIFNFE, TRBDIFNFCE, TRBSOMICMSUBPROD, TRBALQST, TRBCONALQST, TRBSOMABCNOICMS^) VALUES ^('T90', 'T', '90', 'TRIBUTADO CST 90', 20, 0, '90', 0, '', 0, '', 'N', 0, NULL, 'T', 20, '54050', '64050', %TRIBUTADO%, 0, 'N', 'N', 'N', 'N', 20, 0, '90', '14050', '24050', %TRIBUTADO%, 0, '54050', '90', '', '90', %TRIBUTADO%, 0, 0, 'S', '90', 20, 0, 0, 'N', 0, NULL, NULL^);
	ECHO COMMIT;
	ECHO.
	ECHO UPDATE ECF SET ECFATIVO = 'N';
	ECHO COMMIT;
	ECHO UPDATE ECF SET ECFATIVO = 'S' WHERE ECFCOD IN^('96', '97', '98', '99'^);
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"
	
:IMPOSTOS_FEDERAIS

IF "%REGIME%"=="1" (
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('01', 'PIS TRIBUTADO', NULL, %ALQ_PIS%, 0, %ALQ_PIS%, 0, 0, 0, 0, '', '', 'P', '50', '', '98', '01', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('02', 'COFINS TRIBUTADO', NULL, %ALQ_COFINS%, 0, %ALQ_COFINS%, 0, 0, 0, 0, '', '', 'C', '50', '', '98', '01', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('03', 'PIS MONOFASICO', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'P', '70', '', '98', '04', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('04', 'COFINS MONOFASICO', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'C', '70', '', '98', '04', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('05', 'PIS ALIQUOTA 0', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'P', '73', '', '98', '06', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('06', 'COFINS ALIQUOTA 0', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'C', '73', '', '98', '06', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('07', 'PIS SUBST', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'P', '75', '', '98', '05', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('08', 'COFINS SUBST', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'C', '75', '', '98', '05', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('09', 'PIS S/ INCIDENCIA', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'P', '74', '', '98', '08', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('10', 'COFINS S/ INCIDENCIA', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'C', '74', '', '98', '08', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('11', 'PIS SUSPESAO', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'P', '72', '', '98', '09', '', NULL^);
	ECHO INSERT INTO IMPOSTOS_FEDERAIS ^(IMPFEDSIM, IMPFEDDES, IMPFEDINC, IMPFEDALQ, IMPFEDALQATA, IMPFEDALQSAI, IMPFEDALQSAIATA, IMPFEDALQSIM, IMPFEDRET, IMPFEDRETSAI, IPMFEDOBS, IPMFEDOBSSAI, IMPFEDTIP, IMPFEDST, IMPFEDSTATA, IMPFEDSTSIM, IMPFEDSTSAI, IMPFEDSTSAIATA, IMPFEDNATBAS^) VALUES ^('12', 'COFINS SUSPENSAO', NULL, 0, 0, 0, 0, 0, 0, 0, '', '', 'C', '72', '', '98', '09', '', NULL^);
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"

IF "%MIDI_PRODUTO%"=="1" (
	ECHO INSERT INTO IMPOSTOS_FEDERAIS_PRODUTO
	ECHO SELECT 
	ECHO 	'%IMPFEDSIM_PIS%' AS IMPFEDSIM, 
	ECHO 	PROCOD AS PROCOD
	ECHO FROM PRODUTO;
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"

IF "%MIDI_PRODUTO%"=="1" (
	ECHO INSERT INTO IMPOSTOS_FEDERAIS_PRODUTO 
	ECHO SELECT
	ECHO 	'%IMPFEDSIM_COFINS%' AS IMPFEDSIM, 
	ECHO 	PROCOD AS PROCOD
	ECHO FROM PRODUTO;
	ECHO COMMIT;
	ECHO.
	) >> "%EXP_PATH%\OUTRAS_INFORMACOES.SQL"
	
	:: Exportando os Dados do MidiPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [Exportando os Dados]
	ECHO.
	ECHO               MidiPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [Exportando os Dados]
	ECHO.
	ECHO               MidiPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
ECHO INPUT '%MIGR_ARQ%'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_MIDIPDV%" >> "%LOG_PATH%" 2>&1
(ECHO [SUCESSO]) >> "%LOG_PATH%"
TIMEOUT /T 2
CLS

	:: Importando os Dados no SysPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [Importando os Dados]
	ECHO.
	ECHO               SysPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO        [Importando os Dados]
	ECHO.
	ECHO               SysPDV
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	TIMEOUT /T 2
	CLS
	
IF EXIST "%EXP_PATH%\MIDI_FUNCIONARIO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            [FUNCIONARIO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            [FUNCIONARIO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_FUNCIONARIO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)

IF EXIST "%EXP_PATH%\MIDI_FINALIZADORA.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [FINALIZADORA]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [FINALIZADORA]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_FINALIZADORA.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_SECAO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [SECAO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [SECAO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_SECAO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_GRUPO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [GRUPO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO               [GRUPO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_GRUPO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_SUBGRUPO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [SUBGRUPO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [SUBGRUPO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_SUBGRUPO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_PRODUTO.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [PRODUTO]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [PRODUTO]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_PRODUTO.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	IF "%MIDI_GRUPO%"=="0" (ECHO UPDATE PRODUTO SET GRPCOD = '000'; UPDATE PRODUTO SET SGRCOD = '000'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" > NUL)
	IF "%MIDI_SUBGRUPO%"=="0" (ECHO UPDATE PRODUTO SET SGRCOD = '000'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" > NUL)
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_PRODUTOAUX.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [PRODUTOAUX]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [PRODUTOAUX]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_PRODUTOAUX.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_ESTOQUE.SQL" (	
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [ESTOQUE]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [ESTOQUE]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_ESTOQUE.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_SIMILARES.SQL" (	
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [SIMILARES]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [SIMILARES]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_SIMILARES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_ITEM_SIMILARES.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [ITEM_SIMILARES]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [ITEM_SIMILARES]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_ITEM_SIMILARES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_FORNECEDOR.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [FORNECEDOR]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [FORNECEDOR]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_FORNECEDOR.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_CLIENTE.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [CLIENTES]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              [CLIENTES]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_CLIENTE.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\MIDI_CONTARECEBER.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [CONTA_RECEBER]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           [CONTA_RECEBER]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\MIDI_CONTARECEBER.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)
	
IF EXIST "%EXP_PATH%\OUTRAS_INFORMACOES.SQL" (
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO         [OUTRAS_INFORMACOES]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO         [OUTRAS_INFORMACOES]
	ECHO.
	ECHO   ==================================
	ECHO.
	)  >> "%LOG_PATH%"
	ECHO INPUT '%EXP_PATH%\OUTRAS_INFORMACOES.SQL'; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% "%DB_SYSPDV%" >> "%LOG_PATH%" 2>&1
	TIMEOUT /T 2
	CLS
	)

START C:\Syspdv\Syspdv_server.exe
START %LOG_PATH%
ECHO.
ECHO   ==================================
ECHO.
ECHO         [Migracao Concluida]
ECHO.
ECHO      Verifique o Log de Migracao
ECHO.
ECHO       %LOG_PATH%
ECHO.
ECHO   ==================================
ECHO.
	
PAUSE
GOTO END

:END
	EXIT