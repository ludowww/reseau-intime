# Réseau Intime — UI‑01 — Système vertical smartphone

## Statut

**Catégorie : Canon UX/UI actif**

**Périmètre : résolution, responsive, langage visuel, couleurs et composants communs**

**Autorité : cible visuelle et ergonomique de la future interface portrait**

---

# 1. North Star UI

```text
Le joueur doit avoir l’impression d’utiliser
un téléphone intime, élégant et vivant,
pas de naviguer dans un menu de routes.
```

L’interface doit être :

- verticale ;
- lisible ;
- immersive ;
- discrètement anime-inspired ;
- centrée sur les messages et les images ;
- expressive sans devenir décorative au détriment du texte.

---

# 2. Format cible

## Viewport de référence futur

```text
720 × 1280
ratio 9:16
orientation portrait verrouillée
```

Ce viewport sert d’unité de conception.

Les assets finaux peuvent être produits à une résolution supérieure.

## Résolutions de validation

```text
720 × 1280
1080 × 1920
1080 × 2340 environ
fenêtre PC portrait redimensionnable
```

## État actuel

Le projet Godot utilise encore :

```text
1280 × 720 horizontal
```

Le passage en portrait est un futur lot technique explicite.

---

# 3. Safe areas et marges

À l’échelle de référence :

```text
marge horizontale minimale : 24
zone haute minimale : 32 + safe area système
zone basse minimale : 48 + safe area système
espacement vertical standard : 12 / 16 / 24
```

Règles :

- aucun bouton essentiel sous une encoche ou barre système ;
- la navigation basse suit la safe area ;
- les choix ne masquent jamais le dernier message ;
- les images peuvent être bord à bord uniquement dans une zone prévue ;
- un écran plus haut ajoute de l’espace ou du contenu visible, jamais des composants étirés arbitrairement.

---

# 4. Responsive

## Principe

```text
largeur gouverne les composants
hauteur gouverne la quantité visible
```

## Conversation

- header fixe ;
- liste centrale scrollable ;
- zone de choix ou de saisie fixe ;
- retour exact à la position précédente ;
- image redimensionnée sans dépasser la largeur utile ;
- longs messages enveloppés ;
- aucune largeur fixe dépendant d’un appareil précis.

## Galerie

- trois colonnes à la largeur de référence si les miniatures restent lisibles ;
- deux colonnes en mode accessibilité ou fenêtre étroite ;
- onglets personnages horizontalement scrollables ;
- aucune miniature étirée ;
- ratio de tuile stable par collection.

---

# 5. Direction visuelle

## Style

```text
anime-inspired
+ sombre nocturne
+ premium
+ contrasté
+ légèrement romantique
```

Interdits :

- photoréalisme obligatoire ;
- néons saturés partout ;
- surcharge de particules ;
- effets qui réduisent la lisibilité ;
- esthétique RPG ;
- écran de score ;
- badges de rareté de type gacha.

## Fonds

Les fonds peuvent utiliser :

- bleu nuit ;
- violet très sombre ;
- silhouettes de ville ;
- végétation discrète ;
- lumière de La Verrière ;
- motifs propres à un lieu ou personnage.

Le fond ne doit jamais concurrencer le texte.

---

# 6. Palette globale

```text
Background       #070A18
BackgroundDeep   #040611
Surface          #11182B
SurfaceRaised    #172039
Border           #2A3150
TextPrimary      #F3F0FA
TextSecondary    #AAA6BC
TextMuted        #77758A
PlayerAccent     #8D63E6
Focus            #B58AFF
Success          #5AC58B
Warning          #F1A34A
Danger           #E56278
```

Ces valeurs servent de cible de conception et devront être vérifiées dans Godot sur les écrans réels.

---

# 7. Couleurs personnages

```text
Marie      #4F8BFF  bleu
Sandra     #20C7C9  turquoise
Mathilde   #F5A33B  ambre
Pauline    #F05B9D  rose
Raphaëlle  #5FD17C  vert
Nico       #8EA3D1  ardoise
Groupes    #B274F4  violet
Player     #8D63E6  violet désaturé
```

## Usage

La couleur peut apparaître dans :

- anneau d’avatar ;
- point d’état ;
- filet de carte ;
- nom dans un groupe ;
- bulle entrante ;
- badge non-lu ;
- focus clavier/manette.

Elle ne doit pas remplir toute la page.

## Accessibilité

La couleur n’est jamais le seul identifiant.

Toujours conserver au moins deux éléments parmi :

- avatar ;
- nom ;
- position gauche/droite ;
- forme ou filet ;
- icône.

---

# 8. Typographie

La direction peut combiner :

- une police de titre élégante ;
- une police sans-serif très lisible pour messages et contrôles.

À l’échelle de référence :

```text
Titre écran       36–44
Nom conversation  24–30
Corps message      20–24
Choix              19–22
Métadonnée         14–17
```

Règles :

- taille de texte réglable ;
- aucune information critique sous 14 unités ;
- hauteur de ligne généreuse ;
- contraste renforcé disponible ;
- éviter l’italique pour les longs textes ;
- les timestamps restent secondaires mais lisibles.

---

# 9. Composants principaux

## `ConversationCard`

Contient :

```text
avatar
nom
aperçu
heure
non_lu_count ou état discret
accent personnage
```

Aucun résumé de route.

## `MessageBubble`

Contient :

```text
auteur
texte ou média
heure
état d’envoi Player si utile
accent d’identité
```

En conversation individuelle :

```text
personnage à gauche
Player à droite
```

En groupe : nom et couleur restent visibles.

## `ChoiceBar`

- une à trois réponses par défaut ;
- boutons empilés si texte long ;
- confirmation optionnelle via paramètres ;
- aucune limite de temps par défaut ;
- ne masque pas le transcript.

## `GalleryTile`

États :

```text
unlocked
new
locked
removed
```

Une tuile verrouillée ne révèle pas le contenu exact.

## `CharacterTab`

- avatar ;
- nom ;
- couleur ;
- compteur facultatif ;
- scroll horizontal ;
- Nico inclus seulement pour ses contenus réellement prévus.

## `SystemModal`

Utilisée pour :

- écrasement de sauvegarde ;
- suppression ;
- nouvelle partie ;
- retour au titre ;
- quitter sans sauvegarder.

---

# 10. Navigation MVP

Navigation diégétique principale :

```text
Messages
Galerie
```

Le menu système est accessible par :

- un bouton menu ;
- la touche pause ;
- un geste ou bouton retour selon plateforme.

L’onglet `Profil` est différé.

Il ne doit pas être implémenté comme placeholder vide.

---

# 11. Mouvement et feedback

Animations autorisées :

- apparition de message ;
- indicateur de saisie ;
- notification ;
- déverrouillage de photo ;
- transition de journée ;
- changement d’onglet ;
- focus.

Règles :

- durée courte ;
- aucune animation bloquante ;
- mode réduit ;
- possibilité d’affichage instantané ;
- pas de vibration ou flash obligatoire.

---

# 12. Critères d’acceptation UI‑01

- [ ] le système est conçu en portrait ;
- [ ] la largeur ne dépend pas de 1280 × 720 ;
- [ ] chaque personnage possède un accent stable ;
- [ ] la couleur n’est pas le seul identifiant ;
- [ ] la galerie est une grille par personnage ;
- [ ] Messages / Galerie suffisent au MVP ;
- [ ] les écrans système sont séparés du téléphone ;
- [ ] les choix restent visibles sans couvrir le fil ;
- [ ] les tailles et zones tactiles sont accessibles ;
- [ ] aucun mécanisme narratif interne n’est exposé.
