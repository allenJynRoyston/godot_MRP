extends Node

var svg_cache:Array = []

# ------------------------------------------------------------------------------
func fetch_svg(key:SVGS.TYPE) -> CompressedTexture2D:
	var texture:CompressedTexture2D
	
	var cache_res:Array = svg_cache.filter(func(i):return i.key == key)
	if cache_res.size() > 0:
		return cache_res[0].texture
	
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
	
	svg_cache.push_back({
		"key": key, 
		"texture": texture
	})
			
	return texture
# ------------------------------------------------------------------------------
