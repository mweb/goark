extends Node2D

@onready var br = preload("res://actors/brick/brick.tscn")
@onready var ball = preload("res://actors/ball/ball.tscn")

@onready var hud = $UI/HUD
@onready var status = $UI/Status
@onready var bricks = $Bricks
@onready var balls = $Balls

var score = 0
var lives = 3
var freeballs = 5
var time_limit = 180.0

func _ready() -> void:
	init_game()

func _physics_process(delta: float) -> void:
	if balls.get_child_count() > 0:
		time_limit -= delta
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if lives >= 0 && time_limit < 0:
		lives = -1
		freeballs = 0
		var children = balls.get_children()
		for c in children:
			balls.remove_child(c)
			c.queue_free()
	update_hud()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed && event.keycode == KEY_SPACE:
			_on_ball_button_pressed()
	if event is InputEventScreenTouch:
		if event.index == 1 && !event.pressed:
			_on_ball_button_pressed()

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
	if balls.get_child_count() <= 1    :
		lives -= 1
		if lives >= 0:
			freeballs = 5
		else:
			freeballs = -1
	update_hud()

func brick_got_hit(value: int) -> void:
	score += value
	update_hud()

func update_hud():
	if bricks.get_child_count() == 0:
		stop_game()

	hud.set_score(score)
	hud.set_lives(lives)
	hud.set_balls(freeballs)
	hud.set_time_remaining(time_limit)

	if lives >= 0:
		status.hide()
	else:
		status.show()
		if bricks.get_child_count() == 0:
			status.text = "WON"
		else:
			status.text = "GAMEOVER"

func _on_restart_button_pressed() -> void:
	var children = bricks.get_children()
	for c in children:
		bricks.remove_child(c)
		c.queue_free()
	init_game()

func stop_game() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	lives = -1
	freeballs = 0
	var children = balls.get_children()
	for c in children:
		balls.remove_child(c)
		c.queue_free() 

func init_game() -> void:
	lives = 3
	score = 0
	freeballs = 5
	time_limit = 180
	create_bricks()
	update_hud()


func _on_ball_button_pressed() -> void:
	if freeballs > 0:
		var newball = ball.instantiate()
		newball.position = Vector2(600, 600)
		balls.add_child(newball)
		newball.connect("died", ball_lost)
		freeballs -= 1
		update_hud()
