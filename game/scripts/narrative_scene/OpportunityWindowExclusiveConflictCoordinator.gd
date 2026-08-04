extends RefCounted

class_name R8COpportunityWindowExclusiveConflictCoordinator

const DefinitionModele := preload("res://scripts/narrative_scene/SceneDefinition.gd")
const CoordinateurA7Modele := preload("res://scripts/narrative_scene/CandidateReservationProposalCoordinator.gd")
const InstanceModele := preload("res://scripts/narrative_scene/SceneInstance.gd")

const CLOSE_SILENTLY := "CLOSE_SILENTLY"
const MARK_MISSED_IF_PROPOSED := "MARK_MISSED_IF_PROPOSED"
const DEFER := "DEFER"
const POLITIQUES_CONFLIT := [CLOSE_SILENTLY, MARK_MISSED_IF_PROPOSED, DEFER]

const OPEN := "OPEN"
const CLOSED := "CLOSED"
const CANDIDATE := "CANDIDATE"
const RESERVED := "RESERVED"
const PROPOSED := "PROPOSED"
const NOT_SELECTED := "NOT_SELECTED"
const MISSED := "MISSED"
const CANCELLED := "CANCELLED"
const DEFERRED := "DEFERRED"

const CHAMPS_FENETRE := ["window_id", "opens_at", "closes_at", "context", "options"]
const CHAMPS_CONTEXTE_FENETRE := [
	"acte_courant",
	"participants_disponibles",
	"opportunite_valide",
]
const CHAMPS_CONTEXTE_ACTION := [
	"acte_courant",
	"participants_disponibles",
	"opportunite_valide",
	"moment_diegetique",
]
const CHAMPS_OPTION := [
	"option_id",
	"scene_definition_id",
	"variant_id",
	"instance_id",
	"conflict_policy",
]
const MAX_WINDOWS := 64
const MAX_OPTIONS := 32
const MAX_PARTICIPANTS := 32

var _bibliotheque
var _moteur
var _coordinateur_a7
var _fenetres: Dictionary = {}
var _proprietaires_instance: Dictionary = {}


static func creer(bibliotheque, moteur, coordinateur_a7):
	if (
		bibliotheque == null
		or typeof(bibliotheque) != TYPE_OBJECT
		or not bibliotheque.has_method("query_candidates")
		or not bibliotheque.has_method("verifier_candidat_action")
		or moteur == null
		or typeof(moteur) != TYPE_OBJECT
		or not moteur.has_method("evaluer_definition")
		or not moteur.has_method("obtenir_instance")
		or coordinateur_a7 == null
		or typeof(coordinateur_a7) != TYPE_OBJECT
		or not coordinateur_a7.has_method("executer")
		or not coordinateur_a7.has_method("executer_dev")
	):
		return null
	var coordinateur := new()
	coordinateur._bibliotheque = bibliotheque
	coordinateur._moteur = moteur
	coordinateur._coordinateur_a7 = coordinateur_a7
	return coordinateur


