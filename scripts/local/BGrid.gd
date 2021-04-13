extends Button


func _enter_tree():
	add_to_group("keyButtons")

func buttonPress(bText:String = text):
	owner.checkLetter(bText)

func capitalizeKB(first:bool):
	text = text.to_upper() if first else text.to_lower()

func uppercaseKB():
	text = text.to_upper()

func lowercaseKB():
	text = text.to_lower()
