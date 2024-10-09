extends Area2D

@export var shooting_interval: float = 1.0  # Time between shots
@export var bullet_speed: float = 300.0  # Speed of enemy bullets


var player: Node2D = null  # Reference to the player
var can_shoot: bool = false  # Whether the enemy can shoot
var last_shot_time: float = 0.0  # Timer to control shooting
@export var bullet_scene: PackedScene  # Assign this to your Bullet.tscn in the editor

# Called when the node enters the scene tree for the first time
func _ready() -> void:
    pass


#DETECTION AREA CONTROLLER
func _on_detection_area_body_entered(body:CharacterBody2D):
    player = body # Store a reference to the player
    print("PLAYER ENTERING RANGE", player, player.name)
    if (body.name == "PlayerBody2D"):  # If the detected area is the player
        $AnimationPlayer.play("ShowQuestionMark")  # Play the "?" animation
        can_shoot = true
    
func _on_detection_area_body_exited(body: CharacterBody2D):
    if (body.name == "PlayerBody2D"):  # If the player leaves detection range
        print("PLAYER LEAVING AREA")
        player = null
        can_shoot = false

func _process(delta: float) -> void:
    if can_shoot and player != null:
        face_player()
        if Time.get_ticks_msec() / 1000.0 - last_shot_time >= shooting_interval:
            shoot_at_player()
            last_shot_time = Time.get_ticks_msec() / 1000.0

func face_player() -> void:
    if player.position.x < position.x:
        scale.x = 1  # Face right
    else:
        scale.x = -1  # Face left

func shoot_at_player() -> void:
    var bullet = bullet_scene.instantiate()
    get_parent().add_child(bullet)
    bullet.position = $BulletSpawnPoint.global_position
    if(self.position.x - player.position.x < 0 ):
        bullet.set_direction(true);
    else:
        bullet.set_direction(false);
func _on_area_entered(area:Area2D):
    if area.is_in_group("bullets"):
        area.queue_free()  # Destroy the bullet
        die()  # Call die function if health is zero
    

# Function to handle the enemy's death
func die() -> void:
    queue_free()  # Remove the enemy from the scene
