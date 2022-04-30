package expansion;
#if desktop
import sys.FileSystem;
import cpp.NativeFile;
import sys.io.File;
#end
typedef CharFile = {
  var icon:String;
  var image:String;
  var antialiasing:Bool;
  var flipX:Bool;
  var sopas:Array<Popo>;
  var singDuration:Float;
}
typedef Popo = {
  var name:String;
  var prefix:String;
  var fps:Int;
  var loop:Bool;
  var offsets:Array<Float>;
  var indices:Array<Int>;
}
class EditorChar extends MusicBeatState {
  public var namedChar:String = 'bf';
  public var _c:CharFile;
  public var char:Character;

  public function new(namedChar:String = 'bf'){
    super();
    this.namedChar = namedChar;
  }
  override function create(){
    super.create();
    char = new Character(0,0,namedChar);
    add(char);
    _c = char.ola;

  }

  function changeAnim(a:String, b:String, c:Int, d:Bool){
    
    char.animation.addByPrefix(a,b,c,d);
  }
function getAnimsautomaticamente(){

}
}

class Mods  extends MusicBeatState {
  #if desktop
  var list:Array<Dynamic> = [];

  override function create() {
    super.create();
    var cuandolist = FileSystem.readDirectory('mods');
    for (i in 0...cuandolist.length){
      trace(cuandolist[i]);
      if (FileSystem.exists('mods/${list[i]}/pack.json'))
        list.push(list[i]);
    }


  }
  #end
}