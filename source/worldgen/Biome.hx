package worldgen;

import noisehx.Perlin;

class Biome
{
	public var temperature:Float;
	public var rainfall:Float;
	public var name:String;

	public function new(temperature:Float, rainfall:Float, name:String)
	{
		this.temperature = temperature;
		this.rainfall = rainfall;
		this.name = name;
	}
}

class BiomeGenerator
{
	private var temperatureNoise:Perlin;
	private var rainfallNoise:Perlin;
	private var biomes:Array<Biome>;

	public function new(seed:Int)
	{
		temperatureNoise = new Perlin(seed);
		rainfallNoise = new Perlin(seed + 1);
		biomes = new Array<Biome>();

		biomes.push(new Biome(0.25, 0.5, "tundra"));
		biomes.push(new Biome(0.85, 0.25, "desert"));
		biomes.push(new Biome(0.9, 0.8, "ocean"));
		biomes.push(new Biome(0.6, 0.5, "plains"));
		biomes.push(new Biome(0.7, 0.6, "forest"));
	}

	public function getBiome(x:Float, y:Float):Biome
	{
		var temperature:Float = (temperatureNoise.noise2d(x / 128, y / 128) + 1) / 2;
		var rainfall:Float = (rainfallNoise.noise2d(x / 128, y / 128) + 1) / 2;

		var closestBiome:Biome = null;
		var closestDistance:Float = 100000.0;

		for (biome in biomes)
		{
			var distance:Float = Math.sqrt(Math.pow(biome.temperature - temperature, 2) + Math.pow(biome.rainfall - rainfall, 2));
			if (distance < closestDistance)
			{
				closestBiome = biome;
				closestDistance = distance;
			}
		}

		return closestBiome;
	}
}
