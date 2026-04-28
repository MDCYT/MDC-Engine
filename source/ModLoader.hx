package;

import haxe.Json;
import lime.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
#if polymod
import polymod.Polymod;
#end

using StringTools;

/**
 * MDC Engine - Mod Loader
 * ------------------------
 * Carga TODOS los mods declarados en `mods/modList.txt`, no solo `introMod`.
 * Lee opcionalmente un `manifest.json` por mod con metadatos (autor, versión,
 * descripción, icono, dependencias) y los expone al juego.
 *
 * Compatible hacia atrás: si un mod no tiene manifest.json, sigue funcionando
 * con solo la carpeta `_append/` o `_merge/`.
 *
 * @author MDC <me@mdcdev.me>
 */
typedef ModManifest =
{
	var name:String;
	var ?author:String;
	var ?version:String;
	var ?description:String;
	var ?icon:String;
	var ?homepage:String;
	var ?dependencies:Array<String>;
	var ?api_version:String;
};

class ModLoader
{
	public static inline var MOD_ROOT:String = "mods";
	public static inline var MOD_LIST_FILE:String = "modList.txt";

	/** Lista de mods cargados (manifest + carpeta). */
	public static var loadedMods:Array<ModManifest> = [];

	/** Lista de IDs (nombre de carpeta) en orden de carga. */
	public static var loadedDirs:Array<String> = [];

	/** Errores ocurridos durante la carga, para mostrar en pantalla de debug. */
	public static var loadErrors:Array<String> = [];

	public static function init():Void
	{
		loadedMods = [];
		loadedDirs = [];
		loadErrors = [];

		var dirs:Array<String> = readModList();

		if (dirs.length == 0)
		{
			trace("[ModLoader] No mods declared in mods/modList.txt");
			#if polymod
			// Init Polymod with empty list para que assets sigan funcionando.
			try
			{
				Polymod.init({modRoot: MOD_ROOT, dirs: []});
			}
			catch (e:Dynamic)
			{
				trace('[ModLoader] Polymod init (empty) failed: $e');
			}
			#end
			return;
		}

		for (dir in dirs)
		{
			var manifest:ModManifest = readManifest(dir);
			if (manifest == null)
			{
				// Sin manifest -> usar el nombre de carpeta como nombre.
				manifest = {name: dir, version: "0.0.0", author: "Unknown"};
			}
			loadedMods.push(manifest);
			loadedDirs.push(dir);
			trace('[ModLoader] Loaded mod "${manifest.name}" v${manifest.version} by ${manifest.author}');
		}

		#if polymod
		try
		{
			var result = Polymod.init({modRoot: MOD_ROOT, dirs: loadedDirs});
			if (result == null)
				loadErrors.push("Polymod returned null on init");
		}
		catch (e:Dynamic)
		{
			loadErrors.push('Polymod init error: $e');
			trace('[ModLoader] Polymod init failed: $e');
		}
		#end
	}

	/** Lee `mods/modList.txt`. Líneas vacías y `#` se ignoran. */
	public static function readModList():Array<String>
	{
		var dirs:Array<String> = [];
		var raw:String = null;

		#if sys
		var path = '$MOD_ROOT/$MOD_LIST_FILE';
		if (FileSystem.exists(path))
		{
			try raw = File.getContent(path)
			catch (e:Dynamic) raw = null;
		}
		#end

		if (raw == null)
		{
			// Fallback al asset embebido (HTML5).
			var assetPath = 'assets/mods/$MOD_LIST_FILE';
			if (Assets.exists(assetPath))
			{
				try raw = Assets.getText(assetPath)
				catch (e:Dynamic) raw = null;
			}
		}

		if (raw == null)
			return dirs;

		for (line in raw.split('\n'))
		{
			var t = line.trim();
			if (t.length == 0 || t.startsWith('#'))
				continue;
			dirs.push(t);
		}
		return dirs;
	}

	/** Lee `mods/<dir>/manifest.json` si existe. */
	public static function readManifest(dir:String):ModManifest
	{
		var raw:String = null;

		#if sys
		var path = '$MOD_ROOT/$dir/manifest.json';
		if (FileSystem.exists(path))
		{
			try raw = File.getContent(path)
			catch (e:Dynamic) raw = null;
		}
		#end

		if (raw == null)
		{
			var assetPath = 'assets/mods/$dir/manifest.json';
			if (Assets.exists(assetPath))
			{
				try raw = Assets.getText(assetPath)
				catch (e:Dynamic) raw = null;
			}
		}

		if (raw == null)
			return null;

		try
		{
			var parsed:ModManifest = Json.parse(raw);
			if (parsed.name == null || parsed.name.length == 0)
				parsed.name = dir;
			if (parsed.version == null)
				parsed.version = "0.0.0";
			if (parsed.author == null)
				parsed.author = "Unknown";
			return parsed;
		}
		catch (e:Dynamic)
		{
			loadErrors.push('Bad manifest.json in mod "$dir": $e');
			return null;
		}
	}

	/** Devuelve un resumen textual para pantallas de info/debug. */
	public static function describeLoadedMods():String
	{
		if (loadedMods.length == 0)
			return "No mods loaded";
		var out = new StringBuf();
		for (m in loadedMods)
		{
			out.add('• ${m.name} v${m.version}');
			if (m.author != null && m.author.length > 0)
				out.add(' — by ${m.author}');
			out.add('\n');
		}
		return out.toString();
	}
}
