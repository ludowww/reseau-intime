# Réseau Intime — UI_02 — Architecture finale des écrans et états

## Statut

**Catégorie : Canon UX/UI actif**

**Lot : UI‑SCREENS validé**

**Périmètre : écrans narratifs, écrans système, navigation et états secondaires**

**Autorité : inventaire fonctionnel final avant intégration**

Les maquettes produites sont des références conceptuelles. Le présent document fait autorité sur leurs détails accidentels.

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

Les deux couches partagent la même direction sombre et anime-inspired, mais ne sont jamais confondues narrativement.

---

# 2. Écrans diégétiques validés

## D01 — Liste des conversations

### Fonction

Donner accès aux fils actifs sans présenter de routes.

### Contenu minimum

```text
header Messages
conversation cards
aperçu du dernier message
heure
non-lus
notification compacte
navigation Messages / Galerie
```

### Règles

- une ligne visible par personnage ou groupe ;
- les épisodes internes restent dans le même fil ;
- couleur, avatar et nom identifient ensemble l’auteur ;
- l’ordre dépend de l’activité utile, jamais d’une valeur de route ;
- un fil refusé ou expiré ne reste pas artificiellement en attente ;
- un groupe n’apparaît que s’il existe réellement dans le canon.

## D02 — Conversation individuelle

### Fonction

Surface principale du jeu.

### Contenu minimum

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

### Règles

- personnage à gauche, Player à droite ;
- avatar et nom restent disponibles ;
- une à trois réponses par défaut ;
- un choix produit exactement un message Player ;
- aucun message Player important n’est automatique ;
- historique long scrollable ;
- retour exact à la bonne position de lecture ;
- aucune route, score ou raison technique visible.

## D03 — Conversation de groupe

### Fonction

Rendre le réseau social lisible sans homogénéiser les voix.

### Règles

- nom et avatar de l’auteur visibles ;
- couleur propre à chaque participant ;
- aucune couleur neutre unique pour tout le groupe ;
- les voix restent identiques à celles des fils privés ;
- image partagée et séparateur de non-lus possibles ;
- aucun personnage absent n’est ajouté pour remplir l’écran.

## D04 — Transition hors téléphone

### Fonction

Signaler une rencontre ou une activité physique sans rejouer un dialogue oral.

### Informations possibles

```text
personne présente
lieu
heure de début
temps écoulé si utile
conversation suspendue
```

### Règles

- le chat direct s’arrête automatiquement ;
- aucun message ne peut être envoyé pendant la co-présence ;
- aucun choix oral n’est affiché ;
- aucune notification entrante n’est simulée dans le fil actif ;
- aucune durée future n’est inventée ;
- la reprise textuelle exige une séparation réelle ;
- il n’existe aucun bouton permettant de forcer la fin de la rencontre.

La transition ne constitue ni une archive rejouable ni un rapport de scène.

## D05 — Photo ouverte

### Fonction

Afficher une image en grand depuis un fil ou la Galerie.

### Contenu minimum

```text
image
retour vers la provenance
source ou personnage
date et contexte discrets
état d’accès
navigation précédente / suivante si Galerie
```

### Actions conditionnelles

```text
consulter les informations
ajouter à la Galerie si le runtime l’autorise
retirer de la Galerie locale si le runtime l’autorise
partager uniquement avec une permission narrative explicite
```

### Règles

- aucune action de partage permanente ou générique ;
- une image de scène peut être visible sans devenir un fichier diégétique ;
- une image retirée ne peut pas être rouverte ;
- une image verrouillée ne possède aucune miniature spoiler ;
- le plein écran respecte la safe area et le ratio de l’image ;
- retirer une image n’efface jamais les messages, les faits vécus ou la connaissance déjà acquise.

## D06 — Galerie par personnage

### Structure

```text
header Galerie
onglets personnages scrollables
compteur discret
photo grid
navigation basse
```

### Onglets principaux

```text
Marie
Sandra
Mathilde
Pauline
Raphaëlle
Nico seulement si une collection cohérente existe
```

### États de tuile

