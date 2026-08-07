extends RefCounted

class_name R8CCatalogMediaResolver

const REQUIRED_METHODS := [
	"catalog_identity", "media_definition", "media_ids", "resolve", "resolve_thumbnail",
]

var _catalog_id := ""
var _catalog_fingerprint := ""
var _resolver_by_media_id: Dictionary = {}
var _media_ids: Array = []


static func create(catalog_id: String, fingerprint: String, packages: Array) -> Dictionary:
	if catalog_id.is_empty() or fingerprint.is_empty():
		return _failure("INVALID_CATALOG_IDENTITY")
	var resolver := new()
	resolver._catalog_id = catalog_id
	resolver._catalog_fingerprint = fingerprint
	for package in packages:
		if typeof(package) != TYPE_DICTIONARY:
			return _failure("INVALID_PACKAGE")
		var package_resolver = package.get("media_resolver")
		if package_resolver == null:
			return _failure("INVALID_PACKAGE_MEDIA_RESOLVER")
		for method_name in REQUIRED_METHODS:
			if not package_resolver.has_method(method_name):
				return _failure("INVALID_PACKAGE_MEDIA_RESOLVER")
		var package_media_ids: Array = package_resolver.media_ids()
		for media_id in package_media_ids:
			if resolver._resolver_by_media_id.has(media_id):
				return _failure("DUPLICATE_GLOBAL_MEDIA_ID")
			resolver._resolver_by_media_id[media_id] = package_resolver
		for beat in package.get("sequence", {}).get("beats", []):
			if beat.get("type") != "MEDIA_REVEAL":
				continue
			var authored_media_id = beat.get("content", {}).get("media_id")
			if authored_media_id in package_media_ids and authored_media_id not in resolver._media_ids:
				resolver._media_ids.append(authored_media_id)
		for media_id in package_media_ids:
			if media_id not in resolver._media_ids:
				resolver._media_ids.append(media_id)
	return {"ok": true, "error_code": null, "resolver": resolver}


func catalog_identity() -> Dictionary:
	return {"catalog_id": _catalog_id, "catalog_fingerprint": _catalog_fingerprint}


func media_ids() -> Array:
	return _media_ids.duplicate()


func media_definition(media_id: String) -> Dictionary:
	var resolver = _resolver_by_media_id.get(media_id)
	return resolver.media_definition(media_id) if resolver != null else {}


func resolve(media_id: String) -> Dictionary:
	var resolver = _resolver_by_media_id.get(media_id)
	return resolver.resolve(media_id) if resolver != null else _resolution_failure("UNKNOWN_MEDIA")


func resolve_thumbnail(media_id: String, accessible_child_ids: Array = []) -> Dictionary:
	var resolver = _resolver_by_media_id.get(media_id)
	return (
		resolver.resolve_thumbnail(media_id, accessible_child_ids)
		if resolver != null else _resolution_failure("UNKNOWN_MEDIA")
	)


static func _failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "resolver": null}


static func _resolution_failure(error_code: String) -> Dictionary:
	return {"ok": false, "error_code": error_code, "presentation": {}}
