# Deploy no Render - MateriÁguas

## Pré-requisitos

1. Conta no [GitHub](https://github.com)
2. Conta no [Render](https://render.com)
3. Banco MySQL externo (ver opções abaixo)

---

## Passo 1: Criar Banco de Dados MySQL

O Render não tem MySQL nativo. Use uma dessas opções:

### Opção A: PlanetScale (Recomendado - Grátis)

1. Acesse [planetscale.com](https://planetscale.com)
2. Crie uma conta e um novo banco de dados
3. Escolha a região mais próxima (us-east-1)
4. Copie as credenciais de conexão:
   - Host: `aws.connect.psdb.cloud`
   - Username: (gerado)
   - Password: (gerado)
   - Database: nome do seu banco
   - Port: 3306

### Opção B: Railway MySQL (~$5/mês)

1. Acesse [railway.app](https://railway.app)
2. New Project → Database → MySQL
3. Copie as credenciais

### Opção C: Clever Cloud MySQL (Grátis tier limitado)

1. Acesse [clever-cloud.com](https://clever-cloud.com)
2. Crie um addon MySQL

---

## Passo 2: Subir Código para GitHub

```bash
# No terminal (PowerShell ou Git Bash)
cd "C:\Users\Felippe Souza\Desktop\Aplicativo materiaguas\sistema-de-pocos-api-aplicativo"

# Inicializar git (se ainda não tiver)
git init

# Adicionar todos os arquivos
git add .

# Commit inicial
git commit -m "Preparado para deploy no Render"

# Criar repositório no GitHub e conectar
# Vá em github.com → New Repository → materiaguas-api
git remote add origin https://github.com/SEU_USUARIO/materiaguas-api.git
git branch -M main
git push -u origin main
```

---

## Passo 3: Criar Web Service no Render

1. Acesse [dashboard.render.com](https://dashboard.render.com)

2. Clique em **New +** → **Web Service**

3. Conecte seu repositório GitHub

4. Configure:
   - **Name:** `materiaguas`
   - **Environment:** `Docker`
   - **Plan:** `Starter ($7/month)` ou `Free` (com limitações)

5. Clique em **Advanced** e adicione as variáveis de ambiente:

| Key | Value |
|-----|-------|
| `RAILS_ENV` | `production` |
| `RACK_ENV` | `production` |
| `SECRET_KEY_BASE` | (clique em Generate) |
| `DB_HOST` | (do PlanetScale/Railway) |
| `DB_USERNAME` | (do PlanetScale/Railway) |
| `DB_PASSWORD` | (do PlanetScale/Railway) |
| `DB_PORT` | `3306` |
| `DB_NAME` | (nome do banco) |
| `RAILS_SERVE_STATIC_FILES` | `true` |
| `RAILS_LOG_TO_STDOUT` | `true` |
| `GOOGLE_MAPS_KEY` | (sua chave) |

6. Clique em **Create Web Service**

---

## Passo 4: Rodar Migrations

Após o primeiro deploy, vá no painel do Render:

1. Clique no seu serviço `materiaguas`
2. Vá em **Shell** (no menu lateral)
3. Execute:

```bash
bundle exec rake db:migrate
bundle exec rake db:seed
```

---

## Passo 5: Configurar Domínio (Opcional)

1. No painel do Render → seu serviço → **Settings**
2. Em **Custom Domains**, adicione seu domínio
3. Configure o DNS do seu domínio apontando para o Render

---

## Troubleshooting

### Erro de conexão com banco

Verifique se o PlanetScale/Railway está permitindo conexões externas.
No PlanetScale, você precisa usar SSL:

Adicione no `config/database.yml`:
```yaml
production:
  <<: *default
  database: <%= ENV.fetch("DB_NAME") { 'materiaguas_production' } %>
  sslca: /etc/ssl/certs/ca-certificates.crt
```

### Assets não carregam

Verifique se `RAILS_SERVE_STATIC_FILES=true` está configurado.

### Erro de memória

O plano Free tem apenas 512MB. Use o plano Starter ($7) com 1GB.

---

## URLs

Após o deploy, sua aplicação estará em:
- `https://materiaguas.onrender.com`

Para API:
- `POST https://materiaguas.onrender.com/api/v1/authenticate`
- `GET https://materiaguas.onrender.com/api/v1/all/:data`

---

## Custos Estimados

| Serviço | Plano | Custo |
|---------|-------|-------|
| Render Web Service | Starter | $7/mês |
| PlanetScale MySQL | Free | $0/mês |
| **Total** | | **$7/mês (~R$35)** |
