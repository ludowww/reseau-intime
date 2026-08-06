extends RefCounted

class_name R8CA5NarrativeStateCodec

const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")
const EtatRelationModele := preload("res://scripts/narrative_state/EtatRelation.gd")
const EtatRelationCentraleModele := preload("res://scripts/narrative_state/EtatRelationCentrale.gd")
const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")

const FORMAT_VERSION := 2
const REGISTRES_DURABLES := ["promesses", "obligations", "traces_narratives", "connaissances", "livraison_medias"]
const CHAMPS_ETAT_V1 := [
	"progression_saison",
	"relation_centrale",
	"relations",
	"evenements",
	"promesses",
	"obligations",
	"traces_narratives",
	"connaissances",
	"livraison_medias",
]
const CHAMPS_ETAT := [
	"format_version",
	"progression_saison",
	"relation_centrale",
	"relations",
	"evenements",
	"promesses",
	"obligations",
	"traces_narratives",
	"connaissances",
	"livraison_medias",
]
const CHAMPS_PROGRESSION := [
	"acte_courant",
	"evenements_structurants",
	"conditions_sortie",
	"obligations_recentrage",
	"historique_transitions",
]
const CHAMPS_PROVENANCE := [
	"type",
	"id",
	"source_scene_id",
	"source_scene_instance_id",
	"source_choix_id",
	"source_signal_emis",
	"source_resolution_id",
	"scene_status",
]
const CHAMPS_FAIT := [
	"fait_id",
	"nature",
	"source_scene_id",
	"source_scene_instance_id",
	"source_resolution_id",
	"moment_diegetique",
	"recu_par",
	"formulee_par",
	"permission_future",
]
const CHAMPS_PROVENANCE_DURABLE := [
	"event_id", "source_scene_id", "source_scene_instance_id", "source_a10_choice_id",
	"source_a10_resolution_id", "source_sequence_id", "source_authored_version", "source_resolution_id",
	"moment_diegetique",
]
const CHAMPS_CONNAISSANCE := ["knowledge_id", "subject_id", "holder_ids", "status", "provenance"]
const CHAMPS_TRACE_NARRATIVE := [
	"trace_id", "creator_id", "audience_ids", "controller_ids", "accessible_to_ids", "status", "provenance",
	"withdrawn_at",
]
const CHAMPS_PROMESSE := [
	"promise_id", "author_id", "beneficiary_ids", "content_ref", "status", "provenance", "resolved_at",
]
const CHAMPS_OBLIGATION := [
	"obligation_id", "debtor_id", "beneficiary_ids", "kind", "status", "provenance", "resolved_at",
]
const CHAMPS_LIVRAISON_MEDIA := [
	"media_id", "diegetic_status", "fictional_audience_ids", "access_status", "gallery_status",
	"withdrawal_status", "provenance",
]
const MAX_EVENEMENTS := 4096
const MAX_FAITS_PAR_RELATION := 512
const MAX_LONGUEUR_CHAINE := 512
const MAX_RECORDS_PAR_REGISTRE := 4096


static func creer_etat(snapshot):
	var normalise := _normaliser(snapshot)
	if normalise.is_empty():
		return null
	return EtatNarratifModele.creer_depuis_snapshot(normalise)


static func valider(etat) -> bool:
	return not _normaliser(etat).is_empty()


static func _normaliser(etat) -> Dictionary:
	if typeof(etat) != TYPE_DICTIONARY:
		return {}
	var candidat: Dictionary = etat.duplicate(true)
	if candidat.has("format_version"):
		if typeof(candidat["format_version"]) != TYPE_INT or candidat["format_version"] != FORMAT_VERSION:
			return {}
	elif _champs_autorises(candidat, CHAMPS_ETAT_V1):
		for registre in REGISTRES_DURABLES:
			if candidat.has(registre) and (
				typeof(candidat[registre]) != TYPE_DICTIONARY or not candidat[registre].is_empty()
			):
				return {}
			if not candidat.has(registre):
				candidat[registre] = {}
		candidat["format_version"] = FORMAT_VERSION
	else:
		return {}
	if not _valider_v2(candidat):
		return {}
	return candidat


