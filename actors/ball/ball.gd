extends AnimatableBody2D

var direction=Vector2.ZERO
var lastCollision = -1

const MOVEMENT_SPEED: int = 375

signal died

func _ready():
	direction = Vector2(1, 1)

func _physics_process(delta: float) -> void:
	var col = move_and_collide(delta*direction*MOVEMENT_SPEED)
	if col:
		col.get_depth()
		direction = direction.bounce(col.get_normal())
		# move outside again to avoid strang bumping effects
		move_and_collide(col.get_depth()*col.get_normal())
		lastCollision = col.get_collider_id()
		if col.get_collider().name == "Brick":
			col.get_collider().get_parent().hit()
		elif col.get_collider().is_class("Ball"):
			col.get_collider().reflect(col.get_normal())
	if position.y > 1080:
		die()

func reflect(normal: Vector2) -> void:
	direction = direction.bounce(normal)

func die():
	queue_free()
	died.emit()
