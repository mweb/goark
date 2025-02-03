extends Control

signal start
signal resume

@onready var introduction = $introduction
@onready var gameover = $gameover
@onready var won = $won
@onready var highsccore = $won/CenterContainer/GridContainer/Highscore
@onready var time = $won/CenterContainer/GridContainer/Time
@onready var timeValue = $won/CenterContainer/GridContainer/TimeValue
@onready var total = $won/CenterContainer/GridContainer/Total
@onready var pause = $pause

func is_shown() -> bool:
	return introduction.visible || gameover.visible || won.visible || pause.visible

func show_introduction() -> void:
	hide_all()
	introduction.show()

func show_gameover() -> void:
	hide_all()
	gameover.show()

func show_won(score: int, seconds_left: int) -> void:
	hide_all()
	highsccore.text = str(score)
	var minutes = seconds_left/60
	if minutes > 0:
		time.text = str(minutes)+"min "+str(seconds_left-minutes*60)+ "s"
	else: 
		time.text = str(seconds_left)+ "s"
	timeValue.text = str(10*seconds_left)
	total.text = str(score + 10*seconds_left)
	won.show()

func show_pause() -> void:
	hide_all()
	pause.show()

func hide_all() -> void:
	introduction.hide()
	gameover.hide()
	won.hide()
	pause.hide()


func _on_start_pressed() -> void:
	start.emit()


func _on_resume_pressed() -> void:
	resume.emit()
