package funkinscript;
import flixel.FlxG;
// packa
class Script
{
    public var name:String = "null";
    public var interp:Interp;
    public var parser:hscript.Parser;

    private var localAddedVars:Map<String,Dynamic> = [];
    private var localAddedInState:Map<String,Dynamic> = [];

    public var state:MusicBeatState = null;

    public function new()
    {
        interp = new Interp();
        parser = new hscript.Parser();
        localAddedVars = new Map();
        localAddedInState =new Map();
    }
    private var ID:Int = 0;
    private var adID:Int = 0;
    public function setCurState(state:MusicBeatState):Void
    {
        this.state = state;
        setFunction("add",function (obj){
            state.add(obj[0]);
            adID ++;
        });
        setFunction("remove",function (obj){
            state.remove(obj[0]);
            adID --;

        });
    }
    public function reset():Void
    {
        interp = null;
        parser = null;
        localAddedVars = null;

        interp = new Interp();
        parser = new hscript.Parser();
        localAddedVars = new Map();
    }
    public function execute(Data:String)
    {
		var ast = parser.parseString(Data);
		interp.execute(ast);
        setVar("FlxG",FlxG);
    }
    public function callBack(func:String,args:Array<Dynamic>)
        {
           @:privateAccess if (interp.locals.get(func) != null) interp.locals.get(func).r(args);
        }
    public function setFunction( name:String,funct:(Array<Dynamic>)->Void):Void
    {
        interp.setVar(name, Reflect.makeVarArgs(Reflect.makeVarArgs(funct)));
        localAddedVars.set(name, Reflect.makeVarArgs(funct));
    }
    public function setVar(name:String,data:Dynamic):Void
    {
        interp.setVar(name,data);
        localAddedVars.set(name,data);
    }
}