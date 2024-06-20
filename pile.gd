extends Control

@onready var boneInstance = preload("res://bone.tscn")
var click := false
@export var newBone = boneInstance
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == 1 and !click:
		click = true
		print_debug("Clicked here: ", event.global_position)
		newBone = boneInstance.instantiate()
		get_parent().add_child(newBone)
		newBone.position = event.global_position - Vector2(80, 80)
	pass
