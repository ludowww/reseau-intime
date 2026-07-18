# Réseau Intime — UI‑03 — Handoff d’intégration et statut des maquettes

## Statut

**Catégorie : Canon UX/UI actif — frontière pré-runtime**

**Périmètre : responsabilités des données, statut des maquettes, ordre d’implémentation et critères de reprise technique**

**Autorité : empêche que la future intégration mélange contenu narratif, présentation et état technique**

---

# 1. Statut des maquettes produites

Les écrans conceptuels validés pendant les échanges ont établi :

- le format portrait ;
- la direction anime-inspired ;
- le thème sombre nocturne ;
- les couleurs d’identité ;
- les conversations privées et de groupe ;
- la Galerie sous forme de collection photo ;
- les onglets par personnage ;
- les tuiles verrouillées.

Ils restent :

```text
CONCEPT_REFERENCES
```

Ils ne sont pas :

- des assets de production ;
- des captures du jeu ;
- le design définitif des personnages ;
- des textes narratifs canoniques ;
- des mesures pixel-perfect ;
- des licences d’utilisation finale.

La future production doit utiliser les décisions des documents UI, pas copier aveuglément les images conceptuelles.

---

# 2. Séparation des responsabilités

## Narration

Source :

```text
docs/canon/dialogues/
docs/canon/bible/
docs/canon/characters/
```

Fournit :

- texte ;
- auteur ;
- heure ;
- choix ;
- image ou trace attendue ;
- conditions narratives ;
- conséquence.

Ne fournit pas :

- largeur de bulle ;
- couleur de surface ;
- animation ;
- structure de scène Godot.

## UI/UX

Source :

```text
docs/canon/ui/
```

Fournit :

- écrans ;
- composants ;
- navigation ;
- couleurs ;
- états visuels ;
- responsive ;
- accessibilité ;
- hiérarchie de présentation.

Ne fournit pas :

- route ;
- permission narrative ;
- nouvelle trace ;
- nouveau message ;
- connaissance d’un personnage.

## Runtime

Source :

```text
code + données + tests sur main
docs/runtime/ pour les plans actifs
```

Fournit :

- chargement ;
- persistance ;
- calcul d’éligibilité ;
- ordre ;
- sauvegarde ;
- adaptation des données vers les composants.

Ne redéfinit pas le canon ou le design produit.

---

# 3. Contrats sémantiques de données

Ces structures décrivent des besoins, pas des classes imposées.

## `CharacterPresentation`

```text
character_id
display_name
accent_color
avatar_ref
gallery_enabled
```

Les valeurs de couleur viennent de UI‑01.

## `ConversationThreadPresentation`

```text
thread_id
title
participant_ids
last_preview
last_timestamp
unread_count
availability_state
is_group
```

`availability_state` ne doit jamais contenir un nom de route visible.

## `MessagePresentation`

```text
message_id
author_id
timestamp
content_type
text
media_ref
is_player
is_read
```

Types minimum :

```text
TEXT
IMAGE
SYSTEM_DAY_DIVIDER
OFF_PHONE_TRANSITION
REMOVED_MEDIA
```

## `ChoicePresentation`

```text
choice_id
text
enabled
confirmation_required
```

Une raison technique d’indisponibilité n’est pas montrée sauf décision produit explicite.

## `GalleryItemPresentation`

```text
item_id
character_id
thumbnail_ref
full_ref
state
is_new
sort_key
```

États :

```text
UNLOCKED
LOCKED
REMOVED
```

Le runtime ne doit pas générer une miniature spoiler pour `LOCKED`.

## `SaveSlotPresentation`

```text
slot_id
slot_type
narrative_day
narrative_time
safe_location_label
real_saved_at
safe_thumbnail_ref
is_valid
```

Aucun état de route.

## `UISettings`

```text
text_scale
message_speed
auto_scroll
typing_animation
confirm_choices
reduce_motion
high_contrast
master_volume
music_volume
ambience_volume
notification_volume
```

