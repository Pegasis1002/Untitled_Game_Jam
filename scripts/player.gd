extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

const SPEED = 230.0
const JUMP_VELOCITY = -300.0
const MAX_JUMP_TIME = 0.3  # Maximum time since last on floor to allow jumping

enum State { idle, run, atack }
var current_state : State
var can_move : bool
var is_attacking : bool

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Timer to keep track of how long it's been since the player was last on the floor.
var time_since_on_floor = 0.0
# Get the input direction: -1 0 +1

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
	
	var direction = Input.get_axis("move_left", "move_right")
	
	player_idle(delta)
	player_run(delta, direction)
	attack_system(delta)
	player_animations(direction)

	move_and_slide()

func player_idle(delta : float):
	if !can_move:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		current_state = State.idle

func player_run(delta : float, direction):
	if !can_move:
		return
	current_state = State.run
	
	if direction:
		velocity.x = direction * SPEED
	

func attack_system(delta):
	if Input.is_action_just_pressed("primary_attack"):
		can_move = false
		is_attacking = true
	else:
		can_move = true
		is_attacking = false

func player_animations(direction):
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		elif can_move:
			animated_sprite.play("run")
		elif is_attacking:
			animated_sprite.play("attack1")
	else:
		animated_sprite.play("jumpp")
	
	
