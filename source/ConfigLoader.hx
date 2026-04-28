package;

import haxe.Json;
import lime.utils.Assets;

using StringTools;

/**
 * MDC Engine - Config Loader
 * ---------------------------
 * Carga listas de configuración con prioridad:
 *   1. `data/<key>.json`  (formato moderno con metadatos)
 *   2. `data/<key>.txt`   (formato legacy: una línea por valor)
 *
 * Esto permite mantener compatibilidad con los txt actuales mientras los
 * mods nuevos pueden usar JSON con campos adicionales (icono, color, etc).
 *
 * Ejemplo JSON soportado:
 *   {
 *     "weeks": [
 *       { "name": "Tutorial", "songs": ["Tutorial"], "unlocked": true },
 *       { "name": "Daddy Dearest", "songs": ["Bopeebo","Fresh","Dadbattle"] }
 *     ]
 *   }
 * o simplemente:
 *   { "values": ["uno", "dos", "tres"] }
 * o un array crudo:
 *   ["uno", "dos", "tres"]
 *
 * @author MDC <me@mdcdev.me>
 */
class ConfigLoader
{
	/**
	 * Carga una lista de strings desde `data/<key>.json` o `data/<key>.txt`.
	 */
	public static function loadList(key:String):Array<String>
	{
		var jsonPath = Paths.json(key);
		if (Assets.exists(jsonPath))
		{
			try
			{
				var raw:String = Assets.getText(jsonPath);
				var parsed:Dynamic = Json.parse(raw);
				if (Std.isOfType(parsed, Array))
					return cast parsed;
				if (parsed != null && Reflect.hasField(parsed, "values"))
					return cast Reflect.field(parsed, "values");
			}
			catch (e:Dynamic)
			{
				trace('[ConfigLoader] Bad JSON in $jsonPath: $e — falling back to txt');
			}
		}
		var txtPath = Paths.txt(key);
		if (Assets.exists(txtPath))
			return CoolUtil.coolTextFile(txtPath);
		return [];
	}

	/**
	 * Carga un objeto JSON arbitrario. Devuelve `null` si no existe o falla.
	 */
	public static function loadJson(key:String):Dynamic
	{
		var jsonPath = Paths.json(key);
		if (!Assets.exists(jsonPath))
			return null;
		try
		{
			return Json.parse(Assets.getText(jsonPath));
		}
		catch (e:Dynamic)
		{
			trace('[ConfigLoader] Bad JSON in $jsonPath: $e');
			return null;
		}
	}

	/**
	 * Lee texto plano (json o txt) y devuelve string crudo, o null.
	 */
	public static function loadText(key:String):String
	{
		var txtPath = Paths.txt(key);
		if (Assets.exists(txtPath))
		{
			try
				return Assets.getText(txtPath)
			catch (e:Dynamic) {}
		}
		return null;
	}
}
