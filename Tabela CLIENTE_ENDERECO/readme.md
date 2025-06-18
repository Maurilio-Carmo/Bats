# 📚 Script de Criação da Tabela CLIENTE_ENDERECO

## 📜 Introdução

Este script em batch foi desenvolvido para automatizar a inserção ou atualização da estrutura da tabela `CLIENTE_ENDERECO` no banco de dados utilizado pelo sistema SYSPDV com `SQL SERVER` inferior a `VERSAO 2019`. A execução é feita de forma local nos arquivos, garantindo que o layout e campos necessários estejam criados conforme o padrão da aplicação.

---

## ⚙️ Requisitos

Antes de executar o script, garanta que os seguintes pré-requisitos estejam atendidos:

- **Sistema Operacional:** Windows (com acesso administrativo).

- **SGBD Necessário:**  
  - `SQL SERVER` (com CMDSQL disponível no PATH).

- **Banco de Dados SYSPDV:**  
  - Arquivo `.MDF` local disponível e acessível.

- **Permissões Necessárias:**
  - Permissão de leitura e escrita no diretório do banco.
  - Acesso para execução de comandos SQL via `CMDSQL`.

---

## 🛠️ Funcionalidades

O script realiza as seguintes operações:

1. **Verificação do Caminho do Banco** 📁  
   - Verifica o caminho completo para o arquivo `.MDF`.

2. **Geração de Arquivo SQL** 📝  
   - Cria um arquivo temporário contendo o `DDL` necessário para criar ou alterar a tabela `CLIENTE_ENDERECO`.

3. **Execução Automática** ⚙️  
   - Aplica os comandos SQL no banco informado usando `CMDSQL`.

4. **Feedback Visual** 👁️  
   - Exibe mensagens orientativas durante todo o processo.

5. **Limpeza Final** 🧹  
   - Remove arquivos temporários após execução.

---

## 🚀 Como Usar

1. **Preparação:**
   - Certifique-se de ter o SQL Server instalado.
   - Localize o caminho completo do banco de dados `.MDF`

2. **Execução:**
   - Clique com o botão direito no `.BAT` e selecione “Executar como administrador”.

3. **Processamento:**
   - O script criará e executará o `ALTER TABLE` com segurança.
   - Campos adicionais ou alterações serão aplicadas conforme a necessidade.

4. **Finalização:**
   - A mensagem de sucesso será exibida ao final do processo.
   - O arquivo SQL temporário será excluído automaticamente.

---

## ⚠️ Atenção

- **Backup:** Faça backup do banco antes da execução.
- **Confirmação:** Verifique o log visual para garantir que a execução ocorreu sem erros.
- **Banco em Uso:** Certifique-se de que o banco não esteja em uso por nenhuma aplicação no momento da execução.

---

## 🎯 Conclusão

Este script garante que a estrutura da tabela `CLIENTE_ENDERECO` esteja compatível com os requisitos do sistema SYSPDV. Ideal para manutenções corretivas ou preparação de ambiente. Para alterações estruturais maiores, recomenda-se o envolvimento da equipe de desenvolvimento ou DBA responsável.
