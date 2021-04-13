extends "res://scripts/global/constants.gd"
#Description: Collection of global functions.

##################
#Statix Functions#
##################

static func randomNumber(limit:int = 0) -> int:
	#Author: Christian Quiel Panuncillo
	#Date: 23/08/2020
	#Description: Returns a random number based on seconds and the randi().
	var ret = randi() + OS.get_time().hour + OS.get_time().second + OS.get_time().minute +  OS.get_date().day
	return (ret % limit if limit != 0 else ret)

static func randomFloat(limit:int = 0) -> float:
	var ret  = (randomNumber() / OS.get_time().second * 0.00001) + randf() + randomNumber()
	
	while ret > limit && limit != 0:
		var temp = int(ret)
		ret = (temp % limit) + (ret - temp)
	return ret

static func randomBool(skew:float = -1.0) -> bool:
	var ret = (randomNumber(100) > 50)
	
	if skew > 0.0:
		skew = (skew - int(skew)) if skew > 1.0 else skew
		ret = randomFloat(1) <= skew
	return ret 

static func decArrayFloat(rawArr:Array, decVal:float, limit:int = -1):
	for x in range(rawArr.size()):
		rawArr[x] -= abs(decVal)
		rawArr[x] = rawArr[x] if rawArr[x] > limit else float(limit)
	return rawArr

static func incArrayFloat(rawArr:Array, decVal:float, limit:int = 1):
	for x in range(rawArr.size()):
		rawArr[x] += abs(decVal)
		rawArr[x] = rawArr[x] if rawArr[x] < limit else float(limit)
	return rawArr

static func arrayRandF(input:int = 2) -> Array:
	var ret = []
	var allot = 0.0
	
	for x in range(input):
		var temp = x
		temp = -(randomFloat(1) / 2.0)
		allot += temp
		ret.push_back(temp)
	while allot != 0.0 and allot != -0.0 and allot != -0:
		var temp = randomFloat(1)
		var temp2 = randomNumber(input)
		
		if allot + temp >= 0.0:
			temp = abs(allot)
			allot =  0.0
		else:
			allot += temp
		if ret[temp2] + temp > 1.0:
			allot -= (ret[temp2] + temp - 1.0)
			ret[temp2] = 1.0
		else:
			ret[temp2] += temp
	return ret

static func centralizeRange(input1, input2):
	#Author: Christian Quiel Panuncillo
	#Date: 23/08/2020
	#Description: Returns the middle number of the two inputs.
	return input1 + ((input2 - input1) / 2.0)

static func writeToFile(data, fileDir, fileName:String, appendFile:bool, saveAsText:bool) -> void:
	#Author: Christian Quiel Panuncillo
	#Date: 29/08/2020
	#Description: save data to files.
	#Dependancies: logError()
	var directory
	var filePath := "user://"
	var file := File.new()
	
	#Enter or Create File Directory To save
	if fileDir != null && typeof(fileDir) == TYPE_STRING:
		filePath = "user://%s" % fileDir
		directory = Directory.new()
		#Create Directory if it doesnt exist
		if not directory.dir_exists(filePath):
			directory.make_dir_recursive(filePath)
	
	#Append file name to file path
	filePath = filePath.plus_file(fileName)
	
	#Filter data if its null
	if data == null || (!saveAsText && appendFile):
		var temp = [("Appending" if appendFile else "Writing"),
					"Null data argument " if data == null else "",
					filePath,
					"Can't use append on variable type data." if (!saveAsText && appendFile) else ""]
		logError("[Error]: Function \"writeToFile\", %s %sto \"%s\" has failed.%s" % temp)
		
	#Running code
	else:
		if (file.open(filePath, File.READ_WRITE) != OK):
			var temp = file.open(filePath, File.WRITE)
			
			if temp != OK:
				logError("[Error]: Function \"writeToFile\" has failed.\n[Error Code: %d]" % temp)
		if saveAsText:
			if typeof(data) != TYPE_STRING:
				data = str(data)
			if appendFile:
				file.seek_end()
			file.store_line(data)
		else:
			file.store_var(data)
		file.close()

static func readFile(fileName:String, asText:bool, spamError:bool):
	#Author: Christian Quiel Panuncillo
	#Date: 29/08/2020
	#Description: Reads data from files and returns it as either text or variable.
	#Dependancies: logError()
	
	var file = File.new()
	var retData = null
	
	fileName = "user://%s" % fileName
	
	if file.open(fileName, File.READ) == OK:
		retData = file.get_as_text() if asText else file.get_var()
		file.close()
	elif spamError:
		logError("[Error]: Function \"readFile\", reading data from '"+fileName+"' failed.")
	return retData

