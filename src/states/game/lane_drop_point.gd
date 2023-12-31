class_name LaneDropPointScene
extends Area2D


const Tooltip = preload("res://src/ui/tooltip.tscn")
const ENABLE_COLOR = Color.TRANSPARENT
const DISABLE_COLOR = Color(0.0, 0.0, 0.0, 0.5)
const POSITIVE_COLOR = Color(0.0, 1.0, 0.0, 0.5)
const NEGATIVE_COLOR = Color(1.0, 0.0, 0.0, 0.5)


@export var grid_position := Vector2i(0, 0)

var enabled := true ## False if the selected card cannot be placed here.
var is_mouse_inside := false # Is there a native variable for this?
var open_tooltip: Control = null
var extra_stats: Dictionary = {} # Extra stats to be added to base.

# "Left" and "Right" will be flipped in the player field/castle
var ho_left: Line2D
var ho_right: Line2D
@onready var ho_bottom: Line2D = $HoverOutline/Bottom
@onready var ho_top: Line2D = $HoverOutline/Top

@onready var tooltip_delay: Timer = %TooltipDelay
@onready var game: GameScene = find_parent("Game")
@onready var overlay: Polygon2D = %Overlay


func _ready() -> void:
	# Set the overlay equal to the hitbox.
	overlay.set_polygon($CollisionPolygon2D.get_polygon())
	if grid_position.y >= 3:
		ho_left = $HoverOutline/Right
		ho_right = $HoverOutline/Left
	else:
		ho_left = $HoverOutline/Left
		ho_right = $HoverOutline/Right


func _mouse_enter() -> void:
	is_mouse_inside = true
	game.on_card_enter(self)
	check_for_start_tooltip()


func _mouse_exit() -> void:
	is_mouse_inside = false
	game.on_card_exit()
	close_tooltip()


func set_enabled(_enabled: bool) -> void:
	self.enabled = _enabled
	reset()


func set_positive() -> void:
	overlay.color = POSITIVE_COLOR


func set_negative() -> void:
	overlay.color = NEGATIVE_COLOR


func set_hovering(other_tiles: Array[Vector2i]) -> void:
	if grid_position.x in [0, 1, 8] or (grid_position + Vector2i.LEFT) not in other_tiles:
		ho_left.show()
	if grid_position.x in [0, 7, 10] or (grid_position + Vector2i.RIGHT) not in other_tiles:
		ho_right.show()
	if grid_position.y in [0, 3] or (grid_position + Vector2i.UP) not in other_tiles:
		ho_top.show()
	if grid_position.y in [2, 5] or (grid_position + Vector2i.DOWN) not in other_tiles:
		ho_bottom.show()


func reset() -> void:
	for ho_line in $HoverOutline.get_children():
		ho_line.hide()
	if enabled:
		overlay.color = ENABLE_COLOR
	else:
		overlay.color = DISABLE_COLOR


func check_for_start_tooltip() -> void:
	if open_tooltip == null and game.get_unit(grid_position) and game.can_display_tooltip:
		tooltip_delay.start()


func close_tooltip() -> void:
	if open_tooltip:
		open_tooltip.queue_free()
		game.find_child("CanvasLayer").remove_child(open_tooltip)
		open_tooltip = null
	tooltip_delay.stop()


func _on_tooltip_delay_timeout() -> void:
	if not is_mouse_inside or not game.get_unit(grid_position):
		return
	open_tooltip = Tooltip.instantiate()
	game.find_child("CanvasLayer").add_child(open_tooltip)
	open_tooltip.initialize(game.get_unit(grid_position))
