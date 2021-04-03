extends Control
#Contains all the variabled data

const WINDOW_SIZE := OS.window_size

var Options = null
var Data = null
var BGME = "BGME"
var LandscapeMode:bool = false
var ListOfNodesAffectedByOrientation: Array = []




#func _ready():
#	get_viewport().connect("size_changed", self, "_on_size_changed")

#func _on_size_changed():
#	var s := OS.window_size
#
#	#emit_signal("screen_orientation_changed",  "landscape" if WINDOW_SIZE.x < s.x else "portrait")
#	return   # somehow function triggers twice

func openOptions(OpenOption:bool = true):
	if get_index() != get_parent().get_child_count() - 1:
		get_parent().move_child(self, get_parent().get_child_count() - 1)
	funcref(self,"show" if OpenOption else "hide").call_func()

func toggleOptions():
	openOptions(!visible)

func _on_options_visibility_changed():
	get_tree().paused = visible

func changeAndPlayBGME(inputted:String):
	get_node(BGME).stop()
	get_node(BGME).stream = load("res://assets/bgm/Letters/%s.wav" % inputted)
	get_node(BGME).play()

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		GM.quitGame()


func _on_Quit_pressed():
	GM.quitGame()


func _on_Main_pressed():
	GM.changeScene(self,"res://scene/main.tscn")


func OrientationLandscape(button_pressed):
	LandscapeMode = button_pressed
	
	for x in ListOfNodesAffectedByOrientation:
		x.changeOrientation(button_pressed)


func _on_BGME_finished():
	pass # Replace with function body.
