extends Button

var mychar
var myparent

func _on_add_remove_party_member_button_down() -> void:
	var member : PartyMember = TWILIGHT.Party.all_members[mychar]
	
	# If in party already
	if TWILIGHT.Party.current_party.has(member):
		TWILIGHT.Party.current_party.erase(member)
		$IsInParty.text = "Not In Party"
		modulate.a = 0.7
		return
	
	# Else
	TWILIGHT.Party.current_party.append(member)
	$IsInParty.text = "In Party (%d)" % [ float(member.round_priority) / 2.0 ]
	modulate.a = 1

func _on_level_edit_text_changed(new_text: String) -> void:
	if int($Level/LevelEdit.text) > 50 || int($Level/LevelEdit.text) < 0:
		return
		
	TWILIGHT.Party.all_members[ mychar ].set_level(int(new_text), 0)
	update_lvstats()
	update_skills()

func update_lvstats() -> void:
	var member : PartyMember = TWILIGHT.Party.all_members[mychar]
	
	$Level/Hptxt.text = str( member.base_stats[StatType.HEART] )
	$Level/Juicetxt.text = str( member.base_stats[StatType.JUICE] )
	$Level/Atktxt.text = str( member.base_stats[StatType.ATTACK] )
	$Level/Deftxt.text = str( member.base_stats[StatType.DEFENSE] )
	$Level/Spdtxt.text = str( member.base_stats[StatType.SPEED] )

func _on_weapon_edit_text_changed(new_text: String) -> void:
	var equip = Registry.get_equipment(new_text)
	if equip != null:
		if equip.owner == mychar || equip.owner == "":
			update_weaponstats( new_text )
		else:
			$Weapon/WeaponDesc.text = "Weapon does not belong to character."
	else:
		$Weapon/HptxtW.text = "0"
		$Weapon/JuicetxtW.text = "0"
		$Weapon/AtktxtW.text = "0"
		$Weapon/DeftxtW.text = "0"
		$Weapon/SpdtxtW.text = "0"
		$Weapon/LcktxtW.text = "0"
		$Weapon/HittxtW.text = "0"
		$Weapon/WeaponDesc.text = "No Description."
		TWILIGHT.Party.all_members[ mychar ].weapon = ""

func update_weaponstats(_name : String) -> void:
	var _weapon = Registry.get_equipment(_name)
	
	if _weapon.equip_type == Equippable.EquipType.WEAPON:
		$Weapon/HptxtW.text = str( _weapon.get_stat(StatType.HEART) )
		$Weapon/JuicetxtW.text = str( _weapon.get_stat(StatType.JUICE) )
		$Weapon/AtktxtW.text = str( _weapon.get_stat(StatType.ATTACK) )
		$Weapon/DeftxtW.text = str( _weapon.get_stat(StatType.DEFENSE) )
		$Weapon/SpdtxtW.text = str( _weapon.get_stat(StatType.SPEED) )
		$Weapon/LcktxtW.text = str( _weapon.get_stat(StatType.LUCK) )
		$Weapon/HittxtW.text = str( _weapon.get_stat(StatType.HIT) )
		$Weapon/WeaponDesc.text = _weapon.description
		
		TWILIGHT.Party.all_members[ mychar ].weapon = _name
	else:
		$Weapon/WeaponDesc.text = "Resource isn't a Weapon."

func _on_charm_edit_text_changed(new_text: String) -> void:
	var equip = Registry.get_equipment(new_text)
	if equip != null:
		if equip.owner == mychar || equip.owner == "":
			update_charmstats( new_text )
		else:
			$Charm/CharmDesc.text = "Charm does not belong to character."
	else:
		$Charm/HptxtC.text = "0"
		$Charm/JuicetxtC.text = "0"
		$Charm/AtktxtC.text = "0"
		$Charm/DeftxtC.text = "0"
		$Charm/SpdtxtC.text = "0"
		$Charm/LcktxtC.text = "0"
		$Charm/HittxtC.text = "0"
		$Charm/CharmDesc.text = "No Description."
		TWILIGHT.Party.all_members[ mychar ].charm = ""

func update_charmstats(_name : String) -> void:
	var _weapon = Registry.get_equipment(_name)
	
	if _weapon.equip_type == Equippable.EquipType.CHARM:
		$Charm/HptxtC.text = str( _weapon.get_stat(StatType.HEART) )
		$Charm/JuicetxtC.text = str( _weapon.get_stat(StatType.JUICE) )
		$Charm/AtktxtC.text = str( _weapon.get_stat(StatType.ATTACK) )
		$Charm/DeftxtC.text = str( _weapon.get_stat(StatType.DEFENSE) )
		$Charm/SpdtxtC.text = str( _weapon.get_stat(StatType.SPEED) )
		$Charm/LcktxtC.text = str( _weapon.get_stat(StatType.LUCK) )
		$Charm/HittxtC.text = str( _weapon.get_stat(StatType.HIT) )
		$Charm/CharmDesc.text = _weapon.description
		
		#TWILIGHT.equippable(TWILIGHT.Inventory.Charms[0])
		TWILIGHT.Party.all_members[ mychar ].charm = _name
	else:
		$Charm/CharmDesc.text = "Resource isn't a Charm."

func update_skills() -> void:
	for i in range($Skills.get_child_count()):
		if i != 0:
			$Skills.get_child(i).queue_free()
	
	var skillsArray : Array = TWILIGHT.Party.all_members[ mychar ].unlocked_skills
	for i in range(skillsArray.size()):
		var sLabel : Label = $Skills/Skill0.duplicate()
		sLabel.text = skillsArray[i]
		
		sLabel.position.x += i%2 * 72
		sLabel.position.y += floor(i/2.0)*15
		
		$Skills.add_child(sLabel)
