class_name Unit
extends Node2D


@onready var sprite: Sprite2D = %Sprite
@onready var rank_icon: Sprite2D = %RankIcon
@onready var health_bar: ProgressBar = %HealthBar


var grid_position: Vector2i
var attack_power: int
var recoil: int
var health: int
var max_health: int
var speed: int


func init(data: MeleeUnitData, lane: int) -> void:
	grid_position = Vector2i(0, lane)
	attack_power = data.attack_power
	recoil = data.attack_recoil
	health = data.health
	max_health = health
	speed = data.speed
	if grid_position.y > 2:
		health_bar.add_theme_stylebox_override("fill", preload("res://src/ui/health_bar_fill_blue.tres"))
	update_health_bar()
	sprite.texture = data.icon
	rank_icon.texture = Util.rank_to_texture(data.rank)
	update_position()


func update_health_bar() -> void:
	var value = float(health) / max_health
	health_bar.value = value


func update_position() -> void:
	if grid_position.y < 2:
		position.y = 40 + 40 * grid_position.y
		if grid_position.x == 0:
			position.x = 50
		else:
			position.x = 80 + 40 * grid_position.x
	else:
		position.y = 200 + 40 * (grid_position.y - 3)
		if grid_position.x == 0:
			position.x = 590
		else:
			position.x = 560 - 40 * grid_position.x