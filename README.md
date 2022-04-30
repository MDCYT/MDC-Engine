# Friday Night Funkin MDC Engine

[![Discord](https://img.shields.io/discord/778038568680554497?label=discord)](https://discord.gg/fpheq7JYt3) [![GitHub issues](https://img.shields.io/github/issues/MDCYT/FNF-MDC-Engine)](https://github.com/MDCYT/FNF-MDC-Engine/issues) [![GitHub pull requests](https://img.shields.io/github/issues-pr/MDCYT/FNF-MDC-Engine)](https://github.com/MDCYT/FNF-MDC-Engine/pulls) []() []()

![GitHub commits since latest release (by date)](https://img.shields.io/github/commits-since/MDCYT/FNF-MDC-Engine/latest) ![GitHub repo size](https://img.shields.io/github/repo-size/MDCYT/FNF-MDC-Engine) ![Lines of code](https://img.shields.io/tokei/lines/github/MDCYT/FNF-MDC-Engine) ![Supported platforms](https://img.shields.io/badge/supported%20platforms-windows%2C%20macOS%2C%20linux%2C%20html5-blue) ![GitHub all releases](https://img.shields.io/github/downloads/MDCYT/FNF-MDC-Engine/total) ![GitHub](https://img.shields.io/github/license/MDCYT/FNF-MDC-Engine) ![GitHub release (latest by date including pre-releases)](https://img.shields.io/github/v/release/MDCYT/FNF-MDC-Engine?include_prereleases&label=latest%20version) 

Este repositorio, es una moficacion del codigo fuente de [Friday Night Funkin](https://github.com/ninjamuffin99/Funkin)

## Creditos

- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programador de la base
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Artista de la base
- [Kawaisprite](https://twitter.com/kawaisprite) - Musico de la base
- [MDC (Yo)](https://twitter.com/fridayproblems) - Programador que modifico el codigo

## Descarga
Si simplemente quieres descargar la version exportada, puedes hacerlo dandole click a la parte de releases de GitHub

## Instrucciones de Compilacion

Esto es solo por si quieres compilar el juego.

### Instalando los programas necesarios

Primero que nada, deberas instalar algunas cosas necesarias para esto.
- [Instalar Haxe 4.1.5](https://haxe.org/download/version/4.1.5/) 

Otras weas para instalar se encuentran en el `Project.xml`, y estos serian los comandos de instalacion:
```
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib run lime setup flixel
haxelib run lime setup
haxelib install flixel-tools
haxelib run flixel-tools setup
haxelib update flixel
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
haxelib install actuate
```

Para instalar algunas librerias adicionnales, necesitaras seguir estos pasos:
1. Descargar [git-scm](https://git-scm.com/downloads). 
2. Seguir las instrucciones correctas de instalacion (Marcar la opcion de PATH)
3. Poner en el CMD `haxelib git polymod https://github.com/larsiusprime/polymod.git` para instalar Polymod.
4. Poner en el CMD `haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc` Para instalar Discord RPC.
5. Poner en el CMD `haxelib git extension-webm https://github.com/GrowtopiaFli/extension-webm` Para instalar Extension Webm.
6. Poner en el CMD `lime rebuild extension-webm [windows/mac/linux]`(Poner dependiedo de tu sistema operativo, ejemplo: `lime rebuild extension-webm windows`) para tener correctamete instalado Extension Webm.
7. Poner en el CMD `haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons` para instalar Flixel Addons.

Listo, tienes todo lo necesario para empezar a compilar el juego!

### Compilando el juego

Una vez hallas instalado, probarlo sera facilisimo, para probarlo en tu navegador y ver que todo funcione, puedes usar `lime test html5 -debug`

Para correrlo en tu computadora(Mac, Linux, Windows) puede ser un poco mas dificil. En Linux, solo abres una terminal, te vas a la ruta de tu proyecto y ejecutas `lime test linux -debug` o `lime build linux -final` y ejecutarlo en `export/release/linux/bin`. Para Windows, neecsitas instalar Visual Studio Community 2019. Una vez tengas instalado el VSC, no clickees ninguna de las opciones principales. Ve a componentes individuales y selecciona las siguientes opciones:
* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)
* C++ Profiling tools
* C++ CMake tools for windows
* C++ ATL for v142 build tools (x86 & x64)
* C++ MFC for v142 build tools (x86 & x64)
* C++/CLI support for v142 build tools (14.21)
* C++ Modules for v142 build tools (x64/x86)
* Clang Compiler for Windows
* Windows 10 SDK (10.0.17134.0)
* Windows 10 SDK (10.0.16299.0)
* MSVC v141 - VS 2017 C++ x64/x86 build tools
* MSVC v140 - VS 2015 C++ build tools (v14.00)

Esto te instala 22GB de muchas cosas basura, Pero, una vez hallas acabado, abres una terminal y te diriges al directorio de tu proyecto y ejecutas `lime test windows -debug`. Y, una vez halla fializado el comando (Esto demora entre 1 y 2 horas la primera vez, luego tarda menos tiempo, entre 5 y 10 minutos), podras ejecutar FNF, para poder tener el ejecutable, ejecutamos el comando de `lime build windows -final` y nos dirigimos a `export/release/windows/bin` donde encontrarias el ejecutable.
En una Mac, deberia funcionar el comando de `lime test mac -debug`, pero si no funciona, puedes buscar una guia en internet, no se, nunca he usado una Mac.

##################################################################################
 ___    ___   ____     ____
|   \  /   | |  _ \   /  __|
|    \/    | | | | | |  /
| |\    /| | | |_| | |  \__
|_| \__/ |_| |____/   \____|
 _____   _   _    ____    _   _   _   _____
|  ___| | \ | |  /  __|  | | | \ | | |  ___|
|  __|  |  \| | |  |  _  | | |  \| | |  __|
| |___  | |\  | |  |_| | | | | |\  | | |___
|_____| |_| \_|  \_____| |_| |_| \_| |_____|
##################################################################################
