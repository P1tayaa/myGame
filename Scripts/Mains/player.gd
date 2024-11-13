extends Actor

const SPEED = 0.5
const JUMP_VELOCITY = -300.0
const CLIM_SPEED = -50.0


func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-Input.get_action_strength("ui_accept") if is_on_floor() and Input.is_action_just_pressed("ui_accept") else 0.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		_speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var _velocity: = linear_velocity
	_velocity.x = _speed.x * direction.x * SPEED
	if direction.y != 0.0:
		_velocity.y = _speed.y * direction.y
	if is_jump_interrupted:
		_velocity.y = 0.0
	return _velocity
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var is_jump_interrupted: = Input.is_action_just_released("ui_accept") and velocity.y < 0.0
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	var ignore_floor : bool = false
	if (Input.is_action_pressed("ui_down")):
		ignore_floor = true  
	if ($ShapeCast2D.is_colliding() and Input.is_action_pressed("ui_up")):
		velocity.y = CLIM_SPEED
		ignore_floor = true
	if (ignore_floor and get_collision_mask_value(2)):
		set_collision_mask_value(2, false)
	if (!ignore_floor and !get_collision_mask_value(2)):
		set_collision_mask_value(2, true)
	move_and_slide()
	set_floor_snap_length(1)
	#else:
		#move_and_collide(velocity)
		
