extends CharacterBody2D

@export var speed = 200.0
@export var jump_force = -300.0
@export var player_life := 5

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")# Get the gravity from the project settings to be synced with RigidBody nodes.
var is_hurted := false
var knockback_vector := Vector2.ZERO
var direction

@onready var anim := $Animation as AnimatedSprite2D
@onready var remote_transform := $Remote as RemoteTransform2D

func _physics_process(delta):
	_set_state()
	move_and_slide()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	
	if direction != 0:
		velocity.x = direction * speed
		anim.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
		
	
func _on_hurtbox_body_entered(body):
	if $Ray_rigth.is_colliding():
		take_damage(Vector2(-200, -200))
	elif $Ray_left.is_colliding():
		take_damage(Vector2(200, -200))
	if player_life == 0:
		queue_free()
	
func  follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
	
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
	var knockback_tween := get_tree().create_tween()
	knockback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, 0.25)
	anim.modulate = Color(1,0,0,1)
	knockback_tween.parallel().tween_property(anim,"modulate", Color("white"), 0.5)
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false
		
func _set_state():
	var state = "Idle"
	
	if !is_on_floor():
		state = "Jump"
	elif direction != 0:
		state = "Run"
		
	if is_hurted:
		state = "Hurt"
		
	if anim.name != state:
		anim.play(state)
		
func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints >= 0:
			body.anim.play("hit")
			body.create_coin()
			if body.hitpoints == 0 :
				body.break_sprite()


