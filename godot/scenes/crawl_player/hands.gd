extends CharacterBody2D
@onready var body: RigidBody2D = $".."
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var body_velocity: float= 25.0

var collision_point:Vector2

#enum
var isHandStretched:bool = true

func _physics_process(delta: float) -> void:
	player_crawl(delta)
	

func player_crawl(delta:float):
	look_at(get_global_mouse_position())
	if ray_cast_2d.is_colliding() && Input.is_action_pressed("mouse_grab"):
		collision_point = ray_cast_2d.get_collision_point()
		body.global_position = body.global_position.move_toward(collision_point, body_velocity*delta)
	

#FRICTION
