# 2026-slides-CIPC

Diapositivas del Campamento Invernal de Programación Competitiva (CIPC) 2026, generadas con [Marp](https://marp.app/).

## Estructura

```
2026-slides-CIPC/
├── Introducción/            # Presentación general del campamento
│   ├── slides.md            # Contenido en Marp
│   ├── cipc.css             # Tema CIPC
│   ├── compile.sh           # Script para compilar
│   └── source/              # PDF original
├── Inicial/                 # Clases nivel inicial
│   ├── Clase 1/
│   │   ├── slides.md
│   │   ├── cipc.css
│   │   ├── compile.sh
│   │   └── source/
│   ├── Clase 2/
│   └── ...
└── Avanzado/                # Clases nivel avanzado
    ├── Clase 1/
    ├── Clase 2_1/
    └── ...
```

Cada clase es independiente: contiene su contenido (`slides.md`), el tema (`cipc.css`), y un script para compilar (`compile.sh`).

## Requisitos

- [Node.js](https://nodejs.org/) (v18 o superior)
- `@marp-team/marp-cli` (se usa via `npx`, no requiere instalación global)
  - Instalación global opcional: `npm install -g @marp-team/marp-cli`
- Para compilar a PDF: Chrome o Chromium instalado
  - Instalación en WSL/Ubuntu: `sudo apt install chromium-browser`

## Compilar una clase

```bash
cd "Inicial/Clase 1"
bash compile.sh            # compila a PDF (slides.pdf)
bash compile.sh html       # compila a HTML (slides.html)
bash compile.sh pptx       # compila a PPTX (slides.pptx)
```

## Vista previa en vivo

```bash
cd "Inicial/Clase 1"
npx @marp-team/marp-cli --server --watch --html --allow-local-files --theme cipc.css .
```

## Compilar todas las clases

```bash
# A HTML (no requiere Chrome)
for dir in Introducción Inicial/*/ Avanzado/*/; do
  (cd "$dir" && bash compile.sh html)
done
```
