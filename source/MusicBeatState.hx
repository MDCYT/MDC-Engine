package;

import flixel.animation.FlxAnimationController;
import flixel.FlxCamera;
import flixel.math.FlxPoint;
import Conductor.BPMChangeEvent;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.util.FlxTimer;
import openfl.display.Application;
import openfl.Lib;
class MusicBeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;
	public var _localPitch:Float = 0;
	
	public static function switchState(nextState:MusicBeatState):Void
	{
		FlxG.switchState(nextState,true);
	}


	public function new()
	{
		super();
		FlxG.callBacks.set("onChangeSpeed",function (value:Float)
			{
				Conductor.safeZoneOffset = (PlayerSettings.safeFrames / 60) * 1000 * value;
			});
	
	}
	public override function onResize(w,h)
	{
		var width:Int = Math.floor(w);
		var height:Int = Math.floor(h);
		super.onResize(width,height);
		lime.app.Application.current.window.resize(width, height);
        FlxG.resizeGame(width,height);
		FlxG.resizeWindow(width, height);
		
	}
	override function create()
		super.create();


	override function update(elapsed:Float)
	{

		var oldStep:Int = curStep;
		updateCurStep();
		updateBeat();

		if (oldStep != curStep)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		var lastChange:BPMChangeEvent = {
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
		{
			if (Conductor.songPosition >= Conductor.bpmChangeMap[i].songTime)
				lastChange = Conductor.bpmChangeMap[i];
		}

		curStep = lastChange.stepTime + Math.floor((Conductor.songPosition - lastChange.songTime) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void {}
}
