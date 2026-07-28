# Réseau Intime — Index UX/UI canonique

## Statut

**Catégorie : index canonique actif**

```text
UI-FOUNDATION : validé
UI-SCREENS : validé
UI-HANDOFF : validé
T-UI-01 à T-UI-03D : implémentés et validés
UI-MSG-04A à UI-MSG-04C : correctifs runtime intégrés et validés
UI CORE : verrouillé
Extension UI par défaut : gelée
Baseline technique courante : c27bd9331c01bed6c9a40c0c642d246cf26bb6cf
```

Ce dossier contient les décisions UX/UI actives du projet. Les maquettes générées sont des références conceptuelles ; seules les décisions transférées dans les documents ci-dessous ont autorité.

Le checkpoint T-UI-03D reste la fondation canonique. Les lots UI-MSG-04A à 04C ne créent pas une nouvelle direction visuelle : ils corrigent et stabilisent l’intégration du runtime narratif dans cette fondation.

---

# 1. Sources actives

```text
UI_01_VERTICAL_SMARTPHONE_SYSTEM.md
UI_02_SCREEN_ARCHITECTURE_AND_STATES.md
UI_03_INTEGRATION_HANDOFF_AND_MOCKUP_STATUS.md
```

Ordre d’autorité :

```text
UI_01 système visuel et responsive
→ UI_02 écrans et états canoniques
→ UI_03 intégration, checkpoint fondateur et fonctions différées
→ code + tests sur main pour l’état runtime exact
```

Le contrat technique J01–J03 et les corrections communes sont documentés dans :

```text
docs/runtime/SEASON_1_J01_J03_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
```

---

# 2. Décisions verrouillées

```text
format cible : portrait smartphone
viewport de référence : 720 × 1280
ratio de conception : 9:16
support initial : PC en fenêtre portrait
Android : plus tard
style : sombre, anime-inspired, premium et lisible
identification : couleur + avatar + nom + position
navigation diégétique : Messages / Galerie
Galerie : collection organisée par personnage
Profil : différé tant qu’aucune fonction produit n’est validée
interface système : distincte du téléphone diégétique
```

La couleur n’est jamais utilisée seule. L’UI n’affiche ni route, ni score, ni raison technique d’éligibilité.

---

# 3. Surfaces implémentées et validées

## Coque

- viewport portrait ;
- safe areas ;
- navigation Messages / Galerie ;
- thème local ;
- responsive ;
- reduced motion ;
- navigation clavier ;
- focus visible.

## Messages

- liste des conversations ;
- conversations privées et de groupe ;
- bulles Player et personnages ;
- choix Player ;
- non-lus ;
- typing isolé par conversation ;
- livraison progressive des messages ;
- restauration du scroll et du focus ;
- bandeau compact avec jour et heure courants ;
- notifications interactives ouvrant le fil ;
- DayDivider historique par `source_day` ;
- un seul séparateur par jour et par fil ;
- aucun `SYSTEM_DAY_DIVIDER` rendu comme bulle ;
- transitions `CLOCK`, `OFF_PHONE`, `NIGHT`, `NEW_DAY` et fin de contenu ;
- ImageMessage ;
- ouverture PhotoViewer ;
- retour vers le même fil.

## Vitesse de lecture

```text
×1 / ×3 / ×8 → typing et délais entre messages
transitions   → temps réel
PhotoViewer   → non affecté
```

Aucun bouton de vitesse n’est affiché dans l’overlay de transition.

## Galerie et photo

- onglets personnages ;
- grille responsive ;
- états locaux `NEW / VIEWED / LOCKED` ;
- verrouillage non révélateur ;
- PhotoViewer partagé ;
- provenance Messages / Galerie ;
- précédente / suivante depuis Galerie ;
- placeholders générés par l’UI.

---

# 4. Frontière canon / runtime

## La narration fournit

- texte ;
- auteur ;
- heure ;
- choix ;
- trace ou image attendue ;
- audience ;
- permission ;
- condition ;
- conséquence.

## L’UI fournit

- écrans ;
- composants ;
- navigation ;
- couleurs ;
- états visuels ;
- responsive ;
- accessibilité ;
- hiérarchie de présentation.

## Le runtime fournit

- chargement ;
- ordre ;
- éligibilité ;
- temps narratif ;
- transcripts ;
- non-lus ;
- transitions ;
- persistance et sauvegarde futures ;
- adaptation des données vers l’UI.

Aucun composant visuel ne devient propriétaire d’un fait narratif.

---

# 5. Schémas de présentation protégés

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

Règles actuelles :

- `source_day` pilote le séparateur historique ;
- le bandeau conserve le temps courant ;
- `SYSTEM_DAY_DIVIDER` n’est jamais une bulle ;
- `OFF_PHONE_TRANSITION` n’est jamais une bulle ordinaire ;
- une photo ouverte depuis Messages ne devient pas automatiquement un item Galerie.

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

Dans le prototype actuel, `REMOVED` et les permissions d’action restent différés.

---

# 6. Écrans canoniques différés

```text
S01 écran titre
S02 menu pause
S03 sauvegarde / chargement
S04 paramètres
S05 première configuration Player
S05B avertissement adulte
S06 confirmations et erreurs
S07 crédits / informations légales
```

Ils ne sont pas encore implémentés comme flux final. Leur absence actuelle ne les rend pas abandonnés.

---

# 7. Frontière prototype / runtime final

Restent différés :

- vrais assets ;
- persistance Galerie ;
- état `REMOVED` ;
- permissions ajouter / retirer / partager ;
- écrans système ;
- migration et compatibilité de sauvegarde cible ;
- polish visuel global non bloquant.

La liaison au runtime narratif n’est plus entièrement absente : J01–J03 sont intégrés dans la nouvelle chaîne portrait. J04–J21 restent à intégrer.

---

# 8. Règles narratives protégées

L’UI ne doit jamais afficher :

- nom de route ;
- score relationnel ;
- pourcentage de désir ;
- propriétaire de route ;
- contradiction interne ;
- `trace_id`, `promise_id` ou `fact_id` ;
- raison technique d’éligibilité ;
- contenu exact d’une image verrouillée.

L’UI rend les conséquences visibles par :

- messages ;
- horaires ;
- absence ;
- notifications ;
- accès, retrait ou verrouillage d’un contenu ;
- comportement autonome des personnages.

---

# 9. Réouverture du chantier UI

Un nouveau lot UI ne s’ouvre que pour :

1. un besoin bloquant découvert pendant l’intégration narrative ;
2. l’intégration future des vrais assets ;
3. la persistance ou la sauvegarde ;
4. les écrans système explicitement décidés ;
5. une régression avérée.

Les futures journées doivent utiliser les composants communs déjà corrigés. Un besoin propre à J04 ne justifie pas automatiquement un composant parallèle.

```text
PROCHAINE PRIORITÉ : INTÉGRATION RUNTIME J04 DEPUIS LA BASELINE J01–J03
```
