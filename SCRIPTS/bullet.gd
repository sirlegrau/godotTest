extends Area2D

# Variables
@export var speed: float = 1000.0  # Speed of the bullet
@export var lifetime: float = 2.0  # How long the bullet lives before disappearing
var direction: int = 1  # 1 for right, -1 for left

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

func _on_body_entered(body:Node2D):
    if body.is_in_group("tilemap"):  # Check if it collides with the TileMap
        var tilemap = body as TileMap  # Cast to TileMap
        
        # Convert the bullet's position to tilemap coordinates using local_to_map()
        var cell_position = tilemap.local_to_map(tilemap.to_local(global_position))

        # Check if the cell position is within the bounds of the TileMap
        if tilemap.get_cell_source_id(0,cell_position) != -1:  # Ensure the tile exists
            tilemap.set_cell(0,cell_position, -1)  # Remove the tile by setting its value to -1

        queue_free()  # Destroy the bullet upon collision