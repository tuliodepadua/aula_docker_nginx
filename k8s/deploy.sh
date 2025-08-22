#!/bin/bash

# Script para fazer o deploy completo da aplicação no Kubernetes

echo "🚀 Iniciando deploy no Kubernetes..."

# Configurar Docker para usar o daemon do Minikube
echo "🐳 Configurando Docker para usar daemon do Minikube..."
eval $(minikube docker-env)

# Construir as imagens Docker
echo "🔨 Construindo imagens Docker..."
echo "   📦 Construindo imagem Node.js..."
docker build -t node-app:latest ../node

echo "   🐍 Construindo imagem Python..."
docker build -t py-app:latest ../py

echo "   ✅ Imagens construídas com sucesso!"

# Criar namespace
echo "📁 Criando namespace..."
kubectl apply -f namespace.yaml

# Aguardar um momento
sleep 2

# Deploy dos ConfigMaps
echo "⚙️ Aplicando ConfigMaps..."
kubectl apply -f nginx-configmap.yaml

# Deploy das aplicações backend
echo "🔧 Fazendo deploy das aplicações backend..."
kubectl apply -f node-deployment.yaml
kubectl apply -f py-deployment.yaml

# Aguardar os pods ficarem prontos
echo "⏳ Aguardando pods ficarem prontos..."
kubectl wait --for=condition=ready pod -l app=node-app -n app-namespace --timeout=300s
kubectl wait --for=condition=ready pod -l app=py-app -n app-namespace --timeout=300s

# Deploy do nginx (reverse proxy)
echo "🌐 Fazendo deploy do nginx..."
kubectl apply -f nginx-deployment.yaml

# Aguardar nginx ficar pronto
kubectl wait --for=condition=ready pod -l app=nginx-app -n app-namespace --timeout=300s

echo ""
echo "✅ Deploy concluído!"
echo ""
echo "📊 Status dos recursos:"
kubectl get all -n app-namespace

echo ""
echo "🌍 Para acessar a aplicação:"
echo "   kubectl port-forward service/nginx-service 8080:80 -n app-namespace"
echo "   Depois acesse: http://localhost:8080"