static func _valider_v2(etat: Dictionary) -> bool:
	if not _champs_exacts(etat, CHAMPS_ETAT):
		return false
	if typeof(etat["format_version"]) != TYPE_INT or etat["format_version"] != FORMAT_VERSION:
		return false
	var progression = etat.get("progression_saison")
	if typeof(progression) != TYPE_DICTIONARY or not _champs_exacts(progression, CHAMPS_PROGRESSION):
		return false
	if progression["acte_courant"] != null:
		return false
	for champ in CHAMPS_PROGRESSION.slice(1):
		if typeof(progression[champ]) != TYPE_ARRAY or not progression[champ].is_empty():
			return false
	if typeof(etat.get("relation_centrale")) != TYPE_DICTIONARY or not _champs_exacts(
		etat["relation_centrale"], EtatRelationCentraleModele.CHAMPS_MUTABLES
	):
		return false
	if not _faits_valides(etat["relation_centrale"].get("faits")):
		return false
	if etat["relation_centrale"]["etat_foyer"] != null or etat["relation_centrale"]["cadre_provisoire"] != null:
		return false
	if not _valeurs_qualitatives_bornees(etat["relation_centrale"], ["faits", "etat_foyer", "cadre_provisoire"]):
		return false
	var relations = etat.get("relations")
	if typeof(relations) != TYPE_DICTIONARY or relations.size() != EtatNarratifModele.PERSONNAGES.size():
		return false
	var champs_relation := ["personnage_id"] + EtatRelationModele.CHAMPS_MUTABLES
	for personnage_id in EtatNarratifModele.PERSONNAGES:
		if (
			typeof(relations.get(personnage_id)) != TYPE_DICTIONARY
			or not _champs_exacts(relations[personnage_id], champs_relation)
			or not _faits_valides(relations[personnage_id].get("faits"))
			or not _valeurs_qualitatives_bornees(relations[personnage_id], ["faits", "personnage_id"])
		):
			return false
	var evenements = etat.get("evenements")
	if typeof(evenements) != TYPE_DICTIONARY or evenements.size() > MAX_EVENEMENTS:
		return false
	for event_id in evenements:
		if not _evenement_valide(event_id, evenements[event_id]):
			return false
	return (
		_connaissances_valides(etat["connaissances"])
		and _traces_valides(etat["traces_narratives"])
		and _promesses_valides(etat["promesses"])
		and _obligations_valides(etat["obligations"])
		and _livraisons_medias_valides(etat["livraison_medias"])
	)


static func _connaissances_valides(registre) -> bool:
	if typeof(registre) != TYPE_DICTIONARY or registre.size() > MAX_RECORDS_PAR_REGISTRE:
		return false
	for knowledge_id in registre:
		var record = registre[knowledge_id]
		if (
			not _chaine_bornee(knowledge_id)
			or typeof(record) != TYPE_DICTIONARY
			or not _champs_exacts(record, CHAMPS_CONNAISSANCE)
			or record["knowledge_id"] != knowledge_id
			or not _chaine_bornee(record["subject_id"])
			or not _tableau_identifiants_valide(record["holder_ids"], true)
			or record["status"] != "KNOWN"
			or not _provenance_durable_valide(record["provenance"])
		):
			return false
	return true


static func _traces_valides(registre) -> bool:
	if typeof(registre) != TYPE_DICTIONARY or registre.size() > MAX_RECORDS_PAR_REGISTRE:
		return false
	for trace_id in registre:
		var record = registre[trace_id]
		if (
			not _chaine_bornee(trace_id)
			or typeof(record) != TYPE_DICTIONARY
			or not _champs_exacts(record, CHAMPS_TRACE_NARRATIVE)
			or record["trace_id"] != trace_id
			or not _chaine_bornee(record["creator_id"])
			or not _tableau_identifiants_valide(record["audience_ids"], false)
			or not _tableau_identifiants_valide(record["controller_ids"], false)
			or not _tableau_identifiants_valide(record["accessible_to_ids"], false)
			or record["status"] not in ["ACTIVE", "WITHDRAWN"]
			or not _provenance_durable_valide(record["provenance"])
		):
			return false
		if record["status"] == "ACTIVE" and record["withdrawn_at"] != null:
			return false
		if record["status"] == "WITHDRAWN" and not _moment_normalise_valide(record["withdrawn_at"]):
			return false
	return true


static func _promesses_valides(registre) -> bool:
	if typeof(registre) != TYPE_DICTIONARY or registre.size() > MAX_RECORDS_PAR_REGISTRE:
		return false
	for promise_id in registre:
		var record = registre[promise_id]
		if (
			not _chaine_bornee(promise_id)
			or typeof(record) != TYPE_DICTIONARY
			or not _champs_exacts(record, CHAMPS_PROMESSE)
			or record["promise_id"] != promise_id
			or not _chaine_bornee(record["author_id"])
			or not _tableau_identifiants_valide(record["beneficiary_ids"], true)
			or not _chaine_bornee(record["content_ref"])
			or record["status"] not in ["ACTIVE", "PAID", "FAILED"]
			or not _provenance_durable_valide(record["provenance"])
		):
			return false
		if record["status"] == "ACTIVE" and record["resolved_at"] != null:
			return false
		if record["status"] in ["PAID", "FAILED"] and not _moment_normalise_valide(record["resolved_at"]):
			return false
	return true


