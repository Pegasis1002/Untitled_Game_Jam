extends CharacterBody2D

@onready var timer = $Timer
@export var patrol_points : Node
@onready var animated_sprite = $AnimatedSprite2D
@export var SPEED = 3000

var Health : int = 100

enum state { Idle, Run, attack }
var current_state : state
var direction : Vector2 = Vector2.LEFT
var number_of_points : int
var point_pos : Array[Vector2]
var current_point : Vector2
var current_point_pos : int
var can_walk : bool

func _ready():
	if patrol_points != null:
		number_of_points = patrol_points.get_children().size()
		for point in patrol_points.get_children():
			point_pos.append(point.global_position)
		current_point = point_pos[current_point_pos]
	else:
		print("No patrol points")
	
	current_state = state.Idle

func _physics_process(delta):
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	velocity.y += gravity * delta
	enemy_idle(delta)
	enemy_run(delta)
	enemy_animations()
	
	move_and_slide()

func enemy_idle(delta : float):
	if !can_walk:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		current_state = state.Idle

func enemy_run(delta : float):
	if !can_walk:
		return
	
	if abs(position.x - current_point.x) > 0.5:
		velocity.x = direction.x * SPEED * delta
		current_state = state.Run
	else:
		current_point_pos += 1
		
		if current_point_pos >= number_of_points:
			current_point_pos = 0
		
		current_point = point_pos[current_point_pos]
		velocity.x = direction.x * SPEED * delta
		if current_point.x > position.x:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
		can_walk = false
		timer.start()
	
	animated_sprite.flip_h = direction.x < 0

func enemy_animations():
	if current_state == state.Idle && !can_walk:
		animated_sprite.play("idle")
	elif current_state == state.Run && can_walk:
		animated_sprite.play("run")

func _on_timer_timeout():
	can_walk = true
