extends Node2D

@onready var br = preload("res://actors/brick/brick.tscn")
@onready var ball = preload("res://actors/ball/ball.tscn")

var score_file = "user://highscore.save"
var highscore = 0

@onready var hud = $UI/HUD
@onready var uiOverlays = $UI/Overlays
@onready var bricks = $Bricks
@onready var balls = $Balls

var score = 0
var lives = 3
var freeballs = 5
var time_limit = 180.0

func _ready() -> void:
	load_score()

func _physics_process(delta: float) -> void:
	if uiOverlays.is_shown():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		return

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
	if uiOverlays.is_shown():
		return

	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_SPACE:
				_on_ball_button_pressed()
			elif event.keycode == KEY_P || event.keycode == KEY_ESCAPE:
				uiOverlays.show_pause()
				get_tree().paused = true
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
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
			brick.set_value(2)
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
	score += value ** (balls.get_child_count()-1)
	update_hud()

func update_hud():
	if bricks.get_child_count() == 0:
		stop_game()

	hud.set_score(score)
	hud.set_lives(lives)
	hud.set_balls(freeballs)
	hud.set_time_remaining(time_limit)

	if lives <= 0 && !uiOverlays.is_shown():
		if bricks.get_child_count() == 0:
			var time_score = time_limit*10
			var new_high = (score+time_score) > highscore
			if new_high:
				highscore = score+time_score
				hud.set_highscore(highscore)
				save_score()
			uiOverlays.show_won(score, time_limit, time_score, new_high)
		else:
			uiOverlays.show_gameover()

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
	uiOverlays.hide_all()
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

func _on_overlay_start() -> void:
	init_game()

func _on_overlays_resume() -> void:
	if uiOverlays.is_shown():
		get_tree().paused = false
		uiOverlays.hide_all()

func load_score():
	if FileAccess.file_exists(score_file):
		var sfile = FileAccess.open(score_file, FileAccess.READ)
		highscore = sfile.get_var()
		sfile.close()
	else:
		highscore = 0
	hud.set_highscore(highscore)

func save_score():
	var sfile = FileAccess.open(score_file, FileAccess.WRITE)
	sfile.store_var(highscore)
	sfile.close()
