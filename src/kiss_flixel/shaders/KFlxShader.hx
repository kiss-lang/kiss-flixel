package kiss_flixel.shaders;

import kiss_flixel.shaders.Uniform;

class KFlxShader extends flixel.system.FlxAssets.FlxShader {
    public var uniforms(default, null):Map<String,Uniform> = new Map();

    public function new() {
        super();
    }
}
