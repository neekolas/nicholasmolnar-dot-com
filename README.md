# nicholasmolnar.com

A static Zola site. The pages use system fonts, less than 1 KB of CSS, and no JavaScript. Cloudflare Workers Static Assets serves the files without a Worker script.

## Run locally

Install Node 24, then run:

```sh
npm ci
npm run setup
npm run dev
```

Open http://127.0.0.1:1111. The local server includes drafts and refreshes the page after edits. The setup command installs Zola 0.23.6 in `.bin/` and checks its release checksum. It supports Apple Silicon macOS and x86-64 Linux.

## Write a post

Add a Markdown file in `content/`:

```toml
+++
title = "My first post"
date = 2026-09-27
draft = true
+++
```

Write the post below the metadata. Use a unique file name, such as `my-first-post.md`. It becomes `/my-first-post/`. Set `draft = false` to publish it. Published posts appear in the right-hand list, newest first. The example file stays a draft and is excluded from production.

Edit `content/_index.md` for the home paragraph. Edit `zola.toml` for external links. Edit `templates/style.css` for the design. The shared template inlines this stylesheet in each page.

## Build and check

```sh
npm run check
npm run build
npm run preview
```

The production files are in `public/`. The preview command serves these files through Cloudflare's local runtime at http://localhost:8787. It excludes drafts and includes no reload script. Missing URLs return the custom 404 page.

## Deploy

```sh
npx wrangler login
npm run deploy
```

Use the intended Cloudflare account. The target Worker is `nicholasmolnar-com`. The initial config deploys to its `workers.dev` address. To use the production domain, add this top-level field to `wrangler.jsonc` after checking the domain's current DNS:

```json
"routes": [{ "pattern": "nicholasmolnar.com", "custom_domain": true }]
```

For automatic deployments, add `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` to this repository's GitHub Actions secrets. Use a token scoped to the intended account with permission to deploy Workers. Domain setup can need zone permissions. Do not put tokens in source files. The workflow checks pull requests and deploys pushes to `main`.

The `previews/` folder contains the original design choices. Zola does not publish it.
