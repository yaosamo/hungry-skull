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
	#print_debug("nodes on screen: ", get_children())
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
	
	
	if distance < 200 and not crunch and Pile.newBone:
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
	var tresTexture : Texture
	
	if imLucky():
		print_debug("I'm lucky! for coins")
		var wow_anima := load("res://Scenes/wow_2x.tscn")
		var new_wow = wow_anima.instantiate()
		new_wow.global_position = $Skull.position - Vector2(400, 100)
		add_child(new_wow)
		capcoins = 300
		mincoins = 150
		#await new_wow.get_node("anima").animation_finished
		#deleteNode(new_wow)
		new_wow.get_node("anima").animation_finished.connect(deleteNode.bind(new_wow))
	
	dropamount = randi_range(mincoins, capcoins)
	state.r[state.tres.COIN] += dropamount
	get_parent().get_node("Resources").updateUI()
	coinsPew(dropamount)
	
	
	
	if imLucky(state.raredrop):
		var random_item = state.r.keys().pick_random()
		#if coins -> try again
		while random_item == state.tres.COIN:
			print_debug("It's a coin again ", random_item)
			random_item = state.r.keys().pick_random()
		dropamount = randi_range(20, 40)
		#add to res
		state.r[random_item] += dropamount
		get_parent().get_node("Resources").updateUI()
		print_debug("I'm lucky for RARE DROP id: ", random_item)
		tresTexture = get_parent().get_node("Resources").Icons[random_item]
		treasuresPewPew(tresTexture, dropamount)


func coinsPew(dropamount : int):
	var coinParticles := load("res://Scenes/coinsParticles.tscn")
	var new_particle = coinParticles.instantiate()
	new_particle.emitting = true
	new_particle.amount = dropamount
	new_particle.global_position = mouthPos + Vector2(120,0)
	add_child(new_particle)
	new_particle.finished.connect(deleteNode.bind(new_particle))


func deleteNode(n):
	n.queue_free()
	

func treasuresPewPew(tresTexture, dropamount):
	get_parent().get_node("treasure").texture = tresTexture
	for i in dropamount:
		get_parent().get_node("treasure").emit_particle(Transform2D(0, mouthPos), Vector2.ZERO, Color.RED, Color.TRANSPARENT,
		GPUParticles2D.EMIT_FLAG_POSITION
		)
	pass #est
