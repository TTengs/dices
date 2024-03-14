extends RigidBody3D

@onready var raycasts = $Raycasts.get_children()

var start_pos
var roll_strength = 30

var is_rolling = false
var is_falling = false

var force_to_center = 10  # Adjust as needed

var side_up = 0

signal roll_finished(value)
signal pickup_die(die, camera)
signal drop_die(die)

func _ready():
	start_pos = global_position

func _roll():
	# Reset state
	sleeping = false
	freeze = false
	transform.origin = start_pos
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	# Random rotation
	transform.basis = Basis(Vector3.RIGHT, randf_range(0, 2 * PI)) * transform.basis
	transform.basis = Basis(Vector3.UP, randf_range(0, 2 * PI)) * transform.basis
	transform.basis = Basis(Vector3.FORWARD, randf_range(0, 2 * PI)) * transform.basis

	var throw_vector = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	angular_velocity = throw_vector * roll_strength / 2
	apply_central_impulse(throw_vector * roll_strength)
	is_rolling = true

func _on_sleeping_state_changed():
	if sleeping:
		var landed_on_side = false
		for raycast in raycasts:
			# TODO Check on collision layer skal lige refactors i fremtiden
			# but works for now
			if raycast.is_colliding() && raycast.get_collider().collision_layer == 3:
				roll_finished.emit(raycast.opposite_side)
				side_up = raycast.opposite_side
				is_rolling = false
				is_falling = false
				landed_on_side = true
		
		if !landed_on_side:
			print("falling")
			_apply_force_to_center()

func _apply_force_to_center():
	var center = Vector3.ZERO
	for raycast in raycasts:
		center += raycast.global_position
	center /= raycasts.size()
	var direction_to_center = (center - global_position).normalized()
	var direction_to_origin = -global_position.normalized()
	var final_direction = (direction_to_center + direction_to_origin).normalized()
	apply_central_impulse(final_direction * force_to_center)


func _on_input_event(camera, event, _position, _normal, _shape_idx):
	if (event.is_action_pressed("select")):
		print("I clicky")
		pickup_die.emit(self, camera)
	elif (event.is_action_released("select")):
		print("I release you")
		drop_die.emit(self)
