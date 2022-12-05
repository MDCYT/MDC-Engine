package custom;

import flixel.util.FlxColor;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
typedef TransTypeData = {
    /**
    * define the uses of image
    */
    ?isImg:Bool,
    /**
    * Create a random img from IMGS
    */
    ?isRandomIMG:Bool,
    /**
    * is by the index, if the curImage added is '4', if in the array image 4 isn't null use the image
    */
    ?isFromIndex:Bool,
    /**
    * Image handler?!?!?!?
    */
    ?imgs:Array<String>,
    /**
    * uses to apply in the not img trans
    */
    ?color:Array<Int>,
    /**
    * Size of the celdas
    */
    size:Int,
    /**
    * Wait time for show image
    */
    waitTime:Float,
    /**
    * added time for offsets
    */
    addTime:Float,
    /**
    *
    */
    soundOnAppear:String

}
class Trans extends FlxSubState {
    /**
    * the state to laod
    */
	public var toState:FlxState = null;

	private var isIn:Bool = false;
    private var olas:Array<FlxSprite> = [];
	private var vectores = [0, 0, 0, 0];
    private var max:Int = 0;
    private var size:Int = 25;
    private var waitTime:Float = .066;
    private var TransData:TransTypeData;

    private var loadedGraphics:Map<String,FlxGraphic> = new Map();
    
    public override function destroy():Void
    {
        super.destroy();
        for (graphic in loadedGraphics)
            {
                graphic.destroy();
            }
        loadedGraphics = null;
    }
    /**
    * Create a transtition from state.
    * @Param To     Is the state to change
    * @Param IsIn     Is the type offset
    * @Param TransData     Transition data
    */
    public function new(To:FlxState, IsIn:Bool = true,TransData:TransTypeData)
    {
        this.TransData = TransData;
        if (TransData == null)
            TransData = {
                color: [0,0,0],
                waitTime: 0.066,
                size: 250,
                addTime: 0.01,
                soundOnAppear: "",
            }
        
		this.toState = To;
        this.isIn = IsIn;
        this.size = TransData.size;
		max = Std.int((Math.floor(FlxG.width / size) * Math.floor(FlxG.height / size)) * 2);

        super();
        if (TransData.isImg)
            {
                // TODO: Load better images.

                for (i in 0...TransData.imgs.length)
                {
                    var graphicLoad:FlxGraphic = FlxGraphic.fromBitmapData(BitmapData.fromFile("assets/images/trans/" + TransData.imgs[i]));
                    loadedGraphics.set(TransData.imgs[i],graphicLoad);
                }

            }
	for (i in 0...max)
    {
        var square:FlxSprite;
        if (TransData.isImg)
            {
                var graphic:FlxGraphic;
                if (!TransData.isRandomIMG)
                    graphic = loadedGraphics.get(TransData.imgs[i % (TransData.imgs.length - 1)]); 
                else
                    graphic = loadedGraphics.get(TransData.imgs[FlxG.random.int(0,TransData.imgs.length - 1)]);   
                
                square = new FlxSprite().loadGraphic(graphic);

            } 
            else
            {
                if (TransData.color == null)
                    TransData.color = [255,255,255];
                square = new FlxSprite().makeGraphic(1,1,FlxColor.fromRGB(TransData.color[0],TransData.color[1],TransData.color[2]));
            }
        square.setGraphicSize(size,size);
        square.updateHitbox();
		square.ID = curID;
        if (olas[curID - 1] != null)
        {
        if (olas[curID - 1 ].x + 50 <= FlxG.width + size)
                square.x = olas[curID - 1].x + size;
        else
			vectores[1]++;
            square.y = vectores[1] * size;
        }
        square.visible = !isIn;
        curID ++;
		olas.push(square);
		add(square);
        if (i % 360 == 0)
            waitTime -= 0.011;
        
    }

    trace('new trans by size: ${size} sizemax in loop: ${max} isIn ${IsIn} its any state??? ${To != null ? "true" : "false"}');
    if (waitTime <= 0.04) 
    {
        trace("wow its too long???");
        waitTime = 0.035;
    }
    waitTime -= TransData.waitTime;
    waitTime += TransData.addTime;

	trace("wait time: " + waitTime);

	
    }
    private var elap:Float = 0;
    private var loops:Int = 0;
    private var curID:Int = 0;
    private var olaID:Array<Int> = [];
    private var looped:Bool = false;
    private function addNew()
    {
        if (looped)
            return;
		var id = FlxG.random.int(0, max,olaID);
        olaID.push(id);
      
        for (i in olas)
            if (id == i.ID)
                i.visible = isIn;
		if (olaID.length >= max) 
			looped = true;
        
    }
    override function update(e) 
    {
        super.update(e);
		elap += FlxG.elapsed;
     if (looped)
        for (i in olas)
				i.visible = isIn;
		if (elap >= waitTime) 
        {
			elap = 0;
            for (i in 0...(FlxG.random.int(4,8)))
			    addNew();
			if (max >= 650)
                for (i in 0...7)
                    addNew();
            
            loops ++;
            if (TransData.soundOnAppear != ""){
		        FlxG.sound.play('assets/sounds/${TransData.soundOnAppear}.ogg');
            }
		}
		if (loops >= Std.int(max / 2) || looped) {
            looped = true;
            FlxG.state.closeSubState();
            if (toState != null){
			    FlxG.switchState(toState);
                // toState.openSubstate(new Trans(null, false,TransData));
            }
        }
    }
}