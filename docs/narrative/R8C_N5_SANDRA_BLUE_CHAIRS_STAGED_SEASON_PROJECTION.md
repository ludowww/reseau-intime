# R8C-N5 — Projection Saison 1 contrôlée de Sandra — Les chaises bleues

> **Baseline obligatoire :**
> `2bd49d728fb1e812a16fc18b7fdd844d74f51dbf`
>
> **Tag normatif de la baseline :**
> `r8c-n4-1-canon-runtime-placement-clarification`
>
> **Statut du lot :** `RUNTIME_PROJECTION_STAGED`
>
> **Révision corrective :** `R8C-N5.1`
>
> **État média :** `ASSET_REQUIRED_NOT_READY`

## Décision

La scène canonique **Sandra — Les chaises bleues** reçoit une projection
technique complète A6 → A10, mais demeure hors du parcours joueur. N5 utilise
la convention existante la plus sûre : un bundle A6 non indexé, chargé seulement
par son chemin explicite dans les tests et le smoke ciblé.

Aucun provider Saison 1, écran Portrait, corpus de conversation actif, système
de notification, manifeste média ou donnée de journée active ne référence ce
bundle. Aucun asset, placeholder visible ou entrée Galerie n’est créé.

Le statut final est :

`RUNTIME_PROJECTION_STAGED`

## Architecture staged retenue

Le dépôt ne possède aucun registre ou flag générique `staged`. Le loader A6
existant ne parcourt pas le dossier des bundles et n’accepte qu’un chemin JSON
explicite sous `res://data/narrative_scenes/`. N5 réutilise cette frontière :

- `r8c_n5_sandra_blue_chairs_staged.json` contient seulement la définition A6
  fermée ;
- la source N2 `CANON_APPROVED` reste l’unique autorité pour le texte ;
- `sandra_blue_chairs_r8c_n5.projection_report.json` conserve le mapping A6,
  les paramètres A8/A9, les ponts A1/A3, la gate média et l’incompatibilité
  J05 que le schéma A6 ne sait pas représenter ;
- le smoke compose un environnement de contrôle uniquement en mémoire pour
  exercer les mécanismes existants A7–A10 ; ce contrôle n’est pas un contenu
  Saison 1 et n’est jamais publié dans le bundle staged.

Cette architecture ne crée ni loader, ni provider, ni abstraction de contenu
supplémentaire.

## Identité canonique et projection runtime

### Identité stable

| Élément | Valeur |
| --- | --- |
| `scene_definition_id` | `sandra_blue_chairs_definition` |
| `variant_id` | `sandra_blue_chairs_canonical` |
| type doctrinal | `MODULAR` |
| enum A6 existant | `MODULAIRE` |
| occurrence | `UNIQUE` |
| participants | `player`, `sandra` |

Les deux identifiants stables ne contiennent aucun jour, aucune heure et aucune
référence `chapter_04`. La structure stable situe la scène après la réactivation
prudente du lien et avant un déjeuner acquis, une progression intime ou un
verrouillage de route.

### Projection Saison 1 actuelle

| Élément | Valeur révisable |
| --- | --- |
| jour runtime | J04, vendredi |
| fenêtre | 16:30 à 18:04 inclus |
| scène précédente | `chapter_04_nico_saved_seat_followup` |
| scène suivante | `chapter_04_marie_household_report` |
| ordre auteur | Nico → Les chaises bleues → Marie |
| durée technique réservée | 90 minutes |
| implantation A9 | 16:30–18:00 |
| marge avant Marie | 4 minutes |

La date `2030-04-12` existe uniquement parce que les contrats temporels A6–A9
exigent une date ISO complète dans le harness. Elle n’appartient pas à
l’identité canonique et ne constitue pas une nouvelle date de Saison 1.

La durée de 90 minutes est une borne technique prudente égale au parcours N2
le plus long de 90 éléments. Elle ne crée aucun timestamp de dialogue et ne
modifie pas le texte. Le plan conserve quatre minutes pleines avant l’ouverture
Marie à 18:05.

## Texte N2 verrouillé

Le bundle ne duplique pas le transcript, car A6 ne possède aucun champ de
message. La source exacte reste :

`narrative_tool/a11/revisions/sandra_blue_chairs_r8c_n2.source.json`

Les contrôles N5 verrouillent notamment :

- 96 éléments stockés ;
- `m04 = 😅` dans `ou alors je deviens vieille 😅` ;
- `m91 = bonne soirée` ;
- `m93 = 🙂` ;
- `careful_warmth = Que ça m’avait manqué.` et ses sept réceptions ;
- `ironic_withdrawal = Que nos agendas sont nuls.` et ses six réceptions ;
- convergence au message `m53` ;
- aucune addition, suppression, reformulation ou permutation.

## Mapping A6

