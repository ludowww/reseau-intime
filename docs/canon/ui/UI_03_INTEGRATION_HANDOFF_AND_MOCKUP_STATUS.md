# Réseau Intime — UI_03 — Handoff d’intégration final

## Statut

**Catégorie : Canon UX/UI actif — frontière pré-runtime**

**Lot : UI‑HANDOFF validé**

**Périmètre : composants, données de présentation, navigation, persistance, responsive, tests et découpage technique**

**Autorité : contrat final permettant de préparer la reprise technique sans mélanger narration, UI et runtime**

Le préfixe `UI_03` indique l’ordre de lecture du document. Il ne désigne pas une version runtime.

---

# 1. Statut des concepts

Les concepts validés couvrent désormais :

- charte portrait ;
- liste des conversations ;
- conversation individuelle ;
- conversation de groupe ;
- transition hors téléphone ;
- photo plein écran ;
- Galerie par personnage ;
- transition de journée ;
- titre ;
- pause ;
- sauvegarde et chargement ;
- paramètres ;
- première configuration ;
- avertissement adulte ;
- confirmations ;
- erreurs, chargements et accessibilité.

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
- une autorisation d’intégrer leurs images au dépôt.

La production suit `docs/canon/ui/`, pas les détails accidentels des planches.

---

# 2. Séparation des responsabilités

## Narration

Sources :

```text
docs/canon/dialogues/
docs/canon/bible/
docs/canon/characters/
docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md
```

Fournit :

- texte ;
- auteur ;
- heure ;
- choix ;
- trace ou image attendue ;
- audience ;
- permission ;
- condition ;
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
- accessibilité ;
- hiérarchie de présentation.

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

Il ne redéfinit ni le canon ni la cible visuelle.

---

# 3. Inventaire des composants MVP

## Coque

```text
PortraitAppShell
SafeAreaContainer
SystemLayer
DiegeticLayer
BottomNavigation
ScreenHeader
StatusBar
ModalHost
```

## Messages

```text
ConversationList
ConversationCard
MessageTimeline
MessageBubble
ImageMessage
ChoiceBar
ChoiceButton
TypingIndicator
UnreadDivider
DayDivider
NotificationBanner
OffPhoneTransition
```

## Galerie

```text
CharacterTabs
CharacterTab
GalleryGrid
GalleryTile
GalleryStateOverlay
PhotoViewer
PhotoMetadataPanel
```

## Système

```text
TitleScreen
PauseMenu
SaveLoadScreen
SaveSlotCard
SettingsScreen
FirstRunSetup
ContentWarningScreen
ConfirmDialog
StatusPanel
LoadingState
ErrorState
```

Les noms sont sémantiques. Ils n’imposent pas une arborescence Godot définitive.

---

# 4. Contrats sémantiques de présentation

Ces structures expriment les besoins de l’UI, sans imposer un nouveau format JSON global.

## `CharacterPresentation`

