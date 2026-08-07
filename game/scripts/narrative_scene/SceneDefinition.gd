extends RefCounted

class_name R8CSceneDefinition

const DurableMediaIdentifier := preload(
	"res://scripts/shared/DurableMediaIdentifier.gd"
)
const NATURES := ["SIGNATURE", "MODULAIRE"]
const FONCTIONS := ["RELATION", "OPPORTUNITE", "ECHO", "RESPIRATION"]
const POLITIQUES_UNICITE := ["UNIQUE", "REPETABLE"]
const PORTEES_MICRO_SIGNAL := ["LOCALE", "TEMPORAIRE", "DURABLE"]
const RECEPTIONS := ["NON_PERSISTANTE", "RECUE_INTERPRETEE", "LIMITE_EXPLICITE"]
const POLITIQUES_REVALIDATION := ["AVANT_PROPOSITION", "AVANT_PROPOSITION_ET_RESOLUTION"]

const CHAMPS_REQUIS := [
	"scene_id",
	"version_contrat",
	"nature",
	"fonction_principale",
	"participants_requis",
	"conditions_dures",
	"exclusions_dures",
	"contrat_temporel",
	"politique_unicite",
	"resolutions",
]
const CHAMPS_OPTIONNELS := [
	"titre_interne",
	"relation_ou_question_focale",
	"noyau_stable",
	"structure_id",
	"choix",
	"politique_non_resolution",
]
const CHAMPS_AUTORISES := CHAMPS_REQUIS + CHAMPS_OPTIONNELS
const CHAMPS_PARTICIPANT := ["personnage_id", "role"]
const CHAMPS_CONDITIONS := ["actes_compatibles", "evenements_requis"]
const CHAMPS_EXCLUSIONS := ["evenements_interdits"]
const CHAMPS_CONTRAT_TEMPOREL := [
	"date_debut",
	"date_fin",
	"heure_ouverture",
	"heure_fermeture",
	"duree_minutes",
	"revalidation",
]
const CHAMPS_CHOIX := ["choix_id", "formulation", "signal_emis", "resolution_ids"]
const CHAMPS_RESOLUTION := [
	"personnage_id",
	"portee_micro_signal",
	"signal_recu",
	"reception",
	"interpretation",
	"faits_relationnels",
	"convergence",
	"trace_temporaire",
	"durable_manifest",
]
const CHAMPS_TRACE_TEMPORAIRE := ["trace_id", "contenu"]
const CHAMPS_FAIT_RELATIONNEL := [
	"fait_id",
	"nature",
	"recu_par",
	"permission_future",
	"formulee_par",
]
const CHAMPS_POLITIQUE_NON_RESOLUTION := ["proposition_expire", "consequence_manquee"]
const CHAMPS_CONSEQUENCE_MANQUEE := ["personnage_id", "fait_relationnel"]
const CHAMPS_DURABLE_MANIFEST := [
	"binding", "facts", "knowledge", "traces", "promises", "obligations", "media_deliveries",
]
const CHAMPS_DURABLE_BINDING := ["sequence_id", "authored_version", "resolution_id"]
const CATEGORIES_DURABLES := ["facts", "knowledge", "traces", "promises", "obligations", "media_deliveries"]
const CHAMPS_DURABLE_FACT_RELATION := ["event_key", "scope", "personnage_id", "fact"]
const CHAMPS_DURABLE_FACT_CENTRALE := ["event_key", "scope", "fact"]
const CHAMPS_DURABLE_KNOWLEDGE := ["event_key", "effect", "knowledge_id", "subject_id", "holder_ids"]
const CHAMPS_DURABLE_TRACE_CREATE := [
	"event_key", "effect", "trace_id", "creator_id", "audience_ids", "controller_ids", "accessible_to_ids",
]
const CHAMPS_DURABLE_TRACE_ACCESS := ["event_key", "effect", "trace_id", "accessible_to_ids"]
const CHAMPS_DURABLE_TRACE_TERMINAL := ["event_key", "effect", "trace_id"]
const CHAMPS_DURABLE_PROMISE_CREATE := [
	"event_key", "effect", "promise_id", "author_id", "beneficiary_ids", "content_ref",
]
const CHAMPS_DURABLE_PROMISE_TERMINAL := ["event_key", "effect", "promise_id"]
const CHAMPS_DURABLE_OBLIGATION_CREATE := [
	"event_key", "effect", "obligation_id", "debtor_id", "beneficiary_ids", "kind",
]
const CHAMPS_DURABLE_OBLIGATION_TERMINAL := ["event_key", "effect", "obligation_id"]
const CHAMPS_DURABLE_MEDIA_CREATE := ["event_key", "effect", "media_id", "fictional_audience_ids"]
const CHAMPS_DURABLE_MEDIA_GRANT := [
	"event_key", "effect", "media_id", "diegetic_status", "fictional_audience_ids", "gallery_status",
]
const CHAMPS_DURABLE_MEDIA_TERMINAL := ["event_key", "effect", "media_id"]
const CHAMPS_DURABLE_FACT := ["fait_id", "nature", "recu_par", "permission_future", "formulee_par"]
const MAX_LONGUEUR_IDENTIFIANT_DURABLE := 96


