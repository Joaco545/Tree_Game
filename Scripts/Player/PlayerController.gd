extends Area2D
signal hit

# Declare member variables here. Examples:
export var speed = 400 # How fast the player will move (pixels/sec).
export var jump_force = 400
var screen_size # Size of the game window.
var collider_size = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	collider_size = $CollisionShape2D.shape.extents
	print(collider_size)

# Llamar para inicializar al jugador
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	
	if Input.is_action_pressed("move_right"):
		velocity.y = 1
	
	# Si me muevo
	if velocity.length() > 0:
		velocity.x *= speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	
	
	# Aplicando el movimiento y haciendo que no se pase de la pantalla
	position.x += velocity.x * delta
	position.x = clamp(position.x, collider_size.x, screen_size.x-collider_size.x)
	position.y = clamp(position.y, collider_size.y, screen_size.y-collider_size.y)



func _on_Player_body_entered(body):
	# Animacion golpeado
	$AnimatedSprite.play()
	# Emitimos hit signal
	emit_signal("hit")
	# Desabilitamos las colisiones para que no trigeree otra vez
	$CollisionShape2D.set_deferred("disabled", true)
