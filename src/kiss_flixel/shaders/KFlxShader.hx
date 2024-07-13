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
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class KFlxShader extends flixel.system.FlxAssets.FlxShader {
    public var uniforms(default, null):Map<String,Uniform>;

    var json:JsonStringMap = null;

    var camera:FlxCamera = null;

    static var activeShaders:Map<String,KFlxShader> = [];
    static var chosenToEdit:String = null;

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
            activeShaders[jsonMapFile] = this;

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

        #if debug
        var p = flixel.FlxG.keys.pressed;
        var jp = flixel.FlxG.keys.justPressed;
        if (chosenToEdit != null) {
            if (chosenToEdit == json.jsonPath) {
                editShaderUniforms();
            }
        } else if (p.CONTROL && p.ALT && p.S && (jp.CONTROL || jp.ALT || jp.S)) {
            if (Lambda.count(activeShaders) == 1) {
                editShaderUniforms();
            } else {
                kiss_flixel.SimpleWindow.promptForChoiceV2("Edit which shader's uniforms?", [for (k in activeShaders.keys()) k],
                    jsonFile -> { chosenToEdit = jsonFile; });
            }
        }
        #end
    }

    public override function __disable() {
        super.__disable();

        if (json != null)
            activeShaders.remove(json.jsonPath);
    }

    function editShaderUniforms() {
        var window = new SimpleWindow('Editing shader uniforms: ${json.jsonPath}', null, null, 0.9, 0.9, true);
        
        function recursiveCall() {
            window.show();
            window.hide();
            editShaderUniforms();
        }
        
        for (key => uniform in uniforms) {
            switch (uniform) {
                case Boolean:
                    var v:Bool = Reflect.getProperty(this, key);
                    window.makeTextV2('${key}: ${v}', {
                        onClick: s -> {
                            Reflect.setProperty(this, key, !v);
                            recursiveCall();
                        }
                    });
                case AnyInt:
                    var v:Int = Reflect.getProperty(this, key);
                    window.makeTextV2('${key}: ${v}', {
                        onClick: s -> {
                            SimpleWindow.promptForString('Change from $v to any int:', shouldBeInt -> {
                                Reflect.setProperty(this, key, Std.parseInt(shouldBeInt));
                                recursiveCall();
                            });
                        }
                    });
                case IntRange(min, max):
                    var v:Int = Reflect.getProperty(this, key);
                    window.makeTextV2('${key}: ${v}', {
                        onClick: s -> {
                            SimpleWindow.promptForChoice('Change from $v to:', [for (i in min... max+1) i], int -> {
                                Reflect.setProperty(this, key, int);
                                recursiveCall();
                            });
                        }
                    });
                case IntRangeStep(min, max, step):
                    var v:Int = Reflect.getProperty(this, key);
                    window.makeTextV2('${key}: ${v}', {
                        onClick: s -> {
                            SimpleWindow.promptForChoice('Change from $v to:', [for (i in kiss.Prelude.range(min, max+1, step)) i], int -> {
                                Reflect.setProperty(this, key, int);
                                recursiveCall();
                            });
                        }
                    });
                case AnyFloat:
                    var v:Float = Reflect.getProperty(this, key);
                    window.makeTextV2('${key}: ${v}', {
                        onClick: s -> {
                            SimpleWindow.promptForString('Change from $v to any float:', shouldBeFloat -> {
                                Reflect.setProperty(this, key, Std.parseFloat(shouldBeFloat));
                                recursiveCall();
                            });
                        }
                    });
                case FloatRange(min, max):
                    var v:Float = Reflect.getProperty(this, key);
                    window.makeTextV2('${key}: ${v}', {
                        onClick: s -> {
                            SimpleWindow.promptForString('Change from $v to any float between $min and $max:', shouldBeFloat -> {
                                var f = Std.parseFloat(shouldBeFloat);
                                if (f >= min && f <= max)
                                    Reflect.setProperty(this, key, f);
                                recursiveCall();
                            });
                        }
                    });
                case FloatRangeStep(min, max, step):
                    var v:Float = Reflect.getProperty(this, key);
                    window.makeTextV2('${key}: ${v}', {
                        onClick: s -> {
                            var choices = [];
                            var next = min;
                            while (next <= max) {
                                choices.push(next);
                                next += step;
                            }
                            SimpleWindow.promptForChoice('Change from $v to:', choices, float -> {
                                Reflect.setProperty(this, key, float);
                                recursiveCall();
                            });
                        }
                    });
                case ColorSolid:
                    var c:FlxColor = Reflect.getProperty(this, key);
                    window.makeText(key);
                    window.makeTextV2('         ', {
                        bgColor: c,
                        onClick: _ -> {
                            SimpleWindow.promptForColorV2("Choose a solid color:", color -> {
                                Reflect.setProperty(this, key, color);
                                recursiveCall();
                            }, {
                                currentColor: c
                            });
                        }
                    });
                case ColorWithAlpha:
                    var c:FlxColor = Reflect.getProperty(this, key);
                    window.makeText(key);
                    window.makeTextV2('         ', {
                        bgColor: c,
                        onClick: _ -> {
                            SimpleWindow.promptForColorV2("Choose a color (transparency allowed):", color -> {
                                Reflect.setProperty(this, key, color);
                                recursiveCall();
                            }, {
                                allowAlpha: true,
                                currentColor: c
                            });
                        }
                    });
                case Vector2:
                    var p:FlxPoint = Reflect.getProperty(this, key);
                    window.makeTextV2('${key}: ${p}', {
                        onClick: _ -> {
                            SimpleWindow.promptForString('Change from $p to _,_:', str -> {
                                var parts = str.split(",");
                                Reflect.setProperty(this, key, FlxPoint.get(Std.parseFloat(parts[0]), Std.parseFloat(parts[1])));
                                recursiveCall();
                            });
                        }
                    });
                // TODO
                case Vector3:
                case Vector4:
            }
        }

        window.show();
    }
}
