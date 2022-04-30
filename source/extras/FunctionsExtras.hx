package ;

import Song.SwagSong;
import flixel.FlxG;
import flixel.system.FlxSound;
  
class FunctionsExtras
{
    var canPause:Bool = true;
var songScore:Int = 0;

//here for public variables
public static var SONG:SwagSong;

//here for private variables
private var vocals:FlxSound;

#if desktop
  //discordzzzz variables
var storyDifficultyText:String = "";
#end

  function skipSong(){
 canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}
}
    }
