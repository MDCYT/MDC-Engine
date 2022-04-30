package;

import openfl.media.Sound;
import openfl.display.BitmapData;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import openfl.media.Sound;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.text.Font;
import openfl.display.BitmapData;
import flixel.system.FlxAssets;
import flixel.graphics.frames.FlxAtlasFrames;
#if desktop
import cpp.NativeFile;
import sys.io.File;
import sys.FileSystem as Assets;
#else
import lime.utils.Assets;
#end
import openfl.utils.Assets as OpenFlASs;
import haxe.Json;
import flixel.FlxG;

class NativePaths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	#if desktop
	inline public static function sound(from:String)
	{
		if (Assets.exists('assets/sounds/' + from + SOUND_EXT))
			return Sound.fromFile('assets/sounds/' + from + SOUND_EXT);
		else
			return null;
	}

	inline public static function music(from:String)
	{
		if (Assets.exists('assets/music/' + from + SOUND_EXT))
			return Sound.fromFile('assets/music/' + from + SOUND_EXT);
		else
			return null;
	}

	inline public static function image(from:String)
	{
		if (Assets.exists('assets/images/' + from + ".png")){
			return BitmapData.fromFile('assets/images/' + from + '.png');
		}
		else
			return null;
	}

	inline public static function txt(from:String)
	{
		var elxokas = "";
		if (Assets.exists('assets/' + from + ".txt"))
			elxokas = ".txt";
		else if (Assets.exists("assets/" + from + ".json"))
			elxokas = ".json";
		else if (Assets.exists("assets/" + from + ".xml"))
			elxokas = ".xml";

		if (Assets.exists('assets/' + from + elxokas))
			return NativeFile.file_contents_string('assets/' + from + elxokas);
		else
			return "null";
	}

	inline static public function song(song:String, s:String)
	{
		if (Assets.exists('assets/songs/' + song.toLowerCase() + "/" + s + SOUND_EXT))
			return Sound.fromFile('assets/songs/' + song.toLowerCase() + "/" + s + SOUND_EXT);
		else
			return null;
	}

	inline static public function font(key:String)
		return 'assets/fonts/$key';

	inline static public function soundRandom(key:String, min:Int, max:Int)
		return sound(key + FlxG.random.int(min, max));

	inline static public function getSparrowAtlas(key:String, ?library:String)
		return FlxAtlasFrames.fromSparrow(image(key), txt('images/$key'));

	inline static public function getPackerAtlas(key:String, ?library:String)
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), txt('images/$key'));
	#else
	inline public static function sound(from:String)
		return null;

	inline public static function music(from:String)
		return null;

	inline public static function image(from:String)
		return null;

	inline public static function txt(from:String)
		return null;

	inline static public function font(key:String)
		return null;

	inline static public function song(song:String, s:String)
		return null;

	inline static public function soundRandom(key:String, min:Int, max:Int)
		return null;

	inline static public function getSparrowAtlas(key:String, ?library:String)
		return null;

	inline static public function getPackerAtlas(key:String, ?library:String)
		return null;
	#end
}

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, type:AssetType, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;

			levelPath = getLibraryPathForce(file, "shared");
			if (OpenFlAssets.exists(levelPath, type))
				return levelPath;
		}

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, type:AssetType = TEXT, ?library:String)
	{
		return getPath(file, type, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', TEXT, library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', TEXT, library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', TEXT, library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', SOUND, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', MUSIC, library);
	}

	inline static public function voices(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', IMAGE, library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
}
