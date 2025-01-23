# 📚 Script para Conectar SGBD via Prompt de Comando

## 📜 Introdução

Este script em batch permite gerenciar conexões com bancos de dados Firebird e SQL Server de maneira simples e intuitiva. Com um menu interativo, você pode escolher qual gerenciador de banco de dados usar e qual banco específico deseja acessar.

---

## ⚙️ Pré-requisitos

Antes de usar o script, verifique se você possui:

- **Firebird Database** instalado no seu sistema.
- **SQL Server** instalado e configurado.
- Acesso aos bancos de dados mencionados no script.
- Permissões adequadas para executar comandos e acessar os arquivos mencionados.

---

## 🛠️ Estrutura do Script

O script realiza as seguintes funções:

1. **Define variáveis** para os caminhos dos bancos de dados e credenciais.
2. **Exibe um menu inicial** para que o usuário escolha entre Firebird ou SQL Server.
3. **Permite a seleção do banco de dados** específico dentro do Firebird.
4. **Executa comandos SQL** utilizando `ISQL` para Firebird ou `SQLCMD` para SQL Server.

---

## 🚀 Como Usar

1. **Baixe o script:** Copie o código do script para um arquivo com a extensão `.bat`, por exemplo, `gerenciar_banco.bat`.

2. **Configurar Variáveis:**
   - Abra o arquivo `.bat` em um editor de texto.
   - Verifique se os caminhos das variáveis `DB_PATH_SYSPDV`, `DB_PATH_MIDI_4`, e `DB_PATH_MIDI_5` estão corretos e ajustados ao seu ambiente.

3. **Executar o Script:**
   - Clique duas vezes no arquivo `.bat` ou execute-o através do prompt de comando.
   - O menu aparecerá, permitindo que você escolha:
     - `1` - Firebird 2.5
     - `2` - SQL Server
     - `0` - Sair

4. **Escolher Banco de Dados (para Firebird):**
   - Se você escolher Firebird, será solicitado a selecionar um banco de dados específico:
     - `1` - SysPDV
     - `2` - Midi 4
     - `3` - Midi 5
     - `0` - Voltar ao menu anterior

5. **Acompanhe as Mensagens:** O script executará os comandos SQL e exibirá as saídas diretamente no console.

---

## ⚠️ Atenção

- **Credenciais:** Certifique-se de que as credenciais (`ISC_USER` e `ISC_PASSWORD`) estão corretas para acessar os bancos de dados.
- **Permissões:** Execute o script com permissões administrativas se necessário, especialmente ao acessar serviços do sistema.

---

## 📝 Exemplo de Uso

```plaintext
Escolha o Gerenciador do Banco!
    1 - Firebird 2.5
    2 - SQL Server
    0 - Sair
Digite a opcao:
```

Após escolher o gerenciador, você poderá selecionar o banco de dados desejado.

---

## 🎉 Conclusão

Este script é uma ferramenta prática para gerenciar conexões com bancos de dados Firebird e SQL Server. 

Utilize-o com cuidado e aproveite a facilidade que ele proporciona! 

Se tiver dúvidas ou problemas, consulte um profissional qualificado.