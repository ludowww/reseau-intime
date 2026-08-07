extends RefCounted

class_name R8CNarrativeMoment


static func validate(value) -> bool:
	return not _parts(value).is_empty()


static func compare(left, right) -> int:
	var left_parts := _parts(left)
	var right_parts := _parts(right)
	if left_parts.is_empty() or right_parts.is_empty():
		return 0
	var left_unix := _unix_utc(left_parts)
	var right_unix := _unix_utc(right_parts)
	if left_unix < right_unix:
		return -1
	if left_unix > right_unix:
		return 1
	return 0


static func add_minutes(value, minutes) -> String:
	var parts := _parts(value)
	if parts.is_empty() or typeof(minutes) != TYPE_INT or minutes < 0:
		return ""
	var local_unix: int = int(Time.get_unix_time_from_datetime_dict({
		"year": parts["year"],
		"month": parts["month"],
		"day": parts["day"],
		"hour": parts["hour"],
		"minute": parts["minute"],
		"second": parts["second"],
	})) + minutes * 60
	var shifted := Time.get_datetime_dict_from_unix_time(local_unix)
	return "%04d-%02d-%02dT%02d:%02d:%02d%s" % [
		shifted["year"], shifted["month"], shifted["day"],
		shifted["hour"], shifted["minute"], shifted["second"], parts["offset_text"],
	]


static func same_offset(left, right) -> bool:
	var left_parts := _parts(left)
	var right_parts := _parts(right)
	return (
		not left_parts.is_empty()
		and not right_parts.is_empty()
		and left_parts["offset_minutes"] == right_parts["offset_minutes"]
	)


static func _parts(value) -> Dictionary:
	if typeof(value) != TYPE_STRING or value.length() != 25:
		return {}
	for index in [4, 7, 10, 13, 16, 22]:
		var expected := "-" if index in [4, 7] else (
			"T" if index == 10 else ":"
		)
		if value.substr(index, 1) != expected:
			return {}
	if value.substr(19, 1) not in ["+", "-"]:
		return {}
	for span in [[0, 4], [5, 2], [8, 2], [11, 2], [14, 2], [17, 2], [20, 2], [23, 2]]:
		if not value.substr(span[0], span[1]).is_valid_int():
			return {}
	var parts := {
		"year": int(value.substr(0, 4)),
		"month": int(value.substr(5, 2)),
		"day": int(value.substr(8, 2)),
		"hour": int(value.substr(11, 2)),
		"minute": int(value.substr(14, 2)),
		"second": int(value.substr(17, 2)),
		"offset_hour": int(value.substr(20, 2)),
		"offset_minute": int(value.substr(23, 2)),
		"offset_text": value.substr(19, 6),
	}
	if (
		parts["year"] < 1
		or parts["month"] < 1 or parts["month"] > 12
		or parts["day"] < 1 or parts["day"] > 31
		or parts["hour"] < 0 or parts["hour"] > 23
		or parts["minute"] < 0 or parts["minute"] > 59
		or parts["second"] < 0 or parts["second"] > 59
		or parts["offset_hour"] < 0 or parts["offset_hour"] > 14
		or parts["offset_minute"] < 0 or parts["offset_minute"] > 59
		or (parts["offset_hour"] == 14 and parts["offset_minute"] != 0)
	):
		return {}
	var local_unix := Time.get_unix_time_from_datetime_dict({
		"year": parts["year"], "month": parts["month"], "day": parts["day"],
		"hour": parts["hour"], "minute": parts["minute"], "second": parts["second"],
	})
	var round_trip := Time.get_datetime_dict_from_unix_time(local_unix)
	for field in ["year", "month", "day", "hour", "minute", "second"]:
		if round_trip[field] != parts[field]:
			return {}
	var offset_sign := -1 if value.substr(19, 1) == "-" else 1
	parts["offset_minutes"] = offset_sign * (
		parts["offset_hour"] * 60 + parts["offset_minute"]
	)
	return parts


static func _unix_utc(parts: Dictionary) -> int:
	return Time.get_unix_time_from_datetime_dict({
		"year": parts["year"], "month": parts["month"], "day": parts["day"],
		"hour": parts["hour"], "minute": parts["minute"], "second": parts["second"],
	}) - parts["offset_minutes"] * 60
