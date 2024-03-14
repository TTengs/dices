extends Node3D

@onready var game_mode = $"../CanvasLayer/GamemodeButton"

var meyer_game = preload("res://Scenes/gamemodes/meyer_game.tscn")
var meyer_instance = null

var spaceman = preload("res://Scenes/gamemodes/spaceman.tscn")
var spaceman_instance = null

func _on_gamemode_button_item_selected(index):
	if (index == 0):
		print("We meyer gaming")
		# Check if meyer_game is instanced
		if (spaceman_instance != null):
			print("kill")
			spaceman_instance.queue_free()
		#Insantiate a scene that plays the meyer game
		meyer_instance = meyer_game.instantiate()
		add_child(meyer_instance)
	if (index == 1):
		# Check if meyer_game is instanced
		if (meyer_instance != null):
			print("kill")
			meyer_instance.queue_free()
		print("We spaceman gaming")
		#Instantiate spaceman game
		spaceman_instance= spaceman.instantiate()
		add_child(spaceman_instance)
