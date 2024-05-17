extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.velocity.y = body.jump_force
		owner.anim.play("hurt")
