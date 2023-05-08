extends Node

#Movement has value 1, Jitter has value 2, value 3 means both are TRUE
export(int, FLAGS, "Movement", "Jitter") var Track = 1

#Variables for different object (VRcamera, VRcontrollers)
export(String) var Object1Path = "/root/"
export(String) var Object2Path = "/root/"
export(String) var Object3Path = "/root/"

onready var obj1 = get_node(Object1Path)
onready var obj2 = get_node(Object1Path)
onready var obj3 = get_node(Object1Path)

#Variables
var path = ""
var counter = ""
var date
var timer 
var timer_tick = 0
var file_obj1
var file_obj2
var file_obj3
var file_obj1_changes
var file_obj2_changes
var file_obj3_changes
var file_obj1_SD
var file_obj2_SD
var file_obj3_SD
var time
var obj1_movement_array = []
var obj1_rotation_array = []
var obj2_movement_array = []
var obj2_rotation_array = []
var obj3_movement_array = []
var obj3_rotation_array = []
var time_return_array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	#file.open("res://addons/movement_tracker/Data//data.txt", File.WRITE)
	#set_process(false)	
	pass # Replace with function body.

func _configure_data_saving():
	path = "res://addons/movement_tracker/Data/"
	counter = load_file("res://addons/movement_tracker/id_counter.txt")
	
	var dir = Directory.new()
	dir.open(path)
	date = OS.get_datetime()
	var year = date["year"]
	var month = date["month"]
	var day = date["day"]
	path = path +str(year) + "_" + str(month) + "_" + str(day) +"_" + "User_" + str(counter) 
	dir.make_dir(str(year) + "_" + str(month) + "_" + str(day) +"_" + "User_" + str(counter) )
	
	timer = Timer.new()
	add_child(timer)
	timer.set_wait_time(0.1)
	timer.connect("timeout", self, "_on_Timer_timeout")

func load_file(file):
	var counter_return
	var f = File.new()
	f.open(file, File.READ)
	var index = 1
	while not f.eof_reached(): # iterate through all lines until the end of file is reached
		var line = f.get_line()
		line = int(line)+1
		#print(line)
		index += 1
		counter_return = line
	f.close()
	f.open(file, File.WRITE)
	f.store_string(str(counter_return))
	f.close()
	return counter_return

func _on_Timer_timeout():
	if(file_obj1 != null && file_obj1.is_open()):
		_collect_pos_ori_data(file_obj1,obj1)
	else:
		print("Object 1 not opened")
	if(file_obj2 != null && file_obj2.is_open()):
		_collect_pos_ori_data(file_obj2,obj2)
	else:
		print("Object 2 not opened")
	if(file_obj3 != null && file_obj3.is_open()):
		_collect_pos_ori_data(file_obj3,obj3)
	else:
		print("Object 3 not opened")
	timer_tick += 1

func _open_data_files(file_name):
	var file
	file = File.new()
	print(path)
	file.open(path + "/" + file_name + ".txt", File.WRITE)
	if(file_name == "obj1_pos_ori"):
		file.store_string("time,x_pos,y_pos,z_pos,x_ori,y_ori,z_ori\n")
	elif(file_name == "obj1_mov_rot_changes"):
		file.store_string("time,x_mov,y_mov,z_mov,x_rot,y_rot,z_rot\n")
	elif(file_name == "obj1_SD"):
		file.store_string("title,value\n")
	return file

func _collect_pos_ori_data(file,input):
	var movement
	var rotation
	var content 
	var time_return
	time = OS.get_time()
	time_return = String(time.hour) +":"+String(time.minute)+":"+String(time.second)
	time_return_array.append(time_return)
	#time_return = str(timer_tick)
	movement = str(input.transform.origin.x) + "," + str(input.transform.origin.y) + "," + str(input.transform.origin.z)
	obj1_movement_array.append(movement)
	rotation = str(input.rotation_degrees.x) + "," + str(input.rotation_degrees.y) + "," + str(input.rotation_degrees.z)
	obj1_rotation_array.append(rotation)
	content = time_return + "," + movement + "," + rotation + "\n"
	#print(content)
	file.store_string(content)
	pass

