# 📚 Script de Reparação de Banco de Dados Firebird

## 📜 Introdução

Este script permite a seleção e reparação de bancos de dados Firebird. Siga as instruções abaixo para utilizá-lo corretamente.

---

## 🚀 Funcionalidades

- **Seleção de Banco de Dados**: Escolha entre três bancos de dados disponíveis.
- **Reparo de Banco**: Realiza a correção de corrupção no banco de dados selecionado.
- **Backup Automático**: Cria cópias de segurança antes de realizar qualquer operação.
- **Alteração de Porta**: Troca temporariamente a porta do Firebird durante o processo.

---

## 📋 Pré-requisitos

Antes de executar o script, certifique-se de que você possui:

- O Firebird instalado e configurado no seu sistema.
- Acesso ao terminal ou prompt de comando.
- Permissões adequadas para executar comandos que afetam serviços do sistema.

---

## 🔧 Instruções de Uso

1. **Executar o Script**:
   - Abra o terminal ou prompt de comando.
   - Navegue até o diretório onde o script está localizado.
   - Execute o script.

2. **Escolher o Banco de Dados**:
   - Ao ser solicitado, digite a opção correspondente ao banco que deseja reparar:
     - `1` para `%SYSTEM_NAME%_srv`
     - `2` para `%SYSTEM_NAME%_mov`
     - `3` para `%SYSTEM_NAME%_cad`
     - `0` para voltar ao menu anterior.

3. **Aguarde a Conclusão**:
   - O script realizará as operações necessárias, incluindo a criação de backups e a correção do banco.
   - Você verá mensagens informativas sobre o progresso do processo.

4. **Verificar Resultados**:
   - Após a execução, verifique se a operação foi bem-sucedida ou se houve falhas. O log será atualizado com informações detalhadas.

---

## ⚠️ Avisos Importantes

- **Backup**: Sempre faça backups manuais dos seus bancos antes de executar scripts que realizam modificações.
- **Ambiente Seguro**: Execute o script em um ambiente controlado para evitar perda de dados.

---

## 📄 Exemplo de Execução

```bash
C:\> cd caminho\para\o\script
C:\caminho\para\o\script> nome_do_script.bat
```

---

### 🌟 Mensagens Finais

Após a execução, você verá uma mensagem indicando se o processo foi concluído com sucesso ou se houve falhas. Em caso de falhas, o backup mais recente será restaurado automaticamente.

Se você tiver dúvidas ou precisar de assistência adicional, sinta-se à vontade para entrar em contato!

---

💡 **Dica**: Mantenha sempre seu sistema e suas aplicações atualizadas para garantir melhor desempenho e segurança!