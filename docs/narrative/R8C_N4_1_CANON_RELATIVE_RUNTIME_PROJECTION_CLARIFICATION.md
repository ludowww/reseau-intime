# R8C-N4.1 — Clarification placement canonique relatif / projection runtime

> **Nature :** correctif documentaire de portée
>
> **Scène :** Sandra — Les chaises bleues
>
> **Baseline obligatoire de N4 :**
> `6511e79254bd5c886a608452915df60f602420cb`
>
> **Document N4 historique verrouillé :**
> [`R8C_N4_SANDRA_BLUE_CHAIRS_EXACT_SEASON_PLACEMENT_AUDIT.md`](R8C_N4_SANDRA_BLUE_CHAIRS_EXACT_SEASON_PLACEMENT_AUDIT.md)
>
> **Nature du lot :** documentation uniquement ; aucune intégration

## Raison du correctif

R8C-N4 a correctement identifié, dans la Saison 1 actuellement implémentée,
un créneau compatible pour **Les chaises bleues** : J04, vendredi, entre
`chapter_04_nico_saved_seat_followup` et
`chapter_04_marie_household_report`, avec une fenêtre recommandée de
16:30–18:04.

Son statut `EXACT_PLACEMENT_RECOMMENDED` peut toutefois être lu comme si J04
devenait l'unité canonique principale de conception ou une propriété immuable
de la scène. Cette lecture contredirait la hiérarchie narrative de référence et
la portée explicitement relative de R8C-N3.

Le présent correctif ne réécrit pas l'audit N4 verrouillé. Il en clarifie la
portée : N4 a validé une projection exacte dans le runtime observé, pas une
dépendance canonique au numéro J04.

## Architecture narrative de référence

La direction Narrative Bible / North Star reste :

```text
trame principale
→ routes macro
→ séquences
→ scènes modulaires
→ dialogues
→ médias
```

Les jours, heures, cartes runtime et voisinages techniques sont des moyens
d'ordonnancement et de livraison de la Saison 1 actuelle. Ils permettent de
projeter la structure narrative dans une exécution donnée, mais ne remplacent
ni les séquences ni les relations canoniques entre scènes.

La scène conserve donc une identité stable indépendante d'un numéro de jour.
Un changement ultérieur du découpage calendaire peut déplacer sa projection
sans modifier son rôle, son contenu ou son placement canonique relatif.

## Distinction canon / séquence / projection runtime

| Niveau | Décision | Portée |
| --- | --- | --- |
| Canon | **Les chaises bleues** intervient après la reprise et la complicité retrouvée, après un court ralentissement, puis avant un nouveau déjeuner réellement organisé, une progression Sandra explicitement plus intime et tout verrouillage de route. | Invariant narratif, indépendant du découpage en jours. |
| Séquence | La scène est un module unique de la séquence Sandra, placé dans la phase de réouverture prudente du lien. Ses prérequis, incompatibilités et bornes relationnelles déterminent son voisinage narratif. | Structure de conception qui doit survivre à toute recomposition de la Saison 1. |
| Projection runtime actuelle | Dans l'implémentation observée par N4, le meilleur créneau candidat est J04, vendredi, 16:30–18:04, après Nico et avant Marie. | Ordonnancement technique compatible aujourd'hui, révisable si le runtime ou la structure de Saison 1 change. |

La projection runtime doit toujours démontrer qu'elle respecte le canon et la
séquence. L'inverse n'est pas vrai : le canon ne dépend pas de la conservation
de J04, de ses heures ou de ses identifiants de conversations voisines.

## Placement canonique relatif approuvé

Conformément à
[`R8C_N3_SANDRA_BLUE_CHAIRS_CANONICAL_PLACEMENT.md`](R8C_N3_SANDRA_BLUE_CHAIRS_CANONICAL_PLACEMENT.md),
la scène se situe obligatoirement :

1. après la reprise de contact Sandra ;
2. après une complicité retrouvée ;
3. après un court ralentissement ou silence ;
4. avant qu'un nouveau déjeuner soit réellement organisé, convenu ou acquis ;
5. avant une progression Sandra explicitement plus intime ;
6. avant tout verrouillage de route.

Cet ordre demeure vrai si le nombre de jours, leur contenu, leur densité, leurs
heures ou leur composition sont modifiés. Il reçoit le statut :

`CANON_RELATIVE_PLACEMENT_APPROVED`

## Projection runtime actuelle

