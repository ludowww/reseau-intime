extends RefCounted

class_name R8CJsonValueNormalizer


static func normalize(value):
	if typeof(value) == TYPE_FLOAT and value == floor(value):
		return int(value)
	if typeof(value) == TYPE_ARRAY:
		var array: Array = []
		for item in value:
			array.append(normalize(item))
		return array
	if typeof(value) == TYPE_DICTIONARY:
		var dictionary := {}
		for key in value:
			dictionary[key] = normalize(value[key])
		return dictionary
	return value
