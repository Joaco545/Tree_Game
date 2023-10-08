extends KinematicBody2D

export var velocity = 100
var direction = Vector2(1,1)
export var life_tmr = 100

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func spawn(point_at, spawn_at):
	print(point_at)
	velocity *= point_at
	position = spawn_at

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	move_and_slide(Vector2(velocity, 0), direction)
	life_tmr-=delta
	if life_tmr <= 0:
		queue_free()
