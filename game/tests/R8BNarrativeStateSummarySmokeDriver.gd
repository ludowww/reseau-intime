extends Node
const State := preload("res://scripts/runtime/season_1/Season1State.gd")
const Lecture := preload("res://scripts/runtime/season_1/EtatNarratifLecture.gd")
var failures: Array[String] = []
func _ready() -> void:
	_run(); print("R8B_C1_NARRATIVE_STATE_SUMMARY: OK" if failures.is_empty() else "R8B_C1_NARRATIVE_STATE_SUMMARY: FAILED " + str(failures)); get_tree().quit(0 if failures.is_empty() else 1)
func _expect(value: bool, label: String) -> void:
	if not value: failures.append(label)
func _run() -> void:
	var state := State.new(); var lecture := Lecture.new(); var before := state.snapshot(); var global := lecture.obtenir_resume_etat_narratif(state)
	_expect(state.snapshot() == before, "snapshot identique apres lecture")
	_expect(global == lecture.obtenir_resume_etat_narratif(state), "deux lectures successives egales")
	_expect(global.relations.size() == 6, "six relations")
	for relation in global.relations: _expect(relation.has_all(["personnage_id", "etat_arc", "statut_relation", "confiance", "desir", "intimite", "secret", "dernier_evenement_majeur_id", "faits_utiles", "debug"]), "cles relation " + str(relation.personnage_id))
	_expect(lecture.obtenir_resume_relation("nico", state).desir == "NONE", "nico sans desir player")
	_expect(lecture.obtenir_resume_relation("inconnu", state).etat_arc == "INCONNU", "inconnu explicite")
	state.couple_state = "RECONQUEST_ACTIVE"; var central := lecture.obtenir_resume_relation_centrale(state)
	_expect(central.statut_couple == "ENSEMBLE" and not central.statut_couple in ["RECONQUETE", "PROVISOIRE", "FRACTURE"], "reconquete dans taxonomie couple bornee")
	for couple_state in ["SEPARATION", "BASELINE_SHARED_LIFE", "RECONQUEST_ACTIVE", "PROVISIONAL_AGREEMENT", "DOUBLE_LIFE_FRAGILE", "FRACTURE", "RECONFIGURATION_NEGOTIATING", "AUTRE"]:
		state.couple_state = couple_state; _expect(lecture.obtenir_resume_relation_centrale(state).statut_couple in ["ENSEMBLE", "SEPARES", "EN_CLARIFICATION", "INDETERMINE"], "taxonomie statut couple " + couple_state)
	state.couple_state = "RECONQUEST_ACTIVE"; state.j19_raphaelle_outcome = "CREATIVE_CONFIDENCE"
	var raphaelle := lecture.obtenir_resume_relation("raphaelle", state); _expect(raphaelle.etat_arc == "CREATIVE_TRUST" and raphaelle.statut_relation == "ACTIVE", "arc precis distinct du statut")
	var marie := lecture.obtenir_resume_relation("marie", state); _expect(marie.etat_arc == "INDETERMINE" and marie.etat_arc != state.couple_state, "Marie individuelle distincte du couple")
	state.traces["j99_sandra_z"] = {"owner": "Sandra", "current_state": "ACTIVE"}; state.traces["j01_sandra_a"] = {"owner": "Sandra", "current_state": "ACTIVE"}
	_expect(lecture.obtenir_resume_relation("sandra", state).dernier_evenement_majeur_id == "", "trace lexicale ne devient pas dernier evenement")
	state.knowledge["j01_same_suffix"] = {"current_knowers": ["Sandra"], "initial_knowers": ["Nico"], "shareability": "PRIVATE"}; state.knowledge["j02_same_suffix"] = {"current_knowers": ["Nico"], "initial_knowers": ["Sandra"], "shareability": "PRIVATE"}
	var sandra_faits: Array = lecture.obtenir_resume_relation("sandra", state).faits_utiles; _expect(sandra_faits.size() == 1, "current_knowers prevaut sur initial_knowers")
	_expect(lecture.obtenir_resume_relation("sandra", state).secret == "INDETERMINE", "fait prive non relationnel sans secret projete")
	var aliases: Array = lecture.obtenir_resume_etat_narratif(state).connaissances_majeures; _expect(aliases.size() >= 2 and aliases[0] != aliases[1], "aliases publics uniques pour suffixes legacy identiques")
	state.foreground_history.append({"character_id": "Sandra", "function": "j02_sandra_conversation"}); state.foreground_history.append({"character_id": "Sandra", "function": "j01_sandra_conversation"})
	_expect(lecture.obtenir_resume_relation("sandra", state).dernier_evenement_majeur_id.ends_with("6A30315F73616E6472615F636F6E766572736174696F6E"), "dernier evenement suit append-only et non ordre lexical")
	var after := state.snapshot(); lecture.obtenir_resume_etat_narratif(state); _expect(state.snapshot() == after, "lecture ne mute pas registres")