func ouvrir_fenetre(
	specification,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	return _ouvrir_fenetre(specification, etat_narratif, contexte, false)


func ouvrir_fenetre_dev(
	specification,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	if not _diagnostics_detailles_autorises():
		return {"ok": false, "erreur": "DIAGNOSTICS_INDISPONIBLES"}
	return _ouvrir_fenetre(specification, etat_narratif, contexte, true)


func agir_sur_option(
	window_id: String,
	option_id: String,
	etat_narratif,
	contexte: Dictionary,
	intention: String
) -> Dictionary:
	return _agir_sur_option(window_id, option_id, etat_narratif, contexte, intention, false)


func agir_sur_option_dev(
	window_id: String,
	option_id: String,
	etat_narratif,
	contexte: Dictionary,
	intention: String
) -> Dictionary:
	if not _diagnostics_detailles_autorises():
		return {"ok": false, "erreur": "DIAGNOSTICS_INDISPONIBLES"}
	return _agir_sur_option(window_id, option_id, etat_narratif, contexte, intention, true)


func fermer_conflit_exclusif(
	window_id: String,
	option_id_retenue: String,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	return _fermer_conflit_exclusif(
		window_id,
		option_id_retenue,
		etat_narratif,
		contexte,
		false,
	)


func fermer_conflit_exclusif_dev(
	window_id: String,
	option_id_retenue: String,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	if not _diagnostics_detailles_autorises():
		return {"ok": false, "erreur": "DIAGNOSTICS_INDISPONIBLES"}
	return _fermer_conflit_exclusif(
		window_id,
		option_id_retenue,
		etat_narratif,
		contexte,
		true,
	)


func reevaluer_option_differee(
	window_id: String,
	option_id: String,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	if not _identifiant_valide(window_id) or not _identifiant_valide(option_id):
		return _echec("IDENTITE_ACTION_INVALIDE", false)
	var fenetre = _fenetres.get(window_id)
	if fenetre == null:
		return _echec("FENETRE_INCONNUE", false)
	var erreur_contexte := _valider_liaison_contexte(fenetre, contexte)
	if not erreur_contexte.is_empty():
		return _echec(erreur_contexte, false)
	var option = fenetre["options_par_id"].get(option_id)
	if option == null or option["state"] != DEFERRED:
		return _echec("OPTION_NON_DIFFEREE", false)
	if not _option_appartient(window_id, option):
		return _echec("PROPRIETE_INSTANCE_INCOHERENTE", false)
	if _moteur.obtenir_instance(option["instance_id"]) != null:
		return _echec("INSTANCE_A5_INATTENDUE", false)
	var verification: Dictionary = _bibliotheque.verifier_candidat_action(
		option["candidat"],
		option["contexte_candidat"],
	)
	if not verification["ok"]:
		return _echec(verification["erreur"], false)
	var diagnostic: Dictionary = _moteur.evaluer_definition(
		verification["definition"],
		etat_narratif,
		_option_contexte(option, contexte),
	)
	return {
		"ok": true,
		"erreur": "",
		"window_id": window_id,
		"option_id": option_id,
		"state": DEFERRED,
		"reevaluable": true,
		"eligible": diagnostic.get("eligible", false),
		"materialized": false,
		"descriptor": {
			"source_window_id": window_id,
			"source_option_id": option_id,
			"scene_definition_id": option["scene_definition_id"],
			"variant_id": option["variant_id"],
			"conflict_policy": option["conflict_policy"],
		},
	}


func obtenir_fenetre(window_id: String) -> Dictionary:
	var fenetre = _fenetres.get(window_id)
	return {} if fenetre == null else _resume_fenetre(fenetre)


func abandonner_fenetre_non_materialisee(window_id: String) -> Dictionary:
	if not _identifiant_valide(window_id):
		return _echec("WINDOW_ID_INVALIDE", false)
	var fenetre = _fenetres.get(window_id)
	if fenetre == null:
		return _echec("FENETRE_INCONNUE", false)
	if fenetre["state"] != OPEN or not fenetre["selected_option_id"].is_empty():
		return _echec("FENETRE_NON_ABANDONNABLE", false)
	for option_id in fenetre["options_par_id"]:
		var option: Dictionary = fenetre["options_par_id"][option_id]
		if (
			option["state"] != CANDIDATE
			or _moteur.obtenir_instance(option["instance_id"]) != null
			or not _option_appartient(window_id, option)
		):
			return _echec("FENETRE_NON_ABANDONNABLE", false)
	for option_id in fenetre["options_par_id"]:
		var option: Dictionary = fenetre["options_par_id"][option_id]
		_proprietaires_instance.erase(option["instance_id"])
	_fenetres.erase(window_id)
	return {"ok": true, "erreur": "", "window_id": window_id}


func revalider_fenetre_planifiable(
	window_id: String,
	etat_narratif,
	contexte: Dictionary,
	debut_planifie: String,
	fin_planifiee: String
) -> Dictionary:
	return _revalider_fenetre_planifiable(
		window_id,
		etat_narratif,
		contexte,
		debut_planifie,
		fin_planifiee,
		false,
	)


func revalider_fenetre_planifiable_dev(
	window_id: String,
	etat_narratif,
	contexte: Dictionary,
	debut_planifie: String,
	fin_planifiee: String
) -> Dictionary:
	if not _diagnostics_detailles_autorises():
		return {"ok": false, "erreur": "DIAGNOSTICS_INDISPONIBLES"}
	return _revalider_fenetre_planifiable(
		window_id,
		etat_narratif,
		contexte,
		debut_planifie,
		fin_planifiee,
		true,
	)


func _revalider_fenetre_planifiable(
	window_id: String,
	etat_narratif,
	contexte: Dictionary,
	debut_planifie: String,
	fin_planifiee: String,
	inclure_diagnostics: bool
) -> Dictionary:
	if not _identifiant_valide(window_id):
		return _echec("WINDOW_ID_INVALIDE", inclure_diagnostics)
	if (
		etat_narratif == null
		or typeof(etat_narratif) != TYPE_OBJECT
		or not etat_narratif.has_method("obtenir_snapshot")
	):
		return _echec("ETAT_NARRATIF_ABSENT", inclure_diagnostics)
	var fenetre = _fenetres.get(window_id)
	if fenetre == null:
		return _echec("FENETRE_INCONNUE", inclure_diagnostics)
	if fenetre["state"] != OPEN or not fenetre["selected_option_id"].is_empty():
		return _echec("ETAT_FENETRE_INCOMPATIBLE", inclure_diagnostics)
	var erreur_contexte := _valider_liaison_contexte(fenetre, contexte)
	if not erreur_contexte.is_empty():
		return _echec(erreur_contexte, inclure_diagnostics)
	if contexte["moment_diegetique"] < fenetre["opens_at"]:
		return _echec("FENETRE_NON_OUVERTE", inclure_diagnostics)
	if contexte["moment_diegetique"] >= fenetre["closes_at"]:
		return _echec("FENETRE_EXPIREE", inclure_diagnostics)
	if (
		not DefinitionModele.moment_normalise_valide(debut_planifie)
		or not DefinitionModele.moment_normalise_valide(fin_planifiee)
		or not DefinitionModele.meme_offset(fenetre["opens_at"], debut_planifie)
		or not DefinitionModele.meme_offset(fenetre["opens_at"], fin_planifiee)
		or debut_planifie < fenetre["opens_at"]
		or debut_planifie >= fin_planifiee
		or fin_planifiee > fenetre["closes_at"]
	):
		return _echec("BORNES_PLANIFIEES_HORS_FENETRE", inclure_diagnostics)
	if contexte["moment_diegetique"] > debut_planifie:
		return _echec("INSTANT_PLANIFIE_DEPASSE", inclure_diagnostics)
	var contexte_planifie := contexte.duplicate(true)
	contexte_planifie["moment_diegetique"] = debut_planifie
	for option_id in fenetre["options_par_id"]:
		var option: Dictionary = fenetre["options_par_id"][option_id]
		if option["state"] != CANDIDATE:
			return _echec("ETAT_OPTION_INCOMPATIBLE", inclure_diagnostics)
		if not _option_appartient(window_id, option):
			return _echec("PROPRIETE_INSTANCE_INCOHERENTE", inclure_diagnostics)
		if _moteur.obtenir_instance(option["instance_id"]) != null:
			return _echec("INSTANCE_A5_INATTENDUE", inclure_diagnostics)
		var charge: Dictionary = _charger_candidat(option, etat_narratif, contexte_planifie)
		if not charge["ok"]:
			return _echec(charge["erreur"], inclure_diagnostics)
	var resultat := {
		"ok": true,
		"erreur": "",
		"window": _resume_fenetre(fenetre),
		"window_fingerprint": _empreinte_fenetre(fenetre),
	}
	if inclure_diagnostics:
		resultat["diagnostic"] = {
			"code": "FENETRE_PLANIFIABLE_REVALIDEE",
			"debut_planifie": debut_planifie,
			"fin_planifiee": fin_planifiee,
			"options_revalidees": fenetre["options_par_id"].size(),
		}
	return resultat


func _ouvrir_fenetre(
	specification,
	etat_narratif,
	contexte: Dictionary,
	inclure_diagnostics: bool
) -> Dictionary:
	var erreur := _valider_specification(specification)
	if not erreur.is_empty():
		return _echec(erreur, inclure_diagnostics)
	var window_id: String = specification["window_id"]
	var existante = _fenetres.get(window_id)
	if existante != null:
		var erreur_contexte_existant := _valider_contexte_courant(existante, contexte)
		if not erreur_contexte_existant.is_empty():
			return _echec(erreur_contexte_existant, inclure_diagnostics)
		if existante["specification"] == specification:
			return _succes_fenetre(existante, true, inclure_diagnostics)
		return _echec("WINDOW_ID_DEJA_UTILISE", inclure_diagnostics)
	if _fenetres.size() >= MAX_WINDOWS:
		return _echec("LIMITE_FENETRES_ATTEINTE", inclure_diagnostics)
	var candidate_fenetre := {
		"specification": specification.duplicate(true),
		"window_id": window_id,
		"opens_at": specification["opens_at"],
		"closes_at": specification["closes_at"],
		"context": specification["context"].duplicate(true),
		"state": OPEN,
		"selected_option_id": "",
		"options_par_id": {},
	}
	var erreur_contexte := _valider_contexte_courant(candidate_fenetre, contexte)
	if not erreur_contexte.is_empty():
		return _echec(erreur_contexte, inclure_diagnostics)
	var options_candidates: Array = []
	for donnees_option in specification["options"]:
		var option: Dictionary = donnees_option.duplicate(true)
		if _proprietaires_instance.has(option["instance_id"]):
			return _echec("INSTANCE_ID_DEJA_ASSOCIE", inclure_diagnostics)
		if _moteur.obtenir_instance(option["instance_id"]) != null:
			return _echec("INSTANCE_A5_PREEXISTANTE", inclure_diagnostics)
		option["state"] = CANDIDATE
		option["candidat"] = {}
		option["contexte_candidat"] = {}
		option["definition"] = {}
		var charge: Dictionary = _charger_candidat(option, etat_narratif, contexte)
		if not charge["ok"]:
			return _echec(charge["erreur"], inclure_diagnostics)
		option["candidat"] = charge["candidat"]
		option["contexte_candidat"] = charge["contexte_candidat"]
		option["definition"] = charge["definition"]
		options_candidates.append(option)
	options_candidates.sort_custom(_option_avant)
	for option in options_candidates:
		candidate_fenetre["options_par_id"][option["option_id"]] = option
	_fenetres[window_id] = candidate_fenetre
	for option in options_candidates:
		_proprietaires_instance[option["instance_id"]] = {
			"window_id": window_id,
			"option_id": option["option_id"],
		}
	return _succes_fenetre(candidate_fenetre, false, inclure_diagnostics)


func _agir_sur_option(
	window_id: String,
	option_id: String,
	etat_narratif,
	contexte: Dictionary,
	intention: String,
	inclure_diagnostics: bool
) -> Dictionary:
	if not _identifiant_valide(window_id) or not _identifiant_valide(option_id):
		return _echec("IDENTITE_ACTION_INVALIDE", inclure_diagnostics)
	var fenetre = _fenetres.get(window_id)
	if fenetre == null:
		return _echec("FENETRE_INCONNUE", inclure_diagnostics)
	if fenetre["state"] != OPEN:
		return _echec("FENETRE_DEJA_FERMEE", inclure_diagnostics)
	var erreur_contexte := _valider_contexte_courant(fenetre, contexte)
	if not erreur_contexte.is_empty():
		return _echec(erreur_contexte, inclure_diagnostics)
	var option = fenetre["options_par_id"].get(option_id)
	if option == null:
		return _echec("OPTION_INCONNUE", inclure_diagnostics)
	if not _option_appartient(window_id, option):
		return _echec("PROPRIETE_INSTANCE_INCOHERENTE", inclure_diagnostics)
	if intention not in CoordinateurA7Modele.INTENTIONS:
		return _echec("INTENTION_INVALIDE", inclure_diagnostics)
	if option["state"] in [NOT_SELECTED, MISSED, CANCELLED]:
		return _echec("OPTION_TERMINALE", inclure_diagnostics)
	if (
		option["state"] in [CANDIDATE, DEFERRED]
		and _moteur.obtenir_instance(option["instance_id"]) != null
	):
		return _echec("INSTANCE_A5_INATTENDUE", inclure_diagnostics)
	if option["state"] == RESERVED and intention != CoordinateurA7Modele.RESERVE:
		return _echec("INTENTION_INCOMPATIBLE_AVEC_RESERVATION", inclure_diagnostics)
	if option["state"] == PROPOSED and intention != CoordinateurA7Modele.PROPOSE:
		return _echec("INTENTION_INCOMPATIBLE_AVEC_PROPOSITION", inclure_diagnostics)
	var charge: Dictionary = _charger_candidat(option, etat_narratif, contexte)
	if not charge["ok"]:
		return _echec(charge["erreur"], inclure_diagnostics)
	var action: Dictionary = (
		_coordinateur_a7.executer_dev(
			charge["candidat"], etat_narratif, charge["contexte_candidat"], intention
		)
		if inclure_diagnostics
		else _coordinateur_a7.executer(
			charge["candidat"], etat_narratif, charge["contexte_candidat"], intention
		)
	)
	if not action.get("ok", false):
		var code: String = action.get("diagnostic", {}).get("code", "ACTION_A7_REFUSEE")
		return _echec(code, inclure_diagnostics)
	option["candidat"] = charge["candidat"]
	option["contexte_candidat"] = charge["contexte_candidat"]
	option["definition"] = charge["definition"]
	option["state"] = RESERVED if intention == CoordinateurA7Modele.RESERVE else PROPOSED
	var resultat := {
		"ok": true,
		"erreur": "",
		"window_id": window_id,
		"option_id": option_id,
		"instance_id": option["instance_id"],
		"state": option["state"],
		"idempotent": action["idempotent"],
	}
	if inclure_diagnostics:
		resultat["diagnostic"] = {
			"code": "ACTION_OPTION_ACCEPTEE",
			"a7": action.get("diagnostic", {}).duplicate(true),
		}
	return resultat


func _fermer_conflit_exclusif(
	window_id: String,
	option_id_retenue: String,
	etat_narratif,
	contexte: Dictionary,
	inclure_diagnostics: bool
) -> Dictionary:
	if not _identifiant_valide(window_id) or not _identifiant_valide(option_id_retenue):
		return _echec("IDENTITE_FERMETURE_INVALIDE", inclure_diagnostics)
	var fenetre = _fenetres.get(window_id)
	if fenetre == null:
		return _echec("FENETRE_INCONNUE", inclure_diagnostics)
	if fenetre["state"] == CLOSED:
		if fenetre["selected_option_id"] == option_id_retenue:
			return _succes_fenetre(fenetre, true, inclure_diagnostics)
		return _echec("CONFLIT_DEJA_FERME_AUTRE_OPTION", inclure_diagnostics)
	var erreur_contexte := _valider_contexte_courant(fenetre, contexte)
	if not erreur_contexte.is_empty():
		return _echec(erreur_contexte, inclure_diagnostics)
	var retenue = fenetre["options_par_id"].get(option_id_retenue)
	if retenue == null:
		return _echec("OPTION_RETENUE_INCONNUE", inclure_diagnostics)
	if retenue["state"] not in [RESERVED, PROPOSED]:
		return _echec("OPTION_RETENUE_NON_MATERIALISEE", inclure_diagnostics)
	var preparation: Dictionary = _preparer_fermeture(
		fenetre,
		option_id_retenue,
		etat_narratif,
		contexte,
		inclure_diagnostics,
	)
	if not preparation["ok"]:
		return _echec(preparation["erreur"], inclure_diagnostics)
	for changement in preparation["changements"]:
		if not changement["transition"].is_empty():
			changement["instance"].appliquer_transition_preparee(changement["transition"])
		var option: Dictionary = fenetre["options_par_id"][changement["option_id"]]
		option["candidat"] = changement["candidat"]
		option["contexte_candidat"] = changement["contexte_candidat"]
		option["definition"] = changement["definition"]
		option["state"] = changement["cible"]
	fenetre["state"] = CLOSED
	fenetre["selected_option_id"] = option_id_retenue
	return _succes_fenetre(fenetre, false, inclure_diagnostics)


func _preparer_fermeture(
	fenetre: Dictionary,
	option_id_retenue: String,
	etat_narratif,
	contexte: Dictionary,
	inclure_diagnostics: bool
) -> Dictionary:
	var retenue: Dictionary = fenetre["options_par_id"][option_id_retenue]
	var changements: Array = []
	for option_id in fenetre["options_par_id"]:
		var option: Dictionary = fenetre["options_par_id"][option_id]
		if not _option_appartient(fenetre["window_id"], option):
			return {"ok": false, "erreur": "PROPRIETE_INSTANCE_INCOHERENTE"}
		if option["state"] in [NOT_SELECTED, MISSED, CANCELLED]:
			return {"ok": false, "erreur": "OPTION_DEJA_TERMINALE"}
		var instance = _moteur.obtenir_instance(option["instance_id"])
		if option["state"] in [CANDIDATE, DEFERRED] and instance != null:
			return {"ok": false, "erreur": "INSTANCE_A5_INATTENDUE"}
		var charge: Dictionary = _revalider_option_fermeture(
			option,
			retenue,
			etat_narratif,
			contexte,
		)
		if not charge["ok"]:
			return {"ok": false, "erreur": charge["erreur"]}
		if option["state"] in [RESERVED, PROPOSED]:
			var intention := (
				CoordinateurA7Modele.RESERVE
				if option["state"] == RESERVED
				else CoordinateurA7Modele.PROPOSE
			)
			var replay: Dictionary = (
				_coordinateur_a7.executer_dev(
					option["candidat"], etat_narratif, option["contexte_candidat"], intention
				)
				if inclure_diagnostics
				else _coordinateur_a7.executer(
					option["candidat"], etat_narratif, option["contexte_candidat"], intention
				)
			)
			if not replay.get("ok", false) or not replay.get("idempotent", false):
				return {"ok": false, "erreur": "REVALIDATION_A7_REFUSEE"}
			if (
				instance == null
				or instance.obtenir_statut() != replay["state"]
				or contexte["moment_diegetique"] < instance.obtenir_dernier_instant()
			):
				return {"ok": false, "erreur": "INSTANCE_A5_INCOHERENTE"}
		if option_id == option_id_retenue:
			changements.append(_changement_option(option, option["state"], charge, instance, {}))
			continue
		var cible := _cible_conflit(option)
		if cible.is_empty():
			return {"ok": false, "erreur": "POLITIQUE_INCOMPATIBLE_AVEC_ETAT"}
		var transition := {}
		if cible == MISSED:
			var politique: Dictionary = charge["definition"]["politique_non_resolution"]
			if politique["proposition_expire"] != InstanceModele.MISSED:
				return {"ok": false, "erreur": "POLITIQUE_A5_INCOMPATIBLE_AVEC_MISSED"}
			if politique.has("consequence_manquee"):
				return {"ok": false, "erreur": "CONSEQUENCE_MANQUEE_MULTI_TRANSACTION_NON_SUPPORTEE"}
			transition = _preparer_transition_conflit(instance, cible, contexte["moment_diegetique"])
		elif cible == CANCELLED:
			transition = _preparer_transition_conflit(instance, cible, contexte["moment_diegetique"])
		if not transition.is_empty() and not transition["ok"]:
			return {"ok": false, "erreur": "TRANSITION_CONFLIT_NON_PREPARABLE"}
		changements.append(_changement_option(option, cible, charge, instance, transition))
	return {"ok": true, "erreur": "", "changements": changements}


func _revalider_option_fermeture(
	option: Dictionary,
	retenue: Dictionary,
	etat_narratif,
	contexte: Dictionary
) -> Dictionary:
	var charge: Dictionary = _charger_candidat(option, etat_narratif, contexte)
	if charge["ok"] or charge["erreur"] != "OPTION_A6_INELIGIBLE":
		return charge
	if option["state"] not in [CANDIDATE, DEFERRED]:
		return charge
	var instance_retenue = _moteur.obtenir_instance(retenue["instance_id"])
	if (
		instance_retenue == null
		or option["scene_definition_id"] != retenue["scene_definition_id"]
		or instance_retenue.obtenir_scene_definition_id() != option["scene_definition_id"]
	):
		return charge
	var verification: Dictionary = _bibliotheque.verifier_candidat_action(
		option["candidat"],
		option["contexte_candidat"],
	)
	if not verification["ok"] or verification["definition"]["politique_unicite"] != "UNIQUE":
		return charge
	var diagnostic: Dictionary = _moteur.evaluer_definition(
		verification["definition"],
		etat_narratif,
		_option_contexte(option, contexte),
	)
	if diagnostic.get("raisons_ineligibilite", []) != ["SCENE_DEJA_RESOLUE_OU_INSTANCIEE"]:
		return charge
	return {
		"ok": true,
		"erreur": "",
		"candidat": option["candidat"].duplicate(true),
		"contexte_candidat": option["contexte_candidat"].duplicate(true),
		"definition": verification["definition"],
	}


func _preparer_transition_conflit(instance, cible: String, moment: String) -> Dictionary:
	if instance == null:
		return {"ok": false, "erreur": "INSTANCE_A5_ABSENTE"}
	var instance_id: String = instance.obtenir_instance_id()
	if cible == MISSED:
		return instance.preparer_transition(
			InstanceModele.MISSED,
			"CONFLIT_EXCLUSIF_PROPOSITION_VISIBLE",
			moment,
			{
				"operation": "MANQUEE",
				"transaction_id": "r8c-a3:%s:missed" % instance_id,
				"choix_id": "",
				"resolution_id": "opportunite_manquee",
				"portee_micro_signal": "LOCALE",
			},
		)
	return instance.preparer_transition(
		InstanceModele.CANCELLED,
		"CONFLIT_EXCLUSIF_RESERVATION_INTERNE",
		moment,
		{
			"operation": "ANNULATION",
			"transaction_id": "r8c-a3:%s:annulation:CONFLIT_EXCLUSIF_A8" % instance_id,
			"choix_id": "",
			"resolution_id": "",
		},
	)


static func _changement_option(
	option: Dictionary,
	cible: String,
	charge: Dictionary,
	instance,
	transition: Dictionary
) -> Dictionary:
	return {
		"option_id": option["option_id"],
		"cible": cible,
		"candidat": charge["candidat"].duplicate(true),
		"contexte_candidat": charge["contexte_candidat"].duplicate(true),
		"definition": charge["definition"].duplicate(true),
		"instance": instance,
		"transition": transition,
	}


func _cible_conflit(option: Dictionary) -> String:
	var politique: String = option["conflict_policy"]
	var state: String = option["state"]
	if politique == DEFER:
		return DEFERRED if state in [CANDIDATE, DEFERRED] else ""
	if politique == CLOSE_SILENTLY:
		if state in [CANDIDATE, DEFERRED]:
			return NOT_SELECTED
		if state == RESERVED:
			return CANCELLED
		return ""
	if politique == MARK_MISSED_IF_PROPOSED:
		if state == PROPOSED:
			return MISSED
		if state == RESERVED:
			return CANCELLED
		if state in [CANDIDATE, DEFERRED]:
			return NOT_SELECTED
	return ""


func _charger_candidat(option: Dictionary, etat_narratif, contexte: Dictionary) -> Dictionary:
	var contexte_candidat := _option_contexte(option, contexte)
	var requete: Dictionary = _bibliotheque.query_candidates(
		_moteur,
		etat_narratif,
		contexte_candidat,
	)
	if not requete.get("ok", false):
		return {"ok": false, "erreur": "REQUETE_A6_REFUSEE"}
	for candidat in requete["candidats"]:
		if (
			candidat["scene_definition_id"] == option["scene_definition_id"]
			and candidat["variant_id"] == option["variant_id"]
		):
			var verification: Dictionary = _bibliotheque.verifier_candidat_action(
				candidat,
				contexte_candidat,
			)
			if not verification["ok"]:
				return {"ok": false, "erreur": verification["erreur"]}
			return {
				"ok": true,
				"erreur": "",
				"candidat": candidat.duplicate(true),
				"contexte_candidat": contexte_candidat,
				"definition": verification["definition"],
			}
	return {"ok": false, "erreur": "OPTION_A6_INELIGIBLE"}


func _option_contexte(option: Dictionary, contexte: Dictionary) -> Dictionary:
	var resultat := contexte.duplicate(true)
	resultat["instance_id"] = option["instance_id"]
	return resultat


func _valider_specification(specification) -> String:
	if typeof(specification) != TYPE_DICTIONARY or not _cles_exactes(specification, CHAMPS_FENETRE):
		return "SPECIFICATION_FENETRE_INVALIDE"
	if not _identifiant_valide(specification["window_id"]):
		return "WINDOW_ID_INVALIDE"
	if (
		not DefinitionModele.moment_normalise_valide(specification["opens_at"])
		or not DefinitionModele.moment_normalise_valide(specification["closes_at"])
		or not DefinitionModele.meme_offset(specification["opens_at"], specification["closes_at"])
		or specification["opens_at"] >= specification["closes_at"]
	):
		return "BORNES_FENETRE_INVALIDES"
	if (
		typeof(specification["context"]) != TYPE_DICTIONARY
		or not _cles_exactes(specification["context"], CHAMPS_CONTEXTE_FENETRE)
		or not _contexte_base_valide(specification["context"])
	):
		return "CONTEXTE_FENETRE_INVALIDE"
	var options = specification["options"]
	if typeof(options) != TYPE_ARRAY or options.size() < 2 or options.size() > MAX_OPTIONS:
		return "OPTIONS_FENETRE_INVALIDES"
	var option_ids := {}
	var instance_ids := {}
	for option in options:
		if typeof(option) != TYPE_DICTIONARY or not _cles_exactes(option, CHAMPS_OPTION):
			return "OPTION_INVALIDE"
		for champ in ["option_id", "scene_definition_id", "variant_id", "instance_id"]:
			if not _identifiant_valide(option[champ]):
				return "IDENTITE_OPTION_INVALIDE"
		if option["conflict_policy"] not in POLITIQUES_CONFLIT:
			return "POLITIQUE_CONFLIT_INVALIDE"
		if option_ids.has(option["option_id"]):
			return "OPTION_ID_DUPLIQUE"
		if instance_ids.has(option["instance_id"]):
			return "INSTANCE_ID_DUPLIQUE_DANS_FENETRE"
		option_ids[option["option_id"]] = true
		instance_ids[option["instance_id"]] = true
	return ""


func _valider_contexte_courant(fenetre: Dictionary, contexte: Dictionary) -> String:
	var erreur_liaison := _valider_liaison_contexte(fenetre, contexte)
	if not erreur_liaison.is_empty():
		return erreur_liaison
	var moment: String = contexte["moment_diegetique"]
	if moment < fenetre["opens_at"] or moment >= fenetre["closes_at"]:
		return "FENETRE_EXPIREE_OU_NON_OUVERTE"
	return ""


func _valider_liaison_contexte(fenetre: Dictionary, contexte: Dictionary) -> String:
	if not _cles_exactes(contexte, CHAMPS_CONTEXTE_ACTION):
		return "CONTEXTE_ACTION_INVALIDE"
	if not _contexte_base_valide(contexte):
		return "CONTEXTE_ACTION_INVALIDE"
	var projection := {}
	for champ in CHAMPS_CONTEXTE_FENETRE:
		projection[champ] = contexte[champ]
	if projection != fenetre["context"]:
		return "CONTEXTE_FENETRE_CHANGE"
	var moment: String = contexte["moment_diegetique"]
	if (
		not DefinitionModele.moment_normalise_valide(moment)
		or not DefinitionModele.meme_offset(fenetre["opens_at"], moment)
	):
		return "INSTANT_ACTION_INVALIDE"
	return ""


static func _contexte_base_valide(contexte: Dictionary) -> bool:
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


func _resume_fenetre(fenetre: Dictionary) -> Dictionary:
	var options: Array = []
	for option_id in fenetre["options_par_id"]:
		var option: Dictionary = fenetre["options_par_id"][option_id]
		options.append({
			"option_id": option["option_id"],
			"scene_definition_id": option["scene_definition_id"],
			"variant_id": option["variant_id"],
			"instance_id": option["instance_id"],
			"conflict_policy": option["conflict_policy"],
			"state": option["state"],
			"materialized": _moteur.obtenir_instance(option["instance_id"]) != null,
		})
	options.sort_custom(_option_avant)
	return {
		"window_id": fenetre["window_id"],
		"opens_at": fenetre["opens_at"],
		"closes_at": fenetre["closes_at"],
		"state": fenetre["state"],
		"selected_option_id": fenetre["selected_option_id"],
		"options": options,
	}


func _succes_fenetre(
	fenetre: Dictionary,
	idempotente: bool,
	inclure_diagnostics: bool
) -> Dictionary:
	var resultat := {
		"ok": true,
		"erreur": "",
		"window": _resume_fenetre(fenetre),
		"idempotent": idempotente,
	}
	if inclure_diagnostics:
		resultat["diagnostic"] = {"code": "OPERATION_FENETRE_ACCEPTEE"}
	return resultat


func _echec(code: String, inclure_diagnostics: bool) -> Dictionary:
	var resultat := {"ok": false, "erreur": "OPERATION_FENETRE_REFUSEE"}
	if inclure_diagnostics:
		resultat["diagnostic"] = {"code": code}
	return resultat


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


func _option_appartient(window_id: String, option: Dictionary) -> bool:
	var proprietaire = _proprietaires_instance.get(option["instance_id"])
	return (
		typeof(proprietaire) == TYPE_DICTIONARY
		and proprietaire.get("window_id") == window_id
		and proprietaire.get("option_id") == option["option_id"]
	)


static func _option_avant(a: Dictionary, b: Dictionary) -> bool:
	return a["option_id"] < b["option_id"]


static func _empreinte_fenetre(fenetre: Dictionary) -> String:
	return JSON.stringify(fenetre["specification"], "", true, true).sha256_text()


static func _diagnostics_detailles_autorises() -> bool:
	return OS.is_debug_build() or Engine.is_editor_hint()
