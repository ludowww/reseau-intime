extends RefCounted

class_name R8CControlledNarrativeSlotCompositionCoordinator

const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")

const FORMAT_PLAN := "R8C_A9_CONTROLLED_NARRATIVE_SLOT_PLAN"
const VERSION_PLAN := 1
const MAX_WINDOWS := 32
const MAX_PARTICIPANTS := 32
const MAX_DURATION_MINUTES := 1440

const CHAMPS_SPECIFICATION := [
	"slot_id",
	"narrative_date",
	"starts_at",
	"ends_at",
	"context",
	"windows",
	"author_order",
]
const CHAMPS_CONTEXTE_COURANT := [
	"acte_courant",
	"participants_disponibles",
	"opportunite_valide",
	"moment_diegetique",
]
const CHAMPS_CONTEXTE_PLAN := [
	"acte_courant",
	"participants_disponibles",
	"opportunite_valide",
]
const CHAMPS_FENETRE_ENTREE := [
	"window_id",
	"duration_minutes",
	"not_before",
	"not_after",
]
const CHAMPS_PLAN := [
	"format",
	"version",
	"slot_id",
	"narrative_date",
	"starts_at",
	"ends_at",
	"context",
	"author_order",
	"windows",
	"fingerprint",
]
const CHAMPS_FENETRE_PLAN := [
	"window_id",
	"author_position",
	"duration_minutes",
	"not_before",
	"not_after",
	"starts_at",
	"ends_at",
	"window_fingerprint",
]

var _coordinateur_a8


static func creer(coordinateur_a8):
	if (
		coordinateur_a8 == null
		or typeof(coordinateur_a8) != TYPE_OBJECT
		or not coordinateur_a8.has_method("obtenir_fenetre")
		or not coordinateur_a8.has_method("revalider_fenetre_planifiable")
		or not coordinateur_a8.has_method("revalider_fenetre_planifiable_dev")
	):
		return null
	var coordinateur := new()
	coordinateur._coordinateur_a8 = coordinateur_a8
	return coordinateur


func composer(specification, etat_narratif) -> Dictionary:
	return _composer(specification, etat_narratif, false)


func composer_dev(specification, etat_narratif) -> Dictionary:
	if not _diagnostics_detailles_autorises():
		return {"ok": false, "erreur": "DIAGNOSTICS_INDISPONIBLES", "plan": {}}
	return _composer(specification, etat_narratif, true)


func revalider_plan(plan, etat_narratif, contexte_courant: Dictionary) -> Dictionary:
	return _revalider_plan(plan, etat_narratif, contexte_courant, false)


func revalider_plan_dev(plan, etat_narratif, contexte_courant: Dictionary) -> Dictionary:
	if not _diagnostics_detailles_autorises():
		return {"ok": false, "erreur": "DIAGNOSTICS_INDISPONIBLES"}
	return _revalider_plan(plan, etat_narratif, contexte_courant, true)


