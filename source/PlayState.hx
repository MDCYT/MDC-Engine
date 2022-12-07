package;

import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import Strum.Strums;
using StringTools;

class PlayState extends MusicBeatState
{
	
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	private var rPlayData:Dynamic;
	private var vocals:FlxSound = new FlxSound();
	private var music:FlxSound = new FlxSound();
	
	private var dad:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var accuracy:Float = 0;
	private var notesPressed:Map<String,Float> = new Map();

	private var dadGrp:FlxTypedGroup<Character> = new FlxTypedGroup<Character>();
	private var gfGrp:FlxTypedGroup<Character> = new FlxTypedGroup<Character>();
	private var bfGrp:FlxTypedGroup<Boyfriend> = new FlxTypedGroup<Boyfriend>();
	
	private var notes:NotesGroup;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject = new FlxObject(0, 0, 1, 1);

	private static var prevCamFollow:FlxObject;

	private var strumLineNotes:FlxTypedGroup<Strums>;
	private var playerStrums:Strums;
	private var opponentStrums:Strums;
	private var gfStrums:Strums;

	private var camZooming:Bool = true;
	private var curSong:String = "";
	private var canPlay:Bool = false;
	

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	private var hasGF:Bool = false;

	private var timeBG:FlxSprite;
	private var timeBar:FlxBar;
	private var timeTxt:FlxText;
	private var healthBar:HealthBar;

	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;

	private var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	private var animArray:Array<String> = ["LEFT","DOWN","UP","RIGHT"];

	private var halloweenBG:FlxSprite;
	private var isHalloween:Bool = false;

	private var phillyCityLights:FlxTypedGroup<FlxSprite>;
	private var phillyTrain:FlxSprite;
	private var trainSound:FlxSound;

	private var limo:FlxSprite;
	private var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	private var fastCar:FlxSprite;

	private var upperBoppers:FlxSprite;
	private var bottomBoppers:FlxSprite;
	private var santa:FlxSprite;

	private var bgGirls:BackgroundGirls;
	private var wiggleShit:WiggleEffect = new WiggleEffect();

	private var songScore:Int = 0;
	private var scoreTxt:FlxText;
	private var scoreBG:FlxSprite;
	private var waterMark:FlxText;

	public static var campaignScore:Int = 0;

	private var defaultCamZoom:Float = 1.05;
	private var defaultCamZoomHUD:Float = 0.965;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	private var songPos:Float = 0;

	private var inCutscene:Bool = false;

	#if desktop
	// Discord RPC variables
	private var storyDifficultyText:String = "";
	private var iconRPC:String = "";
	private var songLength:Float = 0;
	private var detailsText:String = "";
	private var detailsPausedText:String = "";
	#end

	private var paused:Bool = false;
	private var startedCountdown:Bool = false;
	private var canPause:Bool = true;
	private var charPos:FlxPoint = new FlxPoint(0,0);
	private var scrollSpeed:Float = 1.0;

	private var events:Array<Dynamic> = [];
	private var eventID:Int = 0;

	private var bgs:Array<FlxSprite> = [];
	private var loadedBg:Array<FlxGraphic> = [];
	private var startTimer:FlxTimer;
	private var allNotes:Array<Note> = [];
	private var player:Int = 0;
	
	private var generatedStaticArrows:Bool = false;
	public var ratingTypes = [
		"Horrible", // 0
		"Horrible", // 10
		"Awful", // 20

		"Shit", // 30
		"Bad", // 40
		"Meh", // 50

		"Good!", // 60
		"God!", // 70
		"Great!", // 80

		"Maniatic!", // 90
		"Sick!", // 100
		"Yo y los hackers cuando", // 110
	];
	private var noteOffset:Float = 250;

	private var rating:SwagComboOrRatingSpr = new SwagComboOrRatingSpr();
	private var comboSpr:SwagComboOrRatingSpr = new SwagComboOrRatingSpr();
	private var comboGrp:FlxTypedGroup<SwagNum> = new FlxTypedGroup<SwagNum>();
	private var msGrp:FlxTypedGroup<SwagNum> = new FlxTypedGroup<SwagNum>();
	private var scoreGRP:FlxGroup = new FlxGroup();
	private var strumP1:Strums = null;
	private var strumP2:Strums = null;

	private var replayData:Replay = [];
	public var isReplay:Bool = false;
	public static var setReplay:Bool = false;
	private var fastCarCanDrive:Bool = true;
	private var trainMoving:Bool = false;
	private var trainFrameTiming:Float = 0;

	private var trainCars:Int = 8;
	private var pausedAtTime:Float = 0; // For dumb errors.
	private var trainFinishing:Bool = false;
	private var trainCooldown:Int = 0;
	private var startedMoving:Bool = false;

	private var lightningStrikeBeat:Int = 0;
	private var lightningOffset:Int = 8;

	private var curLight:Int = 0;
	public function new(?replayData:Replay):Void
	{
		super();
		if (replayData != null)
			this.replayData = replayData;
		else
			this.replayData = [];
		
		rPlayData = this.replayData.copy();
	}

	override public function create()
	{
		
		Conductor.songPosition = -Math.PI * 360;
		if (setReplay) isReplay = true;
		setReplay = false;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		FlxG.sound.list.add(vocals);	
		FlxG.sound.list.add(music);	
		persistentUpdate = persistentDraw  = true;

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		if (prevCamFollow != null)
			camFollow = prevCamFollow;
		prevCamFollow = null;

		#if desktop
		storyDifficultyText = CoolUtil.difficultyString();
		iconRPC = SONG.player2;
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
		}
		if (isStoryMode)
			detailsText = "Story Mode: Week " + storyWeek;
		else
			detailsText = "Freeplay";

		detailsPausedText = "Paused - " + detailsText;
		
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end


		var gfVersion:String = SONG.player3;
		if (SONG.player1.endsWith("pixel")){
			gfVersion = "gf-pixel";
			SONG.isPixel = true;
			
		}
		Note.isPixel = SONG.isPixel;
	

		gf = new Character(100, 100,  gfVersion);
		gf.scrollFactor.set(0.95, 0.95);
		dad = new Character(100, 100,  SONG.player2);
		boyfriend = new Boyfriend(100, 100,  SONG.player1);
		
