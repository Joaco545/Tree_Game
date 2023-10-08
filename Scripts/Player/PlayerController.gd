extends KinematicBody2D

const UP = Vector2(0,-1)
const GRAVITY = 5
const MAX_SPEED = 200
const ACCELERATION = 50
const JUMP_HEIGHT = -275
const JUMP_FRAME = 2

onready var bala_scene = preload("res://Scenes/Bala.tscn")

onready var animacion = $AnimatedSprite
var velocity = Vector2.ZERO
# Uso de poder
export var delay_disparo = 1.0
var poder_restante = 0
var timer_disparo = 0.0
var puedo_disparar = false
var jumping = false

var looking_left = false

# Called when the node enters the scene tree for the first time.
func _ready():
	poder_restante = 1
	pass

# Llamar para inicializar al jugador
func Start(pos_inic, poder_inic):
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
		looking_left = false
	elif Input.is_action_pressed("move_left"):
		velocity.x = min(velocity.x + ACCELERATION, -MAX_SPEED)
		me_muevo = true
		animacion.flip_h = true
		looking_left = true
	
	
	if jumping:
		animacion.playing = false
		animacion.frame = JUMP_FRAME
	if me_muevo:
		animacion.playing = true
	else:
		animacion.playing = false
		animacion.frame = 0
	
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
			jumping = true
		else:
			jumping = false
		
		if me_muevo == false:
			velocity.x = lerp(velocity.x, 0, 0.2)
		
		
		# Si puedo disparar, apreto disparar, y estoy en el piso
		if puedo_disparar and Input.is_action_pressed("fire"):
			# Codgo de disparo
			var disparo = bala_scene.instance()
			if looking_left:
				disparo.Spawn(-1, $PowerSpawnL.global_position, poder_restante>0, $".")
			else:
				disparo.Spawn(1, $PowerSpawnR.global_position, poder_restante>0, $".")
			
			get_tree().root.get_child(0).add_child(disparo)
			puedo_disparar = false
			# Disparo projectil, con convertir = (poder > 0)
			pass
	else:
		# Aca puedo poner animaciones de salto o caida
		pass
	
	# Aplico velocidad
	velocity = move_and_slide(velocity, UP)
	
	# Reviso colisiones a ver si un enemigo me toco
	for i in get_slide_count():
		var collision = get_slide_collision(i).collider
		if collision.name.begins_with("Manzana"):
			poder_restante += 1
			collision.queue_free()
			print("Enemigo!")
