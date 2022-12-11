
# FRIDAY NIGHT FUNKIN' Modding Discord Community engine!

hello, it's me, Niz, I'm here to give you several announcements, before asking for help go to [página culera]
Before asking for help on scripts, you can still go to [our discord server](https://discord.gg/dae).
## Credits / shoutouts
Thanks to ([lizin]) for helping me fix bugs 
### Funkin crew team
- [ninjamuffin99 (me!)](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician
### MDC engine team
- [MDC](https://github.com/MDCYT) - creator, programmer
- [MrNiz](https://YouTube.com/@MrNiz) - Co-creator, Main Programmer, Animator, Artista.
- [Asma]() - Animator
- [Ams]() - Extra Programmer.
- [Manx_64x]() - Extra Programmer.

## Silly things
There are many APIs that will be used so I recommend creating this in `source/`

```haxe
package;

import flixel.FlxG;

class APIStuff #if niz_build extends APIS #end
{
   // It's not normally used, but when you have admin powers it will be used, or at least on the mod downloader page.
   public static var engineAdmin:String ="";
   public static var gamejolt:String = "";
   public static var nizpagepas:String = ""; // no se crean la página no la he creado
   public static var globalChat:String = "";
   // Esta madre no se usará de no ser que quiera MDC cambiar un git desde el juego.
   public static var githubwrite:String = "";
   public static function tryDownload(pg:String,?save:Bool = false):Bool
   {
     // FlxG.game.up=false;
    trace("Unoficial BUILD!?!!?!?!");
    return false;
   }
}
```
And if you need something else go to `source/account/`.
And create this with the name `Manager.hx`
```haxe

package;

import account.*;

class Manager extends FunkinAccountCard
{
   public static var basic = new Manager;

   public static var getChild():Manager
     return basic;
   // Used to prevent hacks, but in the end it's just a very bad manager.1
   public function changeCard(to:FunkinBaseCard):Void
   {
     // requestServer().send("local-
      trace("");
 
   }
}
```

# Requirements.
As first you need `Haxe` and `Flixel`
1. [Install Haxe](https://haxe.org/download/version/).
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe

now you need the extra libraries.
```
haxelib install flixel
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hxCodec
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib install hscript
haxelib git linc_luajit https://github.com/nebulazorua/linc_luajit.git
haxelib git hxvm-luajit https://github.com/nebulazorua/hxvm-luajit
haxelib install lime 7.9.0
haxelib install openfl
haxelib install flixel
haxelib run lime setup
haxelib run lime setup flixel
haxelib install flixel-tools
haxelib run flixel-tools setup
haxelib install flixel-addons
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
haxelib git faxe https://github.com/uhrobots/faxe
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib install actuate
haxelib git extension-webm https://github.com/KadeDev/extension-webm
lime rebuild extension-webm windows (NOTE: wait for the next step for this).
```
It's a lot, but it's a combination to make it work well xd 

Oh god. 
The next step is to have the [VsTools]()
Install this in a package 

* MSVC v142 - VS 2019 C++ x64/x86 build tools
* Windows SDK (10.0.17763.0)

If you have problems install this from Microsoft the c++ compiler package.
