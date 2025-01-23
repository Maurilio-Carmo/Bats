# 📚 Script para Organizar Arquivos XML com Quebra

## 📜 Introdução

Este script permite organizar arquivos XML em um diretório específico, utilizando um arquivo de "quebra" para filtrar quais arquivos devem ser copiados. Siga as instruções abaixo para utilizá-lo corretamente.

---

## 🚀 Funcionalidades

---

- **Organização Automática**: Copia arquivos XML de uma pasta de origem para uma pasta de destino com base em IDs especificados em um arquivo de quebra.
- **Verificação de Diretórios**: Garante que os diretórios necessários existem antes de processar os arquivos.
- **Logs Detalhados**: Registra arquivos encontrados e não encontrados em logs separados para fácil verificação.

---

## 📋 Pré-requisitos

Antes de executar o script, certifique-se de que você possui:

- Acesso ao terminal ou prompt de comando do Windows.
- Permissões adequadas para criar pastas e copiar arquivos.
- Um arquivo `Quebra.txt` no diretório `C:\XML\` com os IDs que você deseja filtrar.

---

## 🔧 Instruções de Uso

1. **Executar o Script**:
   - Abra o terminal ou prompt de comando.
   - Navegue até o diretório onde o script está localizado.
   - Execute o script.

2. **Criar ou Verificar o Diretório XML**:
   - Quando solicitado, escolha se deseja criar o diretório `C:\XML` ou se ele já existe.
   - Se escolher criar, o diretório será criado. Se já existir, o script continuará.

3. **Criar o Arquivo Quebra**:
   - O script solicitará que você crie um arquivo chamado `Quebra.txt` no diretório `C:\XML\`. Este arquivo deve conter os IDs que você deseja usar para filtrar os arquivos XML.

4. **Colocar Arquivos XML na Pasta**:
   - Coloque todos os arquivos XML que você deseja processar na pasta `C:\XML\XML Completo`.

5. **Aguarde a Conclusão**:
   - O script irá processar os arquivos e copiá-los para a pasta de destino `C:\XML\XML Quebra`, organizando-os por ano, mês e serial conforme definido no nome do arquivo.

6. **Verifique os Resultados**:
   - Após a execução, verifique os logs em `C:\XML\Log Encontrados.txt` e `C:\XML\Log Nao Encontrados.txt` para ver quais arquivos foram processados com sucesso e quais não foram encontrados.

---

## ⚠️ Avisos Importantes

- **Formato dos Nomes dos Arquivos**: O script assume que os arquivos XML seguem um padrão específico no nome (ex: `XXYYMMZZZZZZZZZ.xml`, onde `XX` é um prefixo, `YY` é o ano, `MM` é o mês e `ZZZZZZZZZ` é um número serial). Verifique se seus arquivos estão formatados corretamente.
- **Backup**: É recomendável fazer backup dos seus arquivos antes de executar o script, para evitar perda de dados.

---

## 📄 Exemplo de Execução

```bash
C:\> cd caminho\para\o\script
C:\caminho\para\o\script> nome_do_script.bat
```

---

### 🌟 Mensagens Finais

Após a execução, você verá uma mensagem confirmando que os arquivos foram organizados com sucesso. Se houver algum problema com os diretórios fornecidos ou se o arquivo `Quebra.txt` não for encontrado, uma mensagem de erro será exibida.

Se você tiver dúvidas ou precisar de assistência adicional, sinta-se à vontade para entrar em contato!

---

💡 **Dica**: Mantenha seus arquivos organizados e sempre verifique os logs após a execução do script para garantir que tudo foi processado corretamente!