extends Node2D

@onready var br = preload("res://actors/brick/brick.tscn")

func _ready() -> void:
	create_bricks()
	
func create_bricks():
	for i in range(5):
		for j in range(5):
			var brick = br.instantiate()
			brick.position = Vector2(240+250*j, 80+100*i)
			add_child(brick)