		gfGrp.add(gf);
		bfGrp.add(boyfriend);
		dadGrp.add(dad);

		notes = new NotesGroup();

		strumLine = new FlxSprite(0, PlayerSettings.downscroll ? FlxG.height * 0.80 : FlxG.height * 0.15).makeGraphic(1, 1);
		strumLine.setGraphicSize(300,10);
		strumLine.updateHitbox();
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<Strums>();
		add(strumLineNotes);

		genOrDestroyStage();
		setPosChar();

		FlxG.camera.zoom = defaultCamZoom;
		FlxG.fixedTimestep = false;
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		healthBar = new HealthBar(this);
		healthBar.y = (PlayerSettings.downscroll ? FlxG.height * 0.1 : FlxG.height * 0.9);
		add(healthBar);
	
		scoreBG = new FlxSprite(0, healthBar.healthBarBG.y + 30).makeGraphic(1,1,FlxColor.BLACK);
		scoreBG.screenCenter(X);
		scoreBG.scrollFactor.set();
		scoreBG.cameras = [camHUD];
		scoreBG.alpha = 0.5;
		add(scoreBG);

		scoreTxt = new FlxText(0, scoreBG.y + scoreBG.height / 2, 0, "", 20);
		scoreTxt.screenCenter(X);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, CENTER);
		scoreTxt.setBorderStyle(OUTLINE,FlxColor.BLACK,2,4);
		scoreTxt.scrollFactor.set();
		add(scoreTxt);

		waterMark = new FlxText(0, (!PlayerSettings.downscroll ? FlxG.height * 0.025 : FlxG.height * 0.925) , 0, "", 20);
		waterMark.screenCenter(X);
		waterMark.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, CENTER);
		waterMark.setBorderStyle(OUTLINE,FlxColor.BLACK,2,4);
		waterMark.scrollFactor.set();
		add(waterMark);

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);
		
		notes.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		waterMark.cameras = [anotherCam];

		startingSong = true;
		playerStrums = new Strums(strumLine.y,0);

		opponentStrums = new Strums(strumLine.y,1);
		add(notes);
		gfStrums = new Strums(strumLine.y,2);
		strumLineNotes.add(playerStrums);
		strumLineNotes.add(opponentStrums);
		strumLineNotes.add(gfStrums);
		
		super.create();
		tryStart();


		generateStaticArrows();

		for (i in 0...4)
		{
			playerStrums.splash(i);
			opponentStrums.splash(i);
			gfStrums.splash(i);
		}

	}
	private function tryStart():Void
	{
		music.time = 0;
		music.loadEmbedded(Paths.inst(PlayState.SONG.song), false);

		generateSong();
		for (shit in ["played","notes","miss","sick","shit","good","bad"])
		notesPressed.set(shit,0);

		setDialogue();
	
		var doof:DialogueWeek6Box = new DialogueWeek6Box(dialogue);
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.cameras = [camHUD];
		var dial:DialogueBox = new DialogueBox(SONG.song);
		dial.scrollFactor.set();
		dial.onComplete = startCountdown;
		dial.cameras = [camHUD];
		Conductor.songPosition = -5000;
	
		if (isStoryMode)
			{
				switch (curSong.toLowerCase())
				{
					case "winter-horrorland":
						var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
						add(blackScreen);
						blackScreen.scrollFactor.set();
						camHUD.visible = false;
	
						new FlxTimer().start(0.1, function(tmr:FlxTimer)
						{
							remove(blackScreen);
							FlxG.sound.play(Paths.sound('Lights_Turn_On'));
							camFollow.y = -2050;
							camFollow.x += 200;
							FlxG.camera.focusOn(camFollow.getPosition());
							FlxG.camera.zoom = 1.5;
	
							new FlxTimer().start(0.8, function(tmr:FlxTimer)
							{
								camHUD.visible = true;
								remove(blackScreen);
								FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
									ease: FlxEase.quadInOut,
									onComplete: function(twn:FlxTween)
									{
										startCountdown();
									}
								});
							});
						});
					case 'senpai':
						
						schoolIntro(doof);
					case 'roses':
						FlxG.sound.play(Paths.sound('ANGRY'));
						schoolIntro(doof);
					case 'thorns':
						schoolIntro(doof);
					default:
						if (dial.hasDialogue){
							add(dial);
							inCutscene = true;
						} else{
							startCountdown();
						}
				}
			}
			else
			{
				switch (curSong.toLowerCase())
				{
					default:
						startCountdown();
				}
			}
		notes.repos();
	}

	private function bindEvent(strumTime:Float,event:String,argA:String,argB:String)
	{
		if (events[eventID] == null)
			events[eventID] = [strumTime,event,argA,argB];
		eventID ++;
	}
	
	private function onEvent(event:Array<Dynamic>)
	{
		if (event == null) return;
		events.remove(event);
		var eventName:String = event[0];
		var argA:String = event[1];
		var argB:String = event[2];
		switch(eventName.toLowerCase())
		{
			case "setcamangle":
				var camera:FlxCamera = FlxG.camera; 
			if (argB.toLowerCase().contains("hud") || argB == "0") camera = camHUD;
			FlxTween.tween(camera,{angle: Std.parseInt(argA.split(',')[0])},Std.parseInt(argA.split(',')[1]));


			case "setcamalpha": //
			var camera:FlxCamera = FlxG.camera; 
			if (argB.toLowerCase().contains("hud") || argB == "0") camera = camHUD;

			FlxTween.tween(camera,{alpha: Std.parseInt(argA.split(',')[0])},Std.parseInt(argA.split(',')[1]));
			case "nothing","": //nothing uwu.
			case "addzoom": 
				var rArg:Int = Std.parseInt(argA);
				var rArgB:Int = Std.parseInt(argB);
				if (argA != "" && argA != null)
					FlxG.camera.zoom += rArg;
				if (argB != "" && argB != null)
					camHUD.zoom += rArgB;
			
			case "setdefaultcamzoom":
				if (argA != "")
					defaultCamZoom = Std.parseFloat(argA);
				if (argB != "")
					defaultCamZoomHUD = Std.parseFloat(argA);

			case "playanim":
				var anim = argA;
				var player = dad;
				switch(argB)
				{
					case "0","bf","boyfriend": player = boyfriend;
					case "2","gf","girlfriend": player = gf;
				}
				player.holdTimer = 0;
				player.playAnim(anim,true);
			case "flashcam":
				var colorTo:FlxColor = 0;
				var rArg:Array<String> = argA.split(',');
				colorTo = FlxColor.fromRGB(Std.parseInt(rArg[0]),Std.parseInt(rArg[1]),Std.parseInt(rArg[2]));
				var camera = FlxG.camera;
				switch(argB.toLowerCase()){
					case "camhud","hudcam","1":  camera = camHUD;
				}
				camera.flash(colorTo);

		}

	}
	private function setPosChar():Void
	{
		if (boyfriend.curCharacter != SONG.player1)
		{
			boyfriend.kill();
			boyfriend = new Boyfriend(0,0, SONG.player1);
			bfGrp.add(boyfriend);

		}
		if (dad.curCharacter != SONG.player2)
		{
			dad.kill();
			dad = new Character(0,0, SONG.player2);
			dadGrp.add(dad);
		}
		boyfriend.setPosition(100,100);
		dad.setPosition(100,100);
		gf.setPosition(100,100);
		
		boyfriend.x += 670;
		boyfriend.y += 350;
		gf.y += 30;
		gf.x += 250;
		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}

			case "spooky":
				dad.y += 200;
			case "monster":
				dad.y += 100;
			case 'monster-christmas':
				dad.y += 130;
			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
				dad.y += 300;
			case 'parents-christmas':
				dad.x -= 500;
			case 'senpai':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				dad.x += 150;
				dad.y += 360;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				dad.x -= 150;
				dad.y += 100;
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
				add(evilTrail);

				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
		}
		camFollow.setPosition(camPos.x, camPos.y);

		
	}

	
	private function genOrDestroyStage():Void
	{
		remove(gfGrp);

		remove(dadGrp);
		remove(bfGrp);
		switch(SONG.song.toLowerCase())
		{
			case 'spookeez' | 'monster' | 'south':  curStage = "spooky";
			case  'pico' | 'blammed' | 'philly': curStage = "philly";
			case 'milf' | 'satin-panties' | 'high': curStage = "limo";
			case 'cocoa' | 'eggnog': curStage = "mall";
			case "winter-horrorland": curStage = 'mallEvil';
			case 'senpai' | 'roses': curStage = "school";			
			case "thorns": curStage = "schoolEvil";
			default:	curStage = "stage";
		}

	
		for (bg in bgs) {

			bgs.remove(bg);
			bg.destroy();
		}
		
		switch (curStage.toLowerCase())
		{
			case "spooky": 
				curStage = 'spooky';

				var hallowTex = Paths.getSparrowAtlas('halloween_bg',"shared");

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				// var hallow = FlxGraphic.fromBitmapData(Bitm)
				// loadedBg.push(hallow);
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = PlayerSettings.antialiasing;
				bgs.push(halloweenBG);
				add(halloweenBG);

				isHalloween = true;
			case "philly": 
				curStage = 'philly';

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('philly/sky',"shared"));
				bg.scrollFactor.set(0.1, 0.1);
				bgs.push(bg);
				add(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('philly/city',"shared"));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);
				bgs.push(city);
				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{

						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('philly/win' + i,"shared"));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = PlayerSettings.antialiasing;
						bgs.push(light);
						
						phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('philly/behindTrain',"shared"));
				add(streetBehind);
				bgs.push(streetBehind);


					phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('philly/train',"shared"));
				add(phillyTrain);
				bgs.push(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('philly/street',"shared"));
				add(street);
				bgs.push(street);
				
			case "limo":
				curStage = 'limo';
				defaultCamZoom = 0.90;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('limo/limoSunset',"shared"));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);
				bgs.push(skyBG);


				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo',"shared");
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);
				bgs.push(skyBG);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
						var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
						dancer.scrollFactor.set(0.4, 0.4);
						grpLimoDancers.add(dancer);
				bgs.push(dancer);
						
				}

				var limoTex = Paths.getSparrowAtlas('limo/limoDrive',"shared");

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = PlayerSettings.antialiasing;
				bgs.push(limo);

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('limo/fastCarLol',"shared"));
			case "mall":
				defaultCamZoom = 0.80;

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('christmas/bgWalls',"shared"));
				bg.antialiasing = PlayerSettings.antialiasing;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);
				bgs.push(bg);


				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop',"shared");
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = PlayerSettings.antialiasing;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);
				bgs.push(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('christmas/bgEscalator',"shared"));
				bgEscalator.antialiasing = PlayerSettings.antialiasing;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);
				bgs.push(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('christmas/christmasTree',"shared"));
				tree.antialiasing = PlayerSettings.antialiasing;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);
				bgs.push(tree);

				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop',"shared");
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = PlayerSettings.antialiasing;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);
				bgs.push(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('christmas/fgSnow',"shared"));
				fgSnow.active = false;
				fgSnow.antialiasing = PlayerSettings.antialiasing;
				add(fgSnow);
				bgs.push(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('christmas/santa',"shared");
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = PlayerSettings.antialiasing;
				bgs.push(santa);
				add(santa);
			case "mallevil":
				curStage = 'mallEvil';
				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('christmas/evilBG,"shared"'));
				bg.antialiasing = PlayerSettings.antialiasing;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);
				bgs.push(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('christmas/evilTree',"shared"));
				evilTree.antialiasing = PlayerSettings.antialiasing;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);
				bgs.push(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("christmas/evilSnow","shared"));
					evilSnow.antialiasing = PlayerSettings.antialiasing;
				add(evilSnow);
				bgs.push(evilSnow);

			case "school":
				curStage = 'school';

				var bgSky = new FlxSprite().loadGraphic(Paths.image('weeb/weebSky',"shared"));
				bgSky.scrollFactor.set(0.1, 0.1);
				add(bgSky);

				bgs.push(bgSky);
				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('weeb/weebSchool',"shared"));
				bgSchool.scrollFactor.set(0.6, 0.90);
				add(bgSchool);
				bgs.push(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('weeb/weebStreet',"shared"));
				bgStreet.scrollFactor.set(0.95, 0.95);
				add(bgStreet);
				bgs.push(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('weeb/weebTreesBack',"shared"));
				fgTrees.scrollFactor.set(0.9, 0.9);
				add(fgTrees);
				bgs.push(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('weeb/weebTrees',"shared");
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				add(bgTrees);
				bgs.push(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals',"shared");
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				add(treeLeaves);
				bgs.push(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);
				bgs.push(bgGirls);

				if (SONG.song.toLowerCase() == 'roses')
					{
						bgGirls.getScared();
				}

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				add(bgGirls);
			case "schoolevil":
				curStage = 'schoolEvil';

				var bg:FlxSprite = new FlxSprite(400,200);
				bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool',"shared");
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);
				bgs.push(bg);

			default:
				
				defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.image('stageback',"shared"));
				bg.antialiasing = PlayerSettings.antialiasing;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				bgs.push(bg);
				var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.image('stagefront',"shared"));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = PlayerSettings.antialiasing;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;
				bgs.push(stageFront);
				add(stageFront);

				var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.image('stagecurtains',"shared"));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = PlayerSettings.antialiasing;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;
				bgs.push(stageCurtains);

				add(stageCurtains);
				
				}
		add(gfGrp);

		if (curStage == 'limo')
			add(limo);

		add(dadGrp);
		add(bfGrp);
				
	}
	private function setDialogue():Void
		{
			switch (SONG.song.toLowerCase())
			{
				case 'tutorial':
					dialogue = ["Hey you're pretty cute.", 'Use the arrow keys to keep up \nwith me singing.'];
				case 'bopeebo':
					dialogue = [
						'HEY!',
						"You think you can just sing\nwith my daughter like that?",
						"If you want to date her...",
						"You're going to have to go \nthrough ME first!"
					];
				case 'fresh':
					dialogue = ["Not too shabby boy.", ""];
				case 'dadbattle':
					dialogue = [
						"gah you think you're hot stuff?",
						"If you can beat me here...",
						"Only then I will even CONSIDER letting you\ndate my daughter!"
					];
				case 'senpai','roses','thorns':
					dialogue = CoolUtil.coolTextFile(Paths.txt('songs/${SONG.song.toLowerCase()}/${SONG.song.toLowerCase()}Dialogue'));
			}
		}
	function schoolIntro(?dialogueBox:DialogueWeek6Box):Void
	{
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(1,1, FlxColor.BLACK);
		black.setGraphicSize(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2));
		black.updateHitbox();
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(1,1, 0xFFff1b31);
		red.setGraphicSize(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2));
		red.updateHitbox();

		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy',"shared");
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns')
		{
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns')
			{
				add(red);
			}
		}
		inCutscene = true;

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{

					if (SONG.song.toLowerCase() == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 3, true, function()
									{
										add(dialogueBox);
									}, true);
								});
								
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}



	function startCountdown():Void
	{
	

		inCutscene = false;
		startedCountdown = true;
		Conductor.songPosition = 0;

		Conductor.songPosition -= Conductor.crochet * 5;
		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.dance();
			charPos.set(gf.getGraphicMidpoint().x,gf.getGraphicMidpoint().y);
			var introAlts:Array<String> = ['UI/ready', "UI/set", "UI/go"];
			var altSuffix:String = "";
			if (Note.isPixel)
				{
					introAlts = ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel'];
					altSuffix = '-pixel';
				}
			
			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3' + altSuffix), 0.6);
				case 1:
					charPos.set(dad.getGraphicMidpoint().x,dad.getGraphicMidpoint().y);

					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0],"shared"));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (Note.isPixel)
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y + 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2'+ altSuffix), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1],"shared"));
					set.scrollFactor.set();

					if (Note.isPixel)
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y + 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1'+ altSuffix), 0.6);
				
				case 3:
					charPos.set(boyfriend.getGraphicMidpoint().x,boyfriend.getGraphicMidpoint().y);

					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2],"shared"));
					go.scrollFactor.set();

					if (Note.isPixel)
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y + 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
							canPlay= true;
						}
					});
					FlxG.sound.play(Paths.sound('introGo'+ altSuffix), 0.6);
				
				
			}


			swagCounter += 1;
		}, 5);

	}


	function startSong():Void
	{

		startingSong = false;
		canPause = true;
		FlxG.stage.application.window.title = "FNF MDC Engine: " + SONG.song + " (" + CoolUtil.difficultyString() + ")" ;

		vocals.play();
		music.play();

		music.onComplete = endSong;

		#if desktop
		songLength = music.length;
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength);
		#end
	}


	private function generateSong():Void
	{
		FlxG.camera.follow(camFollow,LOCKON,(0.6));

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		events = [];
		eventID = 0;
		curSong = songData.song;

		if (SONG.needsVoices)
			vocals.loadEmbedded(Paths.voices(PlayState.SONG.song));


		var noteData:Array<SwagSection>;

		noteData = songData.notes;
		unspawnNotes = [];
		for (note in allNotes)
			destroyNote(note);
		notes.clearAll();

		for (section in noteData)
		{

			for (songNotes in section.sectionNotes)
			{
		music.onComplete = endSong;

				if (songNotes[1] < 0)
				{
					// [noteStrum, -1, 0,curEvent,args0,args1];
					bindEvent(songNotes[0],songNotes[3],songNotes[4],songNotes[5]);
				} else {
				var canContinue:Bool = true;
				
				var gottaHitNote:Bool = section.mustHitSection;
				if (songNotes[1] > 3)
					gottaHitNote = !section.mustHitSection;
				if (!gottaHitNote && !PlayerSettings.showOpponentArrows){
					canContinue = false;

					bindEvent(songNotes[0], "playanim", 'sing${animArray[Std.int(songNotes[1])]}', "dad");
					var susLength:Float = songNotes[2] ;
					susLength = susLength / Conductor.stepCrochet;

				if ( Math.floor(susLength) > 0)
					for (i in 0...Math.floor(susLength + 1))
						bindEvent(songNotes[0], "playanim", 'sing${animArray[Std.int(songNotes[1])]}', "dad");

				}

			if (canContinue)
			{
				var oldNote:Note = unspawnNotes.length > 0 ? unspawnNotes[Std.int(unspawnNotes.length - 1)] : null;
				songNotes[4] = gottaHitNote ? 0 : 1;

				if (songNotes[1] >= 8)
					songNotes[4] = 2;
				var swagNote:Note = new Note(songNotes[0], Std.int(songNotes[1] % 4), oldNote);
				swagNote.sustainLength = songNotes[2];
				swagNote.noteFor = songNotes[4];
				if (songNotes[4] > 1)
					hasGF = true;
				swagNote.scrollFactor.set();
				swagNote.mustPress = gottaHitNote;
				swagNote.patern = swagNote;
			
				allNotes.push(swagNote);


				var susLength:Float = swagNote.sustainLength ;
				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				if ( Math.floor(susLength) > 0)
				{
				for (susNote in 0...Math.floor(susLength + 1))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(songNotes[0] + (((Conductor.stepCrochet) * (susNote)) * 0.7), Std.int(songNotes[1] % 4), oldNote, true);
					sustainNote.scrollFactor.set();
					sustainNote.strumTime += (Conductor.stepCrochet / 1.475);
					sustainNote.noteFor = songNotes[4];
					sustainNote.ID = susNote;
					
					unspawnNotes.push(sustainNote);
					swagNote.childrens.push(sustainNote);
					sustainNote.mustPress = gottaHitNote;
					allNotes.push(sustainNote);
					if (susNote == Math.floor(susLength) && PlayerSettings.downscroll)
							sustainNote.strumTime = sustainNote.prevNote.strumTime + (Conductor.stepCrochet * (0.39));

				

				}

				}
			}
				
			}}
		}
		generatedMusic = true;


		unspawnNotes.sort(sortByShit);
		Strum.Strums.added = false;

	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows():Void
	{
		if (generatedStaticArrows)
			return;
		
		playerStrums.generate();
		opponentStrums.generate();

		gfStrums.generate();
		gfStrums.visible = hasGF;
		if (hasGF)
		{
			playerStrums.x += 85;
			opponentStrums.x -= 90;
			gfStrums.x -= 85;
			defaultCamZoomHUD = 0.94;

		}

		generatedStaticArrows = true;
	}
	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			music.pause();
			vocals.pause();
			@:privateAccess var tweens = FlxTween.globalManager._tweens; 
			for (coolTween in tweens)
				{
					if (coolTween != null && !coolTween.finished)
						coolTween.active = false;

				}

			if (!startTimer.finished)
				startTimer.active = false;
			
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (music != null && !startingSong)
			{
				music.time = pausedAtTime;
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
		
			paused = false;
			@:privateAccess var tweens = FlxTween.globalManager._tweens; 
			// REAL PAUSE
			for (coolTween in tweens)
				{
					if (coolTween != null && !coolTween.finished)
						coolTween.active = true;

				}
			#if desktop
			
			if (startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{

		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC, true, songLength - Conductor.songPosition);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			}
		}
		#end

		super.onFocus();
	}
	
	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		}
		#end

		super.onFocusLost();
	}
	function resyncVocals():Void
	{
		if (curStep < 0) return;
		vocals.pause();
		music.play();
		Conductor.songPosition = music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}


	private function _fps(?mult:Float = 10):Float
		return 1 - FlxG.elapsed * mult;
	

	function getRating()
	{
		var acc_in_num =  accuracy / 10;
		FlxG.watch.addQuick("acc", acc_in_num);
		FlxG.watch.addQuick("acc", Math.floor(acc_in_num));
		if (notesPressed.get("played") <= 0)
			return "N/A";
		return ratingTypes[ Math.floor(acc_in_num)];
	}
	override public function update(elapsed:Float)
	{
		
		songPos = ((Conductor.songPosition * 1000) / music.length);
		if (songPos < 0)
			songPos = 0;
		FlxG.watch.addQuick("songPos",songPos);

		camFollow.lerpPositionByRect(charPos,_fps(10 * scrollSpeed));
		
			var tilin = waterMark.text;
		waterMark.text = '- ${curSong} (${CoolUtil.difficultyString()}) ${FlxStringUtil.formatTime(Math.abs(Conductor.songPosition / 1000), false)} -';
		waterMark.screenCenter(X);
		if (tilin != waterMark.text)
			FlxG.stage.application.window.title = 'Friday Night Funkin\' MDC Engine: ${waterMark.text.replace("-"," ")} ';

		if (FlxG.keys.justPressed.NINE)
		{
			if (iconP1.animation.curAnim.name == 'bf-old')
				iconP1.animation.play(SONG.player1);
			else
				iconP1.animation.play('bf-old');
		}

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
		}

		super.update(elapsed);

		scoreTxt.text = '< Score: $songScore | Accuracy: ${getRating() == "N/A" ? "?" : Std.string(accuracy)}% | Rating: ${getRating()}  ${notesPressed.get("miss") <= 0 ? "" : '| Misses: ${notesPressed.get("miss")}'}  >';
		scoreTxt.screenCenter(X);
		scoreBG.setGraphicSize(Math.floor(scoreTxt.width * 1.05),Math.floor(scoreTxt.height * 1.2));
		scoreBG.updateHitbox();
		scoreBG.screenCenter(X);

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			pausedAtTime = music.time;
			Conductor.songPosition = music.time;

			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y,[music,vocals]));
		
			#if desktop
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
			#end
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			FlxG.switchState(new ChartingState());

			#if desktop
			DiscordClient.changePresence("Chart Editor", null, null, true);
			#end
		}

		iconP1.scale.set(FlxMath.lerp(1, iconP1.scale.x,_fps()),FlxMath.lerp(1, iconP1.scale.y,_fps()));
		iconP2.scale.set(FlxMath.lerp(1, iconP2.scale.x,_fps()),FlxMath.lerp(1, iconP2.scale.y,_fps()));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		iconP1.x = healthBar.healthBar.x + (healthBar.healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - 26);
		iconP2.x = healthBar.healthBar.x + (healthBar.healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - 26);

		if (health > 2)
			health = 2;
		iconP1.animation.curAnim.curFrame = (healthBar.percent < 20 ? 1 : 0);
		iconP2.animation.curAnim.curFrame = (healthBar.percent > 80 ? 1 : 0);
		if (!inCutscene)
			Conductor.songPosition += (FlxG.elapsed) * 1000;
		if (Conductor.songPosition >= 0 && !startingSong)
			startSong();
		curSection = Math.floor(curStep / 16);
		if (generatedMusic && SONG.notes[curSection] != null)
		{
		

			if (!SONG.notes[curSection].mustHitSection)
			{
				charPos.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);

				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						charPos.y = dad.getMidpoint().y;
					case 'senpai':
						charPos.y = dad.getMidpoint().y - 430;
						charPos.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						charPos.y = dad.getMidpoint().y - 430;
						charPos.x = dad.getMidpoint().x - 100;
				}

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}
			}
			else
			{
				charPos.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				switch (curStage)
				{
					case 'limo':
						charPos.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						charPos.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						charPos.x = boyfriend.getMidpoint().x - 200;
						charPos.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						charPos.x = boyfriend.getMidpoint().x - 200;
						charPos.y = boyfriend.getMidpoint().y - 200;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, _fps());
			camHUD.zoom = FlxMath.lerp(defaultCamZoomHUD, camHUD.zoom, _fps());
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (controls.RESET)
		{
			gameOver();
			trace("RESET = True");
		}

		if (health <= 0)
			gameOver();

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				
				notes.push(dunceNote);


				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}
		switch (player)
		{
			case 0: strumP1 = playerStrums;
			case 1: strumP1 = opponentStrums;
			case 2: strumP1 = gfStrums;
		}
	
		if (generatedMusic)
			{
				if (events.length > 0)
				{
					for (event in events)
						{
							if (event[0] <= Conductor.songPosition)
								onEvent(event);
							else
								break;
						}
				}
			
				notes.getNoteAlive(function(daNote:Note)
				{
					var daStrum:FlxSprite  = strumLineNotes.members[daNote.noteFor].get(daNote.noteData);
					if (daStrum == null)
						daStrum = strumLine;
	
					var strumY = daStrum.y;
					var strumX = daStrum.x;
	
					if (strumY >= FlxG.height / 2)
						daNote.y = (strumY + 0.45 * ((Conductor.songPosition + PlayerSettings.offset)- daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
					else 
						daNote.y = (strumY - 0.45 * ((Conductor.songPosition + PlayerSettings.offset)- - daNote.strumTime) * FlxMath.roundDecimal(SONG.speed, 2));
				
					daNote.x = strumX;
					daNote.alpha = daStrum.alpha * (daNote.isSustainNote ? 0.5 : 1 );
				
					if (daNote.isSustainNote)
						daNote.x += daNote.width / (daNote.isPix ? 2 : 1);
					
	
					if (daNote.noteFor != player && daNote.strumTime <= (Conductor.songPosition + PlayerSettings.offset))
						botNoteHit(daNote,daNote.noteFor);
				
					strumP1.isBot = PlayerSettings.botplay;
					boyfriend.isPlayer = PlayerSettings.botplay;
	
					if (daNote.noteFor == player && daNote.strumTime <= (Conductor.songPosition + PlayerSettings.offset) && PlayerSettings.botplay)
							goodNoteHit(daNote);
	
					if (daNote.strumTime + noteOffset < (Conductor.songPosition - Conductor.safeZoneOffset))
					{
						if ((daNote.tooLate && !daNote.wasGoodHit) && daNote.noteFor == player)
							noteMiss(daNote.noteData,daNote);
	
						daNote.active = false;
						daNote.visible = false;
						destroyNote(daNote);
					}
				});
			}

		if (!inCutscene && (!PlayerSettings.botplay && !isReplay))
			keyShit();
		if (isReplay)
			{
			if (replayData.length > 0)
				{
				for (replay in replayData)
					{
						if (replay.inSongPos <=  (Conductor.songPosition + PlayerSettings.offset))
							{
								switch (replay.data.toLowerCase())
								{
									case "good-press":
										goodNoteHit(notes.searchAtTime(replay.hitData.strumTime,replay.hitData.noteData,player),replay.hitData.diff);
									case "bad-press":
										noteMiss(replay.hitData.noteData);
									case "pressedstrum-static","pressedstrum-pressed","pressedstrum-confirm":
										var anim = replay.data.toLowerCase().split("-")[1];
										strumP1.babyArrows[replay.hitData.noteData].playAnim(anim,false);
								}
								replayData.remove(replay);
							} 
							else
							{
							break;
							}
					}
				} else
				{

					endSong();
				}
			}
		if (!isReplay)
			{
				strumP1.onPress = function (data:String,id:Int)
					{
						addReplayData({inSongPos:  Conductor.songPosition, data: "pressedStrum-" + data, hitData: { strumTime: 0, diff: 0, noteData: id}});
					}
			}
		if (strumP1.hasInAnyConfirm && (boyfriend.holdTimer > Conductor.stepCrochet * 5 * 0.001) && (PlayerSettings.botplay || isReplay))
			boyfriend.dance();
		
		if (#if debug FlxG.keys.justPressed.ONE  #else false #end  || (isReplay && FlxG.keys.justPressed.SPACE))
			endSong();
	}

	function replayHit(note:Note,diff:Float)
	{
		///UN MEGA ANAL
		var bf:Character = boyfriend;
		var strum:Strums = playerStrums;
		// For the people change the chart when the replay
		
		if (note == null) return;
		
 		switch (note.noteFor)
		{
			case 1: 
				bf = dad;
				strum = opponentStrums;
			case 2: 
				bf = gf;
				strum = gfStrums;
		}
		strumP1 = strum;
		popUpScore(note,diff);
		combo += 1;
		boyfriend.holdTimer = 0;
		if (note.noteData >= 0)
			health += (note.isSustainNote ? 0.015 : 0.025);
		var altAnim:String = "";
		if (SONG.notes[curSection] != null)
				if (SONG.notes[curSection].altAnim)
					altAnim = '-alt';
		bf.holdTimer= 0;
		bf.playAnim('sing${animArray[note.noteData]}${altAnim}');

		strumP1.play(Math.floor(Math.abs(note.noteData)));

		note.wasGoodHit = true;
		vocals.volume = 1;

		destroyNote(note);
	}
	function gameOver():Void
	{
		if (isReplay)
			FlxG.switchState(new Result(accuracy,notesPressed,rPlayData));

		health = 0;
		if (health < 0)
			health = 0;
		boyfriend.stunned = true;
		persistentUpdate = false;
		persistentDraw = false;
		paused = true;
		vocals.stop();
		music.stop();

		openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

		#if desktop
		// Game Over doesn't get his own variable because it's only used here
		DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconRPC);
		#end
	}
	function endSong():Void
	{
		if (!isReplay) rPlayData = replayData.copy();
		canPause = false;
		startingSong = false;
		music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				FlxG.switchState(new StoryMenuState());

				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				trace('LOADING NEXT SONG');

				prevCamFollow = camFollow;
				var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
				-FlxG.height * FlxG.camera.zoom).makeGraphic(1,1, FlxColor.BLACK);
				blackShit.setGraphicSize(Std.int(FlxG.width * 3), Std.int(FlxG.height * 3));
				blackShit.updateHitbox();
				blackShit.scrollFactor.set();
				if (SONG.song.toLowerCase() == 'eggnog')
					{
						add(blackShit);
						camHUD.visible = false;
						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';
				if (storyDifficulty == 2)
					difficulty = '-hard';
				PlayState.SONG = Song.loadFromJson(storyPlaylist[0] + difficulty, storyPlaylist[0]);
				
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;

				FlxG.switchState(new PlayState());
			

			}
		}
		else
		{
			trace('WENT BACK TO FREEPLAY??');
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;

			FlxG.switchState(new Result(accuracy,notesPressed,rPlayData));

		}
	}

	private function destroyNote(note:Note)
	{
	
		notes.delete(note);
		allNotes.remove(note);
		note.kill();
		note.destroy();
	}

	private function tryAddNotes(name:String,toAdd:Float)
	{
		if (!notesPressed.exists(name))
			notesPressed.set(name,0);
		 notesPressed.set(name,notesPressed.get(name) + toAdd);
		 return notesPressed.get(name);
	}
	private function updateAccuracy():Void
	{
		tryAddNotes("played",1);
		accuracy = FlxMath.roundDecimal(
			(notesPressed.get("notes") * 100) / notesPressed.get("played")
			,2);
		if (accuracy < 0)
			accuracy = 0.00;
		if (accuracy > 100)
			accuracy = 100.00;
	}


	
	function addReplayData(data:Replay.ReplayData):Void
	{
		if (data == null && isReplay && Conductor.songPosition + PlayerSettings.offset < 0) return;
		data.inSongPos = (Conductor.songPosition);
		FlxG.watch.addQuick("LastData", data);
		replayData.push(data);
	}
	
	private function popUpScore(nnot:Note,?diff:Float = -999):Void
	{
		add(scoreGRP);
		scoreGRP.cameras = comboGrp.cameras = msGrp.cameras = [anotherCam];
		var noteDiff:Float = -(nnot.strumTime - Conductor.songPosition);
		scoreGRP.add(comboSpr);
		scoreGRP.add(rating);
		add(comboGrp);
		add(msGrp);

		var score:Int = 350;
		var daRating:String = "sick";
		if (diff != -999) noteDiff = diff;
		var color:Int = 0;
		var coolMap:Map<String,Dynamic> = CoolUtil.calculateRating(noteDiff);

		color = coolMap.get("color");
		daRating = coolMap.get("rating");
		score = coolMap.get("score");

		addReplayData({inSongPos: Conductor.songPosition, data: "good-press", hitData:{ strumTime: nnot.strumTime, diff: noteDiff, noteData: nnot.noteData}});

		if (!nnot.isSustainNote)
		{
			if (daRating.startsWith("sick")) strumP1.splash(nnot.noteData);

			for (child in nnot.childrens)
				child.ratingToForce = daRating;
		}
		else
			daRating = nnot.ratingToForce;

		tryAddNotes(daRating,1);
		judg(score);
		updateAccuracy();

		var seperatedScore:Array<String> = '$combo'.split('');

		// If you say, why?, I answer you, why the hell not?
		rating.appear(daRating);
		comboSpr.appear();
		// I delete more than 150 lines.

		for (i in 0...seperatedScore.length)
		{
			if (comboGrp.members[i] == null) comboGrp.members[i] = new SwagNum();
			var numScore:SwagNum = comboGrp.members[i];
			comboGrp.remove(numScore);

			numScore.appear('${seperatedScore[i]}', i != 0 ? comboGrp.members[i - 1] : numScore, false, 1 );
			comboGrp.add(numScore);
		}

		for (i in 0...'${Math.floor(noteDiff)}MS'.split("").length)
		{
		
			if (msGrp.members[i] == null) msGrp.members[i] = new SwagNum();
			var numScore:SwagNum = msGrp.members[i];
			msGrp.remove(numScore);
			numScore.appear('${Math.floor(noteDiff)}MS'.split("")[i], i != 0 ? msGrp.members[i - 1] : numScore, true, 0.85);
			msGrp.add(numScore);
		}

	}

	private function keyShit():Void
	{
		if (!generatedMusic) return;

		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var realeasArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];

		var ignoreList:Array<Int> = [];

		if (holdArray.contains(true))
			{
				boyfriend.holdTimer = 0;
	
				notes.getNoteAlive(function(daNote:Note)
				{
					if (daNote.isSustainNote && daNote.noteFor == player && daNote.canBeHit && holdArray[daNote.noteData] )
							goodNoteHit(daNote);
				});

				var possibleNotes:Array<Note> = [];
	
				notes.getNoteAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.noteFor == player && !daNote.tooLate && !daNote.wasGoodHit)
					{
						if (ignoreList.contains(daNote.noteData))
							{
								for (coolNote in possibleNotes)
									if (coolNote.strumTime > daNote.strumTime  && daNote.noteData == coolNote.noteData)
									{ 
										possibleNotes.push(daNote);
										possibleNotes.remove(coolNote);
										break;
									}
							}
							else
							{
								possibleNotes.push(daNote);
								ignoreList.push(daNote.noteData);
							}
					}
				});
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
	
				if (possibleNotes.length > 0)
				{
			
					if (!PlayerSettings.ghosttapin)
						for (shit in 0...pressArray.length)
							if (pressArray[shit] && !ignoreList.contains(shit))
							{
								noteMiss(shit, null);
								addReplayData({inSongPos: Conductor.songPosition, data: "bad-press",hitData:{strumTime:0,noteData:shit,diff:0}});
							}
						for (coolNote in possibleNotes)
							{
								if (pressArray[coolNote.noteData]) goodNoteHit(coolNote); // else break; this break all input LITERALLY.
							}
							
					
				}
				else
					{
						if (!PlayerSettings.ghosttapin)
							for (shit in 0...pressArray.length)
								if (pressArray[shit])
								{
									noteMiss(shit, null);
									addReplayData({inSongPos: Conductor.songPosition, data: "bad-press",hitData:{strumTime:0,noteData:shit,diff:0}});
								}
					}
			}
		

		if ((boyfriend.holdTimer > Conductor.stepCrochet * 5 * 0.001) && !holdArray.contains(true))
			boyfriend.dance();

		strumP1.check([holdArray, realeasArray]);
	
	}
	private function judg(score:Int)
	{
		songScore += score;
		tryAddNotes("notes",(score * 100 / 350) / 100);
	}
	function noteMiss(direction:Int = 1,?daNote:Note):Void
	{
		if (PlayerSettings.botplay && daNote != null) return goodNoteHit(daNote);
		if (boyfriend.stunned) return;
		 
		if (daNote != null)
		{
			if (!daNote.isSustainNote && PlayerSettings.sustainPressDependToFather)
			{
				for (child in daNote.childrens)
				{
					destroyNote(child);
				}
			}
		}
		health -= 0.04;
		vocals.volume = 0.1;
		if (combo > 1 && gf.animOffsets.exists('sad'))
			gf.playAnim('sad');
		combo = 0;

		judg(-35);

		tryAddNotes("miss",1);
		updateAccuracy();

		FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
		boyfriend.stunned = true;

		new FlxTimer().start(5 / 60, function(tmr:FlxTimer)
		{
			boyfriend.stunned = false;
		});

		boyfriend.playAnim('sing${animArray[direction]}miss');
		
	}


	function botNoteHit(daNote:Note,charID:Int = 0):Void
	{
		if (daNote.wasGoodHit) return;
		if (SONG.song != 'Tutorial')
			camZooming = true;

		var altAnim:String = "";
		if (SONG.notes[curSection] != null)
		 if (SONG.notes[curSection].altAnim)
		  altAnim = '-alt';
		var strum:Strums = opponentStrums;
		var char:Character = dad;
		switch(charID)
		{
			case 0:
				char = boyfriend;
				strum = playerStrums;
			case 2:
				char = gf;
				strum = gfStrums;
				
		}
		strumP2 = strum;
		if (SONG.needsVoices)
			vocals.volume = 1;
		char.playAnim('sing${animArray[daNote.noteData]}${altAnim}');
		char.holdTimer = 0;
		if (curSong.toLowerCase() == "amusia") return;

		strumP2.splash(daNote.noteData);
		strumP2.play(daNote.noteData);


		daNote.wasGoodHit = true;
			destroyNote(daNote);

	}


	function goodNoteHit(note:Note,?diff:Float = -999):Void
	{
		if (note.wasGoodHit) return;
		var bf:Character = boyfriend;
		var strum:Strums = playerStrums;
		switch (note.noteFor)
		{
			case 1: 
				bf = dad;
				strum = opponentStrums;
			case 2: 
				bf = gf;
				strum = gfStrums;
		}
		strumP1 = strum;
		popUpScore(note, PlayerSettings.botplay ? 0 : diff);
		combo += 1;
		combo = Math.floor(Math.abs(combo));

		boyfriend.holdTimer = 0;
		if (note.noteData >= 0)
			health += (note.isSustainNote ? 0.015 : 0.025);
		var altAnim:String = "";
		if (SONG.notes[curSection] != null)
				if (SONG.notes[curSection].altAnim)
					altAnim = '-alt';
		bf.holdTimer= 0;
		bf.playAnim('sing${animArray[note.noteData]}${altAnim}');

		strumP1.play(Math.floor(Math.abs(note.noteData)));

		note.wasGoodHit = true;
		vocals.volume = 1;

		destroyNote(note);
	}


	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}


	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}


	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				{
					gf.playAnim('hairFall');
					phillyTrain.x = FlxG.width + 200;
					trainMoving = false;
					trainCars = 8;
					trainFinishing = false;
					startedMoving = false;
				}
		}
	}

	

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}

	override function stepHit()
	{
		super.stepHit();
	
		if (music.time > Conductor.songPosition + 20 || music.time < Conductor.songPosition - 20)
			resyncVocals();
	}

	

	override function beatHit()
	{
		super.beatHit();

		if (SONG.notes[curSection] != null)
		{
			if (SONG.notes[curSection].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[curSection].bpm);
				FlxG.log.add('CHANGED BPM!');
			}

			if (SONG.notes[curSection].mustHitSection)
				dad.dance();
		}
	

		wiggleShit.update(Conductor.crochet);

		// HARDCODING FOR MILF ZOOMS!
		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.025;
			camHUD.zoom += 0.035;
		}
		if (iconP1.scale.x <= 1.35)
			iconP1.scale.set(1.35,1.35);
		if (iconP2.scale.x <= 1.35)
			iconP2.scale.set(1.35,1.35);

		if (curBeat % gfSpeed == 0)
			gf.dance();

		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
			boyfriend.playAnim('hey', true);

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
			lightningStrikeShit();
	}

}
