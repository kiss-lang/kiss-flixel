package kiss_flixel;

import tink.syntaxhub.*;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Expr.ImportMode;
import kiss.Stream;
import kiss.Helpers;

import hscript.Parser;
import hscript.Interp;

using StringTools;
using haxe.io.Path;
using tink.MacroApi;

class ShaderFrontend implements FrontendPlugin {
	static var hParser = new Parser();
	static var hInterp = new Interp();

	public function new() {
		function vec2(x, ?y) {
			if (y == null) {
				y = x;
			}
			return macro flixel.math.FlxPoint.get($v{x}, $v{y});
		}
		hInterp.variables["vec2"] = vec2;

		function vec3(x, ?y, ?z) {
			if (y == null && z == null) {
				y = x;
				z = x;
			}
			return macro flixel.util.FlxColor.fromRGBFloat($v{x}, $v{y}, $v{z});
		}
		hInterp.variables["vec3"] = vec3;

		function vec4(x, ?y, ?z, ?w) {
			if (y == null && z == null && w == null) {
				y = x;
				z = x;
				w = x;
			}
			return macro flixel.util.FlxColor.fromRGBFloat($v{x}, $v{y}, $v{z}, $v{w});
		}
		hInterp.variables["vec4"] = vec4;
	}
	 
	static function hint_range_int(min, max, ?step) {
		return if (step == null) {
			macro kiss_flixel.shaders.Uniform.IntRange($v{min}, $v{max});
		} else {
			macro kiss_flixel.shaders.Uniform.IntRangeStep($v{min}, $v{max}, $v{step});
		};
	}

	static function hint_range_float(min, max, ?step) {
		return if (step == null) {
			macro kiss_flixel.shaders.Uniform.FloatRange($v{min}, $v{max});
		} else {
			macro kiss_flixel.Uniform.FloatRangeStep($v{min}, $v{max}, $v{step});
		};
	}

	var vertexExtensions = ["v.glsl", "vert"];
	var fragmentExtensions = ["f.glsl", "frag"];

	public function extensions() {
		return vertexExtensions.concat(fragmentExtensions).iterator();
	}

