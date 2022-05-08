extends SpringArm

export var mouse_sensetive:=0.5

func _ready()->void:
	set_as_toplevel(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	

func _unhandled_input(event:InputEvent)->void:	
	
	if Input.is_action_just_pressed("ui_cancel") :
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else :
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				if spring_length > 1 :
					spring_length=spring_length - 0.5
			if event.button_index == BUTTON_WHEEL_DOWN:
				if spring_length < 7 :
					spring_length=spring_length + 0.5
	
	if event is InputEventMouseMotion:
		rotation_degrees.x-=event.relative.y*mouse_sensetive
		rotation_degrees.x = clamp(rotation_degrees.x,-70,20)
		rotation_degrees.y-=event.relative.x*mouse_sensetive
		rotation_degrees.y = wrapf(rotation_degrees.y,0.0,360.0)
