# DECISION_007 — Direction J3-J5 : désir, tensions, contenus visuels et routes

## Statut

Validé pour cadrage produit et préparation d’écriture.

## Contexte

Après J1 et J2, le prototype possède une base data-first fonctionnelle :

- J1 verrouillé : Marie puis Sandra, Mathilde seulement indirecte ;
- J2 verrouillé : Marie, Raphaëlle, Mathilde, Sandra ;
- J2 final contient 4 contenus visuels ;
- Player reste un nom générique temporaire ;
- une ligne Messages correspond à un personnage ou groupe ;
- les épisodes internes restent dans le même fil ;
- pending / unread ne doivent apparaître qu’à l’initialisation du jour ou lors d’un vrai unlock.

La question suivante est de préparer J3-J5 sans transformer le jeu en arbre infini ni en simple suite de conversations sans désir.

## Décision

J3-J5 doivent être cadrés comme une montée commune :

```text
J3 — Retour maison / premiers secrets conscients / premier désir domestique visible
J4 — Soirée sociale / regards croisés / vertige des possibilités
J5 — Lendemain / première preuve faible / premières provocations conscientes
```

Le jeu doit rester un tronc commun qui nourrit plusieurs routes à la fois.

La règle validée est :

```text
Plus de densité par scène.
Pas plus de dispersion structurelle.
```

## Formule d’écriture validée

À partir de J3, chaque scène importante doit pouvoir être résumée ainsi :

```text
Quelqu’un désire.
Quelqu’un ment ou omet.
Quelqu’un peut voir.
Une image, un message ou une preuve peut rester.
```

Une scène qui ne contient qu’un échange fonctionnel sans désir, trace ou risque doit être renforcée ou supprimée.

## Direction des dialogues

Les dialogues doivent faire sentir, par moments :

- tension ;
- désir ;
- gêne ;
- mensonge ;
- omission ;
- provocation ;
- peur d’être vu ;
- envie de garder une trace ;
- regret ou culpabilité après coup.

Le ton peut évoluer selon la route :

```text
neutre
tendre
ambigu
provocant
séducteur
dangereux
coupable
jaloux
clair
```

Les personnages ne doivent pas écrire de la même manière si le joueur a nourri leur route.

## Direction des contenus visuels

Les photos doivent rester un moteur d’envie.

Une bonne photo doit créer trois envies contradictoires :

```text
l’ouvrir
la garder
ne pas se faire prendre
```

À partir de J3, chaque journée doit viser :

```text
1 photo réelle obtenable
1 photo conditionnelle
1 promesse visuelle ou trace
1 risque de preuve différée
```

Les contenus doivent progresser par paliers : social, ambigu, suggestif, intime plus tard si la route le justifie.

J3-J5 doivent surtout couvrir paliers 0 à 2, avec promesse de palier 3 plus tard.

## Direction par personnage

### Marie

Marie reste l’ancrage émotionnel et une route de désir.

Elle ne doit pas être réduite à l’obstacle ou à la jalousie.

Elle peut devenir plus tendre, plus inquiète, puis plus blessée selon la distance de Player.

### Mathilde

Mathilde porte l’interdit domestique.

Son désir passe par le décor de Marie : canapé, plaid, salon, cuisine, objets partagés.

Plus l’image est domestique, plus elle est risquée.

Elle doit pouvoir provoquer puis reculer par loyauté envers Marie.

### Sandra

Sandra porte le manque émotionnel.

Elle donne envie par rareté : message supprimé, photo presque envoyée, jeudi maintenu, phrase trop honnête puis corrigée.

Elle ne doit pas devenir une conquête facile.

### Raphaëlle

Raphaëlle porte la clarté.

Elle peut devenir désirable, mais seulement si Player accepte de sortir du flou.

Elle ne doit pas devenir un refuge secret ou un pansement.

### Pauline

Pauline porte la preuve sociale et la provocation.

Elle observe avant de piéger.

Détail validé : Pauline a trompé son copain. Des preuves photo ou message peuvent exister et devenir un levier narratif.

Pauline menace donc les secrets de Player tout en ayant elle-même quelque chose à cacher.

### Nico

Nico porte la symétrie et la jalousie.

Il ne doit pas être seulement le rival lourd.

Il révèle l’hypocrisie possible de Player : Player désire ailleurs mais supporte mal que Marie soit désirée.

## Moment de convergence

J4 fin de soirée ou J5 début de journée doit préparer un moment où plusieurs possibilités semblent s’ouvrir presque en même temps.

Exemple de structure :

```text
Marie demande à Player de revenir vers elle.
Sandra écrit au mauvais moment.
Mathilde fait comprendre qu’elle a vu quelque chose.
Pauline envoie une photo.
Nico réagit à une story de Marie.
Raphaëlle peut apparaître ensuite comme contrepoint de clarté.
```

Le joueur doit sentir qu’il peut tout poursuivre, mais pas sans coût.

## Garde-fous

À éviter :

```text
photos explicites trop tôt
routes sexuelles immédiates
tous les personnages disponibles au même rythme
Pauline manipulatrice cartoon
Nico méchant simple
Sandra trop directe
Mathilde sans culpabilité envers Marie
Raphaëlle pansement émotionnel
Marie réduite à la jalousie
```

À renforcer :

```text
photos conditionnelles
promesses visuelles
messages supprimés
tons évolutifs
provocation si route nourrie
désir visible dans Marie
preuve Pauline
convergence des notifications
```

## Référence

Voir : `docs/J3_J5_Desire_Tension_Visual_Routes_Spec.md`.

## Conséquence immédiate

La prochaine brique utile est `docs/J3_WRITING_FOUNDATION.md`, pour transformer cette direction en structure de scènes J3 directement exploitable avant intégration data-first.
