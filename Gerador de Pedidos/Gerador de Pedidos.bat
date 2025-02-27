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

SET ISC_USER=SYSDBA
SET ISC_PASSWORD=masterkey

SET DB_SYSPDV=C:\SYSPDV\SYSPDV_SRV.FDB

SET GERADOR_PATH=C:\SYSPDV\GERADOR_PEDIDO
SET EXP_PATH=%GERADOR_PATH%\EXP
SET GERADOR_ARQ=%GERADOR_PATH%\Arquivo_Gerador.sql
SET LOG_PATH=%GERADOR_PATH%\Log_Gerador.txt

	:: Configura Caminho do Firebird
IF EXIST "C:\Program Files (x86)\Firebird\Firebird_2_5\bin" (
	SET FIREBIRD_PATH="C:\Program Files (x86)\Firebird\Firebird_2_5\bin"
) ELSE (
	SET FIREBIRD_PATH="C:\Program Files\Firebird\Firebird_2_5\bin"
)

	:: Verifica se o diretório existe
IF EXIST "%GERADOR_PATH%" (
    RD /S /Q "%GERADOR_PATH%"
)

	:: Cria o diretório
MD "%GERADOR_PATH%"

CD /D %FIREBIRD_PATH%

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

	:: Verificar se o Banco Existe
IF NOT EXIST "%DB_SYSPDV%" (
    ECHO.
    ECHO   ==================================
    ECHO.
	ECHO                [ ERRO ]
	ECHO.
    ECHO     Banco de Dados NAO encontrado!
    ECHO.
    ECHO   ==================================
    ECHO.
    PAUSE
	GOTO END
) 

:FUNCIONARIO
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO          Qual o FUNCIONARIO?
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P FUNCIONARIO=" Digite o Cod. do Funcionario: "
	CLS
IF "%FUNCIONARIO%"=="" (
    CLS
    ECHO.
    ECHO   ==================================
    ECHO.
    ECHO      O campo NAO pode ficar vazio!
    ECHO.
    ECHO   ==================================
    ECHO.
    PAUSE
    CLS
    GOTO FUNCIONARIO
)

:CLIENTE
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            Qual o CLIENTE?
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P CLIENTE=" Digite o Cod. do Cliente: "
	CLS
IF "%CLIENTE%"=="" (
    CLS
    ECHO.
    ECHO   ==================================
    ECHO.
    ECHO      O campo NAO pode ficar vazio!
    ECHO.
    ECHO   ==================================
    ECHO.
    PAUSE
    CLS
    GOTO CLIENTE
)

:OPERACAO
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            Qual a OPERACAO?
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P OPERACAO=" Digite a Operacao da Nota: "
	CLS
IF "%OPERACAO%"=="" (
    CLS
    ECHO.
    ECHO   ==================================
    ECHO.
    ECHO      O campo NAO pode ficar vazio!
    ECHO.
    ECHO   ==================================
    ECHO.
    PAUSE
    CLS
    GOTO OPERACAO
)

:CFOP
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO              Qual o CFOP?
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P CFOP=" Digite o CFOP da Nota: "
	CLS
IF "%CFOP%"=="" (
    CLS
    ECHO.
    ECHO   ==================================
    ECHO.
    ECHO      O campo NAO pode ficar vazio!
    ECHO.
    ECHO   ==================================
    ECHO.
    PAUSE
    CLS
    GOTO CFOP
)

:ITENS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Qual a QUANTIDADE DE ITENS?
    ECHO.
    ECHO             [ MAX. 250 ]
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P ITENS=" Digite a Quantidade de Itens por Nota: "
	CLS
IF "%ITENS%"=="" (
    CLS
    ECHO.
    ECHO   ==================================
    ECHO.
    ECHO      O campo NAO pode ficar vazio!
    ECHO.
    ECHO   ==================================
    ECHO.
    PAUSE
    CLS
    GOTO ITENS
)

