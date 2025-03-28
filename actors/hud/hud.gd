extends Control

signal settings

@onready var score = $container/Score
@onready var balls = $container/Balls
@onready var time = $container/Time
@onready var highscore = $highscoreContainer/Highscore

func set_score(value: int) -> void:
	if value >= 0:
		score.text = str(value)
	else:
		score.text = "INF"

func set_highscore(value: int) -> void:
	if value <= 0:
		highscore.text = "-"
	else:
		highscore.text = str(value)

func set_balls(value: int) -> void:
	if value >= 0:
		balls.text = str(value)
	else:
		balls.text = "-"

func set_time_remaining(value: int) -> void:
	if value >= 0 && value < 60:
		time.text = str(value)+"s"
	if value >= 60:
		time.text = str(int(value/60.))+" min "+ str(value%60)+" s"


func _on_settings_button_pressed() -> void:
	settings.emit()
