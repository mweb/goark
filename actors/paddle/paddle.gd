extends CharacterBody2D

var use_mouse: bool = false
var mouse_offset_x: float = 0
var ypos = 0.0

const MOVEMENT_SPEED: int = 375

func _ready() -> void:
	ypos = global_position.y

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#var motion := event as InputEventMouseMotion
		if event.relative != Vector2.ZERO:
			mouse_offset_x = event.relative.x
			use_mouse = true


func _physics_process(delta: float) -> void:
	var dir: float = Input.get_axis("move_left", "move_right")
	if dir != 0:
		use_mouse = false

	var move_motion = Vector2(dir * MOVEMENT_SPEED, 0) * delta

	if move_motion == Vector2.ZERO and use_mouse:
		move_motion = Vector2(mouse_offset_x, 0)
		mouse_offset_x = 0.0

	self.rotation = deg_to_rad(clamp(move_motion.x/4., -15.0, 15.0))

	move_and_collide(move_motion)
	global_position.y = ypos
