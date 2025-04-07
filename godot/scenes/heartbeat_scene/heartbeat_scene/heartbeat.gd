extends Node2D
@onready var progress_bar: ProgressBar = $Control/ProgressBar
@onready var animated_sprite_2d = $AnimatedSprite2D


signal key_held
var avg_bpm = 80
var heartrate #80/60
var minheartrate = 1.0
var maxheartrate = 3.4
var idling = true
var breatheout = false
var breathintimemin = 0.9
var breathintimemax = 2.0
var breathouttimemin = 1.9
var breathouttimemax = 3.2
var time_start = 0
var time_now = 0
var time_elapsed_out
var time_elapsed_in
var checktime
var progress_bar_initial
var progress_bar_goal
var progress_bar_step
var maxed
var opacity_step
var lower_blood
var thicker_blood_opacity
var breath_time

#var release: InputEvent

func _ready():
	breath_time = 0
	opacity_step = 0.02
	$Timer.start()
	time_elapsed_out = 0.0
	time_elapsed_in = 0.0
	heartrate = 103/60.0
	maxed = false
	$BloodVessels.self_modulate.a = 0.0
	var lower_blood = false
	var thicker_blood_opacity = 0.0
	$ThickerBloodVessels.self_modulate.a = thicker_blood_opacity
	$HandGrappler/Player/CharacterBlue.self_modulate.a = 0.0

func _on_timer_timeout() -> void:
	opacity_step = 0.02
	if progress_bar.value <= 5:
		opacity_step = 0
	#idling = false
	#print_debug("beat")
	animated_sprite_2d.speed_scale = (heartrate-minheartrate+maxheartrate)/maxheartrate
	animated_sprite_2d.play("heartbeat")
	breath_time += 1.0
	if breath_time >= 8.0 && $HandGrappler/Player/CharacterBlue.self_modulate.a < 0.8:
		$HandGrappler/Player/CharacterBlue.self_modulate.a += 1/40.0
		
	$AudioStreamPlayer2D.volume_db = 6*(progress_bar.value)/100
	$AudioStreamPlayer2D.pitch_scale = (heartrate-minheartrate+maxheartrate)/maxheartrate
	if progress_bar.value == 100:
		$AudioStreamPlayer2D.volume_db = 10
		$AudioStreamPlayer2D.pitch_scale = 1.85
	$AudioStreamPlayer2D.play()
	
	#if $BloodVessels.self_modulate.a <= (1-opacity_step) && progress_bar.value >= 10:
	$BloodVessels.self_modulate.a = progress_bar.value/200
	$ThickerBloodVessels.self_modulate.a = ((heartrate-minheartrate+maxheartrate)/maxheartrate)/40 + opacity_step
	lower_blood = true

		
func _process(delta):
	if progress_bar.value == 100:
		$ThickerBloodVessels.self_modulate.a = 1.0
	if $Timer.time_left < 0.3 && lower_blood == true:
		$ThickerBloodVessels.self_modulate.a = ((heartrate-minheartrate+maxheartrate)/maxheartrate)/40 - opacity_step
		lower_blood = false
	$Timer.wait_time = 1/heartrate
	#progress_bar_initial = 100*(heartrate/maxheartrate - minheartrate/maxheartrate)/(1.0-1.0/3.4)
	if Input.is_action_just_pressed("breathe"):
		print_debug("time left is ",$Timer.time_left)
		checktime = true
		$HandGrappler/Player/CharacterBlue.self_modulate.a = 0.0
		#print_debug("Time breathing in = ",time_elapsed_in)
	if Input.is_action_pressed("breathe"):
		if (time_elapsed_in > breathintimemax) && (checktime == true):
			#print_debug("Time breathing in = ",time_elapsed_in)
			heartrate -= 0.4
			checktime = false
		if time_elapsed_in < breathintimemin && (checktime == true) && heartrate <= maxheartrate:
			#print_debug("Time breathing in = ",time_elapsed_in)
			heartrate += 0.05
			checktime = false
		time_elapsed_in = 0
		time_elapsed_out += delta
		checktime = false
	
	if Input.is_action_just_released("breathe"):
		#print_debug("Time breathing out = ",time_elapsed_out)
		checktime = true
		$HandGrappler/Player/CharacterBlue.self_modulate.a = 0.0
	if not Input.is_action_pressed("breathe"):
		if time_elapsed_out > breathouttimemax && (checktime == true):
			heartrate -= 0.4
			checktime = false
			if heartrate < 1:
				heartrate = 1
			#print_debug("Time breathing out = ",time_elapsed_out)
		if time_elapsed_out < breathouttimemin && (checktime == true) && heartrate <= maxheartrate:
			heartrate += 0.05
			checktime = false
			if heartrate > 3.4:
				heartrate = 3.4
			#print_debug("Time breathing out = ",time_elapsed_out)
		time_elapsed_out = 0
		time_elapsed_in += delta
		checktime = false
	
	if heartrate < minheartrate:
		heartrate = minheartrate
	if heartrate > maxheartrate:
		heartrate = maxheartrate
	#progress_bar_goal = 100*(heartrate/maxheartrate - minheartrate/maxheartrate)/(1.0-1.0/3.4)
	#progress_bar_step = (progress_bar_goal - progress_bar_initial)/10
	#progress_bar.value += progress_bar_step
	if heartrate > 1.9:
		progress_bar.value +=0.015*(((heartrate-0.3)**2)/maxheartrate)
	if heartrate  <= 1.9:
		progress_bar.value -=0.015*1/(((heartrate-0.3)**2)/maxheartrate)
		maxed = false
	
	if progress_bar.value == 100 && maxed == false:
		heartrate = maxheartrate
		maxed = true
	
	## Set Function here that turns of the players ability to move/grip if the progress bar is maxxed out
