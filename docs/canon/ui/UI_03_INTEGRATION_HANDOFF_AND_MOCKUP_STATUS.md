# Réseau Intime — UI_03 — Handoff d’intégration et checkpoint implémenté

## Statut

**Catégorie : Canon UX/UI actif — checkpoint d’implémentation après T‑UI‑03D**

**Lot : UI‑HANDOFF validé — UI CORE PROTOTYPE implémenté et gelé**

**Baseline verrouillée : `25928abf9149b5305fea2c08dfae9a47cdbf775c`**

**Périmètre : composants, données de présentation, navigation, persistance cible, responsive, tests et frontière avec la production narrative**

**Autorité : contrat canonique distinguant la cible UX/UI, les surfaces déjà implémentées et les fonctions volontairement différées**

Le préfixe `UI_03` indique l’ordre de lecture du document. Il ne désigne pas une version runtime.

Ce document ne transforme pas le prototype local en runtime narratif final. Il fixe ce qui est déjà disponible pour soutenir la production narrative et ce qui devra être rouvert plus tard dans un lot explicitement décidé.

---

# 1. Statut des concepts

Les concepts validés couvrent :

- charte portrait ;
- liste des conversations ;
- conversation individuelle ;
- conversation de groupe ;
- transition hors téléphone ;
- transition de journée ;
- photo plein écran ;
- Galerie par personnage ;
- titre ;
- pause ;
- sauvegarde et chargement ;
- paramètres ;
- première configuration ;
- avertissement adulte ;
- confirmations ;
- erreurs, chargements et accessibilité.

Statut général :

```text
CANON_UX_UI_ACTIF
```

Ces concepts ne sont pas :

- des assets finaux ;
- des captures du runtime narratif définitif ;
- des designs personnages canoniques ;
- des textes narratifs ;
- des mesures pixel-perfect ;
- une autorisation d’intégrer automatiquement des images dans le dépôt.

La production suit `docs/canon/ui/`, pas les détails accidentels des planches ou prototypes.

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

La narration ne fournit pas la mise en page ni les scènes Godot.

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

L’UI ne crée aucune route, permission narrative, trace, connaissance ou ligne de dialogue.

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

Le runtime ne redéfinit ni le canon narratif ni la cible visuelle.

---

# 3. Inventaire des composants MVP

