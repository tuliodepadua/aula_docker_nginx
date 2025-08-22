# Deploy no Kubernetes

Este diretório contém os manifestos YAML necessários para fazer o deploy da aplicação no Kubernetes.

## Estrutura dos arquivos

- `namespace.yaml`: Define o namespace `app-namespace` para isolar os recursos
- `node-deployment.yaml`: Deployment e Service para a aplicação Node.js
- `py-deployment.yaml`: Deployment e Service para a aplicação Python/Flask
- `nginx-configmap.yaml`: ConfigMap com a configuração do nginx
- `nginx-deployment.yaml`: Deployment e Service para o nginx (reverse proxy)
- `deploy.sh`: Script para automatizar o deploy completo
- `build-images.sh`: Script para construir apenas as imagens Docker

## Pré-requisitos

1. **Minikube** funcionando (`minikube start`)
2. `kubectl` configurado e conectado ao cluster
3. Docker instalado (para construir as imagens)

**Nota**: As imagens Docker serão construídas automaticamente no daemon Docker do Minikube.

## Como fazer o deploy

### Opção 1: Deploy automático (recomendado)

O script `deploy.sh` irá:
1. Configurar Docker para usar o daemon do Minikube
2. Construir automaticamente as imagens Docker no Minikube
3. Criar o namespace
4. Aplicar todos os manifestos na ordem correta

```bash
cd k8s
chmod +x deploy.sh
./deploy.sh
```

### Opção 2: Deploy manual

```bash
# 1. Configurar Docker para usar daemon do Minikube
eval $(minikube docker-env)

# 2. Construir as imagens Docker no Minikube
docker build -t node-app:latest ../node
docker build -t py-app:latest ../py

# 3. Criar namespace
kubectl apply -f namespace.yaml

# 4. Aplicar ConfigMaps
kubectl apply -f nginx-configmap.yaml

# 5. Deploy das aplicações
kubectl apply -f node-deployment.yaml
kubectl apply -f py-deployment.yaml
kubectl apply -f nginx-deployment.yaml
```

### Opção 3: Construir apenas as imagens

Se você quiser construir apenas as imagens Docker sem fazer o deploy:

```bash
cd k8s
chmod +x build-images.sh
./build-images.sh
```

## ⚠️ Importante para Minikube

Este projeto está configurado para funcionar com **Minikube**. As imagens são construídas diretamente no daemon Docker do Minikube usando `imagePullPolicy: Never`, o que significa que o Kubernetes não tentará baixar as imagens de um registry externo.

## Verificar o deploy

```bash
# Ver todos os recursos
kubectl get all -n app-namespace

# Ver pods
kubectl get pods -n app-namespace

# Ver services
kubectl get services -n app-namespace
```

## Acessar a aplicação

### Usando port-forward (desenvolvimento)

```bash
kubectl port-forward service/nginx-service 8080:80 -n app-namespace
```

Depois acesse: http://localhost:8080

### Usando LoadBalancer (produção)

Se estiver em um cluster que suporta LoadBalancer:

```bash
kubectl get service nginx-service -n app-namespace
```

Use o IP externo fornecido.

## Rotas disponíveis

- `/` - Página inicial do nginx
- `/node/` - Aplicação Node.js
- `/py/` - Aplicação Python/Flask

## Limpeza

Para remover tudo:

```bash
kubectl delete namespace app-namespace
```

## Características do deploy

- **Alta disponibilidade**: 2 réplicas para Node.js e Python
- **Isolamento**: Namespace dedicado
- **Configuração externa**: nginx.conf via ConfigMap
- **Resource limits**: Limites de CPU e memória definidos
- **Service discovery**: Comunicação entre pods via DNS do Kubernetes
