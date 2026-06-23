# 05 — Règles des contenus visuels

## Principe

Le jeu apporte une grande partie de sa progression par des photos, vidéos, stories, captures, messages supprimés et contenus privés.

Règle centrale :

> Un contenu intime n’est jamais seulement une récompense. C’est aussi une preuve, un risque ou un outil de pouvoir.

## Paliers de contenu

```text
0 — Social
1 — Ambigu
2 — Suggestif
3 — Intime
4 — Explicite
5 — Preuve / conséquence
```

### Palier 0 — Social

Photos normales : selfie, photo de soirée, story, photo de groupe.

Fonction : installer l’attirance ou la jalousie.

### Palier 1 — Ambigu

Photo encore défendable, mais cadrage, moment ou message à double sens.

Fonction : faire douter le joueur.

### Palier 2 — Suggestif

La personne sait l’effet qu’elle produit.

Fonction : récompenser une route et renforcer le désir.

### Palier 3 — Intime

Contenu privé difficile à justifier.

Fonction : créer un vrai secret.

### Palier 4 — Explicite

Contenu sexuel ou mini-vidéo explicite réservé aux routes avancées.

Fonction : forte récompense, forte conséquence.

### Palier 5 — Preuve / conséquence

Contenu qui change l’histoire : capture, vidéo découverte, story compromettante, contenu utilisé pour confronter ou manipuler.

Fonction : bascule narrative.

## Règles par personnage

### Marie

Contenu de couple, reconquête, jalousie, NTR ou ouverture négociée.

Risque : si Marie donne de l’intimité pendant que Ludo collectionne les secrets, elle vit cela comme une humiliation.

### Mathilde

Contenu interdit dans la maison : vêtements de Marie, chambre d’amis, canapé, messages nocturnes.

Risque : même un contenu peu explicite peut être très grave parce qu’il vient du territoire de Marie.

### Sandra

Contenu rare, fragile, émotionnel, parfois supprimé ou regretté.

Risque : Sandra fuit si Ludo traite le contenu comme une preuve de conquête ou l’expose.

### Raphaëlle

Contenu doux, sincère, conditionné à la clarté.

Risque : elle coupe si Ludo veut recevoir sans assumer.

### Pauline

Contenu de provocation, piège, preuve ou jeu de pouvoir.

Risque : Pauline peut garder des captures ou utiliser les contenus comme levier.

### Nico

Contenu indirect autour de Marie : stories, réactions, photos de groupe, messages privés, preuves NTR.

Risque : augmente la jalousie de Ludo et la place de Nico auprès de Marie.

## Propriétés obligatoires d’un contenu

Chaque contenu visuel doit avoir :

```text
id
personnage
palier
type
source_app
contexte narratif
conditions de déblocage
risque
variables modifiées
est-ce une preuve ?
peut-il être supprimé ?
peut-il être découvert ?
qui peut le découvrir ?
```

## Actions joueur sur un contenu

Selon le contexte, le joueur peut :

- ouvrir ;
- ignorer ;
- répondre ;
- demander plus ;
- conserver ;
- supprimer ;
- capturer ;
- montrer à quelqu’un ;
- mentir à son sujet ;
- avouer son existence.

## Galerie

La galerie ne doit pas être uniquement une collection. Elle doit garder le contexte.

Catégories proposées :

```text
Photos reçues
Vidéos reçues
Stories
Captures
Preuves
Archives supprimées
Contenus de route
```

## Placeholders

Pendant la préproduction et le prototype, utiliser des assets neutres nommés clairement.

Exemples :

```text
photo_mathilde_tier2_placeholder.png
video_pauline_tier4_placeholder.mp4
story_marie_nico_tier1_placeholder.png
```

## Limites de production

Tous les personnages représentés dans les contenus adultes sont majeurs. Les contenus explicites doivent être réservés aux routes où les personnages sont clairement engagés dans une dynamique fictionnelle consentie. Les contenus de preuve, de jalousie ou de manipulation peuvent exister narrativement, mais ils doivent être traités comme des éléments à conséquence et non comme des actes banalisés.