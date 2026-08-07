extends RefCounted

class_name R8CPhysicalPresentationContentV1

const SCHEMA_ID := "reseau_intime.physical_presentation_catalog"
const SCHEMA_VERSION := 1
const ROOT_FIELDS := [
	"schema_id", "schema_version", "sequence_id", "authored_version", "entries",
]
const ENTRY_FIELDS := ["content_ref", "title", "body", "steps", "continue_label"]
const MIN_STEPS := 1
const MAX_STEPS := 6


static func validate(value) -> Dictionary:
	var errors: Array[String] = []
	if not _validate_dictionary(value, ROOT_FIELDS, "root", errors):
		return _result(errors)
	if value["schema_id"] != SCHEMA_ID:
		_add_error(errors, "root.schema_id", "unexpected_schema_id")
	if typeof(value["schema_version"]) != TYPE_INT or value["schema_version"] != SCHEMA_VERSION:
		_add_error(errors, "root.schema_version", "expected_integer_1")
	_validate_identifier(value["sequence_id"], "root.sequence_id", errors)
	if not _is_semver(value["authored_version"]):
		_add_error(errors, "root.authored_version", "expected_major_minor_patch")
	_validate_entries(value["entries"], errors)
	return _result(errors)


static func schema_contract() -> Dictionary:
	return {
		"schema_id": SCHEMA_ID,
		"schema_version": SCHEMA_VERSION,
		"root_fields": ROOT_FIELDS.duplicate(),
		"entry_fields": ENTRY_FIELDS.duplicate(),
		"minimum_steps": MIN_STEPS,
		"maximum_steps": MAX_STEPS,
	}


static func _validate_entries(value, errors: Array[String]) -> void:
	if typeof(value) != TYPE_ARRAY:
		_add_error(errors, "root.entries", "expected_array")
		return
	var content_refs := {}
	for index in value.size():
		var path := "root.entries[%d]" % index
		var entry = value[index]
		if not _validate_dictionary(entry, ENTRY_FIELDS, path, errors):
			continue
		_validate_non_empty_string(entry["content_ref"], path + ".content_ref", errors)
		_validate_non_empty_string(entry["title"], path + ".title", errors)
		_validate_non_empty_string(entry["body"], path + ".body", errors)
		_validate_non_empty_string(entry["continue_label"], path + ".continue_label", errors)
		var content_ref = entry["content_ref"]
		if typeof(content_ref) == TYPE_STRING and not content_ref.is_empty():
			if content_refs.has(content_ref):
				_add_error(errors, path + ".content_ref", "duplicate")
			content_refs[content_ref] = true
		_validate_steps(entry["steps"], path + ".steps", errors)


static func _validate_steps(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_ARRAY or value.size() < MIN_STEPS or value.size() > MAX_STEPS:
		_add_error(errors, path, "expected_1_to_6_steps")
		return
	for index in value.size():
		_validate_non_empty_string(value[index], "%s[%d]" % [path, index], errors)


static func _validate_dictionary(value, fields: Array, path: String, errors: Array[String]) -> bool:
	if typeof(value) != TYPE_DICTIONARY:
		_add_error(errors, path, "expected_dictionary")
		return false
	for field in fields:
		if not value.has(field):
			_add_error(errors, path + "." + field, "missing_required_field")
	var actual: Array = value.keys()
	actual.sort()
	for field in actual:
		if field not in fields:
			_add_error(errors, path + "." + str(field), "unknown_field")
	for field in fields:
		if not value.has(field):
			return false
	return true


static func _validate_identifier(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_STRING or value.is_empty() or value.length() > 96 or value != value.strip_edges():
		_add_error(errors, path, "invalid_identifier")
		return
	for index in value.length():
		if value.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			_add_error(errors, path, "invalid_identifier")
			return


static func _validate_non_empty_string(value, path: String, errors: Array[String]) -> void:
	if typeof(value) != TYPE_STRING or value.is_empty() or value != value.strip_edges():
		_add_error(errors, path, "expected_non_empty_string")


static func _is_semver(value) -> bool:
	if typeof(value) != TYPE_STRING:
		return false
	var parts: PackedStringArray = value.split(".", false)
	if parts.size() != 3:
		return false
	for part in parts:
		if not part.is_valid_int() or int(part) < 0 or (part.length() > 1 and part.begins_with("0")):
			return false
	return true


static func _add_error(errors: Array[String], path: String, code: String) -> void:
	errors.append("%s: %s" % [path, code])


static func _result(errors: Array[String]) -> Dictionary:
	errors.sort()
	return {"valid": errors.is_empty(), "errors": errors.duplicate()}
