package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import worldgen.World;

class PlayState extends FlxState
{
	var loadedChunks:Array<Chunk> = [];
	var tiles:FlxTypedGroup<Tile> = new FlxTypedGroup();

	var seed:Int;

	override public function create():Void
	{
		FlxG.camera.zoom = 2;

		super.create();

		/*var chunk:Chunk = World.generateChunk(0, 0, {seed: 0});
			trace(chunk.tiles[0]);
			trace('${chunk.x},${chunk.y}'); */

		seed = FlxG.random.int(0, 999999999);

		Main.createThread(function()
		{
			World.generateChunks({seed: seed}, 0, 0, loadedChunks, function(chunk)
			{
				trace('LOADING CHUNK AT + ${chunk.x},${chunk.y}');

				for (tile in chunk.tiles)
				{
					var x:Int = (chunk.x * World.tileRes) + tile.x;
					var y:Int = (chunk.y * World.tileRes) + tile.y;

					var tile:Tile = new Tile(x, y, tile.tile);
					tile.visible = false;
					tile.active = false;
					tiles.add(tile);
				}
			});
		});

		add(tiles);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.W)
		{
			FlxG.camera.scroll.y -= 5;
			tileVis();
		}
		else if (FlxG.keys.pressed.S)
		{
			FlxG.camera.scroll.y += 5;
			tileVis();
		}

		if (FlxG.keys.pressed.A)
		{
			FlxG.camera.scroll.x -= 5;
			tileVis();
		}
		else if (FlxG.keys.pressed.D)
		{
			FlxG.camera.scroll.x += 5;
			tileVis();
		}

		if (FlxG.keys.pressed.Q)
			trace('seed: $seed');
	}

	// temporary
	function tileVis()
	{
		Main.createThread(function()
		{
			for (tile in tiles)
			{
				if (tile.isOnScreen() == true)
				{
					tile.visible = true;
				}
				else if (tile.isOnScreen() == false)
				{
					tile.active = false;
					tile.visible = false;
				}
			}
		});
	}
}
