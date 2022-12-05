package;

import flixel.FlxG;
import lime.utils.Assets;

using StringTools;
#if sys
import sys.FileSystem;
import sys.io.File;
#end
class CoolUtil
{

	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];
	public static function existsVar(fromData:Dynamic,str:String)
		{
			return fromData == null ? false : Reflect.getProperty(fromData,str) != null;
		}
	public static function setVar(fromData:Dynamic,str:String,value:Dynamic)
		{
			// setProperty;
			if (!existsVar(fromData,str) || fromData == null || value == null || str == null)
				FlxG.log.warn("Setted a var from null!");
			// else (existsVar(fromData,str))
			Reflect.setProperty(fromData,str,value);
		}
	public static function jsonToString(json:Dynamic):String
	{
		return haxe.Json.stringify(json,null," ");
	}
	public static function checkChars():Void
		{
			#if sys
			return;
			var songs_to_set = FileSystem.readDirectory("assets/data/songs");
			for (song in songs_to_set)
			{
				trace("settin " + song);
				var charts = FileSystem.readDirectory("assets/data/songs/" + song);
				for (chart in charts)
					{
						if (chart.endsWith(".json"))
							{
								var rawJson = File.getContent("assets/data/songs/" + song + "/" + chart).trim();
								var swagSong:Song.SwagSong = haxe.Json.parse(rawJson);
								trace("exists player3" + existsVar(swagSong,"player3"));
								trace("exists isPixel" + existsVar(swagSong,"isPixel"));
								trace("exists formatVer" + existsVar(swagSong,"formatVer"));
								trace("exists stage" + existsVar(swagSong,"stage"));

								if (!existsVar(swagSong,"player3"))
									setVar(swagSong,"player3","gf");
								if (!existsVar(swagSong,"isPixel"))
									setVar(swagSong,"isPixel",false);
								if (!existsVar(swagSong,"formatVer"))
									setVar(swagSong,"formatVer","1");
								if (!existsVar(swagSong,"stage"))
									setVar(swagSong,"stage","stage");
								File.saveContent("assets/data/songs/" + song + "/" + chart,jsonToString(swagSong));
							}
					}
			}
			#end
		}
	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}
	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}
	public static function calculateRating(noteDiff:Float = 0)
	{
		var map:Map<String,Dynamic> = [];
		var score:Int = 350;
		var daRating:String = "sick";
		var color:Int = 0xFF46a5d3;


		var notDif = Math.abs(noteDiff);
		if (notDif > Conductor.safeZoneOffset * 0.9)
		{
			daRating = 'shit';
			score = 50;
			color = 0xFFCC0001;
		}
		else if (notDif > Conductor.safeZoneOffset * 0.75)	
		{
			daRating = 'bad';
			color = 0xFFfed22b;
			score = 100;
		}
		else if (notDif > Conductor.safeZoneOffset * 0.2)
		{	
			daRating = 'good';
			score = 200;
			color = 0xFF4cc844;
		} else
		{
			daRating = "sick";
			color = 0xFF46a5d3;
			if (notDif == 0)
			score = 400;
		}

		map.set("rating",daRating);
		map.set("color",color);
		map.set("score",score);
	return map;
		
	}
	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
}
