extends RefCounted

class_name GalleryDemoData

# Données locales de démonstration non canoniques.
# Aucun élément ne provient du runtime narratif.

static func fixtures() -> Dictionary:
	return {
		"marie": {
			"character_id": "marie",
			"display_name": "Marie",
			"accent_color": Color8(79, 139, 255),
			"avatar_ref": "M",
			"items": [
				_item("marie_01", "marie", "Photo démo 01", 1),
				_item("marie_02", "marie", "Photo démo 02", 2),
				_item("marie_03", "marie", "Photo démo 03", 3),
				_item("marie_04", "marie", "Photo démo 04", 4),
				_item("marie_05", "marie", "Photo démo 05", 5),
				_item("marie_06", "marie", "Photo démo 06", 6),
				_item("marie_07", "marie", "Photo démo 07", 7),
			],
		},
		"sandra": {
			"character_id": "sandra",
			"display_name": "Sandra",
			"accent_color": Color8(32, 199, 201),
			"avatar_ref": "S",
			"items": [
				_item("sandra_01", "sandra", "Photo démo 01", 1),
				_item("sandra_02", "sandra", "Photo démo 02", 2),
				_item("sandra_03", "sandra", "Photo démo 03", 3),
				_item("sandra_04", "sandra", "Photo démo 04", 4),
			],
		},
		"mathilde": {
			"character_id": "mathilde",
			"display_name": "Mathilde",
			"accent_color": Color8(245, 163, 59),
			"avatar_ref": "M",
			"items": [
				_item("mathilde_01", "mathilde", "Photo démo 01", 1),
				_item("mathilde_02", "mathilde", "Photo démo 02", 2),
				_item("mathilde_03", "mathilde", "Photo démo 03", 3),
			],
		},
		"pauline": {
			"character_id": "pauline",
			"display_name": "Pauline",
			"accent_color": Color8(240, 91, 157),
			"avatar_ref": "P",
			"items": [],
		},
		"raphaelle": {
			"character_id": "raphaelle",
			"display_name": "Raphaëlle",
			"accent_color": Color8(95, 209, 124),
			"avatar_ref": "R",
			"items": [
				_item("raphaelle_01", "raphaelle", "Photo démo 01", 1),
				_item("raphaelle_02", "raphaelle", "Photo démo 02", 2),
			],
		},
	}

static func character_order() -> Array[String]:
	return ["marie", "sandra", "mathilde", "pauline", "raphaelle"]

static func _item(item_id: String, character_id: String, thumbnail_label: String, sort_key: int) -> Dictionary:
	return {
		"item_id": item_id,
		"character_id": character_id,
		"thumbnail_label": thumbnail_label,
		"sort_key": sort_key,
	}
