package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.text.FlxText;

class KeyBinds extends MusicBeatSubstate
{
	/*var keys:Array<String> = [FlxG.save.data.leftBind,
		FlxG.save.data.downBind,
		FlxG.save.data.upBind,
		FlxG.save.data.rightBind];*/

	var keyBinds:Array <String> = ['Up', 'Down', 'Left', 'Right'];

	var keyBindsMenuShit:FlxTypedGroup<Alphabet>;

	#if AMS_WTRMRKS
	//only selection shit
	var selection:Int = 0;
	#end

    var bg:FlxSprite;

	override function create()
	{
		#if desktop
		DiscordClient.changePresence("In the KeyBindsMenu", null);
		#end

		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		keyBindsMenuShit = new FlxTypedGroup<Alphabet>();
		add(keyBindsMenuShit);

		for (i in 0...keyBinds.length)
		{
        var keyBindsTxt:Alphabet = new Alphabet(0, 0, keyBinds[i], true, false);
		keyBindsTxt.screenCenter(X);
		keyBindsTxt.y += (100 * (i - (keyBinds.length / 2))) + 50;
		keyBindsTxt.y += 300;
		keyBindsTxt.forceX = keyBindsTxt.x;
		keyBindsMenuShit.add(keyBindsTxt);
		}
            changeItem();
	}
	override function update(elapsed:Float)
		{
         super.update(elapsed);

		 var up = controls.UP_P;
		 var down = controls.DOWN_P;
		 var enter = controls.ACCEPT;
		 var back = controls.BACK;

		if (up)
		{
			changeItem(-1);
		}
		if (down)
		{
			changeItem(1);
		}
		if (back)
		{
			FlxG.switchState(new OptionsSubState());
		}
		if (enter)
			{
				var selected:String = keyBinds[selection];
				FlxG.sound.play(Paths.sound('confirmMenu'));
				switch (selected)
				{
case 'Up':
	//FlxG.save.data.upBind = keys[2];
	case 'Down':
		//FlxG.save.data.downBind = keys[2];
		case 'Left':
			//FlxG.save.data.leftBind = keys[2];
			case 'Right':
				//FlxG.save.data.rightBind = keys[2];
				}
			}
		}
function changeItem(change:Int = 0) :Void
{
	selection += change;

	if (selection < 0)
		selection = keyBinds.length - 1;
	if (selection >= keyBinds.length)
		selection = 0;

	var esoTilin:Int = 0;

	for (key in keyBindsMenuShit.members)
		{
key.targetY = esoTilin - selection;
esoTilin++;

key.alpha = 0.6;

if (key.targetY == 0)
	{
key.alpha = 1;
	}
	}
}
}
