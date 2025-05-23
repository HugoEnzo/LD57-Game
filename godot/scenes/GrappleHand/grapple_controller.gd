extends Node2D

@export var rest_length = 2.0
@export var stiffness = 10.0
@export var damping = 2.0

@export var caveCollider:PackedScene
@onready var hand_grappler: Node2D = $"../.."
@onready var collision_shape_2d: CollisionShape2D = $"../CollisionShape2D"


@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var player: RigidBody2D = $".."
@onready var male_arm: Sprite2D = $MaleArm

var upright:bool = true

const VELOCITY = 20.0

var collision_point_array = []
var launched = false
var target: Vector2
var contact_point:Vector2




func _ready() -> void:
	#caveCollider.
	pass


func _process(delta: float) -> void:
	
	ray_cast_2d.look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("mouse_grab"):
		#sprite_flip()
		launch()
		
	if Input.is_action_just_released("mouse_grab"):
		#sprite_flip()
		retract()
		
	
	if launched:
		handle_grapple(delta)

func launch():
	if ray_cast_2d.is_colliding():
		collision_point_array.append(ray_cast_2d.get_collision_point())
		launched = true
		target = collision_point_array[0]
	male_arm.show()

func retract():
	launched = false
	collision_point_array.clear()
	male_arm.hide()


func handle_grapple(delta):
	player.global_position = player.global_position.move_toward(Vector2(target.x, target.y), VELOCITY*delta)
	
