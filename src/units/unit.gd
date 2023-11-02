class_name Unit
extends Node2D

var grid_position: Vector2i
var grid_to_world_position : Dictionary # Dictionary[Vector2i, Vector2]
var special_effect: String
var card_data: CardData

# Extra stats to be added to base.
var extra_stats: Dictionary = {}
