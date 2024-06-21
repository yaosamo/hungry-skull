extends Node2D

var crunch := false
var expnotgiven := true

var eyeL_def_pos : Vector2
var eyeR_def_pos : Vector2
var jaw_def_pos : Vector2
var distance := 0

var coins := 10
var exp := 0.0
var lvl := 1
var boneseaten := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%labelLv.text = str("Lv. ", lvl)
	eyeL_def_pos = $EyeL.position
	eyeR_def_pos = $EyeR.position
	jaw_def_pos = $Jaw.position
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#display
	%labelCoin.text = str(coins)
	$Lvlprogress.value = exp
	$labelBones.text = str("Bones eaten: ", boneseaten)
	
	#lvlup
	if $Lvlprogress.value >= 100:
		lvl += 1
		$labelLv.text = str("Lv. ", lvl)
		exp = 0
		$Talk.stream = load("res://Audio/lvlup1.mp3")
		$Talk.play()
		$lvlup.visible = true
		$lvlup/anima.play("levelup")
			
	if !$Talk.playing:
		$lvlup.visible = false
		
		

	#matematika 
	var mouseGlobalpos := get_global_mouse_position()
	var expanentaEyes := 1 / exp(distance*0.00005)
	var coef := 0.065
	var eyeShift = mouseGlobalpos*0.015

	
	if $PileC.newBone:
		var bonePos : Vector2 = $PileC.newBone.position
		distance = $Skull.position.distance_to(bonePos) # fuck you future developer, only last bone will be triggered
	else:
		distance = $Skull.position.distance_to(get_global_mouse_position())
	
	# eyes scale
	$EyeR.scale = Vector2(expanentaEyes*coef,expanentaEyes*coef)
	$EyeL.scale = Vector2(expanentaEyes*coef,expanentaEyes*coef)
	
	# eyes movement
	$EyeL.position = eyeL_def_pos+eyeShift
	$EyeR.position = eyeR_def_pos+eyeShift

	
	#eye flip
	if $Skull.position.x > mouseGlobalpos.x:
		$EyeL.scale = -$EyeL.scale
		$EyeR.scale = -$EyeR.scale
	
	# jaw
	var expJ := 100 / exp(distance*0.002)
	$Jaw.position.y = jaw_def_pos.y+expJ
	$Mouth.position.y = jaw_def_pos.y+expJ-40
	
	
	if distance < 200 and not crunch:
		crunch = true
		spawn()
		boneEaten()
	
		if is_instance_valid($PileC.newBone):
			$PileC.newBone.queue_free()
			$PileC.singlebone = false

		
	if distance > 201 and crunch:
		crunch = false
	pass
 
		
func purchaseBone():
	var boneprice := pow(1.02, boneseaten)
	if coins >= 1:
		coins -= 1
		
func boneEaten():
	boneseaten += 1
	var expcalc:= pow(0.99, boneseaten)*boneseaten
	exp += expcalc
	print_debug("pow(0.95, lvl+coins) ", expcalc)
	#expnotgiven = false
	#$Talk.stream = $PileC.nicebone
	#$Talk.play()
		
func imLucky() -> bool:
	var probability : = 0.1 # 10%
	var randf = randf()
	if randf <= probability: 
		return true
	else:
		return false
	
	
func spawn():
	var spawnpos : Vector2 = $Mouth.position
	var capcoins := 10
	var mincoins := 1
	
	if imLucky():
		print_debug("I'm lucky!")
		capcoins = 100
		mincoins = 50
	
	for i in 25:
		$boneparts.emit_particle(Transform2D(0, spawnpos), Vector2.ZERO, Color.RED, Color.TRANSPARENT,
		GPUParticles2D.EMIT_FLAG_POSITION
		)
	for i in 2:
		$bonecrush.emit_particle(Transform2D(0, spawnpos), Vector2.ZERO, Color.RED, Color.TRANSPARENT,
		GPUParticles2D.EMIT_FLAG_POSITION
		)
	
	var coinsdropped := randi_range(mincoins, capcoins)
	coins += coinsdropped
	for i in coinsdropped:
		$coin.emit_particle(Transform2D(0, spawnpos), Vector2.ZERO, Color.RED, Color.TRANSPARENT,
		GPUParticles2D.EMIT_FLAG_POSITION
		)
