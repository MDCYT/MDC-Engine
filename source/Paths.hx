package;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import lime.utils.Assets;
import openfl.Assets as OpenFLAssets;
import flash.media.Sound;

#if sys
import sys.io.File;
import sys.FileSystem;
#end
import openfl.system.System;

import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import haxe.Json;

using StringTools;
class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;
	static var currentLevel:String;
	public static var curTrackedImages:Map<String, FlxGraphic> = [];
	public static var curTrackedSounds:Map<String, Sound> = [];
	public static var exclution:Array<String> =
	[
		'assets/music/freakyMenu.$SOUND_EXT',
	];
	// public sta
	public static function clearImages():Void
	{
		for (key in curTrackedImages.keys()){
			var obj = curTrackedImages.get(key);
				@:privateAccess if (obj != null && !exclution.contains(key)) {
					openfl.Assets.cache.removeBitmapData(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					curTrackedImages.remove(key);
				}
			}
		System.gc();
	}
	public static function clearSounds():Void
		{
			for (key in curTrackedSounds.keys()){
				var obj = curTrackedSounds.get(key);
					@:privateAccess if (obj != null && !exclution.contains(key)) {
						Assets.cache.clear(key);
						curTrackedSounds.remove(key);
					}
				}
		}
	public static inline function exists(key:String,?d:Dynamic):Bool
	{
		if (FileSystem.exists(getPath(key)))
			return true;
		return false;
	}
	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}
	public static var libraries:Array<String> = ["shared","songs"];

	static function getPath(file:String, ?library:Null<String> = "",?to:Bool = false)
	{
		if (libraries.contains(library) && !to)
			return getLibraryPath(file,library);
		if (library != "" && libraries.contains(library))
			library += "/";
		if (to)
			return 'assets/$library$file';
		return 'assets/$file';
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

	inline static public function file(file:String,?library:String)
	{
		return getPath(file, library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', library);
	}
	inline static public function data(key:String)
	{
		return getPath('data/$key', "preload");
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getSound('sounds/' + key, library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getSound('music/' + key, library);
	}

	inline static public function voices(song:String):Dynamic
		return getSound(song.toLowerCase() + '/Voices', "songs");


	inline static public function inst(song:String):Dynamic
		return getSound(song.toLowerCase() + '/Inst', "songs");

	inline static public function image(key:String, ?library:String)
	{
		var path:FlxGraphic = getImage(key,library);
		// if ((FileSystem.exists(path)))
			//  return  BitmapData.fromFile(path);
		return path; 
	}
	inline private static function keyS(key:String):Dynamic
	{
		if (FileSystem.exists("assets/songs/" + key + ".ogg"))
			return  Sound.fromFile("assets/songs/" + key + ".ogg");
		return "songs://assets/songs/" + key + ".ogg";
	}
	
	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}
	inline static public function getChar(key:String)
	{
		return FlxAtlasFrames.fromSparrow(image('chars/$key',"shared"), file('images/chars/$key.xml',"shared"));
	}
	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}
	public static function getImage(img:String,lib:String):FlxGraphic
	{
		if (Assets.exists(getPath('images/$img.png', lib), IMAGE)) {
			if(!curTrackedImages.exists(getPath('images/$img.png', lib))) {
				var newGraphic:FlxGraphic = FlxG.bitmap.add(getPath('images/$img.png', lib), false, getPath('images/$img.png', lib));
				newGraphic.persist = true;
				curTrackedImages.set(getPath('images/$img.png', lib), newGraphic);
			}
			return curTrackedImages.get(getPath('images/$img.png', lib));
		}
		return null;
	}
	public static function getSound(key:String, ?lib:String) {
		var path:String = getPath('$key.$SOUND_EXT',lib);
		if (lib != null && lib != 'songs')
			path = 'songs:assets/songs/${key}.$SOUND_EXT';
		if(!curTrackedSounds.exists(path))
			curTrackedSounds.set(path, OpenFLAssets.getSound(path));
		return curTrackedSounds.get(path);
	}
}