static func declarer(donnees: Dictionary) -> Dictionary:
	var definition: Dictionary = donnees.duplicate(true)
	var erreur := valider(definition)
	return {
		"ok": erreur.is_empty(),
		"erreur": erreur,
		"definition": definition if erreur.is_empty() else {},
	}


static func valider(definition: Dictionary) -> String:
	for champ in CHAMPS_REQUIS:
		if not definition.has(champ):
			return "definition de scene: champ manquant: %s" % champ
	for champ in ["scene_id", "version_contrat"]:
		if not _chaine_non_vide(definition[champ]):
			return "definition de scene: %s doit etre une chaine non vide" % champ
	for champ in ["titre_interne", "relation_ou_question_focale", "noyau_stable", "structure_id"]:
		if definition.has(champ) and not _chaine_non_vide(definition[champ]):
			return "definition de scene: %s optionnel doit etre une chaine non vide" % champ
	if definition["nature"] not in NATURES:
		return "definition de scene: nature invalide"
	if definition["fonction_principale"] not in FONCTIONS:
		return "definition de scene: fonction principale hors prototype"
	if definition["politique_unicite"] not in POLITIQUES_UNICITE:
		return "definition de scene: politique d'unicite invalide"
	var erreur_participants := _valider_participants(definition["participants_requis"])
	if not erreur_participants.is_empty():
		return erreur_participants
	var erreur_conditions := _valider_conditions(definition)
	if not erreur_conditions.is_empty():
		return erreur_conditions
	var erreur_temps := _valider_contrat_temporel(definition["contrat_temporel"])
	if not erreur_temps.is_empty():
		return erreur_temps
	var erreur_resolutions := _valider_resolutions(definition)
	if not erreur_resolutions.is_empty():
		return erreur_resolutions
	var erreur_choix := _valider_choix(definition)
	if not erreur_choix.is_empty():
		return erreur_choix
	return _valider_politique_non_resolution(definition)


static func valider_fermee(definition: Dictionary) -> String:
	var erreur_champs := _valider_champs_fermes(definition)
	if not erreur_champs.is_empty():
		return erreur_champs
	return valider(definition)


