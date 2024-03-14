extends Control

@onready var main = $"../"
@onready var gravity = $VBoxContainer/HBoxContainer/MenuButton
func _on_back_button_pressed():
	main._pauseMenu()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

#Change gravity of game
func _on_menu_button_item_selected(index):
	if (index == 0):
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, 9.8)
	elif (index == 1):
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, 1.62)
	elif (index == 2):
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, 3.71)
