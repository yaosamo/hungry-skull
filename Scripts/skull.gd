extends Node

@onready var mouthPos : Vector2 = $Mouth.position

var crunch := false
var eyeL_def_pos : Vector2
var eyeR_def_pos : Vector2
var jaw_def_pos : Vector2
var distance := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eyeL_def_pos = $EyeL.position
	eyeR_def_pos = $EyeR.position
	jaw_def_pos = $Jaw.position
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#matematika 
	var mouseGlobalpos : Vector2 = get_parent().get_global_mouse_position()
	var expanentaEyes := 1 / exp(distance*0.00005)
	var coef := 0.065
	var eyeShift = mouseGlobalpos*0.015
	
	
	
	var Pile = get_parent().get_node("PileC")
	if Pile.newBone:
		var bonePos : Vector2 = Pile.newBone.position
		distance = $Skull.position.distance_to(bonePos) # fuck you future developer, only last bone will be triggered
	else:
		distance = $Skull.position.distance_to(get_parent().get_global_mouse_position())
	
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
		spawnParticles()
		spawnTreasure()
		boneEaten()
		if is_instance_valid(Pile.newBone):
			Pile.newBone.queue_free()
			Pile.singlebone = false

		
	if distance > 201 and crunch:
		crunch = false
	pass
	
	
func boneEaten():
	state.boneseaten += 1
	var expcalc:= pow(0.99, state.boneseaten)*state.boneseaten
	get_parent().exp += expcalc
	
	
	
func spawnParticles():
	for i in 25:
		get_parent().get_node("boneparts").emit_particle(Transform2D(0, mouthPos), Vector2.ZERO, Color.RED, Color.TRANSPARENT,
		GPUParticles2D.EMIT_FLAG_POSITION
		)
		
	for i in 2:
		get_parent().get_node("bonecrush").emit_particle(Transform2D(0, mouthPos), Vector2.ZERO, Color.RED, Color.TRANSPARENT,
		GPUParticles2D.EMIT_FLAG_POSITION
		)
		
		
func imLucky(dropitem : float = 0.1) -> bool:
	# dropitem 0.1 = 10% chance 
	var randf = randf()
	if randf <= dropitem: 
		return true
	else:
		return false
	

func spawnTreasure():
	var capcoins := 10
	var mincoins := 1
	var dropamount := 0
	
	if imLucky():
		print_debug("I'm lucky! for coins")
		capcoins = 100
		mincoins = 50
	
	dropamount = randi_range(mincoins, capcoins)
	state.r[state.tres.COIN] += dropamount
	for i in dropamount:
		get_parent().get_node("coin").emit_particle(Transform2D(0, mouthPos), Vector2.ZERO, Color.RED, Color.TRANSPARENT,
		GPUParticles2D.EMIT_FLAG_POSITION
		)
		
	if imLucky(state.raredrop):
		var random_item = state.r.keys().pick_random()
		dropamount = randi_range(1, 10)
		state.r[random_item] += dropamount
		print_debug("I'm lucky for RARE DROP!", state.r[random_item])
		
		for i in dropamount:
			get_parent().get_node("coin").emit_particle(Transform2D(0, mouthPos), Vector2.ZERO, Color.RED, Color.TRANSPARENT,
			GPUParticles2D.EMIT_FLAG_POSITION
			)
		
