package worldgen;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import noisehx.Perlin;
import worldgen.Biome.BiomeGenerator;

class World
{
	public static var tileRes:Int = 32; // 32x32
	public static var chunkSize:Int = 8;

	private static function addtileToChunk(chunk:Chunk, newtile:ChunkData):Void
	{
		for (tile in chunk.tiles)
		{
			if (tile.x == newtile.x && tile.y == newtile.y && tile.layer >= newtile.layer)
			{
				return;
			}
		}

		chunk.tiles.push(newtile);
	}

	public static function generateChunk(x:Int, y:Int, properties:WorldProperties)
	{
		var noise:Perlin = new Perlin(properties.seed);
		var bgen:BiomeGenerator = new BiomeGenerator(properties.seed);

		var chunk:Chunk = {
			x: x,
			y: y,
			tiles: []
		};

		for (nx in x...x + chunkSize)
		{
			for (ny in y...y + chunkSize)
			{
				var finalX:Int = Std.int((nx - x) * tileRes);
				var finalY:Int = Std.int((ny - y) * tileRes);

				var land:Float = noise.noise2d(nx / tileRes, ny / tileRes, 3);
				var biome:Biome = bgen.getBiome(nx, ny); // Gets the closest biome.
				var foliage:Float = noise.noise2d(nx / 128, ny / 128, 10);

				var biomeName:String = biome.name.toLowerCase();

				var seaLevel:Float = 0.25;

				switch (biomeName)
				{
					default:
					// don't do anything cuz seaLevel is default at 0.25
					case 'tundra':
						seaLevel = -1; // really low chance for there to be water LOL
				}

				if (land >= seaLevel && biomeName != 'ocean')
				{
					switch (biomeName)
					{
						case 'plains':
							if (land >= 0.25 && land < 0.5 /*|| land >= -1 && land < -0.75 || land >= -0.45 && land < -0.5*/)
							{
								addtileToChunk(chunk, {
									tile: 'sand',
									biome: biome.name,
									layer: 0,
									x: finalX,
									y: finalY
								});
							}
							else if (land >= 0.5 /*||land <= -0.5*/)
							{
								addtileToChunk(chunk, {
									tile: 'grass',
									biome: biome.name,
									layer: 0,
									x: finalX,
									y: finalY
								});

								if (foliage >= 0.75)
								{
									addtileToChunk(chunk, {
										tile: 'tree',
										biome: biome.name,
										layer: 1,
										x: finalX,
										y: finalY
									});
								}
							}
						case 'forest':
							if (land >= 0.25 && land < 0.5)
							{
								addtileToChunk(chunk, {
									tile: 'sand',
									biome: biome.name,
									layer: 0,
									x: finalX,
									y: finalY
								});
							}
							else if (land >= 0.5)
							{
								addtileToChunk(chunk, {
									tile: 'grass',
									biome: biome.name,
									layer: 0,
									x: finalX,
									y: finalY
								});

								if (foliage >= 0.45)
								{
									addtileToChunk(chunk, {
										tile: 'tree',
										biome: biome.name,
										layer: 1,
										x: finalX,
										y: finalY
									});
								}
							}

						case 'desert':
							if (land >= 0.25)
							{
								addtileToChunk(chunk, {
									tile: 'sand',
									biome: biome.name,
									layer: 0,
									x: finalX,
									y: finalY
								});
							}

						case 'tundra':
							if (land < 0.25)
							{
								addtileToChunk(chunk, {
									tile: 'ice',
									biome: biome.name,
									layer: 0,
									x: finalX,
									y: finalY
								});
							}
							else if (land >= 0.25)
							{
								addtileToChunk(chunk, {
									tile: 'snow',
									biome: biome.name,
									layer: 0,
									x: finalX,
									y: finalY
								});
							}
					}
				}
				else
				{
					addtileToChunk(chunk, {
						tile: 'water',
						biome: biome.name,
						layer: 0,
						x: finalX,
						y: finalY
					});
				}
			}
		}

		return chunk;
	}

	public static function getChunkPoint(chunkX:Float, chunkY:Float):FlxPoint
	{
		return new FlxPoint(Math.floor(chunkX), Math.floor(chunkY));
	}

	public static function generateChunks(properties:WorldProperties, chunkX:Int, chunkY:Int, loadedChunks:Array<Chunk>, ?callback:Chunk->Void):Array<Chunk>
	{
		var chunks:Array<Chunk> = [];

		// Define the radius of the grid in number of chunks
		var radius:Int = 6;

		// Loop through each chunk in the grid and generate it if it doesn't already exist in the loadedChunks array
		for (x in -radius...radius)
		{
			for (y in -radius...radius)
			{
				var pos:FlxPoint = getChunkPoint((chunkX + x) * chunkSize, (chunkY + y) * chunkSize);

				var alreadyLoaded:Bool = false;
				for (chunk in loadedChunks)
				{
					if (chunk.x == pos.x && chunk.y == pos.y)
					{
						alreadyLoaded = true;
						break;
					}
				}

				if (!alreadyLoaded)
				{
					var genChunk:Chunk = generateChunk(Std.int(pos.x), Std.int(pos.y), properties);
					if (callback != null)
						callback(genChunk);
					chunks.push(genChunk);
				}
			}
		}

		return chunks;
	}
}

typedef WorldProperties =
{
	var seed:Int;
}

typedef Chunk =
{
	var x:Int;
	var y:Int;
	var tiles:Array<ChunkData>;
}

typedef ChunkData =
{
	var tile:String;
	var biome:String;
	var layer:Int;
	var x:Int;
	var y:Int;
}