:CUSTO
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO           Usar PRECO DE CUSTO?
    ECHO.
    ECHO                1 - Sim
    ECHO.
    ECHO                2 - Nao
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P CUSTO=" Digite a Opcao: "
	CLS

        :: Validação de entrada CUSTO
    IF "%CUSTO%" NEQ "1" IF "%CUSTO%" NEQ "2" (
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
        GOTO CUSTO
    )

IF "%CUSTO%" EQU "1" ( 
    SET CUSTO=SIM
        ) ELSE ( 
    SET CUSTO=NAO
    )

:PARAMETROS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO          [ FUNCIONARIO: %FUNCIONARIO% ]
	ECHO.
	ECHO          [ CLIENTE: %CLIENTE% ]
	ECHO.
	ECHO          [ OPERACAO: %OPERACAO% ]
	ECHO.
	ECHO          [ CFOP: %CFOP% ]
	ECHO.
	ECHO          [ QTD. ITENS: %ITENS% ]
	ECHO.
	ECHO          [ PRC. CUSTO: %CUSTO% ]
	ECHO.
	ECHO   ==================================
	ECHO.
	(
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO          [ FUNCIONARIO: %FUNCIONARIO% ]
		ECHO.
		ECHO          [ CLIENTE: %CLIENTE% ]
		ECHO.
		ECHO          [ OPERACAO: %OPERACAO% ]
		ECHO.
		ECHO          [ CFOP: %CFOP% ]
		ECHO.
		ECHO          [ QTD. ITENS: %ITENS% ]
		ECHO.
		ECHO          [ PRC. CUSTO: %CUSTO% ]
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> "%LOG_PATH%"
	TIMEOUT /T 3
	CLS

:EXPORTACAO
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            [ EXPORTANDO ]
	ECHO.
	ECHO       Dados dos PEDIDOS DE VENDA
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO   Processando...
	(
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO             [ EXPORTANDO ]
		ECHO.
		ECHO       Dados dos PEDIDOS DE VENDA
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> "%LOG_PATH%"

	(
    ECHO SET HEADING OFF;
    ECHO.
    ECHO OUTPUT "%GERADOR_PATH%\PEDIDO_VENDA.SQL";
    ECHO 	-- CRIA SEQUÊNCIA DE NÚMEROS DE PEDIDO COM BASE NO ESTOQUE.
    ECHO WITH RECURSIVE ULTIMO_PEDIDO AS ^(
    ECHO 	-- OBTÉM O ÚLTIMO NÚMERO DE PEDIDO OU INICIA EM 1 SE NÃO HOUVER REGISTROS.
    ECHO 	SELECT COALESCE^(MAX^(CAST^(PVDNUM AS INTEGER^)^), 0^) AS ULTIMO_PVDNUM
    ECHO 		FROM PEDIDO_VENDA^),
    ECHO QUANTIDADE_PEDIDOS_NECESSARIOS AS ^(
    ECHO 	-- CALCULA A QUANTIDADE NECESSÁRIA DE PEDIDOS CONSIDERANDO O ESTOQUE DOS PRODUTOS DISPONÍVEL E O NÚMERO DE ITENS POR PEDIDO.
    ECHO 	SELECT CEIL^(COUNT^(*^) / CAST^('%ITENS%' AS INTEGER^)^) AS QTD_PEDIDOS
    ECHO 		FROM ESTOQUE E
    ECHO 		JOIN PRODUTO P ON P.PROCOD = E.PROCOD
    ECHO 	WHERE E.ESTATU ^> '0' AND P.PROFORLIN = 'N'^),
    ECHO SEQUENCIA AS ^(
    ECHO 	-- GERA A SEQUÊNCIA DE NÚMEROS DE PEDIDOS NECESSÁRIA, EVITANDO REFERÊNCIA A CTES DENTRO DO PRÓPRIO `WHERE`.
    ECHO 	SELECT ^(SELECT ULTIMO_PVDNUM FROM ULTIMO_PEDIDO^) + 1 AS PVDNUM, 0 AS ITERACAO
    ECHO 		FROM RDB$DATABASE
    ECHO 	UNION ALL
    ECHO 	SELECT PVDNUM + 1, ITERACAO + 1
    ECHO 		FROM SEQUENCIA
    ECHO 	WHERE ITERACAO ^< ^(SELECT QTD_PEDIDOS FROM QUANTIDADE_PEDIDOS_NECESSARIOS^)
    ECHO ^)
    ECHO 	-- SELEÇÃO DOS DADOS PARA INSERIR NOVOS PEDIDOS
    ECHO SELECT 
    ECHO 	'INSERT INTO PEDIDO_VENDA ^(PVDNUM, FUNCOD, CLICOD, PVDTIPPRC, PVDDATEMI, PVDHOREMI, PVDSTATUS, PVDDOCIMP, PVDOBS, PVDVLR, PVDDCN, PVDACR, PVDBLODCN, PVDBLOEST, PVDBLOLIMCRD, PVDCLIDES, PVDCLIEND, PVDCLIBAI, PVDCLICID, PVDCLIEST, PVDCLINUM, PVDCLICEP, PVDCLICPFCGC, PVDCLITEL, PVDTIPEFET, OPECOD, CFOCOD, PVDTIPFRT, PVDDATPREV, PVDHORPREV, PVDTIPATD, PVDLOCCOD^) VALUES ^(''' ^|^| 
    ECHO 	LPAD^(S.PVDNUM, 10, '0'^) ^|^| ''', ''' ^|^|
    ECHO 	LPAD^(CAST^('%FUNCIONARIO%' AS INTEGER^), 6, '0'^) ^|^| ''', ''' ^|^|
    ECHO 	C.CLICOD ^|^| ''', ''' ^|^|
    ECHO 	'1' ^|^| ''', ''' ^|^|
    ECHO 	CURRENT_DATE ^|^| ''', ''' ^|^|
    ECHO 	SUBSTRING^(REPLACE^(CURRENT_TIME, ':', ''^) FROM 1 FOR 4^) ^|^| ''', ''' ^|^|
    ECHO 	'A' ^|^| ''', ''' ^|^|
    ECHO 	'N' ^|^| ''', ''' ^|^|
    ECHO 	'GERADOR DE PEDIDOS' ^|^| ''', ''' ^|^|
    ECHO 	0 ^|^| ''', ''' ^|^|
    ECHO 	0 ^|^| ''', ''' ^|^|
    ECHO 	0 ^|^| ''', ''' ^|^|
    ECHO 	'N' ^|^| ''', ''' ^|^|
    ECHO 	'N' ^|^| ''', ''' ^|^|
    ECHO 	'N' ^|^| ''', ''' ^|^|
    ECHO 	C.CLIDES ^|^| ''', ''' ^|^|
    ECHO 	C.CLIEND ^|^| ''', ''' ^|^|
    ECHO 	C.CLIBAI ^|^| ''', ''' ^|^|
    ECHO 	C.CLICID ^|^| ''', ''' ^|^|
    ECHO 	C.CLIEST ^|^| ''', ''' ^|^|
    ECHO 	COALESCE^(NULLIF^(C.CLINUM, ''^), 'S/N'^) ^|^| ''', ''' ^|^|
    ECHO 	C.CLICEP ^|^| ''', ''' ^|^|
    ECHO 	C.CLICPFCGC ^|^| ''', ''' ^|^|
    ECHO 	C.CLITEL ^|^| ''', ''' ^|^|
    ECHO 	'2' ^|^| ''', ''' ^|^|
    ECHO 	LPAD^(CAST^('%OPERACAO%' AS INTEGER^), 4, '0'^) ^|^| ''', ''' ^|^|
    ECHO 	RPAD^(CAST^('%CFOP%' AS INTEGER^), 5, '0'^) ^|^| ''', ''' ^|^|
    ECHO 	'CIF' ^|^| ''', ''' ^|^|
    ECHO 	CURRENT_DATE ^|^| ''', ''' ^|^|
    ECHO 	SUBSTRING^(REPLACE^(CURRENT_TIME, ':', ''^) FROM 1 FOR 4^) ^|^| ''', ''' ^|^|
    ECHO 	'B' ^|^| ''', ''' ^|^|
    ECHO 	'01' ^|^| '''^); COMMIT;' 
    ECHO FROM CLIENTE C
    ECHO 	CROSS JOIN SEQUENCIA S
    ECHO 	WHERE C.CLICOD = LPAD^(CAST^('%CLIENTE%' AS INTEGER^), 15, '0'^);
    ECHO.
    ECHO OUTPUT "%GERADOR_PATH%\PEDIDO_VENDA_ITENS.SQL";
	ECHO 	-- SCRIPT PARA GERAR ITENS DE PEDIDO DE VENDA COM BASE NO ESTOQUE DISPONIVEL;
	ECHO WITH C AS ^(
	ECHO 	SELECT
	ECHO 		-- VERIFICA SE LAST_PVDNUM ESTÁ INICIALIZADO, CASO CONTRÁRIO, INICIALIZA.
	ECHO 		COALESCE^(RDB$GET_CONTEXT^('USER_TRANSACTION', 'LAST_PVDNUM'^), 
	ECHO 			RDB$SET_CONTEXT^('USER_TRANSACTION', 'LAST_PVDNUM', 1^)^) AS CHECK_LAST_PVDNUM,
	ECHO.
	ECHO 		-- INICIALIZA SEQ_ATUAL COMO 1 SE AINDA NÃO ESTIVER NO CONTEXTO.
	ECHO 		COALESCE^(RDB$GET_CONTEXT^('USER_TRANSACTION', 'SEQ_ATUAL'^), 
	ECHO 			RDB$SET_CONTEXT^('USER_TRANSACTION', 'SEQ_ATUAL', 1^)^) AS CHECK_SEQ_ATUAL,
	ECHO.
	ECHO 		-- VERIFICA SE O VALOR DE PVDNUM MUDOU EM RELAÇÃO AO ÚLTIMO VALOR SALVO NA SESSÃO.
	ECHO 		-- SE MUDOU, RESETA O VALOR DE SEQ_ATUAL PARA 1; CASO CONTRÁRIO, INCREMENTA.
	ECHO 		CASE 
	ECHO 			WHEN LPAD^(
	ECHO 				-- CALCULA O VALOR DE PVDNUM DIVIDINDO O NÚMERO DE PRODUTOS COM ESTOQUE DISPONÍVEL
	ECHO 				-- PELA QUANTIDADE DE ITENS POR PEDIDO E SOMANDO O VALOR DO PRIMEIRO PEDIDO.
	ECHO 				^(SELECT COUNT^(*^) FROM ESTOQUE E2 
	ECHO 					JOIN PRODUTO P ON P.PROCOD = E2.PROCOD
	ECHO 					WHERE E2.ESTATU ^> '0' AND P.PROFORLIN = 'N' AND E2.PROCOD ^<= E.PROCOD^) / 
	ECHO 					CAST^('%ITENS%' AS INTEGER^) + 
	ECHO 					^(SELECT COALESCE^(CAST^(MAX^(PVDNUM^) AS INTEGER^), 0^) + 1 FROM PEDIDO_VENDA^), 10, '0'^) 
	ECHO 				-- COMPARA COM O VALOR ARMAZENADO NO CONTEXTO DA SESSÃO.
	ECHO 				^<^> RDB$GET_CONTEXT^('USER_TRANSACTION', 'LAST_PVDNUM'^)
	ECHO 			-- SE O VALOR MUDOU, RESETA O SEQ_ATUAL PARA 1.
	ECHO 			THEN RDB$SET_CONTEXT^('USER_TRANSACTION', 'SEQ_ATUAL', 1^)
	ECHO 			-- CASO CONTRÁRIO, INCREMENTA O SEQ_ATUAL.
	ECHO 			ELSE RDB$SET_CONTEXT^('USER_TRANSACTION', 'SEQ_ATUAL', 
	ECHO 			CAST^(RDB$GET_CONTEXT^('USER_TRANSACTION', 'SEQ_ATUAL'^) AS INTEGER^) + 1^)
	ECHO 		END AS S,
	ECHO.
	ECHO 		-- ATUALIZA O VALOR DE LAST_PVDNUM NO CONTEXTO DA SESSÃO PARA O VALOR ATUAL DE PVDNUM
	ECHO 		RDB$SET_CONTEXT^('USER_TRANSACTION', 'LAST_PVDNUM', 
	ECHO 			LPAD^(^(SELECT COUNT^(*^) 
	ECHO 				FROM ESTOQUE E2 
	ECHO 				JOIN PRODUTO P ON P.PROCOD = E2.PROCOD
	ECHO 				WHERE E2.ESTATU ^> '0' AND P.PROFORLIN = 'N' AND E2.PROCOD ^<= E.PROCOD^) / 
	ECHO 				CAST^('%ITENS%' AS INTEGER^) + 
	ECHO 				^(SELECT COALESCE^(CAST^(MAX^(PVDNUM^) AS INTEGER^), 0^) + 1 FROM PEDIDO_VENDA^), 10, '0'^)^) AS PVDNUM,
	ECHO.
	ECHO 		-- ARMAZENA O VALOR ATUAL DE SEQ_ATUAL A PARTIR DO CONTEXTO DA SESSÃO
	ECHO 		CAST^(RDB$GET_CONTEXT^('USER_TRANSACTION', 'SEQ_ATUAL'^) AS INTEGER^) AS G FROM RDB$DATABASE
	ECHO ^)
	ECHO SELECT
	ECHO	'INSERT INTO PEDIDO_VENDA_ITEM ^(PVISEQ, PVDNUM, PROCOD, PVIQTD, PVIVLRUNI, PVIVLRDCN, PVITIPDCN, PVIVLRACR, PVITIPACR, PVITRBID, PVIALQICMS, PVIITEEMB, PVIPRODES, PVIPRODESDZ, PVIFUNCOD, PVIPRCPRAT, PVIQTDATD, PVIPRCVDA, PVIPRODESVAR, PVIALQPIS, PVICSTPIS, PVIALQCOF, PVICSTCOF^) VALUES ^(''' ^|^| 
	ECHO 	-- OBTÉM O VALOR DE SEQ_ATUAL DO CTE ANTERIOR
	ECHO 	^(SELECT C.G FROM C WHERE C.S ^>= 0^) ^|^| ''', ''' ^|^|
	ECHO 	LPAD^(^(SELECT COUNT^(*^) 
	ECHO 		FROM ESTOQUE E2 
	ECHO 		JOIN PRODUTO P ON P.PROCOD = E2.PROCOD
	ECHO 		WHERE E2.ESTATU ^> '0' AND P.PROFORLIN = 'N' AND E2.PROCOD ^<= E.PROCOD^) /
	ECHO 		CAST^('%ITENS%' AS INTEGER^) + 
	ECHO 		^(SELECT COALESCE^(CAST^(MAX^(PVDNUM^) AS INTEGER^), 0^) + 1 FROM PEDIDO_VENDA^), 10, '0'^) ^|^| ''', ''' ^|^|
	ECHO 	E.PROCOD ^|^| ''', ''' ^|^|
	ECHO 	E.ESTATU ^|^| ''', ''' ^|^|
	ECHO 	IIF^(UPPER^('%CUSTO%'^) = 'SIM', COALESCE^(NULLIF^(P.PROPRCCST, '0'^), P.PROPRCVDAVAR^), COALESCE^(NULLIF^(P.PROPRCVDAVAR, '0'^), P.PROPRCCST^)^) ^|^| ''', ''' ^|^|
	ECHO 	'0' ^|^| ''', ''' ^|^|
	ECHO 	'P' ^|^| ''', ''' ^|^|
	ECHO 	'0' ^|^| ''', ''' ^|^|
	ECHO 	'V' ^|^| ''', ''' ^|^|
	ECHO 	P.TRBID ^|^| ''', ''' ^|^|
	ECHO 	T.TRBALQ ^|^| ''', ''' ^|^|
	ECHO 	P.PROITEEMB ^|^| ''', ''' ^|^|
	ECHO 	REPLACE^(P.PRODES, '''', ''^) ^|^| ''', ''' ^|^|
	ECHO 	REPLACE^(P.PRODESRDZ, '''', ''^) ^|^| ''', ''' ^|^|
	ECHO 	LPAD^(CAST^('%FUNCIONARIO%' AS INTEGER^), 6, '0'^) ^|^| ''', ''' ^|^|
	ECHO 	'1' ^|^| ''', ''' ^|^|
	ECHO 	'0' ^|^| ''', ''' ^|^|
	ECHO 	IIF^(UPPER^('%CUSTO%'^) = 'SIM', COALESCE^(NULLIF^(P.PROPRCCST, '0'^), P.PROPRCVDAVAR^), COALESCE^(NULLIF^(P.PROPRCVDAVAR, '0'^), P.PROPRCCST^)^) ^|^| ''', ''' ^|^|
	ECHO 	COALESCE^(P.PRODESVAR, 'N'^) ^|^| ''', ''' ^|^|
	ECHO 	-- CALCULA IMPOSTOS FEDERAIS ^(PIS, COFINS^) UTILIZANDO SUBCONSULTAS SIMPLIFICADAS
	ECHO 	CAST^(COALESCE^(
	ECHO 		^(SELECT FIRST^(1^) IF.IMPFEDALQ
	ECHO 		FROM IMPOSTOS_FEDERAIS_PRODUTO IFP 
	ECHO 		JOIN IMPOSTOS_FEDERAIS IF ON IF.IMPFEDSIM = IFP.IMPFEDSIM
	ECHO 		WHERE IF.IMPFEDTIP = 'P'
	ECHO 		AND IFP.PROCOD = P.PROCOD^), '0'^) AS NUMERIC^(15,2^)^) ^|^| ''', ''' ^|^|
	ECHO 	COALESCE^(
	ECHO 		^(SELECT FIRST^(1^) IF.IMPFEDSTSAI
	ECHO 		FROM IMPOSTOS_FEDERAIS_PRODUTO IFP 
	ECHO 		JOIN IMPOSTOS_FEDERAIS IF ON IF.IMPFEDSIM = IFP.IMPFEDSIM
	ECHO 		WHERE IF.IMPFEDTIP = 'P'
	ECHO 		AND IFP.PROCOD = P.PROCOD^), '49'^) ^|^| ''', ''' ^|^|
	ECHO 	CAST^(COALESCE^(
	ECHO 		^(SELECT FIRST^(1^) IF.IMPFEDALQ
	ECHO 		FROM IMPOSTOS_FEDERAIS_PRODUTO IFP 
	ECHO 		JOIN IMPOSTOS_FEDERAIS IF ON IF.IMPFEDSIM = IFP.IMPFEDSIM
	ECHO 		WHERE IF.IMPFEDTIP = 'C'
	ECHO 		AND IFP.PROCOD = P.PROCOD^), '0'^) AS NUMERIC^(15,2^)^) ^|^| ''', ''' ^|^|
	ECHO 	COALESCE^(
	ECHO 		^(SELECT FIRST^(1^) IF.IMPFEDSTSAI
	ECHO 		FROM IMPOSTOS_FEDERAIS_PRODUTO IFP 
	ECHO 		JOIN IMPOSTOS_FEDERAIS IF ON IF.IMPFEDSIM = IFP.IMPFEDSIM
	ECHO 		WHERE IF.IMPFEDTIP = 'C'
	ECHO 		AND IFP.PROCOD = P.PROCOD^), '49'^) ^|^| '''^); COMMIT;' 
	ECHO FROM ESTOQUE E
	ECHO 	INNER JOIN PRODUTO P ON P.PROCOD = E.PROCOD
	ECHO 	INNER JOIN TRIBUTACAO T ON T.TRBID = P.TRBID
	ECHO WHERE E.ESTATU ^> '0' AND P.PROFORLIN = 'N'
	ECHO 	ORDER BY E.PROCOD;
    ) > "%GERADOR_ARQ%"

ECHO INPUT "%GERADOR_ARQ%"; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% %DB_SYSPDV% >> "%LOG_PATH%" 2>&1
TIMEOUT /T 2
CLS

:IMPORTACAO
		:: PEDIDO DE VENDA
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            [ IMPORTANDO ]
	ECHO.
	ECHO           PEDIDOS DE VENDA
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO   Processando...
	(
		ECHO.
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO            [ IMPORTANDO ]
		ECHO.
		ECHO           PEDIDOS DE VENDA
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> "%LOG_PATH%"

ECHO INPUT "%GERADOR_PATH%\PEDIDO_VENDA.SQL"; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% %DB_SYSPDV% >> "%LOG_PATH%" 2>&1
TIMEOUT /T 2
CLS

		:: PEDIDO DE VENDA ITENS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            [ IMPORTANDO ]
	ECHO.
	ECHO        PEDIDOS DE VENDA ITENS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO   Processando...
	(
		ECHO.
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO            [ IMPORTANDO ]
		ECHO.
		ECHO        PEDIDOS DE VENDA ITENS
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> "%LOG_PATH%"

ECHO INPUT "%GERADOR_PATH%\PEDIDO_VENDA_ITENS.SQL"; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% %DB_SYSPDV% >> "%LOG_PATH%" 2>&1
TIMEOUT /T 2
CLS

		:: VALOR TOTAL DOS PEDIDOS
	(
	ECHO UPDATE PEDIDO_VENDA PV
	ECHO 	SET PV.PVDVLR = ^(
	ECHO 		SELECT CAST^(ROUND^(ROUND^(ROUND^(SUM^(PVIVLRUNI * PVIQTD^), 4^), 3^), 2^) AS NUMERIC^(15,2^)^)
	ECHO 			FROM PEDIDO_VENDA_ITEM PVI
	ECHO 			WHERE PVI.PVDNUM = PV.PVDNUM
	ECHO 	^)
	ECHO 	WHERE PV.PVDOBS = 'GERADOR DE PEDIDOS';
	) > "%GERADOR_PATH%\PEDIDO_VENDA_VALOR.SQL"

	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            [ ATUALIZANDO ]
	ECHO.
	ECHO        PEDIDOS DE VENDA VALOR
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO   Processando...
	(
		ECHO.
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO            [ ATUALIZANDO ]
		ECHO.
		ECHO        PEDIDOS DE VENDA VALOR
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> "%LOG_PATH%"

ECHO INPUT "%GERADOR_PATH%\PEDIDO_VENDA_VALOR.SQL"; | ISQL -USER %ISC_USER% -PASSWORD %ISC_PASSWORD% %DB_SYSPDV% >> "%LOG_PATH%" 2>&1
TIMEOUT /T 2
CLS

:END
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO             [ FINALIZADO ]
	ECHO.
	ECHO       %DATE% as %TIME%
	ECHO.
	ECHO   ==================================
	ECHO.
	(
		ECHO.
		ECHO.
		ECHO   ==================================
		ECHO.
		ECHO             [ FINALIZADO ]
		ECHO.
		ECHO       %DATE% as %TIME%
		ECHO.
		ECHO   ==================================
		ECHO.
	) >> "%LOG_PATH%"
START %LOG_PATH%
TIMEOUT /T 2
EXIT
