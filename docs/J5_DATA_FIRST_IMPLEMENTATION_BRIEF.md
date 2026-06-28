# J5 — Brief d’implémentation data-first : lendemain, photos et premières preuves

## Statut

Brief opérationnel pour préparer l’intégration runtime/data-first de J5 sur :

```text
work/j5-data-first-after-party-proofs
```

Ce document ne remplace pas la fondation d’écriture J5. Il la traduit en patch court, testable et cohérent avec le J4 réellement intégré.

Références à respecter :

- `docs/J5_WRITING_FOUNDATION.md`
- `docs/J4_DIALOGUE_POLISH_NOTES.md`
- `docs/story_state/J3_SUMMARY.md`
- `docs/story_state/GLOBAL_STORY_STATE.md`
- `game/data/conversations/chapter_04_index.json`
- `game/data/visual_content/chapter_04_proofs.json`

## Fonction narrative J5

J5 est le lendemain de la soirée J4.

La soirée est finie physiquement, mais elle continue dans le téléphone :

```text
photos
stories
captures
messages relus
notifications différées
interprétations contradictoires
```

Question centrale :

```text
Qu’est-ce qu’une photo change quand elle revient le lendemain, hors de son contexte festif ?
```

J5 ne doit pas révéler tout. Il doit installer la sensation que :

```text
- toutes les photos n’ont pas été vues ;
- tout le monde n’a pas reçu les mêmes images ;
- une image peut rapprocher Player d’un personnage ;
- une image peut aussi devenir une preuve faible.
```

## État hérité de J4 runtime

Le J4 verrouillé produit les éléments suivants :

```text
Pauline a activé un canal privé rare avec Player.
Marie a été regardée avant la soirée et exposée au regard social.
Le groupe a reçu une photo de soirée.
Nico a complimenté / regardé Marie de façon socialement défendable.
Mathilde a observé le trouble de Player et rappelé la photo J3.
Sandra a écrit au mauvais moment depuis l’extérieur de la soirée.
Pauline a envoyé ou gardé une capture de Player regardant son téléphone.
```

IDs J4 à exploiter ou rappeler :

```text
photo_pauline_soft_provocation_j4_placeholder
photo_marie_evening_j4_placeholder
photo_party_group_j4_placeholder
capture_player_phone_party_j4_placeholder
photo_party_group_j4_received
photo_marie_evening_j4_received
mathilde_noticed_player_j4
sandra_bad_timing_j4
sandra_message_opened_during_party_j4
sandra_message_ignored_j4
pauline_saw_notification_j4
pauline_possible_capture_j4
pauline_own_secret_seed_j4
nico_complimented_marie_j4
```

Ne pas supposer que tous les flags existent pour toutes les routes. Si une condition n’est pas fiable ou pas déjà créée, préférer une variation textuelle non conditionnelle plutôt qu’une nouvelle logique complexe.

## Scope recommandé pour le patch J5

J5 data-first doit rester court et testable.

Créer ou remplacer :

```text
game/data/conversations/chapter_05_index.json
game/data/conversations/chapter_05_marie_morning.json
game/data/conversations/chapter_05_pauline_photos.json
game/data/conversations/chapter_05_social_story.json
game/data/conversations/chapter_05_mathilde_followup.json
game/data/conversations/chapter_05_sandra_later.json
game/data/conversations/chapter_05_raphaelle_boundary.json
game/data/conversations/chapter_05_pauline_last_photo.json
game/data/visual_content/chapter_05_proofs.json
```

Ajouter `chapter_05_index.json` dans `DataLoader.gd` seulement si le loader ne charge pas déjà J5.

Ajouter `chapter_05_proofs.json` dans les paths de visual content seulement si nécessaire.

Ne pas modifier J1/J2/J3/J4 runtime.

Ne pas intégrer J6.

## Structure J5 recommandée

### 1. Marie — Matin après soirée

Conversation :

```text
chapter_05_marie_morning
```

Fonction : Marie revient sur la soirée sans confrontation totale.

Tonalité :

```text
fatiguée
douce
lucide
un peu piquée
intime, pas uniquement jalouse
```

À faire sentir :

