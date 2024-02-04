package kiss_flixel;

import tink.syntaxhub.*;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Expr.ImportMode;
import kiss.Stream;

using StringTools;
using haxe.io.Path;
using tink.MacroApi;

class ShaderFrontend implements FrontendPlugin {
	public function new() {}

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
		transformedCode += 'uniform float iTime = 0.0;\n';
		transformedCode += 'uniform vec2 cameraPos = vec2(0.0, 0.0);\n';
		type.fields.push({
			pos: pos,
			name: "__update",
			kind: FFun({
				args: [],
				expr: macro {
					super.__update();
					data.iTime.value = [data.iTime.value[0] + flixel.FlxG.elapsed];
					data.cameraPos.value = [camera.scroll.x, camera.scroll.y];
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

		var delimiters = ",.(){}[] \t\n;?:|&<>/*+-'\"=".split("");

		var colorOut = "";
		var coordIn = "";


        function nextToken() {
            glslStream.dropWhitespace();
            return glslStream.takeUntilOneOf(delimiters);
        }

        function dropNext(delim:String) {
            glslStream.dropWhitespace();
            glslStream.dropString(delim);
        }

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

				case Some("iResolution"):
					transformedCode += "openfl_TextureSize";

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
                    transformedCode += "main() ";

                case Some(name) if (name == colorOut):
                    transformedCode += "gl_FragColor";
                case Some(name) if (name == coordIn):
                    transformedCode += "openfl_TextureCoordv * openfl_TextureSize";

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
					data.cameraPos.value = [camera.scroll.x, camera.scroll.y];
				}
			}),
			access: [APublic]
		});
	}

	static function use() {
		tink.SyntaxHub.frontends.whenever(new ShaderFrontend());
	}
}
