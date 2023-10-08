extends Node2D

func _on_boton1_pressed():
	get_tree().change_scene("res://Scenes/Nivel1.tscn")

func _on_botonSalir_pressed():
	get_tree().quit()
