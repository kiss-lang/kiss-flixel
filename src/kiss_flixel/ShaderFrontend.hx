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

	var vertexExtensions = ["v.glsl", "vert"];
	var fragmentExtensions = ["f.glsl", "frag"];

	public function extensions() {
		return vertexExtensions.concat(fragmentExtensions).iterator();
	}

	public function parse(file:String, context:FrontendContext):Void {
		var extension = file.withoutDirectory().substr(file.withoutDirectory().indexOf(".") + 1);
		trace(extension);

		final type = context.getType();
		var parentClass = 'flixel.system.FlxAssets.FlxShader';
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

				// Not totally sure this actually is a 1-to-1 equivalency:
				case Some("SCREEN_UV"):
					transformedCode += "openfl_TextureCoordv";
				case Some("SCREEN_PIXEL_SIZE"):
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
					dropNext("=");
					var expression = expect("uniform default value", glslStream.takeUntilAndDrop.bind(";"));

					var suffix = "";
					var propGenerated = true;

					function simpleProperty(_type:String) {
						suffix = _type;
						type.fields.push({
							pos: pos,
							name: '${name}${_type}',
							kind: FProp("get", "set", Helpers.parseComplexType(_type)),
							access: [APublic]
						});
						type.fields.push({
							pos: pos,
							name: 'set_${name}${_type}',
							kind: FFun({
								args: [{type: Helpers.parseComplexType(_type), name: "value"}],
								expr: macro {this.data.$name.value = [value]; return value;}
							})
						});
						type.fields.push({
							pos: pos,
							name: 'get_${name}${_type}',
							kind: FFun({
								args: [],
								expr: macro return this.data.$name.value[0]
							})
						});
					}

					function flxPointProperty() {
						suffix = "FlxPoint";
						var _type = "flixel.math.FlxPoint";
						type.fields.push({
							pos: pos,
							name: '${name}${suffix}',
							kind: FProp("get", "set", Helpers.parseComplexType(_type)),
							access: [APublic]
						});
						type.fields.push({
							pos: pos,
							name: 'set_${name}${suffix}',
							kind: FFun({
								args: [{type: Helpers.parseComplexType(_type), name: "value"}],
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
						var _type = "flixel.util.FlxColor";
						type.fields.push({
							pos: pos,
							name: '${name}${suffix}',
							kind: FProp("get", "set", Helpers.parseComplexType(_type)),
							access: [APublic]
						});
						type.fields.push({
							pos: pos,
							name: 'set_${name}${suffix}',
							kind: FFun({
								args: [{type: Helpers.parseComplexType(_type), name: "value"}],
								expr: macro {
									if ($v{withAlpha}) {
										this.data.$name.value = [value.redFloat, value.greenFloat, value.blueFloat, value.alphaFloat];
										return value;
									} else if (value.alphaFloat != 1.0) {
										throw "vec3 uniform cannot be assigned to a color with transparency";
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

						defaultSetterExps.push(macro $i{name + suffix} = $expressionInterpreted);
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
				}],
				expr: macro {
					super();
                    data.iTime.value = [0.0];
					if (camera == null) {
						camera = flixel.FlxG.camera;
					}
					this.camera = camera;
					data.cameraPos.value = [camera.viewLeft, camera.viewTop];
					data.cameraZoom.value = [1.0];
					$b{defaultSetterExps}
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