```text
UNLOCKED  image visible
NEW       image visible + indicateur discret
LOCKED    visuel neutre non révélateur + cadenas
REMOVED   emplacement connu, accès perdu, seulement si utile
```

### Règles

- organisation principale par personnage ;
- aucun onglet primaire `Privé / Public / Souvenir` ;
- aucune rareté ;
- aucune récompense de route affichée ;
- aucun contenu exact révélé avant déblocage ;
- le compteur n’impose pas la complétion parfaite comme seule bonne manière de jouer ;
- un contenu retiré ne redevient jamais accessible par la Galerie ;
- les messages liés à un contenu retiré restent présents selon le canon du fil.

## D07 — Transition de journée

### Fonction

Rendre le temps lisible sans récapitulatif technique.

### Contenu possible

```text
nouveau jour
nom ou numéro du jour
date narrative
ambiance visuelle courte
notifications arrivées pendant l’absence
```

### Règles

- aucun résumé de route, score ou conséquence interne ;
- aucune notification ne révèle un contenu sensible ;
- l’ordre d’ouverture reste choisi par le joueur ;
- l’écran reste bref et compatible avec animations réduites ;
- une action `Continuer` est autorisée comme simple validation d’écran, jamais comme bouton de progression ou de planification ;
- l’écran peut se fermer automatiquement selon le réglage d’accessibilité.

---

# 3. Écrans système validés

## S01 — Écran titre

Actions MVP :

```text
Continuer
Nouvelle partie
Charger
Paramètres
Crédits
Quitter
```

Règles :

- `Continuer` charge la dernière sauvegarde valide ;
- `Continuer` est masqué ou désactivé sans sauvegarde valide ;
- aucune branche ou progression intime n’est révélée ;
- l’avertissement adulte reste accessible sans encombrer l’écran principal.

## S02 — Menu pause

Actions :

```text
Reprendre
Sauvegarder
Charger
Paramètres
Retour au titre
```

Règles :

- panneau système distinct du téléphone ;
- le jeu et les notifications sont figés ;
- une sauvegarde manuelle peut être indisponible pendant une écriture critique, une transition ou une co-présence ;
- la reprise d’une rencontre ne peut pas être forcée depuis le menu pause.

## S03 — Sauvegarde / chargement

### Slots MVP

```text
1 sauvegarde automatique contrôlée
3 à 5 sauvegardes manuelles
```

### Résumé sûr

```text
jour narratif
heure ou moment
description de lieu non révélatrice
date réelle de sauvegarde
vignette sûre
état valide / corrompu
```

### Interdits

- nom de route ;
- pourcentage ;
- secret actif ;
- finale préparée ;
- contenu intime spoiler ;
- état interne brut.

### Règles

- l’autosave n’est pas déclenché au milieu d’une écriture critique ;
- un autosave peut être remplacé selon une politique runtime explicitement testée ;
- les sauvegardes manuelles restent distinctes ;
- écraser et supprimer exigent une confirmation ;
- une sauvegarde corrompue n’empêche pas l’accès aux autres slots ;
- l’erreur indique le slot concerné sans exposer de donnée sensible.

## S04 — Paramètres

### Texte et rythme

- vitesse d’apparition ;
- affichage instantané ;
- taille du texte ;
- défilement automatique ;
- indicateur de saisie ;
- confirmation avant choix.

### Affichage

- plein écran / fenêtré ;
- échelle UI ;
- luminosité ;
- contraste ;
- réduction des animations ;
- réduction des flashes ;
- effets de fond.

### Audio

- volume général ;
- musique ;
- ambiance ;
- notifications ;
- sons UI.

Aucune voix jouée n’est prévue.

### Accessibilité

- texte agrandi ;
- contraste renforcé ;
- animations réduites ou instantanées ;
- maintien de bouton pour confirmer ;
- navigation clavier complète ;
- palettes alternatives pour daltonisme ;
- couleur jamais utilisée seule ;
- aucune limite de temps imposée.

### Plateforme

