# Elevate.ps1
# Automatically check & get admin rights

Clear-Host

Write-Host ""
Write-Host "============================="
Write-Host "==== Running Admin shell ===="
Write-Host "============================="

# Function to check if the script has admin privileges
function Check {
    try {
        # Try running a command that requires privileges
        Get-Process -Name "explorer" | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

# Function to invoke UAC and run with admin privileges
function Get-Privileges {
    Write-Host ""
    Write-Host "**************************************"
    Write-Host "Invoking UAC for Privilege Escalation"
    Write-Host "**************************************"

    $command = "& {Start-Process powershell -ArgumentList '-NoExit', '-Command', 'Set-Location -Path ''$($MyInvocation.MyCommand.Path)''; . ''$($MyInvocation.MyCommand.Path)''; exit;' -Verb runAs}"
    Invoke-Expression $command
    exit
}

# Check if we already have admin privileges
if (-not (Check)) {
    Get-Privileges
}

Clear-Host

# Main script
Write-Host ""
Write-Host "==================================="
Write-Host ""
Write-Host "       Verificando a rota..."
Write-Host ""
Write-Host "==================================="
Write-Host ""

# Wait for 3 seconds
Start-Sleep -Seconds 3
Clear-Host

$ipPath = "172.19.0.0"
$routeCheck = Test-Connection -ComputerName $ipPath -Count 1 -Quiet

if ($routeCheck) {
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    Write-Host "         Rota Encontrada..."
    Write-Host ""
    Write-Host "           1 - Recriar"
    Write-Host ""
    Write-Host "           2 - Testar"
    Write-Host ""
    Write-Host ""
    Write-Host "           0 - Sair"
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    $choice = Read-Host " Digite a opção:  "

    switch ($choice) {
        "1" { Remover }
        "2" { Testar }
        "0" { Exit }
        default {
            Clear-Host
            Write-Host ""
            Write-Host "==================================="
            Write-Host ""
            Write-Host "          Opcao invalida!"
            Write-Host "        Escolha 1, 2 ou 0."
            Write-Host ""
            Write-Host "==================================="
            Write-Host ""
            Pause
            Clear-Host
            }
    }
}
else {
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    Write-Host "       Rota Não Encontrada..."
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    Start-Sleep -Seconds 3
    Clear-Host
    Adcionar
}

function Remover {
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    Write-Host "         Deletando Rota..."
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    route delete 172.19.0.0
    Clear-Host
}

function Adcionar {
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    Write-Host "           ROTA MARTINS"
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    $ipPath = Read-Host " Informe o IP: "

    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    Write-Host "        Adicionando Rota..."
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    route add 172.19.0.0 MASK 255.255.0.0 $ipPath -P
    Start-Sleep -Seconds 3
    Clear-Host

    if ($?) {
        Write-Host ""
        Write-Host "==================================="
        Write-Host ""
        Write-Host "    Rota adicionada com sucesso!"
        Write-Host ""
        Write-Host "==================================="
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "==================================="
        Write-Host ""
        Write-Host "            [ ERRO ]"
        Write-Host "   Falha ao adicionar a rota..."
        Write-Host ""
        Write-Host "==================================="
        Write-Host ""
        Pause
        Exit
    }
}

function Test {
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    Write-Host "      Testando conectividade..."
    Write-Host ""
    Write-Host "==================================="
    Write-Host ""
    $pingResult = Test-Connection 172.19.2.2 -Count 1 -Quiet

    if ($pingResult) {
        Write-Host ""
        Write-Host "==================================="
        Write-Host ""
        Write-Host "    Conectividade bem-sucedida!"
        Write-Host ""
        Write-Host "==================================="
        Write-Host ""
    } else {
        Write-Host ""
        Write-Host "==================================="
        Write-Host ""
        Write-Host "             [ ERRO ]"
        Write-Host "      Falha na conectividade..."
        Write-Host ""
        Write-Host "==================================="
        Write-Host ""
    }
}

Write-Host ""
Write-Host "==================================="
Write-Host ""
Write-Host "        Script Finalizado."
Write-Host ""
Write-Host "==================================="
Write-Host ""
Pause