static func logError(errorMassage:String) -> void:
	#Author: Christian Quiel Panuncillo
	#Date: 29/08/2020
	#Description: Logs errors into a error file respective to the date the function was called.
	#Dependancies: writeToFile()
	
	var fileName = "ErrorLog#("
	var months = [
		null, "January", "February", "March", 
		"April", "May", "June", "July", "August", 
		"September", "October", "November", "December"
	]
	
	fileName += "%s-%s-%s)"%[months[OS.get_datetime()["month"]],str(OS.get_datetime()["day"]),str(OS.get_datetime()["year"])]
	errorMassage = "(" + str(OS.get_time().hour) +":" + str(OS.get_time().minute) + ":"+ str(OS.get_time().second) + ") : " + errorMassage 
	print(errorMassage)
	writeToFile(errorMassage, "ErrorLogs/", fileName+".txt", true, true)

static func saveGame() -> void:
	writeToFile(GData.Data, "saves", "game.dat", false, false)

static func loadGame() -> void:
	GData.Data = readFile("saves/game.dat", false, false)

static func saveOptions() -> void:
	writeToFile(GData.Options, null, "option.dat", false, false)

static func loadOptions() -> void:
	GData.Options = readFile("option.dat", false, false)

static func changeScene(caller:Node, scene:String) -> void:
	#Author: Christian Quiel Panuncillo
	#Date: 29/08/2020
	#Description: Changes scene to new scene
	#Dependancies: logError()
	
	var temp = caller.get_tree().change_scene(scene)
	
	if temp != OK:
		logError("[Error]: Function \"changeScene\", return data of native function \"change_scene\" equals \"%s\"." % temp)
	else:
		caller.get_tree().paused = false

static func toggleVisibility(obj:Node) -> void:
	#Author: Christian Quiel Panuncillo
	#Date: 08/10/2020
	#Description: toggles the visibility of a node
	#Dependancies: logError()
	
	if obj != null:
		obj.visible = !obj.visible
	else:
		logError("[Error]: Function toggleVisibility, passed object is null.")

static func execRefFunc(execFunc) -> void:
	if execFunc != null:
		if execFunc.get_class() == "FuncRef":
			execFunc.call_func()
		else:
			execFunc.run_()

static func stringToArray(inputted:String) -> Array:
	var ret:Array = []
	
	for x in inputted:
		ret.push_back(x)
	return ret

static func setAllColor(receiver:Array, newColor:Array):
	#Author: Christian Quiel Panuncillo
	#Date: 2/09/2020
	#Description: Sets color to array of nodes with color properties or an array of colors.
	#Dependancies: logError()
	var check1 = typeof(receiver[0])
	var check2 = typeof(newColor[0])
	
	if (check1 == 17 || check1 == 14) && (check2 == 17 || check2 == 14):
		for x in range(receiver.size()):
			if typeof(receiver[x]) == 17:
				receiver[x].set_pick_color(newColor[x] if typeof(newColor[x]) == 14 else newColor[x].color)
			else:
				receiver[x] = newColor[x] if typeof(newColor[x]) == 14 else newColor[x].color
	else:
		logError("[Error]: Function \"setAllColor\", invalid input/s.")

static func remove_children(node: Node) -> void:
	for idx in node.get_children():
		idx.free()

static func convertToTime(sec:int) -> String:
	return "%02.0f:%02.0f:%02.0f" % [float(sec) / 360.0, float(sec) / 60.0, sec % 60]

func quitGame():
	get_tree().paused = true
	get_tree().queue_delete(get_tree())
	get_tree().quit()

###################
#Dynamic Functions#
###################

func alert(input:Array) -> void:
	var temp = load("res://prefabs/menus/Alert.tscn").instance()
	
	GData.activeScene.add_child(temp)
	match input.size():
		1:
			temp.alertBase(0,input[0])
		2:
			temp.alertBase(0,input[0],input[1])
		3:
			temp.alertBase(0,input[0],input[1],input[2])
		4:
			temp.alertBase(0,input[0],input[1],input[2],input[3])
		_:
			logError("[Error]: Invalid input size in function \"alert\"")

func alertBool(input:Array) -> void:
	var temp = load("res://prefabs/menus/Alert.tscn").instance()
	
	GData.activeScene.add_child(temp)
	match input.size():
		1:
			temp.alertBase(1,input[0])
		2:
			temp.alertBase(1,input[0],input[1])
		3:
			temp.alertBase(1,input[0],input[1],input[2])
		4:
			temp.alertBase(1,input[0],input[1],input[2],input[3])
		_:
			logError("[Error]: Invalid input size in function \"alertBool\"")

func alertBranch(input:Array) -> void:
	var temp = load("res://prefabs/menus/Alert.tscn").instance()
	
	GData.activeScene.add_child(temp)
	match input.size():
		1:
			temp.alertBase(2,input[0])
		2:
			temp.alertBase(2,input[0],input[1])
		3:
			temp.alertBase(2,input[0],input[1],input[2])
		4:
			temp.alertBase(2,input[0],input[1],input[2],input[3])
		5:
			temp.alertBase(2,input[0],input[1],input[2],input[3],input[4])
		_:
			logError("[Error]: Invalid input size in function \"alertBranch\"")
