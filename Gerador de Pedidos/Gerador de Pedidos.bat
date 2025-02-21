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

:ITENS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Qual a QUANTIDADE DE ITENS?
    ECHO.
    ECHO              [MAX. 250]
	ECHO.
	ECHO   ==================================
	ECHO.
	SET /P ITENS=" Digite a Quantidade de Itens por Nota: "
	CLS

:EXPORTACAO
    (
    ECHO SET HEADING OFF;
    ECHO.
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
    ECHO 	WHERE E.ESTATU > '0' AND P.PROFORLIN = 'N'^),
    ECHO SEQUENCIA AS ^(
    ECHO 	-- GERA A SEQUÊNCIA DE NÚMEROS DE PEDIDOS NECESSÁRIA, EVITANDO REFERÊNCIA A CTES DENTRO DO PRÓPRIO `WHERE`.
    ECHO 	SELECT ^(SELECT ULTIMO_PVDNUM FROM ULTIMO_PEDIDO^) + 1 AS PVDNUM, 0 AS ITERACAO
    ECHO 		FROM RDB$DATABASE
    ECHO 	UNION ALL
    ECHO 	SELECT PVDNUM + 1, ITERACAO + 1
    ECHO 		FROM SEQUENCIA
    ECHO 	WHERE ITERACAO < ^(SELECT QTD_PEDIDOS FROM QUANTIDADE_PEDIDOS_NECESSARIOS^)
    ECHO ^)
    ECHO 	-- SELEÇÃO DOS DADOS PARA INSERIR NOVOS PEDIDOS
    ECHO SELECT 
    ECHO 	'INSERT INTO PEDIDO_VENDA ^(PVDNUM, FUNCOD, CLICOD, PVDTIPPRC, PVDDATEMI, PVDHOREMI, PVDSTATUS, PVDDOCIMP, PVDOBS, PVDVLR, PVDDCN, PVDACR, PVDBLODCN, PVDBLOEST, PVDBLOLIMCRD, PVDCLIDES, PVDCLIEND, PVDCLIBAI, PVDCLICID, PVDCLIEST, PVDCLINUM, PVDCLICEP, PVDCLICPFCGC, PVDBLODCN, CLITEL, PVDTIPEFET, OPECOD, CFOCOD, PVDTIPFRT, PVDDATPREV, PVDHORPREV, PVDTIPATD, PVDLOCCOD^) VALUES ^(''' ^|^| 
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
    ECHO.
    ) > "%GERADOR_ARQ%"