extends MarginContainer

var time:int = 0
var current:int = 0
var stageNum:int = 1
var target:String = ""
var list:Array = GM.nouns.duplicate()
var hintBox:PackedScene = load("res://prefabs/menus/Label.tscn")
var hintArray:Array = []
var keyboard:bool = true
var keys = "VB/Keys"
var hiddenLetters = "VB/HB"
var timeLabel = "VB/Header/Time"
var stageLabel = "VB/Header/StageLabel"

func changeOrientation(landscape:bool = false):
	$VB/Keys.visible = !landscape
	$VB/Keyboard.visible = landscape

func setChoices() -> void:
	var letters:Array = GM.letters.duplicate()
	var ret:Array = [target[current].capitalize()]
	
	letters.shuffle()
	while ret.size() < 9:
		if ret.has(letters.front()):
			letters.shuffle()
		else:
			ret.push_back(letters.pop_front())
	for x in get_node(keys).get_children():
		ret.shuffle()
		x.text = ret.pop_front()

func setHint():
	$VB/MC/Img.texture = load("res://assets/2D/%s.png" % target)

func setStage():
	var tempHolder:HBoxContainer = get_node(hiddenLetters)
	var temp:int = GM.randomNumber(list.size())
	
	keyboard = true
	target = list[temp]
	list.erase(target)
	current = 0
	hintArray = []
	GM.remove_children(tempHolder)
	for x in target:
		hintArray.push_back(hintBox.instance())
		hintArray.back().text = x
		tempHolder.add_child(hintArray.back())
	setChoices()
	setHint()
	get_node(stageLabel).text = "Stage: %d" % stageNum
	stageNum += 1
	if list.empty():
		list = GM.nouns.duplicate()

func _enter_tree():
	GData.ListOfNodesAffectedByOrientation.push_back(self)
	setStage()
	GData.reloadOrientation()

func checkLetter(bText:String):
	if keyboard:
		GData.changeAndPlayBGME(bText)
		if get_node(hiddenLetters).get_child(current).text.capitalize() == bText.capitalize():
			get_node(hiddenLetters).get_child(current).showFull()
			current += 1
			if current < target.length():
				setChoices()
			else:
				keyboard = false
				GData.declareAnswer([target, funcref(self, "setStage")])


func _on_Timer_timeout():
	time += 1
	get_node(timeLabel).text = GM.convertToTime(time)


func _on_Pause_pressed():
	if !GData.visible:
		GData.toggleOptions()

