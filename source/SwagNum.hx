package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;

class SwagNum extends FlxSprite
{
    public function new():Void {
        super();
    }
    private var tween:FlxTween;
    private var prevNum:SwagNum;
    private var map:Map<String,String> = [
        "." => "Point",
        "-" => "Minus",
        "%" => "Percent",
        "null" => "0",
    ];
    public function appear(num:String,prevNum:SwagNum, move:Bool = true, ?mult:Float = 1)
    {
        if (tween != null) tween.cancel();
        if (prevNum == null) prevNum = this;

        this.prevNum = prevNum;
        if (map.get(num) != null) num = map.get(num);

        loadGraphic(Paths.image(Note.isPixel ? 'pixelUI/num$num-pixel' : 'UI/num$num' ,"shared"));
        alpha = 1;
        acceleration.set();
	    velocity.set();
      
        antialiasing = !Note.isPixel;
        setGraphicSize(Std.int(((width) *  (Note.isPixel ? 6 : 0.5)) * mult));
        acceleration.set();
        velocity.set();

        updateHitbox();
        if (!move) return;
        screenCenter();
		x = FlxG.width * 0.55;

        if (prevNum != this) x = prevNum.x + prevNum.width;
        
        y += 80;

        acceleration.set(FlxG.random.int(200, 300));
        velocity.set(-(FlxG.random.int(140,160)),FlxG.random.float(-7.5,7.5));
        tweenThis();
    }
    public function tweenThis()
    {
        tween = FlxTween.tween(this, {alpha: 0}, 0.2, {startDelay: Conductor.crochet * 0.001});
    }
}