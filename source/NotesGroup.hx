package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.util.FlxSort;

class NotesGroup extends FlxTypedGroup<FlxTypedGroup<Note>>
{
    public var sustainNotes:FlxTypedGroup<Note>;
    public var all:FlxTypedGroup<Note>;
    public var notes:FlxTypedGroup<Note>;
    private var totalNotes:Array<Note>= [];
    public function new()
    {
        super();

        sustainNotes = new FlxTypedGroup<Note>();
        notes = new FlxTypedGroup<Note>();
        all = new FlxTypedGroup<Note>();
    }
    public function setCam(cam:Dynamic)
    {
        cameras = [cam];
    }
    public function repos():Void
    {
        remove(all);
        add(all);
        remove(sustainNotes);
        remove(notes);
        add(sustainNotes);
        add(notes);
    }
    public function clearAll():Void
    {
        for (notes in totalNotes)
            delete(notes);
        totalNotes = [];
    }
    public function searchAtTime(time:Float,data:Int,player:Int):Note
    {
        var note:Note = null;
        getNote(function (d:Note)
            {
                if (d.strumTime == time && data == d.noteData && player == d.noteFor)
                    note = d;
            });
        return note;
    }
    public function getNoteAlive(func:(note:Note)->Void):Void
    {
        for (note in totalNotes)
        {
            if (note.alive)
                func(note);
        }
    }
    static var errore:Int = 0;
    static var pass:Int = 0;
    public inline function sortShit(int:Int, obj1:Note, obj2:Note):Int
    {
        
        var result:Int = 0;
        var order:Int =  PlayerSettings.downscroll ? -1 : 1;
        if (obj1 == null || obj2 == null)
            {
                // FOR FUCKING SHIT.
                FlxG.watch.addQuick("nullNotes",errore);
                errore ++;
                return order;
            }
            FlxG.watch.addQuick("passes",pass);
            pass ++;
        if (obj1.y < obj2.y)
            result = order;
        else if (obj1.y > obj2.y)
            result = -order;

        return result;
    }
    public function sortNotes(){
        all.sort(sortShit, PlayerSettings.downscroll ? -1 : 1);
        sustainNotes.sort(sortShit, PlayerSettings.downscroll ? -1 : 1);
        notes.sort(sortShit, PlayerSettings.downscroll ? -1 : 1);
    }

    public function getNote(func:(note:Note)->Void):Void
    {
    for (note in totalNotes)
        {
            func(note);
        }
    }
    public function push(daNote:Note)
    {
        totalNotes.push(daNote);
        all.add(daNote);

        if (daNote.isSustainNote)
            sustainNotes.add(daNote);
        else
            notes.add(daNote);
    }
    public function delete(daNote:Note)
    {
        totalNotes.remove(daNote);
        all.remove(daNote);

        if (daNote.isSustainNote)
            sustainNotes.remove(daNote);
        else
            notes.remove(daNote);
    }
}