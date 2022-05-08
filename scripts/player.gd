extends KinematicBody


#TODO dont jump in runing

export var speed:= 7.0
export var jump_strength := 20.0
export var gravity := 50.0
export var character_height:= 1.6



var _velocity := Vector3.ZERO
var _snap_vector := Vector3.DOWN

onready var _anim_tree = $skin_position/fix_transforms/AnimationTree
onready var _spring_arm = get_node("SpringArm")
onready var _model = $skin_position
onready var label =$label




func _physics_process(delta : float) -> void:
	var move_direction :=Vector3.ZERO
	move_direction.x = Input .get_action_strength("rigth") - Input.get_action_strength("left")	
	move_direction.z = Input .get_action_strength("back") - Input.get_action_strength("forward")		
	move_direction=move_direction.rotated( Vector3.UP ,_spring_arm.rotation.y).normalized()
	
	var _speed = speed
	
	
	if (move_direction.x or move_direction.z) and is_on_floor():
		if Input.is_action_pressed("speed"):
			_speed = speed*2
			_anim_tree["parameters/playback"].travel("run")
		else:			
			_anim_tree["parameters/playback"].travel("walk")
	else:
		_anim_tree["parameters/playback"].travel("idle")
		
		
	
	_velocity.x = move_direction.x*_speed
	_velocity.z = move_direction.z*_speed
	_velocity.y -= gravity*delta
		

	var is_landed  :=is_on_floor() and _snap_vector==Vector3.ZERO
	var is_jumping :=is_on_floor() and Input.is_action_just_pressed("jump")

	if  is_jumping:
		_velocity.y = jump_strength
		_snap_vector = Vector3.ZERO
	elif is_landed:
		_snap_vector = Vector3.DOWN

	_velocity = move_and_slide_with_snap(_velocity,_snap_vector,Vector3.UP,true)

	if _velocity.length() > 0.2:
		var look_direction = Vector2(_velocity.z, _velocity.x)
		_model.rotation.y =look_direction.angle()

func _process(_delta)->void:
	
	_spring_arm.translation=Vector3(translation.x,translation.y + character_height,translation.z)
	
	#label.text = str(_delta)
	#print(str(_spring_arm.translation.y))
	





