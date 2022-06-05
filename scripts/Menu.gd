extends MarginContainer

var seleccionando = 0

func _input(event):
	if Input.is_action_pressed("abajo"):
		seleccionando += 1
		$katana.rect_position.y += 30
	if Input.is_action_pressed("arriba"):
		seleccionando -= 1
		$katana.rect_position.y -= 30
	# Cuando ya se selecciono
	if Input.is_action_just_pressed("ataque"):
		if seleccionando == 1:
			#yield($AnimationPlayer, "animation_finished")
			_on_start_pressed()
		if seleccionando == 2:
			#yield($AnimationPlater, "animation_finished")
			_on_exit_pressed()
	# Pararse en una opción
	if seleccionando == 1:
		$PanelContainer/VBoxContainer/Start.modulate = Color.purple
		$PanelContainer/VBoxContainer/Exit.modulate = Color.white
	elif seleccionando == 2:
		$PanelContainer/VBoxContainer/Start.modulate = Color.white
		$PanelContainer/VBoxContainer/Exit.modulate = Color.purple
	elif seleccionando != 1 and seleccionando != 2:
		$PanelContainer/VBoxContainer/Start.modulate = Color.white
		$PanelContainer/VBoxContainer/Exit.modulate = Color.white
func _on_start_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")
	
func _on_exit_pressed():
	get_tree().quit()
