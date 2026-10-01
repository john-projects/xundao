extends Area2D
class_name HitboxComponent

signal on_hit_hurtbox(hurtbox: HurtboxComponent)

var damage := 1.0
var critical := false
var knockback_power := 0.0
var source: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enable() -> void:
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	
func disable() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	
func setup(damage: float, critical: bool, knockback: float, source: Node2D) -> void:
	self.damage = damage
	self.critical = critical
	knockback_power = knockback
	self.source = source
	

func _on_area_entered(area: Area2D) -> void:
	if area is HurtboxComponent:
		on_hit_hurtbox.emit(area)
		print(area.owner.name)
