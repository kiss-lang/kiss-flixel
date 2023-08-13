package node.vm;

typedef ModuleLinker = (specifier:String, referencingModule:Module, extra:{ var assert : Dynamic; }) -> ts.AnyOf2<Module, js.lib.Promise<Module>>;