extends Control

signal start
signal resume

@onready var introduction = $introduction
@onready var gameover = $gameover
@onready var won = $won
@onready var pause = $pause
@onready var settings = $settings

@onready var highscoreTitle = $won/CenterContainer/GridContainer/HighscoreTitle
@onready var totalTitle = $won/CenterContainer/GridContainer/TotalTitle
@onready var score = $won/CenterContainer/GridContainer/Score
@onready var time = $won/CenterContainer/GridContainer/Time
@onready var timeValue = $won/CenterContainer/GridContainer/TimeValue
@onready var total = $won/CenterContainer/GridContainer/Total
@onready var descriptionNonAndroid = $introduction/RichTextLabel
@onready var descriptionAdnroid = $introduction/RichTextLabelAndroid

@onready var sfxSlider = $settings/VBoxContainer/GridContainer/SliderSoundVolume
@onready var sfxCheckbox = $settings/VBoxContainer/GridContainer/CheckBoxSoundEffects
@onready var musicSlider = $settings/VBoxContainer/GridContainer/SliderMusicVolume
@onready var musicCheckbox = $settings/VBoxContainer/GridContainer/CheckBoxMusic

var show_prev : Callable = func ():
	hide_all()

func is_shown() -> bool:
	return introduction.visible || gameover.visible || won.visible || pause.visible || settings.visible

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
		totalTitle.hide()
	else:
		highscoreTitle.hide()
		totalTitle.show()

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
	settings.hide()

func _on_start_pressed() -> void:
	start.emit()

func _on_resume_pressed() -> void:
	resume.emit()

func show_settings() -> void:
	if pause.visible:
		show_prev = show_pause
	elif introduction.visible:
		show_prev = show_introduction
	hide_all()
	settings.show();
	update_settings_values()

func _on_check_box_sound_effects_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Audioplayer.set_sfx_volume(.8);
	else:
		Audioplayer.set_sfx_volume(0.0);

	sfxSlider.set_value_no_signal(Audioplayer.get_sfx_volume())

func _on_check_box_music_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Audioplayer.set_music_volume(.8);
	else:
		Audioplayer.set_music_volume(0.0);

	musicSlider.set_value_no_signal(Audioplayer.get_music_volume())

func _on_slider_sound_volume_value_changed(value: float) -> void:
	Audioplayer.set_sfx_volume(value);
	if value <= 0.0:
		sfxCheckbox.set_pressed_no_signal(false)
	else:
		sfxCheckbox.set_pressed_no_signal(true)

func _on_slider_music_volume_value_changed(value: float) -> void:
	Audioplayer.set_music_volume(value);
	if value <= 0.0:
		musicCheckbox.set_pressed_no_signal(false)
	else:
		musicCheckbox.set_pressed_no_signal(true)

func _on_close_settings_button_pressed() -> void:
	show_prev.call()
	show_prev = hide_all

func update_settings_values() -> void:
	var sfxVol = Audioplayer.get_sfx_volume()
	var musicVol = Audioplayer.get_music_volume()

	sfxSlider.set_value_no_signal(sfxVol)
	musicSlider.set_value_no_signal(musicVol)
	if sfxVol > 0.0:
		sfxCheckbox.set_pressed_no_signal(true)
	else:
		sfxCheckbox.set_pressed_no_signal(false)
	if musicVol > 0.0:
		musicCheckbox.set_pressed_no_signal(true)
	else:
		musicCheckbox.set_pressed_no_signal(false)
