extends Node2D

var exp := 0.0
var lvl := 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%labelLv.text = str("Lv. ", lvl)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# left side
	$Lvlprogress.value = exp
	$val_bonesEaten.text = str(state.boneseaten)
	
	# lvlup
	if $Lvlprogress.value >= 100:
		lvl += 1
		$labelLv.text = str("Lv. ", lvl)
		exp = 0
		$SFX.stream = load("res://Audio/lvlup1.mp3")
		$SFX.play()
		$lvlup.visible = true
		$lvlup/anima.play("levelup")
pass
