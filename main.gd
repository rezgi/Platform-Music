extends Node

func _ready() -> void:
	flow.send({type = "init", value = "tremendous"})
