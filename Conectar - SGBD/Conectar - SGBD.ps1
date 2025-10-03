# Para rodar este script:
# 1. Abra o PowerShell como Administrador
# 2. Execute se necessario: Set-ExecutionPolicy RemoteSigned
# 3. Execute o comando: irm https://tinyurl.com/Conectar-SGBD | iex

# Configuração de aparência
$Host.UI.RawUI.BackgroundColor = "DarkBlue"   # Fundo azul escuro
$Host.UI.RawUI.ForegroundColor = "Yellow"     # Texto amarelo
Clear-Host                                    # Aplica a mudança

# Definição de caminhos
$DB_PATH_SYSPDV = "C:\SYSPDV\SYSPDV"
$DB_PATH_MIDI_4 = "C:\MIDIPDV\MIDI"
$DB_PATH_MIDI_5 = "C:\MIDI\MIDI"

# Usuário e senha Firebird
$ISC_USER = "SYSDBA"
$ISC_PASSWORD = "masterkey"

# Função: Menu principal
function Show-MainMenu {
    Clear-Host
    Write-Host "`n   =================================="
    Write-Host ""
    Write-Host "     Escolha o Gerenciador do Banco!"
    Write-Host ""
    Write-Host "          1 - Firebird 2.5"
    Write-Host "          2 - SQL Server"
    Write-Host ""
    Write-Host "          0 - Sair"
    Write-Host ""
    Write-Host "   =================================="
    Write-Host ""

    $choice = Read-Host "Digite a opção"

    switch ($choice) {
        "1" { Firebird }
        "2" { SQLServer }
        "0" { Exit }
        default {
            Show-InvalidOption "1, 2 ou 0"
            Show-MainMenu
        }
    }
}

# Função: Firebird (menu 1)
function Firebird {
    Clear-Host

    # Detecta pasta do Firebird (x86 ou x64)
    if (Test-Path "C:\Program Files (x86)\Firebird\Firebird_2_5\bin") {
        $global:FIREBIRD_PATH = "C:\Program Files (x86)\Firebird\Firebird_2_5\bin"
    } else {
        $global:FIREBIRD_PATH = "C:\Program Files\Firebird\Firebird_2_5\bin"
    }

    # Vai para o menu de escolha do sistema
    Show-SistemaMenu
}

# Função: Menu de sistemas
function Show-SistemaMenu {
    Clear-Host
    Write-Host "`n   =================================="
    Write-Host ""
    Write-Host "       Escolha o Sistema de Venda"
    Write-Host ""
    Write-Host "            1 - SysPDV"
    Write-Host "            2 - Midi 4"
    Write-Host "            3 - Midi 5"
    Write-Host ""
    Write-Host "            0 - Voltar"
    Write-Host ""
    Write-Host "   =================================="
    $choice = Read-Host "Digite a opção"

    switch ($choice) {
        "1" { $global:SISTEM_PATH = $DB_PATH_SYSPDV ; Show-BancoMenu }
        "2" { $global:SISTEM_PATH = $DB_PATH_MIDI_4 ; Show-BancoMenu }
        "3" { $global:SISTEM_PATH = $DB_PATH_MIDI_5 ; Show-BancoMenu }
        "0" { Show-MainMenu }
        default {
            Show-InvalidOption "1, 2, 3 ou 0"
            Show-SistemaMenu
        }
    }
}

# Função: Menu de bancos
function Show-BancoMenu {
    Clear-Host
    Write-Host "`n   =================================="
    Write-Host ""
    Write-Host "       Escolha o Banco de Dados"
    Write-Host ""
    Write-Host "            1 - SRV"
    Write-Host "            2 - CAD"
    Write-Host "            3 - MOV"
    Write-Host ""
    Write-Host "            0 - Voltar"
    Write-Host ""
    Write-Host "   =================================="
    $choice = Read-Host "Digite a opção"

    switch ($choice) {
        "1" { $DB_PATH = "${SISTEM_PATH}_SRV.FDB" ; Run-Firebird $DB_PATH }
        "2" { $DB_PATH = "${SISTEM_PATH}_CAD.FDB" ; Run-Firebird $DB_PATH }
        "3" { $DB_PATH = "${SISTEM_PATH}_MOV.FDB" ; Run-Firebird $DB_PATH }
        "0" { Show-SistemaMenu }
        default {
            Show-InvalidOption "1, 2, 3 ou 0"
            Show-BancoMenu
        }
    }
}

# Função: Executar ISQL
function Run-Firebird {
    param([string]$DB_PATH)

    Clear-Host
    Start-Process -NoNewWindow -Wait -FilePath "$FIREBIRD_PATH\isql.exe" `
        -ArgumentList "-user $ISC_USER -password $ISC_PASSWORD $DB_PATH"

    Show-MainMenu
}

# Função: SQL Server
function SQLServer {
    Clear-Host
    Start-Process -NoNewWindow -Wait -FilePath "sqlcmd.exe" `
        -ArgumentList "-S localhost -d syspdv -E"
    Show-MainMenu
}

# Função: Mensagem de erro
function Show-InvalidOption {
    param([string]$validOptions)

    Clear-Host
    Write-Host "`n   =================================="
    Write-Host ""
    Write-Host "               Opção inválida!"
    Write-Host "       Por favor, escolha $validOptions!"
    Write-Host ""
    Write-Host "   =================================="
    Write-Host ""
    Pause
    Clear-Host
}

# Início do programa
Show-MainMenu
