# Réseau Intime — UI‑02 — Architecture des écrans et états

## Statut

**Catégorie : Canon UX/UI actif**

**Périmètre : écrans narratifs, écrans système, navigation et états secondaires**

**Autorité : inventaire fonctionnel des surfaces nécessaires au produit**

---

# 1. Deux couches distinctes

## Couche diégétique

Le téléphone utilisé dans l’histoire :

- Messages ;
- conversations ;
- images reçues ;
- Galerie ;
- notifications ;
- transitions de journée.

## Couche système

Le jeu lui-même :

- titre ;
- pause ;
- sauvegarde ;
- chargement ;
- paramètres ;
- confirmations ;
- crédits.

Les deux couches partagent une direction visuelle.

Elles ne doivent jamais être confondues narrativement.

---

# 2. Carte des écrans diégétiques

## D01 — Liste des conversations

### Fonction

Donner accès aux fils actifs sans présenter de routes.

### Contenu

```text
header Messages
marqueur de journée
conversation cards
non-lus
aperçus
heures
notification compacte
navigation basse
```

### Règles

- une ligne par personnage ou groupe ;
- les épisodes restent dans le même fil ;
- couleur d’identité stable ;
- ordre par activité utile, pas par valeur de route ;
- un fil refusé ne reste pas artificiellement en attente ;
- un groupe n’apparaît que s’il existe dans le canon du jour.

---

## D02 — Conversation individuelle

### Fonction

Surface principale du jeu.

### Contenu

```text
header personnage
jour / moment
transcript persistant
bulles
images intégrées
système typing
choix Player
transition hors téléphone
```

### Règles

- personnage à gauche ;
- Player à droite ;
- messages entrants colorés par personnage ;
- Player conserve une couleur constante ;
- avatar et nom restent disponibles ;
- choix une à trois réponses par défaut ;
- historique long scrollable ;
- retour exact à la dernière position ;
- aucun message Player automatique important.

---

## D03 — Conversation de groupe

### Fonction

Rendre le réseau social lisible sans homogénéiser les voix.

### Contenu

- nom du groupe ;
- participants ;
- auteur visible pour chaque message ;
- couleur propre à chaque auteur ;
- image partagée ;
- séparateur de non-lus ;
- réponse Player.

### Règles

- aucune couleur neutre unique pour tous les participants ;
- le nom reste visible même si l’avatar est affiché ;
- les messages de groupe utilisent les mêmes voix que les fils privés ;
- un personnage absent n’est pas ajouté pour remplir l’écran.

---

## D04 — Transition hors téléphone

### Fonction

Signaler qu’une rencontre ou activité physique commence sans rejouer un dialogue oral.

### Forme

Un séparateur intégré au fil :

```text
lieu
heure ou intervalle
conversation suspendue
```

Exemple :

```text
Vous vous retrouvez à La Verrière.
La conversation reprend après votre séparation.
```

### Règles

- le chat direct s’arrête ;
- aucun choix oral n’est affiché ;
- aucun résumé exhaustif de la scène ;
- l’événement reste porté par le canon et les conséquences ;
- la reprise textuelle exige une séparation réelle.

D04 n’est pas une page de rapport.

---

## D05 — Photo ouverte

### Fonction

Voir une image en grand depuis un fil ou la Galerie.

### Contenu

```text
image
retour
personnage ou source
jour
état d’accès discret
navigation précédente / suivante si galerie
```

### Règles

- les métadonnées narratives complexes restent internes ;
- les actions sauvegarder / partager n’apparaissent que si le produit les autorise réellement ;
- une image de scène peut être visible par le joueur sans être présentée comme fichier du téléphone ;
- une image retirée ne peut pas être rouverte depuis un fil ;
- le plein écran respecte la safe area et le ratio de l’image.

---

## D06 — Galerie par personnage

### Fonction

Présenter une collection photo claire et motivante.

### Structure

```text
header Galerie
onglets personnages
nom du personnage actif
compteur débloqué / total
photo grid
navigation basse
```

### Onglets

```text
Marie
Sandra
Mathilde
Pauline
Raphaëlle
Nico si contenu réel
```

Les onglets sont scrollables horizontalement.

### États de tuile

```text
UNLOCKED  image visible
NEW       image visible avec indicateur discret
LOCKED    silhouette / blur non révélateur + cadenas
REMOVED   emplacement connu mais accès perdu, seulement si utile produit
```

### Règles

