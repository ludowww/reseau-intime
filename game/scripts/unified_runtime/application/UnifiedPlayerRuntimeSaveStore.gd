extends RefCounted

class_name R8CUnifiedPlayerRuntimeSaveStore

const JsonNormalizer := preload(
	"res://scripts/unified_runtime/application/JsonValueNormalizer.gd"
)
const DEFAULT_PATH := "user://reseau_intime/unified_player_runtime_v2.json"
const MAX_SAVE_BYTES := 2 * 1024 * 1024
const MAX_JSON_DEPTH := 32
const MAX_JSON_NODES := 20000

var _path := DEFAULT_PATH


static func create(path_override := "") -> Dictionary:
	var path := DEFAULT_PATH if str(path_override).is_empty() else str(path_override)
	if not _is_confined_user_path(path):
		return {"ok": false, "error_code": "SAVE_PATH_OUTSIDE_USER_STORAGE", "store": null}
	var store := new()
	store._path = path
	return {"ok": true, "error_code": null, "store": store}


func path() -> String:
	return _path


func exists() -> bool:
	return (
		FileAccess.file_exists(_path)
		or FileAccess.file_exists(_temporary_path())
		or FileAccess.file_exists(_backup_path())
	)


func load_snapshot() -> Dictionary:
	if not exists():
		return {"ok": false, "error_code": "SAVE_NOT_FOUND", "snapshot": {}}
	var last_error := "SAVE_JSON_INVALID"
	for candidate_path in [_path, _temporary_path(), _backup_path()]:
		if not FileAccess.file_exists(candidate_path):
			continue
		var loaded := _read_snapshot_path(candidate_path)
		if not loaded["ok"]:
			last_error = str(loaded["error_code"])
			continue
		if candidate_path != _path:
			_promote_recovery(candidate_path)
		return loaded
	return {"ok": false, "error_code": last_error, "snapshot": {}}


func save_snapshot(snapshot: Dictionary) -> Dictionary:
	if snapshot.is_empty():
		return {"ok": false, "error_code": "EMPTY_SNAPSHOT"}
	var encoded := JSON.stringify(snapshot, "  ")
	if encoded.to_utf8_buffer().size() > MAX_SAVE_BYTES:
		return {"ok": false, "error_code": "SAVE_TOO_LARGE"}
	var absolute_path := ProjectSettings.globalize_path(_path)
	var directory_path := absolute_path.get_base_dir()
	if DirAccess.make_dir_recursive_absolute(directory_path) != OK:
		return {"ok": false, "error_code": "SAVE_DIRECTORY_REFUSED"}
	var temporary_path := _temporary_path()
	var backup_path := _backup_path()
	var temporary := FileAccess.open(temporary_path, FileAccess.WRITE)
	if temporary == null:
		return {"ok": false, "error_code": "SAVE_TEMP_OPEN_REFUSED"}
	temporary.store_string(encoded)
	temporary.flush()
	var write_error := temporary.get_error()
	temporary.close()
	if write_error != OK:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(temporary_path))
		return {"ok": false, "error_code": "SAVE_TEMP_WRITE_REFUSED"}
	var verified := _read_snapshot_path(temporary_path)
	if not verified["ok"] or verified["snapshot"] != JsonNormalizer.normalize(snapshot):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(temporary_path))
		return {"ok": false, "error_code": "SAVE_TEMP_VERIFY_REFUSED"}
	var absolute_temporary := ProjectSettings.globalize_path(temporary_path)
	var absolute_backup := ProjectSettings.globalize_path(backup_path)
	if FileAccess.file_exists(backup_path):
		DirAccess.remove_absolute(absolute_backup)
	if FileAccess.file_exists(_path):
		var backup_error := DirAccess.rename_absolute(absolute_path, absolute_backup)
		if backup_error != OK:
			DirAccess.remove_absolute(absolute_temporary)
			return {"ok": false, "error_code": "SAVE_BACKUP_REFUSED"}
	var replace_error := DirAccess.rename_absolute(absolute_temporary, absolute_path)
	if replace_error != OK:
		if FileAccess.file_exists(backup_path):
			DirAccess.rename_absolute(absolute_backup, absolute_path)
		return {"ok": false, "error_code": "SAVE_REPLACE_REFUSED"}
	var final_verification := _read_snapshot_path(_path)
	if not final_verification["ok"] or final_verification["snapshot"] != verified["snapshot"]:
		DirAccess.remove_absolute(absolute_path)
		if FileAccess.file_exists(backup_path):
			DirAccess.rename_absolute(absolute_backup, absolute_path)
		return {"ok": false, "error_code": "SAVE_FINAL_VERIFY_REFUSED"}
	if FileAccess.file_exists(backup_path):
		DirAccess.remove_absolute(absolute_backup)
	return {"ok": true, "error_code": null}


