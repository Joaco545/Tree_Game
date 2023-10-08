extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 5
const SPEED = 100
const JUMP_HEIGHT = -250

var velocity = Vector2.ZERO
var moving_left = true
var is_tree = false

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
	if !is_tree:
		if moving_left:
			velocity.x = -SPEED
		else:
			velocity.x = SPEED
	else:
		velocity.x = 0
	
	velocity = move_and_slide(velocity, UP)
	
	for i in get_slide_count():
		var collided_obj = get_slide_collision(i).collider
		if collided_obj.name.begins_with("Player"):
			# Game over code
			collided_obj.position = Vector2(0,500)
			pass
		
		$EnemyCollider.disabled = is_tree
		$TreeCollider.disabled = !is_tree

func PlayAnimation(name):
	$AnimatedSprite.play(name)
