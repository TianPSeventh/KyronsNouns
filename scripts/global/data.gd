extends Control
#Contains all the variabled data

signal screen_orientation_changed

var Options = null
var Data = null
var BGME = "BGME"
var BGMQueue := []
var LandscapeMode:bool = true
var OrientationSensor = true
var ListOfNodesAffectedByOrientation: Array = []
var hints:bool = true


func reloadOrientation() -> void:
	OrientationLandscape(true if OS.window_size.x > OS.window_size.y else false)

func fontResize():
	var addSize = (OS.window_size.x if OS.window_size.x >  OS.window_size.y else OS.window_size.y) / 1024
	load("res://assets/font/dynamic/large.tres").set("size", 40 * addSize)
	load("res://assets/font/dynamic/medium.tres").set("size", 29 * addSize)
	load("res://assets/font/dynamic/small.tres").set("size", 21 * addSize)
	load("res://assets/font/dynamic/xLarge.tres").set("size", 53 * addSize)

func _ready():
	fontResize()
	var temp = get_viewport()
	$MC/MC2/VB/Orientation/Selector.initSelection(["Sensored","Landscape","Portrait"], [self,"setOrientationMode"])
	temp.connect("size_changed", self, "_on_size_changed")

func _on_size_changed():
	emit_signal("screen_orientation_changed",  true if OS.window_size.x >  OS.window_size.y else false)
	return   # somehow function triggers twice

func openOptions(OpenOption:bool = true):
	if get_index() != get_parent().get_child_count() - 1:
		get_parent().move_child(self, get_parent().get_child_count() - 1)
	funcref(self,"show" if OpenOption else "hide").call_func()

func toggleOptions():
	openOptions(!visible)

func _on_options_visibility_changed():
	get_tree().paused = visible

func changeAndPlayBGME(inputted:String, path:String = "Letters"):
	get_node(BGME).stop()
	get_node(BGME).stream = load("res://assets/bgm/%s/%s.wav" % [path,inputted])
	get_node(BGME).play()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		GM.quitGame()

func _on_Quit_pressed():
	GM.quitGame()

func _on_Main_pressed():
	ListOfNodesAffectedByOrientation.clear()
	GM.changeScene(self,"res://scene/main.tscn")

func setOrientationMode(raw):
	var newOrient
	
	OrientationSensor = false
	match raw.front():
		"Landscape":
			newOrient = true
		"Portrait":
			newOrient = false
		"Sensored":
			OrientationSensor = true
			newOrient = true if OS.window_size.x >  OS.window_size.y else false
	OrientationLandscape(newOrient)

func OrientationLandscape(button_pressed):
	fontResize()
	LandscapeMode = button_pressed
	for x in ListOfNodesAffectedByOrientation:
		x.changeOrientation(button_pressed)

func declareAnswer(Inputted:Array):
	BGMQueue.push_back(Inputted)

func _on_BGME_finished():
	var BGMTemp:FuncRef
	
	if !BGMQueue.empty():
		if BGMQueue.front().size() == 2:
			changeAndPlayBGME(BGMQueue.front().pop_front(), "Word")
		else:
			BGMTemp = BGMQueue.pop_front().front()
			BGMTemp.call_func()

func _on_options_screen_orientation_changed(orientation):
	if OrientationSensor:
		OrientationLandscape(orientation)
