extends Node
const State := preload("res://scripts/runtime/season_1/Season1State.gd")
const Lecture := preload("res://scripts/runtime/season_1/EtatNarratifLecture.gd")
var failures: Array[String] = []
func _ready() -> void:
	_run(); print("R8B_NARRATIVE_STATE_SUMMARY: OK" if failures.is_empty() else "R8B_NARRATIVE_STATE_SUMMARY: FAILED " + str(failures)); get_tree().quit(0 if failures.is_empty() else 1)
func _expect(value: bool, label: String) -> void:
	if not value: failures.append(label)
func _run() -> void:
	var state := State.new(); var lecture := Lecture.new(); var before := state.snapshot(); var global := lecture.obtenir_resume_etat_narratif(state)
	_expect(state.snapshot() == before, "lecture pure sur etat initial")
	_expect(global == lecture.obtenir_resume_etat_narratif(state), "deux lectures stables")
	_expect(not global.has("j01_state") and not global.has("selected_choice_ids"), "aucune cle legacy publique")
	_expect(global.relations.size() == 6, "six relations")
	for relation in global.relations: _expect(relation.has_all(["personnage_id", "etat_arc", "statut_relation", "confiance", "desir", "intimite", "secret", "dernier_evenement_majeur_id", "faits_utiles", "debug"]), "cles relation " + str(relation.personnage_id))
	_expect(lecture.obtenir_resume_relation("nico", state).desir == "NONE", "nico sans desir player")
	_expect(lecture.obtenir_resume_relation("inconnu", state).etat_arc == "INCONNU", "inconnu explicite")
	state.couple_state = "RECONQUEST_ACTIVE"; _expect(lecture.obtenir_resume_relation_centrale(state).statut_couple == "RECONQUETE", "couple ensemble projete")
	state.couple_state = "SEPARATION"; state.promises["marie_player_boxes_wednesday_1830"] = {"status": "ACTIVE"}; var central := lecture.obtenir_resume_relation_centrale(state)
	_expect(central.contrat_couple == "ABSENT" and central.relation_apres_separation == "INDETERMINE", "separation sans contrat actif")
	for jour in ["J01", "J11", "J14", "J17", "J21"]:
		state.current_day = jour; _expect(str(lecture.obtenir_resume_etat_narratif(state).acte_courant).begins_with("ACTE_"), "projection acte " + jour)
	var removed_before := state.snapshot(); state.traces["trace_removed"] = {"current_state": "REMOVED"}; _expect(not lecture.obtenir_resume_etat_narratif(state).traces_pertinentes_ids.has("TRACE_TRACE_REMOVED"), "trace retiree non restauree"); var after := state.snapshot(); lecture.obtenir_resume_etat_narratif(state); _expect(state.snapshot() == after, "lecture ne mute pas registres")
