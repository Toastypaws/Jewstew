extends Camera3D

const ROTATE_SPEED:float = 0.05;

func _process(delta):
	rotate_y(ROTATE_SPEED * delta);
