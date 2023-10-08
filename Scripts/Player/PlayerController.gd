extends KinematicBody2D
signal hit

const UP = Vector2(0,-1)
const GRAVITY = 5
const MAX_SPEED = 200
const ACCELERATION = 50
const JUMP_HEIGHT = -250

onready var animacion = $AnimatedSprite
var velocity = Vector2.ZERO
# Uso de poder
export var delay_disparo = 1.0
var poder_restante = 0
var timer_disparo = 0.0
var puedo_disparar = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Llamar para inicializar al jugador
func start(pos_inic, poder_inic):
	
	position = pos_inic
	poder_restante = poder_inic
	timer_disparo = delay_disparo
	puedo_disparar = true
	show()
	$CollisionShape2D.disabled = false
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += GRAVITY
	var me_muevo = false
	
	# Manejo inputs y prendo el flag de movimiento
	# Flip para animacion aca?
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
		me_muevo = true
		animacion.flip_h = false
	elif Input.is_action_pressed("move_left"):
		velocity.x = min(velocity.x + ACCELERATION, -MAX_SPEED)
		me_muevo = true
		animacion.flip_h = true
	else:
		animacion.flip_h = false
	
	# Si no puedo disparar, reduzco timer y veo si ya puedo disparar
	if puedo_disparar == false:
		timer_disparo -= delta
		if (timer_disparo <= 0):
			timer_disparo = delay_disparo
			puedo_disparar = true
	
	# Veo si estoy en el piso para poder saltar y ver si aplico frenado
	if is_on_floor():
		
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_HEIGHT
			
		if me_muevo == false:
			velocity.x = lerp(velocity.x, 0, 0.2)
			
		# Si puedo disparar, apreto disparar, y estoy en el piso
		if puedo_disparar and Input.is_action_pressed("fire"):
			# Codgo de disparo
			print("Disparo!!")
			puedo_disparar = false
			# Disparo projectil, con convertir = (poder > 0)
			pass
	else:
		# Aca puedo poner animaciones de salto o caida
		pass
	
	# Aplico velocidad
	velocity = move_and_slide(velocity, UP)


func _on_Player_body_entered(body):
	# Animacion golpeado
	$AnimatedSprite.play()
	# Emitimos hit signal
	emit_signal("hit")
	# Desabilitamos las colisiones para que no trigeree otra vez
	$CollisionShape2D.set_deferred("disabled", true)
