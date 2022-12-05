package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
typedef Credits = Array<Array<Dynamic>>;
class CreditsState extends MusicBeatState
{
    public var credits:Credits = [
        ["MDC ENGINE CREDITS"],
        ["MDCYT","mdc","Creator, original programmer","https://www.youtube.com/c/mdcpe"],
        ["MrNiz","niz","Main programmer co-creator (según ams)","https://www.youtube.com/@MrNiz"],
        ["AmsDev","ams","Extra programmer","not founded"],
        ["Manux","muanx","nose"],
        ["AssmanBruh","asma","Main artist/animator"],
        [""],
        ["SPECIAL THANKS"],
        ["Jacko","tupapiprogramadordejsyfnf","Eso tilin"],
        [""],
        ["FNF ORIGINAL TEAM"],
        ["Ninjamuffin99","bf","Original creator and programmer"],
        [""],

        // ["no recuerdo"]
    ];
    private var txtGrp:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();
    private var iconGrp:FlxTypedGroup<HealthIcon> = new FlxTypedGroup<HealthIcon>();
    private var curSelected:Int = 0;
    public 
    var
    bg
    :
    FlxSprite
    ;
    public override function create():Void

    {
        super.create();

        bg = new FlxSprite().loadGraphic(Paths.image("menuDesat","preload"));
        add(bg);
        add(txtGrp);
        add(iconGrp);
        for (i in 0...credits.length)
            {
                var txt:Alphabet = new Alphabet(0, (70 * i) + 30, credits[i][0], !checkSexc(i), false);
                txt.isMenuItem = true;
                txt.targetY = i;
                txtGrp.add(txt);

                var icon = new HealthIcon("credits/" + credits[i][1],false,false,!(i <= 9));
                icon.sprTracker = txt;
                icon.ID = i;
                icon.setGraphicSize(150);
                icon.updateHitbox();
                iconGrp.add(icon);
            } 
            if (curAlphabet == ""){
                curSelected += it;
        if (curSelected >= txtGrp.members.length)
            curSelected = 0;
        if (curSelected <= -1)
            curSelected = txtGrp.members.length - 1;
            }
        section(1);
    }
    var it:Int = 0;
    var curAlphabet:String = "";
    public function section(it:Int){
        curSelected += it;
        if (curSelected >= txtGrp.members.length)
            curSelected = 0;
        if (curSelected <= -1)
            curSelected = txtGrp.members.length - 1;

        this.it = it;
        var bullShit:Int = 0;
        for (icon in iconGrp.members)
            {
                icon.alpha = 0.6;
                if (icon.ID == curSelected)
                    icon.alpha = 1;

            }

		for (item in txtGrp.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0 || item.isBold)
			{
				item.alpha = 1;
                curAlphabet = item.text;
			}
		}
    }
    public override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (controls.UP_P)
            section(-1);
        if (controls.DOWN_P)
            section(1);
  
    }
    function checkSexc(itn:Int):Bool
        return (credits[itn].length > 2);
}