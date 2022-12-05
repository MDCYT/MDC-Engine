package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;

import openfl.Assets;
using StringTools;

class DialogueBox extends FlxSpriteGroup
{
    public var text:FlxTypeText;
    public var dialogueData:DialogueData;
    public var hasDialogue:Bool = true;

    private var dialogue:Dialogue;
	public var onComplete:Void->Void = function ()
        {
            trace("ON END!");
        };

    private var portrait:Portrait;
    private var dialogueBoxSpr:DialogueBoxSprite;

    public function new(song:String)
    {
        super();
        song = song.toLowerCase();
        if (Paths.exists("data/songs/" + song + "/dialogue.json"))
            dialogueData = cast haxe.Json.parse(Assets.getText(Paths.json('songs/$song/dialogue')).trim());
        if (dialogueData == null)
            {
                hasDialogue = false;
                return;
            }
        hasDialogue = true;
        dialogueBoxSpr = new DialogueBoxSprite();
        dialogueBoxSpr.y = FlxG.height + dialogueBoxSpr.height;
        portrait = new Portrait();
        trace(dialogueData);
        dialogue = dialogueData.dialogues[0];
        dialogueBoxSpr.set(dialogueData.dialogueBox);
        add(dialogueBoxSpr);
        dialogueBoxSpr.animation.play("normalOpen");
        text = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.7), "", 32);
		text.font = 'Pixel Arial 11 Bold';
		text.color = 0xFF3F2021;
		add(text);
        add(portrait);
        setDialogue();
        forEach(function (spr)
            {
                spr.alpha -= Math.PI * 60;
            });
 
    }

    private var hasNormal:Bool = false;
    override function update(elapsed:Float):Void
    {
        super.update(elapsed);  
        if (!isEnd)
        {
        forEach(function (spr)
            {
                spr.alpha += 1 * elapsed;
                
            });
        }
        if (dialogueBoxSpr.animation.curAnim.finished && !hasNormal)
            {
                hasNormal = true;
                dialogueBoxSpr.animation.play("normal");
            }
        if (FlxG.keys.justPressed.ANY && !isEnd)
            {
                dialogueData.dialogues.remove(dialogue);
                setDialogue();
            }
        isEnd =  dialogueData.dialogues.length < 1;
        if (isEnd)
        {
            forEach(function (spr)
            {
                spr.alpha -= 1 * elapsed;
                FlxG.watch.addQuick("Tilin opacidad", spr.alpha);
            });
            if (text.alpha <= 0)
                {
                    trace("OH NO TILIN MALO");
                    if (onComplete != null)
                        onComplete();
                    destroy();
                }
        }
    

    }
    private var theNextIsEnd:Bool = false;
    private var isEnd:Bool = false;
    public function setDialogue():Void
    {
        dialogue = dialogueData.dialogues[0];
        if (dialogue == null){
            isEnd = true;
            return;
        }
        text.resetText(dialogue.text);
		text.start(dialogue.velocity * 0.04, true);


		text.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];

        theNextIsEnd = dialogueData.dialogues.length < 2 && dialogueData.dialogues.length > 1;
        
        portrait.set(dialogue.char);
        portrait.setPosition(dialogue.position[0],dialogue.position[1]);
        portrait.playAnim(dialogue.anim);
        portrait.updateHitbox();
 
    }
}
class Portrait extends FlxSprite
{
    public function new()
    {
        super();
    }
    private var offsets:Map<String,Array<Float>> = [];
    private var char:String;
    public var snd:String;
    public function set(char:String)
    {
        if (!Paths.exists('data/dialogue/portraits/$char.json'))
        {
            var json:PortraitData = cast haxe.Json.parse(Assets.getText(Paths.json('dialogue/portraits/$char')));
            
            this.char = char;
            this.snd = json.sound;
            if (char != this.char)
            {
            frames = Paths.getSparrowAtlas("dialogue/" + json.img,"shared");
                for (anim in json.animation)
                {
                    offsets.set(anim.anim,[anim.offsets[0],anim.offsets[1]]);
                    animation.addByPrefix(anim.anim,anim.prefix,24,false);
                }
            }
            this.scale.set(json.scale,json.scale);
        }
    }
    public function playAnim(anim:String)
    {
        if (animation.exists(anim))
        {
            animation.play(anim,true);
            offset.set(offsets.get(anim)[0],offsets.get(anim)[1]);
        }
    }
}
class DialogueBoxSprite extends FlxSprite
{
    public function new()
    {
        super();
    }
    public function set(data:String)
    {
        if(!Paths.exists('data/dialogue/boxes/$data.json'))
            {
                frames = Paths.getSparrowAtlas("UI/speech_bubble_talking","shared");
                animation.addByPrefix("normalOpen","Speech Bubble Normal Open",24,false);
                animation.addByPrefix("normal","speech bubble normal",24,true);
                animation.addByPrefix("crazyOpen","speech bubble loud open",24,false);
                animation.addByPrefix("crazy","AHH speech bubble",24,true);
            }
    }
}
typedef PortraitData =
{
    var animation:Array<ProtraitAnim>;
    var img:String;
    var sound:String;
    var scale:Float;
}
typedef ProtraitAnim =
{
    var anim:String;
    var prefix:String;
    var offsets:Array<Float>;
}
typedef DialogueData =
{
    var dialogueBox:String;
    var music:String;
    var dialogues:Array<Dialogue>;
}
typedef Dialogue =
{
    var text:String;
    var position:Array<Float>;
    var char:String;
    var anim:String;
    var velocity:Float;
}