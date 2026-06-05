## TEXT ESCAPE FUNCTIONS + SYNTAX

## EXAMPLE USE - |br:@|This line will require you to press z @here.
# Custom Escape Functions ALWAYS go before all text.
# Be careful to use different (arbitrary) "Marker Characters" for different functionalities.
# The line below would require two z presses, but the @'s would not register to change the text's speed.
# 	|br:@:2||speed:@:100|I am gonna pause @twice @but this text wont be any faster.
# It should instead be written like:
#	|br:$:2||speed:@:100|I am gonna pause $twice @$and this text will be faster.

## ~ denotes a variable has a default parameter
# Example:  "dbox": (int) ~Visible = 1
# This can be written as |dbox| or |dbox:1|
## "Amount" is generally the amount of Marker Characters searched for. Over-searching is accounted for.

## ------------- ------------- Custom Escape Functions ------------- -------------

## |dbox : (int) ~Visible = 1|
#	- Sets the dialogue box and all its contents' visibility. True by default.

## |name : (str) Text |
#	- Sets the name that displays in the dialogue box.
#	- An empty string makes the name-box disappear.

## |face : (str) ~Portrait Name, Portrait ID |
#	- Sets the dialogue portrait.
#	- Portrait Name is null by default. If Portrait Name points to null the portrait-box disappears.
#	- Portrait ID is to support multiple speaker's faces at once
#	- Character portraits are found at: res://UI/Portraits/

## |p : (MC) Marker Char : (int) ~Amount = 1 |
#	- Text pauses at all marker chars. Requires a Z press to continue text crawl.

## |wait : (MC) Marker Char : (float) ~Duration = 0.1 : (int) ~Amount = 1 |
#	- Text pauses at all marker chars; Waits a set duration (default 0.1 seconds) before text continues.

## |font : (MC) Marker Char : (str) Font Name |
#	- Sets text font at marker char. Font Names are "Default", "Disturbed".
#	- Fonts are found in: res://UI/Dialogue

## |speed : (MC) Marker Char : (float) ~Speed = "default" |
#	- Causes text to scroll at X characters a second after marker char.
#	- Speed is 60 by default. (Speed can be set to "d" or "default" as well.)

## |choice : (str) ~Option 1 Name : (int) Option 1 Jumps To Branch : ~... |
#	- Brings up a choice menu during dialogue. Making a choice jumps to another branch in dialogue tree.

## |end : (MC) Marker Char |
#	- Instantly ends text when crawl reaches marker char.

## |sound : (MC) Marker Char : (path) Sound Path : (str) ~Volume Type = "SE" |
#	- Plays a sound when marker char is reached, assigning the volume to one of four channels (like in Omori).
#	- Sounds are found at res://SOUNDS/
# 	- Volume Types: SE, ME, AS, AM (Sound Effect, Music Effect, Ambient Sound, Ambient Music)

## |func : (MC) Marker Char : (str) Dialogue Function Name : (int) ~Integer = 0 |
#	- Runs a "Dialogue Function" with one parameter. (Cannot run ANY function - this is to future proof.)
#	- Dialogue Functions can be found here: res://UI/Dialogue/Dialogue Functions/
#	- Dialogue Function Name Example: encounter.gd would be written as: "encounter"
#	- Only one integer is passed into these functions! All Dialogue Functions state what it does at the top.

## |size_gradual : (MC) Marker Char : ~Start Size = "default" : Target Size : Step Size |
#	- After marker char, changes text size gradually by (Step Size) every character. Starts at-
#	  (Start Size) and goes until (Target Size) is reached.
#	- Font size is 28 by default. (Start Size can be set to "d" or "default")

## |wave : (MC) Marker Char : (int) Amplitude : (float) ~Frequency = 5.0 |
#	- Makes text characters display slightly offset as a wave animation.
#	- Amplitude is how far characters offset. An Amplitude of 0 causes the wave to stop.
#			Note: Amplitude works best between 10 and 50
#	- Frequency is how fast the waves move. Doesn't ever really require messing with.

## ------------------- Rich Text Stuff (built into Godot, doesn't require custom syntax.) ------------------

# Text shaking
# [shake rate=30.0 level=10 connected=1]

# Set size
# [font_size=28]

# OMORI text colors:
# [color=#51C059]
	#51C059 - Green
	#FFD964 - Yellow
	#FF9232 - Orange
	#5E92FA - Blue
	#5E92FA - Teal
	#AE58CB - Purple
	#C263E2 - Light Purple
