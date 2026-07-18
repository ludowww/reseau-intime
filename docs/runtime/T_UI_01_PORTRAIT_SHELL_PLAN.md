# T-UI-01 — Plan final de coque portrait

## Statut

Plan documentation-only prêt pour validation.

Ce document n’autorise aucune modification runtime par lui-même.

```text
Narration J01–J21 : signée
UI-FOUNDATION : validé
UI-SCREENS : validé
UI-HANDOFF : validé
Reprise technique : en attente d’autorisation explicite
```

## 1. Baseline Git

```text
Branche du plan : agent/t-ui-01-portrait-shell-plan
Base : main
HEAD / origin/main : 4bff6eff8c2dc3c9b936e3f557c2d05f647207a1
```

Avant implémentation, Hermes devra refaire :

```bash
git fetch origin main
git switch main
git merge --ff-only origin/main
git status --short --branch
git rev-parse HEAD
git rev-parse origin/main
```

Aucun SHA mémorisé ne remplace cette vérification.

## 2. Sources canoniques

Lecture obligatoire :

```text
docs/canon/DOCUMENTATION_READING_ORDER.md
docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md
docs/canon/ui/README.md
docs/canon/ui/UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
docs/canon/ui/UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
docs/canon/ui/UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
docs/runtime/README.md
ROADMAP.md
```

Les rapports et plans V0.xx restent historiques, sauf citation explicite depuis une source active.

## 3. Objectif du lot

Construire une fondation portrait additive et réversible qui prouve :

- une référence de conception `720 × 1280` ;
- une largeur smartphone cohérente sur les formats portrait plus hauts ;
- une gestion explicite des safe areas ;
- une séparation entre couche système et téléphone diégétique ;
- une navigation basse `Messages / Galerie` ;
- un socle de thème réutilisable ;
- une scène de démonstration indépendante des données narratives ;
- une validation automatisable avec Godot.

T-UI-01 ne migre pas encore les véritables écrans Messages, Galerie, Photo ou transitions.

## 4. Découpage obligatoire

T-UI-01 sera livré en deux micro-PR techniques distinctes.

### T-UI-01A — Fondation additive

```text
theme minimal
+ safe-area wrapper
+ portrait shell
+ demo à données factices
+ tests ciblés
```

Le runtime historique et son point d’entrée restent inchangés.

### T-UI-01B — Adoption de la coque

Seulement après validation manuelle et automatique de T-UI-01A :

```text
project.godot portrait
+ adoption de la nouvelle coque comme cadre d’application
+ maintien d’un chemin de vérification legacy temporaire
```

Aucune migration narrative ou refonte des vues métier dans cette PR.

## 5. Audit technique : contexte uniquement

Les fichiers suivants expliquent le runtime historique, mais ne constituent pas une allowlist de modification pour T-UI-01A :

```text
game/scenes/Main.tscn
game/scenes/smartphone/PhonePrototype.tscn
game/scenes/smartphone/ConversationView.tscn
game/scenes/smartphone/PhotoGalleryView.tscn
game/scenes/smartphone/TimelineTransitionView.tscn
game/scenes/smartphone/DebugPanel.tscn

game/scripts/ui/PhonePrototype*.gd
game/scripts/ui/ConversationView*.gd
game/scripts/ui/PhotoGalleryView.gd
game/scripts/ui/TimelineTransitionView.gd
game/scripts/ui/DebugPanel.gd
```

Ces fichiers sont des surfaces d’audit.

Ils ne doivent pas être modifiés dans T-UI-01A, sauf blocage démontré et nouvelle validation de périmètre.

`DebugPanel` reste explicitement hors de la future coque produit.

## 6. Allowlist recommandée — T-UI-01A

Chemins proposés, à confirmer contre l’arborescence réelle au début de la branche :

```text
nouvelle scène de coque portrait sous game/scenes/smartphone/
nouveau script de coque sous game/scripts/ui/
nouveau wrapper safe-area réutilisable
nouvelle ressource Theme sous game/resources/ui/ ou dossier réel équivalent
nouvelle scène de démonstration portrait
nouveau test statique ciblé sous tests/
nouveau smoke test Godot ciblé si le dépôt possède déjà ce type de test
```

