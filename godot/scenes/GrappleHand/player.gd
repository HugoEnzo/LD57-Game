extends RigidBody2D

@onready var image_1: Sprite2D = $Image1

func _physics_process(delta: float) -> void:
	sprite_flip()
	pass


func sprite_flip():
	var mouse_position = get_global_mouse_position()
	if mouse_position.x > global_position.x:
		image_1.flip_h = false
	else:
		image_1.flip_h = true
