package;

import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
class NoteSplash  extends FlxSprite {
  public function new(s:Int = 0, x:Float, y:Float){
    super(x,y);
    frames = Paths.getSparrowAtlas('splash', 'shared');
   // var e = Assets.getText('assets/data/s').split('\n');
    

    antialiasing = true;
    animation.addByPrefix('left', 'note impact ${FlxG.random.int(1,2)} left', 24, false);
    animation.addByPrefix('down', 'note impact ${FlxG.random.int(1,2)} down', 24, false);
    animation.addByPrefix('up', 'note impact ${FlxG.random.int(1,2)} up', 24, false);
    animation.addByPrefix('right', 'note impact ${FlxG.random.int(1,2)} right', 24, false);
    x -= 110;
    y -= 110;
    switch(s){
      case 0: animation.play('left');
      case 1: animation.play('down');
      case 2: animation.play('up');
      case 3: animation.play('right');
    }
		offset.set(10, 10);
    scrollFactor.set();
		setPosition(x - Note.swagWidth * 0.95, y - Note.swagWidth);


  }
  
	override function update(elapsed:Float) {
		if(animation.curAnim != null)
      if(animation.curAnim.finished) 
        kill();

		super.update(elapsed);
	}
}