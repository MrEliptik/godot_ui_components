extends Control


func _ready() -> void:
	pass # Replace with function body.

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().quit()
