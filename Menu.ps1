# Caminho da pasta contendo os scripts

$caminhoPasta = "https://github.com/Maurilio-Carmo/Bats/tree/main"



# Função para listar todos os scripts na pasta

Function Listar-Scripts {

    Write-Host "Scripts disponíveis na pasta $caminhoPasta:"

    Get-ChildItem -Path $caminhoPasta -Filter *.ps1 | ForEach-Object {

        Write-Host $_.Name

    }

}



# Função para executar um script específico

Function Executar-Script {

    param (

        [string]$nomeScript

    )



    $caminhoCompleto = Join-Path -Path $caminhoPasta -ChildPath $nomeScript



    if (Test-Path $caminhoCompleto) {

        Write-Host "Executando o script $nomeScript..."

        & $caminhoCompleto

    } else {

        Write-Host "Script $nomeScript não encontrado na pasta."

    }

}



# Menu interativo

Function Menu-Principal {

    do {

        Write-Host "`nMenu de Scripts"

        Write-Host "1\. Listar Scripts"

        Write-Host "2\. Executar um Script"

        Write-Host "3\. Sair"

        $opcao = Read-Host "Escolha uma opção"



        switch ($opcao) {

            "1" { Listar-Scripts }

            "2" {

                $nomeScript = Read-Host "Digite o nome do script que deseja executar"

                Executar-Script -nomeScript $nomeScript

            }

            "3" { Write-Host "Saindo..." }

            default { Write-Host "Opção inválida. Tente novamente." }

        }

    } while ($opcao -ne "3")

}



# Executar o menu principal

Menu-Principal