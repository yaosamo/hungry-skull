extends Control

enum TalkingPoints { GIMME, throwbone, nicebone }
@onready var throwbone = preload("res://Audio/1_throwabone.mp3")
@onready var nicebone = preload("res://Audio/4_nicebone.mp3")
@onready var GIMME = preload("res://Audio/2_gimme.mp3")
@onready var boneInstance = preload("res://Scenes/bone.tscn")
@export var newBone = boneInstance
var singlebone := false

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _gui_input(event: InputEvent):
		if event is InputEventMouseButton and event.button_index == 1 and !singlebone:
			if state.r[state.tres.COIN] >= 1:
				state.r[state.tres.COIN] -= 1
				singlebone = true
				newBone = boneInstance.instantiate()
				get_parent().add_child(newBone)
				newBone.position = event.global_position - Vector2(80, 80)
				#newBone.dragging = true
				newBone.mouseoffset = Vector2(80, 80)
				speakup()
			else: 
				print_debug("Not enough coins")
		pass


func speakup():
	get_parent().get_node("Talk").stream = GIMME
	get_parent().get_node("Talk").play()
