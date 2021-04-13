extends MarginContainer

func _enter_tree():
	GData.activeScene = self
	$VB/HBoxContainer/Selector.initSelection(["Uppercase","Lowercase","Capitalize"],[GData, "setMode"])
	while $VB/HBoxContainer/Selector.getCurrent() != GData.mode:
		$VB/HBoxContainer/Selector.nextItem(true)
	$VB/Hints/Toggle.set_pressed(GData.hints)

func _on_Start_pressed():
	GData.hints = $VB/Hints/Toggle.pressed
	GData.running = true
	GM.changeScene(self,"res://scene/game.tscn")


func _on_Button_pressed():
	if !GData.visible:
		GData.toggleOptions()
