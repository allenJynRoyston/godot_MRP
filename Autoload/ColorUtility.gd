@tool
extends Node

var neon_green:Color = Color("00f647")
var dim_green:Color = Color("004115")
var light_green:Color = Color("008747")
var invalid_red:Color = Color("ff3400")
var invalid_red_dim:Color = Color("861600")

# ------------------------------------------------
func get_window_color(ref:COLORS.WINDOW) -> Color:
	match ref:
		COLORS.WINDOW.ACTIVE:
			return neon_green
		COLORS.WINDOW.INACTIVE:
			return dim_green
		COLORS.WINDOW.SHADING:
			return light_green
		_:
			return neon_green
# ------------------------------------------------

# ------------------------------------------------
func get_text_color(ref:COLORS.TEXT) -> Color:
	match ref:
		COLORS.TEXT.ACTIVE:
			return Color.WHITE
		COLORS.TEXT.INACTIVE:
			return Color.DARK_GRAY
		COLORS.TEXT.DARK:
			return Color.BLACK
		COLORS.TEXT.LIGHT:
			return Color.WHITE
		COLORS.TEXT.INVALID_ACTIVE:
			return invalid_red
		COLORS.TEXT.INVALID_INACTIVE:
			return invalid_red_dim
		_:
			return neon_green
# ------------------------------------------------
