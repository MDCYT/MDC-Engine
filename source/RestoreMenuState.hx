package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class RestoreMenuState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var warningShit:FlxText;
	var succesedShit:FlxText; 

	var menuItems:Array<String> = [
		'yes'
	];
	var curSelected:Int = 0;
	var song:String;
	var difficulty:Int;
	var week:Int;

	override function create()
	{

		#if desktop
		DiscordClient.changePresence("In the DataRestorerMenu", null);
		#end

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var reset:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('restart'));
		reset.scale.y = 0.5;
		reset.scale.x = 0.5;
		reset.screenCenter();
		reset.y -= 130;
		reset.alpha = 1;
		add(reset);

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

		warningShit = new FlxText(5, FlxG.height - 18, 0, "ARE YOU SURE TO DELETE YOUR DATA? THIS ACTION IS PERMANENT!", 80);
		warningShit.scrollFactor.set();
		warningShit.y -= 15;
		warningShit.setFormat("VCR OSD Mono", 45, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(warningShit);

		succesedShit = new FlxText(5, FlxG.height - 18, 0, "Data deleted successfully!", 80);
		succesedShit.scrollFactor.set();
		succesedShit.y -= 15;
		succesedShit.alpha = 0;
		succesedShit.setFormat("VCR OSD Mono", 45, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(succesedShit);
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
			FlxG.switchState(new OptionsSubState());
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
			FlxG.sound.play(Paths.sound('confirmMenu'));
			switch (daSelected)
			{
				case "yes":
					warningShit.alpha = 0;
					succesedShit.alpha = 1;
					Highscore.resetSong(song, difficulty);
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

			item.alpha = 1;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
