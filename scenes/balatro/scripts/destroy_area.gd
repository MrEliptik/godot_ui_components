extends Panel

func _on_area_2d_area_entered(area):
	area.get_parent().destroy()
