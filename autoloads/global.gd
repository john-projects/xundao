extends Node

signal on_create_block_text(unit: Node2D)
signal on_create_damage_text(unit: Node2D, hitbox: HitboxComponent)
signal on_create_heal_text(unit: Node2D, heal: float)

signal on_upgrade_selected

const FLASH_MATERIAL = preload("uid://beabn3es4m4m7")
const FLOATING_TEXT_SCENE = preload("uid://btdihrlsugqm0")

const COMMON_STYLE = preload("uid://c383vl8xrt17p")
const EPIC_STYLE = preload("uid://bvy27iuomo6rx")
const LEGENDARY_STYLE = preload("uid://v4id7ydojihc")
const RARE_STYLE = preload("uid://5vcw7m8i2ilu")


const UPGRADE_PROBABILITY_CONFIG = {
	"rare": {"start_wave": 2, "base_multi": 0.06},
	"epic": {"start_wave": 4, "base_multi": 0.02},
	"legendary": {"start_wave": 7, "base_multi": 0.0023},
}

enum UpgradeTier{
	COMMON,
	RARE,
	EPIC,
	LEGENDARY
}

var coins: int
var player: Player
var game_paused := false

func get_harvesting_coins() -> void:
	coins += player.stats.harvesting

func get_chance_success(chance: float) -> bool:
	var random := randf_range(0, 1.0)
	if random < chance:
		return true
	return false

func get_tier_style(tier: UpgradeTier) -> StyleBoxFlat:
	match tier:
		UpgradeTier.RARE:
			return RARE_STYLE
		UpgradeTier.EPIC:
			return EPIC_STYLE
		UpgradeTier.LEGENDARY:
			return LEGENDARY_STYLE
		_:
			return COMMON_STYLE

func calculate_tier_probability(current_wave: int, config: Dictionary) -> Array[float]:
	var common_chance := 0.0
	var rare_chance := 0.0
	var epic_chance := 0.0
	var legendary_chance := 0.0
	
	if current_wave >= config.rare.start_wave:
		rare_chance = min(1.0, (current_wave - config.rare.start_wave + 1) * config.rare.base_multi)
	if current_wave >= config.epic.start_wave:
		epic_chance = min(1.0, (current_wave - config.epic.start_wave + 1) * config.epic.base_multi)
	if current_wave >= config.legendary.start_wave:
		legendary_chance = min(1.0, (current_wave - config.legendary.start_wave + 1) * config.legendary.base_multi)
	
	var luck_factor := 1.0 + (Global.player.stats.luck / 100.0)
	rare_chance *= luck_factor
	epic_chance *= luck_factor
	legendary_chance *= luck_factor
	
	var total_non_common_chances := rare_chance + epic_chance + legendary_chance
	if total_non_common_chances > 1.0:
		var scale_down := 1.0 / total_non_common_chances
		rare_chance *= scale_down
		epic_chance *= scale_down
		legendary_chance *= scale_down
		total_non_common_chances = 1.0
	
	common_chance = 1.0 - total_non_common_chances
	
	print("Wave: %d, Luck: %.1f => Chances: C: %.2f R: %.2f E: %.2f L: %.2f" %
	[current_wave, Global.player.stats.luck, common_chance, rare_chance, epic_chance, legendary_chance])
	
	return [
		max(0.0, common_chance),
		max(0.0, rare_chance),
		max(0.0, epic_chance),
		max(0.0, legendary_chance),
	]
	
func select_items_for_offer(item_pool: Array, current_wave: int, config: Dictionary) -> Array:
	var tier_chances := calculate_tier_probability(current_wave, config)
	
	var legendary_limit = tier_chances[3]
	var epic_limit = legendary_limit + tier_chances[2]
	var rare_limit = epic_limit + tier_chances[1]
	
	var offered_items: Array = []
	while offered_items.size() < 4:
		var roll := randf()
		var chosen_tier_index := 0
		if roll < legendary_limit:
			chosen_tier_index = 3
		elif roll < epic_limit:
			chosen_tier_index = 2
		elif roll < rare_limit:
			chosen_tier_index = 1
			
		var postential_items: Array = []
		var current_search_iter_index := chosen_tier_index
		
		while postential_items.is_empty() and current_search_iter_index >= 0:
			postential_items = item_pool.filter(func(item: ItemBase): return item.item_tier == current_search_iter_index)
			if postential_items.is_empty():
				current_search_iter_index -= 1
			else:
				break
		if not postential_items.is_empty():
			var selected_item = postential_items.pick_random()
			if not offered_items.has(selected_item):
				offered_items.append(selected_item)
	return offered_items
