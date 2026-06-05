extends Node

## The global registry for storing game data.

var items : GameDataRegistry = GameDataRegistry.new()
var emotions : GameDataRegistry = GameDataRegistry.new()
var equipment : GameDataRegistry = GameDataRegistry.new()
var enemies : GameDataRegistry = GameDataRegistry.new()
var skills : GameDataRegistry = GameDataRegistry.new()
var status_effects : GameDataRegistry = GameDataRegistry.new()
var party_members : GameDataRegistry = GameDataRegistry.new()

func _init() -> void:
	AllRegister.register_items(items)
	AllRegister.register_equipment(equipment)
	AllRegister.register_skills(skills)
	#AllRegister.register_enemies()
	#AllRegister.register_status_effects()
	AllRegister.register_emotions(emotions)
	AllRegister.register_party_members(party_members)

## Shorthand for [code]Registry.items.try_get(id) as Item[/code]. Will return [code]null[/code] if the entry does not exist.
func get_item(id : String) -> Item:
	return items.try_get(id) as Item

## Shorthand for [code]Registry.emotions.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_emotion(id : String) -> Emotion:
	return emotions.try_get(id) as Emotion

## Shorthand for [code]Registry.equipment.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_equipment(id : String) -> Equippable:
	return equipment.try_get(id) as Equippable

## Shorthand for [code]Registry.enemies.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_enemy(id : String) -> Enemy:
	return enemies.try_get(id) as Enemy

## Shorthand for [code]Registry.skills.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_skill(id : String) -> Skill:
	return skills.try_get(id) as Skill

## Shorthand for [code]Registry.status_effects.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_status_effect(id : String) -> StatusEffect:
	return status_effects.try_get(id) as StatusEffect

## Shorthand for [code]Registry.party_members.try_get(id) as Item[/code].  Will return [code]null[/code] if the entry does not exist.
func get_party_member(id : String) -> PartyMemberData:
	return party_members.try_get(id) as PartyMemberData
