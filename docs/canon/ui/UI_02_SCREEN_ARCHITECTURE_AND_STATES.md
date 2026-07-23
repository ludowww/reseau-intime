# Réseau Intime — UI_02 — Architecture des écrans et états

## Statut

**Catégorie : Canon UX/UI actif**

**Lot : UI‑SCREENS validé**

**Périmètre : écrans narratifs, écrans système, navigation et états secondaires**

**Autorité : inventaire fonctionnel des surfaces et comportements**

**Implémentation actuelle : cœur diégétique D01–D07 disponible en prototype local ; écrans système différés**

Les maquettes restent des références conceptuelles. Le présent document fait autorité sur leurs détails accidentels.

---

# 1. Deux couches distinctes

## Couche diégétique

Le téléphone utilisé dans l’histoire :

- Messages ;
- conversations privées et de groupe ;
- images reçues ;
- Galerie ;
- notifications ;
- transitions de journée.

## Couche système

Le jeu lui-même :

- titre ;
- pause ;
- sauvegarde et chargement ;
- paramètres ;
- première configuration ;
- confirmations ;
- crédits et informations légales.

Les deux couches partagent une même direction visuelle, mais ne sont jamais confondues narrativement.

---

# 2. Écrans diégétiques

## D01 — Liste des conversations

Fonction : donner accès aux fils actifs sans présenter de routes.

```text
header Messages
conversation cards
aperçu du dernier message
heure
non-lus
notification compacte
navigation Messages / Galerie
```

Règles :

- une ligne par personnage ou groupe ;
- les épisodes internes restent dans le même fil ;
- couleur, avatar et nom identifient ensemble l’auteur ;
- l’ordre dépend de l’activité utile, jamais d’une valeur de route ;
- un groupe n’apparaît que s’il existe réellement dans le canon.

## D02 — Conversation individuelle

Surface principale du jeu.

```text
header personnage
transcript persistant
bulles entrantes colorées
bulles Player constantes
images intégrées
indicateur de saisie
choix Player
séparateurs de jour
transition hors téléphone
```

Règles :

- personnage à gauche, Player à droite ;
- avatar et nom disponibles ;
- une à trois réponses par défaut ;
- un choix produit exactement un message Player ;
- historique long scrollable ;
- retour exact à la position de lecture ;
- aucune route, score ou raison technique visible.

## D03 — Conversation de groupe

Règles :

- nom et avatar de l’auteur visibles ;
- couleur propre à chaque participant ;
- voix identiques à celles des fils privés ;
- image partagée et séparateur de non-lus possibles ;
- aucun personnage absent ajouté pour remplir l’écran.

## D04 — Transition hors téléphone

Fonction : signaler une rencontre ou activité physique sans rejouer un dialogue oral.

```text
personne présente
lieu
heure de début
temps écoulé si utile
conversation suspendue
```

Règles :

- le chat direct s’arrête automatiquement ;
- aucun message ou choix oral pendant la co-présence ;
- aucune durée future inventée ;
- la reprise textuelle exige une séparation réelle ;
- aucun bouton ne force la fin de la rencontre ;
- la transition n’est ni une archive rejouable ni un rapport de scène.

## D05 — Photo ouverte

Fonction : afficher une image en grand depuis un fil ou la Galerie.

```text
image
retour vers la provenance
source ou personnage
date et contexte discrets
état d’accès
navigation précédente / suivante si Galerie
```

Actions conditionnelles futures :

```text
consulter les informations
ajouter à la Galerie si le runtime l’autorise
retirer de la Galerie locale si le runtime l’autorise
partager uniquement avec une permission explicite
```

Règles :

- aucune action de partage permanente ou générique ;
- une image peut être visible sans devenir un fichier diégétique ;
- une image retirée ne peut pas être rouverte ;
- une image verrouillée ne possède aucune miniature révélatrice ;
- le plein écran respecte la safe area et le ratio ;
- retirer une image n’efface jamais messages, faits vécus ou connaissances.

## D06 — Galerie par personnage

```text
header Galerie
onglets personnages scrollables
compteur discret
grille photo
navigation basse
```

Onglets principaux :

```text
Marie
Sandra
Mathilde
Pauline
Raphaëlle
Nico seulement si une collection cohérente existe
```

États canoniques :

```text
UNLOCKED  image accessible
NEW       image accessible + indicateur textuel
LOCKED    visuel neutre non révélateur
REMOVED   emplacement connu, accès perdu, seulement si utile
```

Dans le prototype local :

```text
state = UNLOCKED | LOCKED
is_new = true | false
VIEWED = UNLOCKED + is_new == false
```

Règles :