static func _valider_champs_fermes(definition: Dictionary) -> String:
	var erreur := _refuser_champs_inconnus(definition, CHAMPS_AUTORISES, "definition")
	if not erreur.is_empty():
		return erreur
	var participants = definition.get("participants_requis")
	if typeof(participants) == TYPE_ARRAY:
		for participant in participants:
			if typeof(participant) == TYPE_DICTIONARY:
				erreur = _refuser_champs_inconnus(participant, CHAMPS_PARTICIPANT, "participant")
				if not erreur.is_empty():
					return erreur
	for bloc in [
		[definition.get("conditions_dures"), CHAMPS_CONDITIONS, "conditions_dures"],
		[definition.get("exclusions_dures"), CHAMPS_EXCLUSIONS, "exclusions_dures"],
		[definition.get("contrat_temporel"), CHAMPS_CONTRAT_TEMPOREL, "contrat_temporel"],
	]:
		if typeof(bloc[0]) == TYPE_DICTIONARY:
			erreur = _refuser_champs_inconnus(bloc[0], bloc[1], bloc[2])
			if not erreur.is_empty():
				return erreur
	var choix = definition.get("choix", [])
	if typeof(choix) == TYPE_ARRAY:
		for option in choix:
			if typeof(option) == TYPE_DICTIONARY:
				erreur = _refuser_champs_inconnus(option, CHAMPS_CHOIX, "choix")
				if not erreur.is_empty():
					return erreur
	var resolutions = definition.get("resolutions")
	if typeof(resolutions) == TYPE_DICTIONARY:
		for resolution in resolutions.values():
			if typeof(resolution) != TYPE_DICTIONARY:
				continue
			erreur = _refuser_champs_inconnus(resolution, CHAMPS_RESOLUTION, "resolution")
			if not erreur.is_empty():
				return erreur
			var trace = resolution.get("trace_temporaire")
			if typeof(trace) == TYPE_DICTIONARY:
				erreur = _refuser_champs_inconnus(trace, CHAMPS_TRACE_TEMPORAIRE, "trace_temporaire")
				if not erreur.is_empty():
					return erreur
			var faits = resolution.get("faits_relationnels", [])
			if typeof(faits) == TYPE_ARRAY:
				for fait in faits:
					if typeof(fait) == TYPE_DICTIONARY:
						erreur = _refuser_champs_inconnus(fait, CHAMPS_FAIT_RELATIONNEL, "fait_relationnel")
						if not erreur.is_empty():
							return erreur
			var manifeste = resolution.get("durable_manifest")
			if typeof(manifeste) == TYPE_DICTIONARY and not manifeste.is_empty():
				erreur = _valider_fermeture_manifeste_durable(manifeste)
				if not erreur.is_empty():
					return erreur
	var politique = definition.get("politique_non_resolution")
	if typeof(politique) == TYPE_DICTIONARY:
		erreur = _refuser_champs_inconnus(
			politique, CHAMPS_POLITIQUE_NON_RESOLUTION, "politique_non_resolution"
		)
		if not erreur.is_empty():
			return erreur
		var consequence = politique.get("consequence_manquee")
		if typeof(consequence) == TYPE_DICTIONARY:
			erreur = _refuser_champs_inconnus(
				consequence, CHAMPS_CONSEQUENCE_MANQUEE, "consequence_manquee"
			)
			if not erreur.is_empty():
				return erreur
			var fait_manque = consequence.get("fait_relationnel")
			if typeof(fait_manque) == TYPE_DICTIONARY:
				erreur = _refuser_champs_inconnus(
					fait_manque, CHAMPS_FAIT_RELATIONNEL, "fait_relationnel"
				)
				if not erreur.is_empty():
					return erreur
	return ""


static func _refuser_champs_inconnus(value: Dictionary, autorises: Array, contexte: String) -> String:
	for champ in value:
		if champ not in autorises:
			return "definition de scene: %s contient un champ inconnu: %s" % [contexte, champ]
	return ""


static func _valider_participants(participants) -> String:
	if typeof(participants) != TYPE_ARRAY or participants.is_empty():
		return "definition de scene: participants_requis doit etre un tableau non vide"
	var identifiants := {}
	for participant in participants:
		if typeof(participant) != TYPE_DICTIONARY:
			return "definition de scene: participant invalide"
		var personnage_id = participant.get("personnage_id")
		if not _chaine_non_vide(personnage_id) or not _chaine_non_vide(participant.get("role")):
			return "definition de scene: participant incomplet"
		if identifiants.has(personnage_id):
			return "definition de scene: participant duplique"
		identifiants[personnage_id] = true
	return ""


static func _valider_conditions(definition: Dictionary) -> String:
	var conditions = definition["conditions_dures"]
	if typeof(conditions) != TYPE_DICTIONARY:
		return "definition de scene: conditions_dures doit etre un dictionnaire"
	for champ in ["actes_compatibles", "evenements_requis"]:
		if typeof(conditions.get(champ)) != TYPE_ARRAY:
			return "definition de scene: condition borne manquante: %s" % champ
	if conditions["actes_compatibles"].is_empty():
		return "definition de scene: au moins un acte compatible est requis"
	for valeur in conditions["actes_compatibles"] + conditions["evenements_requis"]:
		if not _chaine_non_vide(valeur):
			return "definition de scene: condition vide"
	var exclusions = definition["exclusions_dures"]
	if typeof(exclusions) != TYPE_DICTIONARY:
		return "definition de scene: exclusions_dures doit etre un dictionnaire"
	var interdits = exclusions.get("evenements_interdits")
	if typeof(interdits) != TYPE_ARRAY:
		return "definition de scene: evenements_interdits doit etre un tableau"
	for event_id in interdits:
		if not _chaine_non_vide(event_id):
			return "definition de scene: evenement interdit vide"
	return ""


