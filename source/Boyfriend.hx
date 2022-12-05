package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

using StringTools;

class Boyfriend extends Character
{
	public var stunned:Bool = false;

	public function new(x:Float, y:Float, ?char:String = 'bf')
	{
		super(x, y, char, true);
	}
	public function getElpepe():String
		return (animation.curAnim == null ? ""  : animation.curAnim.name);
	public function getCurAnimFinished():Bool
		return (animation.curAnim == null ? false  : animation.curAnim.finished);
	override function update(elapsed:Float)
	{
		
		holdTimer += elapsed;
		if (getElpepe() == 'firstDeath' && getCurAnimFinished())
			playAnim('deathLoop');

		super.update(elapsed);
	}
}
