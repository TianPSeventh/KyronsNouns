extends PopupPanel
#Contains all the variabled data

var Options = null
var Data = null
var BGME = "BGME"
var LandscapeMode:bool = false
var ListOfNodesAffectedByOrientation: Array = []

func openOptions(OpenOption:bool = true):
	if OpenOption:
		popup_centered()
	else:
		hide()

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


func _on_Toggle_toggled(button_pressed):
	LandscapeMode = button_pressed
	for x in ListOfNodesAffectedByOrientation:
		x.changeOrientation(button_pressed)