static func _valider_contrat_temporel(contrat) -> String:
	if typeof(contrat) != TYPE_DICTIONARY:
		return "definition de scene: contrat_temporel doit etre un dictionnaire"
	for champ in ["date_debut", "date_fin", "heure_ouverture", "heure_fermeture"]:
		if not _chaine_non_vide(contrat.get(champ)):
			return "definition de scene: contrat temporel incomplet: %s" % champ
	if not _date_valide(contrat["date_debut"]) or not _date_valide(contrat["date_fin"]):
		return "definition de scene: date temporelle invalide"
	var ouverture := heure_en_minutes(contrat["heure_ouverture"])
	var fermeture := heure_en_minutes(contrat["heure_fermeture"])
	if ouverture < 0 or fermeture < 0:
		return "definition de scene: heure temporelle invalide"
	if contrat["date_debut"] > contrat["date_fin"] or ouverture >= fermeture:
		return "definition de scene: fenetre temporelle incoherente"
	var duree = contrat.get("duree_minutes")
	if typeof(duree) not in [TYPE_INT, TYPE_FLOAT] or duree <= 0 or float(duree) != floor(float(duree)):
		return "definition de scene: duree_minutes doit etre un entier positif"
	if contrat.get("revalidation") not in POLITIQUES_REVALIDATION:
		return "definition de scene: politique de revalidation invalide"
	return ""


static func _valider_resolutions(definition: Dictionary) -> String:
	var resolutions = definition["resolutions"]
	if typeof(resolutions) != TYPE_DICTIONARY:
		return "definition de scene: resolutions doit etre un dictionnaire"
	var participants := _identifiants_participants(definition["participants_requis"])
	for resolution_id in resolutions:
		if not _chaine_non_vide(resolution_id):
			return "definition de scene: resolution sans identifiant"
		var resolution = resolutions[resolution_id]
		if typeof(resolution) != TYPE_DICTIONARY:
			return "definition de scene: resolution invalide"
		if resolution.get("personnage_id") not in participants:
			return "definition de scene: consequence hors participants"
		var portee = resolution.get("portee_micro_signal")
		if portee not in PORTEES_MICRO_SIGNAL:
			return "definition de scene: portee de micro-signal invalide"
		var reception = resolution.get("reception")
		if reception not in RECEPTIONS:
			return "definition de scene: reception de micro-signal invalide"
		if not _chaine_non_vide(resolution.get("signal_recu")):
			return "definition de scene: signal recu manquant"
		if not _chaine_non_vide(resolution.get("interpretation")):
			return "definition de scene: interpretation manquante"
		if resolution.get("convergence") != "RETOUR_NOYAU_COMMUN":
			return "definition de scene: micro-branche non convergente"
		var faits = resolution.get("faits_relationnels", [])
		if typeof(faits) != TYPE_ARRAY:
			return "definition de scene: faits_relationnels doit etre un tableau"
		for fait in faits:
			if typeof(fait) != TYPE_DICTIONARY or not _chaine_non_vide(fait.get("fait_id")):
				return "definition de scene: fait relationnel invalide"
		if portee == "LOCALE" and reception != "NON_PERSISTANTE":
			return "definition de scene: signal local doit rester non persistant"
		if portee == "LOCALE" and not faits.is_empty():
			return "definition de scene: signal local ne peut pas ecrire de fait durable"
		if portee == "TEMPORAIRE":
			var trace = resolution.get("trace_temporaire")
			if typeof(trace) != TYPE_DICTIONARY or not _chaine_non_vide(trace.get("trace_id")):
				return "definition de scene: trace temporaire explicite requise"
			if not faits.is_empty():
				return "definition de scene: signal temporaire ne peut pas ecrire de fait durable"
		if portee == "DURABLE":
			if reception == "NON_PERSISTANTE" or faits.is_empty():
				return "definition de scene: durable exige reception, interpretation et fait explicites"
		var manifeste_durable = resolution.get("durable_manifest", {})
		var erreur_manifeste := _valider_manifeste_durable(manifeste_durable)
		if not erreur_manifeste.is_empty():
			return erreur_manifeste
		if portee != "DURABLE" and not manifeste_durable.is_empty():
			return "definition de scene: durable_manifest non vide interdit pour resolution locale"
	return ""


