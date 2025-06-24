@tool
extends Node

var svg_cache:Array = []
var image_cache:Array = []

# ------------------------------------------------------------------------------
func fetch_image(src:String = "") -> CompressedTexture2D:
	var new_texture:CompressedTexture2D
	
	if src != "":
		var cache_res:Array = image_cache.filter(func(i):return i.src == src)
		if cache_res.size() > 0:
			return cache_res[0].texture
		
		new_texture = load(src)

	# if image fails or does not exists, return redacted image
	if new_texture == null:
		new_texture = load("res://Media/images/redacted.png")
	
	image_cache.push_back({
		"src": src, 
		"texture": new_texture
	})
			
	return new_texture
# ------------------------------------------------------------------------------
		
# ------------------------------------------------------------------------------
func fetch_svg(key:SVGS.TYPE) -> CompressedTexture2D:
	var cache_res:Array = svg_cache.filter(func(i):return i.key == key)
	if cache_res.size() > 0:
		return cache_res[0].texture
	
	var texture:CompressedTexture2D
	match key:
		SVGS.TYPE.BIN:
			texture = load("res://SVGs/bin-xmark-fill-svgrepo-com.svg")			
		SVGS.TYPE.CLEAR:
			texture = load("res://SVGs/clear-svgrepo-com.svg")
		SVGS.TYPE.DELETE:
			texture = load("res://SVGs/clear-svgrepo-com.svg")
		SVGS.TYPE.DOT:
			texture = load("res://SVGs/dot-filled-svgrepo-com.svg")
		SVGS.TYPE.DOWNLOAD:
			texture = load("res://SVGs/download-window-svgrepo-com.svg")
		SVGS.TYPE.EMAIL:
			texture = load("res://SVGs/email-svgrepo-com.svg")
		SVGS.TYPE.EXE_FILE:
			texture = load("res://SVGs/exe-svgrepo-com.svg")
		SVGS.TYPE.TXT_FILE:
			texture = load("res://SVGs/txt-text-file-svgrepo-com.svg")
		SVGS.TYPE.MEDIA_FORWARD:
			texture = load("res://SVGs/media-forward-svgrepo-com.svg")
		SVGS.TYPE.MEDIA_PAUSE:
			texture = load("res://SVGs/media-pause-svgrepo-com.svg")
		SVGS.TYPE.MEDIA_PLAY:
			texture = load("res://SVGs/media-play-svgrepo-com.svg")
		SVGS.TYPE.MINUS:
			texture = load("res://SVGs/minus-svgrepo-com.svg")
		SVGS.TYPE.MUSIC:
			texture = load("res://SVGs/music-svgrepo-com.svg")
		SVGS.TYPE.NEW:
			texture = load("res://SVGs/new-rectangle-solid-svgrepo-com.svg")
		SVGS.TYPE.PLUS:
			texture = load('res://SVGs/plus-svgrepo-com.svg')
		SVGS.TYPE.SETTINGS:
			texture = load("res://SVGs/settings-svgrepo-com.svg")
		SVGS.TYPE.STOP:
			texture = load("res://SVGs/stop-svgrepo-com.svg")
		SVGS.TYPE.THINKING:
			texture = load("res://SVGs/thinking-round-svgrepo-com.svg")
		SVGS.TYPE.LOADING:
			texture = load("res://SVGs/loading-svgrepo-com.svg")
		SVGS.TYPE.SAVE:
			texture = load("res://SVGs/save-floppy-svgrepo-com.svg")
		SVGS.TYPE.CAUTION:
			texture = load("res://SVGs/caution-mark-svgrepo-com.svg")
		SVGS.TYPE.WARNING:
			texture = load("res://SVGs/warning-svgrepo-com.svg")
		SVGS.TYPE.HOURGLASS:
			texture = load("res://SVGs/hourglass-half-bottom-svgrepo-com.svg")
		SVGS.TYPE.INFO:
			texture = load("res://SVGs/info-circle-svgrepo-com.svg")
		SVGS.TYPE.RESEARCH:
			texture = load("res://SVGs/research-2-svgrepo-com.svg")
						
		SVGS.TYPE.BUILD:
			texture = load("res://SVGs/build-svgrepo-com.svg")
		SVGS.TYPE.ASSIGN:
			texture = load("res://SVGs/assignment-svgrepo-com.svg")
		SVGS.TYPE.INVESTIGATE:
			texture = load("res://SVGs/science-magnifying-glass-svgrepo-com.svg")
		SVGS.TYPE.RECRUIT:
			texture = load("res://SVGs/human-resources-svgrepo-com.svg")
		SVGS.TYPE.CONTAIN:
			texture = load("res://SVGs/box-minimalistic-svgrepo-com.svg")			
		SVGS.TYPE.NEXT:
			texture = load("res://SVGs/next-svgrepo-com.svg")
		SVGS.TYPE.BACK:
			texture = load("res://SVGs/back-svgrepo-com.svg")
		SVGS.TYPE.ARROW_DOWN:
			texture = load("res://SVGs/back-up-down-svgrepo-com.svg")
		SVGS.TYPE.ARROW_UP:
			texture = load("res://SVGs/back-up-svgrepo-com.svg")
					
		SVGS.TYPE.MONEY:
			texture = load("res://SVGs/money-svgrepo-com.svg")
		SVGS.TYPE.ENERGY:
			texture = load("res://SVGs/energy-svgrepo-com.svg")
		SVGS.TYPE.D_CLASS:
			texture = load("res://SVGs/handcuffs-svgrepo-com.svg")
		SVGS.TYPE.STAFF:
			texture = load("res://SVGs/person-circle-fill-svgrepo-com.svg")
		SVGS.TYPE.DRS:
			texture = load("res://SVGs/person-square-fill-svgrepo-com.svg")
		SVGS.TYPE.SECURITY:
			texture = load("res://SVGs/security-user-svgrepo-com.svg")
			
		SVGS.TYPE.TARGET:
			texture = load("res://SVGs/target_svgrepo-com.svg")			
		SVGS.TYPE.NO_ISSUES:
			texture = load("res://SVGs/clear-day-svgrepo-com.svg")
		SVGS.TYPE.DANGER:
			texture = load("res://SVGs/death-sign-svgrepo-com.svg")
		SVGS.TYPE.GLOBAL:
			texture = load("res://SVGs/global-button-svgrepo-com.svg")
		SVGS.TYPE.RING:
			texture = load("res://SVGs/ring-one-svgrepo-com.svg")			
		
		SVGS.TYPE.CAMERA_A:
			texture = load("res://SVGs/camera-svgrepo-com.svg")
		SVGS.TYPE.CAMERA_B:
			texture = load("res://SVGs/film-camera-svgrepo-com.svg")
		SVGS.TYPE.DOWN_ARROW:
			texture = load("res://SVGs/down-arrow-svgrepo-com.svg")
		SVGS.TYPE.LOCK:
			texture = load("res://SVGs/lock-closed-svgrepo-com.svg")
		SVGS.TYPE.UNLOCK:
			texture = load("res://SVGs/lock-open-svgrepo-com.svg")			
		SVGS.TYPE.CHECKBOX:
			texture = load("res://SVGs/checkbox-cross-svgrepo-com.svg")
		SVGS.TYPE.EMPTY_CHECKBOX:
			texture = load("res://SVGs/checkbox-blank-svgrepo-com.svg")
		SVGS.TYPE.CONVERSATION:
			texture = load("res://SVGs/conversation-fill-svgrepo-com.svg")
		SVGS.TYPE.QUESTION_MARK:
			texture = load("res://SVGs/question-square-fill-svgrepo-com.svg")
		SVGS.TYPE.NO_ELECTRICITY:
			texture = load("res://SVGs/electricity-caution-svgrepo-com.svg")			
		SVGS.TYPE.UP_ARROW:
			texture = load("res://SVGs/up-arrow-svgrepo-com.svg")						
		SVGS.TYPE.SWAP:
			texture = load("res://SVGs/swap-fill-svgrepo-com.svg")
		SVGS.TYPE.LAYER:
			texture = load("res://SVGs/top-face-rhombus-black.svg")
		SVGS.TYPE.LAYERS:
			texture = load("res://SVGs/layers-svgrepo-com.svg")			
		SVGS.TYPE.ZERO:
			texture = load("res://SVGs/number-small-0-svgrepo-com.svg")
		SVGS.TYPE.ONE:
			texture = load("res://SVGs/number-small-1-svgrepo-com.svg")
		SVGS.TYPE.TWO:
			texture = load("res://SVGs/number-small-2-svgrepo-com.svg")
		SVGS.TYPE.THREE:
			texture = load("res://SVGs/number-small-3-svgrepo-com.svg")
		SVGS.TYPE.FOUR:
			texture = load("res://SVGs/number-small-4-svgrepo-com.svg")
		SVGS.TYPE.FIVE:
			texture = load("res://SVGs/number-small-5-svgrepo-com.svg")
		SVGS.TYPE.SIX:
			texture = load("res://SVGs/number-small-6-svgrepo-com.svg")
		SVGS.TYPE.SEVEN:
			texture = load("res://SVGs/number-small-7-svgrepo-com.svg")
		SVGS.TYPE.EIGHT:
			texture = load("res://SVGs/number-small-8-svgrepo-com.svg")
		SVGS.TYPE.NINE:
			texture = load("res://SVGs/number-small-9-svgrepo-com.svg")			
		SVGS.TYPE.DESKTOP:
			texture = load("res://SVGs/desktop-sharp-svgrepo-com.svg")			
		
		SVGS.TYPE.FROZEN:
			texture = load("res://SVGs/ice-svgrepo-com.svg")
	svg_cache.push_back({
		"key": key, 
		"texture": texture
	})
			
	return texture
# ------------------------------------------------------------------------------
