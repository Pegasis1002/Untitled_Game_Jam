extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = Vector2.LEFT

var agro = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if !agro:
		animated_sprite.play("run")
		if direction:
			velocity.x = direction.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()


func _on_startpoint_body_entered(body):
	direction = Vector2.RIGHT
	animated_sprite.flip_h = false

func _on_end_point_body_entered(body):
	direction = Vector2.LEFT
	animated_sprite.flip_h = true


func _on_agro_radius_body_entered(body):
	agro = true
	var ppos = (body.position - position).normalized()
	print(ppos)
	velocity.x = -direction.x * SPEED
	move_and_slide()

func _on_agro_radius_body_exited(body):
	agro = false
	

func _on_melle_radius_body_entered(body):
	agro = true
	attack(body)

func attack(body):
	animated_sprite.play("attack1")
