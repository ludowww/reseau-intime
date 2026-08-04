extends RefCounted

class_name R8CA5NarrativeStateCodec

const EtatNarratifModele := preload("res://scripts/narrative_state/EtatNarratif.gd")
const EtatRelationModele := preload("res://scripts/narrative_state/EtatRelation.gd")
const EtatRelationCentraleModele := preload("res://scripts/narrative_state/EtatRelationCentrale.gd")
const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")

const RACINES_VIDES := ["promesses", "obligations", "traces_narratives", "connaissances", "livraison_medias"]
const CHAMPS_ETAT := [
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
const MAX_EVENEMENTS := 4096
const MAX_FAITS_PAR_RELATION := 512
const MAX_LONGUEUR_CHAINE := 512


static func creer_etat(snapshot):
	if not valider(snapshot):
		return null
	return EtatNarratifModele.creer_depuis_snapshot(snapshot)


static func valider(etat) -> bool:
	if typeof(etat) != TYPE_DICTIONARY:
		return false
	if not _champs_exacts(etat, CHAMPS_ETAT):
		return false
	var progression = etat.get("progression_saison")
	if typeof(progression) != TYPE_DICTIONARY or not _champs_exacts(progression, CHAMPS_PROGRESSION):
		return false
	if progression["acte_courant"] != null:
		return false
	for champ in CHAMPS_PROGRESSION.slice(1):
		if typeof(progression[champ]) != TYPE_ARRAY or not progression[champ].is_empty():
			return false
	for racine in RACINES_VIDES:
		if typeof(etat.get(racine)) != TYPE_DICTIONARY or not etat[racine].is_empty():
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
