# Vontimitta Heritage Blog

A traditional-looking static Vue.js website about Vontimitta, focused on:

- Vontimitta history
- Sri Kodandarama Swamy Temple
- Festival / Brahmotsavam
- Recent and historic photographs
- Traditional heritage visual design

## Tech stack

- Vue 3
- Vite
- Plain CSS
- No backend
- No database
- No Docker
- No Kubernetes

## Run locally

```bash
npm install
npm run dev
```

Then open the local URL shown by Vite.

## Production build

```bash
npm run build
npm run preview
```

The production files will be generated inside `dist/`.

## Important image note

The gallery currently references image URLs from published sources so the project remains small.

Before using this website publicly, replace the remote image URLs in:

`src/data/content.js`

with photographs you own, have permission to use, or have verified as appropriately licensed.

## Main project structure

```text
vontimitta-blog/
├── index.html
├── package.json
├── vite.config.js
├── README.md
└── src/
    ├── main.js
    ├── App.vue
    ├── style.css
    └── data/
        └── content.js
```

## Content sources used while preparing the starter content

- Government of Andhra Pradesh — YSR Kadapa District: https://kadapa.ap.gov.in/vontimitta/
- Archaeological Survey of India: https://asi.nic.in/
- TTD News — Vontimitta: https://news.tirumala.org/vontimitta/

This is a starter heritage site, not an official temple/TTD website.
