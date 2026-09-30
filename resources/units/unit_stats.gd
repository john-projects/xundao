extends Resource
class_name UnitStats

enum UnitType {
	PLAYER,
	ENEMY
}

@export var name: String
@export var type: UnitType
@export var icon: Texture2D
@export var health:= 1.0
@export var health_increase_per_wave:= 1.0
@export var damage:= 1.0
@export var damage_increase_per_wave:= 1.0
@export var speed:= 300
@export var luck:= 1.0
@export var block_chance:= 0.0
@export var gold_drop:= 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
