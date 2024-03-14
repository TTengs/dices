extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartGameButton.grab_focus()


func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_controls_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/controls.tscn")

func _on_exit_game_button_pressed():
	get_tree().quit()
