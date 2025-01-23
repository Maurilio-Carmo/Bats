@ECHO OFF

COLOR 6
SETLOCAL ENABLEDELAYEDEXPANSION

	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO      Script para Renomear XML's
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE

:INI
	:: Caminho para a pasta com os arquivos XML
CLS
ECHO.
SET /P caminho_pasta=" Digite o caminho da pasta com os arquivos XML: "
ECHO.

	:: Navegar até a pasta especificada
CD /d "%caminho_pasta%" || (
	CLS
	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO            Caminho invalido!
	ECHO.
	ECHO   Certifique que o diretorio existe.
	ECHO.
	ECHO   ==================================
	ECHO.
	PAUSE
	GOTO INI
)

:LOOP
	:: Loop através de todos os arquivos XML na pasta
FOR %%f in (*.xml) do (

	:: Obter o nome do arquivo sem a extensão
	SET "nome_arquivo=%%~nf"

	:: Procurar pelo segundo sublinhado e obter a parte desejada
	FOR /f "tokens=3,4 delims=_" %%a IN ("!nome_arquivo!") DO (
		IF "%%b"=="" (
			SET "novo_nome=%%a.xml"
			) ELSE (
			SET "novo_nome=%%a_%%b.xml"
			)
		:: Renomear o arquivo
		REN "%%f" "!novo_nome!"
		)
	)

	ECHO.
	ECHO   ==================================
	ECHO.
	ECHO          Renomeacao concluida!
	ECHO.
	ECHO   ==================================
	ECHO.

:END
	PAUSE