func _collect_mov_rot_data(input_array_mov,input_array_rot,file):
	var content 
	var change_mov_x
	var change_mov_y
	var change_mov_z
	var change_rot_x
	var change_rot_y
	var change_rot_z
	var splitted_data_past_mov
	var splitted_data_actual_mov
	var splitted_data_past_rot
	var splitted_data_actual_rot
	if(input_array_mov.size()>1):
		for i in input_array_mov.size():
			splitted_data_past_mov = input_array_mov[i-1].split(",")
			splitted_data_actual_mov = input_array_mov[i].split(",")
			splitted_data_past_rot = input_array_rot[i-1].split(",")
			splitted_data_actual_rot = input_array_rot[i].split(",")
			change_mov_x = float(splitted_data_past_mov[0])-float(splitted_data_actual_mov[0])
			change_mov_y = float(splitted_data_past_mov[1])-float(splitted_data_actual_mov[1])
			change_mov_z = float(splitted_data_past_mov[2])-float(splitted_data_actual_mov[2])
			change_rot_x = float(splitted_data_past_rot[0])-float(splitted_data_actual_rot[0])
			change_rot_y = float(splitted_data_past_rot[1])-float(splitted_data_actual_rot[1])
			change_rot_z = float(splitted_data_past_rot[2])-float(splitted_data_actual_rot[2])
			#print("split data: ", splitted_data_actual)
			#print("split data: ", splitted_data_past)
			#print("changex: ", change_mov_x)
			content = str(time_return_array[i]) + "," + str(change_mov_x) +"," + str(change_mov_y)+"," + str(change_mov_z) +"," + str(change_rot_x)+"," + str(change_rot_y)+"," + str(change_rot_z)+ "\n"
			file.store_string(content)
	file.close()
	pass

