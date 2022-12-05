package;

import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;

using StringTools;

class Save {

    private static var _file:FileReference;

    public static function save(data:String,name:String) 
	{
		_file = new FileReference();
		_file.addEventListener(Event.COMPLETE, onEvent);
		_file.addEventListener(Event.CANCEL, onEvent);
		_file.addEventListener(IOErrorEvent.IO_ERROR, onEvent);
		_file.save(data.trim(), name);  
    } 
	public static function download(url:String, name:String) {
		// _file = new FileReference();
        //
		// _file.addEventListener(Event.COMPLETE, onEvent);
		// _file.addEventListener(Event.CANCEL, onEvent);
		// _file.addEventListener(IOErrorEvent.IO_ERROR, onEvent);
		// _file.download(url, name);
        trace("CANT DOWNLOAD");
	} 
    private static function onEvent(_):Void {
		_file.removeEventListener(Event.COMPLETE, onEvent);
		_file.removeEventListener(Event.CANCEL, onEvent);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onEvent);
		_file = null;
    }
}