```text
character_id
display_name
accent_color
avatar_ref
gallery_enabled
```

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
is_archived
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
source_day
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
can_add_to_gallery
can_remove_local
can_share
```

États :

```text
UNLOCKED
LOCKED
REMOVED
```

Règles :

- `LOCKED` ne possède aucune miniature spoiler ;
- `REMOVED` ne restaure jamais le fichier ;
- retirer l’accès ne supprime ni le message source ni la connaissance acquise ;
- `can_share` vient d’une permission narrative explicite.

## `OffPhonePresentation`

```text
participant_ids
location_label
started_at
elapsed_time
state
```

États :

```text
ACTIVE
ENDED_WAITING_FOR_TEXT_RESUME
```

Le joueur ne peut pas modifier cet état depuis l’UI.

## `DayTransitionPresentation`

```text
narrative_day
display_date
visual_mood
notification_summaries
can_auto_dismiss
```

## `SaveSlotPresentation`

```text
slot_id
slot_type
narrative_day
narrative_time
safe_location_label
real_saved_at
safe_thumbnail_ref
validation_state
```

États :

```text
EMPTY
VALID
CORRUPTED
INCOMPATIBLE
```

Aucun score, secret ou état de route n’est affiché.

## `PlayerProfilePresentation`

```text
display_name
pronoun_set
adult_acknowledgement
```

Les pronoms restent optionnels tant que le jeu n’en a pas besoin dans ses textes.

## `UISettings`

```text
text_scale
message_speed
instant_text
auto_scroll
typing_animation
confirm_choices
reduce_motion
reduce_flashes
high_contrast
color_filter
keyboard_navigation
master_volume
music_volume
ambience_volume
notification_volume
ui_volume
```

Les réglages Android restent conditionnels à la plateforme.

---

# 5. Propriété des états

| État | Propriétaire | Persisté |
|---|---|---|
| progression narrative | runtime narratif | oui |
| traces / connaissances / promesses | runtime narratif | oui |
| historique des messages | runtime | oui |
| non-lus | runtime / présentation | oui |
| dernier fil ouvert | présentation | facultatif |
| éléments Galerie déjà vus | présentation | oui |
| réglages | système | oui |
| animation en cours | UI | non |
| hover / focus temporaire | UI | non |
| particules | UI | non |
| taille calculée | UI | non |
| rencontre hors téléphone active | runtime | oui si sauvegarde autorisée |

Aucun composant visuel ne devient propriétaire d’un fait narratif.

---

# 6. Persistance et sauvegarde

## État narratif obligatoire

- progression ;
- choix ;
- messages ;
- traces ;
- connaissances ;
- promesses ;
- audiences et retraits ;
- états relationnels bornés ;
- journée et phase ;
- obligations dues.

## État de présentation utile

- dernier fil ouvert ;
- nouveaux contenus de Galerie déjà consultés ;
- paramètres ;
- profil Player ;
- slots manuels ;
- position de lecture seulement si elle améliore réellement la reprise.

## Autosave

L’autosave est contrôlé par le runtime.

Il ne se déclenche pas :

- au milieu de l’application d’un choix ;
- entre un message Player et sa conséquence immédiate ;
- pendant une mutation de journée incomplète ;
- à un moment où les données sont temporairement incohérentes.

La politique exacte de checkpoint doit être définie et testée dans une branche sauvegarde dédiée.

---

# 7. Navigation canonique

```text
Titre
├── Continuer → dernière sauvegarde valide
├── Nouvelle partie → avertissement → configuration → D01
├── Charger → sauvegardes
├── Paramètres
└── Crédits
```

Navigation diégétique :

```text
D01 Messages ↔ D06 Galerie
D01 → D02 / D03
D02 / D03 → D05 Photo → provenance
D02 → D04 hors téléphone
transition réelle terminée → reprise du fil
D07 nouveau jour → D01
```

Navigation système :

```text
écran narratif → Pause
Pause → Reprendre / Sauvegarder / Charger / Paramètres / Titre
```

Interdits :

- quitter un écran destructif sans confirmation ;
- forcer la fin d’une rencontre depuis Pause ;
- perdre la provenance d’une photo ;
- empiler plusieurs modales destructives.

---

# 8. Responsive et accessibilité

## Référence

```text
720 × 1280
9:16 portrait
```

## Tests supplémentaires

```text
1080 × 1920
1080 × 2340 ou format portrait allongé
fenêtre PC portrait
texte agrandi
contraste renforcé
animations réduites
navigation clavier
```

## Règles

- safe areas en haut et en bas ;
- aucune action sous la barre système ;
- choix empilés avec texte agrandi ;
- Galerie à deux colonnes en grand texte ;
- zones tactiles minimales cohérentes ;
- aucune information portée uniquement par la couleur ;
- focus clavier visible ;
- défilement toujours possible ;
- aucune décision chronométrée par défaut.

Le test historique `1280 × 720` peut rester temporairement jusqu’au retrait explicite de l’ancien layout.

---

# 9. Critères d’acceptation par famille

## Coque

- portrait stable ;
- safe areas respectées ;
- navigation Messages / Galerie fonctionnelle ;
- système et diégétique séparés.

## Messages

- fils persistants ;
- une ligne par personnage ou groupe ;
- auteur lisible par couleur, nom et avatar ;
- un choix égale un message Player ;
- scroll et reprise corrects ;
- aucun message pendant co-présence.

## Galerie

- onglets personnages ;
- verrouillage non révélateur ;
- contenu retiré inaccessible ;
- permissions d’action respectées ;
- provenance photo conservée.

## Système

- `Continuer` dépend d’une sauvegarde valide ;
- slots non révélateurs ;
- erreur et corruption isolées ;
- réglages appliqués ou explicitement différés ;
- confirmations destructives explicites.

## Accessibilité

- texte agrandi utilisable ;
- contraste renforcé ;
- animations réduites ;
- navigation clavier ;
- palette alternative sans perte d’identité.

---

# 10. Ordre technique recommandé

## `T‑UI‑01` — Coque portrait

Périmètre :

- viewport portrait ;
- safe areas ;
- thème et tokens ;
- couches système / diégétique ;
- navigation basse ;
- scène démonstratrice ;
- aucune migration narrative.

## `T‑UI‑02` — Composants Messages

- liste des conversations ;
- bulles ;
- choix ;
- non-lus ;
- notifications ;
- typing ;
- transition hors téléphone ;
- transition de journée.

## `T‑UI‑03` — Galerie et Photo

- onglets personnages ;
- grille ;
- tuiles ;
- photo plein écran ;
- permissions ;
- verrouillé / nouveau / retiré.

## `T‑UI‑04` — Écrans système

- titre ;
- pause ;
- sauvegarde / chargement ;
- paramètres ;
- première configuration ;
- avertissement ;
- confirmations et erreurs.

## `T‑NAR‑01` — Réconciliation J01–J06

Commence seulement après validation de la coque et des composants nécessaires.

Puis :

```text
J07–J09
→ J10–J12
→ J13–J16
→ J17–J21
```

---

# 11. Frontière des branches

Une PR ne mélange pas par défaut :

```text
migration portrait
+ réécriture globale des conversations
+ changement de sauvegarde
+ production d’assets
```

Préférer :

- un shell ou groupe de composants ;
- une famille d’écrans ;
- une modification de sauvegarde explicitement testée ;
- un bloc narratif court.

La PR technique historique #54 reste non autoritative et n’est pas une base automatique.

---

# 12. Validation technique attendue

Base :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
```

Les branches UI ajoutent leurs smoke tests portrait et leurs contrôles de navigation.

Aucun résultat n’est déclaré tant que la commande n’a pas réellement été exécutée dans l’environnement Hermes.

---

# 13. Décision de reprise technique

Critères :

- [x] `UI‑FOUNDATION` validé ;
- [x] `UI‑SCREENS` validé ;
- [x] sauvegarde et chargement cadrés ;
- [x] paramètres et accessibilité cadrés ;
- [x] mode portrait accepté comme cible ;
- [x] composants MVP identifiés ;
- [x] `UI‑HANDOFF` validé ;
- [x] documents V0.xx traités comme historiques ;
- [x] maquettes traitées comme références conceptuelles ;
- [ ] autorisation explicite de Ludovic pour commencer `T‑UI‑01` ;
- [ ] plan court `T‑UI‑01` rédigé depuis `main` courant.

```text
UI‑HANDOFF : VALIDÉ
REPRISE TECHNIQUE : PRÊTE MAIS NON ENCORE AUTORISÉE
PROCHAINE ACTION : décision explicite puis plan T‑UI‑01
```
