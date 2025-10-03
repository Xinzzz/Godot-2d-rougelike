extends CharacterBody2D

@export var speed: int
enum player_states {MOVE, DEAD}

var pos
var rot
var is_dead = false
var current_state = player_states.MOVE


@onready var bullet_scene = preload("res://Entities/Scenes/Bullets/bullet_1.tscn")
@onready var gun = $Gun_handler
@onready var gun_sprite = $Gun_handler/Gun_sprite
@onready var bullet_point = $Gun_handler/Bullet_point

var input_movement = Vector2()

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	target_mouse()
	
	if player_data.health <= 0:
		current_state = player_states.DEAD
	
	match current_state:
		player_states.MOVE:
			movement(delta)	
		player_states.DEAD:
			dead()
			
func movement(delta):
	input_movement = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	anim_play()
	if input_movement != Vector2.ZERO:
		velocity = input_movement * speed * delta
	
	if input_movement == Vector2.ZERO:
		velocity = Vector2.ZERO
	
	move_and_slide()

func dead():
	is_dead = true
	velocity = Vector2.ZERO
	gun.visible = false
	$Anim.play("Dead")
	await get_tree().create_timer(2).timeout
	if get_tree():
		get_tree().reload_current_scene()
		player_data.health = 4
		is_dead = false

func anim_play():
	var mouse_movement = get_global_mouse_position()
	pos = global_position
	if mouse_movement - pos >= Vector2.ZERO:
		$Player_sprite.flip_h = false
	else:
		$Player_sprite.flip_h = true
			
	if input_movement != Vector2.ZERO:
		$Anim.play("Move")
	 
	if input_movement == Vector2.ZERO:
		$Anim.play("Idle")
		
	if Input.is_action_just_pressed("ui_shoot"):
		instance_bullet()
		
func target_mouse():
	var mouse_movement = get_global_mouse_position()
	pos = global_position
	gun.look_at(mouse_movement)
	rot = rad_to_deg((mouse_movement - pos).angle())
	if rot >= -90 and rot <= 90:
		gun_sprite.flip_v = false
	else:
		gun_sprite.flip_v = true


func instance_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.direction = bullet_point.global_position - gun.global_position
	print(bullet.direction)
	bullet.global_position = bullet_point.global_position
	get_tree().root.add_child(bullet)
