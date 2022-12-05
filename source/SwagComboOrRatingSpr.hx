package;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxG;

class SwagComboOrRatingSpr extends FlxSprite
{
    private var tween:FlxTween;
    public function appear(num:String = "combo")
    {
        var isRating:Bool = !(num == "combo");
        if (tween != null) tween.cancel();

        
		loadGraphic(Paths.image(Note.isPixel ? 'pixelUI/$num-pixel' : 'UI/$num' ,"shared"));
        setGraphicSize(Std.int((width *  (Note.isPixel ? 6 : 0.7))));
        antialiasing = Note.isPixel;
        alpha = 1;
        acceleration.set();
        velocity.set();
        screenCenter();
        x = FlxG.width * 0.55;
        updateHitbox();

        if (isRating)
        {
            x = x - 40;
            y -= 60;
        }
       
        acceleration.set(0,550);
        velocity.set(-( FlxG.random.int(0, 10)),-(FlxG.random.int(140, 175)));
        tweenThis();
    }
public function tweenThis()
    {
        tween = FlxTween.tween(this, {alpha: 0}, 0.2, {startDelay: Conductor.crochet * 0.001});
    }
}