func _composer(specification, etat_narratif, inclure_diagnostics: bool) -> Dictionary:
	var erreur := _valider_specification(specification)
	if not erreur.is_empty():
		return _echec(erreur, inclure_diagnostics)
	if (
		etat_narratif == null
		or typeof(etat_narratif) != TYPE_OBJECT
		or not etat_narratif.has_method("obtenir_snapshot")
	):
		return _echec("ETAT_NARRATIF_ABSENT", inclure_diagnostics)
	var calcul: Dictionary = _calculer_implantation(
		specification["narrative_date"],
		specification["starts_at"],
		specification["ends_at"],
		specification["windows"],
		specification["author_order"],
	)
	if not calcul["ok"]:
		return _echec(
			calcul["code"],
			inclure_diagnostics,
			calcul["author_position"],
			calcul["window_id"],
		)
	var implantation: Array = []
	for position in calcul["windows"].size():
		var fenetre_calculee: Dictionary = calcul["windows"][position]
		var window_id: String = fenetre_calculee["window_id"]
		var verification: Dictionary = (
			_coordinateur_a8.revalider_fenetre_planifiable_dev(
				window_id,
				etat_narratif,
				specification["context"],
				fenetre_calculee["starts_at"],
				fenetre_calculee["ends_at"],
			)
			if inclure_diagnostics
			else _coordinateur_a8.revalider_fenetre_planifiable(
				window_id,
				etat_narratif,
				specification["context"],
				fenetre_calculee["starts_at"],
				fenetre_calculee["ends_at"],
			)
		)
		if not verification.get("ok", false):
			var code_a8: String = verification.get("diagnostic", {}).get(
				"code", "REVALIDATION_A8_REFUSEE"
			)
			return _echec(code_a8, inclure_diagnostics, position, window_id)
		var fenetre_plan: Dictionary = fenetre_calculee.duplicate(true)
		fenetre_plan["window_fingerprint"] = verification["window_fingerprint"]
		implantation.append(fenetre_plan)
	var plan := {
		"format": FORMAT_PLAN,
		"version": VERSION_PLAN,
		"slot_id": specification["slot_id"],
		"narrative_date": specification["narrative_date"],
		"starts_at": specification["starts_at"],
		"ends_at": specification["ends_at"],
		"context": _contexte_plan(specification["context"]),
		"author_order": specification["author_order"].duplicate(),
		"windows": implantation,
	}
	plan["fingerprint"] = _empreinte_contenu_plan(plan)
	var resultat := {"ok": true, "erreur": "", "plan": plan.duplicate(true)}
	if inclure_diagnostics:
		resultat["diagnostic"] = {
			"code": "PLAN_CRENEAU_COMPOSE",
			"strategie": "EARLIEST_FIT_ORDRE_AUTEUR",
			"fenetres_planifiees": implantation.size(),
		}
	return resultat


func _revalider_plan(
	plan,
	etat_narratif,
	contexte_courant: Dictionary,
	inclure_diagnostics: bool
) -> Dictionary:
	var erreur := _valider_plan(plan)
	if not erreur.is_empty():
		return _echec_revalidation(erreur, inclure_diagnostics)
	if (
		etat_narratif == null
		or typeof(etat_narratif) != TYPE_OBJECT
		or not etat_narratif.has_method("obtenir_snapshot")
	):
		return _echec_revalidation("ETAT_NARRATIF_ABSENT", inclure_diagnostics)
	if not _contexte_courant_valide(
		contexte_courant,
		plan["narrative_date"],
		plan["starts_at"],
	):
		return _echec_revalidation("CONTEXTE_COURANT_INVALIDE", inclure_diagnostics)
	if _contexte_plan(contexte_courant) != plan["context"]:
		return _echec_revalidation("CONTEXTE_PLAN_CHANGE", inclure_diagnostics)
	if _empreinte_contenu_plan(plan) != plan["fingerprint"]:
		return _echec_revalidation("EMPREINTE_PLAN_INVALIDE", inclure_diagnostics)
	var calcul: Dictionary = _calculer_implantation(
		plan["narrative_date"],
		plan["starts_at"],
		plan["ends_at"],
		_descriptions_depuis_plan(plan["windows"]),
		plan["author_order"],
	)
	if not calcul["ok"]:
		return _echec_revalidation(
			calcul["code"],
			inclure_diagnostics,
			calcul["author_position"],
			calcul["window_id"],
		)
	for position in plan["windows"].size():
		var fenetre_plan: Dictionary = plan["windows"][position]
		var fenetre_attendue: Dictionary = calcul["windows"][position]
		if (
			fenetre_plan["starts_at"] != fenetre_attendue["starts_at"]
			or fenetre_plan["ends_at"] != fenetre_attendue["ends_at"]
		):
			return _echec_revalidation(
				"IMPLANTATION_NON_CANONIQUE",
				inclure_diagnostics,
				position,
				fenetre_plan["window_id"],
			)
		var verification: Dictionary = (
			_coordinateur_a8.revalider_fenetre_planifiable_dev(
				fenetre_plan["window_id"],
				etat_narratif,
				contexte_courant,
				fenetre_plan["starts_at"],
				fenetre_plan["ends_at"],
			)
			if inclure_diagnostics
			else _coordinateur_a8.revalider_fenetre_planifiable(
				fenetre_plan["window_id"],
				etat_narratif,
				contexte_courant,
				fenetre_plan["starts_at"],
				fenetre_plan["ends_at"],
			)
		)
		if not verification.get("ok", false):
			var code_a8: String = verification.get("diagnostic", {}).get(
				"code", "REVALIDATION_A8_REFUSEE"
			)
			return _echec_revalidation(code_a8, inclure_diagnostics, position, fenetre_plan["window_id"])
		if verification["window_fingerprint"] != fenetre_plan["window_fingerprint"]:
			return _echec_revalidation(
				"IDENTITE_FENETRE_A8_CHANGE",
				inclure_diagnostics,
				position,
				fenetre_plan["window_id"],
			)
	var resultat := {
		"ok": true,
		"erreur": "",
		"valid": true,
		"slot_id": plan["slot_id"],
		"fingerprint": plan["fingerprint"],
	}
	if inclure_diagnostics:
		resultat["diagnostic"] = {
			"code": "PLAN_CRENEAU_REVALIDE",
			"fenetres_revalidees": plan["windows"].size(),
		}
	return resultat


