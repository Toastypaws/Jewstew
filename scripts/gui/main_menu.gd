extends Control

@onready var current_scene = get_tree().current_scene.name;
@onready var main:Control = $main;
@onready var options:Control = $options;
@onready var graphics:Control = $graphics;
@onready var warp:Control = $warp;

func _ready():
	if(current_scene == "main_menu"):
		$main/button_start.visible = true;
	else:
		$main/button_continue.visible = true;
		main.visible = false;

func _input(event):
	if(current_scene != "main_menu"):
		if(Input.is_action_just_pressed("pause_toggle")):
			if(get_tree().paused == false):
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
				get_tree().paused = true;
				main.visible = true;
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
				get_tree().paused = false;
				main.visible = false;

# MAIN =================================================
func _on_button_start_pressed():
	get_tree().change_scene_to_file(global.WAREHOUSE_SRC);
	
func _on_button_continue_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	get_tree().paused = false;
	main.visible = false;

func _on_button_quit_pressed():
	get_tree().quit();
	
func _on_main_button_options_pressed():
	main.visible = false;
	options.visible = true;

# OPTIONS ==================================================
func _on_options_button_return_pressed():
	options.visible = false;
	main.visible = true;

func _on_options_button_graphics_pressed():
	options.visible = false;
	graphics.visible = true;
	
func _on_button_warp_pressed():
	options.visible = false;
	warp.visible = true;

# GRAPHICS ==================================================
func _on_graphics_button_return_pressed():
	graphics.visible = false;
	options.visible = true;

# WARP ==================================================
func _on_warp_button_return_pressed():
	warp.visible = false;
	options.visible = true;

func _on_warp_button_warehouse_pressed():
	get_tree().paused = false;
	get_tree().change_scene_to_file(global.WAREHOUSE_SRC);

func _on_warp_button_hills_pressed():
	get_tree().paused = false;
	get_tree().change_scene_to_file(global.HILLS_SRC);

func _on_warp_button_main_menu_pressed():
	get_tree().paused = false;
	get_tree().change_scene_to_file(global.MAIN_MENU_SRC);