Noms recommandés :

```text
PortraitShell.tscn
PortraitShell.gd
SafeAreaContainer.gd
PortraitShellDemo.tscn
reseau_intime_portrait_theme.tres
test_t_ui_01_portrait_shell_static.py
```

Les noms peuvent être adaptés aux conventions réelles du dépôt, mais le nombre de nouveaux composants doit rester minimal.

Fichiers interdits dans T-UI-01A :

```text
game/project.godot
game/scenes/Main.tscn
PhonePrototype*
ConversationView*
PhotoGalleryView*
TimelineTransitionView*
DebugPanel*
JSON narratifs
sauvegardes
assets définitifs
```

`game/project.godot` appartient à T-UI-01B.

## 7. Stratégie de stretch

Référence :

```text
largeur de conception : 720
hauteur de référence : 1280
ratio de référence : 9:16
```

Le ratio 9:16 est une référence, pas un masque fixe imposant des bandes noires sur tous les téléphones plus hauts.

Tester en priorité :

```text
stretch mode : canvas_items
stretch aspect : keep_width
```

But recherché :

- conserver une largeur de composition stable ;
- permettre aux écrans plus hauts d’exposer davantage d’espace vertical ;
- éviter l’étirement non uniforme ;
- garder les composants lisibles sur PC portrait.

`expand` pourra être comparé dans la scène démo si `keep_width` produit un comportement insuffisant.

La décision finale doit être basée sur les tests de T-UI-01A.

## 8. Safe areas

Créer un wrapper réutilisable autour du contenu interactif.

Le wrapper devra :

- lire la safe area fournie par la plateforme lorsqu’elle est pertinente ;
- convertir et borner les marges dans l’espace réel du viewport ou de la fenêtre ;
- éviter les valeurs négatives ou supérieures à la taille visible ;
- fournir un fallback de test configurable sur PC ;
- distinguer safe area physique et simple padding visuel ;
- recalculer lors d’un redimensionnement utile.

Ne pas figer comme règle produit des marges arbitraires telles que `60 px` ou `80 px`.

Les tests devront pouvoir simuler :

```text
aucune encoche
encoche haute
zone basse réservée
portrait très allongé
```

## 9. Séparation des couches

La coque expose deux emplacements structurels.

### Couche système

Réservée ultérieurement à :

- écran titre ;
- pause ;
- sauvegarde / chargement ;
- paramètres ;
- confirmations ;
- accessibilité ;
- transitions globales.

### Couche diégétique

Réservée ultérieurement à :

- Messages ;
- conversations ;
- Galerie ;
- Photo ;
- transitions hors téléphone ;
- transitions de journée.

T-UI-01A ne construit pas ces écrans. Il fournit seulement les conteneurs et les règles de navigation nécessaires pour les accueillir plus tard.

## 10. Navigation démonstratrice

La scène démo contient uniquement :

```text
barre supérieure minimale
zone de contenu interchangeable
deux panneaux factices : Messages / Galerie
barre basse
focus clavier visible
```

Elle doit prouver :

- l’activation de `Messages` par défaut ;
- le passage vers `Galerie` ;
- le retour vers `Messages` ;
- la conservation du layout aux différentes résolutions ;
- l’absence de chevauchement avec les safe areas ;
- l’absence de données ou de logique narratives.

Elle ne doit pas implémenter :

- vraie liste de fils ;
- vraies bulles ;
- vraie Galerie ;
- Photo plein écran ;
- transition hors téléphone ;
- transition de journée ;
- notifications réelles ;
- sauvegarde ;
- Debug.

## 11. Thème et tokens

Introduire un thème minimal réservé aux nouveaux composants portrait.

Le lot ne convertit pas les anciens `StyleBoxFlat` codés en dur.

Le thème minimal couvre :

```text
fond
surface principale
surface secondaire
bordure
texte principal
texte secondaire
focus
accent Player
accents personnages disponibles comme données de présentation
navigation active / inactive
```

Règles :

- aucune couleur seule ne définit un auteur ;
- les anciens scripts continuent à fonctionner sans conversion massive ;
- le thème peut évoluer sans modifier la narration ;
- les noms de tokens restent sémantiques, pas liés à un écran précis.

