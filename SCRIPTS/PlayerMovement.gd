extends CharacterBody2D

# Variables for movement
@export var bullet_scene: PackedScene  # Assign this to your Bullet.tscn in the editor
@export var fire_rate: float = 0.15  # Time delay between shots
@export var speed: float = 300.0  # Horizontal movement speed
@export var jump_force: float = 500.0  # Jumping force
@export var gravity: float = 900.0  # Gravity applied to the player


var can_shoot: bool = true

func _ready():
    var bullet = bullet_scene.instantiate() as Area2D
    bullet.position = position
    get_parent().add_child(bullet)
    print('bullet ready')
# Function to handle movement
func _physics_process(delta):
    # Apply gravity to the vertical velocity
    if not is_on_floor():
        velocity.y += gravity * delta
    
    # Handle horizontal movement
    var direction = 0
    if Input.is_action_pressed("ui_right"):
        direction += 1
        Global.player_direction = true
    elif Input.is_action_pressed("ui_left"):
        direction -= 1
        Global.player_direction = false
    
    velocity.x = direction * speed
    
    # Handle jumping
    if Input.is_action_just_pressed("ui_up") and is_on_floor():
        velocity.y = -jump_force

    if Input.is_action_pressed("shoot") and can_shoot:
        print("shooting 2")
        shoot_bullet()
    
    # Move the player character
    move_and_slide()


# Function to shoot a bullet
func shoot_bullet() -> void:
    if not bullet_scene:
        print("Bullet scene is not assigned!")
        return

    var bullet = bullet_scene.instantiate() as Area2D
    bullet.position = position  # Set the bullet's position to the player's position
    
    # Set bullet direction based on the current player's facing direction
    
    bullet.set_direction(Global.player_direction)  # Pass the boolean to set the direction

    get_parent().add_child(bullet)  # Add the bullet to the scene
    can_shoot = false  # Prevent shooting until cooldown is over
    await get_tree().create_timer(fire_rate).timeout  # Wait for the fire rate delay
    can_shoot = true  # Allow shooting again


