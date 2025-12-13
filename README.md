# Jaroslav Pesek - Personal Website

Personal academic website built with Hugo, managed via Nix flake.

## Development

```bash
# Enter development shell
nix develop

# Generate publications data and start local server
mkdir -p site/data
pandoc site/content/publications.bib -t csljson -o site/data/publications.json
cd site
hugo server

# Build production site
hugo --minify -d ../dist
```

## Structure

```
site/
├── content/          # Markdown content
│   ├── _index.md     # Home/About
│   ├── research/     # Research interests
│   ├── publications/ # Auto-generated from .bib
│   ├── teaching/     # Teaching info
│   └── articles/     # Articles (formerly Blog)
├── layouts/          # Template overrides
├── assets/css/       # CSS overrides
└── data/             # Generated data (publications.json)
```

## Publications

Publications are managed via `site/content/publications.bib`. During build:
1. Pandoc converts BibTeX to CSL-JSON
2. Hugo template renders all entries grouped by year

## Theme

Theme is configured in `site/hugo.toml` via Hugo Modules. To change theme:
1. Edit `module.imports` in `hugo.toml`
2. Run `hugo mod tidy` in `site/` directory
3. Rebuild

## Deployment

GitHub Actions builds with Nix and deploys to GitHub Pages automatically on push to main.
