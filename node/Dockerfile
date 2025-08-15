FROM node:18-alpine

WORKDIR /app

# Instala dependências primeiro para aproveitar cache
COPY package*.json ./ 
RUN npm install

# Copia o código
COPY . .

# Boa prática: expor porta "informativa"
EXPOSE 3000

# Usuário não-root (opcional, melhora segurança)
RUN addgroup -S app && adduser -S app -G app
USER app

CMD ["node", "app.js"]
