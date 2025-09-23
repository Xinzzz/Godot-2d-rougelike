extends CharacterBody2D

@export var speed: int

var pos
var rot

@onready var gun = $Gun_handler
@onready var gun_sprite = $Gun_handler/Gun_sprite
@onready var bullet_point = $Gun_handler/Bullet_point

var input_movement = Vector2()

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	movement(delta)	
	target_mouse()

func movement(delta):
	input_movement = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	anim_play()
	if input_movement != Vector2.ZERO:
		velocity = input_movement * speed * delta
	
	if input_movement == Vector2.ZERO:
		velocity = Vector2.ZERO
	
	move_and_slide()

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
		
func target_mouse():
	var mouse_movement = get_global_mouse_position()
	pos = global_position
	gun.look_at(mouse_movement)
	rot = rad_to_deg((mouse_movement - pos).angle())
	if rot >= -90 and rot <= 90:
		gun_sprite.flip_v = false
	else:
		gun_sprite.flip_v = true
