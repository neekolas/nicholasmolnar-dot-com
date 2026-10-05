# nicholasmolnar.com

Status: layout C and typography C (native system sans serif, 16px body, 24px title) are implemented in Zola 0.23.6. The local production preview and draft server are running. Cloudflare publication is waiting for the hosting account to be selected.

The home page has the exact supplied copy and the approved GitHub, X, LinkedIn, and email links. An example Markdown post is a draft. Production shows an empty post list until a real post is published.

Validation passed for Markdown rendering, post order, draft exclusion, draft preview, internal links, deleted-post cleanup, and zero production scripts. The home page is 1,546 bytes including its inline CSS. The CSS source is 784 bytes.

## Recommendation

Use Zola with custom HTML templates and one small stylesheet. Use Cloudflare Workers Static Assets to serve the generated files. Do not add a Worker script.

The research makes a useful distinction: small output and a small generator are separate goals. All three leading options can produce the same HTML. For this site, Zola gives the simplest ongoing work: add a Markdown file, then run one build command. It includes Markdown conversion, page metadata, and sorted post lists in one binary.

| Option | Fit for this site |
| --- | --- |
| Zola | Recommended. One build tool. Small templates. No custom post discovery or metadata parser. The generator itself is larger. |
| ssg + lowdown | Small source, but requires a separate Markdown tool and extra work for the post index. |
| Custom Rust generator | Small code that we can read in full. We would own file discovery, metadata, escaping, ordering, and output cleanup. Choose this if generator source size matters more than build setup. |

Use no theme, CSS framework, web fonts, browser JavaScript, or analytics. Keep Sass, search, and syntax highlighting off. Keep template source short but readable. Minify generated HTML with Zola. Do not remove language, viewport, titles, headings, or keyboard focus behavior to save bytes.

## Design review

Open `previews/index.html` through a local web server. Each design has a home page and a sample post page.

| Preview | Appearance | Home CSS | Home HTML including CSS | Browser JS |
| --- | --- | ---: | ---: | ---: |
| A | White, Times New Roman, blue links, open space | 493 B | 1,309 B | 0 B |
| B | Gray, Times New Roman, inset rules | 625 B | 1,440 B | 0 B |
| C | White, compact Verdana, narrow vertical rule | 608 B | 1,431 B | 0 B |

Sizes are uncompressed UTF-8 bytes for the current home previews. The comparison page is a review tool and is excluded from the site budget.

The home paragraph is exact. Post titles and external link labels are examples. Their destinations are not final. All three designs place posts on the right on wide screens and below the paragraph on narrow screens.

The target is a 1997 appearance in current browsers. Literal support for a 1997 browser is a separate requirement. The previews use a small responsive layout, which old browsers will not support.

## Content and files

Keep the proposed project small:

```text
zola.toml              Site URL, title, external links, build options
content/
  _index.md            Exact home paragraph and post sort order
  first-post.md        Title, date, draft flag, Markdown body
templates/
  base.html            Page shell, shared CSS, post navigation
  index.html           Home paragraph and external links
  page.html            Post title, date, body, home link
  404.html             Small missing-page response
static/
  robots.txt           Allow indexing
wrangler.jsonc         Static output directory and routing
.github/workflows/
  deploy.yml           Build, check, and deploy on main
```

Store each post directly in `content/`. A file named `first-post.md` becomes `/first-post/`. Its metadata sets the title and date. Sort published posts by date, newest first. Exclude drafts. Generate the right-hand list from the same collection. Use relative site links so previews work on their own host.

Keep external link labels and URLs in one config list. Choose the final destinations during review. Keep the supplied company names as plain text unless links are requested.

## Build and hosting

1. Pin a stable Zola version during implementation. Use the same version locally and in CI.
2. Use `zola serve` for local writing. Its development reload code must not appear in production output.
3. Run `zola build` to create `public/`. Keep generated output out of Git.
4. Use one GitHub Actions workflow to install the pinned Zola release, build, check output, and deploy with a pinned Wrangler version. Check the repository and Cloudflare account before configuring secrets or domains.
5. Set the Wrangler asset directory to `public/`. Omit the Worker entry point. Use static 404 handling.
6. Check the initial deployment on its Cloudflare URL. Then connect `nicholasmolnar.com` and verify HTTPS. Add a `www` redirect only if that hostname is in use or requested.

Cloudflare serves and caches the files directly. There is no application server or database. Node may be used by the deployment tool; it is not part of the site build or browser output.

## Size targets and checks

- Browser JavaScript: 0 bytes.
- Shared CSS: at most 1 KB uncompressed. Inline it in the shared template to avoid another request.
- Home page: target at most 3 KB with a short post list. The list adds bytes as posts are added.
- Fonts, images, and third-party requests: none in the initial design.
- Check narrow and wide screens. Keep long URLs and code blocks from widening the page.
- Check keyboard links, visible focus, headings, and contrast.
- Check Markdown output, published post order, draft exclusion, page titles, and internal links.
- Check direct post URLs and a missing URL on Cloudflare.
- Inspect built HTML for injected scripts and measure actual output sizes.

## Implementation progress

1. Done: select option C.
2. Done: add approved external links; keep the sample post as a draft.
3. Done: add Zola templates, a pinned tool setup, a build workflow, and Cloudflare static asset configuration.
4. Done: check the build, post behavior, and local routing.
5. Remaining: select the Cloudflare account, deploy, configure CI credentials, and verify the domain.

## Sources

- [Supplied research](https://claude.ai/public/artifacts/a76a64ba-3c42-4e36-b72f-9505361892ec)
- [Zola overview: Markdown, templates, and page lists](https://www.getzola.org/documentation/getting-started/overview/)
- [Cloudflare Static Assets: direct file serving and 404 behavior](https://developers.cloudflare.com/workers/static-assets/)
- [Cloudflare static site deployment](https://developers.cloudflare.com/workers/static-assets/get-started/)

The research's exact tool sizes and long-term maintenance forecasts are not acceptance criteria. This plan uses measured preview sizes and official build and hosting documentation.
