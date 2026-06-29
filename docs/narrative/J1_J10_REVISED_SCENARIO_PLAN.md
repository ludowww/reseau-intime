# Plan scénario révisé — J1 à J10

## Statut

Document de synthèse construit après les arcs dédiés :

```text
PLAYER_ARC_J1_J10.md
MARIE_ARC_J1_J10.md
SANDRA_ARC_J1_J10.md
MATHILDE_ARC_J1_J10.md
PAULINE_ARC_J1_J10.md
RAPHAELLE_ARC_J1_J10.md
ROUTE_COMPATIBILITY_MATRIX.md
ROUTE_STATE_MODEL.md
ANTI_LOOP_RULES.md
```

Objectif : reposer la trame J1-J10 avant toute réécriture de J5/J6 et avant tout J7 runtime.

## Position actuelle

```text
J1-J4 : base narrative utilisable mais à relire avec le nouveau plan.
J5-J6 : techniquement intégrés, narrativement provisoires.
J7 : à ne pas écrire tant que J5/J6 ne sont pas refondus.
```

## Question dramatique globale

```text
Player aime être désiré et découvre qu’il peut troubler.
Marie sent que le couple vacille et refuse d’être exclue du réel.
La question n’est plus seulement : Player va-t-il céder ?
La question devient : quel cadre, quel mensonge ou quelle ouverture naît de ce désir partagé ?
```

## États narratifs cibles

### J1 — Reconnexion et désir d’être vu

Pivot : Sandra rouvre la porte par une photo légère liée aux retrouvailles au restaurant.

Personnages moteurs : Sandra, Marie en fond de couple stable.

Ce qui change : Player comprend qu’il aime être attendu et regardé par quelqu’un d’extérieur au couple.

Scène pivot : Sandra envoie une photo récente, officiellement pour qu’il la reconnaisse au restaurant.

Réponse Player à prévoir : flatterie légère, prudence, allusion au manque ou évitement.

État final :

```text
couple_state: stable
player_posture: curious / romanticizing possible
sandra_trust: active légère
```

Motif interdit ensuite : simple nostalgie sans conséquence.

### J2 — Restaurant Sandra et première trace douce

Pivot : retrouvailles au restaurant + photo commune.

Personnages moteurs : Sandra, Player.

Ce qui change : le lien Sandra sort du téléphone et devient un souvenir réel.

Scène pivot : Sandra envoie ou commente la photo du restaurant ; ils ont l’air trop à l’aise ensemble.

Réponse Player à prévoir : dire que le moment lui a fait du bien, la flatter, ou première allusion “ton copain a de la chance”.

État final :

```text
sandra_trust: tension installée
proof_state restaurant_photo: soft_trace
player_posture: romanticizing / partial_truth
```

Motif interdit : Sandra comme attente passive.

### J3 — Mathilde entre par le jeu domestique

Pivot : Player prend légèrement le parti de Mathilde dans une chamaillerie avec Marie.

Personnages moteurs : Marie, Mathilde, Player.

Ce qui change : Mathilde sent que Player peut la choisir symboliquement contre Marie.

Scène pivot : petite dispute domestique ; Player appuie Mathilde ; elle le relance plus tard avec photo innocente à détail troublant.

Réponse Player à prévoir : taquinerie, aveu qu’il aime quand elle gagne, ou rappel de limite liée à Marie.

État final :

```text
mathilde_domestic_risk: active légère
mathilde_loyalty_conflict: active légère
couple_state: stable mais première vibration
```

Motif interdit : sexualiser Mathilde sans Marie dans l’angle.

### J4 — Soirée Pauline / exposition sociale

Pivot : Pauline orchestre une soirée et photographie les tensions.

Personnages moteurs : Pauline, Marie, Mathilde, Nico, Sandra en contretemps.

Ce qui change : Player perd le contrôle de ce qui est visible. Pauline capte des preuves faibles. Marie devient visible ailleurs.

