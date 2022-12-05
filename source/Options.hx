package;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;

using StringTools;
class Option extends FlxTypedSpriteGroup<Alphabet>
{
	public var alphabet:Alphabet = null;

	public var displayName:String = "Test: %value%";
	public var type:String = "string";
	public var possibleTypes:Array<String> = [];
	
	public var onClickCallBack:(curSelected:Int, has:String)->Void = null;

	public var min:Int = 30;
	public var max:Int = 360;

	public var value:String = "";

	public var curValue:Int = 0;
	public var valueBool:Bool = true;
	public var velocityAdd:Int = 10;

	public var data:String = "";
	public function new(name:String, type:String, info:Dynamic, onClickEvent:(curSelected:Int, has:String)->Void,id:Int,data:String)
	{
		super();
		// Auto correction
		if (name.indexOf("%value%") == -1 && type != "classstring") name += (" - %value%");

		displayName = name;
		this.data = data;
		this.type = type;
		switch(type)
		{
			case "array","string": 
				value = Std.string(possibleTypes[0]);
			case "bool":
				valueBool = info;
				value = Std.string(valueBool);
			case "int":
				curValue = info;
				value = Std.string(curValue);
		}
		
		changeAlphabet();

		this.ID = id;
		onClickCallBack = onClickEvent;

	}
	public function changeAlphabet()
	{
		if (alphabet != null)
		{
			alphabet.kill();
			alphabet.destroy();
		}

		alphabet = new Alphabet(0, 0, displayName.replace("%value%",value), true, false);
		alphabet.isMenuItem = true;
		alphabet.targetY = ID;
		alphabet.update(0);
		add(alphabet);
	}
	public function getAlphabet():Alphabet
		return alphabet;
	public function click(curSelected:Int = 0,has:String = ""):Void
	{
		var is_to_down:Bool = has == "down";
		switch(type)
		{
			case "array","string": 
				curValue += 1;
				if (curValue >= possibleTypes.length)
					curValue = 0;
				Reflect.setProperty(PlayerSettings,data,value);

				value = Std.string(possibleTypes[curValue]);
			case "bool":
				valueBool = !valueBool;
				Reflect.setProperty(PlayerSettings,data,valueBool);
				value = Std.string(valueBool);
			case "int":
				curValue +=( is_to_down ? -velocityAdd : velocityAdd);
				if (curValue >= max) curValue = max;
				if (curValue >= min) curValue = min;
				value = Std.string(curValue);
				Reflect.setProperty(PlayerSettings,data,curValue);

			default:
				// because click event return;
				
		}
		changeAlphabet();
		if (onClickCallBack != null) onClickCallBack(curSelected, has);
	}
}
class Options extends MusicBeatState
{
	public var options:Array<Option> = [];
	public var possibleOptions:Array<Array<Array<String>>> = [
		[
			["Antialiasing","description","bool","antialiasing"],
			["Fps value","description","int","FPS"],
		],
		[
			[],
		]
	];
	public override function create():Void
	{
		super.create();
		for (i in 0...possibleOptions[0].length)
			{
				trace(possibleOptions[0][i]);
			}
	}
}
