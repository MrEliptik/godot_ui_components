extends Control


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "rotate":
		get_tree().quit()