```text
Marie ne sait pas tout.
Mais elle sent que Player était parfois dans son téléphone.
Elle a peut-être remarqué Nico, Pauline ou Mathilde, mais ne fait pas encore d’accusation totale.
```

Choix recommandés :

```text
A — reconnaître qu’il était ailleurs
B — minimiser / fatigue
C — revenir vers Marie
D — être jaloux de Nico
```

Photo possible : `photo_marie_after_party_j5_placeholder` si Player revient vers Marie ou si la route Marie est nourrie.

### 2. Pauline — Les photos de soirée

Conversation :

```text
chapter_05_pauline_photos
```

Fonction : Pauline devient redistributrice des images.

Elle envoie une photo ou un mini-lot, mais garde aussi des choses.

Ton :

```text
piquant
joueur
fausse innocence
contrôle discret
```

Photo obligatoire :

```text
photo_party_after_j5_placeholder
```

La photo doit d’abord paraître amusante, puis devenir inquiétante quand Player regarde mieux.

Effet narratif : première preuve faible sociale.

### 3. Social / Nico — Marie visible autrement

Conversation :

```text
chapter_05_social_story
```

Fonction : faire revenir Nico via story, réaction ou photo, pas forcément par conversation privée.

Nico ne doit pas devenir un méchant. Il est le miroir de Player : il regarde Marie pendant que Player regarde ailleurs.

Visuel recommandé :

```text
story_marie_nico_j5_placeholder
```

Choix recommandés :

```text
A — laisser passer
B — réagir jaloux
C — revenir vers Marie plutôt que viser Nico
D — fouiller les photos
```

### 4. Mathilde — Follow-up photo / recul

Conversation :

```text
chapter_05_mathilde_followup
```

Fonction : faire revenir la photo J3/J4 comme secret actif.

Mathilde demande ou fait sentir :

```text
Tu l’as gardée ?
Tu l’as supprimée ?
Tu y as repensé ?
```

Tonalité :

```text
taquine
plus prudente que J4
provocante seulement si la route est nourrie
coupable dès que Marie redevient concrète
```

Photo conditionnelle possible :

```text
photo_mathilde_after_party_j5_placeholder
```

Garde-fou : ne pas la rendre frontale ou prédatrice. La tension vient de la trace, pas d’une demande explicite.

### 5. Sandra — Le “plus tard”

Conversation :

```text
chapter_05_sandra_later
```

Fonction : faire ressentir le coût émotionnel du mauvais timing J4.

Sandra comprend qu’elle existe dans une vie où elle n’a pas de place officielle.

Ton :

```text
doux
retenu
un peu blessé
fuyant
rare
```

Trace possible :

```text
sandra_almost_sent_photo_j5
```

Sandra peut mentionner une photo ou une image supprimée, mais ne doit pas forcément envoyer une vraie photo.

Garde-fou : elle ne doit pas devenir trop disponible.

### 6. Raphaëlle — Limite claire

Conversation :

```text
chapter_05_raphaelle_boundary
```

Fonction : contrepoint calme après le bruit social.

Raphaëlle n’était pas dans la soirée. Elle revient comme quelqu’un qui voit la fatigue, le flou ou la fuite.

Ton :

```text
sobre
calme
adulte
ferme
```

Elle peut écouter, mais refuse d’être une cachette.

Choix recommandés :

```text
A — reconnaître le flou
B — chercher un refuge
C — mentir encore
D — dire qu’il doit parler à Marie
```

### 7. Pauline — Dernière photo / son propre secret

Conversation :

```text
chapter_05_pauline_last_photo
```

Fonction : conclure J5 en laissant entendre que d’autres images existent, y compris contre Pauline.

Pauline a aussi des choses à cacher. J5 peut le semer, pas l’exploser.

Trace possible :

```text
pauline_cheating_proof_seed_j5
```

Formes possibles :

```text
photo ambiguë de Pauline avec quelqu’un d’autre
capture aperçue
allusion à son copain au mauvais moment
image retirée
phrase où elle indique savoir où sont les preuves
```

Garde-fou : ne pas révéler toute la tromperie de Pauline en J5.

## Visual content J5 recommandé

Créer `game/data/visual_content/chapter_05_proofs.json` avec au minimum :

