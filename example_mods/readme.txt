MDC ENGINE - Carpeta de mods
============================

Aquí van todos los mods que quieras cargar en el juego.

ESTRUCTURA:
  mods/
    modList.txt          <- lista de carpetas a cargar (una por línea)
    miMod/
      manifest.json      <- metadata: nombre, autor, versión, descripción
      _append/           <- archivos que se AÑADEN a los del juego
        data/...
      _merge/            <- archivos que REEMPLAZAN a los del juego
        data/...
      images/
      music/
      sounds/

ACTIVAR UN MOD:
  Añade el nombre de la carpeta en modList.txt y reinicia el juego.

VER EJEMPLO COMPLETO:
  Mira la carpeta exampleFullMod/ — tiene manifest.json, semanas custom
  en JSON y mensajes de intro extra.

DOCUMENTACIÓN COMPLETA:
  Lee Modding.md en la raíz del repositorio.
