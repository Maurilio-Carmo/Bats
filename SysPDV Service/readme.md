# README.md

## 🛠️ Script para Reinstalar o Serviço SysPDV

Este script em Batch é projetado para facilitar a reinstalação do serviço **SysPDVService** no seu sistema. Ele automatiza o processo de parada, exclusão e reinstalação do serviço, garantindo que você tenha uma instalação limpa e funcional.

---

### 📋 Funcionalidades

- **Parar o Serviço**: Finaliza o processo em execução do SysPDVService.
- **Deletar o Serviço**: Remove o serviço do sistema, se ele existir.
- **Instalar o Serviço Novamente**: Reinstala o SysPDVService a partir do diretório especificado.
- **Iniciar o Serviço**: Inicia o serviço reinstalado.

---

### ⚙️ Instruções de Uso

1. **Executar o Script**:
   - Abra o terminal do Windows (cmd).
   - Navegue até o diretório onde o script está salvo.
   - Execute o script digitando `script.bat` (substitua `script.bat` pelo nome do seu arquivo).

2. **Processo de Reinstalação**:
   - O script começará com uma mensagem de boas-vindas e uma pausa para que você possa ler.
   - Em seguida, ele tentará parar qualquer instância em execução do **SysPDVService**.
   - Após parar o serviço, ele tentará deletá-lo. Se o serviço não for encontrado, uma mensagem informativa será exibida.

3. **Instalação do Serviço**:
   - O script navegará até a pasta `\SYSPDV\SERVICO` e executará a instalação do serviço novamente usando `SysPDVService.exe /INSTALL`.

4. **Iniciar o Serviço**:
   - Após a instalação, o script iniciará automaticamente o serviço.

5. **Conclusão**:
   - Uma mensagem final será exibida, confirmando que a operação foi concluída com sucesso.

---

### ❗ Observações

- Certifique-se de ter permissões administrativas para executar operações de serviços no Windows.
- O caminho `\SYSPDV\SERVICO` deve ser válido e acessível para que a instalação funcione corretamente.

---

### 📞 Suporte

Se você encontrar problemas ou tiver dúvidas sobre o uso do script, sinta-se à vontade para entrar em contato!

---

### 🎉 Agradecimentos

Obrigado por usar este script! Esperamos que ele facilite a reinstalação do serviço SysPDV! 🚀