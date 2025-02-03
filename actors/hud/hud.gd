extends Control

@onready var score = $container/Score
@onready var lives = $container/Lives
@onready var balls = $container/Balls
@onready var time = $container/Time

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

func set_time_remaining(value: int) -> void:
	if value >= 0 && value < 60:
		time.text = str(value)+"s"
	if value >= 60:
		time.text = str(value/60)+" min "+ str(value%60)+" s"