func _calculer_implantation(
	narrative_date: String,
	starts_at: String,
	ends_at: String,
	descriptions: Array,
	author_order: Array
) -> Dictionary:
	var descriptions_par_id := {}
	for description in descriptions:
		descriptions_par_id[description["window_id"]] = description
	var implantation: Array = []
	var curseur := _minutes(starts_at)
	var offset: String = starts_at.substr(19, 6)
	for position in author_order.size():
		var window_id: String = author_order[position]
		var description: Dictionary = descriptions_par_id[window_id]
		var fenetre: Dictionary = _coordinateur_a8.obtenir_fenetre(window_id)
		var erreur_fenetre := _valider_resume_a8(
			fenetre,
			narrative_date,
			starts_at,
		)
		if not erreur_fenetre.is_empty():
			return _calcul_refuse(erreur_fenetre, position, window_id)
		var debut_minutes: int = max(
			curseur,
			max(_minutes(description["not_before"]), _minutes(fenetre["opens_at"])),
		)
		var fin_minutes: int = debut_minutes + description["duration_minutes"]
		var fin_autorisee: int = min(
			_minutes(ends_at),
			min(_minutes(description["not_after"]), _minutes(fenetre["closes_at"])),
		)
		if fin_minutes > fin_autorisee:
			return _calcul_refuse("ORDRE_AUTEUR_IMPOSSIBLE", position, window_id)
		implantation.append({
			"window_id": window_id,
			"author_position": position,
			"duration_minutes": description["duration_minutes"],
			"not_before": description["not_before"],
			"not_after": description["not_after"],
			"starts_at": _instant(narrative_date, debut_minutes, offset),
			"ends_at": _instant(narrative_date, fin_minutes, offset),
		})
		curseur = fin_minutes
	return {
		"ok": true,
		"code": "",
		"author_position": -1,
		"window_id": "",
		"windows": implantation,
	}


static func _descriptions_depuis_plan(windows: Array) -> Array:
	var descriptions: Array = []
	for fenetre in windows:
		descriptions.append({
			"window_id": fenetre["window_id"],
			"duration_minutes": fenetre["duration_minutes"],
			"not_before": fenetre["not_before"],
			"not_after": fenetre["not_after"],
		})
	return descriptions


static func _calcul_refuse(code: String, position: int, window_id: String) -> Dictionary:
	return {
		"ok": false,
		"code": code,
		"author_position": position,
		"window_id": window_id,
		"windows": [],
	}


