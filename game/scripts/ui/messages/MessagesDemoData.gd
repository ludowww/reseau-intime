extends RefCounted

class_name MessagesDemoData

# Local presentation-only fixtures. Every visible line is fictional and non-canonical.
# CharacterPresentation, ConversationThreadPresentation, MessagePresentation,
# and ChoicePresentation follow docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md.

static func build() -> Dictionary:
	var characters := {
		"marie": _character("marie", "Marie", "#4F8BFF", "M"),
		"sandra": _character("sandra", "Sandra", "#20C7C9", "S"),
		"player": _character("player", "Player", "#8D63E6", "P"),
		"group": _character("group", "Groupe", "#B274F4", "G"),
	}
	var threads: Array[Dictionary] = [
		{
			"thread_id": "demo_private_marie",
			"title": "Marie",
			"participant_ids": ["marie", "player"],
			"last_preview": "Un aperçu fictif assez long pour vérifier son retour à la ligne sans couper le texte.",
			"last_timestamp": "21:14",
			"unread_count": 2,
			"availability_state": "AVAILABLE",
			"is_group": false,
			"is_archived": false,
			"avatar_ref": "M",
			"accent_color": "#4F8BFF",
		},
		{
			"thread_id": "demo_group_verriere",
			"title": "Le groupe de la Verrière",
			"participant_ids": ["marie", "sandra", "player"],
			"last_preview": "Échange collectif fictif pour tester des auteurs distincts.",
			"last_timestamp": "20:48",
			"unread_count": 1,
			"availability_state": "AVAILABLE",
			"is_group": true,
			"is_archived": false,
			"avatar_ref": "G",
			"accent_color": "#B274F4",
		},
	]
	var messages_by_thread := {
		"demo_private_marie": [
			_message("demo_m_01", "marie", "21:08", "Texte de démonstration non canonique : ce fil sert uniquement à vérifier la lecture d’une bulle courte.", false),
			_message("demo_m_02", "player", "21:10", "Réponse fictive déjà présente pour vérifier l’alignement constant du Player à droite.", true),
			_message("demo_m_03", "marie", "21:14", "Long message de démonstration hors récit : il doit s’envelopper naturellement, rester entièrement lisible et ne jamais passer sous la zone fixe des choix, même dans une fenêtre portrait étroite.", false),
		],
		"demo_group_verriere": [
			_message("demo_g_01", "sandra", "20:45", "Message collectif fictif de Sandra pour vérifier le nom et l’accent de l’autrice.", false),
			_message("demo_g_02", "marie", "20:48", "Second message de groupe non canonique avec une autrice différente.", false),
		],
	}
	for index in range(4, 11):
		messages_by_thread["demo_private_marie"].append(
			_message(
				"demo_m_%02d" % index,
				"marie" if index % 2 == 0 else "player",
				"21:%02d" % (14 + index),
				"Message supplémentaire non canonique pour vérifier un historique long, son défilement vertical et la reprise exacte de la position de lecture.",
				index % 2 != 0,
			)
		)
	var choices_by_thread := {
		"demo_private_marie": [
			_choice("demo_choice_01", "Réponse factice courte."),
			_choice("demo_choice_02", "Réponse de démonstration volontairement longue afin de vérifier que le bouton s’agrandit et enveloppe tout son texte sans masquer le dernier message."),
			_choice("demo_choice_03", "Autre réponse fictive."),
		],
		"demo_group_verriere": [
			_choice("demo_choice_group_01", "Réponse collective factice."),
		],
	}
	return {
		"characters": characters,
		"threads": threads,
		"messages_by_thread": messages_by_thread,
		"choices_by_thread": choices_by_thread,
	}

static func _character(character_id: String, display_name: String, accent_color: String, avatar_ref: String) -> Dictionary:
	return {
		"character_id": character_id,
		"display_name": display_name,
		"accent_color": accent_color,
		"avatar_ref": avatar_ref,
		"gallery_enabled": false,
	}

static func _message(message_id: String, author_id: String, timestamp: String, text: String, is_player: bool) -> Dictionary:
	return {
		"message_id": message_id,
		"author_id": author_id,
		"timestamp": timestamp,
		"content_type": "TEXT",
		"text": text,
		"media_ref": "",
		"is_player": is_player,
		"is_read": true,
		"source_day": 0,
	}

static func _choice(choice_id: String, text: String) -> Dictionary:
	return {
		"choice_id": choice_id,
		"text": text,
		"enabled": true,
		"confirmation_required": false,
	}
