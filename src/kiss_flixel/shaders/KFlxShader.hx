package kiss_flixel.shaders;

import kiss_flixel.shaders.Uniform;
import kiss_tools.JsonMap;
import kiss_tools.JsonString;
import kiss_tools.JsonInt;
import kiss_tools.JsonFloat;
import kiss_tools.JsonBool;
import kiss_flixel.JsonFlxColor;
import kiss_flixel.JsonFlxPoint;
import flixel.FlxCamera;

class KFlxShader extends flixel.system.FlxAssets.FlxShader {
    public var uniforms(default, null):Map<String,Uniform>;

    var json:JsonStringMap = null;

    var camera:FlxCamera = null;

    public function new(?camera:FlxCamera, ?jsonMapFile:String) {
        super();

        if (camera == null) {
            camera = flixel.FlxG.camera;
        }
        this.camera = camera;

        data.iTime.value = [0.0];
        data.cameraPos.value = [camera.viewLeft, camera.viewTop];
        data.cameraZoom.value = [1.0];

        if (jsonMapFile != null) {
            json = new JsonMap(jsonMapFile, new JsonString(""));
            
            for (name => uniform in uniforms) {
                if (json.exists(name)) {
                    switch (uniform) {
                        case Boolean:
                            Reflect.setProperty(this, name, new JsonBool(false).parse(json.get(name).value).value);
                        case AnyInt | IntRange(_, _) | IntRangeStep(_, _, _):
                            Reflect.setProperty(this, name, new JsonInt(0).parse(json.get(name).value).value);
                        case AnyFloat | FloatRange(_, _) | FloatRangeStep(_, _, _):
                            var value = new JsonFloat(0).parse(json.get(name).value).value;
                            Reflect.setProperty(this, name, value);
                        case ColorSolid | ColorWithAlpha:
                            var value = new JsonFlxColor(0).parse(json.get(name).value).value;
                            Reflect.setProperty(this, name, value);
                        case Vector2:
                            Reflect.setProperty(this, name, new JsonFlxPoint(flixel.math.FlxPoint.get()).parse(json.get(name).value).value);
                        // TODO
                        case Vector3 | Vector4:
                            trace('Warning! Shader uniform $name of type $uniform is not handled in kiss-flixel json');
                    }
                }
            }
        }
    }

	public override function __update() {
        super.__update();
        data.iTime.value = [data.iTime.value[0] + flixel.FlxG.elapsed];
        data.cameraPos.value = [camera.viewLeft, camera.viewTop];
        data.cameraZoom.value = [camera.zoom];
    }

}
