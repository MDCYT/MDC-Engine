# Changelog

Todos los cambios notables del MDC Engine se documentan aquí.
Este proyecto sigue [SemVer](https://semver.org/lang/es/).

## [2.0.0] - 2026-04-28

### Added

- **Sistema de mods múltiples**: el engine ahora carga **todos** los mods listados en `mods/modList.txt`, no solo `introMod`.
- **`manifest.json` por mod** con nombre, autor, versión, descripción, icono, dependencias y `api_version`.
- Nuevo `ModLoader.hx` que centraliza la inicialización de Polymod, gestiona errores y expone la lista de mods cargados (`ModLoader.loadedMods`).
- Nuevo `ConfigLoader.hx` con soporte transparente de **JSON o TXT** para todos los archivos de configuración (`weeknames`, `creatorsnames`, `freeplaySonglist`, `characterList`, `controls`, `cinematics`, `dialogues`, `intro`, `actualizedmessage`).
- Mod de ejemplo `exampleFullMod/` que demuestra `_merge/`, `_append/` y `manifest.json`.
- Workflow de **GitHub Actions** que compila HTML5 en cada push y PR (`.github/workflows/build-html5.yml`).
- Guía de modding completa en `Modding.md` (formatos, ejemplos, troubleshooting).

### Changed

- `TitleState`, `StoryMenuState`, `FreeplayState`, `ChartingState`, `OptionsMenu`, `PlayState` ahora usan `ConfigLoader.loadList(...)` en vez de leer `.txt` directamente. Compatibilidad total con los txt existentes.
- `mods/modList.txt` ahora soporta comentarios (`#`) y líneas en blanco.
- `mods/readme.txt` actualizado con la estructura nueva.

### Fixed

- Polymod ya no está hardcodeado a `dirs: ['introMod']` — los usuarios pueden activar varios mods sin recompilar el juego.
- Mejor manejo de errores cuando `manifest.json` está mal formado.

### Migration

Los mods existentes siguen funcionando sin cambios. Para aprovechar las
nuevas features, añade un `manifest.json` a tu carpeta de mod.

---

## [1.2.1] - 2021

- Error de los diálogos solucionado.

## [1.2.0] - 2021-07-16

### Added
- Cinemáticas personalizables (agregar y quitar cinemáticas).
- Diálogos personalizables (agregar y quitar diálogos).
- Pantalla de inicio personalizable (creadores, logo e inicio editable).
- Build de 32 Bits.

## [1.1.0] - 2021-07-16

### Added
- Cinemáticas.
- Mensaje de la semana editable.

## [1.0.0] - 2021-07-16

### Added
- El juego base.
