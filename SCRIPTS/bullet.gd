extends Area2D

# Variables
@export var speed: float = 1000.0  # Speed of the bullet
@export var lifetime: float = 2.0  # How long the bullet lives before disappearing
var direction: int = 1  # 1 for right, -1 for left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    add_to_group("bullets")
    # Schedule the bullet to be removed after its lifetime ends
    await get_tree().create_timer(lifetime).timeout
    queue_free()

# Process function to handle bullet movement
func _process(delta: float) -> void:
    # Move the bullet based on its direction
    position += Vector2(speed * direction * delta, 0)

# Function to set the bullet's direction
func set_direction(is_right: bool) -> void:
    direction = 1 if is_right else -1  # 1 for right, -1 for left


