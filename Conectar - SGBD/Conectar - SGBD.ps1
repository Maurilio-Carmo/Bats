$Host.UI.RawUI.BackgroundColor = "Dark"  # Muda o fundo para azul escuro
$Host.UI.RawUI.ForegroundColor = "Yellow"  # Muda a letra para amarela
Clear-Host  # Aplica a mudança

# Definição de caminhos dos bancos de dados
$DB_PATH_SYSPDV = "C:\SYSPDV\SYSPDV_SRV.FDB"
$DB_PATH_MIDI_4 = "C:\MIDIPDV\MIDI_SRV.FDB"
$DB_PATH_MIDI_5 = "C:\MIDI\MIDI_SRV.FDB"

# Definição de usuário e senha
$ISC_USER = "SYSDBA"
$ISC_PASSWORD = "masterkey"

function Show-MainMenu {
    Clear-Host
    Write-Host ""
    Write-Host "`n   =================================="
    Write-Host ""
    Write-Host "`n     Escolha o Gerenciador do Banco!"
    Write-Host ""
    Write-Host "`n          1 - Firebird 2.5"
    Write-Host ""
    Write-Host "`n          2 - SQL Server"
    Write-Host ""
    Write-Host ""
    Write-Host "`n          0 - Sair"
    Write-Host ""
    Write-Host "`n   =================================="
    Write-Host ""
    $choice = Read-Host "Digite a opção"

    switch ($choice) {
        "1" { Firebird }
        "2" { SQLServer }
        "0" { Exit }
        default {
            Write-Host ""
            Write-Host "`n   =================================="
            Write-Host ""
            Write-Host "               Opção inválida!"
            Write-Host "        Por favor, escolha 1, 2 ou 0!"
            Write-Host ""
            Write-Host "`n   =================================="
            Write-Host ""
            Pause
            Show-MainMenu
        }
    }
}

function Firebird {
    Clear-Host
    if (Test-Path "C:\Program Files (x86)\Firebird\Firebird_2_5\bin") {
        $FIREBIRD_PATH = "C:\Program Files (x86)\Firebird\Firebird_2_5\bin"
    } else {
        $FIREBIRD_PATH = "C:\Program Files\Firebird\Firebird_2_5\bin"
    }

    Write-Host "`n   =================================="
    Write-Host ""
    Write-Host "`n       Escolha o Banco de Dados"
    Write-Host ""
    Write-Host "`n            1 - SysPDV"
    Write-Host ""
    Write-Host "`n            2 - Midi 4"
    Write-Host ""
    Write-Host "`n            3 - Midi 5"
    Write-Host ""
    Write-Host ""
    Write-Host "`n            0 - Voltar"
    Write-Host ""
    Write-Host "`n   =================================="
    Write-Host ""
    $db_choice = Read-Host "Digite a opção"

    switch ($db_choice) {
        "1" { $DB_PATH = $DB_PATH_SYSPDV }
        "2" { $DB_PATH = $DB_PATH_MIDI_4 }
        "3" { $DB_PATH = $DB_PATH_MIDI_5 }
        "0" { Show-MainMenu }
        default {
            Write-Host ""
            Write-Host "`n   =================================="
            Write-Host ""
            Write-Host "              Opção inválida!"
            Write-Host "       Por favor, escolha 1, 2, 3 ou 0!"
            Write-Host ""
            Write-Host "`n   =================================="
            Write-Host ""
            Pause
            Firebird
        }
    }
    
    Clear-Host
    Start-Process -NoNewWindow -Wait -FilePath "$FIREBIRD_PATH\isql.exe" -ArgumentList "-user $ISC_USER -password $ISC_PASSWORD $DB_PATH"
    Show-MainMenu
}

function SQLServer {
    Clear-Host
    Start-Process -NoNewWindow -Wait -FilePath "sqlcmd.exe" -ArgumentList "-S localhost -d syspdv -E"
    Show-MainMenu
}

Show-MainMenu
