extends RefCounted

class_name R8CAuthoredSequenceCatalogV1

const SCHEMA_ID := "reseau_intime.authored_sequence_catalog"
const SCHEMA_VERSION := 1
const ROOT_FIELDS := ["schema_id", "schema_version", "catalog_id", "season_id", "packages"]
const PACKAGE_FIELDS := [
	"package_id", "sequence_id", "authored_version", "sequence_path",
	"messages_path", "physical_path", "media_path",
]
const PATH_FIELDS := ["sequence_path", "messages_path", "physical_path", "media_path"]


static func canonical_manifest(value: Dictionary) -> Dictionary:
	var packages: Array = []
	for package in value.get("packages", []):
		if typeof(package) != TYPE_DICTIONARY:
			packages.append(package)
			continue
		var canonical_package := {}
		for field in PACKAGE_FIELDS:
			canonical_package[field] = package.get(field)
		packages.append(canonical_package)
	return {
		"schema_id": value.get("schema_id"),
		"schema_version": value.get("schema_version"),
		"catalog_id": value.get("catalog_id"),
		"season_id": value.get("season_id"),
		"packages": packages,
	}


static func fingerprint(value: Dictionary) -> String:
	return JSON.stringify(canonical_manifest(value), "", true, true).sha256_text()


static func schema_contract() -> Dictionary:
	return {
		"schema_id": SCHEMA_ID,
		"schema_version": SCHEMA_VERSION,
		"root_fields": ROOT_FIELDS.duplicate(),
		"package_fields": PACKAGE_FIELDS.duplicate(),
	}
