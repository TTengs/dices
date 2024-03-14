extends Node3D

@onready var pause_menu = $PauseMenu
var paused = false

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		_pauseMenu()

func _pauseMenu():
	if paused:
		pause_menu.hide()
		#To stop time when paused
		#Engine.time_scale = 1
	else:
		pause_menu.show()
		#Engine.time_scale = 0
	
	paused = !paused
