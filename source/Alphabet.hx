package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;

/**
 * Loosley based on FlxTypeText lolol
 */
class Alphabet extends FlxSpriteGroup
{
	public var delay:Float = 1;
	
	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;

	public var text:String = "";
	private var _text:String = "";

	private var _finalText:String = "";
	private var _curText:String = "";

	public var widthOfWords:Float = FlxG.width;

	var yMulti:Float = 1;

	private var lastSprite:AlphaCharacter;
	private var xPosResetted:Bool = false;
	private var lastWasSpace:Bool = false;

	private var splitWords:Array<String> = [];

	public var isBold:Bool = false;
	private var isTyped:Bool = false;

	public function new(x:Float, y:Float, text:String = "", ?bold:Bool = false, typed:Bool = false,targetY:Float = -1)
	{
		super(x, y);

		_finalText = text;
		if (targetY != -1)
			this.targetY = targetY;
		this.text = text;
		_text = text;
		isBold = bold;
	
		if (typed)
			startTypedText();
		else
			addText();
	}
	public function replaceText(text:String,isBold:Bool,typed:Bool)
	{
		kill();		// WHEN ERES NUB JIJIJIJA
		new Alphabet(0,0,text,isBold,typed,targetY);
		revive();
	}
	public function addText()
	{
		lastWasSpace = false;
		for (i in members)
			i.destroy();
		clear();
		if (lastSprite != null)
			lastSprite = null;
		_text = _finalText = text;

		doSplitWords();

		var xPos:Float = 0;
		for (character in splitWords)
		{
			if (character == " ")
				lastWasSpace = true;

			if (AlphaCharacter.all.indexOf(character.toLowerCase()) != -1 )
			{
				if (lastSprite != null)
					xPos = lastSprite.x + lastSprite.width;

				if (lastWasSpace)
					xPos += 40;
				lastWasSpace = false;


				var letter:AlphaCharacter = new AlphaCharacter(xPos, 0);

				if (isBold)
					letter.createBold(character);
				else
					letter.addNoBold(character);

				add(letter);

				lastSprite = letter;
			}

		}

	}

	function doSplitWords():Void
	{
		splitWords = _finalText.split("");
	}

	public function startTypedText():Void
	{
		_finalText = text;
		doSplitWords();

		var loopNum:Int = 0;
		var xPos:Float = 0;
		var curRow:Int = 0;

		new FlxTimer().start(delay * 0.05, function(tmr:FlxTimer)
		{
			if (_finalText.fastCodeAt(loopNum) == "\n".code)
			{
				yMulti += 1;
				xPosResetted = true;
				xPos = 0;
				curRow += 1;
			}

			if (splitWords[loopNum] == " ")
			{
				lastWasSpace = true;
			}

			if (AlphaCharacter.all.indexOf(splitWords[loopNum].toLowerCase()) != -1 )
			{
				if (lastSprite != null)
				lastSprite.updateHitbox();

				if (lastSprite != null && !xPosResetted)
					xPos += lastSprite.width + 3;
				else
					xPosResetted = false;

				if (lastWasSpace)
				{
					xPos += 20;
					lastWasSpace = false;
				}
				var letter:AlphaCharacter = new AlphaCharacter(xPos, 55 * yMulti);
				letter.row = curRow;
				if (isBold)
					letter.createBold(splitWords[loopNum]);
				else
				{
					letter.addNoBold(splitWords[loopNum]);
					letter.x += 90;
				}

	
				FlxG.sound.play(Paths.soundRandom("GF_", 1, 4));

				add(letter);

				lastSprite = letter;
			}

			loopNum += 1;

			tmr.time = FlxG.random.float(0.04, 0.09);
		}, splitWords.length);
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.16);
			x = FlxMath.lerp(x, (targetY * 20) + 90, 0.16);
		}

		super.update(elapsed);
	}
}

class AlphaCharacter extends FlxSprite
{
	public static var alphabet:String = "abcdefghijklmnñopqrstuvwxyz";
	public static var numbers:String = "1234567890";
	public static var symbols:String = "|~#$%()*+-:;<=>@[]^_.,'!?";
	public static var all:String = alphabet + numbers + symbols;

	public var row:Int = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		var tex = Paths.getSparrowAtlas('alphabet');
		frames = tex;

		antialiasing = PlayerSettings.antialiasing;
	}

	public function addNoBold(letter:String)
	{
		if (alphabet.indexOf(letter.toLowerCase()) != -1)
			createLetter(letter);
		else if (numbers.indexOf(letter.toLowerCase()) != -1)
			createLetter(letter);
	}
	public function createBold(letter:String)
	{
		if (letter.toLowerCase() == "ñ")
			letter = "oem";
		animation.addByPrefix(letter, letter.toUpperCase() + " bold", 24);
		animation.play(letter);
		updateHitbox();
	}

	public function createLetter(letter:String):Void
	{
		if (letter.toLowerCase() == "ñ")
			letter = "oem";
		
		var letterCase:String = "lowercase";
		if (letter.toLowerCase() != letter)
			letterCase = 'capital';

		animation.addByPrefix(letter, letter + " " + letterCase, 24);
		animation.play(letter);
		updateHitbox();

		y = (110 - height);
		y += row * 60;
	}

	public function createNumber(letter:String):Void
	{
		animation.addByPrefix(letter, letter, 24);
		animation.play(letter);

		updateHitbox();
	}

	public function createSymbol(letter:String)
	{
		switch (letter)
		{
			case '.':
				animation.addByPrefix(letter, 'period', 24);
				animation.play(letter);
				y += 50;
			case "'":
				animation.addByPrefix(letter, 'apostraphie', 24);
				animation.play(letter);
			case "?":
				animation.addByPrefix(letter, 'question mark', 24);
				animation.play(letter);
			case "!":
				animation.addByPrefix(letter, 'exclamation point', 24);
				animation.play(letter);
		}

		updateHitbox();
		
	}
}
