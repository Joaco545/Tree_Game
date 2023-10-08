extends KinematicBody2D

export var velocity = 100
var direction = Vector2(1,1)
export var life_tmr = 100
var especial = false
var player_ref

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func Spawn(point_at, spawn_at, es_especial, player):
	print(point_at)
	velocity *= point_at
	position = spawn_at
	especial = es_especial
	player_ref = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(Vector2(velocity, 0), direction)
	
	life_tmr-=delta
	if life_tmr <= 0:
		Delete()
	
	# Reviso colisiones a ver si golpeo un enemigo
	for i in get_slide_count():
		var collided_obj = get_slide_collision(i).collider
		if collided_obj.name.begins_with("Enemy"):
			if collided_obj.is_tree:
				print("desconvertir")
				collided_obj.is_tree = false
				collided_obj.PlayAnimation("enemigo")
			if !collided_obj.is_tree and especial:
				print("Convertir!")
				collided_obj.is_tree = true
				player_ref.poder_restante -= 1
				collided_obj.PlayAnimation("arbol")
	
	# Si colisione, me elimino despues de ver que era
	if get_slide_count() > 0:
		Delete()

func Delete():
	queue_free()
