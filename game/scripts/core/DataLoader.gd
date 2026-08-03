extends Node

# The active portrait runtime loads every narrative JSON through explicit paths.
# DataLoader keeps only that generic reader and the shared visual catalogue.
const VISUAL_CONTENT_PATHS := [
	"res://data/visual_content/placeholders.json",
	"res://data/visual_content/chapter_01_proofs.json",
	"res://data/visual_content/chapter_02_proofs.json",
	"res://data/visual_content/chapter_03_proofs.json",
	"res://data/visual_content/chapter_04_opening_proofs.json",
	"res://data/visual_content/chapter_08_named_boundaries_visuals.json",
	"res://data/visual_content/chapter_09_named_boundaries_visuals.json",
]

var visual_content_by_id: Dictionary = {}
var load_errors: Array[String] = []


func _ready() -> void:
	load_all()


func load_all() -> void:
	load_errors.clear()
	visual_content_by_id.clear()
	for path in VISUAL_CONTENT_PATHS:
		_load_visual_content(path)


func load_json(path: String) -> Dictionary:
	var normalized_path := path.simplify_path()
	if path == "" or not normalized_path.begins_with("res://data/"):
		load_errors.append("JSON path outside res://data: %s" % path)
		return {}
	if not FileAccess.file_exists(normalized_path):
		load_errors.append("Missing JSON: %s" % normalized_path)
		return {}
	var parsed = JSON.parse_string(FileAccess.get_file_as_string(normalized_path))
	if typeof(parsed) != TYPE_DICTIONARY:
		load_errors.append("Invalid JSON object: %s" % normalized_path)
		return {}
	return parsed


func _load_visual_content(path: String) -> void:
	var bundle := load_json(path)
	for key in ["items", "proofs"]:
		for item in bundle.get(key, []):
			if typeof(item) != TYPE_DICTIONARY:
				continue
			var content_id := str(item.get("id", ""))
			if content_id != "":
				visual_content_by_id[content_id] = item


func get_visual_content(content_id: String) -> Dictionary:
	return visual_content_by_id.get(content_id, {})