func _valider_specification(specification) -> String:
	if typeof(specification) != TYPE_DICTIONARY or not _cles_exactes(
		specification, CHAMPS_SPECIFICATION
	):
		return "SPECIFICATION_CRENEAU_INVALIDE"
	if not _identifiant_valide(specification["slot_id"]):
		return "SLOT_ID_INVALIDE"
	if not _bornes_slot_valides(specification):
		return "BORNES_CRENEAU_INVALIDES"
	if not _contexte_courant_valide(
		specification["context"],
		specification["narrative_date"],
		specification["starts_at"],
	):
		return "CONTEXTE_CRENEAU_INVALIDE"
	if specification["context"]["moment_diegetique"] > specification["starts_at"]:
		return "CRENEAU_DEJA_COMMENCE"
	var windows = specification["windows"]
	if typeof(windows) != TYPE_ARRAY or windows.is_empty() or windows.size() > MAX_WINDOWS:
		return "FENETRES_CRENEAU_INVALIDES"
	var descriptions := {}
	for description in windows:
		if typeof(description) != TYPE_DICTIONARY or not _cles_exactes(
			description, CHAMPS_FENETRE_ENTREE
		):
			return "DESCRIPTION_FENETRE_INVALIDE"
		if not _identifiant_valide(description["window_id"]):
			return "WINDOW_ID_INVALIDE"
		if descriptions.has(description["window_id"]):
			return "WINDOW_ID_DUPLIQUE"
		if (
			typeof(description["duration_minutes"]) != TYPE_INT
			or description["duration_minutes"] <= 0
			or description["duration_minutes"] > MAX_DURATION_MINUTES
		):
			return "DUREE_FENETRE_INVALIDE"
		if not _intervalle_minute_valide(
			description["not_before"],
			description["not_after"],
			specification["narrative_date"],
			specification["starts_at"],
		):
			return "BORNES_FENETRE_INVALIDES"
		if (
			description["not_before"] < specification["starts_at"]
			or description["not_after"] > specification["ends_at"]
		):
			return "FENETRE_HORS_CRENEAU"
		descriptions[description["window_id"]] = true
	var ordre = specification["author_order"]
	if typeof(ordre) != TYPE_ARRAY or ordre.size() != windows.size():
		return "ORDRE_AUTEUR_INVALIDE"
	var ordre_ids := {}
	for window_id in ordre:
		if not _identifiant_valide(window_id) or not descriptions.has(window_id):
			return "ORDRE_AUTEUR_INVALIDE"
		if ordre_ids.has(window_id):
			return "ORDRE_AUTEUR_DUPLIQUE"
		ordre_ids[window_id] = true
	return ""


