extends CenterContainer

const vert_offset = 42.0

@onready var info_text: Label = %InfoText
@onready var damage_amt: Label = %DamageAmt
@onready var health_amt: Label = %HealthAmt
@onready var move_amt: Label = %MoveAmt
@onready var damage_icon: TextureRect = %DamageIcon
@onready var health_icon: TextureRect = %HealthIcon
@onready var move_icon: TextureRect = %MoveIcon


func initialize(unit: Unit) -> void:
	if unit is RangedUnit:
		damage_amt.text = str(unit.attack_damage) + add_extra_stats_text(unit, "attack_damage")
		health_icon.hide()
		health_amt.hide()
		move_icon.hide()
		move_amt.hide()
	elif unit is MeleeUnit:
		damage_amt.text = str(unit.attack_power) + add_extra_stats_text(unit, "attack_power")
		health_amt.text = str(unit.health) + add_extra_stats_text(unit, "health")
		move_amt.text = str(unit.speed) + add_extra_stats_text(unit, "speed")
	elif unit is BarricadeUnit:
		health_amt.text = str(unit.health)
		move_icon.hide()
		move_amt.hide()
		damage_icon.hide()
		damage_amt.hide()

	if not unit.special_effect == "":
		info_text.text = unit.special_effect
	else:
		info_text.hide()

	call_deferred("set_pos", unit)


func add_extra_stats_text(unit: Unit, stat_name: String) -> String:
	if unit.extra_stats.get(stat_name, 0):
		return "(%+d)" % int(unit.extra_stats.get(stat_name))
	return ""


func set_pos(unit: Unit) -> void:
	var position_offset := Vector2(-100, -100)
	if unit.grid_position.y < 3:
		position_offset.y += vert_offset
	else:
		position_offset.y -= vert_offset - 5
	position = unit.position + position_offset
	position.x = clampf(position.x, -100 + size.x / 2, 740 - size.x / 2)
