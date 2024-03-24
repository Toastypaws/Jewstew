extends Control

@onready var main:Control = $main

func _input(event):
	if(Input.is_action_just_pressed("pause_toggle")):
		if(get_tree().paused == false):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
			get_tree().paused = true;
			main.visible = true;

func _on_button_continue_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
	get_tree().paused = false;
	main.visible = false;
