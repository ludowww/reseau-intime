extends RefCounted

class_name R8CDurableMediaIdentifier

const MAX_LENGTH := 160
const ALLOWED_CHARACTERS := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_"


static func validate(value) -> bool:
	return format_valid(value) and not forbidden_day_identity(value)


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
	if typeof(value) != TYPE_STRING or value != value.to_lower():
		return false
	var parts: PackedStringArray = value.split("_", false)
	for index in parts.size():
		var part: String = parts[index]
		if part.length() == 3 and part.begins_with("j") and part.substr(1, 2).is_valid_int():
			return true
		if part == "chapter" and index + 1 < parts.size():
			var number: String = parts[index + 1]
			if number.length() == 2 and number.is_valid_int():
				return true
	return false
