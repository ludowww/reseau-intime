# 08 — Formats de données

## Objectif

Définir des formats JSON simples pour écrire, valider et charger le contenu narratif.

Les formats doivent rester lisibles par l’auteur et faciles à valider par des scripts.

## Character

```json
{
  "id": "mathilde",
  "display_name": "Mathilde",
  "role": "Interdit domestique et familial",
  "default_app": "messages",
  "variables": {
    "desire": 0,
    "loyalty": 50
  },
  "tags": ["family", "home", "seduction", "forbidden"]
}
```

## Conversation thread

```json
{
  "id": "thread_mathilde_private",
  "app": "messages",
  "type": "private",
  "participants": ["ludo", "mathilde"],
  "title": "Mathilde",
  "unlocked_from_chapter": 2
}
```

Types possibles :

```text
private
group
social_post
story
system
```

## Message

```json
{
  "id": "msg_mathilde_020",
  "thread_id": "thread_mathilde_private",
  "sender": "mathilde",
  "time_label": "23:18",
  "text": "Tu dors ?",
  "attachments": [],
  "conditions": {
    "chapter_min": 2,
    "flags_required": ["mathilde_sleeping_home"]
  },
  "choices": [
    {
      "id": "choice_goodnight",
      "text": "Oui, bonne nuit.",
      "effects": {
        "mathilde.desire": -1,
        "mathilde.loyalty": 1,
        "lie_score": -1
      },
      "next": "msg_mathilde_021a"
    },
    {
      "id": "choice_awake",
      "text": "Non. Pourquoi ?",
      "effects": {
        "mathilde.desire": 2,
        "lie_score": 1
      },
      "next": "msg_mathilde_021b"
    }
  ]
}
```

## Choice

Un choix doit éviter d’avoir trop d’effets. Maximum recommandé : 3 à 5 effets.

```json
{
  "id": "choice_show_interest",
  "text": "Tu sais très bien que tu joues avec le feu.",
  "tone": "ambiguous",
  "effects": {
    "mathilde.desire": 2,
    "mathilde.loyalty": -1,
    "lie_score": 1
  },
  "sets_flags": ["ludo_flirted_mathilde"],
  "next": "msg_mathilde_022_fire"
}
```

Tones possibles :

```text
neutral
tender
avoidant
truthful
ambiguous
flirty
jealous
controlling
confessional
```

## Visual content

```json
{
  "id": "photo_mathilde_home_01",
  "character": "mathilde",
  "tier": 2,
  "type": "photo",
  "source_app": "messages",
  "thread_id": "thread_mathilde_private",
  "asset_path": "res://assets/placeholders/photo_mathilde_tier2_placeholder.png",
  "context": "Mathilde dort chez Marie et écrit à Ludo depuis le salon.",
  "is_proof": true,
  "risk_level": 4,
  "unlock_conditions": {
    "mathilde.desire_min": 3,
    "mathilde.loyalty_min": 2
  },
  "effects_on_open": {
    "mathilde.desire": 1,
    "lie_score": 1
  },
  "can_delete": true,
  "can_capture": true,
  "can_be_discovered_by": ["marie", "pauline"]
}
```

## Notification

```json
{
  "id": "notif_pauline_photo_01",
  "app": "messages",
  "source": "pauline",
  "title": "Pauline vous a envoyé une photo",
  "body": "Ne réagis pas.",
  "priority": 80,
  "trigger_conditions": {
    "chapter": 4,
    "flags_required": ["party_at_pauline"]
  },
  "opens": "msg_pauline_party_012",
  "effects_on_open": {
    "pauline.interest": 1
  },
  "effects_on_ignore": {
    "pauline.control": -1
  }
}
```

## Social post

```json
{
  "id": "story_marie_nico_01",
  "app": "social",
  "type": "story",
  "author": "marie",
  "media": "res://assets/placeholders/story_marie_nico_tier1_placeholder.png",
  "caption": "Soirée tranquille ❤️",
  "reactions": [
    {
      "from": "nico",
      "emoji": "🔥",
      "visible_to_player": true
    }
  ],
  "effects_on_view": {
    "ludo_jealousy": 2,
    "nico.place_near_marie": 1
  }
}
```

## Route state

```json
{
  "chapter": 5,
  "dominant_route": "mathilde",
  "secondary_route": "nico",
  "threat": "marie_suspicion",
  "relationship_mode": "SECRET_AFFAIR"
}
```

## Ending

```json
{
  "id": "ending_mathilde_catastrophe",
  "title": "Pas elle",
  "mode": "SECRET_AFFAIR",
  "dominant_route": "mathilde",
  "requirements": {
    "mathilde.desire_min": 80,
    "lie_score_min": 60,
    "marie.lucidity_min": 70
  },
  "relationship_states": {
    "ludo_marie": "rupture_explosive",
    "ludo_mathilde": "intimacy_guilt",
    "marie_mathilde": "broken"
  },
  "last_message": {
    "from": "marie",
    "text": "Tu pouvais me faire du mal avec n’importe qui. Mais pas avec elle."
  }
}
```

## Flags

Les flags sont des événements discrets.

Exemples :

```text
mathilde_sleeping_home
party_at_pauline
ludo_flirted_mathilde
sandra_sent_deleted_photo
pauline_has_capture
marie_saw_notification
nico_reacted_to_marie_story
raphaelle_asked_for_clarity
```

## Convention de nommage

```text
msg_[character]_[context]_[number]
choice_[intent]
photo_[character]_[context]_[number]
video_[character]_[context]_[number]
story_[character]_[context]_[number]
ending_[route]_[name]
```

## Validation automatique souhaitée

Scripts futurs :

- vérifier les IDs uniques ;
- vérifier les `next` existants ;
- vérifier les variables autorisées ;
- vérifier les assets référencés ;
- vérifier les conditions ;
- vérifier que chaque contenu visuel a un contexte et un risque ;
- vérifier qu’aucun message ne référence un personnage inconnu.