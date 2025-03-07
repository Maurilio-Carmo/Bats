# 📚 Script de configuração NFC-e e WebServices para SYSPDV

## 📜 Introdução

Este script em batch automatiza a atualização e configuração dos WebServices e dos parâmetros de NFC-e (Nota Fiscal de Consumidor Eletrônica) no sistema SYSPDV. Ele gera e executa comandos SQL para modificar os bancos de dados do servidor e dos pontos de venda (CAIXAS) de forma remota.

---

## ⚙️ Requisitos

Antes de utilizar o script, verifique se possui os seguintes itens configurados corretamente:

- **Sistema Operacional:** Windows.

- **SGBD Instalados** para alterações no Banco:
  - `SQL Server`
  - `Firebird 2.5`

- **Banco de Dados SYSPDV:**  
  - Arquivos do `SQL Server` ou `Firebird`.

- **Permissões adequadas:**
  - O usuário deve ter permissão para criar/excluir diretórios e executar comandos via `SQLCMD` ou `ISQL`.

- **Informações do Cliente e Contabilidade:**
  - `CFOP`
  - `ID Token - CSC`
  - `Certificado Digital` - Preferência de modelo - `A1` 

---

## 🛠️ Funcionalidades

O script executa as seguintes funções:

1. **Menu Interativo** 💭
   - Permite escolher entre ativar NFC-e para todos os PDVs ou configurar Individualmente.

2. **Configuração Automática** ⚙️
   - Atualiza tabelas essenciais do banco de dados:

     - `PROPRIO` (parametrização de NFC-e).   
     - `SERIE_NOTA_FISCAL` (inserção condicional);
     - `CAIXA` (atualização da `Especie` e `Serie`);

3. **Geração e Execução de Scripts SQL** 💻
   - Cria arquivos temporários com os comandos SQL e os executa via `SQLCMD` ou `ISQL`.

4. **Atualização Remota** 🌐
   - Lê a lista de CAIXAS (com seus respectivos IPs) e aplica as configurações remotamente.

5. **Registra Logs Detalhados** 📂
   - Gera um arquivo de log (`Log_WebServices.txt`) para auditoria e resolução de problemas.

---

## 🚀 Como Usar

1. **Preparação:**
   - Verifique se o Firebird e os bancos de dados estão corretamente instalados.

2. **Execução do Script:**
   - Execute o script em modo Administrador.
   - O menu aparecerá, permitindo escolher:
     - `1` - Ativar NFC-e para todos os PDVs
     - `2` - Configurar Individulmente
     - `0` - Sair

     ⚡***Obs.: Na opção Individual deve-se alterar a especie dos caixas pela rotina de cadastro dos caixas `CADASTRO > CAIXA > CAIXA`***

3. **Processamento:**
   - O script cria um diretório temporário em `C:\SYSPDV\NFCE\AUTO_CONFIG`.
   - Gera arquivos SQL e aplica as configurações nos bancos SRV e CAD, MOV de cada PDV.
   - As mensagens e logs são exibidos na tela e salvos no arquivo de log.

4. **Finalização:**
   - O arquivo de log (`Log_WebServices.txt`) é aberto automaticamente para verificação de sucesso.

---

## ⚠️ Atenção

- **Backup:** Faça backup dos bancos antes de executar o script.
- **Erros e Conexões:** Verifique o log em caso de falhas.
- **Customização:** Ajuste as variáveis de ambiente conforme necessário.

---

## 🎉 Conclusão

Este script é uma ferramenta prática para automatizar a configuração de NFC-e no SYSPDV. Utilize com cuidado e, caso precise de ajuda, consulte um profissional especializado. 🚀

