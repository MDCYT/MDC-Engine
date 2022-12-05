package;

import sys.FileSystem;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
// import FlxInputText;
// import flixel.addons.uiFlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;
import flixel.ui.FlxButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUITabMenu;
import openfl.utils.Assets;
import haxe.Json;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import Character._Anim;
import Character._Char;
import Character._Idle;

using StringTools;
class CharEditor extends MusicBeatState
{

    public var tempChar:_Char = null;
    public var character:String = "bf";

    public var char:Character = null;
    public var ghostChar:Character = null;

    private var bg:FlxSprite ;
    private var stageFront:FlxSprite ;
       
    private var tabs = [];
    public var curAnim:Int = 0;

    private var ui:FlxUITabMenu;

    private var tab_as:FlxUI;
    private var _char_name:FlxUIInputText;
    private var _posiblityImg:FlxUIDropDownMenu;
    private var _reloadB:FlxButton;
    private var _saveB:FlxButton;

    private var tab_an:FlxUI;
    private var _anim:FlxUIInputText;
    private var _pref:FlxUIInputText;
    private var _ind:FlxUIInputText;
    private  var _animationsVi:FlxUIDropDownMenu;
    private var _info:FlxText;
    private var _fps:FlxUINumericStepper ;
    private var _reloadadD:FlxButton;
    private var _removeD:FlxButton;
    private var _loop:FlxUICheckBox;

    private var tab_off:FlxUI;
    private var _scalex:FlxUINumericStepper ;
    private var _scaley:FlxUINumericStepper ;