Les noms sont sémantiques. Ils n’imposent pas une arborescence Godot définitive.

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
DayTransition
```

## Galerie et photo

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

Les composants Coque, Messages, Galerie et Photo sont disponibles dans le prototype local validé. Les écrans Système restent des cibles canoniques différées.

---

# 4. Contrats sémantiques de présentation

Ces structures expriment les besoins de l’UI sans imposer un nouveau format JSON global.

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

États d’accès canoniques :

```text
UNLOCKED
LOCKED
REMOVED
```

Règles :

- `LOCKED` ne possède aucune miniature spoiler ;
- `REMOVED` ne restaure jamais le fichier ;
- retirer l’accès ne supprime ni le message source ni la connaissance acquise ;
- `can_share` vient d’une permission narrative explicite ;
- `is_new` décrit la découverte de présentation, pas un fait narratif.

Dans le prototype local verrouillé après T‑UI‑03D :

```text
state = UNLOCKED | LOCKED
is_new = true | false
```

L’état visible `VIEWED` est dérivé de `UNLOCKED + is_new == false`. Il n’est pas stocké comme état d’accès.

`REMOVED`, les permissions d’action et leur persistance restent canoniques mais différés.

## `PhotoPresentation`

```text
photo_id
visual_ref
access_state
source_kind
character_id
display_name
accent_color
context_label
timestamp
caption
```

Règles :

- le viewer n’accepte qu’un contenu accessible ;
- `source_kind` distingue au minimum Messages et Galerie ;
- le retour conserve la provenance ;
- aucune référence interne n’est affichée au joueur ;
- une photo ouverte depuis Messages ne devient pas automatiquement un item Galerie.

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

| État | Propriétaire cible | Persisté cible | Prototype local actuel |
|---|---|---:|---|
| progression narrative | runtime narratif | oui | non concerné |
| traces / connaissances / promesses | runtime narratif | oui | non concerné |
| historique des messages | runtime | oui | fixtures locales |
| non-lus | runtime / présentation | oui | local |
| dernier fil ouvert | présentation | facultatif | local |
| éléments Galerie déjà vus | présentation | oui | local, non persisté |
| réglages | système | oui | partiel / local |
| animation en cours | UI | non | local |
| hover / focus temporaire | UI | non | local |
| taille calculée | UI | non | local |
| rencontre hors téléphone active | runtime | oui si sauvegarde autorisée | local |

Aucun composant visuel ne devient propriétaire d’un fait narratif.

Le passage local `NEW → VIEWED` du prototype sert uniquement à valider le comportement d’interface. Sa persistance réelle sera définie dans un lot runtime ou sauvegarde dédié.

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

Le checkpoint UI actuel n’ajoute aucune persistance.

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

Le prototype verrouillé valide la navigation Messages ↔ Galerie et les retours Photo → provenance. La navigation système complète reste différée.

---

# 8. Responsive et accessibilité

## Référence

```text
720 × 1280
9:16 portrait
```

## Matrice validée pour le cœur UI

```text
720 × 1280
1080 × 1920
1080 × 2340
safe areas : none / tall-portrait
reduce motion : true / false
navigation clavier
```

## Règles

- safe areas en haut et en bas ;
- aucune action sous la barre système ;
- choix empilés avec texte agrandi ;
- Galerie à deux colonnes en largeur étroite ;
- zones tactiles minimales cohérentes ;
- aucune information portée uniquement par la couleur ;
- focus clavier visible ;
- défilement toujours possible ;
- aucune décision chronométrée par défaut.

Le test historique `1280 × 720` peut rester comme contrôle de non-régression tant que l’ancien layout n’est pas retiré explicitement.

---

# 9. Critères d’acceptation par famille

## Coque

- portrait stable ;
- safe areas respectées ;
- navigation Messages / Galerie fonctionnelle ;
- système et diégétique séparés ;
- reduced motion respecté ;
- focus clavier visible.

## Messages

- une ligne par personnage ou groupe ;
- auteur lisible par couleur, nom et avatar ;
- un choix égale un message Player ;
- scroll et reprise corrects ;
- typing isolé par conversation ;
- transitions hors téléphone et de journée cohérentes ;
- ImageMessage ouvrable sans mutation narrative ;
- retour du viewer vers le même fil.

## Galerie et photo

- onglets personnages ;
- grille responsive ;
- verrouillage non révélateur ;
- indicateur `Nouveau` textuel ;
- état déjà vu dérivé sans libellé intrusif ;
- PhotoViewer partagé ;
- contenu verrouillé absent du viewer ;
- provenance photo conservée ;
- permissions futures respectées lorsqu’elles seront fournies par le runtime.

## Système

- `Continuer` dépend d’une sauvegarde valide ;
- slots non révélateurs ;
- erreur et corruption isolées ;
- réglages appliqués ou explicitement différés ;
- confirmations destructives explicites.

Ces critères restent canoniques, même si les écrans système ne sont pas encore implémentés.

## Accessibilité

- texte agrandi utilisable ;
- contraste renforcé ;
- animations réduites ;
- navigation clavier ;
- palette alternative sans perte d’identité.

---

# 10. Checkpoint d’implémentation verrouillé

## Baseline

```text
25928abf9149b5305fea2c08dfae9a47cdbf775c
```

## Lots terminés

```text
T‑UI‑01   Coque portrait
T‑UI‑02   Famille Messages
T‑UI‑03A  Gallery Core
T‑UI‑03B  ImageMessage
T‑UI‑03C  PhotoViewer
T‑UI‑03D  Gallery States
```

## Implémenté et validé

### Coque

- viewport portrait ;
- safe areas ;
- thème et tokens locaux ;
- navigation basse Messages / Galerie ;
- scène démonstratrice ;
- reduced motion ;
- focus clavier ;
- responsive sur les trois résolutions de référence.

### Messages

- liste des conversations ;
- fils privé et groupe ;
- bulles Player et personnages ;
- choix ;
- non-lus ;
- notification ;
- typing ;
- DayDivider ;
- transition hors téléphone ;
- transition de journée ;
- ImageMessage ;
- ouverture PhotoViewer ;
- restauration du scroll, du focus et du typing.

### Galerie et photo

- onglets personnages ;
- grille responsive ;
- états locaux `NEW / VIEWED / LOCKED` ;
- verrouillage non révélateur ;
- PhotoViewer partagé ;
- provenance Messages / Galerie ;
- précédente / suivante depuis Galerie ;
- retour exact ;
- placeholders générés par l’UI.

### Tests

- matrices portrait ;
- safe areas ;
- reduced motion ;
- clavier et focus ;
- non-régression T‑UI ;
- gate globale historique contrôlée.

## Implémenté uniquement comme prototype local

- données Galerie factices ;
- photos factices générées par l’UI ;
- `NEW / VIEWED` conservés seulement dans l’instance locale ;
- aucune persistance Galerie ;
- aucun lien automatique entre ImageMessage et Galerie ;
- aucune intégration des vraies photos narratives ;
- aucune permission narrative réelle d’ajout, retrait ou partage.

## Différé sans être abandonné

- vrais assets photo ;
- liaison au runtime narratif ;
- persistance Galerie ;
- état `REMOVED` ;
- permissions ajouter / retirer / partager ;
- écrans Titre, Pause, Sauvegarde / Chargement, Paramètres, Configuration et Avertissement ;
- production et intégration des assets finaux ;
- polissage visuel global non bloquant.

---

# 11. Ordre technique mis à jour

## `T‑UI‑01` — Coque portrait

```text
TERMINÉ
```

## `T‑UI‑02` — Composants Messages

```text
TERMINÉ
```

## `T‑UI‑03` — Galerie et Photo

```text
TERMINÉ POUR LE PÉRIMÈTRE PROTOTYPE VALIDÉ
```

Inclus :

- Gallery Core ;
- ImageMessage ;
- PhotoViewer ;
- états locaux `NEW / VIEWED / LOCKED`.

Différé :

- `REMOVED` ;
- permissions runtime ;
- persistance ;
- vrais assets.

## `T‑UI‑04` — Écrans système

```text
DIFFÉRÉ
```

Il sera ouvert seulement lorsque l’un des besoins suivants le justifie :

- vertical slice système ;
- sauvegarde et chargement ;
- flux de démarrage de saison ;
- besoin bloquant découvert pendant la production narrative.

Il n’est pas la prochaine étape automatique.

---

# 12. Frontière des branches

Une branche ne mélange pas par défaut :

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
- un bloc narratif court ;
- un lot documentation-only distinct lorsqu’un checkpoint doit être formalisé.

La PR technique historique #54 reste non autoritative et n’est pas une base automatique.

---

# 13. Validation technique attendue

Base :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
```

