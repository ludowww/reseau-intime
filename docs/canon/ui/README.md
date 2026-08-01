# Réseau Intime — Index UX/UI canonique

## Statut

**Catégorie : index canonique actif**

```text
UI-FOUNDATION : validé
UI-SCREENS : validé
UI-HANDOFF : validé
T-UI-01 à T-UI-03D : implémentés et validés
UI-MSG-04A à UI-MSG-04C : correctifs runtime intégrés et validés
RUNTIME SAISON 1 : J01→J21 présent sur la baseline
DERNIER JALON VERROUILLÉ : J11 A5
UI CORE : verrouillé
Extension UI par défaut : gelée
Baseline technique courante : fa2880c1ad168569b148ed85bedf4774324f87dd
Tag runtime : runtime-s1-11e-j11-a5-scene-presentation
```

Ce dossier contient les décisions UX/UI actives du projet. Les maquettes générées sont des références conceptuelles ; seules les décisions transférées dans les documents ci-dessous ont autorité.

Le checkpoint T-UI-03D reste la fondation canonique. Les lots runtime ultérieurs,
jusqu’au verrouillage J11 A5, ne créent pas une nouvelle direction visuelle : ils
adaptent le runtime narratif dans cette fondation.

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

La fondation historique J01–J04 des corrections communes est conservée dans :

```text
docs/runtime/SEASON_1_J01_J04_RUNTIME_BASELINE_AND_FORWARD_CONTRACT.md
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
- non-lus calculés par la couche runtime commune ;
- aucun badge numérique de non-lu ;
- fil non lu affiché avec le nom et « Nouveau message ! » en `TEXT_PRIMARY` et graisse renforcée ;
- `variation_embolden = 1.5` pour l’état non lu ;
- restauration du véritable aperçu et du style normal après lecture complète ;
- typing isolé par conversation ;
- livraison progressive des messages ;
- restauration du scroll et du focus ;
- bandeau compact avec jour et heure courants ;
- notifications interactives ouvrant le fil ;
- notifications neutres affichant « Nouveau message ! » sans extrait narratif ;
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
- placeholders générés par l’UI ;
- un `PHOTO_SET` peut être présenté comme un seul message avec plusieurs frames enfants ;
- le set Pauline J04 comporte trois frames sans créer trois bulles séparées.

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
- non-lus via `RuntimeUnread.gd` ;
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
- une photo ouverte depuis Messages ne devient pas automatiquement un item Galerie ;
- un message entrant ajouté dans un fil fermé reste non lu jusqu’à présentation complète ;
- fermer une notification ne marque jamais le fil comme lu ;
- plusieurs messages en attente ne produisent aucun compteur visible.

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

- livraison des vrais assets narratifs concernés ;
- persistance Galerie ;
- état `REMOVED` ;
- permissions ajouter / retirer / partager ;
- écrans système ;
- migration et compatibilité de sauvegarde cible ;
- polish visuel global non bloquant.

Le runtime narratif J01–J21 est présent dans la chaîne portrait. Cette présence ne
garantit pas un polish uniforme. L’architecture visuelle commune utilise
`VisualMediaResolver` et `ResourceLoader`, mais les placeholders et prototypes ne
valent pas assets finaux. J11 A5 contient deux parents Galerie et six enfants de
séquence ; aucun des six assets finaux n’est livré et **« Visuel non livré »** reste
le fallback attendu.

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

Les évolutions futures doivent utiliser les composants communs déjà corrigés et ne
justifient pas automatiquement un composant parallèle.

```text
PROCHAINE RECOMMANDATION : LOT BORNÉ AUX SIX ASSETS ENFANTS J11 A5
```