    private var camPos:FlxObject = new FlxObject(1,1,1,1);
    var anInput= ["_char_name","_anim","_pref","_ind"];
    public override function create():Void
    {
        super.create();
        bg = new FlxSprite(-680,280).loadGraphic(Paths.image('stageback'));
        bg.setGraphicSize(Std.int(bg.width * 1.3));
        bg.updateHitbox();
        bg.antialiasing = PlayerSettings.antialiasing;
        stageFront = new FlxSprite(-680,280).loadGraphic(Paths.image('stagefront'));
        stageFront.setGraphicSize(Std.int(stageFront.width * 1.2));
        stageFront.updateHitbox();
        stageFront.antialiasing = PlayerSettings.antialiasing;

        add(bg);
        add(stageFront);
        sync(true,true);

        for (i in ["Animation","Assets","Offsets"])
            tabs.push({name:i,label:i});

		ui = new FlxUITabMenu(null, tabs, true);

		ui.resize(300, 400);
		ui.x = FlxG.width / 2;
		ui.y = 20;
		add(ui);
		ui.scrollFactor.set();

        _char_name = new FlxUIInputText(10, 10, 70, tempChar.image, 8);
        _reloadB= new FlxButton(10  + _char_name.x  + _char_name.width, 8, "Reload image", function()
        {
            tempChar.image = _char_name.text;
            trace(_char_name.text);


            sync(true,false);
        });

        _saveB= new FlxButton(10  + _reloadB.x + _reloadB.width, 8, "save data", function()
        {
            save();
        });
        _posiblityImg = new FlxUIDropDownMenu(_char_name.x,_char_name.y + _char_name.height + 20, FlxUIDropDownMenu.makeStrIdLabelArray(["XML","TXT"], true), function(character:String)
        {
        });
        tab_as = new FlxUI(null, ui);
		tab_as.name = "Assets";
		tab_as.add(_char_name);
		tab_as.add(_reloadB);
		tab_as.add(_saveB);
		tab_as.add(new FlxText(_char_name.x + _char_name.width + 10, _char_name.y,0,"Image"));

        
        _anim = new FlxUIInputText(10, 10, 150, tempChar.animations[curAnim].animation, 10);

        _pref = new FlxUIInputText(10, _anim.y + _anim.height + 10, 150, tempChar.animations[curAnim].prefix, 10);
        
        var rtr:Array<String> = [];
        for (i in tempChar.animations)
            rtr.push(i.animation);
        _animationsVi = new FlxUIDropDownMenu(_pref.x, _pref.y + _pref.height + 20, FlxUIDropDownMenu.makeStrIdLabelArray(rtr, true), function(character:String)
		{
			curAnim = Std.parseInt(character);
            reload_anims_han();
		});
        _ind = new FlxUIInputText(_animationsVi.x, _animationsVi.y + 40, 150, "", 10);

        _fps = new FlxUINumericStepper(_animationsVi.x + _animationsVi.width + 25, _animationsVi.y + 70, 0.1, 1, 0.1, 120, 1);
		_fps.value = tempChar.animations[curAnim].fps;
		
        _loop = new FlxUICheckBox(10, _animationsVi.y + _pref.width + 16, null, null, "Loop Anim", 100);
		_loop.checked = tempChar.animations[curAnim].loop;
        

	
        _reloadadD = new FlxButton(_anim.x + _anim.width + 60,_anim.y, "Reload/Add", addAnAnimation);
        _removeD = new FlxButton(_anim.x + _anim.width + 60,_reloadadD.y + _reloadadD.height  + 20 , "Remove", function(){            
            tempChar.animations.remove(tempChar.animations[curAnim]);
            curAnim = 0;
            if (tempChar.animations.length  < 1)
                tempChar.animations.push({animation: "idle",prefix:"BF IDLE DANCE",isIndices: false, indices: [], fps: 24, loop: false, offsets: [0,0]});
        });
        trace("i hate FlxUi");

        tab_an = new FlxUI(null, ui);
		tab_an.name = "Animation";
     
        tab_an.add(_ind);
        tab_an.add(_anim);        tab_an.add(_pref);
        tab_an.add(_fps);
        tab_an.add(_reloadadD);
        tab_an.add(_removeD);
        tab_an.add(_animationsVi);
        tab_an.add(_loop);

        tab_an.add(new FlxText(_anim.x + _anim.width + 10,_anim.y,"Animation Name"));
        tab_an.add(new FlxText(_pref.x + _pref.width + 10,_pref.y,"Animation Prefix"));
        tab_an.add(new FlxText(_fps.x + _fps.width + 10,_fps.y,"FPS"));
        tab_an.add(new FlxText(_ind.x + _ind.width + 5,_ind.y, "Indices"));

        tab_off = new FlxUI(null,ui);
        tab_an.name = "Offsets";
        if (tempChar.scale == null)
            tempChar.scale = [1,1];
        _scalex  = new FlxUINumericStepper(10,10, 0.1, 1, 0.01, 60, 1);
		_scalex.value = tempChar.scale[0];
        _scaley  = new FlxUINumericStepper(10,10 + _scalex.height + 20, 0.1, 1, 0.01, 60, 1);
		_scalex.value = tempChar.scale[1];
        
        tab_off.add(_scalex);
        tab_off.add(_scaley);
		_scaley.value = tempChar.scale[1];
        addTextUI(tab_off,_scalex,"Scale x");
        addTextUI(tab_off,_scaley,"Scale y");
        ui.addGroup(tab_as);
        ui.addGroup(tab_an);
        ui.addGroup(tab_off);
        

        _info = new FlxText(40,70,0,"CurAnim: null\noffset.x ?\n offset.y ?");
        _info.alignment = LEFT;
        add(_info);

        if (char != null)
            char.setPosition(100,100);
        if (Reflect.getProperty(tempChar,"addPos") == null)
            tempChar.addPos = [0,0];
        char.x += tempChar.addPos[0];
        char.y += tempChar.addPos[0];
        camPos.screenCenter();
        FlxG.camera.follow(camPos);
    }
    public function addTextUI(tab:FlxUI,the_tab:Dynamic,str:String)
         tab.add(new FlxText(the_tab.x + the_tab.width,the_tab.y + 10,0,str));
    

