package;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

import flixel.util.FlxSave;
import haxe.Json;

using StringTools;
typedef ReplayData =
{
    /**
    * Cur song position to do the event binded.
    */
    var inSongPos:Float;
    /**
    * event name.
    */
    var data:String;
    /**
    * real data.
    */
    var hitData:_HitData;
}
typedef _HitData =
{
    /**
    * Literaly all.
    */
    var noteData:Int;
    /**
    * Used for press note
    */
    var strumTime:Float;
    /**
    * Used for the rating in ms
    */
    var diff:Float;
}
/**
* Used for the replay when you press F12 in the result screen IN freplay.
* 
* If you use this, remember this: NO MODIFY NOTHING; HAVE A FULL ERROR FOR IT.
*/
typedef Replay = Array<ReplayData>;
class ReplayParser
{
    public static function get(name:String):Replay
    {
        var data:String = '{"data":[],"song":"tutorial", "date": "2000-09-04"}';

        #if sys
        var path:String = Paths.json('replays/${name.toLowerCase()}');
        if (!FileSystem.exists('assets/data/replays'))
            FileSystem.createDirectory('assets/data/replays');

        if (FileSystem.exists(path))
                data = File.getContent(path);
        #end

        return Json.parse(data);
    }
    public static function autoSave(name:String,data:String)
    {

        #if sys
        var path:String = Paths.json('replays/_${name.toLowerCase()}_${Date.now().toString().replace(" ","_").replace("-","_").replace(":","_")}');
        if (!FileSystem.exists('assets/data/replays'))
            FileSystem.createDirectory('assets/data/replays');

        if (!FileSystem.exists(path))
              File.saveContent(path,data);
        #end
        flush(data);

    }
    public static function getOnTheAppSave():Array<String>
    {
        var save:FlxSave = new FlxSave();
        save.bind("replays","mrniz");
        var rtr:Array<String> = [];

        if (save.data.all == null)
            save.data.all = rtr;
        rtr =  save.data.all.copy();

        save.flush();
        save.close();

        return rtr;
    }
    public static function flush(dat:String)
    {
        var save:FlxSave = new FlxSave();
        save.bind("replays","mrniz");
        var rtr:Array<String> = [];

        if (save.data.all != null)
            rtr = save.data.all.copy();
        rtr.push(dat);
        save.data.all = rtr.copy();

        save.flush();
        save.close();

        return rtr;
    }

}