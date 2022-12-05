package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;

class NotesGroup extends FlxTypedGroup<FlxTypedGroup<Note>>
{
    public var sustainNotes:FlxTypedGroup<Note>;
    public var notes:FlxTypedGroup<Note>;
    private var totalNotes:Array<Note>= [];
    public function new()
    {
        super();

        sustainNotes = new FlxTypedGroup<Note>();
        notes = new FlxTypedGroup<Note>();
    }
    public function setCam(cam:Dynamic)
    {
        cameras = [cam];
    }
    public function repos():Void
    {
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

        if (daNote.isSustainNote)
            sustainNotes.add(daNote);
        else
            notes.add(daNote);
    }
    public function delete(daNote:Note)
    {
        totalNotes.remove(daNote);

        if (daNote.isSustainNote)
            sustainNotes.remove(daNote);
        else
            notes.remove(daNote);
    }
}