	public function parse(file:String, context:FrontendContext):Void {
		var extension = file.withoutDirectory().substr(file.withoutDirectory().indexOf(".") + 1);
		trace(extension);

		final type = context.getType();
		var parentClass = 'kiss_flixel.shaders.KFlxShader';
		type.kind = TDClass(parentClass.asTypePath(), [], false, false, false);

		var pos = Context.makePosition({file: file, min: 0, max: 0});

		var glslStream = Stream.fromFile(file);

		var transformedCode = "";
		function error(reason = "") {
			throw 'Error transforming shader code! $reason';
		}

		// Supply some useful properties, updated every frame:
		// * ShaderToy-esque iTime
		// * Camera position (cameraPos)
		// * Camera zoom (cameraZoom)
		transformedCode += 'uniform float iTime;\n';
		transformedCode += 'uniform vec2 cameraPos;\n';
		transformedCode += 'uniform float cameraZoom;\n';
		type.fields.push({
			pos: pos,
			name: "__update",
			kind: FFun({
				args: [],
				expr: macro {
					super.__update();
					data.iTime.value = [data.iTime.value[0] + flixel.FlxG.elapsed];
					data.cameraPos.value = [camera.viewLeft, camera.viewTop];
					data.cameraZoom.value = [camera.zoom];
				}
			}),
			access: [APublic, AOverride]
		});
		type.fields.push({
			pos: pos,
			name: "camera",
			kind: FVar(kiss.Helpers.parseComplexType("flixel.FlxCamera"), macro null),
			access: [APrivate]
		});

		// TODO Implement round for the targets that weirdly don't have it

		// give uniforms their default values
		var defaultSetterExps = [];
		var uniformMapExps = [];

		var delimiters = ",.(){}[] \t\n;?:|&<>/*+-'\"=".split("");

		var colorOut = "";
		var coordIn = "";

		transformedCode += "const float PI = 3.1415926535897932384626433832795;\n";

        function nextToken() {
            glslStream.dropWhitespace();
            return glslStream.takeUntilOneOf(delimiters);
        }

        function dropNext(delim:String) {
            glslStream.dropWhitespace();
            glslStream.dropString(delim);
        }

		var expect = glslStream.expect;

		while (!glslStream.isEmpty()) {
			switch (glslStream.takeWhileOneOf(delimiters)) {
				case Some(codeSyntax):
					transformedCode += codeSyntax;
				default:
			}
			switch (glslStream.takeUntilOneOf(delimiters)) {
                case Some("#pragma"):
                    switch (nextToken()) {
                        case Some("header"):
                            // We already add #pragma header at the start of everything -- a duplicate creates an error
                            continue;
                        case Some(pragma):
                            transformedCode += '#pragma $pragma';
                        default:
                    }

				// Shadertoy compatibility:
				case Some("iResolution"):
					transformedCode += "openfl_TextureSize";

				case Some("void"):
					switch (nextToken()) {
						case Some("mainImage"):
							dropNext("(");
							dropNext("out");
							dropNext("vec4");
							switch (nextToken()) {
								case Some(symbol):
									colorOut = symbol;
								default:
									error();
							}
							dropNext(",");
							dropNext("in");
							dropNext("vec2");
							switch (nextToken()) {
								case Some(symbol):
									coordIn = symbol;
								default:
									error();
							}
							dropNext(")");
							transformedCode += "void main() ";
						case Some("fragment"):
							dropNext("()");
							transformedCode += "void main() ";
						case Some(other):
							transformedCode += 'void $other';
						default:
							throw "expected name of void function";
					}

                case Some(name) if (name == colorOut):
                    transformedCode += "gl_FragColor";
                case Some(name) if (name == coordIn):
                    transformedCode += "openfl_TextureCoordv * openfl_TextureSize";

				// Godot compatibility
				case Some("TIME"):
					transformedCode += "iTime";
				case Some("COLOR"):
					transformedCode += "gl_FragColor";
				case Some("SCREEN_TEXTURE" | "TEXTURE"):
					transformedCode += "bitmap";
				
				case Some("texture"):
					transformedCode += "flixel_texture2D";

				// Not totally sure this actually is a 1-to-1 equivalency:
				case Some("SCREEN_UV" | "UV"):
					transformedCode += "openfl_TextureCoordv";

				case Some("SCREEN_PIXEL_SIZE" | "TEXTURE_PIXEL_SIZE"):
					transformedCode += "vec2(1.0 / openfl_TextureSize.x, 1.0 / openfl_TextureSize.y)";

				// Uniform handling:
				case Some("uniform"):
					var uType = expect("uniform type", nextToken);

					// Don't try to handle arrays:
					if (glslStream.startsWith("[")) {
						transformedCode += 'uniform $uType ${expect("array uniform declaration", glslStream.takeUntilAndDrop.bind(";"))};';
						continue;
					}

					// This feature is also very incompatible with the extended metadata system of openfl shaders uniforms:
					// https://api.openfl.org/openfl/display/ShaderParameter.html

					var name = expect("uniform name", nextToken);

					var range = null;
					var isColor = false;
					glslStream.dropWhitespace();
					// handle a Godot-syntax hint_ annotation
					if (glslStream.startsWith(":")) {
						dropNext(":");
						glslStream.dropWhitespace();
						if (glslStream.startsWith("hint_range")) {
							switch (uType) {
								case "float":
									hInterp.variables["hint_range"] = hint_range_float;
								case "int":
									hInterp.variables["hint_range"] = hint_range_int;
								default:
									throw 'hint_range is only valid on int/float uniforms';
							}
							range = hInterp.execute(hParser.parseString(expect("hint_range() expression", glslStream.takeUntilAndDrop.bind(")")) + ")"));
						} else if (glslStream.startsWith("hint_color")) {
							dropNext("hint_color");
							isColor = true;
						}
					}

					dropNext("=");
					var expression = expect("uniform default value", glslStream.takeUntilAndDrop.bind(";"));

					var suffix = "";
					var propGenerated = true;

					function simpleProperty(_type:String) {
						var propName = '${name}${_type}';
						switch (_type) {
							case "Bool":
								uniformMapExps.push(macro $v{propName} => ${macro kiss_flixel.shaders.Uniform.Boolean});
							case "Int" | "Float" if (range != null):
								uniformMapExps.push(macro $v{propName} => $range);
							case "Int":
								uniformMapExps.push(macro $v{propName} => ${macro kiss_flixel.shaders.Uniform.AnyInt});
							case "Float":
								uniformMapExps.push(macro $v{propName} => ${macro kiss_flixel.shaders.Uniform.AnyFloat});
							default:
								throw 'not a simpleProperty type: $_type';
						}
						suffix = _type;
						type.fields.push({
							pos: pos,
							name: propName,
							kind: FProp("get", "set", Helpers.parseComplexType('Null<$_type>')),
							access: [APublic]
						});
						var jsonType = {
							pack: ["kiss_tools"],
							name: "Json" + _type
						};
						type.fields.push({
							pos: pos,
							name: 'set_${name}${_type}',
							kind: FFun({
								args: [{type: Helpers.parseComplexType('Null<$_type>'), name: "value"}],
								expr: macro {
									this.data.$name.value = [value];
									this.json?.put($v{propName}, new kiss_tools.JsonString(new $jsonType(value).stringify()));
									return value;
								}
							})
						});
						type.fields.push({
							pos: pos,
							name: 'get_${name}${_type}',
							kind: FFun({
								args: [],
								expr: macro {
									var v = this.data.$name.value;
									return if (v == null || v.length == 0)
										null;
									else
										v[0];
								} 
							})
						});
					}

					function flxPointProperty() {
						suffix = "FlxPoint";
						var propName = '${name}${suffix}';
						uniformMapExps.push(macro $v{propName} => ${macro kiss_flixel.shaders.Uniform.Vector2});

						var _type = "flixel.math.FlxPoint";
						type.fields.push({
							pos: pos,
							name: propName,
							kind: FProp("get", "set", Helpers.parseComplexType('Null<$_type>')),
							access: [APublic]
						});
						type.fields.push({
							pos: pos,
							name: 'set_${name}${suffix}',
							kind: FFun({
								args: [{type: Helpers.parseComplexType('Null<$_type>'), name: "value"}],
								expr: macro {
									this.data.$name.value = [value.x, value.y];
									return value;
								}
							})
						});
						type.fields.push({
							pos: pos,
							name: 'get_${name}${suffix}',
							kind: FFun({
								args: [],
								expr: macro {
									var components = this.data.$name.value;
									return flixel.math.FlxPoint.get(components[0], components[1]);
								}
							})
						});
					}
					function flxColorProperty(withAlpha:Bool) {
						suffix = "FlxColor";
						var propName = '${name}${suffix}';
						if (isColor) {
							if (withAlpha) {
								uniformMapExps.push(macro $v{propName} => ${macro kiss_flixel.shaders.Uniform.ColorWithAlpha});
							} else {
								uniformMapExps.push(macro $v{propName} => ${macro kiss_flixel.shaders.Uniform.ColorSolid});
							}
						} else {
							uniformMapExps.push(macro $v{propName} => ${macro kiss_flixel.shaders.Uniform.Vector3});
						}

						var _type = "flixel.util.FlxColor";
						type.fields.push({
							pos: pos,
							name: propName,
							kind: FProp("get", "set", Helpers.parseComplexType('Null<$_type>')),
							access: [APublic]
						});
						type.fields.push({
							pos: pos,
							name: 'set_${name}${suffix}',
							kind: FFun({
								args: [{type: Helpers.parseComplexType('Null<$_type>'), name: "value"}],
								expr: macro {
									if (!$v{withAlpha} && value.alphaFloat != 1.0) {
										throw "vec3 uniform cannot be assigned to a color with transparency";
									} 
									this.json?.put($v{propName}, new kiss_tools.JsonString(new JsonFlxColor(value).stringify()));
									if ($v{withAlpha}) {
										this.data.$name.value = [value.redFloat, value.greenFloat, value.blueFloat, value.alphaFloat];
										return value;
									} else {
										this.data.$name.value = [value.redFloat, value.greenFloat, value.blueFloat];
										return value;
									}
								}
							})
						});
						type.fields.push({
							pos: pos,
							name: 'get_${name}${suffix}',
							kind: FFun({
								args: [],
								expr: macro {
									var components = this.data.$name.value;
									if (components == null || components.length == 0)
										return null;
									var alpha = if ($v{withAlpha}) components[3] else 1.0;
									return flixel.util.FlxColor.fromRGBFloat(components[0], components[1], components[2], alpha);
								}
							})
						});
					}
					switch (uType) {
						case "float":
							simpleProperty("Float");
						case "bool":
							simpleProperty("Bool");
						case "int":
							simpleProperty("Int");
						case "vec2":
						  	flxPointProperty();
						case "vec3":
							flxColorProperty(false);
						case "vec4":
							flxColorProperty(true);
						default:
							propGenerated = false;
					}

					if (propGenerated) {
						var expressionInterpreted = hInterp.execute(hParser.parseString(expression));

						var primitives = ["float", "int", "bool"];
						if (primitives.contains(uType)) {
							expressionInterpreted = macro $v{expressionInterpreted};
						}

						var propName = macro $i{name + suffix};
						defaultSetterExps.push(macro if ($propName == null) $propName = $expressionInterpreted);
					} else {
						trace('Warning! uniform $uType $name in $file may have its default value of ${expression} ignored!');
					}

					transformedCode += 'uniform $uType $name;';
				case Some(other):
					transformedCode += other;
				default:
			}
		}

		transformedCode = "#pragma header\n" + transformedCode;

		var metaName = if (vertexExtensions.contains(extension)) ":glVertexSource" else if (fragmentExtensions.contains(extension)) ":glFragmentSource" else
			throw 'Unknown extension .${extension}';

		var meta = {
			pos: pos,
			name: metaName,
			params: [
				{
					pos: pos,
					expr: EConst(CString(transformedCode))
				}
			]
		};

		type.fields.push({
			pos: pos,
			name: "new",
			meta: [meta],
			kind: FFun({
				args: [{
					name: "camera",
					opt: true
				}, {
					name: "jsonMapFile",
					opt: true
				}],
				expr: macro {
					this.uniforms = [$a{uniformMapExps}];
					super(jsonMapFile);
					$b{defaultSetterExps};
                    data.iTime.value = [0.0];
					if (camera == null) {
						camera = flixel.FlxG.camera;
					}
					this.camera = camera;
					data.cameraPos.value = [camera.viewLeft, camera.viewTop];
					data.cameraZoom.value = [1.0];
				}
			}),
			access: [APublic]
		});

		// trace([for (field in type.fields) field.name]);
	}

	static function use() {
		tink.SyntaxHub.frontends.whenever(new ShaderFrontend());
	}
}
