extends Node

##TODO actually use this
@export var __sensitivity : float = 1: 
	get: 
		return __sensitivity
	set(value): 
		__sensitivity = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
