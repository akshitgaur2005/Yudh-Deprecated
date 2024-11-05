extends CharacterBody3D


const SPEED = 10
const JUMP_VELOCITY = 2
const ROTATE_SPEED = 0.3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var body_pivot = $BodyPivot
@onready var animation_player = $AnimationPlayer

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var attack = randi_range(0, 100)
	#var attack = 0
	if Input.is_action_pressed("attack"):
		attack = 1
	if attack == 1:
		attack()
	
	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1))
	#var input_dir = Vector2(0, 0)
	var to_rotate = randf_range(-1, 1)
	#var to_rotate = 0
	#if Input.is_action_pressed("left"):
	#	to_rotate = 1
	#if Input.is_action_pressed("right"):
	#	to_rotate = -1
	#print(input_dir)

	
	if animation_player.current_animation != "thrust":
		rotation.y += to_rotate * ROTATE_SPEED
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

func attack():
	animation_player.play("thrust")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "thrust":
		animation_player.play("idle")

func _on_area_3d_body_entered(body: Node3D) -> void:
	queue_free()
