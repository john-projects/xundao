extends Node2D
class_name WeaponBehavior

@export var weapon: Weapon

var critical := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func execute_attack() -> void:
	pass
	
func get_damage() -> float:
	var damage := weapon.data.stats.damage + Global.player.stats.damage
	var crit_chance := weapon.data.stats.crit_chance
	if Global.get_chance_success(crit_chance):
		critical = true
		damage = ceil(damage * weapon.data.stats.crit_damage)
	return damage