static func _obligations_valides(registre) -> bool:
	if typeof(registre) != TYPE_DICTIONARY or registre.size() > MAX_RECORDS_PAR_REGISTRE:
		return false
	for obligation_id in registre:
		var record = registre[obligation_id]
		if (
			not _chaine_bornee(obligation_id)
			or typeof(record) != TYPE_DICTIONARY
			or not _champs_exacts(record, CHAMPS_OBLIGATION)
			or record["obligation_id"] != obligation_id
			or not _chaine_bornee(record["debtor_id"])
			or not _tableau_identifiants_valide(record["beneficiary_ids"], true)
			or not _chaine_bornee(record["kind"])
			or record["status"] not in ["DUE", "PAID", "FAILED"]
			or not _provenance_durable_valide(record["provenance"])
		):
			return false
		if record["status"] == "DUE" and record["resolved_at"] != null:
			return false
		if record["status"] in ["PAID", "FAILED"] and not _moment_normalise_valide(record["resolved_at"]):
			return false
	return true


static func _livraisons_medias_valides(registre) -> bool:
	if typeof(registre) != TYPE_DICTIONARY or registre.size() > MAX_RECORDS_PAR_REGISTRE:
		return false
	for media_id in registre:
		var record = registre[media_id]
		if (
			not _chaine_bornee(media_id)
			or typeof(record) != TYPE_DICTIONARY
			or not _champs_exacts(record, CHAMPS_LIVRAISON_MEDIA)
			or record["media_id"] != media_id
			or record["diegetic_status"] not in ["NOT_APPLICABLE", "CREATED"]
			or not _tableau_identifiants_valide(record["fictional_audience_ids"], false)
			or record["access_status"] not in ["LOCKED", "ACCESSIBLE", "REVOKED"]
			or record["gallery_status"] not in ["HIDDEN", "AVAILABLE"]
			or record["withdrawal_status"] not in ["ACTIVE", "WITHDRAWN"]
			or not _provenance_durable_valide(record["provenance"])
		):
			return false
		if record["gallery_status"] == "AVAILABLE" and record["access_status"] != "ACCESSIBLE":
			return false
		if record["withdrawal_status"] == "WITHDRAWN" and (
			record["gallery_status"] != "HIDDEN" or record["access_status"] == "ACCESSIBLE"
		):
			return false
	return true


static func _provenance_durable_valide(value) -> bool:
	if typeof(value) != TYPE_DICTIONARY or not _champs_exacts(value, CHAMPS_PROVENANCE_DURABLE):
		return false
	for field in CHAMPS_PROVENANCE_DURABLE:
		if field == "moment_diegetique":
			if not _moment_normalise_valide(value[field]):
				return false
		elif not _chaine_bornee(value[field]):
			return false
	return _version_authored_valide(value["source_authored_version"])


static func _tableau_identifiants_valide(value, require_non_empty: bool) -> bool:
	if typeof(value) != TYPE_ARRAY or (require_non_empty and value.is_empty()) or value.size() > MAX_FAITS_PAR_RELATION:
		return false
	var seen := {}
	for item in value:
		if not _chaine_bornee(item) or seen.has(item):
			return false
		seen[item] = true
	return true


static func _version_authored_valide(value) -> bool:
	if typeof(value) != TYPE_STRING:
		return false
	var parts: PackedStringArray = value.split(".", false)
	if parts.size() != 3:
		return false
	for part in parts:
		if not part.is_valid_int() or int(part) < 0 or (part.length() > 1 and part.begins_with("0")):
			return false
	return true


static func _evenement_valide(event_id, evenement) -> bool:
	if not _chaine_bornee(event_id) or typeof(evenement) != TYPE_DICTIONARY:
		return false
	if not _champs_exacts(evenement, ["event_id", "event_type", "provenance", "payload"]):
		return false
	if evenement["event_id"] != event_id or evenement["event_type"] not in EtatNarratifModele.TYPES_EVENEMENTS:
		return false
	var provenance = evenement["provenance"]
	if (
		typeof(provenance) != TYPE_DICTIONARY
		or not provenance.has("type")
		or not provenance.has("id")
		or not _champs_autorises(provenance, CHAMPS_PROVENANCE)
	):
		return false
	for valeur in provenance.values():
		if not _chaine_bornee(valeur):
			return false
	if not _provenance_valide(event_id, evenement["event_type"], provenance):
		return false
	var payload = evenement["payload"]
	var relation_simple: bool = evenement["event_type"] == EtatNarratifModele.TYPE_RELATION
	var champs_payload := ["personnage_id", "changements"] if relation_simple else ["changements"]
	if typeof(payload) != TYPE_DICTIONARY or not _champs_exacts(payload, champs_payload):
		return false
	if relation_simple and payload["personnage_id"] not in EtatNarratifModele.PERSONNAGES:
		return false
	var changements = payload["changements"]
	var autorises := EtatRelationModele.CHAMPS_MUTABLES if relation_simple else EtatRelationCentraleModele.CHAMPS_MUTABLES
	if typeof(changements) != TYPE_DICTIONARY or changements.is_empty() or not _champs_autorises(changements, autorises):
		return false
	if changements.has("faits") and not _faits_valides(changements["faits"]):
		return false
	for champ in changements:
		if champ == "faits":
			continue
		if champ in ["etat_foyer", "cadre_provisoire"] and changements[champ] != null:
			return false
		if changements[champ] != null and not _chaine_bornee(changements[champ]):
			return false
	return true


