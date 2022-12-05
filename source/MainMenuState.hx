package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.math.FlxMath;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = [
		'story mode', 
		'freeplay', 
		'credits',
		#if !switch
		'donate', 
		'options',
		'github',
		#end
		#if debug
		'test',
		
		#end
	];
	public static var engineVer:String = "0.1.1b";
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var leftBG:FlxSprite; //= new PartOfBG(0,0,"leftBG",function (spr){spr.setGraphicSize(1280);}); 
	var stage:FlxSprite; //= new PartOfBG(0,0,"stage",function (spr){spr.setGraphicSize(1280);}); 
	var colorBG:Int;
	var bg:FlxSprite;
	override function create()
	{


		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;
		magenta = new FlxSprite(-80).makeGraphic(1,1);
		magenta.visible = false;
		bg = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y =optionShit.length * 0.0012;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = PlayerSettings.antialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		leftBG = new FlxSprite(-30).loadGraphic(Paths.image("leftBG","preload"));
		leftBG.scrollFactor.set();
		leftBG.setGraphicSize(500);
		leftBG.updateHitbox();
		leftBG.screenCenter(Y);
		leftBG.antialiasing = PlayerSettings.antialiasing;
		add(leftBG);
		// magenta.scrollFactor.set();
		stage = new FlxSprite( 888.5,  537 ).loadGraphic(Paths.image("stage","preload"));
		stage.scrollFactor.set();
		stage.updateHitbox();
		stage.antialiasing = PlayerSettings.antialiasing;
		colorBG = 0xffF9CF51;

		add(stage);
		createDynamicChar(FlxG.random.int(0,stupidList.length -1));

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		var expr = "
		trace('TEST');
		add(coolText);
		trace('another test');
		var coolText = new FlxText(0,0,0,'cry about it niz');
		coolText.size = 32;
		coolText.scrollFactor.set();
		coolText.screenCenter();
		trace(coolText);
		
		function create()
			{
				trace('onCreate call method');
			}
		function update()
			{
				if (FlxG.keys.justPressed.L)
					trace('hola mundo');
			}
		";
		
		script.setCurState(this);
		// script.setVar("coolText", new FlxText(0,0,0,"TESTING"));
	

		script.execute(expr);
		script.callBack("create",[]);
	
		for (i in 0...optionShit.length)
		{
			var y = 120 + (i * (160 * 0.35));
			var menuItem:FlxSprite = new FlxSprite(0, y);
			defY[i] = y;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/${optionShit[i]}',"preload");
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.scale.set(defScale,defScale);
			menuItem.updateHitbox();
			menuItem.screenCenter(X);
			menuItem.scrollFactor.set();
			menuItem.x -= 550;
			menuItems.add(menuItem);
			defX[i] = menuItem.x;
			menuItem.antialiasing = PlayerSettings.antialiasing;
		}

		Week.init();

		var versionShit:FlxText = new FlxText(5, FlxG.height - (18 + 18), 0, "MDC Engine v"+ engineVer + "(git ver: https error 404)"+ "\nFNF v" + gameVer + "\n", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
		FlxG.camera.follow(camFollow);

	}

	var selectedSomethin:Bool = false;
	var defX:Array<Float> = [];
	var defY:Array<Float> = [];
	var defScale:Float = 0.25;
	var char:FlxSprite;
	var stupidList:Array<String> = ["bf","bf-pixel"];
	var script = new funkinscript.Script();

	private function createDynamicChar(id:Int)
	{
		trace(stupidList[id]);
		switch(stupidList[id])
		{
			case "bf":
				char = new FlxSprite(920,360);
				char.frames = Paths.getChar("BOYFRIEND");
				char.animation.addByPrefix("idle","BF idle dance");
				char.animation.addByPrefix("hey", "BF HEY",24,false);
			case "bf-pixel":
				char = new FlxSprite(920,320);
				char.frames = Paths.getChar("bfPixel");
				char.scale.set(6,6);
				char.animation.addByPrefix("idle","BF IDLE instance 1");
		}
		char.scrollFactor.set();
		char.updateHitbox();
		add(char);
		char.animation.play("idle");
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		if (FlxG.keys.justPressed.SEVEN)
			FlxG.switchState(new DebugMenuState());
		if (magenta.visible)
			{
				colorBG = 0xFFfd719b; 
			} else
			{
				colorBG = 0xffF9CF51; 
			}
		leftBG.color = colorBG;
		stage.color = colorBG;
		bg.color = colorBG;
		script.callBack("update",[elapsed]);

		// if (FlxG.keys.justPressed.SIX)
		// 	FlxG.switchState(new CreditsState.CreditsState());
		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}
			menuItems.forEach(function(spr:FlxSprite)
				{
					
		
					spr.x = FlxMath.lerp(defX[spr.ID],spr.x, 1 - elapsed * 10);
					spr.y = FlxMath.lerp(defY[spr.ID],spr.y, 1 - elapsed * 10);
					spr.scale.x = FlxMath.lerp(defScale,spr.scale.x, 1 - elapsed * 10);
					spr.scale.y = FlxMath.lerp(defScale,spr.scale.y, 1 - elapsed * 10);
					if (spr.ID == curSelected)
					{
						spr.x = FlxMath.lerp(defX[spr.ID] + 250,spr.x, 1 - elapsed * 10);
						spr.scale.set(defScale + 0.2, defScale + 0.2);
						spr.y = FlxMath.lerp(defY[spr.ID],spr.y, 1 - elapsed * 10);

						camFollow.y =  FlxMath.lerp(spr.getGraphicMidpoint().y,camFollow.y, 0.5 - elapsed * 10);
					}
		
				});

			if (controls.ACCEPT)
			{
				if (char.animation.exists("hey"))
					char.animation.play("hey");

				
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu')).pitch = FlxG.random.float(0.76,0.96);
				// FlxG.sound.play("assets/sounds/confirmMenu.ogg").pitch = 0.86
				FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0.5}, 0.6, {
							ease: FlxEase.quadOut,
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.07, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice.toLowerCase())
							{
								default: resetItems();
								case "donate": resetItems("https://ninja-muffin24.itch.io/funkin");
								case "test": FlxG.switchState(new ChartingState());
								case "credits": FlxG.switchState(new CreditsState.CreditsState());
								case "github": resetItems("https://github.com/MDCYT/MDC-engine");
								case 'story mode': FlxG.switchState(new StoryMenuState());
								case 'freeplay': FlxG.switchState(new FreeplayState());
							}
						});
					}
				});
			}
		}

		super.update(elapsed);

	
	}
	function resetItems(urlToOpen:String  = ""):Void
		{
		if (urlToOpen != null && urlToOpen != "")
			FlxG.openURL(urlToOpen);
		selectedSomethin = false;
		char.animation.play("idle");

		for (item in menuItems)
			{
				FlxTween.tween(item, {alpha: 1}, 0.8, {ease: FlxEase.quadOut});
				item.visible = true;
			}
		}
	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
			}

			spr.updateHitbox();
		});
	}
}
