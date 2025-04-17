extends RigidBody2D


func _physics_process(delta: float) -> void:
	#sprite_flip()
	pass


func sprite_flip():
	var mouse_position = get_global_mouse_position()
	if mouse_position.x > global_position.x:
		scale.x = -1
	else:
		scale.x = 1
