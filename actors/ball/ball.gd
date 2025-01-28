extends AnimatableBody2D

var direction=Vector2.ZERO
var lastCollision = -1

const MOVEMENT_SPEED: int = 375

signal died

func _ready():
	direction = Vector2(1, 1)

func _physics_process(delta: float) -> void:
	var col = move_and_collide(delta*direction*MOVEMENT_SPEED)
	if col && col.get_collider_id() != lastCollision:
		direction = direction.bounce(col.get_normal())
		lastCollision = col.get_collider_id()
		if col.get_collider().name == "Brick":
			col.get_collider().get_parent().hit()
	elif col:
		pass
	else:
		lastCollision = -1

	if position.y > 1080:
		die()

func die():
	queue_free()
	emit_signal("died")
