package;

import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

class UpdaterScreen extends MusicBeatSubstate {
  override function create(){
    super.create();

    var s = new FlxSprite(2000).makeGraphic(600, FlxG.height, FlxColor.BLACK);
    add(s);
    var o = new FlxText(2000,0,0,"OYE TIENES UNA VERSIÓN ANTIGUA DE MDC ENGINE!\n\n");
    add(o);
    new FlxTimer().start(1, function(_) 
      {
        FlxTween.tween(s, {x: 900});
        FlxTween.tween(o, {x: 900});
      });
    FlxG.mouse.visible = true;

  }
  override function close() {
    super.close();
    MainMenuState.selectedSomethin = true;
  }
}