# 📚 Script de Geração e Importação de Pedidos de Venda para SYSPDV

## 📜 Introdução

Este script automatiza o processo de geração, exportação e importação de pedidos de venda no sistema SYSPDV, utilizando o banco de dados Firebird 2.5. O script solicita parâmetros do usuário, gera os comandos SQL necessários para criar os pedidos, seus itens e atualizar os valores totais. Todas as ações são registradas em um log para facilitar auditoria e resolução de problemas.

**Utilizado em situações:**
   - Onde o cliente comprou uma loja ou trocou de `CNPJ` e foi orientado pela contabilidade a `vender` os itens de uma loja para outra fiscalmente com `NF-e`, afim de facilidar o processo de geração das notas este script gera os pedidos a serem importados nas notas.

---

## ⚙️ Requisitos

Antes de executar o script, certifique-se de que os seguintes itens estão configurados corretamente:

- **Sistema Operacional:** 
  - Windows.

- **SGBD:**  
  - Firebird.

- **Banco de Dados SYSPDV:**  
  - Arquivo de banco localizado em `C:\SYSPDV\SYSPDV_SRV.FDB`.

- **Permissões:**  
  - Usuário com permissão para criação/exclusão de diretórios e execução `Administrador`.

- **Cadastros**  
  - Funcionário
  - Cliente
  - Operação

---

## 🛠️ Funcionalidades

O script realiza as seguintes operações:

1. **Configuração do Ambiente**  
   - Verifica e define o caminho do Firebird.
   - Cria o diretório de trabalho (`C:\SYSPDV\GERADOR_PEDIDO`), garantindo um ambiente limpo.

2. **Validação do Banco de Dados**  
   - Confere se o arquivo do banco de dados existe antes de prosseguir.

3. **Solicitação de Parâmetros**  
   - Solicita ao usuário informações essenciais:
     - Código do **Funcionário**.
     - Código do **Cliente**.
     - Código da **Operação**.
     - **CFOP** da Nota.
     - Quantidade de **Itens** por nota (até 250).
     - Definição se deve utilizar o **Preço de Custo** (Sim ou Não).

4. **Geração de Scripts SQL**  
   - Cria os arquivos SQL para:
     - **PEDIDO_VENDA:** Inserção dos dados do pedido.
     - **PEDIDO_VENDA_ITENS:** Geração dos itens do pedido com base no estoque.
     - **PEDIDO_VENDA_VALOR:** Atualização do valor total dos pedidos.

5. **Execução e Importação dos Scripts**  
   - Executa os scripts gerados via `ISQL`, aplicando as alterações diretamente no banco de dados.
   - Registra todas as etapas e mensagens de erro/sucesso em um arquivo de log (`Log_Gerador.txt`).

6. **Finalização**  
   - Ao concluir as operações, exibe as informações de término e abre automaticamente o log para conferência.

---

## 🚀 Como Usar

1. **Preparação:**
   - Verifique se o Firebird 2.5 e o banco de dados SYSPDV estão instalados e acessíveis.
   - Certifique-se de que possui privilégios de administrador para executar o script.

2. **Execução do Script:**
   - Execute o arquivo batch (`.bat`) em modo Administrador.
   - Siga as instruções exibidas na tela:
     - Informe o **Código do Funcionário**.
     - Informe o **Código do Cliente**.
     - Informe o código da **Operação**.
     - Informe o **CFOP**.
     - Informe a **Quantidade de Itens** por nota.
     - Escolha se deseja utilizar o **Preço de Custo** (digite `1` para Sim ou `2` para Não).

3. **Processamento:**
   - O script irá:
     - Criar o diretório de trabalho e registrar a data e hora de início.
     - Gerar os arquivos SQL com os comandos necessários.
     - Executar os scripts de exportação e importação, registrando todas as ações no log.

4. **Finalização:**
   - Após a execução, o log (`Log_Gerador.txt`) será aberto automaticamente para que você possa verificar se todas as operações foram realizadas com sucesso.

---

## ⚠️ Atenção

- **Backup:** Faça backup do banco de dados antes de executar o script, para evitar perda de dados em caso de falhas.
- **Erros e Conexões:** Em caso de erro, consulte o arquivo de log (`Log_Gerador.txt`) para identificar possíveis problemas e corrigi-los.
- **Customização:** Se necessário, ajuste as variáveis de ambiente e os caminhos definidos no script para adequá-los ao seu ambiente.

---

## 🎉 Conclusão

Este script é uma ferramenta prática para automatizar a geração e importação de pedidos de venda no SYSPDV, otimizando o processo de integração com o banco de dados Firebird. Utilize-o com cuidado, seguindo todas as recomendações, e consulte um profissional especializado se houver dúvidas ou necessidades de personalização.

