# Guía de Modding — MDC Engine

> **Versión 2.0 — modding sin programar.**
> Esta guía explica cómo crear mods para MDC Engine **sin tocar una sola línea de Haxe**. Todo se hace con archivos de texto, JSON y assets.

---

## 1. Estructura de un mod

Cada mod vive en su propia carpeta dentro de `mods/`:

```
mods/
├── modList.txt              ← lista de mods activos (uno por línea)
├── miMod/
│   ├── manifest.json        ← metadata del mod
│   ├── _append/             ← contenido que se AÑADE al base
│   │   └── data/
│   │       └── introText.txt
│   ├── _merge/              ← contenido que REEMPLAZA al base
│   │   └── data/
│   │       └── weeknames.json
│   ├── images/              ← sprites custom (sobreescriben los del juego)
│   ├── music/
│   └── sounds/
```

### `_append/` vs `_merge/`

| Carpeta   | Comportamiento                                                              |
| --------- | --------------------------------------------------------------------------- |
| `_append/`| El contenido del archivo se **añade** al final del archivo original.        |
| `_merge/` | El archivo del mod **reemplaza** al original (útil para JSON estructurado). |

Si un archivo está fuera de `_append/` y `_merge/`, simplemente sobreescribe al asset original (típico para imágenes o sonidos).

---

## 2. `modList.txt`

Una línea = un mod. Líneas en blanco y las que empiezan con `#` se ignoran.

```txt
# mods activos
introMod
exampleFullMod
miMod
```

El orden importa: los mods de abajo pueden sobreescribir cambios de los mods de arriba.

---

## 3. `manifest.json`

Describe tu mod. Es opcional pero recomendado.

```json
{
  "name": "Mi Mod Increíble",
  "author": "TuNombre",
  "version": "1.2.0",
  "description": "Cambia las semanas y agrega música nueva.",
  "homepage": "https://github.com/tuusuario/mi-mod",
  "icon": "images/icon.png",
  "api_version": "2.0.0",
  "dependencies": []
}
```

| Campo         | Tipo      | Descripción                                  |
| ------------- | --------- | -------------------------------------------- |
| `name`        | string    | Nombre legible.                              |
| `author`      | string    | Autor o equipo.                              |
| `version`     | string    | SemVer recomendado (`1.0.0`).                |
| `description` | string    | Resumen corto.                               |
| `icon`        | string?   | Ruta relativa a una imagen 150×150.          |
| `homepage`    | string?   | URL del repositorio o sitio del mod.         |
| `api_version` | string?   | Versión del engine para la que se hizo.      |
| `dependencies`| string[]? | IDs de otros mods requeridos.                |

---

## 4. Archivos de configuración soportados

Todos estos archivos viven en `assets/preload/data/` (en el base) o en
`<mod>/_merge/data/` o `<mod>/_append/data/`. **Todos aceptan ahora formato JSON
además del .txt clásico**, gracias a `ConfigLoader`.

| Archivo               | Qué controla                                | Formato legacy | Formato JSON              |
| --------------------- | ------------------------------------------- | -------------- | ------------------------- |
| `weeknames`           | Nombres de las semanas en Story Mode        | una por línea  | `{ "values": [ ... ] }`   |
| `creatorsnames`       | Nombres en la pantalla de créditos          | una por línea  | `{ "values": [ ... ] }`   |
| `freeplaySonglist`    | Canciones del modo Freeplay                 | una por línea  | `{ "values": [ ... ] }`   |
| `characterList`       | Personajes seleccionables en el chart editor| una por línea  | `{ "values": [ ... ] }`   |
| `controls`            | Bindings de teclado                         | par línea/clave| `{ "values": [ ... ] }`   |
| `cinematics`          | Flag (`1`/`0`) por semana                   | una por línea  | `{ "values": [ ... ] }`   |
| `dialogues`           | Flag (`1`/`0`) por canción de Story         | una por línea  | `{ "values": [ ... ] }`   |
| `intro`               | Líneas del logo intro                       | una por línea  | `{ "values": [ ... ] }`   |
| `introText`           | Mensajes random del logo (`a--b`)           | una por línea  | (mejor mantener en .txt)  |
| `actualizedmessage`   | `1`/`0` para mostrar pantalla "actualízate" | una línea      | `{ "values": ["1"] }`     |
| `specialThanks`       | Lista de agradecimientos                    | una por línea  | `{ "values": [ ... ] }`   |

### Ejemplo: cambiar las semanas

`mods/miMod/_merge/data/weeknames.json`:

```json
{
  "values": [
    "Tutorial",
    "Mi Semana 1",
    "Mi Semana 2"
  ]
}
```

### Ejemplo: añadir mensajes random al intro

`mods/miMod/_append/data/introText.txt`:

```
mi mod--esta vivo
hola desde--miMod
```

---

## 5. Charts y canciones

Las canciones siguen el formato JSON estándar de Friday Night Funkin.

```
mods/miMod/_merge/data/micancion/
  micancion.json
  micancion-easy.json
  micancion-hard.json
mods/miMod/songs/micancion/
  Inst.ogg
  Voices.ogg
```

Para agregarla al Freeplay, en `_merge/data/freeplaySonglist.json`:

```json
{ "values": ["Tutorial", "Micancion"] }
```

---

## 6. Personajes custom

Los personajes se cargan por nombre en `Character.hx`. Para añadir un personaje
visual sin programar, basta con sustituir el sprite/atlas:

```
mods/miMod/images/BOYFRIEND.png
mods/miMod/images/BOYFRIEND.xml
```

Si quieres un personaje **nuevo** con animaciones distintas, agrégalo a
`characterList.json` y provee sus assets bajo `images/<nombre>.png` + `.xml`.

---

## 7. Activar y debug

1. Coloca tu carpeta dentro de `mods/`.
2. Añade el nombre a `mods/modList.txt`.
3. Lanza el juego.
4. En consola/log verás:
   ```
   [ModLoader] Loaded mod "Mi Mod Increíble" v1.2.0 by TuNombre
   ```

Si algún `manifest.json` está mal escrito, verás el error en el log pero el mod
seguirá cargando con valores por defecto.

---

## 8. Compatibilidad con la 1.x

Los mods viejos que solo usaban `_append/data/introText.txt` siguen funcionando
sin cambios. El nuevo cargador respeta el comportamiento anterior.

---

## 9. Recursos

- [Polymod (motor de mods)](https://github.com/larsiusprime/polymod)
- [HaxeFlixel Docs](https://haxeflixel.com/documentation/)
- [Friday Night Funkin'](https://github.com/FunkinCrew/Funkin)

¿Dudas? Abre un issue en [MDCYT/MDC-Engine](https://github.com/MDCYT/MDC-Engine/issues).
