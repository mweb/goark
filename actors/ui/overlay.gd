extends Control

signal start
signal resume

@onready var introduction = $introduction
@onready var gameover = $gameover
@onready var won = $won
@onready var highscoreTitle = $won/CenterContainer/GridContainer/HighscoreTitle
@onready var scoreTitle = $won/CenterContainer/GridContainer/ScoreTitle
@onready var score = $won/CenterContainer/GridContainer/Score
@onready var time = $won/CenterContainer/GridContainer/Time
@onready var timeValue = $won/CenterContainer/GridContainer/TimeValue
@onready var total = $won/CenterContainer/GridContainer/Total
@onready var pause = $pause
@onready var descriptionNonAndroid = $introduction/RichTextLabel
@onready var descriptionAdnroid = $introduction/RichTextLabelAndroid


func is_shown() -> bool:
	return introduction.visible || gameover.visible || won.visible || pause.visible

func show_introduction() -> void:
	hide_all()
	print(OS.get_name())
	if OS.get_name() == "Android":
		descriptionAdnroid.show()
		descriptionNonAndroid.hide()
	introduction.show()

func show_gameover() -> void:
	hide_all()
	gameover.show()

func show_won(score_value: int, seconds_left: int, time_score: int, new_high: bool) -> void:
	hide_all()
	if new_high:
		highscoreTitle.show()
		scoreTitle.hide()
	else:
		highscoreTitle.hide()
		scoreTitle.show()

	score.text = str(score_value)
	var minutes = int(seconds_left/60.)
	if minutes > 0:
		time.text = str(minutes)+"min "+str(seconds_left-minutes*60)+ "s"
	else: 
		time.text = str(seconds_left)+ "s"
	timeValue.text = str(time_score)
	total.text = str(time_score + score_value)
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