- vibration et économie d’énergie sont conditionnelles à une future version Android ;
- elles ne sont pas obligatoires pour le MVP PC ;
- tout réglage nécessitant un redémarrage nomme précisément la conséquence.

## S05 — Première configuration Player

MVP :

```text
prénom affiché
pronoms optionnels seulement s’ils sont réellement utilisés
confirmation
```

Règles :

- le prénom remplace `Player` dans les textes prévus ;
- le prénom peut être modifié plus tard ;
- caractères invalides et longueur maximale sont explicités ;
- aucun éditeur d’avatar au MVP ;
- aucune information inutilisée n’est demandée.

## S05B — Avertissement de contenu

Écran distinct ou étape du premier lancement :

- fiction réservée aux adultes ;
- liste courte des thèmes matures ;
- déclaration locale `J’ai 18 ans ou plus` ;
- refus permettant de quitter proprement ;
- accès aux paramètres d’accessibilité avant l’entrée dans le jeu.

Cette déclaration n’est pas présentée comme une vérification légale d’identité.

## S06 — Confirmations système

Cas minimum :

- écraser une sauvegarde ;
- supprimer une sauvegarde ;
- nouvelle partie ;
- recommencer ;
- retour au titre ;
- quitter sans sauvegarder ;
- confirmer un choix si l’option est activée.

Toujours :

```text
action claire
conséquence claire
bouton annuler visible
action destructive différenciée
aucune validation automatique
```

## S07 — Crédits et informations légales

- crédits ;
- version ;
- licences ;
- avertissements ;
- politique de contenu si nécessaire.

Peut suivre le premier build vertical mais doit exister avant distribution publique.

---

# 4. États transversaux obligatoires

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

## Cas critiques

### Fil très long

- chargement sans perdre la position ;
- historique paginé ou virtualisé si nécessaire ;
- dernier message toujours atteignable.

### Aucun choix

- zone de choix absente ;
- aucun panneau vide ;
- attente ou transition expliquée par le comportement du fil.

### Texte agrandi

- choix empilés ;
- Galerie à deux colonnes ;
- header plus haut si nécessaire ;
- aucune troncature des décisions.

### Contenu retiré

- le fil peut conserver un message de retrait ;
- la Galerie ne restaure pas l’image ;
- les messages, faits vécus et connaissances ne sont jamais supprimés automatiquement ;
- seule l’accessibilité au fichier change.

### Chargement et erreur

- écran discret et non bloquant ;
- possibilité de réessayer ou revenir ;
- aucune donnée sensible dans le message d’erreur.

---

# 5. Navigation

## Barre diégétique MVP

```text
Messages
Galerie
```

## Accès système

- menu depuis D01 ;
- pause depuis tout écran narratif hors transition critique ;
- retour cohérent ;
- aucun onglet Profil vide.

## Navigation photo

```text
fil → photo → fil
Galerie → photo → Galerie
```

La provenance est mémorisée.

---

# 6. Priorités

## MVP critique

```text
D01 D02 D03 D04 D05 D06 D07
S01 S02 S03 S04 S05 S05B S06
```

## Après le premier build vertical

```text
S07 final
animations avancées
filtres secondaires de Galerie
personnalisation cosmétique
fonctionnalités Android spécifiques
```

---

# 7. Validation UI‑SCREENS

- [x] toutes les surfaces narratives nécessaires possèdent un écran ;
- [x] tous les écrans système nécessaires à un test fiable sont cadrés ;
- [x] la Galerie est organisée par personnage ;
- [x] les verrouillages ne spoilent pas ;
- [x] les choix et messages longs restent lisibles ;
- [x] le mode texte agrandi est prévu ;
- [x] aucune surface n’expose les routes ;
- [x] la sauvegarde ne révèle pas les états internes ;
- [x] les rencontres physiques respectent text-only ;
- [x] la navigation revient à la bonne provenance ;
- [x] retirer une image n’efface ni les messages ni la connaissance ;
- [x] les maquettes restent des références conceptuelles.

```text
UI‑SCREENS : VALIDÉ
PROCHAINE PHASE : UI‑HANDOFF
```
