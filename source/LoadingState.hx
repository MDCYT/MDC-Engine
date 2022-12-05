package;

import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

class LoadingState extends MusicBeatState
{
	
	var target:FlxState;
	var stopMusic = false;
	
	var logo:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft = false;
	
	function new(target:FlxState, stopMusic:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}
	
	override function create()
	{
		super.create();
		logo = new FlxSprite(-150, -100);
		logo.frames = Paths.getSparrowAtlas('logoBumpin');
		logo.antialiasing = PlayerSettings.antialiasing;
		logo.animation.addByPrefix('bump', 'logo bumpin', 24);
		logo.animation.play('bump');
		logo.updateHitbox();

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = PlayerSettings.antialiasing;
		add(gfDance);
		add(logo);
		var song = PlayState.SONG;
		if (song.needsVoices)
			Paths.voices(song.song);
		Paths.inst(song.song);
		new FlxTimer().start(2,onLoad);
	}
	

	override function beatHit()
	{
		super.beatHit();
		
		logo.animation.play('bump');
		danceLeft = !danceLeft;
		
		if (danceLeft)
			gfDance.animation.play('danceRight');
		else
			gfDance.animation.play('danceLeft');
	}
	
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		Conductor.songPosition += FlxG.elapsed * 1000;
	}
	
	function onLoad(adssd)
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		FlxG.switchState(target);
	}

	
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		FlxG.switchState(getNextState(target, stopMusic));
	}
	
	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
	
		return new LoadingState(target, stopMusic);
	}
	

}

