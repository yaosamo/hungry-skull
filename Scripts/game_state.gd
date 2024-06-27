extends Node
enum tres { COIN, DIAMOND, EMERALD, RUBY, SAPPHIRE, PEARL, QUARTZ }

var COIN := 10
var EMERALD := 0
var RUBY := 0
var SAPPHIRE := 0
var PEARL := 0
var QUARTZ := 0
var DIAMOND := 0
var boneseaten := 0

var r : Dictionary = {
	tres.COIN : 10,
	tres.EMERALD : 0,
	tres.RUBY : 0,
	tres.SAPPHIRE : 0,
	tres.PEARL : 0,
	tres.QUARTZ : 0,
	tres.DIAMOND : 0
	}
var raredrop:= 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
