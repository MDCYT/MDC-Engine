package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.text.FlxText;
class Result extends MusicBeatState
{
    private var acc:Float = 0.00;
    private var notesHitted:Map<String,Float>;
    private var replayData:Dynamic;
    public function new(acc:Float,notesHitted:Map<String,Float>,replayData:Replay)
    {
        super();
        this.notesHitted = notesHitted;
        this.acc = acc;
        this.replayData = replayData;
    }
    var accShit:FlxTypedGroup<FlxSprite>;
    var bg:FlxSprite;
    var bgColors:Array<Int> =
    [
        0xFFcd2701,
        0xFFff7654,
        0xFF9ae7c5,
        0xFF44d091,
        0xFF44d091,
        0xFF220187,
        0xFF002c8b,
        0xFF027ebc,
        0xFFff6201,
        0xFFfeba29,
        0xFFcbe927
    ]
    ;
    var a:Array<Array<Dynamic>> = [];
    public override function create()
    {

        super.create();
        bg = new FlxSprite().loadGraphic(Paths.image("menuDesat"));
        bg.scale.set(1.35,1.35);
        bg.updateHitbox();
        bg.screenCenter();
        bg.antialiasing = PlayerSettings.antialiasing;
        bg.angle = 12;
        add(bg);
    
        accShit = new FlxTypedGroup<FlxSprite>();
        add(accShit);
        for (i in 0...2)
            {
                var esoTilin = new FlxSprite().makeGraphic(3000,500,FlxColor.BLACK);
                esoTilin.alpha = 0.9;
                esoTilin.angle = 5 + (i == 1 ? 2.25 : 0 );
                var pos:Array<{x:Float,y:Float}> =[{x:-40,y:710},{x:0,y:-300}];
                esoTilin.x = pos[i].x;
                esoTilin.y = pos[i].y;
                add(esoTilin);
            }
            var coolText = new FlxText(0, FlxG.height - 120,0, 'To save press F6\nTo replay press F12 (BETA)\nTo exit press ESC/Enter\n');
            coolText.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.BLACK, LEFT);
            coolText.setBorderStyle(OUTLINE,FlxColor.WHITE,4,5);
            add(coolText);
        for (i in 0..."100000000000".length)
                accShit.add(new FlxSprite());
            onFiv = FlxG.sound.load(Paths.sound("confirmMenu"));
        var ele = ["sick","good","bad","shit"];
        for (reting in 0...ele.length)
            {
                a[reting] = [];
                var opo = new FlxSprite(reting < 2 ? 0 : 250, ((reting % 2)  * 150) + 250).loadGraphic(Paths.image('UI/' + ele[reting],"shared"));
                opo.scale.set(0.5,0.5);
                opo.updateHitbox();
                opo.visible = false;
                add(opo);
                var epe = new FlxText(0, opo.y + opo.height, 0, '${notesHitted.get(ele[reting])}');
                epe.setFormat(Paths.font("vcr.ttf"), 35, FlxColor.WHITE, CENTER);
                epe.setBorderStyle(OUTLINE,FlxColor.BLACK,4,5);
                epe.x = opo.x  + opo.width / 2;
                epe.visible = false;
                add(epe);
                a[reting].push(opo);
                a[reting].push(epe);

            }
            FlxG.setGlobalSpeed(1);
            // SORRY FOR THIS SHIT
            FlxG.setGlobalSpeed(1, false);

            dat ='{"data": \n${haxe.Json.stringify(replayData, null, " ")},\n"song": "${PlayState.SONG.song}",\n"date": "${Date.now().toString()}"}';
            trace(Date.now().toString() + ' - cur date');
            Replay.ReplayParser.autoSave(PlayState.SONG.song,dat);
    }
    var disAcc:Float = 0.00;
    var onFiv:FlxSound;
    var can:Bool = false;
    var w:Float = 0;
    var e:Bool = false;
    var olo:Bool = false;
    var dat:String = "";
    var pitch:Float = 0.1; // INIT PITCH
    public override function update(elapsed:Float)
    {
        super.update(elapsed);
        if (FlxG.keys.justPressed.F12)
            {
                PlayState.setReplay = true;
                FlxG.switchState(new PlayState(replayData));
                FlxG.setGlobalSpeed(1);
                
            }
        if (FlxG.keys.justPressed.F6)
            {
                Save.save(dat,"Replay.json");
            }
        if (FlxG.keys.anyJustPressed([ENTER,ESCAPE,BACKSPACE]))
            {
                FlxG.setGlobalSpeed(1);
                FlxG.switchState(new FreeplayState());
            }
        FlxG.camera.zoom = FlxMath.lerp(1,FlxG.camera.zoom, 1 - elapsed * 10);
        if (acc == disAcc && !olo)
            {
                olo = true;
                for (i in a)
                    {
                        i[0].visible = true;
                        i[1].visible = true;
                        FlxG.camera.flash(FlxColor.WHITE,0.5);
                    }
            }
        if (can){
        var oldAc = disAcc;
        disAcc += 25 * elapsed;
        disAcc = FlxMath.roundDecimal(disAcc,2);
        if (disAcc> acc)
            disAcc = acc;
        if (Math.floor(oldAc) != Math.floor(disAcc))
                e = false;
        if (oldAc != disAcc)
            {
                can = false;
                w = 0;
                FlxG.sound.play(Paths.sound("scrollMenu"),0.5);
                if (Std.int(disAcc) % 10 == 0  && !e){
                    onFiv.time = 0;
                    onFiv.play();
                    e = true;
                      pitch += 0.1;
                    onFiv.pitch = pitch;
                    bg.color = bgColors[Math.floor(disAcc / 10)];
                    FlxG.camera.zoom += 0.259;
                    FlxG.camera.flash(bgColors[Math.floor(disAcc / 10)], 1.2);
                  
                }
                var str:String = "";
                if (disAcc == Math.floor(disAcc))
                    str = '$disAcc.00%';
                else
                    str = '$disAcc%';

                        
                
                var e:Array<String> = str.split("");
                accShit.forEach(function (o){
                    o.visible = false;
                });
                var off:Int = 9999;
                for (i in 0...e.length)
                    {
                        var lol = accShit.members[i];
                        lol.visible = true;
                        if (e[i] == "."){ 
                            e[i] = "Point";
                            off = i;
                        }
                        if (e[i] == "-") e[i] = "Minus";
                        if (e[i] == "%") e[i] = "Percent";

                        lol.loadGraphic(Paths.image("UI/num" + e[i],"shared"));
                        lol.x = (i * 80);
                        lol.y = 0;
                        lol.x += 665;
                        lol.y += 400 -220;

                        if (e[i] == "Point"){
                            lol.y += 65;
                            lol.x += 15;
                        }
                        if (i > off)
                            lol.x -= 25;
                    }
            }
        }
        else
            {
                w += elapsed;
                if (w >= 0.005)
                    {
                        can = true;
                    }
            }

    }
}