- organisation principale par personnage ;
- aucune rareté ou récompense de route ;
- aucun contenu exact révélé avant déblocage ;
- le compteur ne présente pas la complétion parfaite comme seule réussite ;
- un contenu retiré ne redevient pas accessible ;
- les messages liés restent présents selon le canon.

## D07 — Transition de journée

Fonction : rendre le temps lisible sans récapitulatif technique.

```text
nouveau jour
nom ou numéro du jour
date narrative
ambiance visuelle courte
notifications arrivées pendant l’absence
```

Règles :

- aucun résumé de route, score ou conséquence interne ;
- aucune notification sensible ;
- ordre d’ouverture choisi par le joueur ;
- écran bref et compatible reduced motion ;
- `Continuer` reste une validation d’écran, pas une décision narrative.

---

# 3. Écrans système canoniques différés

## S01 — Titre

```text
Continuer
Nouvelle partie
Charger
Paramètres
Crédits
Quitter
```

`Continuer` dépend d’une sauvegarde valide et ne révèle aucune progression sensible.

## S02 — Pause

```text
Reprendre
Sauvegarder
Charger
Paramètres
Retour au titre
```

Le téléphone narratif et les notifications sont figés. Une rencontre ne peut pas être forcée à se terminer depuis Pause.

## S03 — Sauvegarde / chargement

Cible :

```text
1 autosave contrôlé
3 à 5 sauvegardes manuelles
```

Résumé sûr : jour, heure, lieu non révélateur, date réelle, vignette sûre, état du slot.

Interdits : nom de route, pourcentage, secret actif, finale préparée ou état interne brut.

## S04 — Paramètres

Cibles :

- vitesse et affichage instantané ;
- taille de texte ;
- défilement automatique ;
- confirmation avant choix ;
- échelle UI ;
- contraste et réduction des effets ;
- audio ;
- navigation clavier ;
- palettes alternatives ;
- aucune limite de temps imposée.

## S05 — Première configuration Player

```text
prénom affiché
pronoms optionnels s’ils sont utilisés
confirmation
```

Aucun éditeur d’avatar au MVP.

## S05B — Avertissement de contenu

- fiction réservée aux adultes ;
- liste courte des thèmes matures ;
- déclaration locale d’âge ;
- refus permettant de quitter ;
- accès aux paramètres d’accessibilité.

## S06 — Confirmations

Cas minimum : sauvegarde, nouvelle partie, retour au titre, quitter et confirmation de choix si activée.

Toujours : action et conséquence claires, annulation visible, action destructive différenciée.

## S07 — Crédits et informations légales

Crédits, version, licences, avertissements et politique de contenu si nécessaire.

---

# 4. États transversaux

```text
LOADING
EMPTY
ERROR
DISABLED
LOCKED
REMOVED
NEW
READ_ONLY
LONG_TEXT
LARGE_TEXT
REDUCED_MOTION
HIGH_CONTRAST
KEYBOARD_NAVIGATION
CORRUPTED_SAVE
```

Cas critiques :

- fil très long sans perte de position ;
- absence de choix sans panneau vide ;
- texte agrandi avec choix empilés et Galerie à deux colonnes ;
- contenu retiré inaccessible sans effacer les faits vécus ;
- erreur non révélatrice avec retour ou nouvel essai.

---

# 5. Navigation

Barre diégétique :

```text
Messages
Galerie
```

Navigation photo :

```text
fil → photo → même fil
Galerie → photo → même Galerie
```

La provenance, le scroll et le focus sont conservés.

L’accès système complet est différé. Aucun onglet Profil vide.

---

# 6. État d’implémentation

## Implémenté et validé

```text
D01 D02 D03 D04 D05 D06 D07
```

Sous forme de cœur UI portrait additif avec données et images factices lorsque nécessaire.

## Canonique mais différé

```text
S01 S02 S03 S04 S05 S05B S06 S07
REMOVED
permissions Galerie
persistance Galerie
vrais assets
liaison runtime complète
```

---

# 7. Validation UI‑SCREENS

- [x] surfaces narratives définies ;
- [x] écrans système cadrés ;
- [x] Galerie organisée par personnage ;
- [x] verrouillages non révélateurs ;
- [x] choix et messages longs lisibles ;
- [x] aucune surface n’expose les routes ;
- [x] navigation vers la bonne provenance ;
- [x] retirer une image ne supprime ni messages ni connaissance ;
- [x] maquettes classées comme références conceptuelles ;
- [x] cœur diégétique implémenté et testé en portrait ;
- [ ] flux système final implémenté ;
- [ ] persistance et vrais assets intégrés.

```text
UI‑SCREENS : CANON VALIDÉ
CŒUR DIÉGÉTIQUE : IMPLÉMENTÉ ET VALIDÉ
ÉCRANS SYSTÈME : DIFFÉRÉS
PROCHAINE PRIORITÉ : PRODUCTION NARRATIVE
```
