## A generic melee unit creation action
extends CardAction


func can_perform(grid_pos: Vector2i, is_enemy: bool) -> bool:
	# Don't allow placing units on top of other units.
	if game.get_unit(grid_pos):
		return false
	return in_staging_area(grid_pos, is_enemy)


func perform_action(grid_pos: Vector2i, is_enemy: bool) -> void:
	var unit: MeleeUnit = preload("res://src/units/melee_unit.tscn").instantiate()
	if is_enemy:
		game.play_sound(game.SoundEffect.PLACE, false)
	else:
		game.play_sound(game.SoundEffect.PLACE, true)
	melee_units.add_child(unit)
	unit.init(data, grid_pos, game.grid_to_world_pos)