Les branches UI ajoutent leurs smoke tests portrait et leurs contrôles de navigation.

La gate globale historique est comparée par identité exacte afin de détecter toute nouvelle régression sans confondre les échecs déjà connus avec ceux du lot courant.

Aucun résultat n’est déclaré tant que la commande n’a pas réellement été exécutée dans l’environnement d’intégration.

---

# 14. Gel de l’extension UI

Après ce checkpoint :

```text
UI CORE PROTOTYPE : IMPLÉMENTÉ ET VALIDÉ
CHECKPOINT UI : VERROUILLÉ
EXTENSION UI PAR DÉFAUT : GELÉE
```

Un nouveau lot UI ne doit être ouvert que pour :

1. un besoin bloquant découvert pendant la production narrative ;
2. l’intégration future des vrais assets ;
3. la persistance ou la sauvegarde ;
4. le lot explicitement décidé des écrans système ;
5. une régression avérée.

Les préférences esthétiques non bloquantes restent dans un backlog et ne justifient pas seules la réouverture du chantier UI.

---

# 15. Reprise de la production narrative

La priorité retourne à la Bible Narrative / North Star.

L’architecture de conception reste :

```text
trame principale
→ routes macro
→ actes narratifs
→ séquences
→ scènes modulaires
→ dialogues
→ photos attendues
→ découpage des journées
```

Les scènes servent des routes et des séquences définies en amont. Les journées ne redeviennent pas la couche principale de conception.

Le présent document ne fixe pas le prochain lot narratif détaillé. Il constate uniquement que le cœur UI nécessaire n’est plus un obstacle à la reprise narrative.

---

# 16. Décision finale

Critères :

- [x] `UI‑FOUNDATION` validé ;
- [x] `UI‑SCREENS` cadré ;
- [x] mode portrait accepté comme cible ;
- [x] composants MVP identifiés ;
- [x] `T‑UI‑01` terminé ;
- [x] `T‑UI‑02` terminé ;
- [x] `T‑UI‑03A` terminé ;
- [x] `T‑UI‑03B` terminé ;
- [x] `T‑UI‑03C` terminé ;
- [x] `T‑UI‑03D` terminé ;
- [x] responsive, safe areas, reduced motion et navigation clavier validés ;
- [x] limites du prototype local documentées ;
- [x] extensions futures conservées comme cibles différées ;
- [x] reprise narrative autorisée.

```text
UI‑HANDOFF : VALIDÉ
UI CORE PROTOTYPE : IMPLÉMENTÉ ET VALIDÉ
CHECKPOINT UI : VERROUILLÉ
EXTENSION UI PAR DÉFAUT : GELÉE
PROCHAINE PRIORITÉ : BIBLE NARRATIVE ET PRODUCTION DES ROUTES / SÉQUENCES
```
