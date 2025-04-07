extends Node2D

@export var rest_length = 2.0
@export var stiffness = 10.0
@export var damping = 2.0

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var player: RigidBody2D = $".."
@onready var line_2d: Line2D = $Line2D

const VELOCITY = 20.0

var launched = false
var target: Vector2

func _ready() -> void:
	#player.lock_rotation = true
	pass


func _process(delta: float) -> void:
	
	ray_cast_2d.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("mouse_grab"):
		launch()
	if Input.is_action_just_released("mouse_grab"):
		retract()
	
	if launched:
		handle_grapple(delta)

func launch():
	if ray_cast_2d.is_colliding():
		launched = true
		target = ray_cast_2d.get_collision_point()
	line_2d.show()

func retract():
	launched = false
	line_2d.hide()


func handle_grapple(delta):
	player.global_position = player.global_position.move_toward(Vector2(target.x, target.y), VELOCITY*delta)
	

func update_rope():
	line_2d.set_point_position(1, to_local(target))
