extends RefCounted

class_name PortraitShellTheme

const BACKGROUND := Color(0.027, 0.039, 0.094)
const BACKGROUND_DEEP := Color(0.016, 0.024, 0.067)
const SURFACE := Color(0.067, 0.094, 0.168)
const SURFACE_RAISED := Color(0.090, 0.125, 0.224)
const BORDER := Color(0.165, 0.192, 0.314)
const TEXT_PRIMARY := Color(0.953, 0.941, 0.980)
const TEXT_SECONDARY := Color(0.667, 0.651, 0.737)
const TEXT_MUTED := Color(0.467, 0.459, 0.541)
const MARIE_ACCENT := Color8(79, 139, 255)
const SANDRA_ACCENT := Color8(32, 199, 201)
const MATHILDE_ACCENT := Color8(245, 163, 59)
const PAULINE_ACCENT := Color8(240, 91, 157)
const RAPHAELLE_ACCENT := Color8(95, 209, 124)
const NICO_ACCENT := Color8(142, 163, 209)
const GROUP_ACCENT := Color8(178, 116, 244)
const PLAYER_ACCENT := Color8(141, 99, 230)
const FOCUS := Color(0.710, 0.541, 1.000)
const MESSAGE_ACCENT := Color(0.310, 0.545, 1.000)
const GALLERY_ACCENT := Color(0.125, 0.780, 0.788)
const TAB_INACTIVE := Color(0.165, 0.192, 0.314)
const IDENTITY_ACCENTS := {
	"Marie": MARIE_ACCENT,
	"Sandra": SANDRA_ACCENT,
	"Mathilde": MATHILDE_ACCENT,
	"Pauline": PAULINE_ACCENT,
	"Raphaelle": RAPHAELLE_ACCENT,
	"Raphaëlle": RAPHAELLE_ACCENT,
	"Nico": NICO_ACCENT,
	"Group": GROUP_ACCENT,
	"Groupes": GROUP_ACCENT,
	"Player": PLAYER_ACCENT,
}

func accent_for(identity: String) -> Color:
	return IDENTITY_ACCENTS.get(identity, PLAYER_ACCENT)

func panel_style(fill: Color, border_width := 1, radius := 24) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = BORDER
	style.border_width_left = border_width
	style.border_width_top = border_width
	style.border_width_right = border_width
	style.border_width_bottom = border_width
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 16
	style.content_margin_top = 12
	style.content_margin_right = 16
	style.content_margin_bottom = 12
	return style

func button_style(fill: Color, border_color: Color, radius := 18) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = fill
	style.border_color = border_color
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.content_margin_left = 14
	style.content_margin_top = 10
	style.content_margin_right = 14
	style.content_margin_bottom = 10
	return style

func focus_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	style.border_color = FOCUS
	style.border_width_left = 3
	style.border_width_top = 3
	style.border_width_right = 3
	style.border_width_bottom = 3
	style.corner_radius_top_left = 18
	style.corner_radius_top_right = 18
	style.corner_radius_bottom_left = 18
	style.corner_radius_bottom_right = 18
	return style

func nav_style(active: bool) -> StyleBoxFlat:
	if active:
		return button_style(Color(0.15, 0.18, 0.30), PLAYER_ACCENT)
	return button_style(Color(0.09, 0.11, 0.18), TAB_INACTIVE)

func item_style(color: Color) -> StyleBoxFlat:
	return button_style(color, BORDER, 16)