---

# 4. Persistance UI

La future sauvegarde doit distinguer :

## État narratif

- progression ;
- choix ;
- traces ;
- connaissances ;
- promesses ;
- relations.

## État de présentation utile

- dernier fil ouvert ;
- position de scroll si raisonnable ;
- nouveaux contenus de Galerie déjà vus ;
- paramètres ;
- sauvegardes manuelles.

## État éphémère non nécessaire

- animation en cours ;
- hover ;
- particules ;
- message temporairement sélectionné ;
- taille calculée d’un composant.

---

# 5. Ordre d’implémentation recommandé

## T‑UI‑01 — Coque portrait

- `project.godot` portrait ;
- viewport de référence ;
- safe areas ;
- scaling ;
- navigation basse ;
- thèmes et tokens ;
- aucune migration narrative dans le même patch si possible.

## T‑UI‑02 — Composants narratifs

- ConversationCard ;
- MessageBubble ;
- ChoiceBar ;
- DayDivider ;
- OffPhoneTransition ;
- notification ;
- typing.

Utiliser de fausses données ou une scène de démonstration contrôlée.

## T‑UI‑03 — Galerie

- CharacterTab ;
- GalleryGrid ;
- GalleryTile ;
- PhotoViewer ;
- états verrouillé / nouveau / retiré.

## T‑UI‑04 — Écrans système

- titre ;
- pause ;
- sauvegarde / chargement ;
- paramètres ;
- première configuration ;
- confirmations.

## T‑NAR‑01 — Réconciliation J01–J06

Seulement après validation de la coque et des composants.

## T‑NAR suivants

```text
J07–J09
→ J10–J12
→ J13–J16
→ J17–J21
```

---

# 6. Frontière des branches

Une PR ne doit pas mélanger par défaut :

```text
refonte globale UI
+ migration de quinze journées
+ changement de sauvegarde
+ production d’assets
```

Préférer :

- un écran ou un groupe de composants ;
- une migration de format ;
- un bloc narratif court ;
- un changement de sauvegarde explicitement testé.

---

# 7. Validation technique attendue

Lors de la reprise :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -v
git diff --check
godot --headless --path game --quit
```

Tests portrait futurs :

```text
720 × 1280
1080 × 1920
1080 × 2340
```

Le test historique `1280 × 720` peut être conservé temporairement pour détecter les régressions avant suppression explicite de l’ancien layout.

---

# 8. Critères avant autorisation technique

La reprise technique peut être autorisée lorsque :

- [ ] UI‑01 est validé ;
- [ ] les écrans manquants ont des spécifications détaillées ou maquettes suffisantes ;
- [ ] l’écran sauvegarde / chargement est cadré ;
- [ ] les paramètres et l’accessibilité sont cadrés ;
- [ ] le mode portrait est accepté comme cible ;
- [ ] les composants MVP sont identifiés ;
- [ ] la première branche technique possède un périmètre court ;
- [ ] les documents runtime anciens sont traités comme historiques ;
- [ ] aucun asset conceptuel n’est considéré final par erreur.

---

# 9. Prochaine tranche UI

```text
UI‑02 — spécifications et maquettes finales
```

Priorité :

1. photo plein écran ;
2. transition hors téléphone ;
3. transition de journée ;
4. écran titre ;
5. pause ;
6. sauvegarde / chargement ;
7. paramètres ;
8. première configuration et confirmations.

La liste Messages, la conversation individuelle, la conversation de groupe et la Galerie par personnage disposent déjà d’une direction conceptuelle validée.

---

# 10. Verdict

```text
NARRATION : signée
DIRECTION UI : cadrée
MAQUETTES : références conceptuelles
RUNTIME HORIZONTAL : historique à réconcilier
REPRISE TECHNIQUE : encore séparée et non autorisée par UI‑01
```
