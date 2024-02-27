extends Control

@export var offset: float = 30.0
@export var scale_between_cards: float = 0.05
@export var anim_duration: float = 0.45
@export var anim_duration_offset: float = 0.15

var first_card_pos: Vector2
var first_card_scale: Vector2

var tween: Tween
var tween_last_card: Tween
var tween_bg: Tween

func _ready() -> void:
	for c in %Cards.get_children():
		c.put_back.connect(on_card_put_back.bind(c))
	
	var first_card: Button = %Cards.get_child(%Cards.get_child_count() - 1)
	first_card_pos = first_card.position
	first_card_scale = first_card.scale
	
	await get_tree().create_timer(0.5).timeout
	
	tween_bg_color(first_card.color)
	
	update_cards()
	
	await tween.finished
	for c in %Cards.get_children():
		c.original_position = c.global_position
	
func tween_bg_color(new_color: Color) -> void:
	if tween_bg and tween_bg.is_running():
		tween_bg.kill()
	tween_bg = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_bg.tween_property($BG, "color", new_color, anim_duration*2.0)
	
func update_cards(thrown: bool = false, animated: bool = true) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	
	var child_count: int = %Cards.get_child_count()
	var card_ref: Button = %Cards.get_child(child_count - 1)
	
	for i: int in range(child_count-1, -1, -1):
		var c: Button = %Cards.get_child(i)
		if c == card_ref:
			c.disabled = false
		else:
			c.disabled = true
		
		print("Button: ", c.get_name())
		var multiplier: float = child_count-1-i
		print("Multiplier: ", multiplier)
		var card_offset: float = offset*multiplier
		print("Card offset: ", card_offset)
		var card_scale: float = scale_between_cards * multiplier
		print("Card scale: ", card_scale)
		
		if not animated:
			c.position = first_card_pos - Vector2(0, card_offset)
			c.scale = first_card_scale - Vector2(card_scale, card_scale)
		else:
			var duration: float = anim_duration + (anim_duration_offset * multiplier)
			tween.tween_property(c, "position", first_card_pos - Vector2(0, card_offset), duration)
			tween.tween_property(c, "scale", first_card_scale - Vector2(card_scale, card_scale), duration)

func on_card_put_back(which: Button) -> void:
	print("Put back: ", which.get_name())
	
	var previous_card: Button = %Cards.get_child(%Cards.get_child_count()-2)
	tween_bg_color(previous_card.color)
	
	if tween_last_card and tween_last_card.is_running():
		tween_last_card.kill()
	tween_last_card = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween_last_card.tween_property(which, "global_position", $TopPoint.global_position-(which.size/2.0), anim_duration/2.0)
	tween_last_card.parallel().tween_property(which, "scale", Vector2(0.8, 0.8), anim_duration/2.0)
	
	# Move card to back
	tween_last_card.tween_callback(%Cards.move_child.bind(which, 0))
	tween_last_card.tween_callback(update_cards.bind(true))

	# Move card to back
	#%Cards.move_child(which, 0)
	
	# Recalculate positions
	#update_cards(true)

func set_cards_3D(state: bool) -> void:
	for c in %Cards.get_children():
		c.is_3D = state

func _on_check_button_toggled(toggled_on: bool) -> void:
	set_cards_3D(toggled_on)
