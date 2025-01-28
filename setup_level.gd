extends Node2D

@onready var br = preload("res://actors/brick/brick.tscn")
@onready var ball = preload("res://actors/ball/ball.tscn")

@onready var hud = $UI/HUD
@onready var status = $UI/Status
@onready var bricks = $Bricks

var score = 0
var lives = 3
var balls = 5
var balls_in_game = 0

func _ready() -> void:
	create_bricks()
	update_hud()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_SPACE && balls > 0:
			var newball = ball.instantiate()
			newball.position = Vector2(600, 600)
			add_child(newball)
			newball.connect("died", ball_lost)
			balls -= 1
			balls_in_game += 1
			update_hud()

func create_bricks():
	for i in range(5):
		for j in range(10):
			var brick = br.instantiate()
			# width = 1452px
			brick.position = Vector2((95+36)+(128+10)*j, (55+20)+(48+10)*i)
			bricks.add_child(brick)
			brick.set_value(10*(10*(5-i)))
			brick.connect("got_hit", brick_got_hit)

func ball_lost():
	balls_in_game -= 1
	if balls_in_game <= 0:
		lives -= 1
		if lives >= 0:
			balls = 5
		else:
			balls = -1
	update_hud()

func brick_got_hit(value: int) -> void:
	score += value
	update_hud()

func update_hud():
	hud.set_score(score)
	hud.set_lives(lives)
	hud.set_balls(balls)
	if lives >= 0:
		status.hide()
	else:
		status.show()

func _on_restart_button_pressed() -> void:
	var children = bricks.get_children()
	for c in children:
		bricks.remove_child(c)
		c.queue_free()
	lives = 3
	score = 0
	balls = 5
	update_hud()
	create_bricks()
