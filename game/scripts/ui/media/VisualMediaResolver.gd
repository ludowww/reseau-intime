extends RefCounted

class_name VisualMediaResolver

const STATUS_LOADED := "LOADED"
const STATUS_MISSING_REFERENCE := "MISSING_REFERENCE"
const STATUS_INVALID_REFERENCE := "INVALID_REFERENCE"
const STATUS_DEVELOPMENT_PLACEHOLDER := "DEVELOPMENT_PLACEHOLDER"
const STATUS_NOT_DELIVERED := "NOT_DELIVERED"
const STATUS_LOAD_FAILED := "LOAD_FAILED"
const NOT_DELIVERED_LABEL := "Visuel non livré"
const PLACEHOLDER_ROOT := "res://assets/placeholders/"

static func resolve(reference: String) -> Dictionary:
	var normalized_reference := reference.strip_edges()
	if normalized_reference == "":
		return _result(STATUS_MISSING_REFERENCE, normalized_reference)
	if normalized_reference.begins_with("res://"):
		return _result(STATUS_INVALID_REFERENCE, normalized_reference)
	var item: Dictionary = DataLoader.get_visual_content(normalized_reference)
	if item.is_empty():
		return _result(STATUS_INVALID_REFERENCE, normalized_reference)
	var asset_path := str(item.get("asset_path", "")).strip_edges()
	var asset_status := str(item.get("asset_status", "")).strip_edges().to_upper()
	if asset_status in ["PROTOTYPE", "PLACEHOLDER", "DEVELOPMENT_PLACEHOLDER"] or asset_path.begins_with(PLACEHOLDER_ROOT):
		return _result(STATUS_DEVELOPMENT_PLACEHOLDER, normalized_reference, asset_path)
	if asset_path == "" or asset_status in ["NOT_DELIVERED", "PENDING", "MISSING"]:
		return _result(STATUS_NOT_DELIVERED, normalized_reference, asset_path)
	if not asset_path.begins_with("res://"):
		return _result(STATUS_INVALID_REFERENCE, normalized_reference, asset_path)
	if not ResourceLoader.exists(asset_path):
		return _result(STATUS_LOAD_FAILED, normalized_reference, asset_path)
	var resource := ResourceLoader.load(asset_path, "", ResourceLoader.CACHE_MODE_REUSE)
	if not resource is Texture2D:
		return _result(STATUS_LOAD_FAILED, normalized_reference, asset_path)
	return _result(STATUS_LOADED, normalized_reference, asset_path, resource)

static func _result(status: String, reference: String, asset_path := "", texture: Texture2D = null) -> Dictionary:
	return {
		"status": status,
		"reference": reference,
		"asset_path": asset_path,
		"texture": texture,
	}
