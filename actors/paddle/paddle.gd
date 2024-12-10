extends CharacterBody2D

var use_mouse: bool = false
var mouse_position_x: float = 0

const MOVEMENT_SPEED: int = 375

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#var motion := event as InputEventMouseMotion
		if event.relative != Vector2.ZERO:
			mouse_position_x = get_global_mouse_position().x
			use_mouse = true


func _physics_process(delta: float) -> void:
	var dir: float = Input.get_axis("move_left", "move_right")
	if dir != 0:
		use_mouse = false

	var move_motion = Vector2(dir * MOVEMENT_SPEED, 0) * delta

	if move_motion == Vector2.ZERO and use_mouse:
		move_motion = Vector2(mouse_position_x - global_position.x, 0)

	move_and_collide(move_motion)
