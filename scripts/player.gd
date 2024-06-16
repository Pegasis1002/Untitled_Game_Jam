extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var startpoint = $"../Enemy/startpoint"
@onready var end_point = $"../Enemy/end point"

const SPEED = 230.0
const JUMP_VELOCITY = -300.0
const MAX_JUMP_TIME = 0.3  # Maximum time since last on floor to allow jumping

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Timer to keep track of how long it's been since the player was last on the floor.
var time_since_on_floor = 0.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		time_since_on_floor += delta  # Update the timer
	else:
		time_since_on_floor = 0.0  # Reset the timer

	# Handle jump.
	if Input.is_action_just_pressed("jump") and time_since_on_floor <= MAX_JUMP_TIME:
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1 0 +1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jumpp")
	
	# Update velocity based on direction
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

