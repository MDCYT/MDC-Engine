package;

import Controls;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxSignal;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepadInputID;

// import ui.DeviceManager;
// import props.Player;
class PlayerSettings
{

	private static var map:Map<String,Dynamic> = [];
    public static var downscroll:Bool = false;
    public static var botplay:Bool = true;
    public static var ghosttapin:Bool = true;
    public static var pressCauseMiss:Bool = false;
    public static var sustainPressDependToFather:Bool = true;

    public static var safeFrames:Int = 10;
    public static var offset:Int = 0; // IN MS
    public static var pitch:Float = 1; // Default pitch on songs; redo later
	public static var offsetMiss:Float = 360;

	public static var FPS:Int = 60;
	public static var showFPS:Bool = false;
	public static var badQuality:Bool = true;
	public static var antialiasing:Bool = false;
	public static var showOpponentArrows:Bool = true;

    public static var keybinds:Map<String,Array<FlxKey>> =
    [
        "left"=> [LEFT,A],
        "down"=> [DOWN,S],
        "up"=> [UP,W],
        "right"=> [RIGHT,D],

        "ui-left"=> [LEFT,A],
        "ui-down"=> [DOWN,S],
        "ui-up"=> [UP,W],
        "ui-right"=> [RIGHT,D],
        
        "accept"=> [ENTER],
        "cancel"=> [ESCAPE,BACKSPACE],
        "reset"=> [R],

        "null"=> [Q],
    ];
 
    public static var keybinds_control:Map<String,Array<FlxGamepadInputID>> =
    [
        "left"=> [X],
        "down"=> [A],
        "up"=> [Y],
        "right"=> [B],

        "ui-left"=> [DPAD_LEFT],
        "ui-down"=> [DPAD_DOWN],
        "ui-up"=> [DPAD_UP],
        "ui-right"=> [DPAD_RIGHT],
        
        "accept"=> [START,A],
        "cancel"=> [B],
        "reset"=> [],

    ];

	static public var numPlayers(default, null) = 0;
	static public var numAvatars(default, null) = 0;
	static public var player1(default, null):PlayerSettings;
	static public var player2(default, null):PlayerSettings;


	#if (haxe >= "4.0.0")
	static public final onAvatarAdd = new FlxTypedSignal<PlayerSettings->Void>();
	static public final onAvatarRemove = new FlxTypedSignal<PlayerSettings->Void>();
	#else
	static public var onAvatarAdd = new FlxTypedSignal<PlayerSettings->Void>();
	static public var onAvatarRemove = new FlxTypedSignal<PlayerSettings->Void>();
	#end

	public var id(default, null):Int;

	#if (haxe >= "4.0.0")
	public final controls:Controls;
	#else
	public var controls:Controls;
	#end
	// public final settings:Settings;

	// public var avatar:Player;
	// public var camera(get, never):PlayCamera;

	function new(id, scheme)
	{
		this.id = id;
		this.controls = new Controls('player$id', scheme);
	}

	public function setKeyboardScheme(scheme)
	{
		controls.setKeyboardScheme(scheme);
	}


	static public function init():Void
	{
		map = new Map();
        if (FlxG.save.data.config != null)
            map = FlxG.save.data.config;
        else 
            save();

		if (player1 == null)
		{
			player1 = new PlayerSettings(0, Solo);
			++numPlayers;
		}

		var numGamepads = FlxG.gamepads.numActiveGamepads;
		if (numGamepads > 0)
		{
			var gamepad = FlxG.gamepads.getByID(0);
			if (gamepad == null)
				throw 'Unexpected null gamepad. id:0';

			player1.controls.addDefaultGamepad(0);
		}

		if (numGamepads > 1)
		{
			if (player2 == null)
			{
				player2 = new PlayerSettings(1, None);
				++numPlayers;
			}

			var gamepad = FlxG.gamepads.getByID(1);
			if (gamepad == null)
				throw 'Unexpected null gamepad. id:0';

			player2.controls.addDefaultGamepad(1);
		}

	}

	static public function reset()
	{
		player1 = null;
		player2 = null;
		numPlayers = 0;
	}

	public static function getAndCheckIfNull(data:String,?value:Dynamic):Dynamic
		{
			if (map.get(data) == null)
				map.set(data,value);
			else
				value = map.get(data);
			return value;
		}
		public static function save()
		{
			map.set("downscroll",downscroll);
			map.set("botplay",botplay);
			map.set("ghosttapin",ghosttapin);
			map.set("pressCauseMiss",pressCauseMiss);
			map.set("offset",offset);
			map.set("pitch",pitch);
			FlxG.save.data.config = map;
			FlxG.save.flush();
	
		}
}

