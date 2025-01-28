extends Node2D

@onready var br = preload("res://actors/brick/brick.tscn")
@onready var ball = preload("res://actors/ball/ball.tscn")

@onready var hud = $UI/HUD

var score = 0
var lives = 3
var balls = 10
var balls_in_game = 0

func _ready() -> void:
	create_bricks()
	hud.set_score(score)
	hud.set_lives(lives)
	hud.set_balls(balls)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_SPACE && balls > 0:
			var newball = ball.instantiate()
			newball.position = Vector2(600, 600)
			add_child(newball)
			balls -= 1
			balls_in_game += 1
			hud.set_balls(balls)

func create_bricks():
	for i in range(5):
		for j in range(10):
			var brick = br.instantiate()
			# width = 1452px
			brick.position = Vector2((95+36)+(128+10)*j, (55+20)+(48+10)*i)
			add_child(brick)
