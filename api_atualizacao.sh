#!/bin/bash

# Exibir a data e hora para o início do processo
echo "===================="
echo "Início do processo: $(date)"
echo "===================="

# 1. Criar backup do arquivo db.json
echo "Criando backup do arquivo db.json..."
cp db.json db.json-bkp
if [ $? -ne 0 ]; then
  echo "Erro ao criar o backup do arquivo db.json."
  exit 1
fi

# 2. Resetar alterações e realizar pull do Git
echo "Resetando alterações locais e puxando novas mudanças do repositório Git..."
git reset --hard
git pull
if [ $? -ne 0 ]; then
  echo "Erro ao executar git pull."
  exit 1
fi
echo "Git atualizado com sucesso."

# 3. Restaurar o arquivo db.json original do backup
echo "Restaurando o arquivo db.json a partir do backup..."
cp db.json-bkp db.json
if [ $? -ne 0 ]; then
  echo "Erro ao restaurar o arquivo db.json."
  exit 1
fi

# 4. Alterar permissões do diretório /api-suite-integration
echo "Alterando permissões do diretório /api-suite-integration..."
sudo chmod 777 -R /api-suite-integration-compiler
if [ $? -ne 0 ]; then
  echo "Erro ao alterar permissões do diretório /api-suite-integration."
  exit 1
fi

# 5. Executar o script de compilação
echo "Executando o script compile-integration.sh..."
./upgrade-unix.sh
if [ $? -ne 0 ]; then
  echo "Erro ao executar o script compile-integration.sh."
  exit 1
fi
echo "Migração realizada com sucesso."

# 6. Reiniciar os serviços
echo "Reiniciando os serviços api-gestaoparts e api-gestaoparts-notify..."
sudo service api-gestaoparts restart
if [ $? -ne 0 ]; then
  echo "Erro ao reiniciar o serviço api-gestaoparts."
  exit 1
fi

sudo service api-gestaoparts-notify restart
if [ $? -ne 0 ]; then
  echo "Erro ao reiniciar o serviço service api-gestaoparts-notify-notify."
  exit 1
fi

# Mensagem final
echo "===================="
echo "Operação realizada com sucesso!"
echo "Término do processo: $(date)"
echo "===================="
