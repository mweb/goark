extends AnimatableBody2D

var direction=Vector2.ZERO

const MOVEMENT_SPEED: int = 375

signal died

func _ready():
	direction = Vector2(1, 1)

func _physics_process(delta: float) -> void:
	var col = move_and_collide(delta*direction*MOVEMENT_SPEED)
	if col:
		col.get_depth()

		direction = direction.bounce(col.get_normal())
		match col.get_collider().name:
			"Brick":
				col.get_collider().get_parent().hit()
				Audioplayer.play_sfx(Audioplayer.Sfx.HIT_BLOCK)
			"Ball":
				col.get_collider().reflect(col.get_normal())
				Audioplayer.play_sfx(Audioplayer.Sfx.HIT_WALL)
			"Paddle":
				Audioplayer.play_sfx(Audioplayer.Sfx.HIT_PADDLE)
			_:
				Audioplayer.play_sfx(Audioplayer.Sfx.HIT_WALL)

		# move outside again to avoid strang bumping effects
		move_and_collide(delta*direction*MOVEMENT_SPEED)

	if position.y > 1080:
		die()

func reflect(normal: Vector2) -> void:
	direction = direction.bounce(normal)

func die():
	queue_free()
	died.emit()