## 12. Compatibilité historique

### T-UI-01A

- `game/project.godot` reste inchangé ;
- le point d’entrée historique reste inchangé ;
- la démo portrait est lancée explicitement ;
- les tests 1280 × 720 existants continuent à passer.

### T-UI-01B

Après validation de T-UI-01A :

- passage de la base projet à `720 × 1280` ;
- réglages de stretch explicitement versionnés ;
- chemin de vérification temporaire du runtime horizontal ;
- rollback documenté vers les réglages antérieurs.

T-UI-01B doit rester indépendante de T-UI-02, T-UI-03 et T-UI-04.

## 13. Accessibilité couverte par la coque

T-UI-01 prouve seulement les capacités structurelles :

- focus clavier visible ;
- ordre de focus cohérent entre Messages et Galerie ;
- taille de cible suffisante ;
- texte de démonstration agrandi sans clipping ;
- animations de navigation désactivables ;
- contraste du focus ;
- aucune information portée uniquement par la couleur.

Les comportements détaillés des écrans seront implémentés dans leurs lots respectifs.

## 14. Tests et critères d’acceptation

Validation de base :

```bash
python3 tools/validate_game_data.py
python3 tools/simulate_route_paths.py
python3 -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
godot --headless --path game --quit
```

T-UI-01A doit lancer la scène démo ou son smoke test aux formats :

```text
720 × 1280
1080 × 1920
1080 × 2340 ou équivalent
fenêtre PC portrait redimensionnée
```

Vérifier :

- aucun contrôle interactif hors safe area ;
- aucune navigation basse masquée ;
- aucune déformation non uniforme ;
- panneau actif lisible ;
- texte agrandi sans troncature critique ;
- focus clavier visible ;
- mode animations réduites fonctionnel ;
- aucune référence à un JSON narratif ;
- aucun chargement d’asset adulte ;
- point d’entrée historique inchangé.

T-UI-01B doit en plus vérifier :

- nouveau viewport de base correctement chargé ;
- lancement par défaut en portrait ;
- réglages de stretch conformes ;
- compatibilité legacy explicitement vérifiée ;
- aucun changement narratif.

## 15. Risques

- élargissement du lot vers une refonte complète des vues existantes ;
- tentative de convertir tous les styles historiques ;
- safe-area calculée dans le mauvais espace de coordonnées ;
- changement trop précoce de `project.godot` ;
- scène démo transformée en faux runtime ;
- dépendance involontaire aux JSON narratifs ;
- ajout du Debug dans la coque produit ;
- double système de navigation durable.

Chaque risque doit entraîner un arrêt et une revue de périmètre, pas un élargissement silencieux.

## 16. Rollback

### T-UI-01A

Le rollback consiste à supprimer les nouveaux fichiers de coque, thème, safe area, démo et tests.

Aucun fichier historique n’ayant été modifié, le runtime revient à son état initial.

### T-UI-01B

Le rollback consiste à :

- restaurer les réglages antérieurs de `game/project.godot` ;
- restaurer l’ancien point d’entrée si celui-ci a changé ;
- conserver les composants additifs de T-UI-01A s’ils restent inutilisés et sans impact.

## 17. Exclusions techniques

T-UI-01 n’inclut pas :

```text
migration J01–J21
modification de JSON narratif
système de sauvegarde
écrans titre / pause / paramètres
vraies conversations
vraie Galerie
Photo plein écran
transitions narratives
notifications réelles
production d’assets
conversion globale des StyleBoxFlat
suppression du runtime horizontal
refonte du DebugPanel
```

Ces éléments appartiennent à T-UI-02, T-UI-03, T-UI-04 ou T-NAR.

## 18. Validation du plan

Le plan est prêt à être commit et poussé seulement si son diff documentaire contient exclusivement :

```text
docs/runtime/T_UI_01_PORTRAIT_SHELL_PLAN.md
```

Après fusion du plan sur `main`, Ludovic pourra autoriser explicitement :

```text
T-UI-01A — fondation portrait additive
```

Cette autorisation ne vaudra pas automatiquement pour T-UI-01B.
