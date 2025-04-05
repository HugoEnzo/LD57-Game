extends Node2D
# Variables for movement
var speed = 100
var crawl_speed = 50


const DRAG_LIM_MAX: Vector2 = Vector2(0, 24)
const DRAG_LIM_MIN: Vector2 = Vector2(-24, 0)

@onready var hands: RigidBody2D = $Hands


var mouse_position = Vector2.ZERO
var look_dir = 0

var gravity = 100
var velocity = Vector2.ZERO


func _ready():
	pass
	

func _physics_process(delta: float) -> void:
	pass
	#mouse_position = get_global_mouse_position()
	#look_dir = (mouse_position-hands.global_position).normalized().angle()+deg_to_rad(90)
	#hands.rotation = lerp_angle(hands.rotation, look_dir, 1.0)
	#velocity.y += gravity * delta
	#set_velocity(velocity)
	#move_and_slide()

	
