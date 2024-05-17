extends CharacterBody2D

const SPEED = 1000

@onready var wall_detector := $Walldetector as RayCast2D
@onready var texture := $Texture as Sprite2D
@onready var anim := $Anim as AnimationPlayer

var direction := -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1

	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false
		 
	velocity.x = direction * SPEED * delta

	move_and_slide()


func _on_anim_animation_finished(anim_name):
	direction = 0
	if anim_name == "hurt":
		queue_free()
