# 📚 Script para BKP Diario MIDI 4 e 5

## 📜 Introdução

Este script em batch é projetado para realizar backups diários do banco de dados **MIDI_SRV.FDB** utilizando o Firebird. Ele automatiza o processo de parada do serviço, cópia do banco de dados e criação de um arquivo de backup com base no dia da semana.

---

## ⚙️ Pré-requisitos

Antes de usar o script, verifique se você possui:

- **Firebird Database** instalado no seu sistema.
- Acesso ao banco de dados **MIDI_SRV.FDB**.
- Permissões adequadas para executar comandos e acessar os arquivos mencionados.

---

## 🛠️ Estrutura do Script

O script realiza as seguintes funções:

1. **Define variáveis necessárias** para a execução.
2. **Verifica e cria diretórios** necessários para armazenar backups.
3. **Configura o caminho do backup**, solicitando ao usuário se ainda não estiver configurado.
4. **Verifica a existência dos arquivos necessários** (`fbclient.dll` e `gbak.exe`).
5. **Para o serviço Firebird**, realiza o backup e reinicia o serviço.
6. **Remove arquivos temporários** após a conclusão do backup.

---

## 🚀 Como Usar

1. **Baixe o script:** 
   - Transfira o script para o **shell:startup** para ser executado logo após a inicialização.

2. **Configurar Variáveis:**
   - Execute o script pela primeira vez em modo Administrador.
   - O script solicitará que você configure o caminho onde deseja salvar os backups.

3. **Executar o Script:**
   - Após a primeira inicialização, fica gravado o destino de Backup, realizando sempre que executado.

4. **Acompanhe as Mensagens:**
   - O script exibirá mensagens informativas sobre cada etapa do processo de backup.

---

## ⚠️ Atenção

- **Backup:** Sempre faça backup dos seus dados antes de executar operações que alterem dados.
- **Permissões:** Execute o script com permissões administrativas se necessário, especialmente ao acessar serviços do sistema.

---

## 📝 Exemplo de Uso

```plaintext
Configurando o Caminho do Backup.
Digite o caminho de onde deseja salvar os backups: C:\MeusBackups
```

Após configurar, o script iniciará automaticamente o processo de backup.

---

## 📂 Logs e Backup

Os backups são salvos na pasta especificada pelo usuário, com nomes formatados como `Midi_srv_DiaDaSemana.gbk`. Por exemplo, um backup realizado em uma segunda-feira será nomeado como `Midi_srv_Segunda.gbk`.

---

## 🎉 Conclusão

Este script é uma ferramenta útil para gerenciar backups diários do seu banco de dados Firebird. 

Utilize-o com cuidado e aproveite a facilidade que ele proporciona! 

Se tiver dúvidas ou problemas, consulte um profissional qualificado.