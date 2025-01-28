extends Control

@onready var score = $Score
@onready var lives = $Lives
@onready var balls = $Balls

func set_score(value: int) -> void:
	if value >= 0:
		score.text = str(value)
	else:
		score.text = "INF"

func set_lives(value: int) -> void:
	if value >= 0:
		lives.text = str(value)
	else:
		lives.text = "-"

func set_balls(value: int) -> void:
	if value >= 0:
		balls.text = str(value)
	else:
		balls.text = "-"
