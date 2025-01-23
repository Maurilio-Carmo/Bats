# README.md

## 📜 Introdução

Este script em batch é projetado para gerenciar a biometria em um sistema que utiliza bancos de dados Firebird. Ele permite que você desative ou restaure a biometria de forma simples e eficaz.

## ⚙️ Pré-requisitos

Antes de usar o script, certifique-se de que você possui:

- **Firebird Database** instalado no seu sistema.
- Acesso ao banco de dados **SYSPDV_CAD.FDB** e **SYSPDV_MOV.FDB**.
- Permissões adequadas para executar comandos e acessar os arquivos mencionados.

## 🛠️ Estrutura do Script

O script realiza as seguintes funções:

1. **Verifica se os caminhos dos arquivos e pastas necessários existem.**
2. **Exibe um menu para o usuário escolher entre desativar ou restaurar a biometria.**
3. **Executa comandos SQL para modificar as configurações da biometria no banco de dados.**
4. **Registra as operações em um arquivo de log.**

## 🚀 Como Usar

1. **Baixe o script:** Copie o código do script para um arquivo com a extensão `.bat`, por exemplo, `gerenciar_biometria.bat`.

2. **Configurar Variáveis:**
   - Abra o arquivo `.bat` em um editor de texto.
   - Verifique se os caminhos das variáveis `SYSPDV_CAD_PATH`, `SYSPDV_MOV_PATH`, e `TEMP_PATH` estão corretos e ajustados ao seu ambiente.

3. **Executar o Script:**
   - Clique duas vezes no arquivo `.bat` ou execute-o através do prompt de comando.
   - O menu aparecerá, permitindo que você escolha uma opção:
     - `1` - Desativar a biometria
     - `2` - Restaurar a biometria
     - `0` - Sair do programa

4. **Siga as instruções na tela:** O script fornecerá feedback sobre cada ação realizada, incluindo mensagens de sucesso ou erro.

## ⚠️ Atenção

- **Backup:** Sempre faça backup dos seus bancos de dados antes de executar operações que alterem dados.
- **Permissões:** Execute o script com permissões administrativas se necessário, especialmente ao acessar arquivos ou processos do sistema.

## 📝 Exemplo de Uso

```plaintext
Escolha a Opcao da Biometria!
    1 - Desativar
    2 - Restaurar
    0 - Sair
Digite a opcao: 
```

Após selecionar uma opção, o script executará as ações correspondentes e exibirá mensagens apropriadas.

## 📂 Logs

Os logs das operações realizadas são salvos em `C:\SYSPDV\TEMP\Log_Biometria.txt`. 
Você pode revisar este arquivo para verificar as ações executadas e quaisquer erros que possam ter ocorrido.

## 🎉 Conclusão

Este script é uma ferramenta poderosa para gerenciar a biometria em seu sistema Firebird. 

Utilize-o com cuidado e aproveite a facilidade que ele proporciona! Se tiver dúvidas ou problemas, consulte um profissional qualificado.