package;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
class HealthBar extends FlxSpriteGroup
{
    public var healthBarBG:FlxSprite;
    public var healthBar:FlxBar;
    private var colorLeft:FlxColor;
    private var colorRight:FlxColor;

    public var percent:Float = 50;
 
    public function new(instance:MusicBeatState, areUP:Bool = false):Void
    {
        super();
        healthBarBG = new FlxSprite().makeGraphic(1,1,FlxColor.BLACK);
		healthBarBG.setGraphicSize((Math.floor((!areUP ? FlxG.width :  FlxG.height) * 0.6) ), 22);
		healthBarBG.updateHitbox();
		healthBarBG.screenCenter(X);
		add(healthBarBG);    
        
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), instance,
        'health', 0, 2);
        healthBar.scrollFactor.set();
        healthBar.createFilledBar(0xFFFF0000, 0xFF00FF00);
        add(healthBar);
      
    }
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        percent = healthBar.percent;
    }
}

