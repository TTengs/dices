extends Control

@onready var texture = $Panel/TextureRect
signal mouse_entered_panel(dice_slot)
signal mouse_exited_panel()

var one_eye = 0
var two_eyes = 16
var three_eyes = 32
var four_eyes = 48
var five_eyes = 64
var six_eyes = 80

func _on_panel_mouse_entered():
	mouse_entered_panel.emit(self)

func _on_panel_mouse_exited():
	mouse_exited_panel.emit()

func _on_spaceman_die_selected(side_up, dice_slot):
	_update_icon_slot(side_up, dice_slot)

func _on_meyer_game_die_selected(side_up, dice_slot):
	_update_icon_slot(side_up, dice_slot)

func _update_icon_slot(eyes, dice_slot):
	if (self == dice_slot):
		if (eyes == 1):
			texture.texture.region.position.x = one_eye
		elif (eyes == 2):
			texture.texture.region.position.x = two_eyes
		elif (eyes == 3):
			texture.texture.region.position.x = three_eyes
		elif (eyes == 4):
			texture.texture.region.position.x = four_eyes
		elif (eyes == 5):
			texture.texture.region.position.x = five_eyes
		elif (eyes == 6):
			texture.texture.region.position.x = six_eyes