| Source canonique | Projection A6 |
| --- | --- |
| identité de scène | `scene_id` / `scene_definition_id` |
| variante canonique | `variant_id` |
| `MODULAR` | enum runtime existant `MODULAIRE` |
| `UNIQUE` | `politique_unicite` |
| Sandra et Player | `participants_requis` |
| prérequis positifs | `conditions_dures.evenements_requis` |
| incompatibilités | `exclusions_dures.evenements_interdits` |
| placement courant | `contrat_temporel`, explicitement non identitaire |
| deux options N2 | `choix` avec formulations exactes |
| réceptions distinctes | deux résolutions `LOCALE`, `NON_PERSISTANTE` |
| convergence | `RETOUR_NOYAU_COMMUN` |
| conséquence locale | signal distinct reçu et interprété localement, sans `fait_relationnel` |
| trace durable bornée | hors résolution A6 : un événement A1 commun staged après `RESOLVED` |

A6 ne contient pas et ne prétend pas contenir les bulles, les identifiants de
réception N2, les métadonnées auteur, le statut staged, l’état de production du
média, l’ordre Nico/Marie ou la règle J05. Le rapport JSON conserve ces éléments
et pointe vers leur source d’autorité.

Le schéma A6 fermé associe obligatoirement tout `fait_relationnel` durable à la
résolution, donc au choix et au signal. N5.1 n’utilise pas cette voie : les deux
attitudes sont strictement locales et le harness staged applique séparément la
trace commune, seulement après avoir observé l’état A5 `RESOLVED`. Cette preuve
n’ajoute aucun pont au runtime joueur.

## A1 / A3 — prérequis projetés

L’état A1 synthétique et `Season1State` sont séparés sur la baseline. A3 sait
évaluer des identifiants d’événements A1, mais ne sait pas lire directement les
scalaires ou registres Saison 1. N5 n’ajoute donc aucun faux branchement runtime.
Le harness injecte quatre événements discrets minimaux et sourcés :

| Événement A1/A3 projeté | Provenance Saison 1 auditée |
| --- | --- |
| `sandra_recontact_reactivated` | `fact_sandra_preexisting_friendship` et `sandra_state = RECONNECTION_OPEN` |
| `sandra_first_complicity_restored` | `sandra_j03_echo_outcome = RESPONDED` |
| `sandra_shared_lunch_memory_available` | `fact_player_saw_sandra_lunch_photo` et `j01_sandra_lunch_memory_soft` |
| `sandra_short_pause_after_recontact_elapsed` | fin de la continuité J03 puis atteinte de 16:30 dans la projection auditée |

Le quatrième fait est le seul ajout conceptuel absent des registres actuels :
il rend discret le court silence requis par N3. Les trois autres sont des ponts
minimaux vers des données qualitatives ou factuelles déjà présentes.

Les événements interdits sont exclusivement discrets : demande de distance,
conflit actif, nouveau déjeuner acquis, progression avancée, intimité explicite
ou route verrouillée. Aucun score, total, seuil ou état relationnel numérique
n’est introduit.

Ces événements restent limités au harness staged. Leur adaptateur réel depuis
`Season1State` devra être conçu et validé dans un futur lot d’activation.

## A8 — décision avant et après proposition

### Avant proposition

La politique retenue est `CLOSE_SILENTLY`. Le smoke démontre qu’une option N2
encore candidate devient `NOT_SELECTED`, sans instance A5, sans `MISSED`, sans
absence narrative et sans mutation A1 quand l’autre option de contrôle est
retenue.

La baseline possède une limite connue : A8 ne propose aucune opération publique
qui ferme une fenêtre intacte uniquement parce que son heure de fermeture a été
atteinte. Une action à 18:05 est bien refusée, mais cette seule expiration ne
matérialise pas la fermeture silencieuse. N5 documente ce manque comme bloqueur
d’activation au lieu d’ajouter une abstraction locale non autorisée.

### Après proposition

`MARK_MISSED_IF_PROPOSED` est écarté pour cette scène. N2 n’est ni un rendez-vous
manqué ni une dette : une fois proposée, son instance A5 demeure jouable jusqu’à
sa résolution complète. Le contrat A6 revalide avant proposition, pas après
présentation, afin que la fermeture de la fenêtre n’invente pas une absence au
milieu du transcript.

La définition n’a aucune `politique_non_resolution` et n’autorise aucune
conséquence manquée. Aucune sanction relationnelle et aucune trace A1 ne peuvent
donc être produites par expiration.

## A9 — créneau contrôlé

Le slot staged est borné à 16:30–18:04. La fenêtre A6/A8 ferme à 18:05 selon une
sémantique exclusive : aucune proposition n’est acceptée à 18:05.

A9 accepte l’implantation de 90 minutes à 16:30–18:00. Un mutant dont la borne
ou la durée impose une fin à 18:05 est refusé. Les tests vérifient également le
refus d’un contexte périmé, d’un plan falsifié, d’un prérequis absent et d’une
incompatibilité active.

