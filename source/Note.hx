package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	
	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var originColor:Int = 0; // The sustain note's original note's color
	public var noteSection:Int = 0;
	public var noteCharterObject:FlxSprite;

	public var noteScore:Float = 1;

	public var noteYOff:Int = 0;

	public static var swagWidth:Float = 160 * 0.7;
	public static var isPixel:Bool = false;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	public var colors:Array<String> = ['purple', 'blue', 'green', 'red'];
	public var noteFor:Int = 0;
	

	public var childrens:Array<Note> = [];
	public var forceCanBeHit:String = "dynamic";

	public var patern:Note;
	public var ratingToForce:String = "sick";
	// 		""IA""
	public var isIA:Bool = false;
	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false,?noteFor:Int = 0)
	{
		super(-2000,-2000);
		if (prevNote == null)
			prevNote = this;
		this.noteFor = noteFor;
		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		this.strumTime = strumTime;
		this.noteData = noteData;

		reload();

		animation.play('scroll');

		if (PlayerSettings.downscroll && sustainNote) 
			flipY = true;
		
		if (isSustainNote && prevNote != null)
		{
			alpha = 0.5;
			animation.play('end');
			var is_end:Bool = false;
			updateHitbox();
		
			if (prevNote.isSustainNote)
			{
				is_end = true;
				prevNote.animation.play('hold');
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.075;
				
				if(PlayState.SONG != null) 
					prevNote.scale.y *= PlayState.SONG.speed;
	
				if(Note.isPixel) {
					prevNote.scale.y *= (6 / height);
					prevNote.scale.y *= PlayState.daPixelZoom;
	
				}
		
				
				prevNote.updateHitbox();
				
			}
			
			

		}
		updateHitbox();
	}
	public var pressNote:Bool = false;
	public var wasSwagNote:Bool = false;
	public var isPix:Bool = false;

	private var anims:Array<Array<Int>> = [[4,5,6,7],[4,5,6,7],[0,1,2,3]];

	public function reload():Void
	{

		if (!isPixel)
		{
		frames = Paths.getSparrowAtlas('UI/NOTE_assets',"shared");

		animation.addByPrefix('scroll', '${colors[noteData]}0');
		animation.addByPrefix('end', '${colors[noteData]} hold end');
		animation.addByPrefix('hold', '${colors[noteData]} hold piece');

		setGraphicSize(Std.int(width * 0.7));
		if (noteData < 0)
			{
				frames = Paths.getSparrowAtlas('UI/NOTE_event',"shared");
				animation.addByPrefix('scroll', 'event');
				scale.set(0.25,0.25);
			}
		} else
		{
			isPix = true;
			loadGraphic(Paths.image('pixelUI/arrows-pixels',"shared"), true, 17, 17);
			if (isSustainNote)
				loadGraphic(Paths.image('pixelUI/arrowEnds',"shared"), true, 7, 6);
			animation.add('scroll', [anims[0][noteData]]);
			animation.add('end', [anims[1][noteData]]);
			animation.add('hold',[anims[2][noteData]]);

			setGraphicSize(Std.int(width * PlayState.daPixelZoom));
		}
	updateHitbox();

	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		pressNote = false;
		if (strumTime <= Conductor.songPosition + 10)
			pressNote = true;
		if (!pressNote)
		wasSwagNote = false;

	
			if (isSustainNote)
			{
				if (strumTime > Conductor.songPosition - (Conductor.safeZoneOffset)
					&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.2))
					canBeHit = true;
				else
					canBeHit = false;
			}
			else
			{
				if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
					&& strumTime < Conductor.songPosition + Conductor.safeZoneOffset)
					canBeHit = true;
				else
					canBeHit = false;
			}

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		
		if (tooLate)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}