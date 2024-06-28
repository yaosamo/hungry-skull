extends VBoxContainer

var UiRes : Dictionary 
@onready var sapphire := load("res://assets/300w/sapphire.png")
@onready var coin := load("res://assets/300w/coin.png")
@onready var emerald := load("res://assets/300w/emeraldG.png")
@onready var ruby := load("res://assets/300w/ruby.png")
@onready var secret := load("res://assets/300w/secret.png")
@onready var Icons := {
	state.tres.COIN : coin,
	state.tres.EMERALD : emerald,
	state.tres.RUBY : ruby,
	state.tres.SAPPHIRE : sapphire,
	state.tres.PEARL : coin,
	state.tres.QUARTZ : coin,
	state.tres.DIAMOND : coin
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in state.r.keys():
		var resItem := $resource.duplicate()
		add_child(resItem)
		resItem.visible = true
		UiRes[i] = resItem
		resItem.get_child(0).text = str(state.r[i])
		resItem.get_child(1).get_child(0).texture = Icons[i]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print_debug(Icons)
	pass


func updateUI():
	for i in state.r.keys():
		UiRes[i].get_child(0).text = format(str(state.r[i]))


# Oleh's magic
func format(val) -> String:
	var v := int(val)
	var p :Array[String] = []
	while v >= 1000:
		p.append("%03d" % (v % 1000))
		v /= 1000
	p.append(str(v))
	p.reverse()
	return ",".join(p)