Scènes pivots :

```text
- Pauline organise et cadre.
- Marie est regardée par Nico.
- Mathilde est complice dans le groupe.
- Sandra écrit au mauvais moment.
- Pauline prend trop de photos.
```

Réponse Player à prévoir : jalousie, dissimulation, curiosité, début de perte de contrôle.

État final :

```text
couple_state: suspicious seed
pauline_control: active légère
nico_mirror: active légère
proof_state party_photos: weak_proof / social_proof
```

Motif interdit : soirée comme simple décor.

### J5 — Marie comprend que le couple vacille

Pivot principal : Marie ne demande plus seulement attention ; elle nomme le danger du couple.

Personnages moteurs : Marie, Pauline.

Ce qui change : Marie devient active. Pauline confronte doucement Player. Les preuves deviennent relationnelles, pas seulement visuelles.

Scène pivot Marie :

```text
Marie dit qu’elle sent quelque chose bouger entre eux.
Elle refuse d’être la dernière à comprendre son propre couple.
```

Scène pivot Pauline :

```text
Pauline dit qu’elle comprend que Player puisse regarder ailleurs.
Elle n’est pas juge, elle est déjà compromise.
Elle peut envoyer un selfie provoque contrôlé par elle.
```

Réponses Player à prévoir :

```text
- vérité partielle : je suis troublé / j’aime être désiré ;
- mensonge : ce n’est rien ;
- ouverture : je ne sais pas si on doit tout fermer ;
- provocation avec Pauline : entrer dans son jeu.
```

État final selon choix :

```text
truth path: couple_state → truth_discussion
lie path: couple_state → suspicious / revenge seed
pauline path: pauline_control → tension installée
open seed: couple_state → open_discussion seed
```

Motifs interdits :

```text
- pose ton téléphone ;
- Marie seulement blessée ;
- Pauline seulement “j’ai une photo”.
```

### J6 — Acte concret de Player

Pivot : Player agit. Il ne doit plus seulement être analysé.

Personnages moteurs : Player, Marie, Mathilde ou Sandra selon variante.

Ce qui change : un choix Player modifie réellement une compatibilité de route.

Actes possibles à choisir pour la version runtime :

```text
- supprimer une trace Mathilde ;
- garder une trace et mentir ;
- dire à Marie qu’il aime être désiré ailleurs ;
- accepter ou refuser un défi Pauline ;
- donner à Sandra un vrai moment plutôt qu’un “plus tard”.
```

Scène pivot recommandée :

```text
Player doit choisir quoi faire d’une trace Mathilde pendant que Marie demande une vérité.
```

Pourquoi : cela relie couple, maison, preuve, mensonge et désir en un seul acte.

État final selon choix :

```text
delete/limit: reconnection seed, mathilde_loyalty_conflict +, pauline_control -
keep/lie: suspicious → broken_trust seed, mathilde_domestic_risk +, pauline_control +
honest: truth_discussion → open_discussion possible, raphaelle_clarity +
provocative: chaos_desire seed, pauline_control +, marie_revenge +
```

Motifs interdits :

```text
- répétition du téléphone ;
- Sandra “plus tard” sans changement ;
- Raphaëlle “je ne suis pas une cachette” répété ;
- Mathilde “tu as gardé la photo ?” sans décision.
```

### J7 — Conséquence du choix Player

Pivot : le monde réagit à l’acte concret de J6.

Personnages moteurs : Sandra ou Mathilde selon J6, plus Marie en réaction.

Deux scènes possibles :

```text
Sandra lance soirée confidences si Player lui a donné un vrai moment ou vérité.
Mathilde relance par chamaillerie / photo volée ludique si Player a gardé le jeu domestique.
```

Ce qui change : une route secondaire cesse d’être motif et devient mécanique relationnelle.

Sandra : confidence/photo, valorisation, confiance.

