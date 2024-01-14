package kiss_flixel;

import tink.syntaxhub.*;
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.Expr.ImportMode;
using StringTools;
using tink.MacroApi;

class ShaderFrontend implements FrontendPlugin {
 
	public function new() {}
	
    var vertexExtensions = ["v.glsl", "vert"]; 
    var fragmentExtensions = ["f.glsl", "frag"];

	public function extensions() {
		return vertexExtensions.concat(fragmentExtensions).iterator();
	}
	
	public function parse(file:String, context:FrontendContext):Void {
        var extension = file.substr(file.indexOf(".") + 1);
        trace(extension);

		final type = context.getType();
        var parentClass = 'flixel.system.FlxAssets.FlxShader';
        type.kind = TDClass(parentClass.asTypePath(), [], false, false, false);

        var pos = Context.makePosition({ file: file, min: 0, max: 0 });
		
        var metaName = if (vertexExtensions.contains(extension)) 
            ":glVertexSource"
        else if (fragmentExtensions.contains(extension))
            ":glFragmentSource"
        else
            throw "Unknown extension";

        var meta = {
            pos: pos,
            name: metaName,
            params: [
                {
                    pos: pos,
                    expr: EConst(CString(sys.io.File.getContent(file)))
                }
            ]
        };

        type.fields.push({
            pos: pos,
            name: "new",
            meta: [meta],
            kind: FFun({
                args: [],
                expr: macro { super(); }
            }),
            access: [APublic]
        });
	}

	static function use() {
		tink.SyntaxHub.frontends.whenever(new ShaderFrontend());
	}
}