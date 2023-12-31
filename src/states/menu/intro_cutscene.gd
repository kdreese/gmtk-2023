extends Control


@onready var background_texture: TextureRect = %BackgroundTexture
@onready var fanfare: AudioStreamPlayer = %Fanfare
@onready var title: Label = %Title
@onready var buttons: VBoxContainer = %Buttons
@onready var skip_button: Button = $SkipButton



const MENU = preload("res://src/states/menu/menu.tscn")


func _ready() -> void:
	title.modulate = Color.TRANSPARENT
	buttons.modulate = Color.TRANSPARENT
	fanfare.play()

	create_tween().tween_property(background_texture, "position", Vector2(0, -480), 10.0)
	get_tree().create_timer(7.5).timeout.connect(fade_in_title)
	get_tree().create_timer(17.0).timeout.connect(go_to_menu)


func fade_in_title() -> void:
	create_tween().tween_property(title, "modulate", Color.WHITE, 1.0)


func go_to_menu() -> void:
	get_tree().change_scene_to_packed.call_deferred(MENU)


func skip_cutscene() -> void:
	fanfare.stop()
	go_to_menu()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		skip_cutscene()
		get_viewport().set_input_as_handled()
	elif event is InputEventKey or event is InputEventMouseButton:
		if not skip_button.visible:
			skip_button.show()