```text
photo_party_after_j5_placeholder
story_marie_nico_j5_placeholder
photo_mathilde_after_party_j5_placeholder
photo_marie_after_party_j5_placeholder
photo_pauline_soft_provocation_j5_placeholder
pauline_cheating_proof_seed_j5_placeholder
```

Sandra peut rester sans vrai content_id si la trace est textuelle / supprimée.

Chaque item doit préciser :

```text
character
tier
type
source_app
asset_path placeholder
tags
is_proof
risk_level
can_delete / can_capture / can_set_as_wallpaper
can_be_discovered_by
```

## Règles d’écriture J5

J5 doit être dense mais lisible.

Emojis : reprendre la règle J4/J3, mais adapter au lendemain :

```text
Marie : modérée, intime, fatigue douce — 🙂 🙄 😅
Pauline : plus expressive, contrôle et fausse innocence — 😇 🙂 🙄 🙃 😅
Mathilde : vive mais plus prudente — 😅 😇 🫠 🙄 🙂
Sandra : peu d’emojis, retenue — 🙂 😅
Raphaëlle : très sobre — 🙂 😅 au maximum
Nico / social : peu ou pas d’emojis, sauf réaction sociale ponctuelle
```

Les photos doivent être commentées immédiatement. Une image sans réaction est une image faible.

## Variables / flags

Utiliser les variables déjà connues autant que possible :

```text
marie_trust
lie_score
truth_tendency
ludo_jealousy
social_pressure
marie.lucidity
mathilde.desire
mathilde.loyalty
sandra.attachment
sandra.exposure
raphaelle.attachment
raphaelle.clarity
pauline.interest
pauline.control
nico.desire_for_marie
nico.place_near_marie
marie_attention_score
marie_neglect_score
mathilde_attention_score
sandra_priority_score
raphaelle_clarity_score
pauline_risk_score
nico_surveillance_score
```

Flags J5 possibles :

```text
truth_seed_marie_j5
photo_marie_after_party_j5_received
photo_party_after_j5_received
party_photo_detail_seen_j5
pauline_kept_more_photos_j5
proof_social_j5
story_marie_nico_j5_seen
mathilde_photo_question_j5
photo_mathilde_after_party_j5_received
sandra_later_acknowledged_j5
sandra_almost_sent_photo_j5
raphaelle_boundary_j5
pauline_cheating_proof_seed_j5
j5_more_images_exist
```

Ne pas créer de nouvelles variables chiffrées sans mettre à jour les validateurs.

## Ordre d’unlock recommandé

```text
initial_conversation_ids:
- chapter_05_marie_morning

unlocks:
chapter_05_pauline_photos after chapter_05_marie_morning
chapter_05_social_story after chapter_05_pauline_photos
chapter_05_mathilde_followup after chapter_05_social_story
chapter_05_sandra_later after chapter_05_mathilde_followup
chapter_05_raphaelle_boundary after chapter_05_sandra_later
chapter_05_pauline_last_photo after chapter_05_raphaelle_boundary
```

J5 doit finir sur une sensation :

```text
Il y a d’autres images.
Player ne contrôle pas toute la mémoire de la soirée.
```

## Validations attendues après intégration runtime

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest tests.test_godot_prototype_static -v
git diff --check
godot --headless --path game --quit
godot --headless --path game --resolution 1280x720 --quit
```

Smoke manuel J5 :

```text
J5 ordre : Marie → Pauline photos → Social/Nico → Mathilde → Sandra → Raphaëlle → Pauline fin
Les photos J5 apparaissent dans le bon fil.
Aucun ancien J4/J5 legacy ne s’active par erreur.
Pas de doublons à la réouverture.
Badges/pending cohérents.
Le ton J5 est bien lendemain / relecture, pas nouvelle soirée.
```

## Hors scope

Ne pas faire dans ce patch :

```text
J6
révélation finale Pauline
confrontation totale Marie
route finale verrouillée
preuve irréversible
contenu explicite
nouveau système UI
nouveau système galerie
refactor DataLoader hors ajout J5 si nécessaire
correction du warning held_sandra_space_day2 sauf blocage réel
```

## Critère de réussite

J5 est réussi si le joueur comprend que :

```text
La soirée J4 est terminée.
Mais les photos, elles, commencent seulement à parler.
```
