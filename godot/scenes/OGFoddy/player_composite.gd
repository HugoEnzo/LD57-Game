extends Node2D

@export var max_hammer_velocity: float= 100.0

@onready var player_body: RigidBody2D = $"Player Body"
@onready var hammer: RigidBody2D = $"Hammer"



func _physics_process(delta: float) -> void:
	var mouse_vec: Vector2= get_global_mouse_position() - player_body.global_position
	hammer.angular_velocity= hammer.global_transform.y.dot(mouse_vec.normalized()) * max_hammer_velocity