A9 ordonne des `window_id`, tandis que Nico et Marie sont encore des
conversations du provider historique. Le plan A9 staged porte donc la seule
fenêtre N2 et le rapport de projection conserve l’ordre de séquence complet
Nico → N2 → Marie. Aucun faux wrapper A6 n’est créé autour de Nico ou Marie.

## A10 — orchestration hors joueur

Le smoke charge le bundle staged par son chemin explicite, puis exerce :

```text
A1 events → A3 eligibility → A6 candidate
→ A7 proposal → A8 conflict closure → A9 plan
→ A10 activation → A5 PROPOSED → A10 local resolution → A5 RESOLVED
→ staged common post-resolution event → A1 durable fact
```

L’option de contrôle nécessaire au minimum de deux options A8 est créée
uniquement en mémoire par le smoke. Elle ne figure ni dans le bundle staged ni
dans les données Saison 1.

## Incompatibilité J05

La scène concernée est exactement :

- conversation : `chapter_05_sandra_photo_continuity` ;
- identité stable : `sandra_saturday_photo_continuity_01`.

Règle projetée :

- si N2 possède une instance A5 `PROPOSED` ou `RESOLVED`, J05 est silencieusement
  inéligible avant toute proposition ;
- si N2 n’a jamais été proposée et sa fenêtre s’est fermée silencieusement,
  l’éligibilité J05 historique est évaluée normalement ;
- aucun `MISSED`, aucune absence narrative, aucune sanction et aucune trace A1
  ne sont créés.

Le smoke vérifie séparément les trois cas : `PROPOSED` → inéligible,
`RESOLVED` → inéligible et aucune instance N2 → évaluation normale.

N5 ne modifie ni la conversation, ni `Season1State`, ni `J05RuntimeProvider`.
Le pont A5 → éligibilité J05 reste un bloqueur explicite du futur lot
d’activation.

## Trace durable A1

Le seul fait durable autorisé est :

| Élément | Valeur |
| --- | --- |
| événement staged commun | `r8c-n5:sandra-blue-chairs:common-resolution-trace` |
| identifiant technique | `sandra_recontact_importance_received_understood` |
| texte canonique | `Sandra a reçu et compris que la reprise du contact compte pour Player.` |
| portées des attitudes | `LOCALE`, `NON_PERSISTANTE` |
| provenance de choix ou signal | aucune |
| permission future | `false` |

Après l’une ou l’autre attitude, la résolution A6 reste locale et n’écrit aucun
événement A1. Le harness staged observe ensuite la résolution complète et
applique le même événement commun, indépendant du choix et du signal. Le fait
n’existe pas à l’éligibilité, la réservation, l’ouverture A8, la composition
A9, la proposition, l’expiration ou la fermeture silencieuse. Le replay exact
de la résolution puis de l’événement commun est idempotent et ne duplique pas le
fait.

Le mécanisme technique existant stocke cette « trace » éditoriale comme un fait
relationnel A1 dans `relations.sandra.faits`. Sa provenance staged ne contient
ni choix, ni signal, ni résolution optionnelle. N5 ne prétend pas l’écrire dans
`traces_narratives`, racine que le codec A5 exige encore vide.

## Média et blocage d’activation

| Élément | Décision N5 |
| --- | --- |
| média requis | `photo_sandra_cafe_blue_chairs` |
| statut | `ASSET_REQUIRED_NOT_READY` |
| asset créé | non |
| ancien asset réutilisé | non |
| placeholder visible | non |
| entrée Galerie | non |
| activation joueur | interdite |

Le média est causal dès le premier message N2. Les composants actuels de
conversation afficheraient un fallback si une référence manquante était
branchée dans un transcript visible. Pour garantir l’absence totale de
placeholder, N5 garde donc la scène entière hors provider plutôt que d’ajouter
une référence média non livrée.

## Preuve de non-activation joueur

Les tests balaient explicitement et exigent l’absence de référence au bundle,
à son identité stable et au média depuis :

- `Season1RuntimeProvider.gd` et les providers J01–J21 ;
- `PortraitMain.gd`, `PortraitMain.tscn` et le shell Portrait ;
- `game/data/conversations/` ;
- les scripts de notifications et de messages visibles ;
- `game/data/runtime/season_1/` ;
- `game/data/visual_content/` et `game/assets/`.

Les seules références autorisées sont le bundle staged, le rapport, le présent
document et les tests/smokes ciblés.

## Conditions restantes avant activation

N5 n’autorise aucun lot d’activation. Une activation future devra au minimum :

1. produire et valider l’asset final ;
2. relire le texte N2 dans son contexte mobile sans le modifier ;
3. concevoir le pont borné `Season1State` → événements A1/A3 ;
4. fournir une vraie fermeture silencieuse à l’expiration avant proposition ;
5. relier les preuves A5 `PROPOSED` et `RESOLVED` à l’inéligibilité silencieuse J05 ;
6. revalider J04, 16:30–18:04, Nico, Marie et la durée ;
7. commencer un lot d’activation séparé et explicitement autorisé.

`RUNTIME_PROJECTION_STAGED`
