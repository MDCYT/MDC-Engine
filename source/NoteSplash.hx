package;

import flixel.FlxG;
import flixel.FlxSprite;
class NoteSplash  extends FlxSprite {
  public function new(s:Int = 0, x:Float, y:Float){
    super(x,y);
    frames = Paths.getSparrowAtlas('splash', 'shared');
    

    antialiasing = true;
    animation.addByPrefix('note impact ${FlxG.random.int(0,1)} left', 'left', 24, false);
    animation.addByPrefix('note impact ${FlxG.random.int(0,1)} down', 'down', 24, false);
    animation.addByPrefix('note impact ${FlxG.random.int(0,1)} up', 'up', 24, false);
    animation.addByPrefix('note impact ${FlxG.random.int(0,1)} right', 'right', 24, false);
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