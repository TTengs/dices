extends Control

@onready var point = $VBoxContainer/HBoxContainer/points
@onready var main_menu = $VBoxContainer/Button
@onready var gongrats_text = $VBoxContainer/Label

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_spaceman_dice_chosen(points):
	point.text = str(points)
	if (points == 0):
		gongrats_text.text = "You get no points, cus no key :("
