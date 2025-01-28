extends Node2D

signal got_hit(value: int)

var value = 10

func set_value(newValue: int) -> void:
	value = newValue

func hit():
	got_hit.emit(value)
	queue_free()
