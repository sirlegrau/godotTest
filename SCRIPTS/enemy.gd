extends Area2D

# Variables
@export var health: int = 3  # Enemy health
@export var speed: float = 50.0  # Speed of the enemy movement
@export var damage: int = 1  # Damage to the player (if needed)

# Called when the node enters the scene tree for the first time
func _ready() -> void:
    pass


func _on_area_entered(area:Area2D):
    if area.is_in_group("bullets"):
        area.queue_free()  # Destroy the bullet
        die()  # Call die function if health is zero
    

# Function to handle the enemy's death
func die() -> void:
    queue_free()  # Remove the enemy from the scene


