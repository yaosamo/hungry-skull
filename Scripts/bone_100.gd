extends Control

var dragging := false
var mouseoffset : Vector2

#prices
var bonebaseprice := 10

func _ready() -> void:
	pass

func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			dragging = true
			mouseoffset = get_local_mouse_position()
			print_debug("dragging")
		if !event.pressed:
			dragging = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		self.global_position = get_global_mouse_position() - mouseoffset
	pass