func _save_and_close_data():
	if(file_obj1!= null):
		file_obj1.close()
	if(file_obj2!= null):
		file_obj2.close()
	if(file_obj3!= null):
		file_obj3.close()

	if(file_obj1_changes != null && file_obj1_changes.is_open()):
		_collect_mov_rot_data(obj1_movement_array,obj1_rotation_array,file_obj1_changes)
	if(file_obj2_changes != null && file_obj2_changes.is_open()):
		_collect_mov_rot_data(obj1_movement_array,obj2_rotation_array,file_obj2_changes)
	if(file_obj3_changes != null && file_obj3_changes.is_open()):
		_collect_mov_rot_data(obj1_movement_array,obj3_rotation_array,file_obj3_changes)
	
	var duration = float(timer_tick)/10
	if(file_obj1_SD != null && file_obj1_SD.is_open()):
		var obj1_movement_array_X = _my_splitter(obj1_movement_array,0)
		var obj1_movement_array_Y = _my_splitter(obj1_movement_array,1)
		var obj1_movement_array_Z = _my_splitter(obj1_movement_array,2)
		var pos_changes_x = []
		var pos_changes_y = []
		var pos_changes_z = []
		for i in obj1_movement_array_X.size():
			if(i > 0):
				pos_changes_x.append(float(obj1_movement_array_X[i-1])-float(obj1_movement_array_X[i]))
				pos_changes_y.append(float(obj1_movement_array_Y[i-1])-float(obj1_movement_array_Y[i]))
				pos_changes_z.append(float(obj1_movement_array_Z[i-1])-float(obj1_movement_array_Z[i]))
		#print(pos_changes_x)
		#print(obj1_movement_array_X)
		#file_obj1_SD.store_string("SD mov x," + str(standard_deviation_calc(obj1_movement_array_X)) + "\n")
		file_obj1_SD.store_string("SD mov x," + str(standard_deviation_calc(pos_changes_x)) + "\n")
		file_obj1_SD.store_string("SD mov y," + str(standard_deviation_calc(pos_changes_y)) + "\n")
		file_obj1_SD.store_string("SD mov z," + str(standard_deviation_calc(pos_changes_z)) + "\n")
		var obj1_rotation_array_X = _my_splitter(obj1_rotation_array,0)
		var obj1_rotation_array_Y = _my_splitter(obj1_rotation_array,1)
		var obj1_rotation_array_Z = _my_splitter(obj1_rotation_array,2)
		var rot_changes_x = []
		var rot_changes_y = []
		var rot_changes_z = []
		for i in obj1_rotation_array_X.size():
			if(i > 0):
				rot_changes_x.append(float(obj1_rotation_array_X[i-1])-float(obj1_rotation_array_X[i]))
				rot_changes_y.append(float(obj1_rotation_array_Y[i-1])-float(obj1_rotation_array_Y[i]))
				rot_changes_z.append(float(obj1_rotation_array_Z[i-1])-float(obj1_rotation_array_Z[i]))
		file_obj1_SD.store_string("SD rot x," + str(standard_deviation_calc(rot_changes_x)) + "\n")
		file_obj1_SD.store_string("SD rot y," + str(standard_deviation_calc(rot_changes_y)) + "\n")
		file_obj1_SD.store_string("SD rot z," + str(standard_deviation_calc(rot_changes_z)) + "\n")
		file_obj1_SD.store_string("Duration(sec): " + str(duration) + "\n")
		#standard_deviation_calc(obj1_rotation_array)
	if(file_obj2_SD != null && file_obj2_SD.is_open()):
		var obj2_movement_array_X = _my_splitter(obj2_movement_array,0)
		var obj2_movement_array_Y = _my_splitter(obj2_movement_array,1)
		var obj2_movement_array_Z = _my_splitter(obj2_movement_array,2)
		var pos_changes_x = []
		var pos_changes_y = []
		var pos_changes_z = []
		for i in obj2_movement_array_X.size():
			if(i > 0):
				pos_changes_x.append(float(obj2_movement_array_X[i-1])-float(obj2_movement_array_X[i]))
				pos_changes_y.append(float(obj2_movement_array_Y[i-1])-float(obj2_movement_array_Y[i]))
				pos_changes_z.append(float(obj2_movement_array_Z[i-1])-float(obj2_movement_array_Z[i]))
		#print(pos_changes_x)
		#print(obj1_movement_array_X)
		#file_obj1_SD.store_string("SD mov x," + str(standard_deviation_calc(obj1_movement_array_X)) + "\n")
		file_obj2_SD.store_string("SD mov x," + str(standard_deviation_calc(pos_changes_x)) + "\n")
		file_obj2_SD.store_string("SD mov y," + str(standard_deviation_calc(pos_changes_y)) + "\n")
		file_obj2_SD.store_string("SD mov z," + str(standard_deviation_calc(pos_changes_z)) + "\n")
		var obj2_rotation_array_X = _my_splitter(obj2_rotation_array,0)
		var obj2_rotation_array_Y = _my_splitter(obj2_rotation_array,1)
		var obj2_rotation_array_Z = _my_splitter(obj2_rotation_array,2)
		var rot_changes_x = []
		var rot_changes_y = []
		var rot_changes_z = []
		for i in obj2_rotation_array_X.size():
			if(i > 0):
				rot_changes_x.append(float(obj2_rotation_array_X[i-1])-float(obj2_rotation_array_X[i]))
				rot_changes_y.append(float(obj2_rotation_array_Y[i-1])-float(obj2_rotation_array_Y[i]))
				rot_changes_z.append(float(obj2_rotation_array_Z[i-1])-float(obj2_rotation_array_Z[i]))
		file_obj2_SD.store_string("SD rot x," + str(standard_deviation_calc(rot_changes_x)) + "\n")
		file_obj2_SD.store_string("SD rot y," + str(standard_deviation_calc(rot_changes_y)) + "\n")
		file_obj2_SD.store_string("SD rot z," + str(standard_deviation_calc(rot_changes_z)) + "\n")
		file_obj2_SD.store_string("Duration(sec): " + str(duration) + "\n")
		#standard_deviation_calc(obj2_rotation_array)
	if(file_obj3_SD != null && file_obj3_SD.is_open()):
		var obj3_movement_array_X = _my_splitter(obj3_movement_array,0)
		var obj3_movement_array_Y = _my_splitter(obj3_movement_array,1)
		var obj3_movement_array_Z = _my_splitter(obj3_movement_array,2)
		var pos_changes_x = []
		var pos_changes_y = []
		var pos_changes_z = []
		for i in obj3_movement_array_X.size():
			if(i > 0):
				pos_changes_x.append(float(obj3_movement_array_X[i-1])-float(obj3_movement_array_X[i]))
				pos_changes_y.append(float(obj3_movement_array_Y[i-1])-float(obj3_movement_array_Y[i]))
				pos_changes_z.append(float(obj3_movement_array_Z[i-1])-float(obj3_movement_array_Z[i]))
		#print(pos_changes_x)
		#print(obj1_movement_array_X)
		#file_obj1_SD.store_string("SD mov x," + str(standard_deviation_calc(obj1_movement_array_X)) + "\n")
		file_obj3_SD.store_string("SD mov x," + str(standard_deviation_calc(pos_changes_x)) + "\n")
		file_obj3_SD.store_string("SD mov y," + str(standard_deviation_calc(pos_changes_y)) + "\n")
		file_obj3_SD.store_string("SD mov z," + str(standard_deviation_calc(pos_changes_z)) + "\n")
		var obj3_rotation_array_X = _my_splitter(obj3_rotation_array,0)
		var obj3_rotation_array_Y = _my_splitter(obj3_rotation_array,1)
		var obj3_rotation_array_Z = _my_splitter(obj3_rotation_array,2)
		var rot_changes_x = []
		var rot_changes_y = []
		var rot_changes_z = []
		for i in obj3_rotation_array_X.size():
			if(i > 0):
				rot_changes_x.append(float(obj3_rotation_array_X[i-1])-float(obj3_rotation_array_X[i]))
				rot_changes_y.append(float(obj3_rotation_array_Y[i-1])-float(obj3_rotation_array_Y[i]))
				rot_changes_z.append(float(obj3_rotation_array_Z[i-1])-float(obj3_rotation_array_Z[i]))
		file_obj3_SD.store_string("SD rot x," + str(standard_deviation_calc(rot_changes_x)) + "\n")
		file_obj3_SD.store_string("SD rot y," + str(standard_deviation_calc(rot_changes_y)) + "\n")
		file_obj3_SD.store_string("SD rot z," + str(standard_deviation_calc(rot_changes_z)) + "\n")
		file_obj3_SD.store_string("Duration(sec): " + str(duration) + "\n")
		#standard_deviation_calc(obj2_movement_array)
		#standard_deviation_calc(obj2_rotation_array)
	
	if(timer!=null):
		timer.stop()
		timer.queue_free()
		timer_tick = 0

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_SPACE:
			if(Track==0):
				print("Saved values not chosen!")
			else:
				print("Collecting movement data...")
				_configure_data_saving()
				if(Object1Path != "/root/"):
					if(Track==1 or Track == 3):
						file_obj1 = _open_data_files("obj1_pos_ori")
						file_obj1_changes = _open_data_files("obj1_mov_rot_changes")
					if(Track==2 or Track == 3):
						file_obj1_SD = _open_data_files("obj1_SD")
				else:
					print("Wrong path object 1")
				if(Object2Path != "/root/"):
					if(Track==1 or Track == 3):
						file_obj2 = _open_data_files("obj2_pos_ori")
						file_obj2_changes = _open_data_files("obj2_mov_rot_changes")
					if(Track==2 or Track == 3):
						file_obj2_SD = _open_data_files("obj2_SD")
				else:
					print("Wrong path object 2")
				if(Object3Path != "/root/"):
					if(Track==1 or Track == 3):
						file_obj2 = _open_data_files("obj3_pos_ori")
						file_obj3_changes = _open_data_files("obj3_mov_rot_changes")
					if(Track==2 or Track == 3):
						file_obj3_SD = _open_data_files("obj3_SD")
				else:
					print("Wrong path object 3")
				timer.start()
				#print(Object1Path)
				#print(obj1)
		if event.pressed and event.scancode == KEY_ESCAPE:
			_save_and_close_data()
			get_tree().quit()


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		_save_and_close_data()

func _my_splitter(array, split_index):
	var splitted_data
	var return_array = []
	if(array != null):
		for i in array.size():
			splitted_data = array[i].split(",")
			return_array.append(float(splitted_data[split_index]))
	return return_array

func standard_deviation_calc(movement):
	var mov_added = 0
	var mean
	var pow_array = []
	var sum = 0
	var sd
	
	for i in range(movement.size()):
		mov_added += movement[i]
	
	mean = mov_added/movement.size() 
	
	for i in range(movement.size()):
		pow_array.append(pow(movement[i]-mean,2))
		sum += pow_array[i]
	
	sd = sqrt(sum)
	return sd
