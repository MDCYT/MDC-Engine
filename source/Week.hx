package;

import openfl.Assets;
import haxe.Json;

using StringTools;

typedef _Week = {
    var formatVer:String;

    var songs:Array<Dynamic>; // [["song","char",[color]]]

    var hide:Array<Bool>; // [freeplay,story-mode]
    var weekFile:String; // weekfiel

    var weekName:String; // weekfiel
}

typedef LogicWeek = 
{
    var songs:Array<String>;
    var chars:Array<String>;
    var colors:Array<Array<Int>>;

    var hideInFreeplay:Bool;
    var hideInStoryMode:Bool;
    var songs_length:Int ;

    var weekFile:String;
    var ID:Int;
}

class Week {
    public static var _weeks:Array<_Week> = [];
    public static var weeks:Map<Int,_Week> = new Map();

    public static function getLogic():Array<LogicWeek> 
    {
        var rtr:Array<LogicWeek> = [];
        for (i in 0..._weeks.length)
        {
            var songs:Array<String> = [];
            var chars:Array<String> = [];
            var colors:Array<Array<Int>> = [];
            
            for (e in _weeks[i].songs)
                {
                    songs.push(e[0]);
                    chars.push(e[1]);
                    colors.push(e[2]);
                }
            var logic:LogicWeek = {
                songs: songs,
                chars: chars,
                colors: colors,
                hideInFreeplay: _weeks[i].hide[0],
                hideInStoryMode: _weeks[i].hide[1],
                weekFile: _weeks[i].weekFile,
                songs_length: _weeks[i].songs.length,
                ID: i
            };
            rtr.push(logic);
        }
        return rtr;
    }
    public static function init()
    {
        var weeks_file = "weeks/weeks.txt";
        var weekOrder = Assets.getText(Paths.data(weeks_file)).trim().replace("\r","").split("\n");
        for (i in 0...weekOrder.length)
            {
                trace("addingWeek " + i  + "  " + weekOrder[i]);
                var rawJson = Assets.getText(Paths.data("weeks/" + weekOrder[i] + ".json"));

                var jsonParse = Json.parse(rawJson);
                jsonParse.weekName = weekOrder[i];

                _weeks.push(jsonParse);
                weeks.set(i,jsonParse);
            }
    }
    public static function getByString(?str:String = "tutorial"):_Week
    {
        for (i in _weeks)
            {
                if (i.weekName.toLowerCase() == str.toLowerCase())
                    return i;
            }

        return null;
    }
    public static function getAll():Array<_Week>
        {
            return _weeks;
        }
    public static function getByInt(?itn:Int = 0):_Week
        {
            if (weeks.get(itn) != null)
                {
                    return  weeks.get(itn);
                }
    
            return null;
        }
}