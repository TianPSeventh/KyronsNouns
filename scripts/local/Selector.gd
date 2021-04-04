extends HBoxContainer

var placeHolder:String = "No Item."
var selected:int = 0
var list:Array = []
var reaction = null

func initSelection(inputted:Array, inputReaction = null) -> void:
	list = inputted
	$Current.text = list.front()
	reaction = inputReaction

func setSelection(next:bool):
	if list.empty():
		$Current.text = placeHolder
	else:
		selected = (selected + (1 if next else -1)) % list.size()
		if selected < 0:
			selected += list.size()
		$Current.text = list[selected]
		if reaction != null:
			GM.funcRefArgu.newInit(reaction[0], reaction[1]).run_(list[selected])

func getCurrent():
	return list[selected]

func _ready():
	if list.empty():
		$Current.text = placeHolder
	else:
		$Current.text = list[selected]
