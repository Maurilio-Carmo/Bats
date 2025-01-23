# 📚 Script para Migrar Dados entre Bancos Syspdv e Midi

## 📜 Introdução

Este script BAT foi criado para realizar **migrações e automações** no sistema SysPDV, utilizando comandos do Windows. Ele é útil para automatizar processos, economizar tempo e minimizar erros humanos.

Funcionalidades principais:
- 🔄 Migração de dados de forma rápida e eficiente.
- ⚙️ Execução de comandos automatizados para ajustes no sistema.
- 📂 Manipulação de arquivos relacionados ao SysPDV.

---

## 🚀 Instruções de Uso

### 1️⃣ Pré-requisitos

Antes de executar o script, certifique-se de:

- ✅ Ter o sistema operacional **Windows** instalado no computador.
- ✅ Possuir permissões de administrador para evitar erros de execução.
- ✅ No dico C: ter os diretorios do Syspdv e Midi com seus respectivos bancos.

⚠️ **Atenção:** Faça backup do arquivo original antes de realizar qualquer modificação.

### 2️⃣ Estrutura dos Logs

#### ⚡ Verificação Inicial

- O script realiza uma checagem para garantir que:
  - Os arquivos necessários estão no local correto.
  - Há permissões administrativas para execução.

#### ⚡ Preparação de Diretórios

- Cria ou verifica diretórios necessários para a migração ou execução do processo.
- Logs associados:
  - "Criando diretório base: <C:\MIGR>"
    - Arquivo de Log e Script de Exportação.
  - "Criando diretório exportação: <C:\MIGR\EXP>"
    - Arquivos com INSERT's a serem importados do sistema de destino.

#### ⚡ Exportação de Arquivos

- Exporta em varios arquivos os dados das tabelas que serão migradas.
   - O arquivo tem a devida Organização!
   - Nome do banco e tabela de origem!

#### ⚡ Importação do Sistema

- Importa cada uma dos arquivos gerados individualmente.
   - Executa cada linha como comando individual!

#### ⚡ Validação Final

- Ao finalizar o Script, abrira o arquivo de log e o Sistema de destino!
   - Verifique se todos os dados foram Migrados Corretamente!

---

## 🛠️ Solução de Problemas

Aqui estão algumas soluções para problemas comuns:

1. **Identifique erros nos logs**:
   - Localize mensagens de falha ou erro, dentro do Log e abra o arquivo de Exportação da Respectiva tabela.

2. **Corrija os problemas reportados**:
   - Somente a linha que apresentou erro que não será executada, verifique os dados da linha!

3. **Reexecute o script**:
  - Após orrigir a linha!
    - Executar somente a linha em um gerenciador como 🌐**IBO Console** ou ⚛️**IBExpert**! 

---

## 📬 Suporte
Após a execução, você verá uma mensagem indicando se o processo foi concluído com sucesso ou se houve falhas. 

Se você tiver dúvidas ou precisar de assistência adicional, sinta-se à vontade para entrar em contato!