func _valider_plan(plan) -> String:
	if typeof(plan) != TYPE_DICTIONARY or not _cles_exactes(plan, CHAMPS_PLAN):
		return "FORMAT_PLAN_INVALIDE"
	if plan["format"] != FORMAT_PLAN or plan["version"] != VERSION_PLAN:
		return "VERSION_PLAN_INVALIDE"
	if not _identifiant_valide(plan["slot_id"]):
		return "SLOT_ID_INVALIDE"
	if not _bornes_slot_valides(plan) or not _contexte_plan_valide(plan["context"]):
		return "CONTENU_PLAN_INVALIDE"
	if not _empreinte_valide(plan["fingerprint"]):
		return "EMPREINTE_PLAN_INVALIDE"
	var ordre = plan["author_order"]
	var windows = plan["windows"]
	if (
		typeof(ordre) != TYPE_ARRAY
		or typeof(windows) != TYPE_ARRAY
		or ordre.is_empty()
		or ordre.size() != windows.size()
		or ordre.size() > MAX_WINDOWS
	):
		return "CONTENU_PLAN_INVALIDE"
	var ids := {}
	var fin_precedente := ""
	for position in windows.size():
		var fenetre = windows[position]
		if typeof(fenetre) != TYPE_DICTIONARY or not _cles_exactes(
			fenetre, CHAMPS_FENETRE_PLAN
		):
			return "FENETRE_PLAN_INVALIDE"
		var window_id = fenetre["window_id"]
		if (
			not _identifiant_valide(window_id)
			or ids.has(window_id)
			or ordre[position] != window_id
			or fenetre["author_position"] != position
		):
			return "ORDRE_PLAN_INVALIDE"
		ids[window_id] = true
		if (
			typeof(fenetre["duration_minutes"]) != TYPE_INT
			or fenetre["duration_minutes"] <= 0
			or fenetre["duration_minutes"] > MAX_DURATION_MINUTES
			or not _empreinte_valide(fenetre["window_fingerprint"])
		):
			return "FENETRE_PLAN_INVALIDE"
		if not _intervalle_minute_valide(
			fenetre["not_before"],
			fenetre["not_after"],
			plan["narrative_date"],
			plan["starts_at"],
		):
			return "FENETRE_PLAN_INVALIDE"
		if (
			fenetre["not_before"] < plan["starts_at"]
			or fenetre["not_after"] > plan["ends_at"]
		):
			return "FENETRE_PLAN_HORS_CRENEAU"
		if not _intervalle_minute_valide(
			fenetre["starts_at"],
			fenetre["ends_at"],
			plan["narrative_date"],
			plan["starts_at"],
		):
			return "IMPLANTATION_PLAN_INVALIDE"
		if (
			fenetre["starts_at"] < plan["starts_at"]
			or fenetre["ends_at"] > plan["ends_at"]
			or fenetre["starts_at"] < fenetre["not_before"]
			or fenetre["ends_at"] > fenetre["not_after"]
			or _minutes(fenetre["ends_at"]) - _minutes(fenetre["starts_at"])
			!= fenetre["duration_minutes"]
		):
			return "IMPLANTATION_PLAN_INVALIDE"
		if not fin_precedente.is_empty() and fenetre["starts_at"] < fin_precedente:
			return "CHEVAUCHEMENT_PLAN"
		fin_precedente = fenetre["ends_at"]
	return ""


func _valider_resume_a8(
	fenetre: Dictionary,
	narrative_date: String,
	reference_offset: String
) -> String:
	if fenetre.is_empty():
		return "FENETRE_A8_INCONNUE"
	if (
		fenetre.get("state") != "OPEN"
		or not fenetre.get("selected_option_id", "").is_empty()
		or typeof(fenetre.get("options")) != TYPE_ARRAY
		or fenetre["options"].is_empty()
	):
		return "ETAT_FENETRE_A8_INCOMPATIBLE"
	if not _intervalle_minute_valide(
		fenetre.get("opens_at"),
		fenetre.get("closes_at"),
		narrative_date,
		reference_offset,
	):
		return "BORNES_FENETRE_A8_INCOMPATIBLES"
	for option in fenetre["options"]:
		if (
			typeof(option) != TYPE_DICTIONARY
			or option.get("state") != "CANDIDATE"
			or option.get("materialized", true)
		):
			return "ETAT_FENETRE_A8_INCOMPATIBLE"
	return ""


static func _bornes_slot_valides(value: Dictionary) -> bool:
	var date = value.get("narrative_date")
	var debut = value.get("starts_at")
	var fin = value.get("ends_at")
	return (
		typeof(date) == TYPE_STRING
		and typeof(debut) == TYPE_STRING
		and typeof(fin) == TYPE_STRING
		and date.length() == 10
		and _intervalle_minute_valide(debut, fin, date, debut)
	)


static func _intervalle_minute_valide(
	debut,
	fin,
	date: String,
	reference_offset: String
) -> bool:
	return (
		_moment_minute_valide(debut)
		and _moment_minute_valide(fin)
		and debut.substr(0, 10) == date
		and fin.substr(0, 10) == date
		and DefinitionModele.meme_offset(reference_offset, debut)
		and DefinitionModele.meme_offset(reference_offset, fin)
		and debut < fin
	)


static func _contexte_courant_valide(
	contexte,
	date: String,
	reference_offset: String
) -> bool:
	if typeof(contexte) != TYPE_DICTIONARY or not _cles_exactes(
		contexte, CHAMPS_CONTEXTE_COURANT
	):
		return false
	if not _contexte_plan_valide(_contexte_plan(contexte)):
		return false
	var moment = contexte["moment_diegetique"]
	return (
		_moment_minute_valide(moment)
		and moment.substr(0, 10) == date
		and DefinitionModele.meme_offset(reference_offset, moment)
	)