static func _provenance_valide(event_id: String, event_type: String, provenance: Dictionary) -> bool:
	if provenance["type"] != "R8C_A3_SCENE_SYNTHETIQUE":
		return _champs_exacts(provenance, ["type", "id"])
	if event_type != EtatNarratifModele.TYPE_RELATION or provenance["id"] != event_id:
		return false
	var champs_resolution := [
		"type",
		"id",
		"source_scene_id",
		"source_scene_instance_id",
		"source_choix_id",
		"source_signal_emis",
		"source_resolution_id",
		"scene_status",
	]
	if _champs_exacts(provenance, champs_resolution):
		return (
			provenance["scene_status"] == "RESOLVED"
			and event_id == "r8c-a3:%s:resolution:%s" % [
				provenance["source_scene_instance_id"],
				provenance["source_resolution_id"],
			]
		)
	var champs_manquee := [
		"type",
		"id",
		"source_scene_id",
		"source_scene_instance_id",
		"source_resolution_id",
		"scene_status",
	]
	return (
		_champs_exacts(provenance, champs_manquee)
		and provenance["source_resolution_id"] == "opportunite_manquee"
		and provenance["scene_status"] in ["MISSED", "CANCELLED"]
		and event_id == "r8c-a3:%s:missed" % provenance["source_scene_instance_id"]
	)


static func _faits_valides(faits) -> bool:
	if typeof(faits) != TYPE_ARRAY or faits.size() > MAX_FAITS_PAR_RELATION:
		return false
	for fait in faits:
		if typeof(fait) == TYPE_STRING:
			if not _chaine_bornee(fait):
				return false
			continue
		if (
			typeof(fait) != TYPE_DICTIONARY
			or not fait.has("fait_id")
			or not _champs_autorises(fait, CHAMPS_FAIT)
		):
			return false
		for champ in fait:
			var valeur = fait[champ]
			if champ == "permission_future":
				if typeof(valeur) != TYPE_BOOL:
					return false
			elif not _chaine_bornee(valeur):
				return false
		if fait.has("moment_diegetique") and not _moment_normalise_valide(fait["moment_diegetique"]):
			return false
	return true


static func _valeurs_qualitatives_bornees(valeur: Dictionary, exclus: Array) -> bool:
	for champ in valeur:
		if champ in exclus:
			continue
		if valeur[champ] != null and not _chaine_bornee(valeur[champ]):
			return false
	return true


static func _moment_normalise_valide(moment) -> bool:
	if typeof(moment) != TYPE_STRING or moment.length() != 25 or not DefinitionModele.moment_valide(moment):
		return false
	if moment.substr(16, 1) != ":" or moment.substr(19, 1) not in ["+", "-"] or moment.substr(22, 1) != ":":
		return false
	var secondes: String = moment.substr(17, 2)
	var heures_offset: String = moment.substr(20, 2)
	var minutes_offset: String = moment.substr(23, 2)
	if not secondes.is_valid_int() or not heures_offset.is_valid_int() or not minutes_offset.is_valid_int():
		return false
	var secondes_nombre := int(secondes)
	var heures_offset_nombre := int(heures_offset)
	var minutes_offset_nombre := int(minutes_offset)
	return (
		secondes_nombre >= 0 and secondes_nombre <= 59
		and heures_offset_nombre >= 0 and heures_offset_nombre <= 14
		and minutes_offset_nombre >= 0 and minutes_offset_nombre <= 59
		and (heures_offset_nombre < 14 or minutes_offset_nombre == 0)
	)


static func _chaine_bornee(valeur) -> bool:
	return typeof(valeur) == TYPE_STRING and not valeur.strip_edges().is_empty() and valeur.length() <= MAX_LONGUEUR_CHAINE


static func _champs_exacts(valeur: Dictionary, attendus: Array) -> bool:
	return valeur.size() == attendus.size() and _champs_autorises(valeur, attendus)


static func _champs_autorises(valeur: Dictionary, autorises: Array) -> bool:
	for champ in valeur:
		if typeof(champ) != TYPE_STRING or champ not in autorises:
			return false
	return true
