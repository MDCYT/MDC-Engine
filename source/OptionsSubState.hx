package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsSubState extends MusicBeatSubstate
{

	public static var startSong = true;
	
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [
		'preferences', 
		'hud', 
		'keybinds',
		'Data Restorer'
	];
	var curSelected:Int = 0;


	override function create()
	{

		#if desktop
		DiscordClient.changePresence("In the Options", null);
		#end

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, 0, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.screenCenter(X);
			songText.forceX = songText.x;
			grpMenuShit.add(songText);
		}

		changeSelection();
	}

	override function update(elapsed:Float)
	{

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;
		var back = controls.BACK;

		if (back)
		{
			FlxG.switchState(new MainMenuState());
		}
		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];
			MainMenuState.selectedSomethin = false;

			switch (daSelected)
			{
				case "preferences":
					FlxG.switchState(new MainMenuState());    
				case "hud":
					FlxG.switchState(new MainMenuState());	
				case "keybinds":
					FlxG.switchState(new KeyBinds());		
				case "Data Restorer":
					FlxG.switchState(new RestoreMenuState());				
			}
		}
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