Mathilde : photo volée ludique, récupération de contrôle, jeu partagé.

État final :

```text
sandra_trust ou mathilde_domestic_risk passe à risque clair.
Marie perçoit ou ressent une variation de disponibilité.
```

Motif interdit : relancer toutes les filles le même jour.

### J8 — Marie agit ou Raphaëlle ouvre une voie claire

Pivot A : Marie utilise Nico si Player a menti.

Pivot B : Raphaëlle propose une marche si Player a choisi vérité/clarté.

Ce qui change : la route se polarise.

Route mensonge :

```text
Marie drague Nico ou accepte son regard pour rendre Player jaloux.
Player découvre son propre double standard.
```

Route clarté :

```text
Raphaëlle sort du cadre travail par une marche.
Le désir n’avance que si Player reste clair.
```

État final :

```text
lie path: couple_state → revenge / cold_war
truth path: raphaelle_clarity → tension installée, couple_state → open_discussion possible
```

Motif interdit : Nico comme rival caricatural ; Raphaëlle comme thérapeute.

### J9 — Proximité nocturne / prix du silence

Pivot A : Mathilde appelle Player la nuit pour une araignée.

Pivot B : Pauline demande ce que son silence vaut.

Ce qui change : la tension devient plus concrète et coûteuse.

Mathilde :

```text
scène nocturne, petite tenue, photo ludique ou photo récompense.
Le tactile devient naturel, mais Marie reste moralement présente.
```

Pauline :

```text
chantage ludique / défi du silence.
Le contrôle devient transactionnel, ou sa fragilité apparaît.
```

État final :

```text
mathilde_domestic_risk → conséquence ouverte
pauline_control → risque clair / conséquence ouverte
proof_state → weaponized ou shared_by_consent selon route
```

Motif interdit : voyeurisme non consenti traité comme sexy ; chantage brutal.

### J10 — La règle du couple

Pivot : Marie force une discussion sur les règles.

Ce qui change : premier verrou relationnel léger.

Marie peut dire :

```text
Je peux entendre qu’on ne soit pas faits pour tout fermer.
Mais je refuse d’être la dernière à savoir que la porte est ouverte.
```

Choix Player :

```text
- sauver le couple fermé ;
- proposer une ouverture ;
- accepter que Marie ait aussi ses possibles ;
- continuer à mentir ;
- reconnaître qu’il ne sait pas choisir.
```

États finaux possibles :

```text
reconnection
open_discussion
open_agreed seed
cold_war
broken_trust
chaos_desire
```

Motif interdit : confrontation finale définitive trop tôt.

## Priorités de réécriture

### Priorité 1 — J5

J5 doit devenir :

```text
Marie active + Pauline dangereusement compréhensive.
```

Supprimer ou remplacer :

```text
- téléphone comme sujet principal ;
- “plus tard” Sandra comme pivot principal ;
- Raphaëlle cachette comme répétition ;
- Pauline distributeur de photos.
```

### Priorité 2 — J6

J6 doit devenir :

```text
acte concret de Player.
```

Le jour ne doit être validé que si Player fait au moins une chose :

```text
mentir clairement ;
avouer ;
effacer ;
garder ;
proposer un cadre ;
entrer dans un défi ;
poser une limite.
```

### Priorité 3 — J7+

Ne pas écrire J7 tant que :

```text
- J5 a un couple_state clair en fin de journée ;
- J6 a un acte concret ;
- au moins une route monte et une route recule ;
- Player répond visiblement dans les scènes fortes.
```

## Règle de validation narrative

Une journée est valide si elle répond clairement :

```text
Qu’est-ce qui n’était pas vrai la veille et devient vrai aujourd’hui ?
```

Pour J5 :

```text
Marie sait que le couple est en danger et commence à agir.
```

Pour J6 :

```text
Player ne peut plus prétendre qu’il ne fait que regarder : il a agi.
```
