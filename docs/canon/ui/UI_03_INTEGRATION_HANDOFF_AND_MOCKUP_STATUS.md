# Réseau Intime — UI_03 — Handoff d’intégration et statut des maquettes

## Statut

**Catégorie : Canon UX/UI actif — frontière pré-runtime**

**Périmètre : responsabilités, données de présentation, persistance, ordre technique et critères de reprise**

**Autorité : définit comment intégrer l’UI sans mélanger narration, présentation et runtime**

Le préfixe `UI_03` indique l’ordre de lecture du document. Le lot de travail correspondant est `UI‑HANDOFF`.

---

# 1. Statut des maquettes

Les concepts validés ont établi :

- portrait smartphone ;
- style sombre anime-inspired ;
- couleurs par personnage ;
- conversations privées et de groupe ;
- Galerie en collection photo ;
- onglets par personnage ;
- tuiles verrouillées.

Statut :

```text
CONCEPT_REFERENCES
```

Ils ne sont pas :

- des assets finaux ;
- des captures du runtime ;
- des designs personnages canoniques ;
- des textes narratifs ;
- des mesures pixel-perfect ;
- une autorisation de copier les images en production.

La production suit les documents UI actifs, pas les détails accidentels d’une maquette.

---

# 2. Séparation des responsabilités

## Narration

Sources :

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
- trace attendue ;
- conditions ;
- conséquence.

Ne fournit pas la mise en page ou les scènes Godot.

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
- accessibilité.

Ne crée aucune route, permission, trace, connaissance ou ligne de dialogue.

## Runtime

Sources :

```text
code + données + tests sur main
docs/runtime/ pour un plan de branche actif
```

Fournit :

- chargement ;
- ordre ;
- éligibilité ;
- persistance ;
- sauvegarde ;
- adaptation des données vers l’UI.

Il ne redéfinit pas le canon ou la cible visuelle.

---

# 3. Contrats sémantiques de présentation

Ces formes décrivent les besoins de l’UI. Elles n’imposent pas des classes ou un format JSON définitif.

## `CharacterPresentation`

```text
character_id
display_name
accent_color
avatar_ref
gallery_enabled
```

Les couleurs viennent de `UI_01_VERTICAL_SMARTPHONE_SYSTEM.md`.

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

`availability_state` ne contient jamais un nom de route visible.

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

Une raison interne d’indisponibilité ne devient pas automatiquement un texte joueur.

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

Une tuile `LOCKED` ne possède pas de miniature spoiler.

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

Aucun score, secret ou état de route n’est affiché.

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

# 4. Persistance

## État narratif

- progression ;
- choix ;
- traces ;
- connaissances ;
- promesses ;
- états relationnels.

## État de présentation utile

- dernier fil ouvert ;
- nouveaux contenus de Galerie déjà consultés ;
- paramètres ;
- slots manuels ;
- position de lecture seulement si elle améliore réellement la reprise.

## État éphémère à ne pas sauvegarder

- animation en cours ;
- hover ou focus temporaire ;
- particules ;
- taille calculée ;
- message temporairement sélectionné.

---

# 5. Ordre technique recommandé

## `T‑UI‑01` — Coque portrait

- `project.godot` portrait ;
- viewport de référence ;
- safe areas ;
- scaling ;
- tokens de thème ;
- navigation Messages / Galerie ;
- scène de démonstration ou fausses données ;
- aucune migration narrative massive.

## `T‑UI‑02` — Composants narratifs

- `ConversationCard` ;
- `MessageBubble` ;
- `ChoiceBar` ;
- `DayDivider` ;
- `OffPhoneTransition` ;
- notification ;
- typing.

## `T‑UI‑03` — Galerie

- `CharacterTab` ;
- `GalleryGrid` ;
- `GalleryTile` ;
- `PhotoViewer` ;
- états verrouillé, nouveau et retiré.

## `T‑UI‑04` — Écrans système

- titre ;
- pause ;
- sauvegarde / chargement ;
- paramètres ;
- première configuration ;
- confirmations.

## `T‑NAR‑01` — Réconciliation J01–J06

Commence seulement après validation de la coque et des composants.

Puis :

```text
J07–J09
→ J10–J12
→ J13–J16
→ J17–J21
```

---

# 6. Frontière des branches

Une PR ne mélange pas par défaut :

```text
refonte UI globale
+ migration de nombreuses journées
+ changement de sauvegarde
+ production d’assets
```

Préférer :

- un écran ou groupe de composants ;
- une migration de format ;
- un bloc narratif court ;
- une modification de sauvegarde explicitement testée.

---

# 7. Validation attendue

Base :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -v
git diff --check
godot --headless --path game --quit
```

Résolutions portrait futures :

```text
720 × 1280
1080 × 1920
1080 × 2340
fenêtre PC portrait
```

Le test historique `1280 × 720` peut rester temporairement pour détecter les régressions avant retrait explicite de l’ancien layout.

---

# 8. Critères avant autorisation technique

La reprise technique peut être autorisée lorsque :

- [ ] `UI‑FOUNDATION` est validé ;
- [ ] `UI‑SCREENS` spécifie ou maquette suffisamment les écrans manquants ;
- [ ] sauvegarde / chargement est cadré ;
- [ ] paramètres et accessibilité sont cadrés ;
- [ ] portrait est accepté comme cible ;
- [ ] les composants MVP sont identifiés ;
- [ ] `UI‑HANDOFF` est validé ;
- [ ] la première branche technique possède un périmètre court ;
- [ ] les documents V0.xx sont traités comme historiques ;
- [ ] aucun concept visuel n’est pris pour un asset final.

---

# 9. Prochaine phase

```text
UI‑SCREENS — spécifications et maquettes finales
```

Priorités :

1. photo plein écran ;
2. transition hors téléphone ;
3. transition de journée ;
4. écran titre ;
5. pause ;
6. sauvegarde / chargement ;
7. paramètres ;
8. première configuration et confirmations ;
9. états vides, erreur et texte agrandi.

La liste Messages, la conversation individuelle, la conversation de groupe et la Galerie par personnage disposent déjà d’une direction conceptuelle validée.

---

# 10. Verdict

```text
NARRATION : signée
UI‑FOUNDATION : cadré
MAQUETTES : références conceptuelles
RUNTIME HORIZONTAL : prototype à réconcilier
REPRISE TECHNIQUE : encore séparée et non autorisée
```
