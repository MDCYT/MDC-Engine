package;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;

class DebugMenuState extends MusicBeatState
{
    public var options:Array<String> = ["CharEditor","ChartEditor","WeekEditor"];
    public var ver:String = "MDC engine v" + MainMenuState.engineVer + "\nFNF v" + MainMenuState.gameVer + "\n" + FlxG.VERSION + "\n";

    private var curSelected:Int = 0;
    private var items:FlxTypedGroup<Alphabet>;

    override function create():Void
    {
        var bg = new FlxSprite().loadGraphic("menuDesat","preload");
        add(bg);
        bg.color = FlxColor.GRAY;
        items = new FlxTypedGroup<Alphabet>();
        add(items);
        for (i in 0...options.length)
        {
            var item:Alphabet = new Alphabet(0, (70 * i) + 30,options[i], true, false);
            item.isMenuItem = true;
            item.targetY = i;
            items.add(item);
        }
        var info = new FlxText(0,FlxG.height - (18 * 3),0,ver);
        info.alignment = LEFT;
        add(info);
        super.create();
    }
    public override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (controls.UP_P)
            curSelected -= 1;
        if (controls.DOWN_P)
            curSelected += 1;
        if (curSelected >= options.length)
            curSelected = 0;
        if (curSelected <= -1)
            curSelected = options.length - 1;
      
        if (controls.ACCEPT)
            {
                switch(options[curSelected].toLowerCase())
                {
                    case "chareditor": FlxG.switchState(new CharEditor());
                    case "charteditor": FlxG.switchState(new ChartingState());
                    default: trace(options[curSelected] + " doesn't bind");
                }                
            }
    }
}