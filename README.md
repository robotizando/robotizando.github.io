# robotizando.github.io

Site/portfólio pessoal de **Daniel Omar Basconcello Filho**, construído com
[Jekyll](https://jekyllrb.com/) usando o tema remoto
[portfolYOU](https://github.com/YoussefRaafatNasry/portfolYOU) e publicado via **GitHub Pages**.

> Este `README.md` é apenas para desenvolvimento — está na lista `exclude` do
> [`_config.yml`](_config.yml) e **não** é publicado no site.

---

## 1. Instalação do Ruby e dependências

O site usa o conjunto de gems **`github-pages`** (que fixa Jekyll 3.9.x), declarado no
[`Gemfile`](Gemfile). É necessário **Ruby** com **Bundler**.

### Pré-requisitos

| Ferramenta | Versão recomendada | Verificar |
|------------|--------------------|-----------|
| Ruby       | 3.2.x (3.0+ funciona) | `ruby --version` |
| Bundler    | 2.4+               | `bundle --version` |
| Node/Chrome | qualquer + Google Chrome/Chromium | só para gerar o PDF do CV |

### 1.1. Instalar o Ruby

**Ubuntu / Debian (Ruby do sistema):**

```bash
sudo apt update
sudo apt install -y ruby-full build-essential zlib1g-dev
```

**Recomendado — gerenciador de versões (evita conflitos de versão/permissão):**

```bash
# rbenv
sudo apt install -y rbenv
rbenv install 3.2.3
rbenv global 3.2.3

# ou rvm
# \curl -sSL https://get.rvm.io | bash -s stable --ruby=3.2.3
```

> **Por que um gerenciador de versões?** Os binstubs de `bundle`/`jekyll` gravam um
> *shebang* fixo apontando para a versão de Ruby usada na instalação (ex.: `#!/usr/bin/env ruby3.0`).
> Se essa versão não existir mais, você verá `/usr/bin/env: 'ruby3.0': No such file or directory`.
> Um gerenciador de versões mantém o Ruby e os binstubs consistentes. Veja o
> [Troubleshooting](#3-troubleshooting) se cair nesse erro.

### 1.2. Instalar o Bundler

```bash
gem install bundler
```

### 1.3. Instalar as dependências do projeto

Instale as gems **no diretório do projeto** (`vendor/bundle`), evitando precisar de `sudo`
e mantendo o ambiente isolado:

```bash
cd robotizando.github.io
bundle config set --local path 'vendor/bundle'
bundle install
```

> `vendor/` e `.bundle/` já estão no [`.gitignore`](.gitignore) e não são commitados.

---

## 2. Rodar o site localmente

```bash
# servidor com auto-reload em http://localhost:4000
bundle exec jekyll serve

# apenas gerar os arquivos estáticos em _site/
bundle exec jekyll build
```

Páginas principais:

- `/` — landing
- `/about/` — Currículo (CV) — fonte em [`pages/about.md`](pages/about.md) + dados em [`_data/`](_data/)
- `/resume/` — versão limpa do CV para impressão/PDF (ver seção 4)

---

## 3. Troubleshooting

rbenv init

**`/usr/bin/env: 'ruby3.0': No such file or directory` ao rodar `bundle`/`jekyll`**

Os binstubs em `/usr/local/bin/bundle` e `/usr/local/bin/jekyll` têm o shebang fixo numa
versão de Ruby que não existe mais. Soluções, da melhor para a alternativa:

1. **Use um gerenciador de versões** (rbenv/rvm) e reinstale `bundler` + `bundle install`
   com o Ruby ativo — os novos binstubs apontarão para o Ruby correto.
2. **Reinstale o bundler** para o seu Ruby atual:
   `gem install bundler && hash -r`.
3. **Contorno pontual** — invoque o bundler com o Ruby disponível, ignorando o shebang:
   ```bash
   ruby3.2 $(gem contents bundler | grep -m1 'exe/bundle$') install
   ruby3.2 $(gem contents bundler | grep -m1 'exe/bundle$') exec jekyll build
   ```

**`Bundler::PermissionError ... /var/lib/gems`** — você está tentando instalar gems no caminho
do sistema sem permissão. Rode `bundle config set --local path 'vendor/bundle'` (seção 1.3).

**`Invalid date ... vendor/bundle/.../_posts/...erb`** — o Jekyll está tentando processar a pasta
`vendor`. Ela já está em `exclude:` no [`_config.yml`](_config.yml); garanta que essa entrada existe.

**`GitHub Metadata: API rate limit exceeded`** — aviso inofensivo no build local (apenas
preenche metadados do GitHub). Pode ignorar, ou exportar um token:
`export JEKYLL_GITHUB_TOKEN=<seu_token>`.

---

## 4. Gerar o currículo em PDF

O CV em PDF (para enviar a empresas) é gerado a partir da página `/resume/`.
Instruções completas em **[`scripts/README-cv-pdf.md`](scripts/README-cv-pdf.md)**. Resumo:

```bash
./scripts/generate-cv-pdf.sh
# → assets/cv/Daniel-Basconcello-Filho-CV.pdf
```

O botão **"Download CV"** em `/about/` aponta para esse arquivo. Regenere e recommite o PDF
sempre que editar [`_data/`](_data/) (skills/experiência) ou o layout
[`_layouts/resume.html`](_layouts/resume.html).