static func _contexte_plan_valide(contexte) -> bool:
	if typeof(contexte) != TYPE_DICTIONARY or not _cles_exactes(
		contexte, CHAMPS_CONTEXTE_PLAN
	):
		return false
	if not _chaine_bornee(contexte.get("acte_courant"), 96):
		return false
	if typeof(contexte.get("opportunite_valide")) != TYPE_BOOL:
		return false
	var participants = contexte.get("participants_disponibles")
	if (
		typeof(participants) != TYPE_DICTIONARY
		or participants.is_empty()
		or participants.size() > MAX_PARTICIPANTS
	):
		return false
	for personnage_id in participants:
		if not _identifiant_valide(personnage_id) or typeof(participants[personnage_id]) != TYPE_BOOL:
			return false
	return true


static func _contexte_plan(contexte: Dictionary) -> Dictionary:
	return {
		"acte_courant": contexte.get("acte_courant"),
		"participants_disponibles": contexte.get("participants_disponibles", {}).duplicate(true),
		"opportunite_valide": contexte.get("opportunite_valide"),
	}


static func _moment_minute_valide(moment) -> bool:
	return DefinitionModele.moment_normalise_valide(moment) and moment.substr(17, 2) == "00"


static func _minutes(moment: String) -> int:
	return DefinitionModele.heure_en_minutes(moment.substr(11, 5))


static func _instant(date: String, minutes: int, offset: String) -> String:
	return "%sT%02d:%02d:00%s" % [date, int(minutes / 60), minutes % 60, offset]


static func _empreinte_contenu_plan(plan: Dictionary) -> String:
	var contenu := plan.duplicate(true)
	contenu.erase("fingerprint")
	return JSON.stringify(contenu, "", true, true).sha256_text()


static func _empreinte_valide(value) -> bool:
	if typeof(value) != TYPE_STRING or value.length() != 64:
		return false
	for index in value.length():
		if value.substr(index, 1) not in "0123456789abcdef":
			return false
	return true


static func _cles_exactes(value: Dictionary, attendues: Array) -> bool:
	if value.size() != attendues.size():
		return false
	for champ in attendues:
		if not value.has(champ):
			return false
	return true


static func _identifiant_valide(value) -> bool:
	if typeof(value) != TYPE_STRING or value.is_empty() or value.length() > 96:
		return false
	if value != value.strip_edges():
		return false
	for index in value.length():
		if value.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			return false
	return true


static func _chaine_bornee(value, maximum: int) -> bool:
	return (
		typeof(value) == TYPE_STRING
		and not value.is_empty()
		and value.length() <= maximum
		and value == value.strip_edges()
	)


static func _echec(
	code: String,
	inclure_diagnostics: bool,
	position: int = -1,
	window_id: String = ""
) -> Dictionary:
	var resultat := {"ok": false, "erreur": "COMPOSITION_CRENEAU_REFUSEE", "plan": {}}
	if inclure_diagnostics:
		resultat["diagnostic"] = _diagnostic_echec(code, position, window_id)
	return resultat


static func _echec_revalidation(
	code: String,
	inclure_diagnostics: bool,
	position: int = -1,
	window_id: String = ""
) -> Dictionary:
	var resultat := {"ok": false, "erreur": "REVALIDATION_PLAN_REFUSEE", "valid": false}
	if inclure_diagnostics:
		resultat["diagnostic"] = _diagnostic_echec(code, position, window_id)
	return resultat


static func _diagnostic_echec(code: String, position: int, window_id: String) -> Dictionary:
	var diagnostic := {"code": code if not code.is_empty() else "OPERATION_A9_REFUSEE"}
	if position >= 0:
		diagnostic["author_position"] = position
	if not window_id.is_empty():
		diagnostic["window_id"] = window_id
	return diagnostic


static func _diagnostics_detailles_autorises() -> bool:
	return OS.is_debug_build() or Engine.is_editor_hint()
