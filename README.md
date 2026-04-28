# Friday Night Funkin' — MDC Engine

[![Discord](https://img.shields.io/discord/778038568680554497?label=discord)](https://discord.gg/dae)
[![Issues](https://img.shields.io/github/issues/MDCYT/MDC-Engine)](https://github.com/MDCYT/MDC-Engine/issues)
[![PRs](https://img.shields.io/github/issues-pr/MDCYT/MDC-Engine)](https://github.com/MDCYT/MDC-Engine/pulls)
[![Build HTML5](https://github.com/MDCYT/MDC-Engine/actions/workflows/build-html5.yml/badge.svg)](https://github.com/MDCYT/MDC-Engine/actions/workflows/build-html5.yml)
![Repo size](https://img.shields.io/github/repo-size/MDCYT/MDC-Engine)
![Plataformas](https://img.shields.io/badge/plataformas-windows%20%7C%20macOS%20%7C%20linux%20%7C%20html5-blue)
![License](https://img.shields.io/github/license/MDCYT/MDC-Engine)

**MDC Engine** es un fork moddeable del [Friday Night Funkin'](https://github.com/FunkinCrew/Funkin) original, pensado para que cualquiera pueda crear mods **sin programar**: solo editas archivos `.txt`/`.json`, drop & play.

> Versión 2.0 (abril 2026): sistema de mods múltiple, `manifest.json`, configuración JSON, CI automatizado y guía de modding completa. Lee el [CHANGELOG](CHANGELOG.md).

---

## ¿Qué puedes modificar sin tocar código?

- Nombres de las semanas, créditos, agradecimientos
- Lista de canciones de Freeplay
- Personajes seleccionables en el chart editor
- Cinemáticas y diálogos por canción
- Mensajes random del intro
- Sprites, música, sonidos, fondos, fuentes
- Charts (JSON estándar de FNF)

Cómo hacerlo está explicado en [Modding.md](Modding.md).

---

## Créditos

- [ninjamuffin99](https://twitter.com/ninja_muffin99) — programador de la base
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) y [Evilsk8r](https://twitter.com/evilsk8r) — arte de la base
- [Kawaisprite](https://twitter.com/kawaisprite) — música de la base
- [MDC](https://twitter.com/fridayproblems) — programador del engine
- [larsiusprime](https://github.com/larsiusprime) — Polymod (motor de mods)

---

## Descargar

Si solo quieres jugar, descarga la última build desde la sección de [Releases](https://github.com/MDCYT/MDC-Engine/releases) o de los artifacts de GitHub Actions.

---

## Compilar desde código

### Requisitos

- [Haxe 4.3.4](https://haxe.org/download/) o superior
- Git

### Instalación de dependencias

```bash
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
haxelib install actuate
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib run lime setup flixel
haxelib run lime setup
```

Para Discord RPC y soporte WEBM (solo desktop):

```bash
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git extension-webm https://github.com/GrowtopiaFli/extension-webm
lime rebuild extension-webm windows   # o linux / mac
```

### Compilar

```bash
# Para web (rápido, ideal para iterar)
lime test html5 -debug

# Para Windows
lime test windows -debug

# Para Linux
lime test linux -debug

# Build final
lime build html5 -release
lime build windows -final
```

Los builds quedan en `export/release/<plataforma>/bin`.

> **Windows**: necesitas Visual Studio 2022 con _Desktop development with C++_. La primera compilación tarda ~30–60 min, las siguientes son rápidas.

---

## Estructura del proyecto

```
MDC-Engine/
├── source/              ← código Haxe del engine
│   ├── ModLoader.hx     ← carga los mods declarados en mods/modList.txt
│   ├── ConfigLoader.hx  ← lee data/*.json o *.txt indistintamente
│   └── ...
├── assets/              ← assets base (música, sprites, JSON de canciones)
├── example_mods/        ← mods de ejemplo (introMod, exampleFullMod)
├── docs/                ← landing del proyecto (GitHub Pages)
├── Modding.md           ← guía de modding sin código
├── CHANGELOG.md
└── Project.xml
```

---

## Crear un mod (TL;DR)

```bash
mkdir -p mods/miMod/_merge/data
echo '{ "values": ["Tutorial", "Mi Semana"] }' > mods/miMod/_merge/data/weeknames.json
echo "miMod" >> mods/modList.txt
```

¡Y listo! Lee [Modding.md](Modding.md) para todos los detalles.

---

## Contribuir

PRs bienvenidos. Por favor:

1. Abre un issue describiendo el cambio antes de PRs grandes.
2. Mantén compatibilidad con mods 1.x cuando sea posible.
3. Asegúrate de que el workflow de CI pase (build HTML5).

---

## Licencia

Este proyecto hereda la licencia del FNF original — ver [LICENSE](LICENSE).
