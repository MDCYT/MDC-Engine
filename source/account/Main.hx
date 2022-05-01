package account;

import flixel.FlxG;
import openfl.display.BitmapData;

typedef Data ={
  var ?email:String;
  var ?pass:String;
  var ?rutePFP:String;
  var ?username:String;
  var ?nickname:String;
}
class Main
{
  public static var username:String;
  public static var id:String;
  public static var nickname:String; 
  public static var pfp:BitmapData;

  public static var current:Array<String> = [null,null, null, null];
  /*
  * si termina con 0x es un error del usuario o un error no tan detallado.
  * si termina en 0xA es un error con el servidor.
  * si termina con 0xE es error del juego.
  */ 
  private static function getError(?s:String = 'CNRDTLIN0x'){
    switch(s){ 
      default:
        return "I'm sorry!, if you don't put enough information we can't register it correctly";
      case "TWNCCWTS0xA":
        return "when making contact with the server the response was null or did not respond directly at all.\n" + 
        "check your internet connection, restart the internet and start the check again in 'Options', 'Login', and select your Login Type";
      case "XD0xE":
        return "GO TO SETTINGS TO LOGIN OR SIGN IN!";
    }
  }
  public static function start() {
    if (current[0] == "MDC_SERVER_LOGIN")
    {
      FlxG.save.data.loginreqdata = ["MDC_SERVER_LOGIN", "ID", "null", "null"];
      FlxG.save.flush();
      current = FlxG.save.data.loginreqdat;
    }
    else
    {
      error("XD0xE");
    }
  }
  public static function login(type:String, ?a:Data):Void {
    var onError:Bool;
    onError = true;
    if (type == "ONLINE"){
      trace('trying login online');
    } else {
      username = a.username;
      nickname = a.nickname; 
      pfp = BitmapData.fromFile(a.rutePFP);
    }
  }
  public static function signIn(type:String, ?a:Data){
    if (type == "ONLINE"){
      trace('trying contact to server');
      trace('ERROR');

      error("TNCCWTS0xA");

    }


  }
  private static function error(s:String) {
    trace(getError(s));
    FlxG.log.add('[MDC_LOGIN_SYSTEM]: Error:$s ${getError(s)}');
  }
}