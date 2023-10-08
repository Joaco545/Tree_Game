extends Area2D

func _on_Fallzone_body_entered(body):
	get_tree().change_scene("res://Scenes/SelectorNivel.tscn")