static func _valider_fermeture_manifeste_durable(manifeste: Dictionary) -> String:
	var erreur := _refuser_champs_inconnus(manifeste, CHAMPS_DURABLE_MANIFEST, "durable_manifest")
	if not erreur.is_empty():
		return erreur
	var binding = manifeste.get("binding")
	if typeof(binding) == TYPE_DICTIONARY:
		erreur = _refuser_champs_inconnus(binding, CHAMPS_DURABLE_BINDING, "durable_manifest.binding")
		if not erreur.is_empty():
			return erreur
	for categorie in CATEGORIES_DURABLES:
		var entrees = manifeste.get(categorie)
		if typeof(entrees) != TYPE_ARRAY:
			continue
		for entree in entrees:
			if typeof(entree) != TYPE_DICTIONARY:
				continue
			var champs := _champs_effet_durable(categorie, entree)
			if champs.is_empty():
				continue
			erreur = _refuser_champs_inconnus(entree, champs, "durable_manifest.%s" % categorie)
			if not erreur.is_empty():
				return erreur
			if categorie == "facts" and typeof(entree.get("fact")) == TYPE_DICTIONARY:
				erreur = _refuser_champs_inconnus(
					entree["fact"], CHAMPS_DURABLE_FACT, "durable_manifest.facts.fact"
				)
				if not erreur.is_empty():
					return erreur
	return ""


static func _valider_manifeste_durable(manifeste) -> String:
	if typeof(manifeste) != TYPE_DICTIONARY:
		return "definition de scene: durable_manifest doit etre un dictionnaire"
	if manifeste.is_empty():
		return ""
	if not _champs_exacts_durables(manifeste, CHAMPS_DURABLE_MANIFEST):
		return "definition de scene: durable_manifest incomplet"
	var binding = manifeste["binding"]
	if typeof(binding) != TYPE_DICTIONARY or not _champs_exacts_durables(binding, CHAMPS_DURABLE_BINDING):
		return "definition de scene: durable_manifest binding invalide"
	if not _identifiant_durable(binding["sequence_id"]):
		return "definition de scene: durable_manifest binding sequence invalide"
	if not _version_authored_durable(binding["authored_version"]):
		return "definition de scene: durable_manifest binding version invalide"
	if not _identifiant_durable(binding["resolution_id"]):
		return "definition de scene: durable_manifest binding resolution invalide"
	var event_keys := {}
	var nombre_effets := 0
	for categorie in CATEGORIES_DURABLES:
		var entrees = manifeste[categorie]
		if typeof(entrees) != TYPE_ARRAY:
			return "definition de scene: categorie durable doit etre un tableau: %s" % categorie
		var identifiants := {}
		for entree in entrees:
			nombre_effets += 1
			if typeof(entree) != TYPE_DICTIONARY:
				return "definition de scene: effet durable invalide: %s" % categorie
			var event_key = entree.get("event_key")
			if not _identifiant_durable(event_key):
				return "definition de scene: event_key durable vide"
			if event_keys.has(event_key):
				return "definition de scene: event_key durable duplique"
			event_keys[event_key] = true
			var erreur_effet := _valider_effet_durable(categorie, entree)
			if not erreur_effet.is_empty():
				return erreur_effet
			var identifiant = _identifiant_effet_durable(categorie, entree)
			var identifiant_valide := (
				_identifiant_media_durable(identifiant)
				if categorie == "media_deliveries"
				else _identifiant_durable(identifiant)
			)
			if not identifiant_valide:
				return "definition de scene: identifiant metier durable vide"
			if identifiants.has(identifiant):
				return "definition de scene: identifiant metier durable duplique"
			identifiants[identifiant] = true
	if nombre_effets == 0:
		return "definition de scene: durable_manifest sans effet"
	return ""


