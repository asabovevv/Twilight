class_name Portrait

var name : String
var image : SpriteFrames
var img_battle_crop : Rect2i # previously Battle_Crop_Rect (Needs Rework for SpriteFrames)
var img_dialogue_crop : Rect2i # previously Portrait_Crop_Rect (Needs Rework for SpriteFrames)

func _init(
	_name : String,
	_img_battle_crop : Rect2i,
	_img_dialogue_crop : Rect2i
):
	self.name = _name
	self.img_battle_crop = _img_battle_crop
	self.img_dialogue_crop = _img_dialogue_crop

func _load_battle_portrait(_battle_portrait_folder_path : String) -> void:
	# Get all files from Character's Battle Portrait Folder
	var battle_portraits : PackedStringArray = DirAccess.get_files_at(_battle_portrait_folder_path)
	
	# Once for each emotion, add a battle portrait
	for i in range(Registry.emotions.size()):
		
		var index = min(Registry.emotions.size()-1, i)
		
		# Get file "i" from Character's Battle Portrait Folder
		var spritesheet : Texture2D = load( battle_portraits[index] )
		@warning_ignore("integer_division")
		var frame_width : int = spritesheet.get_width() / 3
		var spritesheet_img : Image = spritesheet.get_image()
		
		# Split Image into 3 frames
		var frames : Array[Texture2D]
		for j in range(3):
			frames.append( ImageTexture.create_from_image( spritesheet_img.get_region( Rect2i(j*frame_width, 0, frame_width, spritesheet.get_height() )) ) )
		
		# Create animation from frames
		new_animation(Registry.emotions.name, frames)

func new_animation(_name : String, _frames : Array[Texture2D] ) -> void:
	image.add_animation(_name)
	for i in range(_frames.size()):
		image.add_frame(_name, _frames[i], 0.33)