- organisation principale par personnage ;
- pas d’onglets `Privé / Public / Souvenir` comme navigation primaire ;
- aucune rareté ;
- aucune récompense de route affichée ;
- une tuile verrouillée ne révèle ni nudité, ni scène, ni branche manquée ;
- le compteur ne doit pas imposer une complétion parfaite comme seule bonne manière de jouer ;
- les images de Nico peuvent être classées dans son onglet uniquement si le canon prévoit réellement une collection cohérente.

---

## D07 — Transition de journée

### Fonction

Rendre le temps lisible sans écran récapitulatif lourd.

### Forme

- date ou jour ;
- ambiance visuelle courte ;
- changement d’heure ;
- notifications qui apparaissent ensuite ;
- durée brève ou désactivable.

### Interdits

- résumé des routes ;
- liste des conséquences ;
- score ;
- écran vide nécessitant un bouton `Continuer` ;
- replay automatique de la journée.

---

# 3. Carte des écrans système

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

`Continuer` charge la dernière sauvegarde valide.

L’écran ne révèle aucune branche.

---

## S02 — Menu pause

Actions :

```text
Reprendre
Sauvegarder
Charger
Paramètres
Retour au titre
```

Le menu peut être un panneau superposé.

Il ne doit pas ressembler à une application du téléphone.

---

## S03 — Sauvegarde / chargement

### Slots MVP

```text
1 sauvegarde automatique
3 à 5 sauvegardes manuelles
```

### Résumé d’un slot

```text
jour narratif
heure ou moment
lieu / scène non révélatrice
date réelle de sauvegarde
vignette sûre
```

Exemple :

```text
J09 — Mercredi
La Verrière
18 juillet 2026 — 21:42
```

### Interdits

- nom de route ;
- pourcentage ;
- secret actif ;
- finale préparée ;
- image spoiler ;
- état interne brut.

### Actions

- charger ;
- écraser ;
- supprimer ;
- revenir ;
- confirmation obligatoire pour action destructive.

---

## S04 — Paramètres

### Texte et rythme

- vitesse d’apparition ;
- instantané ;
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
- réduction des flashes ;
- animations instantanées ;
- maintien de bouton pour confirmer ;
- couleur jamais utilisée seule ;
- durées non limitées.

---

## S05 — Première configuration Player

MVP possible :

```text
prénom affiché
pronoms si réellement utilisés
avertissement de contenu
confirmation
```

Un éditeur d’avatar est différé.

Le jeu ne doit pas demander des informations qui ne seront jamais utilisées.

---

## S06 — Modales de confirmation

Cas :

- écraser ;
- supprimer ;
- nouvelle partie ;
- retour au titre ;
- quitter sans sauvegarder ;
- confirmer un choix si option activée.

Toujours :

```text
action claire
conséquence claire
bouton annuler visible
action destructive différenciée
```

---

## S07 — Crédits et informations

- crédits ;
- version ;
- licences ;
- avertissements ;
- politique de contenu si nécessaire.

Peut être différé après le premier vertical slice, mais doit exister avant distribution publique.

---

# 4. États transversaux obligatoires

Chaque écran concerné doit prévoir :

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
```

## Cas critiques

### Fil très long

- chargement sans perdre la position ;
- historique paginé ou virtualisé si nécessaire ;
- dernier message toujours atteignable.

### Aucun choix

- zone de choix absente ;
- aucun panneau vide ;
- attente ou transition visible par le comportement du fil.

### Texte agrandi

- choix empilés ;
- galerie passe à deux colonnes ;
- header peut gagner en hauteur ;
- aucune troncature des décisions.

### Contenu retiré

- le fil peut conserver un emplacement ou message de retrait si narrativement nécessaire ;
- la Galerie ne restaure pas l’image ;
- la connaissance n’est pas affichée comme fichier.

---

# 5. Navigation

## Barre diégétique MVP

```text
Messages
Galerie
```

## Accès système

- bouton menu depuis D01 ;
- pause depuis tout écran narratif ;
- retour cohérent ;
- pas d’onglet Profil vide.

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
S01 S02 S03 S04 S05 S06
```

## Peut suivre le premier build vertical

```text
S07 final
animations avancées
filtres secondaires de galerie
personnalisation cosmétique
```

---

# 7. Critères de validation

- [ ] toutes les surfaces narratives nécessaires ont un écran ;
- [ ] tous les écrans système nécessaires à un test fiable existent ;
- [ ] la galerie est organisée par personnage ;
- [ ] les verrouillages ne spoilent pas ;
- [ ] les choix et messages longs restent lisibles ;
- [ ] le mode texte agrandi est prévu ;
- [ ] aucune surface n’expose les routes ;
- [ ] la sauvegarde ne révèle pas les états internes ;
- [ ] les rencontres physiques respectent text-only ;
- [ ] la navigation revient à la bonne provenance.