static func _valider_effet_durable(categorie: String, entree: Dictionary) -> String:
	var champs := _champs_effet_durable(categorie, entree)
	if champs.is_empty() or not _champs_exacts_durables(entree, champs):
		return "definition de scene: effet durable inconnu ou incoherent: %s" % categorie
	if categorie == "facts":
		return _valider_fait_durable(entree)
	if categorie == "knowledge":
		if entree["effect"] != "ACQUIRE" or not _identifiant_durable(entree.get("subject_id")):
			return "definition de scene: effet knowledge invalide"
		return _valider_tableau_identifiants_durables(entree.get("holder_ids"), true)
	if categorie == "traces":
		if entree["effect"] == "CREATE":
			if not _identifiant_durable(entree.get("creator_id")):
				return "definition de scene: create trace incomplet"
			for champ in ["audience_ids", "controller_ids", "accessible_to_ids"]:
				var erreur := _valider_tableau_identifiants_durables(entree.get(champ), false)
				if not erreur.is_empty():
					return erreur
		elif entree["effect"] in ["GRANT_ACCESS", "REVOKE_ACCESS"]:
			return _valider_tableau_identifiants_durables(entree.get("accessible_to_ids"), true)
		return ""
	if categorie == "promises":
		if entree["effect"] == "CREATE":
			if not _identifiant_durable(entree.get("author_id")) or not _chaine_durable(entree.get("content_ref")):
				return "definition de scene: create promise incomplet"
			return _valider_tableau_identifiants_durables(entree.get("beneficiary_ids"), true)
		return ""
	if categorie == "obligations":
		if entree["effect"] in ["CREATE_DUE", "CREATE_PAID", "CREATE_FAILED"]:
			if not _identifiant_durable(entree.get("debtor_id")) or not _chaine_durable(entree.get("kind")):
				return "definition de scene: create obligation incomplete"
			return _valider_tableau_identifiants_durables(entree.get("beneficiary_ids"), true)
		return ""
	if categorie == "media_deliveries":
		if entree["effect"] in ["CREATE_DIEGETIC", "GRANT_ACCESS"]:
			var erreur := _valider_tableau_identifiants_durables(entree.get("fictional_audience_ids"), false)
			if not erreur.is_empty():
				return erreur
		if entree["effect"] == "GRANT_ACCESS" and (
			entree.get("diegetic_status") not in ["NOT_APPLICABLE", "CREATED"]
			or entree.get("gallery_status") not in ["HIDDEN", "AVAILABLE"]
		):
			return "definition de scene: grant access media invalide"
	return ""


static func _champs_effet_durable(categorie: String, entree: Dictionary) -> Array:
	if categorie == "facts":
		if entree.get("scope") == "RELATION":
			return CHAMPS_DURABLE_FACT_RELATION
		if entree.get("scope") == "RELATION_CENTRALE":
			return CHAMPS_DURABLE_FACT_CENTRALE
		return []
	var effet = entree.get("effect")
	if categorie == "knowledge":
		return CHAMPS_DURABLE_KNOWLEDGE if effet == "ACQUIRE" else []
	if categorie == "traces":
		if effet == "CREATE":
			return CHAMPS_DURABLE_TRACE_CREATE
		if effet in ["GRANT_ACCESS", "REVOKE_ACCESS"]:
			return CHAMPS_DURABLE_TRACE_ACCESS
		return CHAMPS_DURABLE_TRACE_TERMINAL if effet == "WITHDRAW" else []
	if categorie == "promises":
		return CHAMPS_DURABLE_PROMISE_CREATE if effet == "CREATE" else (
			CHAMPS_DURABLE_PROMISE_TERMINAL if effet in ["PAY", "FAIL"] else []
		)
	if categorie == "obligations":
		return CHAMPS_DURABLE_OBLIGATION_CREATE if effet in ["CREATE_DUE", "CREATE_PAID", "CREATE_FAILED"] else (
			CHAMPS_DURABLE_OBLIGATION_TERMINAL if effet in ["PAY", "FAIL"] else []
		)
	if categorie == "media_deliveries":
		if effet == "CREATE_DIEGETIC":
			return CHAMPS_DURABLE_MEDIA_CREATE
		if effet == "GRANT_ACCESS":
			return CHAMPS_DURABLE_MEDIA_GRANT
		return CHAMPS_DURABLE_MEDIA_TERMINAL if effet in ["REVOKE_ACCESS", "WITHDRAW"] else []
	return []


