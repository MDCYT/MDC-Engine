package;

import flixel.FlxSprite;

using StringTools;
class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;
	public var character:String = "bf";
	private var isPlayer:Bool = false;
	private var winingAnim:Bool = false;

	public function new(char:String = 'bf', isPlayer:Bool = false,?winingAnim:Bool = false,?canBeTwoaAnims:Bool =  true)
	{
		super();
		character = char;

		this.isPlayer = isPlayer;
		antialiasing = !(char.endsWith("-pixel"));
		if (!Paths.exists('images/icons/${char}.png')) char = character + "-icon";
		if (!Paths.exists('images/icons/${char}.png')) char = "icon-" + character;
		if (!Paths.exists('images/icons/${char}.png')) char = character;
		if (!Paths.exists('images/icons/${char}.png')) char = "face";
		loadGraphic(Paths.image('icons/' + char));
		// trace (winingAnim); 
		if (canBeTwoaAnims){
		loadGraphic(Paths.image('icons/' + char), true, Std.int(width / (winingAnim ? 3 : 2)), Std.int(height));
		animation.add("icon", (winingAnim ? [0,1,2] : [0, 1]), 0, false, isPlayer);
		animation.play("icon");
		}
		setGraphicSize(165);
		updateHitbox();
		scrollFactor.set();
	}
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
