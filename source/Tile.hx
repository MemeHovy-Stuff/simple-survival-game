import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxDirection;
import flixel.util.FlxDirectionFlags;
import worldgen.World;

class TileSettings
{
	public static var tileTypes:Map<String, TileProperties> = new Map();
	public static var isInit:Bool = false;

	// everything is case sensitive! i think!
	public static function initialize()
	{
		if (isInit == false)
		{
			trace('INITIALIZING TILES...');

			tileTypes.set("water", {
				image: "water",
				animated: false,
				width: 16,
				height: 16,
				functions: {
					onPStand: function()
					{
						trace('PLAYER IS STANDING ON WATER BLOCK?!');
					}
				}
			});
			// trace(1);

			tileTypes.set("grass", {
				image: "grass",
				animated: false,
				width: 16,
				height: 16
			});
			// trace(2);

			tileTypes.set("sand", {
				image: "sand",
				animated: false,
				width: 16,
				height: 16
			});
			// trace(3);

			tileTypes.set("snow", {
				image: "snow",
				animated: false,
				width: 16,
				height: 16
			});
			// trace(4);

			tileTypes.set("ice", {
				image: "ice",
				animated: false,
				width: 16,
				height: 16
			});
			// trace(5);

			tileTypes.set("tree", {
				image: "tree",
				animated: false,
				width: 16,
				height: 16
			});

			isInit = true; // very important
		}
	}
}

class Tile extends FlxSprite
{
	var curType:TileProperties;

	public function new(x:Int, y:Int, type:String)
	{
		super(x, y);

		TileSettings.initialize();
		curType = TileSettings.tileTypes.get(type.toLowerCase());

		loadGraphic('assets/images/tiles/${curType.image}.png', curType.animated, curType.width, curType.height);
		if (!curType.disableAutoScale || curType.disableAutoScale == null)
		{
			if (graphic.width != World.tileRes || graphic.height != World.tileRes)
			{
				setGraphicSize(World.tileRes, World.tileRes);
				updateHitbox();
			}
		}
	}

	public function onHit()
	{
		if (curType.functions != null && curType.functions.onHit != null)
			curType.functions.onHit();
	}

	public function onBreak()
	{
		if (curType.functions != null && curType.functions.onBreak != null)
			curType.functions.onBreak();
	}

	public function onInteract()
	{
		if (curType.functions != null && curType.functions.onInteract != null)
			curType.functions.onInteract();
	}

	// On Player Standing on Tile
	public function onPStand()
	{
		if (curType.functions != null && curType.functions.onPStand != null)
			curType.functions.onPStand();
	}
}

typedef TileProperties =
{
	var image:String;
	var animated:Bool;
	var width:Int;
	var height:Int;
	var ?functions:TileFunctions;
	var ?disableAutoScale:Bool;
}

typedef TileFunctions =
{
	var ?onHit:Void->Void;
	var ?onBreak:Void->Void;
	var ?onInteract:Void->Void;
	var ?onPStand:Void->Void;
}
