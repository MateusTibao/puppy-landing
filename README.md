# Puppy | Landing page com lista de espera

Página única (`index.html`) que grava os cadastros num banco Supabase (Postgres, plano gratuito). Não tem servidor nem build: é só publicar no GitHub Pages.

```
puppy-landing/
├── index.html                          a página inteira (HTML, CSS e JS)
├── supabase.sql                        cria a tabela e as regras de segurança
├── .github/workflows/keepalive.yml     ping semanal que evita a pausa do plano gratuito
└── README.md
```

## Passo a passo (uns 15 minutos)

### 1. Criar o banco no Supabase
1. Acesse supabase.com, entre com a conta do GitHub e clique em **New project**.
2. Dê um nome (ex.: `puppy`), crie uma senha do banco (guarde) e escolha a região **South America (São Paulo)**.
3. Espere uns 2 minutos até o projeto ficar pronto.

### 2. Criar a tabela
1. No menu lateral, abra **SQL Editor** e clique em **New query**.
2. Cole o conteúdo de `supabase.sql` e clique em **Run**.
3. Em **Table Editor**, a tabela `lista_espera` deve aparecer vazia.

### 3. Copiar a URL e a chave pública
1. Vá em **Project Settings > API Keys**.
2. Copie a **Project URL** (`https://xxxx.supabase.co`).
3. Copie a **Publishable key** (`sb_publishable_...`). Se o painel só mostrar chaves antigas, use a chave **anon** da aba *Legacy API keys*.
4. **Nunca use** a `secret` nem a `service_role` na página. Elas dão acesso total ao banco.

### 4. Colar no index.html
Abra `index.html`, procure o bloco `CONFIG` perto do fim do arquivo e preencha:

```js
const CONFIG = {
  SUPABASE_URL: "https://xxxx.supabase.co",
  SUPABASE_KEY: "sb_publishable_...",
  CONTACT_EMAIL: "contato@seudominio.com"   // opcional, aparece no FAQ de dados
};
```

A chave pública pode ficar visível no código. Quem a vê só consegue **inserir** cadastros, porque a tabela só aceita isso para o papel `anon`.

### 5. Publicar no GitHub Pages
1. Crie um repositório novo, por exemplo `puppy-landing`, e envie estes arquivos.
2. Em **Settings > Pages**, escolha **Deploy from a branch**, branch `main`, pasta `/ (root)`.
3. Em 1 ou 2 minutos a página abre em `https://SEU-USUARIO.github.io/puppy-landing/`.

### 6. Testar de verdade
1. Abra a página, preencha o formulário e envie.
2. Confira o cadastro em **Table Editor > lista_espera**.
3. Para baixar a lista: botão **Export > CSV** no mesmo lugar.

### 7. Evitar a pausa do banco (importante)
O plano gratuito do Supabase pausa o projeto depois de 7 dias sem uso. Numa apresentação, isso derruba o cadastro. O arquivo `.github/workflows/keepalive.yml` faz um ping toda segunda e quarta.

1. No repositório, vá em **Settings > Secrets and variables > Actions > New repository secret**.
2. Crie `SUPABASE_URL` (a Project URL) e `SUPABASE_KEY` (a mesma chave pública).
3. Em **Actions**, abra "Manter Supabase ativo" e clique em **Run workflow** para testar. Deve terminar verde.

O GitHub desliga workflows agendados em repositórios sem nenhuma atividade por 60 dias. Se isso acontecer, é só abrir a aba Actions e reativar. Se o projeto chegar a pausar, o botão **Restore** no painel do Supabase traz tudo de volta, com os dados.

## Como funciona o formulário

- **Obrigatórios:** perfil (lojista ou fornecedor), nome, e-mail, WhatsApp e o aceite de contato. Empresa, segmento e cidade ficam num bloco opcional para não afastar quem tem pressa.
- **Validação:** feita na página (mensagens junto de cada campo) e de novo no banco, com as regras da tabela.
- **E-mail repetido:** o banco recusa, mas a página mostra a mesma tela de sucesso. Assim ninguém descobre quem já está na lista testando e-mails.
- **Robôs:** um campo escondido (`site`) é preenchido por robôs e ignorado por pessoas. Quando preenchido, nada é gravado.
- **Origem:** se o link tiver `?utm_source=instagram`, o valor vai para a coluna `origem`.
- **Erro de rede:** a página avisa e mantém o que a pessoa digitou.

## Dados pessoais (LGPD)

A página pede consentimento explícito e diz para que os dados são usados. Vale combinar no grupo:
- quem tem acesso ao painel do Supabase (só quem precisa);
- um e-mail para pedidos de exclusão (campo `CONTACT_EMAIL`);
- apagar a lista ao fim da disciplina, se ela não for continuar.

## Ajustes comuns

- **Mudar textos e cores:** o início do `<style>` tem as cores do protótipo (`--primary`, `--ink`, `--secondary`). Os textos estão no HTML.
- **Domínio próprio:** em Settings > Pages, campo *Custom domain*.
- **Dados da pesquisa na página:** a frase "Ouvimos 8 lojistas..." usa os números da pesquisa do grupo. Se coletarem mais respostas, atualize o texto na seção "Um app para quem compra e para quem vende".
