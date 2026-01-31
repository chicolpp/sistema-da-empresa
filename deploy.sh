#!/bin/bash
# Script de deploy para VPS

echo "=== Atualizando sistema ==="
apt-get update && apt-get upgrade -y

echo "=== Instalando Docker ==="
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com | sh
fi

echo "=== Instalando Docker Compose ==="
if ! command -v docker-compose &> /dev/null; then
    apt-get install -y docker-compose
fi

echo "=== Clonando repositório ==="
cd /root
rm -rf sistema-da-empresa
git clone https://github.com/chicolpp/sistema-da-empresa.git
cd sistema-da-empresa

echo "=== Iniciando containers ==="
docker-compose -f docker-compose.prod.yml down 2>/dev/null
docker-compose -f docker-compose.prod.yml up -d --build

echo "=== Aguardando banco iniciar ==="
sleep 30

echo "=== Rodando migrations ==="
docker-compose -f docker-compose.prod.yml exec -T app bundle exec rake db:migrate

echo "=== Deploy concluído! ==="
echo "Acesse: http://$(curl -s ifconfig.me)"
