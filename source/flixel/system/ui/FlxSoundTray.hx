package flixel.system.ui;

import flixel.tweens.FlxTween;
#if FLX_SOUND_SYSTEM
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.util.FlxColor;
#if flash
import flash.text.AntiAliasType;
import flash.text.GridFitType;
#end

/**
 * The flixel sound tray, the little volume meter that pops down sometimes.
 */
class FlxSoundTray extends Sprite
{
	/**
	 * Because reading any data from DisplayObject is insanely expensive in hxcpp, keep track of whether we need to update it or not.
	 */
	public var active:Bool;


	/**
	 * Helps display the volume bars on the sound tray.
	 */
	var _bars:Array<Bitmap>;

	/**
	 * How wide the sound tray background is.
	 */
	var _width:Int = 100;

	var _defaultScale:Float = 2.0;
    var text:TextField;
	/**
	 * Sets up the "sound tray", the little volume meter that pops down sometimes.
	 */
	@:keep
	public function new()
	{
		super();

		visible = false;
		scaleX = _defaultScale;
		scaleY = _defaultScale;
		var tmp:Bitmap = new Bitmap(new BitmapData(_width, 30, true, 0x7F000000));
		screenCenter();
		addChild(tmp);

        text = new TextField();
		text.width = tmp.width;
		text.height = tmp.height;
		text.multiline = true;
		text.wordWrap = true;
		text.selectable = false;

		#if flash
		text.embedFonts = true;
		text.antiAliasType = AntiAliasType.NORMAL;
		text.gridFitType = GridFitType.PIXEL;
		#else
		#end
		var dtf:TextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, 10, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		text.defaultTextFormat = dtf;
		addChild(text);
		text.text = "Volume";
		text.y = 16;

		var bx:Int = 10;
		var by:Int = 14;
		_bars = new Array();

		for (i in 0...10)
		{
			tmp = new Bitmap(new BitmapData(4, Math.floor((i + 1) ), false, FlxColor.WHITE));
			tmp.x = bx;
			tmp.y = by;
            tmp.x += _width / 2;
            // COMO CUANDO ESCRIN CENTER
			addChild(tmp);
			_bars.push(tmp);
			bx += 6;
			by --;
		}

		y = -height;
		visible = false;
	}

    private var _timetoleave:Float = 0;
    private var _appear:Bool = false;
	/**
	 * This function just updates the soundtray object.
	 */
	public function update(MS:Float):Void
	{
        // callese flixel.
        if ((lastTween != null && lastTween.finished) && _appear)
            _timetoleave -= MS / 1000;
        if (_timetoleave <= 0)
        {
            _timetoleave = 0;
            if (_appear) lastTweenOncomplete = FlxTween.tween(this, {"y": -height}, 0.65, {onComplete:onDisappear});

        }
	}


    private function onDisappear(twn:FlxTween):Void
    {
        if (_timetoleave > 0){
            y = 0;
            return;
        }
        visible = active = false;
        CoolUtil.cancelTween(lastTweenOncomplete);

        y = -height;
        // Save sound preferences
        lastTweenOncomplete = null;
        FlxG.save.data.mute = FlxG.sound.muted;
        FlxG.save.data.volume = FlxG.sound.volume;
        FlxG.save.flush();
        _appear = false;
    }
    private var lastTween:FlxTween;
    private var lastTweenOncomplete:FlxTween;
	/**
	 * Makes the little volume tray slide out.
	 *
	 * @param	Silent	Whether or not it should beep.
	 */
	public function show(Silent:Bool = false):Void
	{
        if (lastTweenOncomplete == null || !lastTweenOncomplete.finished)
            y = 0;
        CoolUtil.cancelTween(lastTweenOncomplete);
        CoolUtil.cancelTween(lastTween);
      
        _appear = true;
		if (!Silent)
		{
			var sound = FlxAssets.getSound("flixel/sounds/beep");
			if (sound != null)
				FlxG.sound.load(sound).play();
		}
        var div:Float = 1;
        if (lastTween != null && !lastTween.finished){
            CoolUtil.cancelTween(lastTween);
            div = 2;
        } 
        lastTween = FlxTween.tween(this, {"y": 0}, 0.5 / div);

        _timetoleave = 1.25;

		visible = active = true;
		var globalVolume:Int = Math.round(FlxG.sound.volume * 10);

		if (FlxG.sound.muted)
			globalVolume = 0;

		for (i in 0..._bars.length)
			_bars[i].alpha = i < globalVolume ? 1 : 0.5;

        // SHOW VOLUME !??!?!?!?!??!??!?!?!??!.
		text.text = "Volume: " + (FlxG.sound.muted ? "muted." : Std.string(globalVolume));

	}

	public function screenCenter():Void
	{
		scaleX = _defaultScale;
		scaleY = _defaultScale;

		x = (0.5 * (Lib.current.stage.stageWidth - _width * _defaultScale) - FlxG.game.x);
	}
}
#end