    var idleTime:Float = 0;
    function check_and_correction_indices():Array<Int>
        {
            var indices:Array<Int> = [];
            var ind = _ind.text.split("");
            var num:String = "0123456789";
            for (i in ind)
                if (num.indexOf(i) != -1)
                    indices.push(Std.parseInt(i));
            var indicesText:String = "";
            for (i in indices)
                indicesText += i + ", ";
                
            _ind.text = indicesText;
            return indices;
        }
    function is_number_pressed():Bool{
        var names:Array<String> = ["ONE","TWO","THREE","FOUR","FIVE","SIX","EIGHT","NINE","COMMA"];
        var yes:Array<String> = [];

        for (i in names){

            if (!(Reflect.getProperty(FlxG.keys.pressed,i)))
                yes.push("yes");
        }
        return  (yes.length == names.length);
    }
    function a(){
        var yes:Array<flixel.addons.ui.FlxUIInputText> = [_char_name,_ind,_anim,_pref];
        var yes3:Array<String> = [];
        if (!_char_name.hasFocus)
            yes3.push("yes");
        if (!_ind.hasFocus)
            yes3.push("yes");
        if (!_anim.hasFocus)
            yes3.push("yes");
        if (!_pref.hasFocus)
            yes3.push("yes");
        FlxG.watch.addQuick("_cn",_char_name.hasFocus);
        FlxG.watch.addQuick("_ind",_ind.hasFocus);
        FlxG.watch.addQuick("_anim",_anim.hasFocus);
        FlxG.watch.addQuick("_pref",_pref.hasFocus);
        return (yes3.length == yes.length);
    }
    override function update(elapsed:Float):Void
    {
        FlxG.watch.addQuick("e",a());
     super.update(elapsed);

        if (a()){
            
        if (FlxG.keys.pressed.I)
            camPos.y -= 10;
        else if (FlxG.keys.pressed.K)
            camPos.y += 10;

        if (FlxG.keys.pressed.J)
            camPos.x -= 10;
        else if (FlxG.keys.pressed.L)
            camPos.x += 10;

        if (FlxG.keys.justPressed.U)
            FlxG.camera.zoom += 0.1;
        if (FlxG.keys.justPressed.O)
            FlxG.camera.zoom -= 0.1;
        idleTime += FlxG.elapsed;
        if (FlxG.keys.pressed.ANY && (is_number_pressed()))
            check_and_correction_indices();
        
    if ((idleTime >= 1.5 || FlxG.keys.justPressed.SPACE) && char.animation.curAnim != null)
        {  
            if (char.animation.curAnim.name == tempChar.animations[curAnim].animation)
                idleTime = 0;
            char.playAnim(tempChar.animations[curAnim].animation,FlxG.keys.justPressed.SPACE);
            ghostChar.playAnim("idle",true);

        }

     var multiplier = 1;
     if (FlxG.keys.pressed.SHIFT)
         multiplier = 10;
     if (FlxG.keys.pressed.CONTROL)
         multiplier = 25;


     var oldAnim = curAnim;
     if (FlxG.keys.justPressed.W)
        curAnim += 1;
     if (FlxG.keys.justPressed.S)
        curAnim -= 1;
     if (curAnim >= tempChar.animations.length)
        curAnim = 0;
     if (curAnim < 0)
        curAnim = tempChar.animations.length - 1;
     if (oldAnim != curAnim)
        {
            reload_anims_han();  
            changeAnim();      
        }
      
    if (FlxG.keys.justPressed.UP)
        char.animOffsets.get(tempChar.animations[curAnim].animation)[1] += 1 * multiplier;
    if (FlxG.keys.justPressed.DOWN)
        char.animOffsets.get(tempChar.animations[curAnim].animation)[1] -= 1 * multiplier;
    if (FlxG.keys.justPressed.LEFT)
        char.animOffsets.get(tempChar.animations[curAnim].animation)[0] += 1 * multiplier;
    if (FlxG.keys.justPressed.RIGHT)
        char.animOffsets.get(tempChar.animations[curAnim].animation)[0] -= 1 * multiplier;
    }
    tempChar.animations[curAnim].offsets = char.animOffsets.get(tempChar.animations[curAnim].animation);
    char.offset.x = char.animOffsets.get(tempChar.animations[curAnim].animation)[0];
    char.offset.y = char.animOffsets.get(tempChar.animations[curAnim].animation)[1];
    
    var toLo = "";
    for (i in tempChar.animations)
        toLo += '${i.animation}  ${i.offsets}\n"';
    _info.text = tempChar.animations[curAnim].animation + " anim  [" + tempChar.animations[curAnim].offsets[0] + ", " + tempChar.animations[curAnim].offsets[1] + "]\n\n\n" + toLo;
    ghostChar.setPosition(char.x,char.y);
    ghostChar.alpha = 0.5;    
}
    public function reload_anims_han()
    {
        var rtr:Array<String> = [];
        for (i in tempChar.animations)
            rtr.push(i.animation);
        var characters:Array<String> = rtr;
        _animationsVi.setData(FlxUIDropDownMenu.makeStrIdLabelArray(characters, true));
    }
    var isLeft:Bool = false;
    function changeAnim()
    {
        char.playAnim(tempChar.animations[curAnim].animation,true);
        ghostChar.playAnim("idle",true);


        var daAnim = tempChar.animations[curAnim];
        _char_name.text = tempChar.image;

        _animationsVi.selectedLabel = daAnim.animation;
        _anim.text = daAnim.animation;
        _pref.text = daAnim.prefix;
        _fps.value = daAnim.fps;
        _loop.checked = daAnim.loop; 
    }
    function addAnAnimation():Void
    {
        if (char.animation.getByName(_anim.text) != null){
            char.animation.remove(_anim.text);
            ghostChar.animation.remove(_anim.text);
        }
        if (tempChar.animations[curAnim].indices ==  null)
            tempChar.animations[curAnim].indices = [];
        
            var indices = check_and_correction_indices();
            var newerAnim:_Anim = 
            {
                animation: _anim.text,
                prefix: _pref.text,
                isIndices: (indices.length > 1),
                indices: indices,
                fps: _fps.value,
                loop:  _loop.checked,
                offsets: [char.offset.x,char.offset.y],
            };
            for (i in 0...tempChar.animations.length)
            {
                if (tempChar.animations[i].animation == _anim.text)
                    {
                        tempChar.animations[i] = newerAnim;
                        sync(false);
                        trace("Updating an animation " + _anim.text);
                        trace("data");
                        trace(newerAnim);
                    }
                if (i >= tempChar.animations.length - 1)
                    {
                        trace("Added an animation " + _anim.text);
                        trace("data");
                        trace(newerAnim);
                        tempChar.animations.push(newerAnim);   

                    }
            }
        
           
        var anim = newerAnim;
        
        if (anim.indices == null){
            anim.indices = [];
            anim.isIndices = anim.indices.length > 1;
        }
        if (anim.isIndices || anim.indices.length > 1){
            char.animation.addByIndices(anim.animation, anim.prefix, anim.indices, "", Math.floor(anim.fps), anim.loop);
            ghostChar.animation.addByIndices(anim.animation, anim.prefix, anim.indices, "", Math.floor(anim.fps), anim.loop);
        } else{
            char.animation.addByPrefix(anim.animation, anim.prefix,  Math.floor(anim.fps), anim.loop);
            ghostChar.animation.addByPrefix(anim.animation, anim.prefix,  Math.floor(anim.fps), anim.loop);
        }
        for (e in 0...3)
            if (anim.offsets[e] == null)
                anim.offsets[e] = 0;
        char.addOffset(anim.animation,anim.offsets[0],anim.offsets[1]);
        ghostChar.addOffset(anim.animation,anim.offsets[0],anim.offsets[1]);
        ghostChar.playAnim("idle",true);
    }
    function sync(?updateChar:Bool = false, ?changeFile:Bool = false)
    {
        if (changeFile)
        {
            tempChar = {
                icon:"bf",
                addPos: [0,0],
                addCameraPos: [0,0],
                isPlayer: false,
                animation_death: "death",
                color: [0,0,0],
                image: "BOYFRIEND",
                animations: [],
                animHey: "HEY",
                fearAnim: "scared",
                idle: {
                    is_left_right: false,
                    left_anim: "",
                    right_anim: "",
                    idle_anim: "idle",
                },
                scale:[1,1],
                flip:[false,false],
            }
        
            if (FileSystem.exists(Paths.data("chars/" + character + ".json"))){
                var rawJson = Assets.getText(Paths.data("chars/" + character + ".json")).trim();
                tempChar = Json.parse(rawJson);

            }
        }
      
        if (tempChar.animations.length < 1)
            {
                tempChar.animations.push({animation: "idle",prefix:"BF IDLE DANCE",isIndices: false, indices: [], fps: 24, loop: false, offsets: [0,0]});
            }
        if (char == null || updateChar)
            {
                if (char != null){
                char.kill();
                char.destroy();
                ghostChar.kill();
                ghostChar.destroy();
                }
                char = new Character(0,0,character,false,true);
                ghostChar = new Character(0,0,character,false,true);

                add(ghostChar);
                add(char);
                ghostChar.frames = Paths.getChar(tempChar.image);
                char.frames = Paths.getChar(tempChar.image);
            }

            var rawChar = tempChar;
            
				for (i in 0...rawChar.animations.length)
				{
					var anim = rawChar.animations[i];
                    if (char.animation.getByName(anim.animation) != null)
                        char.animation.remove(anim.animation);

                    if (anim.indices == null)
                        anim.indices = [];
                    anim.isIndices = anim.indices.length > 1;
					if (anim.isIndices || anim.indices.length > 1)
						char.animation.addByIndices(anim.animation, anim.prefix, anim.indices, "", Math.floor(anim.fps), anim.loop);
					else
						char.animation.addByPrefix(anim.animation, anim.prefix,  Math.floor(anim.fps), anim.loop);
					for (e in 0...3)
						if (anim.offsets[e] == null)
							anim.offsets[e] = 0;
					char.addOffset(anim.animation,anim.offsets[0],anim.offsets[1]);
				}
                ghostChar.animation.copyFrom(char.animation);
                if (tempChar.idle.is_left_right)
                {
                    char.playAnim(tempChar.idle.left_anim);
                    isLeft = false;
                } 
                else
                {
                    char.playAnim(tempChar.idle.idle_anim);
                }
            
    }
    var _file:FileReference;
    private function save()
        {
            var json = tempChar;
            var al = ["SwagChar","im a char", "change me!", "hi", "you are saving me after 290310 years!"];
    
            var data:String = Json.stringify(json,null, " ");
    
            if ((data != null) && (data.length > 0))
            {
                _file = new FileReference();
                _file.addEventListener(Event.COMPLETE, onSaveComplete);
                _file.addEventListener(Event.CANCEL, onSaveCancel);
                _file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
                _file.save(data.trim(), al[FlxG.random.int(0,al.length - 1)]+ ".json");
            }
        }
    
        function onSaveComplete(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
            FlxG.log.notice("Successfully saved LEVEL DATA.");
        }
    
        /**
         * Called when the save file dialog is cancelled.
         */
        function onSaveCancel(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
        }
    
        /**
         * Called if there is an error while saving the gameplay recording.
         */
        function onSaveError(_):Void
        {
            _file.removeEventListener(Event.COMPLETE, onSaveComplete);
            _file.removeEventListener(Event.CANCEL, onSaveCancel);
            _file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
            _file = null;
            FlxG.log.error("Problem saving Level data");
        }
    
}