# URL base do repositório GitHub
$repoUrl = "https://raw.githubusercontent.com/Maurilio-Carmo/Bats/main"

# Função para listar os scripts no repositório GitHub
function List-Scripts {
    $scripts = @(
        "Script1.ps1",  # Substitua pelos nomes reais dos seus scripts
        "Script2.ps1"
        # Adicione mais scripts conforme necessário
    )

    $scripts | ForEach-Object { Write-Host "$($_)" }
    return $scripts
}

# Função para baixar o script do GitHub e executar
function Execute-Script($scriptName) {
    $scriptUrl = "$repoUrl/$scriptName"
    $scriptPath = "$env:TEMP\$scriptName"

    # Baixar o script para um arquivo temporário
    Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

    # Executar o script
    Write-Host "Executando o script: $scriptName"
    . $scriptPath

    # Apagar o script temporário após execução
    Remove-Item $scriptPath
}

# Exibir o menu
do {
    Write-Host "Escolha um script para executar:"
    $scripts = List-Scripts
    $selection = Read-Host "Digite o nome do script ou 'sair' para finalizar"

    if ($selection -eq "sair") {
        Write-Host "Saindo do menu..."
        break
    }

    # Verificar se o script escolhido existe
    if ($scripts -contains $selection) {
        Execute-Script $selection
    } else {
        Write-Host "Script não encontrado. Tente novamente."
    }

    Write-Host ""
} while ($true)
