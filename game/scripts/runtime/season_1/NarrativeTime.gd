extends RefCounted

class_name NarrativeTime

static func parse_narrative_time(value: String) -> int:
	if value.length() != 5 or value.substr(2, 1) != ":":
		return -1
	var hour_text := value.substr(0, 2)
	var minute_text := value.substr(3, 2)
	if not hour_text.is_valid_int() or not minute_text.is_valid_int():
		return -1
	var hour := int(hour_text)
	var minute := int(minute_text)
	if hour < 0 or hour > 23 or minute < 0 or minute > 59:
		return -1
	return hour * 60 + minute

static func format_narrative_time(minutes: int) -> String:
	if minutes < 0 or minutes >= 24 * 60:
		return ""
	return "%02d:%02d" % [minutes / 60, minutes % 60]
