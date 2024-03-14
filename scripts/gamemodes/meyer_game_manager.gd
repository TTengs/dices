extends Node

@onready var result_label = $CanvasLayer/Label
@onready var last_scores = $CanvasLayer/RichTextLabel
@onready var life_label = $CanvasLayer/Life

var Die = preload("res://Scenes/die.tscn")  # Replace with the path to your dice.gd script
var dice = []

var values = []
var any_die_rolling

var picked_up_die = null
var game_camera = null

var is_mouse_on_health = false

var life = 0

func _on_die_roll_finished(value):
#Make array that stores the values emmitted from the function
	values.append(value)
	print(str(value))
	
	#If the values array contains a certain pattern of values, append a string to the result_label
	if values.size() == 2:
		values.sort()
		if values[0] == values[1]:
			result_label.text += "Pair " + str(values[1])
		elif values == [1,2]:
			result_label.text += "Big Meyer"
		elif values == [1,3]:
			result_label.text += "Lil Meyer"
		elif values == [2,3]:
			result_label.text += "Skål"
		else:
			result_label.text = str(values[1]) + str(values[0])
			
		# Append the result to the last_scores text field
		last_scores.text += result_label.text

func _ready():
	last_scores.text = ""
	# Instantiate the dice
	for i in range(3):  # Replace 2 with the number of dice you want
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

	if event.is_action_pressed("ui_accept") && !any_die_rolling:
		result_label.text = ""
		last_scores.text += "\n"
		values.clear()
		for die in dice:
			die._roll()

func _process(_delta):
	if picked_up_die && game_camera:
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_origin = game_camera.project_ray_origin(mouse_pos)
		var ray_direction = game_camera.project_ray_normal(mouse_pos)
		var plane = Plane(Vector3(0, 1, 0), Vector3(0, 4, 0))  # Replace with the desired plane for the die to move on
		var intersection = plane.intersects_ray(ray_origin, ray_direction)
		if intersection:
			picked_up_die.global_transform.origin = intersection

func _on_pickup_die(die, camera):
	if (!any_die_rolling):
		picked_up_die = die
		game_camera = camera

func _on_drop_die(die):
	picked_up_die = null
	
	# If dice is dropped on health, display this and remove the die
	print("life " + str(life))
	if (is_mouse_on_health && life == 0):
		life = die.side_up
		life_label.text = str(die.side_up)
		dice.erase(die)
		die.queue_free()

func _on_panel_mouse_entered():
	is_mouse_on_health = true

func _on_panel_mouse_exited():
	is_mouse_on_health = false