static func _valider_fait_durable(entree: Dictionary) -> String:
	if entree["scope"] == "RELATION":
		if not _identifiant_durable(entree.get("personnage_id")):
			return "definition de scene: personnage_id requis pour RELATION"
	elif entree.has("personnage_id"):
		return "definition de scene: personnage_id interdit pour RELATION_CENTRALE"
	var fait = entree.get("fact")
	if typeof(fait) != TYPE_DICTIONARY or not _champs_autorises_durables(fait, CHAMPS_DURABLE_FACT):
		return "definition de scene: forme de fait durable incoherente"
	if not _identifiant_durable(fait.get("fait_id")):
		return "definition de scene: fait durable sans identifiant"
	for champ in fait:
		if champ == "permission_future":
			if typeof(fait[champ]) != TYPE_BOOL:
				return "definition de scene: permission_future durable invalide"
		elif not _chaine_durable(fait[champ]):
			return "definition de scene: champ de fait durable vide"
	return ""


static func _identifiant_effet_durable(categorie: String, entree: Dictionary):
	if categorie == "facts":
		var fait = entree.get("fact")
		return fait.get("fait_id") if typeof(fait) == TYPE_DICTIONARY else null
	var champs := {
		"knowledge": "knowledge_id", "traces": "trace_id", "promises": "promise_id",
		"obligations": "obligation_id", "media_deliveries": "media_id",
	}
	return entree.get(champs.get(categorie, ""))


static func _valider_tableau_identifiants_durables(value, non_vide: bool) -> String:
	if typeof(value) != TYPE_ARRAY or (non_vide and value.is_empty()):
		return "definition de scene: tableau d'identifiants durable invalide"
	var vus := {}
	for identifiant in value:
		if not _identifiant_durable(identifiant) or vus.has(identifiant):
			return "definition de scene: tableau d'identifiants durable invalide"
		vus[identifiant] = true
	return ""


static func _champs_exacts_durables(value: Dictionary, attendus: Array) -> bool:
	return value.size() == attendus.size() and _champs_autorises_durables(value, attendus)


static func _champs_autorises_durables(value: Dictionary, autorises: Array) -> bool:
	for champ in value:
		if champ not in autorises:
			return false
	return true


static func _identifiant_durable(value) -> bool:
	if (
		typeof(value) != TYPE_STRING
		or value.is_empty()
		or value.length() > MAX_LONGUEUR_IDENTIFIANT_DURABLE
		or value != value.strip_edges()
	):
		return false
	for index in value.length():
		if value.substr(index, 1) not in "abcdefghijklmnopqrstuvwxyz0123456789_":
			return false
	var morceaux: PackedStringArray = value.to_lower().split("_", false)
	for index in morceaux.size():
		var morceau: String = morceaux[index]
		if morceau.length() == 3 and morceau.begins_with("j") and morceau.substr(1, 2).is_valid_int():
			return false
		if morceau == "chapter" and index + 1 < morceaux.size():
			var numero: String = morceaux[index + 1]
			if numero.length() == 2 and numero.is_valid_int():
				return false
	return true


static func _identifiant_media_durable(value) -> bool:
	return DurableMediaIdentifier.validate(value)


static func _chaine_durable(value) -> bool:
	return (
		typeof(value) == TYPE_STRING
		and not value.is_empty()
		and value.length() <= 512
		and value == value.strip_edges()
	)


static func _version_authored_durable(value) -> bool:
	if typeof(value) != TYPE_STRING:
		return false
	var morceaux: PackedStringArray = value.split(".", false)
	if morceaux.size() != 3:
		return false
	for morceau in morceaux:
		if not morceau.is_valid_int() or int(morceau) < 0 or (morceau.length() > 1 and morceau.begins_with("0")):
			return false
	return true


static func _valider_choix(definition: Dictionary) -> String:
	var choix = definition.get("choix", [])
	if typeof(choix) != TYPE_ARRAY or choix.size() > 3:
		return "definition de scene: zero a trois choix ecrits sont autorises"
	if choix.is_empty() and not definition["resolutions"].is_empty():
		return "definition de scene: resolutions orphelines sans choix"
	var choix_ids := {}
	var resolutions_referencees := {}
	for option in choix:
		if typeof(option) != TYPE_DICTIONARY:
			return "definition de scene: choix invalide"
		var choix_id = option.get("choix_id")
		if not _chaine_non_vide(choix_id) or not _chaine_non_vide(option.get("formulation")):
			return "definition de scene: choix incomplet"
		if not _chaine_non_vide(option.get("signal_emis")):
			return "definition de scene: choix sans signal emis"
		if choix_ids.has(choix_id):
			return "definition de scene: choix duplique"
		choix_ids[choix_id] = true
		var resolution_ids = option.get("resolution_ids")
		if typeof(resolution_ids) != TYPE_ARRAY or resolution_ids.is_empty():
			return "definition de scene: choix sans resolution"
		for resolution_id in resolution_ids:
			if not definition["resolutions"].has(resolution_id):
				return "definition de scene: choix vers resolution inconnue"
			if definition["resolutions"][resolution_id].get("signal_recu") != option["signal_emis"]:
				return "definition de scene: signal emis et signal recu incoherents"
			resolutions_referencees[resolution_id] = true
	if resolutions_referencees.size() != definition["resolutions"].size():
		return "definition de scene: resolution orpheline non consommee"
	return ""


