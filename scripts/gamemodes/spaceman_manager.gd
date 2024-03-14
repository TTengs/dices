extends Node

@onready var key1 = $CanvasLayer/VBoxContainer/HBoxContainer/Label2
@onready var key2 = $CanvasLayer/VBoxContainer/HBoxContainer/Label3
@onready var point1 = $CanvasLayer/VBoxContainer/HBoxContainer2/Label2
@onready var point2 = $CanvasLayer/VBoxContainer/HBoxContainer2/Label3
@onready var point3 = $CanvasLayer/VBoxContainer/HBoxContainer2/Label4

@onready var win_screen = $SpacemanWin

var Die = preload("res://Scenes/die.tscn")  # Replace with the path to your dice.gd script
var dice = []

var any_die_rolling

var picked_up_die = null
var game_camera = null

var is_mouse_on_key = false
var is_mouse_on_points = false

var key = 0
var point = 0

var key_is_chosen = false
var points_are_chosen = false

var has_chosen_die = true

signal dice_chosen(points)

func _on_die_roll_finished(value):
#Does nothing at the moment, maybe in future auto store the last die
	print(str(value))

func _ready():
	# Hide win screen
	win_screen.hide()
	# Instantiate the dice
	for i in range(5):  # Replace 2 with the number of dice you want
		var die = Die.instantiate()
		add_child(die)
		# Set the die's position
		die.global_transform.origin.y = 8
		die.global_transform.origin.z = randf_range(-0.5, 1.5)
		die.global_transform.origin.x = randf_range(-2, 2)
		dice.append(die)
		die.roll_finished.connect(_on_die_roll_finished)
		# Allow for mouse to pickup the dice
		die.pickup_die.connect(_on_pickup_die)
		die.drop_die.connect(_on_drop_die)

func _input(event):
	# Only allow _input if no die is rolling
	any_die_rolling = false
	for die in dice:
		if die.is_rolling:
			any_die_rolling = true
			break
	
	if event.is_action_pressed("ui_accept") && !any_die_rolling && has_chosen_die:
		for die in dice:
			die._roll()
			has_chosen_die = false

func _process(_delta):
	if picked_up_die && game_camera:
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_origin = game_camera.project_ray_origin(mouse_pos)
		var ray_direction = game_camera.project_ray_normal(mouse_pos)
		var plane = Plane(Vector3(0, 1, 0), Vector3(0, 4, 0))  # Replace with the desired plane for the die to move on
		var intersection = plane.intersects_ray(ray_origin, ray_direction)
		if intersection:
			picked_up_die.global_transform.origin = intersection
	
	if (dice.is_empty()):
		#maybe fix so it only call once
		_no_more_dice()

func _on_pickup_die(die, camera):
	if (!any_die_rolling):
		picked_up_die = die
		game_camera = camera

func _on_drop_die(die):
	picked_up_die = null
	
	# If dice is dropped on key, display this and remove the die
	if (is_mouse_on_key && !key_is_chosen):
		if (key1.text == ""):
			key1.text = str(die.side_up)
			dice.erase(die)
			die.queue_free()
			has_chosen_die = true
		else:
			key2.text = str(die.side_up)
			dice.erase(die)
			die.queue_free()
			has_chosen_die = true
			key_is_chosen = true
	
	# If dice is dropped on points, display this and remove die
	if (is_mouse_on_points && !points_are_chosen):
		if (point1.text == ""):
			point1.text = str(die.side_up)
			dice.erase(die)
			die.queue_free()
			has_chosen_die = true
		elif (point2.text == ""):
			point2.text = str(die.side_up)
			dice.erase(die)
			die.queue_free()
			has_chosen_die = true
		else:
			point3.text = str(die.side_up)
			dice.erase(die)
			die.queue_free()
			has_chosen_die = true
			points_are_chosen = true

func _no_more_dice():
	if (key_is_chosen && points_are_chosen):
		if ((int(key1.text) == 1  && int(key2.text) == 3) || (int(key1.text) == 3 && int(key2.text) == 1)):
			print("You have key")
			var total_points = int(point1.text) + int(point2.text) + int(point3.text)
			print(total_points)
			win_screen.show()
			dice_chosen.emit(total_points)
		else:
			print("You no have key")
			win_screen.show()
			dice_chosen.emit(0)

func _on_h_box_container_mouse_entered():
	is_mouse_on_key = true

func _on_h_box_container_mouse_exited():
	is_mouse_on_key = false

func _on_h_box_container_2_mouse_entered():
	is_mouse_on_points = true

func _on_h_box_container_2_mouse_exited():
	is_mouse_on_points = false
