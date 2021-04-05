extends MarginContainer


func _on_Start_pressed():
	GData.hints = $VB/Hints/Toggle.pressed
	GM.changeScene(self,"res://scene/game.tscn")