static func _valider_politique_non_resolution(definition: Dictionary) -> String:
	if not definition.has("politique_non_resolution"):
		return ""
	var politique = definition["politique_non_resolution"]
	if typeof(politique) != TYPE_DICTIONARY:
		return "definition de scene: politique_non_resolution doit etre un dictionnaire"
	for champ in politique:
		if champ not in ["proposition_expire", "consequence_manquee"]:
			return "definition de scene: politique_non_resolution contient un champ non consomme"
	if politique.get("proposition_expire") not in ["MISSED", "CANCELLED"]:
		return "definition de scene: statut d'expiration invalide"
	var consequence = politique.get("consequence_manquee")
	if consequence != null:
		if typeof(consequence) != TYPE_DICTIONARY:
			return "definition de scene: consequence manquee invalide"
		if consequence.get("personnage_id") not in _identifiants_participants(definition["participants_requis"]):
			return "definition de scene: consequence manquee hors participants"
		var fait = consequence.get("fait_relationnel")
		if typeof(fait) != TYPE_DICTIONARY or not _chaine_non_vide(fait.get("fait_id")):
			return "definition de scene: fait manque invalide"
	return ""


static func heure_en_minutes(heure) -> int:
	if typeof(heure) != TYPE_STRING:
		return -1
	var morceaux: PackedStringArray = heure.split(":")
	if morceaux.size() != 2 or morceaux[0].length() != 2 or morceaux[1].length() != 2:
		return -1
	if not morceaux[0].is_valid_int() or not morceaux[1].is_valid_int():
		return -1
	var heures := int(morceaux[0])
	var minutes := int(morceaux[1])
	if heures < 0 or heures > 23 or minutes < 0 or minutes > 59:
		return -1
	return heures * 60 + minutes


static func moment_valide(moment) -> bool:
	return (
		typeof(moment) == TYPE_STRING
		and moment.length() >= 16
		and moment.substr(10, 1) == "T"
		and _date_valide(moment.substr(0, 10))
		and heure_en_minutes(moment.substr(11, 5)) >= 0
	)


static func moment_normalise_valide(moment) -> bool:
	if typeof(moment) != TYPE_STRING or moment.length() != 25 or not moment_valide(moment):
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


static func meme_offset(premier: String, second: String) -> bool:
	return moment_normalise_valide(premier) and moment_normalise_valide(second) and premier.substr(19, 6) == second.substr(19, 6)


static func _date_valide(date) -> bool:
	if typeof(date) != TYPE_STRING or date.length() != 10:
		return false
	var morceaux: PackedStringArray = date.split("-")
	if morceaux.size() != 3 or morceaux[0].length() != 4 or morceaux[1].length() != 2 or morceaux[2].length() != 2:
		return false
	for morceau in morceaux:
		if not morceau.is_valid_int():
			return false
	var annee := int(morceaux[0])
	var mois := int(morceaux[1])
	var jour := int(morceaux[2])
	if annee < 1 or mois < 1 or mois > 12:
		return false
	var jours := [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
	if mois == 2 and (annee % 400 == 0 or (annee % 4 == 0 and annee % 100 != 0)):
		jours[1] = 29
	return jour >= 1 and jour <= jours[mois - 1]


static func _identifiants_participants(participants: Array) -> Array:
	var identifiants := []
	for participant in participants:
		identifiants.append(participant["personnage_id"])
	return identifiants


static func _chaine_non_vide(valeur) -> bool:
	return typeof(valeur) == TYPE_STRING and not valeur.strip_edges().is_empty()
