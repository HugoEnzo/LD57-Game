extends Node2D
@onready var hands: CharacterBody2D = $Body/Hands
@onready var body: RigidBody2D = $Body




func _ready() -> void:
	pass
	$Body.lock_rotation = true



#func sprite_flip():
	#var mouse_vec = get_global_mouse_position()
	#if mouse_vec.x-body.position.x<0:#mouse is to the left
		#body.rotate(PI)
