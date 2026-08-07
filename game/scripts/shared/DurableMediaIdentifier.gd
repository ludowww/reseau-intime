extends RefCounted

class_name R8CDurableMediaIdentifier

const MAX_LENGTH := 160
const ALLOWED_CHARACTERS := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"
const MODERN_CHARACTERS := "abcdefghijklmnopqrstuvwxyz0123456789_"
const LEGACY_SEGMENT_CHARACTERS := "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"


static func validate(value) -> bool:
	return modern_valid(value) or frozen_legacy_valid(value)


static func modern_valid(value) -> bool:
	if not format_valid(value) or value != value.to_lower() or not _segments_are_closed(value):
		return false
	for index in value.length():
		if value.substr(index, 1) not in MODERN_CHARACTERS:
			return false
	return not _contains_day_identity(value)


static func frozen_legacy_valid(value) -> bool:
	if not format_valid(value) or not _segments_are_closed(value):
		return false
	var parts: PackedStringArray = value.split("_", true)
	if parts.size() < 5 or parts[0] != "S1" or parts[3] != "SCN":
		return false
	if not _prefixed_number(parts[1], "A", 1) or not _prefixed_number(parts[2], "J", 2):
		return false
	for index in range(4, parts.size()):
		for character_index in parts[index].length():
			if parts[index].substr(character_index, 1) not in LEGACY_SEGMENT_CHARACTERS:
				return false
	return true


static func format_valid(value) -> bool:
	if (
		typeof(value) != TYPE_STRING
		or value.is_empty()
		or value.length() > MAX_LENGTH
		or value != value.strip_edges()
	):
		return false
	for index in value.length():
		if value.substr(index, 1) not in ALLOWED_CHARACTERS:
			return false
	return true


static func forbidden_day_identity(value) -> bool:
	if not format_valid(value) or frozen_legacy_valid(value):
		return false
	return _contains_day_identity(value.to_lower())


static func _contains_day_identity(value: String) -> bool:
	var parts: PackedStringArray = value.split("_", true)
	for index in parts.size():
		var part: String = parts[index]
		if part.length() == 3 and part.begins_with("j") and part.substr(1, 2).is_valid_int():
			return true
		if part == "chapter" and index + 1 < parts.size():
			var number: String = parts[index + 1]
			if number.length() == 2 and number.is_valid_int():
				return true
	return false


static func _segments_are_closed(value: String) -> bool:
	return not value.begins_with("_") and not value.ends_with("_") and "__" not in value


static func _prefixed_number(value: String, prefix: String, digit_count: int) -> bool:
	if not value.begins_with(prefix) or value.length() != prefix.length() + digit_count:
		return false
	return value.substr(prefix.length(), digit_count).is_valid_int()
