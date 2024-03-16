extends Node

@onready var win_screen = $SpacemanWin

var Die = preload("res://Scenes/die.tscn")  # Replace with the path to your dice.gd script
var dice = []

var any_die_rolling

var picked_up_die = null
var game_camera = null

var is_mouse_on_slot1 = false
var is_mouse_on_slot2 = false
var is_mouse_on_point1 = false
var is_mouse_on_point2 = false
var is_mouse_on_point3 = false

var dice_slot = null

var key = 0
var point = 0

var key_is_chosen = false
var points_are_chosen = false

var has_chosen_die = true

# List to check if 2 keys have been chosen, maybe refactor to allow for moving them in the future.
var key_list = []
var points_list = []

signal die_selected(side_up, dice_slot)
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
	
	#TODO Kan måske lige slås sammen????
	if (is_mouse_on_slot1 && key_list.size() < 2):
		die_selected.emit(die.side_up, dice_slot)
		#Add key dice to the key list
		key_list.append(die.side_up)
		print(key_list)
		dice.erase(die)
		die.queue_free()
		has_chosen_die = true
	if (is_mouse_on_slot2 && key_list.size() < 2):
		die_selected.emit(die.side_up, dice_slot)
		key_list.append(die.side_up)
		dice.erase(die)
		die.queue_free()
		has_chosen_die = true
	
	# If dice is dropped on points, display this and remove die
	if (is_mouse_on_point1 && points_list.size() < 3):
		die_selected.emit(die.side_up, dice_slot)
		#Add key dice to the points list
		points_list.append(die.side_up)
		print(points_list)
		dice.erase(die)
		die.queue_free()
		has_chosen_die = true
	elif (is_mouse_on_point2 && points_list.size() < 3):
		die_selected.emit(die.side_up, dice_slot)
		points_list.append(die.side_up)
		dice.erase(die)
		die.queue_free()
		has_chosen_die = true
	elif (is_mouse_on_point3 && points_list.size() < 3):
		die_selected.emit(die.side_up, dice_slot)
		points_list.append(die.side_up)
		dice.erase(die)
		die.queue_free()
		has_chosen_die = true

func _no_more_dice():
	# Add all numbers in the key list and check if they add up to 4
	if (key_list.has(1) && key_list.has(3)):
		# Add all numbers in the points list
		var total_points = points_list[0] + points_list[1] + points_list[2]
		win_screen.show()
		dice_chosen.emit(total_points)
	else:
		win_screen.show()
		dice_chosen.emit(0)

func _on_dice_slot_mouse_entered_panel(slot):
	is_mouse_on_slot1 = true
	dice_slot = slot

func _on_dice_slot_mouse_exited_panel():
	is_mouse_on_slot1 = false

func _on_dice_slot_2_mouse_entered_panel(slot):
	is_mouse_on_slot2 = true
	dice_slot = slot

func _on_dice_slot_2_mouse_exited_panel():
	is_mouse_on_slot2 = false

func _on_point_dice_slot_mouse_entered_panel(slot):
	is_mouse_on_point1 = true
	dice_slot = slot

func _on_point_dice_slot_mouse_exited_panel():
	is_mouse_on_point1 = false

func _on_point_dice_slot_2_mouse_entered_panel(slot):
	is_mouse_on_point2 = true
	dice_slot = slot

func _on_point_dice_slot_2_mouse_exited_panel():
	is_mouse_on_point2 = false

func _on_point_dice_slot_3_mouse_entered_panel(slot):
	is_mouse_on_point3 = true
	dice_slot = slot

func _on_point_dice_slot_3_mouse_exited_panel():
	is_mouse_on_point3 = false
