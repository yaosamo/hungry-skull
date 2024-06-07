extends Control

var dragging := false
var max_scale = 0.087
var min_scale = 0.063
var min_distance = 50.0
var max_distance = 1500.0

var h_eye_travel := 20
var eyeL_def_pos: Vector2
var eyeR_def_pos: Vector2

func _ready() -> void:
	eyeL_def_pos = %EyeL.position
	eyeR_def_pos = %EyeR.position
	pass

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			dragging = true
		if !event.pressed:
			dragging = false
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position()-self.size/2
		
	#matematika 
	var distance = get_parent().get_node("Skull").position.distance_to(position)
	var clamped_distance = clamp(distance, min_distance, max_distance)
	var exp := 1 / exp(distance*0.00005)
	var coef := 0.065
	var normalized_distance = (clamped_distance - min_distance) / (max_distance - min_distance)
	var SC = lerp(max_scale, min_scale, normalized_distance)
	var eyeXshift = position.x*0.015
	var eyeYshift = position.y*0.015
	
	# eyes scale
	%EyeR.scale = Vector2(exp*coef,exp*coef)
	%EyeL.scale = Vector2(exp*coef,exp*coef)
	
	# eyes movement
	%EyeL.position.x = eyeL_def_pos.x+eyeXshift
	%EyeL.position.y = eyeL_def_pos.y+eyeYshift
	%EyeR.position.x = eyeR_def_pos.x+eyeXshift
	%EyeR.position.y = eyeR_def_pos.y+eyeYshift
		
	if get_parent().get_node("Skull").position.x > position.x:
		%EyeL.scale = -%EyeL.scale
		%EyeR.scale = -%EyeR.scale	
		
	# jaw
	%Jaw.position.y = SC*6000
	%Mouth.position.y = SC*5300
	pass
