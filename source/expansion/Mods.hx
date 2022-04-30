package expansion;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;
#if desktop
import sys.FileSystem;
import cpp.NativeFile;
import sys.io.File;
#end
typedef ModPack = {
  var name:String;
  var version:String;
  var author:String;
  var description:String;
  var url:String;
  var icon:String;
  var repository:Repository;
  var enabled:Bool;
  var type:String;
  var codeLanguage:String;
  var language:String;
}
typedef Repository = {
  var type:String;
  var url:String;
}
typedef CharFile = {
  var icon:String;
  var image:String;
  var antialiasing:Bool;
  var flipX:Bool;
  var frames:Array<Frames>;
  var singDuration:Float;
}
typedef Frames = {
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
    var bg = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
    add(bg);
    var rawList = FileSystem.readDirectory('mods');
    for (i in 0...rawList.length){
      trace(rawList[i]);
    var modList = FileSystem.readDirectory('mods');
    for (i in 0...modList.length){
      trace(modList[i]);
      if (FileSystem.exists('mods/${list[i]}/pack.json'))
        modList.push(list[i]);
    }
    for (i in 0...list.length){
      var modShit:ModPack = haxe.Json.parse(NativeFile.file_contents_string('mods/${list[i]}/pack.json'));

      var bg = new FlxSprite(70, (i * 600) + 50).makeGraphic(500,400,FlxColor.BLACK);
      bg.screenCenter(X);
      bg.alpha = 0.6;
      add(bg);

      var name = new FlxText(70, bg.y + 40,0, modShit.name);
      name.setFormat(Paths.font('vcr.ttf'), 25, FlxColor.BLACK, LEFT);
      add(name);
      var author = new FlxText(0, name.y - 30,0, modShit.author);
      author.setFormat(Paths.font('vcr.ttf'), 16, FlxColor.BLACK, LEFT);
      add(author);
      var desc = new FlxText(0, author.y - 50,0, modShit.description);
      desc.setFormat(Paths.font('vcr.ttf'), 10, FlxColor.BLACK, LEFT);
      add(desc);

    }
    }
  }
  #end
}