func _temporary_path() -> String:
	return _path + ".tmp"


func _backup_path() -> String:
	return _path + ".previous"


func _read_snapshot_path(candidate_path: String) -> Dictionary:
	var file := FileAccess.open(candidate_path, FileAccess.READ)
	if file == null:
		return {"ok": false, "error_code": "SAVE_OPEN_REFUSED", "snapshot": {}}
	if file.get_length() > MAX_SAVE_BYTES:
		file.close()
		return {"ok": false, "error_code": "SAVE_TOO_LARGE", "snapshot": {}}
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return {"ok": false, "error_code": "SAVE_JSON_INVALID", "snapshot": {}}
	var budget := {"nodes": 0}
	if not _json_within_limits(parsed, 0, budget):
		return {"ok": false, "error_code": "SAVE_JSON_TOO_COMPLEX", "snapshot": {}}
	return {"ok": true, "error_code": null, "snapshot": JsonNormalizer.normalize(parsed)}


func _promote_recovery(candidate_path: String) -> bool:
	var absolute_path := ProjectSettings.globalize_path(_path)
	var absolute_candidate := ProjectSettings.globalize_path(candidate_path)
	var corrupt_path := _path + ".corrupt"
	var absolute_corrupt := ProjectSettings.globalize_path(corrupt_path)
	if FileAccess.file_exists(corrupt_path):
		DirAccess.remove_absolute(absolute_corrupt)
	var primary_moved := false
	if FileAccess.file_exists(_path):
		if DirAccess.rename_absolute(absolute_path, absolute_corrupt) != OK:
			return false
		primary_moved = true
	if DirAccess.rename_absolute(absolute_candidate, absolute_path) != OK:
		if primary_moved:
			DirAccess.rename_absolute(absolute_corrupt, absolute_path)
		return false
	if primary_moved and FileAccess.file_exists(corrupt_path):
		DirAccess.remove_absolute(absolute_corrupt)
	return true


static func _is_confined_user_path(path: String) -> bool:
	if not path.begins_with("user://"):
		return false
	var relative := path.trim_prefix("user://")
	if relative.is_empty() or relative.contains("\\"):
		return false
	for segment in relative.split("/"):
		if segment.is_empty() or segment in [".", ".."]:
			return false
		for index in segment.length():
			if segment.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-":
				return false
	var user_root := ProjectSettings.globalize_path("user://").simplify_path().trim_suffix("/")
	var candidate := ProjectSettings.globalize_path(path).simplify_path()
	return candidate.to_lower().begins_with((user_root + "/").to_lower())


static func _json_within_limits(value, depth: int, budget: Dictionary) -> bool:
	if depth > MAX_JSON_DEPTH:
		return false
	budget["nodes"] = int(budget["nodes"]) + 1
	if budget["nodes"] > MAX_JSON_NODES:
		return false
	if typeof(value) == TYPE_ARRAY:
		for item in value:
			if not _json_within_limits(item, depth + 1, budget):
				return false
	elif typeof(value) == TYPE_DICTIONARY:
		for key in value:
			if not _json_within_limits(value[key], depth + 1, budget):
				return false
	return true
