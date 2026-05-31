extends Button

var mychar
var myparent

func _on_add_remove_party_member_button_down() -> void:
	# If in party already
	for i in range(TWILIGHT.Party_Order.size()):
		if TWILIGHT.Party_Order[i] == mychar:
			TWILIGHT.Party_Order.remove_at(i)
			$IsInParty.text = "Not In Party"
			return
	
	# Else
	TWILIGHT.add_char_to_party(mychar)
	$IsInParty.text = "In Party (%d)" % [ float(mychar.TurnPriority) / 2.0 ]

func _on_level_edit_text_changed(new_text: String) -> void:
	if int($Level/LevelEdit.text) > 50 || int($Level/LevelEdit.text) < 0:
		return
		
	TWILIGHT.All_Characters[ TWILIGHT.get_char_id(mychar.Name) ].set_level(int(new_text), 0)
	update_lvstats()
	update_skills()

func update_lvstats() -> void:
	var id : int = TWILIGHT.get_char_id(mychar.Name)
	
	$Level/Hptxt.text = str( TWILIGHT.All_Characters[id].Heart_Max )
	$Level/Juicetxt.text = str( TWILIGHT.All_Characters[id].Juice_Max )
	$Level/Atktxt.text = str( TWILIGHT.All_Characters[id].Attack_Base )
	$Level/Deftxt.text = str( TWILIGHT.All_Characters[id].Defense_Base )
	$Level/Spdtxt.text = str( TWILIGHT.All_Characters[id].Speed_Base )

func _on_weapon_edit_text_changed(new_text: String) -> void:
	if FileAccess.file_exists("res://RESOURCES/Equippable/"+new_text+".tres"):
		update_weaponstats(load("res://RESOURCES/Equippable/"+new_text+".tres"))
	else:
		$Weapon/HptxtW.text = "0"
		$Weapon/JuicetxtW.text = "0"
		$Weapon/AtktxtW.text = "0"
		$Weapon/DeftxtW.text = "0"
		$Weapon/SpdtxtW.text = "0"
		$Weapon/LcktxtW.text = "0"
		$Weapon/HittxtW.text = "0"
		$Weapon/WeaponDesc.text = "No Description."

func update_weaponstats(weapon : Equipable) -> void:
	if weapon.is_weapon:
		$Weapon/HptxtW.text = str( weapon.heart )
		$Weapon/JuicetxtW.text = str( weapon.juice )
		$Weapon/AtktxtW.text = str( weapon.attack )
		$Weapon/DeftxtW.text = str( weapon.defense )
		$Weapon/SpdtxtW.text = str( weapon.speed )
		$Weapon/LcktxtW.text = str( weapon.luck )
		$Weapon/HittxtW.text = str( weapon.hit )
		$Weapon/WeaponDesc.text = weapon.description
		
		#TWILIGHT.equippable(TWILIGHT.Inventory.Weapons[0])
		TWILIGHT.All_Characters[ TWILIGHT.get_char_id(mychar.Name) ].Weapon = weapon
	else:
		$Weapon/HptxtW.text = "0"
		$Weapon/JuicetxtW.text = "0"
		$Weapon/AtktxtW.text = "0"
		$Weapon/DeftxtW.text = "0"
		$Weapon/SpdtxtW.text = "0"
		$Weapon/LcktxtW.text = "0"
		$Weapon/HittxtW.text = "0"
		$Weapon/WeaponDesc.text = "Resource isn't a Weapon."

func _on_charm_edit_text_changed(new_text: String) -> void:
	if FileAccess.file_exists("res://RESOURCES/Equippable/"+new_text+".tres"):
		update_charmstats(load("res://RESOURCES/Equippable/"+new_text+".tres"))
	else:
		$Charm/HptxtC.text = "0"
		$Charm/JuicetxtC.text = "0"
		$Charm/AtktxtC.text = "0"
		$Charm/DeftxtC.text = "0"
		$Charm/SpdtxtC.text = "0"
		$Charm/LcktxtC.text = "0"
		$Charm/HittxtC.text = "0"
		$Charm/CharmDesc.text = "No Description."

func update_charmstats(charm : Equipable) -> void:
	if !charm.is_weapon:
		$Charm/HptxtC.text = str( charm.heart )
		$Charm/JuicetxtC.text = str( charm.juice )
		$Charm/AtktxtC.text = str( charm.attack )
		$Charm/DeftxtC.text = str( charm.defense )
		$Charm/SpdtxtC.text = str( charm.speed )
		$Charm/LcktxtC.text = str( charm.luck )
		$Charm/HittxtC.text = str( charm.hit )
		$Charm/CharmDesc.text = charm.description
		
		#TWILIGHT.equippable(TWILIGHT.Inventory.Charms[0])
		TWILIGHT.All_Characters[ TWILIGHT.get_char_id(mychar.Name) ].Charm = charm
	else:
		$Charm/HptxtC.text = "0"
		$Charm/JuicetxtC.text = "0"
		$Charm/AtktxtC.text = "0"
		$Charm/DeftxtC.text = "0"
		$Charm/SpdtxtC.text = "0"
		$Charm/LcktxtC.text = "0"
		$Charm/HittxtC.text = "0"
		$Charm/CharmDesc.text = "Resource isn't a Charm."

func update_skills() -> void:
	for i in range($Skills.get_child_count()):
		if i != 0:
			$Skills.get_child(i).queue_free()
	
	var skillsArray : Array = TWILIGHT.All_Characters[ TWILIGHT.get_char_id(mychar.Name) ].Skills
	for i in range(skillsArray.size()):
		var sLabel : Label = $Skills/Skill0.duplicate()
		sLabel.text = skillsArray[i]
		
		sLabel.position.x += i%2 * 72
		sLabel.position.y += floor(i/2.0)*15
		
		$Skills.add_child(sLabel)