Dans la Saison 1 actuellement implémentée et auditée par N4, la projection
recommandée reste :

```text
J04 — vendredi — 16:30–18:04
après chapter_04_nico_saved_seat_followup
avant chapter_04_marie_household_report
```

Ce créneau est compatible avec l'état du runtime examiné par N4 et préserve
l'ordre local Nico → **Les chaises bleues** → Marie. Il demeure néanmoins :

- révisable ;
- non constitutif de l'identité canonique de la scène ;
- dépendant de l'état réel de la Saison 1 au moment de l'intégration ;
- à revalider si la structure, les horaires, les scènes voisines, les
  préconditions ou les incompatibilités de la Saison 1 changent.

Il reçoit le statut :

`CURRENT_RUNTIME_PROJECTION_CANDIDATE`

## Formulation corrigée

> « Les chaises bleues possède un placement canonique relatif approuvé dans la
> séquence Sandra. J04, 16:30–18:04 constitue la projection runtime actuellement
> recommandée, non une dépendance canonique au numéro de jour. »

Dans toute lecture ultérieure de N4, `EXACT_PLACEMENT_RECOMMENDED` doit être
compris comme une recommandation exacte pour la projection de Saison 1 auditée,
et non comme un statut canonique absolu attachant la scène à J04.

## Décisions N4 conservées

Le correctif ne remet pas en cause les conclusions N4 suivantes :

- l'analyse des collisions et de la densité locale ;
- les prérequis et conditions négatives ;
- l'ordre relatif canonique issu de N3 ;
- la revue de l'agence joueur et le maintien du choix N2 ;
- les fonctions des émojis `😅` et `🙂` ;
- le concept média `photo_sandra_cafe_blue_chairs`, son caractère causal et
  l'absence d'asset final ;
- les incompatibilités, notamment la non-répétition avec la continuité photo
  Sandra actuellement projetée en J05 ;
- la fenêtre A8 conceptuelle, y compris l'éligibilité unique, la revalidation
  et la fermeture silencieuse avant proposition ;
- le créneau A9 conceptuel, y compris les bornes, la durée à authorer, l'ordre
  explicite et le refus du plan en cas de chevauchement.

Les mentions de J04, 16:30–18:04, Nico, Marie et J05 dans les descriptions A8,
A9, de collision ou d'incompatibilité sont conservées comme paramètres de la
projection runtime actuelle. Elles ne deviennent pas des identifiants ou des
invariants canoniques.

Seule la portée canonique attribuable au numéro de jour est corrigée. Aucun
dialogue, média, fait, trace, fenêtre, créneau ou comportement runtime n'est
modifié.

## Impact sur le futur lot d'intégration

Le futur lot ne doit pas être nommé simplement « intégration J04 ». Son nom de
référence est :

`R8C-N5 — Projection Saison 1 de la séquence Sandra Les chaises bleues`

Ce lot pourra cibler J04 techniquement si cette projection reste la meilleure
au moment de son ouverture. Avant toute intégration, il devra toutefois :

1. revalider J04, 16:30–18:04 et les voisins Nico/Marie contre le runtime réel ;
2. confirmer que tous les prérequis et toutes les incompatibilités N3/N4 sont
   encore satisfaits ;
3. préserver la position canonique relative dans la séquence Sandra ;
4. permettre un déplacement ultérieur sans réécriture du canon ;
5. ne pas encoder `J04` dans l'identité narrative stable de la scène ;
6. conserver la possibilité de refuser ou déplacer la projection si sa durée,
   son média ou son voisinage ne sont plus compatibles.

Le présent document n'autorise pas N5 et ne commence aucun travail
d'intégration.

## Périmètre et statut final

R8C-N4.1 est un correctif exclusivement documentaire. Il ne modifie aucun
artefact A11.5, N1, N2, N3 ou N4, aucun dialogue, aucun fichier `game/`, aucune
donnée Saison 1, aucun artefact A1–A10 ou A6, aucun runtime et aucun média. Il
ne crée ni outil, ni test runtime, ni abstraction.

Les deux décisions finales, distinctes et simultanées, sont :

```text
CANON_RELATIVE_PLACEMENT_APPROVED
CURRENT_RUNTIME_PROJECTION_CANDIDATE
```

J04 demeure la meilleure projection runtime candidate documentée pour la
Saison 1 actuelle. J04 n'est pas l'identité canonique de **Les chaises bleues**.
