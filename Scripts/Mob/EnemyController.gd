extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 5
const SPEED = 100
const JUMP_HEIGHT = -250

var velocity = Vector2.ZERO
var moving_left = true

onready var ground_ray = $LimitCheck

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	velocity.y += GRAVITY
	
	# Veo si esta cerca del borde de la plataforma
	if !ground_ray.is_colliding():
		# Invierto escala y movimiento
		moving_left = !moving_left
		scale.x = -scale.x
	
	if moving_left:
		velocity.x = -SPEED
	else:
		velocity.x = SPEED
	
	
	velocity = move_and_slide(velocity, UP)
	
	pass
