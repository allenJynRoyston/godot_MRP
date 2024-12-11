@tool
extends Node

var svg_cache:Array = []

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
			
		SVGS.TYPE.BUILD:
			texture = load("res://SVGs/build-fix-repair-2-svgrepo-com.svg")
		SVGS.TYPE.SCIENCE:
			texture = load("res://SVGs/science-magnifying-glass-svgrepo-com.svg")
		SVGS.TYPE.ASSIGN:
			texture = load("res://SVGs/assign-svgrepo-com.svg")
		SVGS.TYPE.INVESTIGATE:
			texture = load("res://SVGs/binauculars-look-binoculars-look-ahead-svgrepo-com.svg")
		SVGS.TYPE.NEXT:
			texture = load("res://SVGs/next-svgrepo-com.svg")
		SVGS.TYPE.PEOPLE:
			texture = load("res://SVGs/people-nearby-svgrepo-com.svg")
		
		SVGS.TYPE.MONEY:
			texture = load("res://SVGs/dollar1-svgrepo-com.svg")
		SVGS.TYPE.ENERGY:
			texture = load("res://SVGs/battery-half-svgrepo-com.svg")
		SVGS.TYPE.D_CLASS:
			texture = load("res://SVGs/convict-justice-svgrepo-com.svg")
		SVGS.TYPE.STAFF:
			texture = load("res://SVGs/scientist-svgrepo-com.svg")
		SVGS.TYPE.DRS:
			texture = load("res://SVGs/round-bottom-flask-7-svgrepo-com.svg")
		SVGS.TYPE.SECURITY:
			texture = load("res://SVGs/soldier-svgrepo-com.svg")
			
		
		# ENERGY, D_CLASS, DRS, STAFF, SECURITY,
				
	
	svg_cache.push_back({
		"key": key, 
		"texture": texture
	})
			
	return texture
# ------------------------------------------------------------------------------
