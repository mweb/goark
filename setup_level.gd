extends Node2D

@onready var br = preload("res://actors/brick/brick.tscn")
@onready var ball = preload("res://actors/ball/ball.tscn")

func _ready() -> void:
	create_bricks()
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_SPACE:
			var newball = ball.instantiate()
			newball.position = Vector2(600, 600)
			add_child(newball)

func create_bricks():
	for i in range(5):
		for j in range(10):
			var brick = br.instantiate()
			# width = 1452px
			brick.position = Vector2((95+36)+(128+10)*j, (55+20)+(48+10)*i)
			add_child(brick)
