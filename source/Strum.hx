package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;

import flixel.group.FlxSpriteGroup;

class Strums extends FlxSpriteGroup
{
    private var player:Int = 0;
    private var posY:Float = 0;
    public static var added:Bool = false;
    public function new(posY:Float,player:Int):Void
    {
        super();
        this.posY = posY;
        this.player = player;
        if (player > 1)
            added = true;
        scrollFactor.set();
   
    }
    public var babyArrows:Array<Strum> = [];
    public var noteSplashes:Array<NoteSplash> = [];
    public function generate():Void
    {
        x = 0;
        if (!PlayerSettings.showOpponentArrows && player != 0)
            visible = active = false;
        switch(player)
        {
            case 0: x = 780;
            if (!PlayerSettings.showOpponentArrows)
                {
                    x = 50 + (4 * Note.swagWidth);
                    x-= 89;
                }
            case 1: x += 50;
            isBot = true;
            alpha = 0.5;
            case 2: x += 50 + (4 * Note.swagWidth);
            isBot = true;
        }

        for (index in 0...4)
        {
            var babyArrow:Strum = new Strum(index,posY - 25,x);
            babyArrow.alpha = 0;
            babyArrows.push(babyArrow);
            isBot = true;
            wasSick = true;
            add(babyArrow);

            var splashNote = new NoteSplash(index);
            splashNote.updateHitbox();
            noteSplashes.push(splashNote);
            add(splashNote);
            FlxTween.tween(babyArrow, {y: babyArrow.y + 25, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * index)});
        }
     
    
        // screenCenter(X);
        // x += 110 * 0.5;

    }
    public var isBot:Bool = false;
    public var hasInAnyConfirm:Bool = false;
    public override function update(leap)
        {
            super.update(leap);
            hasInAnyConfirm = babyArrows[0].animation.curAnim.name == "static" && 
            babyArrows[1].animation.curAnim.name == "static" && 
            babyArrows[2].animation.curAnim.name == "static" &&
            babyArrows[3].animation.curAnim.name == "static";
            for (n in babyArrows)
                {
                    n.onPressAny = onPress;
                }
        }
    public var wasSick:Bool = false;
    public function get(id:Int)
    {
        return (babyArrows[Math.floor(Math.abs(id % 4))]);
    }
    public function play(?id:Int):Void
    {
        for (spr in babyArrows)
            {
                if (id == spr.ID)
                    spr.playAnim("confirm",isBot);
                spr.forceBot = isBot;
            }
      
    }
    public function splash(?id:Int = 0)
    {
        for (spr in noteSplashes)
            {
                spr.updateHitbox();
                spr.x = (get(spr.ID).x + get(spr.ID).width / 2) - 160;
                spr.y = (get(spr.ID).y + get(spr.ID).height / 2) - (20 * 6);
                if (spr.ID == id)
                    spr.press();
            }
    }
    public function check(bools:Array<Array<Bool>>):Void
    {
        for (spr in babyArrows)
            {
                spr.animations(bools[0][spr.ID],bools[1][spr.ID]);
                spr.forceBot = isBot;
            }
    }
    public var onPress:(data:String,id:Int) -> Void;

}
class Strum extends FlxSprite
{

    private var offsetPlayer:Array<Int> = [3,2,1,0];
    private var names:Array<String> = ["left","down","up","right"];
    public var oldPosY:Float;
    public var oldPosX:Float;
    public var tween:FlxTween;
    public var onY:Bool = false;
    public var onPressAny:(data:String,id:Int)->Void;
    public function punish(?twn:FlxTween = null):Void
        {
            if (tween != null) tween.cancel();

            tween = FlxTween.tween(this,{y: this.oldPosY + 5 * (onY ?  Math.PI : -Math.PI)},
            1,
            {ease: FlxEase.circOut,startDelay: 0.1 * ID,
            onComplete: punish});
            onY =!onY;
        }
    public function new(id:Int = 0,posY:Float,addPosX:Float):Void
    {
        super();
        ID = id;
        this.oldPosY = posY;
        y = posY;

        if (Note.isPixel)
        {
            loadGraphic(Paths.image('pixelUI/arrows-pixels',"shared"), true, 17, 17);
            scale.set(6,6);
            antialiasing = false;
            animation.add('static', [0 + (1 * ID)]);
            animation.add('pressed', [4 + (1 * ID),8 + (1 * ID)], 12, false);
            animation.add('confirm', [12 + (1 * ID),16 + (1 * ID)], 24, false);
        }
        else
        {
            frames = Paths.getSparrowAtlas('UI/NOTE_assets',"shared");
            var scalee:Float = 0.7;
           
            antialiasing = PlayerSettings.antialiasing;
            scale.set(scalee,scalee);
            animation.addByPrefix('static', 'arrow${names[ID].toUpperCase()}');
            animation.addByPrefix('pressed', '${names[ID]} press', 24, false);
            animation.addByPrefix('confirm', '${names[ID]} confirm', 24, false);
        }

        x = (Note.swagWidth * ID) + addPosX;
        oldPosX = x;
        updateHitbox();
        playAnim("static",false);
        scrollFactor.set();
        
    }
    private var hasBot:Bool = false;
    public var forceBot:Bool = false;
    public function animations(pressed:Bool,released:Bool):Void
    {
        if (pressed && animation.curAnim.name != 'confirm')
            playAnim("pressed",forceBot);
        if (released)
            playAnim("static",forceBot);
    }
    public function playAnim(AnimName:String = "static",hasBot:Bool = false)
    {
        animation.play(AnimName,true);
        this.hasBot = hasBot;
        waitTime = 0;
        if (onPressAny != null)
        onPressAny(AnimName,ID);
		centerOffsets();
        centerOrigin();
    }
    private var waitTime:Float = 0;
    public var moveX:Float = 0;
    public var moveY:Float = 0;
    var offsetADD:Bool = false;
    var offX:Float = 1;
    var offY:Float = 1;
    override function update(elapsed:Float)
    {
        super.update(elapsed);
        var beat = (Conductor.songPosition) / 1000  * (Conductor.bpm / 60);
        
        x = oldPosX + (moveX * (ID + 1))  * Math.sin((beat + (ID * 0.25)));
        y = oldPosY + (moveY * (ID + 1)) * Math.cos((beat + (ID * 0.25)));
       

        if (animation.curAnim.name == "confirm" && hasBot && animation.curAnim.finished)
                waitTime += FlxG.elapsed * 1000;
        if (waitTime >= Conductor.stepCrochet * 250 * 0.001)
            {
                waitTime = 0;
                playAnim("static");
            }
    }
}
class NoteSplash extends FlxSprite
{
    public var notes:Array<String> = ["purple","blue","green","red"];
    public function new(id:Int)
    {
        super();
        ID = id;
        frames = Paths.getSparrowAtlas((Note.isPixel ? "pixel" : "") +"UI/noteSplashes","shared");
        for (i in 0...2)
         animation.addByPrefix('anim-$i', 'note splash ${notes[ID]} ${i+1}',24,false);
        scrollFactor.set();
    }
    public override function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (animation.curAnim != null) if (animation.curAnim.finished) visible = false;
    }
    public function press():Void
    {
        animation.play("anim-" + FlxG.random.int(0,1),true);
        visible = true;
    }
}