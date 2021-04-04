extends "res://scripts/global/methods.gd"


class funcRefArgu:
	var instance:Object
	var function:String
	var parameter:Array
	
	func run_(input = null) -> void:
		if input != null:
			parameter.push_back(input)
		instance.call(function, parameter)
	
	func _init(new_inst:Object = null, new_func:String = "", new_param:Array = []) -> void:
		instance = new_inst
		function = new_func
		parameter = new_param
	
	static func newInit(new_inst:Object, new_func:String, new_param:Array = [], newAFR = funcRefArgu.new()) -> funcRefArgu:
		newAFR._init(new_inst, new_func, new_param)
		return newAFR

