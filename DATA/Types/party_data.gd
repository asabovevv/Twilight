class_name PartyData

var fast_emotion : Array[String] = ["neutral"] # List of emotions in overworld tag system
var all_members : Dictionary[String, PartyMember] # Every party member, even ones not currently in the party
var current_party : Array[PartyMember] # The active party
