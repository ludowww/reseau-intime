# Réseau Intime — UI‑01 — Système vertical smartphone

## Statut

**Catégorie : Canon UX/UI actif**

**Périmètre : résolution, responsive, langage visuel, couleurs et composants communs**

**Autorité : cible visuelle et ergonomique du téléphone narratif**

**Implémentation : cœur portrait validé sur `main`, flux final encore partiel**

---

# 1. North Star UI

```text
Le joueur doit avoir l’impression d’utiliser
un téléphone intime, élégant et vivant,
pas de naviguer dans un menu de routes.
```

L’interface est verticale, lisible, immersive, sombre, centrée sur les messages et les images, sans exposer les mécanismes internes.

---

# 2. Format cible et état implémenté

```text
référence : 720 × 1280
ratio : 9:16
orientation : portrait
```

Matrice validée :

```text
720 × 1280
1080 × 1920
1080 × 2340
safe areas : none / tall-portrait
reduced motion : true / false
navigation clavier
```

Le cœur UI portrait est implémenté de manière additive dans des scènes dédiées. Le dépôt conserve encore un contrôle historique `1280 × 720`, un runtime narratif non entièrement migré et des écrans système différés.

Le portrait n’est plus un futur lot à démarrer. Il est un prototype validé à préserver pendant la reprise narrative.

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
- les images ne dépassent jamais leur zone utile ;
- un écran plus haut ajoute de l’espace visible sans étirement arbitraire.

---

# 4. Responsive

```text
largeur gouverne les composants
hauteur gouverne la quantité visible
```

## Conversation

- header fixe ;
- liste centrale scrollable ;
- zone de choix fixe ;
- retour exact à la position précédente ;
- images contenues dans la largeur utile ;
- longs messages enveloppés.

## Galerie

- trois colonnes lorsque la largeur le permet ;
- deux colonnes en fenêtre étroite ;
- onglets personnages scrollables ;
- ratio de tuile stable ;
- état verrouillé non révélateur ;
- indicateur `Nouveau` textuel.

## PhotoViewer

- plein espace utile dans la safe area ;
- image 3:4 sans crop ;
- retour vers la provenance ;
- précédente / suivante uniquement depuis Galerie ;
- contrôles sous-jacents masqués pendant l’ouverture.

---

# 5. Direction visuelle

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
- effets réduisant la lisibilité ;
- esthétique RPG ;
- écran de score ;
- badges de rareté.

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

Ces valeurs sont la cible canonique. Les variations locales du prototype ne créent pas une seconde palette produit.

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

La couleur n’est jamais le seul identifiant. Toujours conserver au moins deux éléments parmi avatar, nom, position, forme et icône.

---

# 8. Typographie

```text
Titre écran       36–44
Nom conversation  24–30
Corps message      20–24
Choix              19–22
Métadonnée         14–17
```

Règles :

- aucune information critique sous 14 unités ;
- hauteur de ligne généreuse ;
- contraste renforcé prévu ;
- timestamps secondaires mais lisibles.

---

# 9. Composants principaux

## `ConversationCard`

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

```text
auteur
texte ou média
heure
accent d’identité
```

Personnage à gauche, Player à droite. En groupe, nom et couleur restent visibles.

## `ChoiceBar`

- une à trois réponses par défaut ;
- boutons empilés si texte long ;
- aucune limite de temps par défaut ;
- ne masque pas le transcript.

## `GalleryTile`

États canoniques :

```text
UNLOCKED
NEW
LOCKED
REMOVED
```

Dans le prototype local, `VIEWED` est dérivé de `UNLOCKED + is_new == false`. Une tuile verrouillée ne révèle pas le contenu exact.

## `CharacterTab`

- avatar ;
- nom ;
- couleur ;
- compteur facultatif ;
- scroll horizontal ;
- Nico seulement si une collection cohérente existe.

---

# 10. Navigation

Navigation diégétique principale :

```text
Messages
Galerie
```

Le menu système reste une cible distincte. L’onglet `Profil` est différé et ne doit pas apparaître comme placeholder vide.

---

# 11. Mouvement et feedback

Animations autorisées :

- apparition de message ;
- indicateur de saisie ;
- notification ;
- transition de journée ;
- changement d’onglet ;
- focus.

Règles : durée courte, aucune animation bloquante, mode réduit, pas de vibration ou flash obligatoire.

---

# 12. Checkpoint UI‑01

## Implémenté et validé

- [x] système conçu en portrait ;
- [x] résolutions portrait testées ;
- [x] accents personnages stables ;
- [x] couleur accompagnée d’autres identifiants ;
- [x] Galerie en grille par personnage ;
- [x] Messages / Galerie fonctionnels ;
- [x] choix visibles sans couvrir le fil ;
- [x] zones tactiles cohérentes ;
- [x] aucun mécanisme interne exposé ;
- [x] safe areas, reduced motion et clavier testés.

## Canonique mais différé

- [ ] écrans système complets ;
- [ ] paramètres de texte et contraste dans le flux final ;
- [ ] intégration des vrais assets ;
- [ ] persistance Galerie et sauvegarde.

```text
UI‑01 : CIBLE CANONIQUE ACTIVE
CŒUR PORTRAIT : IMPLÉMENTÉ ET VALIDÉ
EXTENSION UI : GELÉE PAR DÉFAUT
```
