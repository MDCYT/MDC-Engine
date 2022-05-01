package;

import openfl.media.Sound;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import lime.app.Application;
import Discord.DiscordClient;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import openfl.display.BitmapData;
import flixel.FlxG;
import sys.FileSystem;
import flixel.FlxState;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;

class InitialCache extends MusicBeatState {
  var loaded:Int = 0;
  var max:Int;
  var text:FlxText;
  var current:String = "nothing";
  var logoSprite:flixel.FlxSprite;
  public static function e(){
    FlxG.save.bind('funkin', 'MDCDEV');
		// NO TOQUEN ESTA MAMADA, igual nada se toca aquí, por que de igual modo da crash,
		// PERO EN SERIO NO LO TOQUES SI QUIERES DESHABILITARLO HABRÁ UN HAXELIB NAME
		// LO ELIMINAS DEL PROJECT.XML
		account.Main.start();

		PlayerSettings.init();


		// DEBUG BULLSHIT

		NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end


		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}
    var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
    diamond.persist = true;
    diamond.destroyOnNoUse = false;

    FlxTransitionableState.defaultTransIn = new TransitionData(TILES, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
      new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
    FlxTransitionableState.defaultTransOut = new TransitionData(TILES, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
      {asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));

  

		#if desktop
		DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end
  }
  override function create() {
    super.create();
   e();
   transIn = FlxTransitionableState.defaultTransIn;
   transOut = FlxTransitionableState.defaultTransOut;
    text = new FlxText(0,400,0, "LOADING...");
    text.setFormat(Paths.font('vcr.tff'), 20, FlxColor.BLACK, CENTER);
    text.screenCenter(X);
    add(text);
    logoSprite = new FlxSprite(0, -100).loadGraphic('assets/images/logo.png');
    logoSprite.screenCenter(X);
    add(logoSprite);
    var toLoadSongs = FileSystem.readDirectory('assets/songs');
    var toLoadSounds = FileSystem.readDirectory('assets/sounds');
    var toLoadMusic = FileSystem.readDirectory('assets/music');
    var toLoadImg = FileSystem.readDirectory('assets/images');
    max = toLoadSongs.length + toLoadSounds.length + toLoadMusic.length + toLoadImg.length;
    for (i in 0...toLoadSongs.length) {
      loaded ++;
    var pat = 'assets/songs/${toLoadSongs[i]}/';
      var s = Sound.fromFile(pat + 'Inst.ogg');
      FlxG.sound.play(s, 0.01, false, null, true);
      current = 'assets/songs/${toLoadSongs[i]}/Inst.ogg';

      if (FileSystem.exists('${pat}Voices.ogg')){
        var p = Sound.fromFile(pat + 'Voices.ogg');

        current = 'assets/songs/${toLoadSongs[i]}/Voices.ogg';
        FlxG.sound.play(p, 0.01, false, null, true);
      }
    }
    for (i in 0...toLoadSounds.length) {
      current = 'assets/sounds/${toLoadSounds[i]}';

      FlxG.sound.load('assets/sounds/${toLoadSounds[i]}');
      loaded ++;

    }
    for (i in 0...toLoadMusic.length) {
      current = 'assets/music/${toLoadMusic[i]}';
      FlxG.sound.load('assets/music/${toLoadMusic[i]}');
      loaded ++;
    }
    for (i in 0...toLoadImg.length){
      if (FileSystem.isDirectory('assets/images/${toLoadImg[i]}')) {
        current = 'assets/images/${toLoadImg[i]}';
        var img = FileSystem.readDirectory('assets/images/${toLoadImg[i]}');
        max += img.length;
        for (e in 0...img.length){
          var bitmapLoad = BitmapData.loadFromFile('assets/images/${img[e]}');
          current = 'assets/images/${img[i]}';

          loaded ++;
        }
        loaded ++;
      } else {
        current = 'assets/images/${toLoadImg[i]}';
        var bitmapLoad = BitmapData.loadFromFile('assets/images/${toLoadImg[i]}');
        loaded ++;
      }
    }
    
  }
  function onLoad() {
    FlxG.switchState(new TitleState());
  }
  var load:Bool = false;
  var tryChange:Bool = true;
  override function update(e:Float) {
    super.update(e);
    FlxG.watch.addQuick("State", current);
    FlxG.watch.addQuick("loaded", loaded);
    FlxG.watch.addQuick("loaded", max);
    if (load) {
      current = 'all its loaded!';
    }
    text.text = 'LOADING: ${current}\n$loaded / $max';
    load = max == loaded;
    if (load) 
      onLoad();
  }
}