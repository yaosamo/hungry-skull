extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	%labelCoin.text = str(format(state.COIN))
	%labelEmerald.text = str(state.EMERALD)
	%labelRuby.text = str(state.RUBY)
	%labelSapphire.text = str(state.SAPPHIRE)
	
	pass
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
