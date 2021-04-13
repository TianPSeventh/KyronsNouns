extends PopupPanel

var execFunc = null
var execElseFunc = null

func alertBase(alertType:int, context:String, headerTitle:String = "Notifictation", textTitle:String = "", input = null, elseInput = null):
	if textTitle != "":
		$MC/VB/Title.text = textTitle
	else:
		$MC/VB/Title.hide()
	$MC/VB/SC/Text.text = context
	execFunc = input
	execElseFunc = elseInput
	$MC/VB/header.text = headerTitle
	match alertType:
		0:
			$MC/VB/Close.show()
		1:
			$MC/VB/bool.show()
		2:
			$MC/VB/branch.show()
	popup_centered()

func click():
	#BGM.click()
	pass

func _on_Close_pressed():
	queue_free()

func confirmChoice(extra_arg_0):
	GM.execRefFunc(execFunc if extra_arg_0 else execElseFunc)
	_on_Close_pressed()
