#!/bin/bash

# Script para construir apenas as imagens Docker

echo "🔨 Construindo imagens Docker para Kubernetes..."

# Configurar Docker para usar o daemon do Minikube
echo "🐳 Configurando Docker para usar daemon do Minikube..."
eval $(minikube docker-env)

echo "📦 Construindo imagem Node.js no Minikube..."
docker build -t node-app:latest ../node

if [ $? -eq 0 ]; then
    echo "✅ Imagem Node.js construída com sucesso!"
else
    echo "❌ Erro ao construir imagem Node.js"
    exit 1
fi

echo ""
echo "🐍 Construindo imagem Python no Minikube..."
docker build -t py-app:latest ../py

if [ $? -eq 0 ]; then
    echo "✅ Imagem Python construída com sucesso!"
else
    echo "❌ Erro ao construir imagem Python"
    exit 1
fi

echo ""
echo "🎉 Todas as imagens foram construídas com sucesso no Minikube!"
echo ""
echo "📋 Imagens criadas:"
docker images | grep -E "(node-app|py-app)"
