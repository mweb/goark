extends AnimatableBody2D

var direction=Vector2.ZERO

const MOVEMENT_SPEED: int = 375

func _ready():
	direction = Vector2(1,-1)

func _physics_process(delta: float) -> void:
	var col = move_and_collide(delta*direction*MOVEMENT_SPEED)
	if col:
		direction = direction.bounce(col.get_normal())
