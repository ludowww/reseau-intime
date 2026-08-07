extends RefCounted

class_name R8CUnifiedSeasonSessionSaveStore

var _owner
var _path := ""


static func create(owner, path: String) -> Dictionary:
	if owner == null or not owner.has_method("store_active_runtime_snapshot") or path.is_empty():
		return {"ok": false, "error_code": "INVALID_SEASON_SAVE_OWNER", "store": null}
	var store := new()
	store._owner = owner
	store._path = path
	return {"ok": true, "error_code": null, "store": store}


func path() -> String:
	return _path


func save_snapshot(snapshot: Dictionary) -> Dictionary:
	if _owner == null:
		return {"ok": false, "error_code": "SEASON_SAVE_OWNER_RELEASED"}
	return _owner.store_active_runtime_snapshot(snapshot)


func release() -> void:
	_owner = null
