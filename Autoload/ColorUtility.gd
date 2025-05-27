@tool
extends Node

const neon_green:Color = Color("00f647")
const dim_green:Color = Color("004115")
const light_green:Color = Color("008747")
const invalid_red:Color = Color("ff3400")
const invalid_red_dim:Color = Color("861600")

const scp_color:Color = Color(0.736, 0.247, 0.9)
const room_color:Color = Color(0.337, 0.275, 1.0)
const researcher_color:Color = Color(1.0, 0.108, 0.485)

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
