# R8C-N7.1 — Contrat de structure de Saison 1, projection runtime et entrée N8

> **Baseline inspectée :** `024f9f3dbdaedfbbac20956ad2a9918fb611101c`
> **Tag stable vérifié :** `r8c-n7-written-payoff-aftercare-reconciliation`
> **Branche de livraison :** `work/r8c-n7-1-season-structure-runtime-projection-contract`
> **Nature :** contrat documentaire ; aucun changement de dialogue, runtime, test, asset, JSON ou A1–A10
> **Statut du document :** `SEASON_RUNTIME_PROJECTION_CONTRACT_READY_FOR_PRODUCT_REVIEW`
> **Statut produit possible après revue et verrouillage seulement :** `SEASON_RUNTIME_PROJECTION_CONTRACT_APPROVED`

## 1. Verdict et autorité

Ce document est l’unique point de réconciliation N7.1 entre la structure canonique
de Saison 1, les séquences authored, la projection historique J01–J21 et le
`Season1State` réellement exécutable sur la baseline. Il ne remplace pas les textes
de personnage ni les dialogues signés ; il prévaut, pour l’entrée N8, sur les
anciens découpages par jours, sur les anciennes lectures de J17 comme finale et sur
les anciens vocabulaires d’état incompatibles.

Les douze décisions produit requises ont été intégrées comme listes fermées,
formules exactes et responsabilités de preuve dans les sections 7, 9, 12 et 14. Le
runtime inspecté ne les contredit pas : il expose les faits nécessaires, tandis que
les deux formulations J17 qui ne prouvent encore rien sur la baseline sont
explicitement resserrées dans le périmètre N8. Le contrat est donc prêt pour revue
produit, mais n’est pas approuvé et n’autorise encore aucune implémentation N8.

Conformément à la règle de sécurité, l’absence d’un fait dommageable dans un
snapshot structurellement valide vaut `false`; l’absence d’une preuve constructive
vaut également `false` et peut mener au fallback propre au choix. Seule une
incohérence de structure ou une référence de preuve annoncée mais absente invalide
la résolution. Une entrée invalide ne choisit ni fallback favorable, ni `FRACTURE`
par défaut.

N8 demeure un correctif ciblé du runtime historique de Saison 1. Aucun cutover,
adaptateur, exécuteur de séquences, projection A6, double écriture ou migration vers
A1–A10 n’est autorisé.

## 2. Hiérarchie canonique complète

La hiérarchie normative est :

```text
Saison
→ mouvement dramatique
→ séquence authored
→ scène ou beat
→ dialogue
→ média
→ projection temporelle
→ jour et heure diégétiques
```

- La saison est l’unité de transformation et de clôture.
- Un mouvement est une unité dramatique canonique. Ce n’est ni un champ, ni une
  phase, ni un état runtime.
- La séquence authored est l’unité principale de composition narrative. Elle porte
  une identité, une fonction, des entrées et sorties ; elle peut contenir plusieurs
  scènes, beats, échanges, silences et médias.
- Une scène ou un beat situe une action concrète. Un dialogue et un média en sont
  des modes de livraison, pas des identités supérieures.
- La projection temporelle place ces unités dans le corpus actuellement jouable.
  Les jours et horaires sont des contenants diégétiques et techniques.
- Les dates et heures restent nécessaires aux rendez-vous, absences, repos,
  obligations, échéances et au rythme crédible de messagerie.
- `J01–J21` est la projection actuelle du corpus et du runtime, pas l’architecture
  canonique de la saison.
- L’identité canonique d’une séquence ne dépend jamais d’un identifiant `jNN_*`.

> **Règle normative :** Un déplacement, une fusion ou une subdivision de journée
> ne modifie pas l’identité canonique d’un mouvement, d’une séquence ou d’une scène.

### 2.1 Les cinq mouvements

| Mouvement | Matière principale | Fonction et sortie |
|---|---|---|
| I — Réouverture | `S01–S07` | Réactiver le réseau, faire revenir les liens anciens, installer les premières fissures et la question dramatique. La réouverture a un effet lisible sur Marie/Player. |
| II — Attirances | `S08–S14` | Rendre distincts regards, ambiguïtés, tentations et déplacements relationnels ; installer une progression visuelle et sociale. Une attirance ou une limite ne peut plus être réduite à une occasion. |
| III — Explorations | `S15–S22` | Autoriser expérimentations, franchissements conditionnels, scènes adultes, payoffs et découverte des limites réelles. Une exploration modifie ce qui est possible, dû ou difficile à dire. |
| IV — Limites et conséquences | `S23–S28` | Faire répondre aux conflits, audiences, promesses, paiements, réparations ou fractures. Les conséquences pertinentes sont résolues, transformées ou transportées. |
| V — Clarification | sous-mouvements ci-dessous | Construire ou terminer le couple après les conséquences, puis produire décision, logistique et épilogues compatibles. |

### 2.2 Sous-mouvements canoniques du mouvement V

Ces étapes sont indépendantes des jours et conservent cet ordre relatif :

1. départ de Mathilde et clarification intermédiaire, matière historique `S31` et
   `S29` ;
2. état provisoire du couple ;
3. résolution des lignes extérieures Sandra, Pauline, Raphaëlle et Nico, matière
   `S30`, `S32`, `S33` et `S34` ;
4. aftercares réellement dus ;
5. synthèse des conséquences et constitution de la trace ou posture ;
6. conversation finale autonome Marie/Player ;
7. décision, contrat ou séparation et logistique ;
8. épilogues et dernière image recontextualisée, fonction historique `S35`.

J17 et J21 localisent actuellement une partie de ces fonctions. Ils n’en sont pas
les identités canoniques.

## 3. J17, J21 et la véritable conversation finale

### 3.1 Contrat de J17

J17 porte le départ de Mathilde, les quatre choix de couple existants, une résolution
intermédiaire vers un des six états, un micro-retour Mathilde après le départ, un
micro-retour Marie après la résolution, une règle ou obligation de continuité et la
préparation des conséquences suivantes.

J17 n’est ni la conversation finale de la saison, ni la décision logistique
terminale, ni l’épilogue. Son choix local n’annule aucun fait J01–J16.

### 3.2 Identité de la conversation finale

| Propriété | Contrat |
|---|---|
| Identité canonique produit | `s1_m5_marie_player_final_conversation` |
| Collision | Aucune occurrence dans le dépôt à la baseline inspectée. |
| Compatibilité syntaxique | Compatible : chaîne authored non vide, stable, explicite et en snake_case ; les contrats A2/A6 n’imposent pas une casse différente à une identité documentaire de séquence. |
| Fonction | Faire décider Marie et Player à partir de l’historique réel, après les conséquences et la posture ; la trace ou son contrôleur ne décide pas le couple. |
| Prérequis | État provisoire J17 valide ; résolutions extérieures pertinentes ; aftercares dus payés, échoués ou explicitement transportés ; trace/posture constituée ; connaissances de Marie bornées aux faits réellement acquis. |
| Entrées | Choix J17 exact, état canonique dérivé, gardes déclenchées, conditions constructives prouvées, promesses, obligations, traces, connaissances, résolutions des lignes extérieures, posture et logistique déjà établie. |
| Sorties | Statut final du couple ; contrat et divulgation distincts si le couple continue, ou relation résiduelle et logistique si séparation ; obligations de suivi ; admissibilité des épilogues. |
| Position relative | `conséquences → trace/posture → s1_m5_marie_player_final_conversation → décision/logistique → épilogues` |
| Projection runtime actuelle | Absente. J21 sert un matin Marie avant la trace, puis la trace, une posture et une réponse courte de son contrôleur ; il ferme ensuite la saison. |
| Portée N8 | Aucune. N8 ne modifie pas J21 et n’implémente pas cette conversation. |

L’ancien `S29 — La conversation qui ne peut plus être repoussée` reste la matière de
clarification intermédiaire historiquement projetée sur J17 ; il ne nomme plus la
conversation finale. Le script J21 pré-runtime conserve de la matière de soirée,
mais son ordre et sa projection actuelle sont supersédés par le contrat de finale du
document `14` et par l’identité ci-dessus.

### 3.3 Documents historiquement associés à la fonction finale

- `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` utilisait `S29`
  pour la définition du couple et `S35` pour la dernière image.
- `docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md`
  projetait `S29` sur J17 et `S35` sur J21.
- `docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md` décrivait six sorties de
  couple à J17 ; ses sorties deviennent provisoires.
- `docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md` contient de la matière de
  finale mais reste lié à J21 et ne gouverne plus l’identité ni l’ordre final.
- `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` fixe l’autonomie
  et l’ordre de la conversation finale ; il est l’autorité narrative supérieure.
- `docs/narrative/R8C_N7_J17_J21_CONTINUITY_AND_AFTERCARE_PLAN.md` et
  `docs/narrative/R8C_N7_REVISION_PACKETS_AND_ACCEPTANCE_GATES.md` constatent le
  raccord manquant, sans lui attribuer l’identité produit désormais fixée ici.

## 4. Vocabulaire unique des six états J17

Identifiant explicitement interdit : `RECONFIGURATION_NEGOTIATING`. Toute donnée
nouvelle, formule N8, test ou micro-retour emploie le vocabulaire ci-dessous.

Le droit de refus de Marie est un invariant permanent dans les six états. Le
prédicat constructif de reconfiguration vérifie qu’une proposition le reconnaît
explicitement ; il ne crée, ne suspend et ne retire jamais ce droit.

| État | Définition narrative | Faits garantis | Faits explicitement exclus | Dépend encore du record | Statut provisoire du couple | Règle ou obligation immédiate | Finale compatible | Runtime actuel / N8 |
|---|---|---|---|---|---|---|---|---|
| `SEPARATION` | Fin du couple reconnue ou organisation de fin déjà active. | Ancien couple terminé ; logistique exigée ; histoire commune conservée. | Permission extérieure automatique ; effacement des promesses, dommages ou souvenirs. | Qualité résiduelle, objets, logement, rendez-vous, dettes et aftercares. | Séparés. | Organiser concrètement logement, objets, heure ou limites. | Oui, pour fixer logistique et relation après séparation. | Produit par `choice_j17_separation`; enrichissement du record et micro-retour N8. |
| `FRACTURE` | Ancien fonctionnement retiré, vie pratique encore liée et réparation non promise. | Cadre antérieur indisponible ; lien pratique possible ; conséquence active. | Réconciliation, séparation déjà accomplie, disponibilité d’une route de consolation. | Cause exacte, connaissance de Marie, réparation possible et logistique. | En clarification, fracturé. | Limite pratique immédiate ; aucune progression de consolation. | Oui, vers réparation nouvelle ou séparation, sans attente automatique. | Produit aujourd’hui seulement après refus/non-dû ; gardes dommageables à ajouter en N8. |
| `DOUBLE_LIFE_FRAGILE` | Couple matériellement maintenu alors qu’un fait important caché ou une version incompatible reste actif. | Contradiction active ; confiance contestée ; conséquence future nécessaire. | Contrat sain, succès propre, vérité complète, pardon. | Fait caché, personne qui sait quoi, preuve, dette et fermeture possible. | Ensemble matériellement, divulgation compromise. | Ne pas aggraver ; payer ou révéler la contradiction existante. | Oui, comme matière de révélation, décision ou séparation. | Accepté par snapshot/J21 mais jamais produit par le résolveur J17 actuel ; adaptation N8. |
| `PROVISIONAL_AGREEMENT` | Le couple évite la rupture immédiate avec des règles temporaires et une revue bornée. | Problème reconnu ; ancien cadre non restauré ; aucune permission rétroactive. | Résolution finale, ouverture implicite, oubli de l’historique. | Règle exacte, espaces, divulgation, date de revue et obligations. | Ensemble sous accord provisoire. | Règle temporaire et checkpoint explicite ; progression extérieure contenue. | Oui, la finale doit décider ou définir un provisoire complet. | Produit par `choice_j17_provisional` et fallback de reconquête ; record/règle à enrichir en N8. |
| `RECONQUEST_ACTIVE` | Marie et Player essaient encore activement, par des actes antérieurs prouvés et une règle concrète. | Choix du couple ; vérité suffisante ; absence de violation active ; acte ordinaire à répéter. | Pardon total, retour intact à l’ancien cadre, nouvelle progression extérieure non clarifiée. | Actes précis, règle, dommages réparés, obligations et divulgation. | Ensemble en reconquête. | Aucun faux horaire ou lieu ; aucune nouvelle progression extérieure avant clarification ; acte ordinaire concret. | Oui, sans transformer la reconquête en absolution. | Produit trop directement par le choix homonyme ; N8 doit appliquer les gardes et conditions. |
| `RECONFIGURATION_NEGOTIATION` | Négociation réelle du contrat, sans ouverture automatique ni engagement d’un tiers. | Désir extérieur reconnu ; audiences sûres ou réparées ; pause ; refus de Marie explicitement reconnu. | Permission rétroactive, couple déjà ouvert, tiers engagé, disponibilité automatique d’une personne. | Désirs exacts, limites, partenaires libres, date de revue et résultat de la négociation. | En clarification/négociation. | Aucune nouvelle étape ; droit de refus intact ; checkpoint borné. | Oui, la finale peut conclure refus, autre contrat ou séparation. | Accepté par snapshot/J21 mais jamais produit par J17 ; adaptation N8 et preuves authored à matérialiser. |

Aucun de ces états n’est un résumé exhaustif de l’histoire. Le record de continuité
reste la preuve de ce qui a déclenché l’état et de ce qui demeure ouvert.

## 5. Surface runtime réellement observée

Tous les champs ci-dessous sont déclarés et snapshotés dans
`game/scripts/runtime/season_1/Season1State.gd`.

| Donnée | Type réel | Valeurs observées ou validées | Écrivains réels |
|---|---|---|---|
| `j11_physical_level` | `String` | `NONE`, `PROXIMITY_ONLY`, `MATHILDE_M_B2`, `MATHILDE_M_B3`, `MARIE_ADULT_RECONQUEST`, `RAPHAELLE_FIRST_KISS` | `set_j11_mathilde_proximity`, `establish_j11_mathilde_physical_event`, `establish_j11_marie_adult_event`, `set_j11_raphaelle_outcome` ; scènes `chapter_11_*`. |
| `obligations["aftercare_mathilde_j11"]` | `Dictionary` optionnel ; `status: String` | absent, puis `DUE`, et obligatoirement `PAID` ou `FAILED` avant la fin J11 | `establish_j11_mathilde_physical_event`, `_create_j11_aftercare`, `resolve_j11_aftercare`; échec traité par `mark_j12_failed_aftercare_processed`. |
| `j14_outcome`, `j14_player_explanation` | `String` | `TRUTH_LIMITED`, `MINIMIZE_OR_LIE`, `PROTECT_AND_DEFER`, `PROTECT_AND_ANSWER_NOW`, ou `S27_MUTATION_NO_DISCOVERY` pour `j14_outcome` | `select_j14_variant`, `_set_j14_no_discovery_mutation`, `apply_j14_choice`; choix `choice_j14_<variant>_truth|lie|defer`. |
| `j14_witness` | `String` | vide, `Marie` ou `Mathilde` | `select_j14_variant`, d’après la trace J13/J11 projetée sur J14. |
| `j14_controller_notified` | `bool` | `false`, `true` | `resolve_j14_controller_informed` met `true`; `fail_j14_controller_notice` maintient/met `false`. |
| `promises["j14_inform_trace_controller"].status` | `String` dans un `Dictionary` optionnel | absent, `ACTIVE`, puis `PAID` ou `FAILED` avant fin J14 | `_create_j14_controller_notice`, `resolve_j14_controller_informed`, `fail_j14_controller_notice`. |
| `j15_mode` | `String` | `ACTIVE_CLARIFICATION`, `REPAIR`, `OPEN_CLARIFICATION`, `NO_OBLIGATION` après établissement | `select_j15_mode`, `establish_j15_mode`. |
| `j15_outcome` | `String` | `DUE_PAY`, `DUE_CANCEL`, `DUE_FAIL`, `REPAIR_TRUTH`, `REPAIR_LIE`, `OPEN_ANSWER`, `OPEN_REFUSE`, `OPEN_LIE`, `CLEAN_ACKNOWLEDGE` | `apply_j15_choice`; familles de choix homonymes de `chapter_15_obligation_mutation.json`. |
| `j15_urgent_consequence_remaining` | `bool` | `false`, `true` | `apply_j15_choice`; vrai pour échec dû ou mensonge renouvelé. |
| `j16_priority` | `String` | `MARIE`, `MATHILDE`, `FALLBACK` après établissement | `select_j16_priority`, `establish_j16_priority`. |
| `j16_consequence_outcome` | `String` | `MARIE_RESTITUTE`, `MARIE_PRACTICAL`, `MARIE_CONTEST`, `MATHILDE_RESTITUTE`, `MATHILDE_PRACTICAL`, `MATHILDE_CONTEST`, `FALLBACK_CONFIRM` | `apply_j16_consequence_choice`; choix de `chapter_16_priority_payment.json`. |
| `promises["j16_priority_consequence_payment"].status` | `String` dans un `Dictionary` optionnel | absent, `ACTIVE`, puis `PAID` ou `FAILED` | Créé par `apply_j15_choice`; résolu par `apply_j16_consequence_choice`; une contestation produit `FAILED`. |
| `j16_j17_outcome` | `String` | `ACCEPT`, `REFUSE`, `ALTERNATIVE` après choix | `apply_j16_j17_choice`; choix `choice_j16_j17_accept|refuse|alternative`. |
| `promises["marie_j16_couple_conversation_j17"]` | `Dictionary` optionnel ; `status: String` | absent, ou `ACTIVE` après acceptation, puis `PAID` au choix J17 | `apply_j16_j17_choice`, `apply_j17_couple_choice`. |
| `j17_departure_outcome` | `String` | `HELP`, `DISTANCE` | `apply_j17_departure_choice`; la variante UI `choice_j17_distance_required` est normalisée par le provider vers `choice_j17_distance`. |
| `j17_couple_outcome` | `String` | `RECONQUEST`, `PROVISIONAL`, `SEPARATION`, `REFUSED_ACKNOWLEDGE` | `apply_j17_couple_choice`; quatre choix de couple réels. |
| `couple_state` | `String` | huit valeurs validées par snapshot, dont les six états J17 ; le résolveur actuel n’en produit directement que quatre | `apply_j17_couple_choice` pour J17. |
| `selected_choice_ids` | `Array[String]` | identifiants exacts des choix acceptés | Toutes les méthodes `apply_*`; J17 y conserve le choix de départ et le choix de couple. |
| `traces["j17_couple_definition_record_01"]` | `Dictionary` | actuellement `trace_id`, `record_type`, `source_day`, `couple_state`, `discussion_was_due`, `current_state`, `visual_asset` | `apply_j17_couple_choice`. |

### 5.1 Combinaisons authored fermées d’actes répétés envers Marie

`J17_REPEATED_MARIE_ACTS_PROVEN` ne repose ni sur un score, ni sur un compteur. Il
vaut `true` si au moins une des quatre combinaisons nommées suivantes est vraie :

| Combinaison fermée | Formule exacte |
|---|---|
| `MARIE_SHARED_EVENING_AND_HOUSEHOLD` | `promises["marie_j01_shared_evening"].status == PAID AND marie_j08_household_resolution == PAID AND promises["marie_j07_household_request"].status == PAID` |
| `MARIE_RETURN_AND_SHARED_MEAL` | `marie_j03_return_outcome IN {ACTIVE, BOUNDED} AND (promises["marie_j09_dinner_j10_2030"].status == PAID OR promises["marie_j09_dinner_friday_2030"].status == PAID)` |
| `MARIE_SHARED_HOUR_AND_LAVERRIERE` | `marie_j05_shared_hour_resolution == PAID AND promises["marie_j05_shared_hour"].status == PAID AND promises["marie_j12_laverriere_presence"].status == PAID` |
| `MARIE_PRESENCE_AND_J11_RECONNECTION` | `marie_j09_presence_outcome IN {presence_active, presence_playful_useful, presence_late_active, presence_bounded_reliable, absence_honest} AND j11_pivot == MARIE AND j11_pivot_outcome IN {MARIE_ADULT_RECONQUEST, MARIE_NON_ADULT_RECONNECTION, MARIE_SEX_NOT_USED_AS_BANDAGE, MARIE_HONEST_REFUSAL}` |

Sont exclus : dérive, attente manquée, `presence_distracted`,
`presence_spectator`, toute promesse échouée, annulée ou refusée,
`MARIE_NO_RECONQUEST` et le choix J17 lui-même.

## 6. Règles de calcul et invalidité

L’évaluation N8 doit être déterministe, ordonnée et faite avant la mutation de la
promesse J17 et de `couple_state`.

```text
entrée structurellement valide
→ validité du choix
→ gardes dommageables, dans l’ordre
→ conditions constructives propres au choix
→ fallback propre au choix
→ record de continuité
→ micro-retours
```

Une preuve constructive absente vaut `false`. Une violation vaut `true` seulement
si un fait existant l’établit explicitement. Dans un snapshot structurellement
valide, l’absence d’un fait dommageable de la liste fermée vaut `false`, jamais
« inconnu » ou invalide. Une donnée contradictoire ou impossible, un champ requis
encore `UNESTABLISHED`, ou une preuve annoncée mais absente invalide l’entrée et
empêche toute sortie.

Cas d’entrée invalides minimaux :

- choix inconnu ;
- `choice_j17_refused_acknowledge` alors que la discussion est due ;
- choix due-only alors que la discussion est refusée ou non due ;
- `j16_j17_outcome == ACCEPT` sans promesse active correspondante, ou promesse
  active avec `REFUSE`/`ALTERNATIVE` ;
- champ requis encore `UNESTABLISHED` ;
- preuve annoncée dans un record mais absente de `knowledge`, `promises`,
  `obligations` ou `traces` ;
- deux valeurs incompatibles pour le même fait ;
- condition constructive déclarée satisfaite sans preuve authored fermée.

Un cas invalide ne produit ni septième état, ni fallback, ni état de dommage par
prudence. Le résolveur doit refuser explicitement et laisser l’état antérieur
inchangé.

## 7. Traduction exacte des prédicats N7

### 7.1 Discussion J16 refusée ou non due

- **Nom stable :** `J17_DISCUSSION_REFUSED_OR_NOT_DUE`.
- **Définition :** Player a explicitement refusé l’heure J17 ou proposé une
  alternative qui ne crée pas la promesse due ; Marie n’attend donc pas la
  conversation.
- **Runtime :** `j16_j17_outcome: String` (`ACCEPT`, `REFUSE`, `ALTERNATIVE`) et
  `promises["marie_j16_couple_conversation_j17"]: Dictionary` optionnel, écrit par
  `apply_j16_j17_choice` dans `chapter_16_priority_payment.json`.
- **Valeurs satisfaisantes :** `REFUSE` ou `ALTERNATIVE`, avec promesse absente.
- **Valeur incompatible :** `ACCEPT` avec promesse `ACTIVE`.
- **Formule exacte à l’entrée J17 :**

```text
(j16_j17_outcome == REFUSE OR j16_j17_outcome == ALTERNATIVE)
AND NOT promises.has("marie_j16_couple_conversation_j17")
```

La discussion due, utilisée comme condition de validité des trois autres choix, est
exactement l’état complémentaire valide suivant :

```text
j16_j17_outcome == ACCEPT
AND promises.has("marie_j16_couple_conversation_j17")
AND promises["marie_j16_couple_conversation_j17"].status == ACTIVE
```

- **Information manquante :** `UNESTABLISHED`, promesse mal formée ou incohérence
  résultat/promesse invalide l’entrée.
- **Source canonique :** N7-RP-04 et la disponibilité réelle de
  `apply_j17_couple_choice`.
- **Conséquence N8 :** calculable sans nouveau champ ; conserver la cohérence
  stricte au lieu de réduire la notion à `promise.status != ACTIVE`.
- **Statut :** calculable.

### 7.2 Violation grave connue de Marie et non réparée

- **Nom stable :** `J17_MARIE_KNOWN_SEVERE_VIOLATION_UNREPAIRED`.
- **Formule normative :** `D1_A OR D1_B OR D1_C`, avec les trois familles fermées
  ci-dessous. Aucun autre échec n’est promu en violation grave.

`D1_A — AFTERCARE_MATHILDE_FAILED_AND_KNOWN` :

```text
j11_physical_level IN {MATHILDE_M_B2, MATHILDE_M_B3}
AND obligations["aftercare_mathilde_j11"].status == FAILED
AND j14_variant == MATHILDE
AND j14_witness == Marie
AND knowledge["fact_witness_saw_limited_trace"].discovered_trace_id
    == j11_mathilde_physical_aftercare_01
AND Marie IN knowledge["fact_witness_saw_limited_trace"].current_knowers
```

L’échec d’aftercare est terminal en Saison 1. La restitution de distance J16 ne le
répare pas.

`D1_B — AUDIENCE_BREACH_KNOWN_CONTROLLER_NOTICE_FAILED` :

```text
j14_witness == Marie
AND Marie IN knowledge["fact_witness_saw_limited_trace"].current_knowers
AND promises["j14_inform_trace_controller"].status == FAILED
AND knowledge["fact_trace_controller_not_informed"].source_ref
    == j14_inform_trace_controller
```

La réparation suffisante et exclusive de cette famille est la conjonction : notice
`PAID`, `j14_controller_notified == true` et fait cohérent
`fact_trace_controller_informed_of_audience_breach`.

`D1_C — REPEATED_DECEPTION_TO_MARIE_THEN_CONTESTED` :

```text
j14_witness == Marie
AND j15_outcome IN {DUE_FAIL, REPAIR_LIE, OPEN_LIE}
AND j16_priority == MARIE
AND j16_consequence_outcome == MARIE_CONTEST
AND promises["j16_priority_consequence_payment"].status == FAILED
AND traces["j16_consequence_payment_record_01"].consequence_outcome
    == CONSEQUENCE_FAILED
```

Cette famille est réparée par `MARIE_RESTITUTE` ou `MARIE_PRACTICAL`, avec promesse
`PAID` et record `CONSEQUENCE_PAID`.

Sont explicitement exclus de D1 : aftercare `PAID`, notice contrôleur `PAID`,
`TRUTH_LIMITED`, `PROTECT_AND_DEFER`, `DUE_CANCEL`, `OPEN_REFUSE`, tous les
`*_RESTITUTE` et `*_PRACTICAL`, le refus honnête et la clôture propre.
- **Comportement si absence :** dans une structure valide, chaque famille absente
  vaut `false`; aucune invalidité et aucune fracture par prudence.
- **Statut :** décision produit fermée et calculable à partir du runtime existant.

### 7.3 Fait matériel caché

- **Nom stable :** `J17_MATERIAL_FACT_HIDDEN`.
- **Liste fermée :** seuls les trois passages physiques extérieurs suivants sont
  matériels pour ce contrat : Mathilde M-B2, Mathilde M-B3 et le premier baiser
  Raphaëlle.
- **Formule exacte :**

```text
knowledge["fact_mathilde_physical_event_occurred"].physical_level
    == MATHILDE_M_B2
OR knowledge["fact_mathilde_physical_event_occurred"].physical_level
    == MATHILDE_M_B3
OR (
  j11_pivot == RAPHAELLE
  AND j11_pivot_outcome == FIRST_KISS
  AND j11_physical_level == RAPHAELLE_FIRST_KISS
)
```

Le runtime ne porte aucune preuve que Marie a acquis le fait physique exact. Le
coup d’œil borné J14 ne l’ajoute pas aux knowers du fait source. Chacun de ces faits
présent est donc caché sur la baseline et dans le périmètre N8; N8 ne fabrique aucune
divulgation.

`PROXIMITY_ONLY`, image privée, attraction nommée, désir borné, version Pauline et
message Nico ne sont pas matériels à eux seuls. Les mensonges et brèches relèvent de
D1, D3 ou D9.
- **Comportement si absence :** `false` dans une structure valide.
- **Statut :** décision produit fermée et calculable.

### 7.4 Version incompatible encore active

- **Nom stable :** `J17_INCOMPATIBLE_VERSION_ACTIVE`.
- **Formule exacte :**

```text
j15_outcome IN {DUE_FAIL, REPAIR_LIE, OPEN_LIE}
AND j16_priority IN {MARIE, MATHILDE}
AND j16_consequence_outcome IN {MARIE_CONTEST, MATHILDE_CONTEST}
AND promises["j16_priority_consequence_payment"].status == FAILED
AND traces["j16_consequence_payment_record_01"].consequence_outcome
    == CONSEQUENCE_FAILED
```

La paire incompatible est identifiée par la source J14
`j14_source_trace_id` et `fact_player_explanation_to_witness`, puis par
`fact_j15_obligation_resolution` et le record J16. Elle est fermée par
`REPAIR_TRUTH`, tout `*_RESTITUTE` ou `*_PRACTICAL`, `DUE_CANCEL` ou
`OPEN_REFUSE`. `FALLBACK_CONFIRM` ne crée aucune contradiction. Le futur
`existing_contradiction_id` J21 n’entre jamais dans cette formule.
- **Comportement si absence :** `false` dans une structure valide.
- **Statut :** décision produit fermée et calculable.

### 7.5 Actes Marie répétés

- **Nom stable :** `J17_REPEATED_MARIE_ACTS_PROVEN`.
- **Formule exacte :** disjonction des quatre combinaisons fermées de la section
  5.1. Le choix J17 n’entre dans aucune combinaison.
- **Comportement si absence :** `false`; une entrée de reconquête valide tombe sur
  `PROVISIONAL_AGREEMENT` si les gardes dommageables sont fausses.
- **Statut :** décision produit fermée et calculable sans score ni compteur.

### 7.6 Vérité suffisante

- **Nom stable :** `J17_SUFFICIENT_TRUTH_PROVEN`.
- **Faits dus :** exactement les trois faits matériels de la section 7.3.
- **Formule exacte :**

```text
STRUCTURAL_INPUT_VALID
AND NOT J17_MATERIAL_FACT_HIDDEN
AND NOT J17_INCOMPATIBLE_VERSION_ACTIVE
```

Une vérité limitée ou une notification de contrôleur n’est pas une divulgation
complète. La présence de l’un des trois faits physiques extérieurs rend donc ce
prédicat faux sur la baseline et dans N8, faute de preuve de divulgation exacte.
- **Statut :** décision produit fermée et dérivée.

### 7.7 Aucune violation active

- **Nom stable :** `J17_NO_ACTIVE_VIOLATION`.
- **Définition :** aucune violation explicitement établie ne demeure active après
  application des réparations reconnues.
- **Nature :** prédicat dérivé, jamais un nouveau champ destiné uniquement à
  matérialiser une négation.
- **Formule normative :**

```text
NOT J17_MARIE_KNOWN_SEVERE_VIOLATION_UNREPAIRED
AND NOT J17_MATERIAL_FACT_HIDDEN
AND NOT J17_INCOMPATIBLE_VERSION_ACTIVE
```

- **Comportement si absence :** les trois gardes valent `false` lorsque leurs faits
  sont absents d’une structure valide; le prédicat vaut alors `true` sans stocker un
  nouveau booléen.
- **Statut :** décision produit fermée et dérivée.

### 7.8 Règle concrète

- **Nom stable :** `J17_CONCRETE_RULE_PROVEN`.
- **Identifiant fermé de règle :**
  `J17_RULE_RECONQUEST_NO_FALSE_TIME_PLACE_OR_EXTERNAL_PROGRESSION`.
- **Sémantique exacte :** aucun faux horaire, aucun faux lieu et aucune nouvelle
  progression extérieure avant le prochain checkpoint du couple.
- **Preuve authored :** la formulation actuelle de `choice_j17_reconquest` est
  insuffisante. N8 doit en resserrer strictement le texte, sans changer son ID, son
  ordre UI ni son sens fondamental, afin d’énoncer les trois éléments avant la
  dérivation. Le test statique verrouille cette formulation sémantique.
- **Précondition statique N8 :** le build est invalide si le texte associé à
  `choice_j17_reconquest` ne prouve pas exactement la règle fermée ci-dessus.
- **Formule runtime exacte après validation de cette précondition :**

```text
STRUCTURAL_INPUT_VALID
AND choice_id == choice_j17_reconquest
```

La sémantique du choix est un invariant de build vérifié statiquement, pas une chaîne
libre évaluée au runtime ni un nouveau champ. Une fois le texte verrouillé,
l’acceptation de ce choix est l’acte authored explicite et le nom stable du prédicat est enregistré dans
`satisfied_constructive_condition_ids`.
- **Baseline :** `false` tant que la formulation n’est pas resserrée.
- **Statut :** décision produit fermée; preuve à matérialiser dans les données N8.

### 7.9 Désir extérieur reconnu

- **Nom stable :** `J17_EXTERNAL_DESIRE_ACKNOWLEDGED`.
- **Source de désir fermée :**

```text
J17_EXTERNAL_DESIRE_SOURCE_PRESENT =
  (j11_pivot == SANDRA AND j11_pivot_outcome == SANDRA_DESIRE_BOUNDED)
  OR
  (j11_pivot == RAPHAELLE
   AND j11_pivot_outcome == RESULT_SENT_ATTRACTION_NAMED)
```

- **Preuve authored :** N8 resserre strictement le texte de
  `choice_j17_provisional` pour reconnaître « ce qui a existé dehors », sans engager
  la personne concernée, sans permission et sans réécriture rétroactive.
- **Précondition statique N8 :** le build est invalide si le texte associé à
  `choice_j17_provisional` ne reconnaît pas explicitement le désir extérieur selon
  la sémantique ci-dessus.
- **Formule runtime exacte après validation de cette précondition :**

```text
STRUCTURAL_INPUT_VALID
AND J17_EXTERNAL_DESIRE_SOURCE_PRESENT
AND choice_id == choice_j17_provisional
```

La sémantique du choix est un invariant de build, pas un champ. `FIRST_KISS` et
Mathilde M-B2/M-B3 sont
arrêtés auparavant par `J17_MATERIAL_FACT_HIDDEN`; un niveau physique ne sert jamais
de substitut à la reconnaissance.
- **Baseline :** `false` tant que la formulation provisoire n’est pas resserrée.
- **Statut :** décision produit fermée; preuve à matérialiser dans les données N8.

### 7.10 Audiences sûres ou réparées

- **Nom stable :** `J17_AUDIENCES_SAFE_OR_REPAIRED`.
- **Événement pertinent unique :** `j14_discovery_event_01` et son unique
  `discovered_trace_id`. Les validateurs structurels couvrent les autres traces; N8
  n’ajoute aucun second agrégat d’audiences.
- **Formule exacte :**

```text
STRUCTURAL_INPUT_VALID
AND (
  j14_variant == S27_MUTATION_NO_DISCOVERY
  OR (
    knowledge["fact_witness_saw_limited_trace"] IS_COHERENT
    AND promises["j14_inform_trace_controller"].status == PAID
    AND j14_controller_notified == true
    AND knowledge.has("fact_trace_controller_informed_of_audience_breach")
  )
)
```

`IS_COHERENT` reprend le contrat de structure J14 existant : `source_ref` vers
`j14_discovery_event_01`, witness/knowers, `discovered_trace_id`, champs visibles et
valeurs cohérents. Le prédicat vaut `false` si la notice a échoué, si le fait
`fact_trace_controller_not_informed` existe, ou si la réparation requise n’est pas
payée. Une corruption structurelle invalide l’entrée.
- **Statut :** décision produit fermée et calculable sans compteur.

### 7.11 Pause acceptée

- **Nom stable :** `J17_EXTERNAL_PROGRESSION_PAUSE_ACCEPTED`.
- **Preuve authored :** N8 resserre `choice_j17_provisional` pour dire explicitement
  qu’aucune nouvelle étape extérieure n’a lieu avant le checkpoint.
- **Précondition statique N8 :** le build est invalide si le texte provisoire ne
  contient pas cette pause explicite.
- **Formule runtime exacte après validation de cette précondition :**

```text
STRUCTURAL_INPUT_VALID
AND choice_id == choice_j17_provisional
```

La sémantique du choix est un invariant de build, pas un champ. Sa sélection est
l’acte authored préalable à la dérivation.
- **Baseline :** exactement `false`; le texte actuel ne prouve ni pause ni
  checkpoint.
- **Comportement si absence :** `false`; fallback `PROVISIONAL_AGREEMENT`.
- **Statut :** décision produit fermée; preuve à matérialiser dans les données N8.

### 7.12 Droit complet de refus de Marie explicitement reconnu

- **Nom stable :** `J17_MARIE_FULL_REFUSAL_RIGHT_EXPLICITLY_ACKNOWLEDGED`.
- **Preuve authored :** le même resserrement de `choice_j17_provisional` doit dire
  que Marie peut refuser toute reconfiguration, qu’il ne s’agit ni d’une ouverture
  ni d’une permission rétroactive, et qu’aucune personne extérieure n’est engagée.
- **Précondition statique N8 :** le build est invalide si le texte provisoire omet
  le droit complet de refus, crée une ouverture ou une permission rétroactive, ou
  engage une personne extérieure.
- **Formule runtime exacte après validation de cette précondition :**

```text
STRUCTURAL_INPUT_VALID
AND choice_id == choice_j17_provisional
```

La sémantique du choix est un invariant de build, pas un champ. Sa sélection est
l’acte explicite avant dérivation.
- **Baseline :** exactement `false`; le texte actuel ne prouve aucune des deux
  conditions distinctes de pause et de refus.
- **Invariant :** le droit de refus lui-même demeure vrai dans les six états; le
  prédicat ne le crée, ne le suspend et ne le retire jamais.
- **Comportement si absence :** `false`; fallback `PROVISIONAL_AGREEMENT`.
- **Statut :** décision produit fermée; preuve à matérialiser dans les données N8.

## 8. Table exhaustive et ordonnée : quatre choix vers six états

L’ordre UI existant reste inchangé et ne doit pas être confondu avec l’ordre des
gardes : lorsque la discussion est due, l’interface présente
`choice_j17_reconquest`, puis `choice_j17_provisional`, puis
`choice_j17_separation`; lorsqu’elle est refusée ou non due, elle présente seulement
`choice_j17_refused_acknowledge`. Aucun cinquième ou sixième bouton n’est créé.

La condition « entrée valide » inclut la cohérence structurelle de la section 6.
Les gardes dommageables précèdent les conditions constructives ; les gardes
spécifiques précèdent le fallback du choix.

N8 resserre strictement les formulations de `choice_j17_reconquest` et
`choice_j17_provisional` pour matérialiser les preuves authored des sections
7.8–7.12. Leurs identifiants, leur ordre et les quatre choix UI restent inchangés :
aucune option, aucun layout et aucun point UI n’est ajouté, et leur sens fondamental
n’est pas modifié.

| Ordre | Choix et validité | Prédicats exacts | Sortie | Justification et fallback | Cas contradictoire | Test N8 ciblé |
|---:|---|---|---|---|---|---|
| 1 | `choice_j17_separation`; valide seulement si discussion due | Aucun prédicat narratif supplémentaire après validation | `SEPARATION` | Le choix explicite de fin prime ; aucun fallback. | Choix reçu sans promesse active ou avec résultat J16 refus/alternative : entrée invalide. | Séparation due ; historique conservé ; record/logistique présents. |
| 2 | `choice_j17_refused_acknowledge`; uniquement `J17_DISCUSSION_REFUSED_OR_NOT_DUE` | Formule section 7.1 | `FRACTURE` | Reconnaît que l’ancien cadre n’est plus disponible ; aucun fallback. | Si discussion due, refuser explicitement l’entrée et ne pas muter l’état. | Cas `REFUSE`, cas `ALTERNATIVE`, puis cas dû rejeté. |
| 3 | `choice_j17_reconquest` ou `choice_j17_provisional`; discussion due | `J17_MARIE_KNOWN_SEVERE_VIOLATION_UNREPAIRED` | `FRACTURE` | Une formulation favorable n’efface pas une violation grave non réparée. | Un fait fermé absent vaut faux; structure incohérente ou référence annoncée absente invalide sans `FRACTURE` arbitraire. | Chaque famille D1-A/B/C ; priorité sur toutes les lignes suivantes ; référence annoncée absente rejetée. |
| 4 | Même validité que ligne 3 | `J17_MATERIAL_FACT_HIDDEN OR J17_INCOMPATIBLE_VERSION_ACTIVE` | `DOUBLE_LIFE_FRAGILE` | Couple matériellement maintenu sous contradiction ; après la ligne 3. | Si ligne 3 vraie aussi, ligne 3 gagne ; tout fait hors liste D2 vaut non matériel pour ce contrat. | Chaque fait D2, D3 seul, les deux, et concurrence avec ligne 3. |
| 5 | `choice_j17_reconquest`; discussion due | `J17_REPEATED_MARIE_ACTS_PROVEN AND J17_SUFFICIENT_TRUTH_PROVEN AND J17_NO_ACTIVE_VIOLATION AND J17_CONCRETE_RULE_PROVEN` | `RECONQUEST_ACTIVE` | Les quatre preuves sont nécessaires ; le choix seul ne suffit pas. | Condition annoncée vraie sans preuve : entrée invalide. | Cas nominal ; une variante par condition constructive fausse ; guards précédents prioritaires. |
| 6 | `choice_j17_reconquest`; discussion due ; lignes 3–5 non retenues | Négation évaluée des gardes et au moins une condition constructive de ligne 5 fausse | `PROVISIONAL_AGREEMENT` | Fallback propre à la reconquête, jamais fallback d’une entrée invalide. | Champ requis `UNESTABLISHED`, incohérence ou preuve annoncée absente invalide ; une condition constructive simplement absente vaut faux. | Fallback pour chaque condition absente de façon valide ; données corrompues rejetées. |
| 7 | `choice_j17_provisional`; discussion due | `J17_EXTERNAL_DESIRE_ACKNOWLEDGED AND J17_AUDIENCES_SAFE_OR_REPAIRED AND J17_EXTERNAL_PROGRESSION_PAUSE_ACCEPTED AND J17_MARIE_FULL_REFUSAL_RIGHT_EXPLICITLY_ACKNOWLEDGED` | `RECONFIGURATION_NEGOTIATION` | Négociation sans ouverture automatique ; quatre preuves requises. | Droit ou pause supposé par le label du choix : interdit ; guards 3–4 restent prioritaires. | Cas nominal ; une variante par condition fausse ; aucune permission de tiers créée. |
| 8 | `choice_j17_provisional`; discussion due ; lignes 3, 4 et 7 non retenues | Négation évaluée des gardes et au moins une condition constructive de ligne 7 fausse | `PROVISIONAL_AGREEMENT` | Fallback propre au choix provisoire. | Entrée invalide ou preuve obligatoire contradictoire : aucun fallback. | Fallback par condition constructive ; corruption et choix inconnu rejetés. |

Un identifiant de choix inconnu est refusé explicitement. Il ne produit aucun état.

### 8.1 Situation exécutable contractuelle

Les huit lignes sont désormais spécifiées par des formules fermées. Les lignes 1 à
4 utilisent exclusivement les données existantes. Les lignes 5 à 8 utilisent aussi
les deux formulations authored que N8 doit resserrer et verrouiller statiquement
avant la dérivation. Jusqu’à ce resserrement, la règle concrète, le désir reconnu,
la pause et la reconnaissance du droit de refus valent exactement `false` sur la
baseline; les fallbacks restent donc les seules sorties constructives atteignables
hors gardes dommageables. L’implémentation N8 attend encore l’approbation produit de
ce contrat.

## 9. Record de continuité minimal attendu pour N8

Le support naturel est l’actuel
`traces["j17_couple_definition_record_01"]`, un `FACT_RECORD` déjà persisté dans le
snapshot de `Season1State`. N8 doit l’enrichir de façon bornée, sans créer de journal
générique.

| Champ du record | Type | Statut baseline | Contrat N8 |
|---|---|---|---|
| `trace_id` | `String` | existe | Conserver `j17_couple_definition_record_01`. |
| `record_type` | `String` | existe | Conserver `FACT_RECORD`. |
| `source_day` | `String` | existe | Conserver `J17` comme projection informative. |
| `choice_id` | `String` | absent | Ajouter l’identifiant exact parmi les quatre choix de couple. |
| `couple_state` | `String` | existe | Stocker exactement l’un des six états canoniques. |
| `discussion_was_due` | `bool` | existe | Conserver ; doit correspondre au résultat J16 et à la promesse. |
| `triggered_guard_fact_ids` | `Array[String]` | absent | Ajouter uniquement les identifiants autorisés de la liste fermée ci-dessous qui sont réellement présents et ont déclenché les lignes 3 ou 4 ; vide pour les autres sorties. |
| `satisfied_constructive_condition_ids` | `Array[String]` | absent | Ajouter uniquement les noms stables de la liste fermée ci-dessous dont les preuves sont effectivement satisfaites ; aucune condition implicite. |
| `mathilde_micro_return_delivered` | `bool` | absent | Ajouter ; `true` seulement après insertion effective du micro-retour dans le fil Mathilde. |
| `marie_micro_return_delivered` | `bool` | absent | Ajouter ; `true` seulement après insertion effective du micro-retour dans le fil Marie. |
| `temporal_projection` | `Dictionary` fermé | absent ; seul `source_day` existe | Ajouter `day_id`, `departure_at`, `couple_discussion_due_at` et `resolved_at`. `day_id` vaut `J17`, `departure_at` reprend `J17 17:30`, la fenêtre due reprend `J17 20:30–21:30` ou reste absente si non due, et `resolved_at` est l’horloge effective du provider au succès, jamais une heure inventée par le résolveur. |
| `current_state` | `String` | existe | Conserver `ACTIVE`. |
| `visual_asset` | `String` | existe | Conserver `none`. |

Le record n’est ni un score, ni un journal A1, ni une route, ni une sauvegarde
disque, ni un résumé psychologique. Les tableaux `promises`, `obligations`, `traces`
et `knowledge` restent les sources des preuves ; le record référence les faits qui
ont effectivement décidé J17 et ne les recopie pas en prose.

### 9.1 Références de preuve fermées

`triggered_guard_fact_ids` accepte seulement les identifiants effectivement présents
parmi :

```text
fact_mathilde_physical_event_occurred
aftercare_mathilde_j11
fact_witness_saw_limited_trace
j14_inform_trace_controller
fact_trace_controller_not_informed
fact_trace_controller_informed_of_audience_breach
fact_player_explanation_to_witness
fact_j15_obligation_resolution
j16_priority_consequence_payment
j16_consequence_payment_record_01
choice_j11_mathilde_m_b2_hold
choice_j11_mathilde_m_b3_accept
choice_j11_raphaelle_meeting_accept
```

Les trois identifiants `choice_*` doivent exister dans `selected_choice_ids`; les
autres doivent exister dans le registre correspondant parmi `knowledge`,
`promises`, `obligations` ou `traces`.

`satisfied_constructive_condition_ids` accepte seulement :

```text
J17_REPEATED_MARIE_ACTS_PROVEN
J17_SUFFICIENT_TRUTH_PROVEN
J17_NO_ACTIVE_VIOLATION
J17_CONCRETE_RULE_PROVEN
J17_EXTERNAL_DESIRE_ACKNOWLEDGED
J17_AUDIENCES_SAFE_OR_REPAIRED
J17_EXTERNAL_PROGRESSION_PAUSE_ACCEPTED
J17_MARIE_FULL_REFUSAL_RIGHT_EXPLICITLY_ACKNOWLEDGED
```

Une référence annoncée mais absente de sa source invalide l’entrée. Toute chaîne
libre, score, compteur ou résumé psychologique est interdit.

### 9.2 Contrat des deux micro-retours

| Retour | Position | Contenu fonctionnel obligatoire | Interdits | Marqueur |
|---|---|---|---|---|
| Mathilde | Dans `thread_mathilde_private`, après l’application du choix de départ et avant la conversation de couple | Confirmer seulement départ, aide ou distance, état pratique et absence de réinterprétation relationnelle | nouveau choix, scène, asset, promesse amoureuse, disponibilité future | `mathilde_micro_return_delivered` |
| Marie | Dans `thread_marie_private`, après dérivation et enregistrement de l’état | Nommer naturellement le statut provisoire réel, la règle/limite immédiate et le checkpoint, la conséquence ou la logistique suivante | label décidé par le seul texte du choix, pardon rétroactif, finale de saison, nouvelle permission extérieure | `marie_micro_return_delivered` |

Le retour Marie varie selon les six états : logistique de fin pour `SEPARATION`,
cadre retiré pour `FRACTURE`, contradiction non résolue pour
`DOUBLE_LIFE_FRAGILE`, règle et revue pour `PROVISIONAL_AGREEMENT`, tentative sans
pardon pour `RECONQUEST_ACTIVE`, négociation sans permission et avec refus intact
pour `RECONFIGURATION_NEGOTIATION`.

## 10. Projection informative J01–J21

Chaque ligne correspond au provider et à la runtime map réels. Dans la colonne
abrégée, les providers résident sous `game/scripts/runtime/season_1/` et les maps
sous `game/data/runtime/season_1/`. Pour J01–J10, les maps ne déclarent pas la clé
`implementation_status`, mais les providers, données, tests et la chaîne
`Season1RuntimeProvider` sont présents. J11–J21 déclarent `PLAYABLE`.

| Jour projeté | Mouvement | Séquences canoniques projetées | Provider / runtime map | État du contenu | Dépendance utile à J17 | Contradiction ou décalage documentaire |
|---|---|---|---|---|---|---|
| J01 | I | `S01`, fonction Marie `S02`, ouverture `S03` | `J01RuntimeProvider.gd` / `j01_runtime_map.json` | Runtime présent ; statut absent de la map | Présence/promesse initiale Marie, fait de couple | Ancien jour fixe ; les séquences restent indépendantes. |
| J02 | I | `S04` | `J02RuntimeProvider.gd` / `j02_runtime_map.json` | Runtime présent ; statut absent | Acte « faire de la place », arrivée Mathilde | Le foyer est projection, pas identité de `S04`. |
| J03 | I | `S06`, écho `S03`, retour Marie | `J03RuntimeProvider.gd` / `j03_runtime_map.json` | Runtime présent ; statut absent | Retour Marie, traces Sandra/Raphaëlle | Plusieurs séquences partagent le jour. |
| J04 | I | `S05`, `S07`, fermeture `S01` | `J04RuntimeProvider.gd` / `j04_runtime_map.json` | Runtime présent ; statut absent | Réseau public, Nico, foyer | Fin de mouvement par fonction, non par numéro. |
| J05 | II | `S08` et slot `S09`/`S10`/`S12` | `J05RuntimeProvider.gd` / `j05_runtime_map.json` | Runtime présent ; statut absent | Heure partagée Marie ; continuité Sandra | Le slot authored n’est pas une route persistée. |
| J06 | II | pivot `S09`/`S10`/`S11`/`S12` | `J06RuntimeProvider.gd` / `j06_runtime_map.json` | Runtime présent ; statut absent | Retour concret Marie ; proximité Mathilde | Projection variable liée aux champs J06. |
| J07 | II | `S13`, ou continuité `S11`/`S12` | `J07RuntimeProvider.gd` / `j07_runtime_map.json` | Runtime présent ; statut absent | Demande de foyer Marie, promesses de présence | Identifiants et échéances encore liés au jour. |
| J08 | II | `S14` | `J08RuntimeProvider.gd` / `j08_runtime_map.json` | Runtime présent ; statut absent | Paiement/échec foyer, écho Marie | La superposition est canonique, J08 informatif. |
| J09 | III | `S15` | `J09RuntimeProvider.gd` / `j09_runtime_map.json` | Runtime présent ; statut absent | Présence Marie, dîner, apparition possible de `STRAIN_VISIBLE` | Mouvement III commence par fonction d’exploration. |
| J10 | III | `S16`, `S17`, `S18`, `S21` ou `S22` selon pivot | `J10RuntimeProvider.gd` / `j10_runtime_map.json` | Runtime présent ; statut absent | Résolution dîner Marie, sélection du pivot J11 | L’ancien acte III/J10 ne fixe pas l’identité de ces séquences. |
| J11 | III | `S19`, `S20`, `S18`, `S21`, `S22`, payoff Marie conditionnel | `J11RuntimeProvider.gd` / `j11_runtime_map.json` | `PLAYABLE` | Niveau physique, aftercares, acte/reconnexion Marie | Plusieurs payoffs authored sont comprimés dans un pivot journalier. N8 ne les modifie pas. |
| J12 | IV | `S23` | `J12RuntimeProvider.gd` / `j12_runtime_map.json` | `PLAYABLE` | Traitement aftercare échoué, présence Marie, audiences publiques | Ancien document classe J12 dans l’acte III ; N7.1 rattache `S23` au mouvement IV. |
| J13 | IV | `S24`, `S25` ou `S26` | `J13RuntimeProvider.gd` / `j13_runtime_map.json` | `PLAYABLE` | Trace sélectionnée pour J14, version privée/alibi | Le pivot journalier est une projection technique. |
| J14 | IV | `S27` | `J14RuntimeProvider.gd` / `j14_runtime_map.json` | `PLAYABLE` | Mensonge/minimisation, témoin, audience et notification | La mutation sans découverte ne prouve ni vérité complète ni audience globalement sûre. |
| J15 | IV | `S28` | `J15RuntimeProvider.gd` / `j15_runtime_map.json` | `PLAYABLE` | Paiement, refus ou mensonge de clarification ; urgence J16 | Résolution locale non équivalente à une réparation globale. |
| J16 | IV → V | conséquences de `S28`, préparation historique `S31`/`S29` | `J16RuntimeProvider.gd` / `j16_runtime_map.json` | `PLAYABLE` | Paiement/contestation, départ, acceptation/refus/alternative J17 | Aucune séquence autonome nouvelle ; journée de pont. |
| J17 | V | `S31` puis `S29` réinterprété comme clarification intermédiaire | `J17RuntimeProvider.gd` / `j17_runtime_map.json` | `PLAYABLE`, sémantiquement incomplet | Quatre choix, état provisoire, record et deux micro-retours | Runtime produit quatre sorties directes, pas six ; J17 n’est pas la finale. |
| J18 | V | `S30` | `J18RuntimeProvider.gd` / `j18_runtime_map.json` | `PLAYABLE` | Conséquence Sandra en aval | Aftercare Sandra canonique absent du runtime ; hors N8. |
| J19 | V | `S32`, `S33` | `J19RuntimeProvider.gd` / `j19_runtime_map.json` | `PLAYABLE` | Résolutions Pauline/Raphaëlle en aval | Compression en foreground/secondary ; hors N8. |
| J20 | V | `S34`, sélection de trace | `J20RuntimeProvider.gd` / `j20_runtime_map.json` | `PLAYABLE` | Résolution Nico et trace finale en aval | La trace est choisie avant J21 ; elle ne décide pas le couple. |
| J21 | V | fonction `S35` : trace/posture et dernière image | `J21RuntimeProvider.gd` / `j21_runtime_map.json` | `PLAYABLE`, finale structurellement incomplète | Consommateur des six états ; aucune entrée N8 | Conversation finale autonome absente ; N8 ne touche pas J21. |

Les noms de fichiers `chapter_NN_*`, les segments `jNN_*`, les champs J01–J21,
les providers, les runtime maps et les heures de messages restent temporairement
liés aux jours. Les horaires, échéances, absences et rendez-vous peuvent rester
purement diégétiques. Le découplage général des identités de contenu, providers et
champs `jNN_*` appartient à un futur lot distinct. N8 ne touche à aucun de ces
éléments hors de J17 et ne recommande aucune migration générale.

## 11. Gouvernance documentaire réconciliée

Les statuts de cette table sont ceux exigés par N7.1 : `Canon`, `Runtime`,
`Archive`, `À réécrire`.

| Document réel | Statut | Autorité retenue et usage encore valide | Éléments supersédés | Effet sur N8 |
|---|---|---|---|---|
| `docs/narrative/R8C_N7_1_SEASON_STRUCTURE_RUNTIME_PROJECTION_AND_N8_ENTRY_CONTRACT.md` | Canon | Autorité N7.1 sur structure, projection J17, vocabulaire, formules fermées et entrée N8 ; prêt pour revue produit, non approuvé. | Aucun document antérieur ne peut compléter ou élargir silencieusement une formule. | N8 attend l’approbation produit de ce contrat. |
| `docs/canon/PROJECT_DOCUMENTATION_GOVERNANCE.md` | Canon | Autorité sur les sources et statuts documentaires. | Aucun. | Impose code/données/tests comme vérité d’exécution. |
| `docs/canon/bible/14_CONTRAT_NARRATIF_SAISON_1_RECONCILIE.md` | Canon | Autorité supérieure sur cinq mouvements, centralité Marie/Player et ordre final. | Ancienne finale confondue avec J17/J21. | Interdit de faire de J17 une finale et interdit le cutover opportuniste. |
| `docs/canon/bible/04_TRAME_PRINCIPALE_ET_ACTES_SAISON_1.md` | À réécrire | Conserve phrase directrice et matière dramatique. | Quotas/ancienne formulation d’actes lorsque contradictoires avec `14`. | Aucune implémentation directe. |
| `docs/canon/bible/07_BIBLIOTHEQUE_DE_SEQUENCES_SAISON_1.md` | À réécrire | Catalogue authored `S01–S35`, fonctions et dépendances. | `S29` comme conversation décidant le couple final ; articulation finale incomplète. | Sert à nommer la matière, jamais à modifier A6. |
| `docs/canon/bible/11_DISTRIBUTION_SEQUENCES_SCENES_IMAGES_CONSEQUENCES_JOURNEES.md` | À réécrire | Source informative de la projection historique J01–J21. | Jours comme architecture durable ; J12 dans ancien acte III ; J17/J21 comme identités de fin. | N8 conserve J17 technique sans généraliser le calendrier. |
| `docs/canon/bible/12_PLANS_SCENES_AUDIT_RUNTIME_J01_J08.md` | À réécrire | Ancien plan détaillé J01–J08 utile pour provenance. | Découpage par bloc comme autorité structurelle. | Lecture seulement pour preuves antérieures. |
| `docs/canon/bible/12B_PLANS_SCENES_J09_J12.md` | À réécrire | Ancien plan J09–J12 utile aux faits Marie/J11/J12. | Bloc de jours et ancien passage d’acte. | Lecture seulement ; N8 ne modifie pas J09–J12. |
| `docs/canon/bible/12C_PLANS_SCENES_J13_J16.md` | À réécrire | Ancien plan des conséquences J13–J16. | Jour fixe comme identité. | Source secondaire, toujours vérifiée contre runtime. |
| `docs/canon/bible/12D_PLANS_SCENES_J17_J21.md` | À réécrire | Matière des résolutions tardives. | J17 résolution finale et ancien vocabulaire de couple. | Ne complète aucun prédicat absent. |
| `docs/canon/bible/12E_AUDIT_GLOBAL_COHERENCE_J01_J21.md` | Archive | Mémoire de cohérence du corpus par jours. | Verdict de complétude structurelle antérieur au contrat `14` et à N7. | Aucun. |
| `docs/canon/dialogues/J17_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | Source pré-runtime des six sorties, règles, retours et logistique. | J17 comme décision de saison ; conditions non traduites en champs fermés. | Source sémantique des micro-retours, pas formule exécutable. |
| `docs/canon/dialogues/J21_SCRIPT_NARRATIF_COMPLET.md` | À réécrire | Matière de soirée, trace et sorties. | Projection/ordre ne satisfaisant pas la conversation finale autonome. | Hors allowlist N8. |
| `docs/canon/dialogues/J01_J21_FINAL_NARRATIVE_CORPUS_SIGNOFF.md` | Canon | Signoff du corpus historique J01–J21. | Ne prouve pas la conformité au contrat final plus récent. | Empêche une réouverture globale ; n’autorise que le correctif ciblé. |
| `docs/canon/dialogues/J01_J21_REACHABILITY_MATRIX.md` | À réécrire | Matrice historique des états et conséquences. | Ancien identifiant de reconfiguration et conditions non projetées sur le runtime. | Source de tests, vocabulaire remplacé par N7.1. |
| `docs/canon/dialogues/J01_J21_PROMISE_REGISTRY.md` | Canon | Identités, échéances et statuts des promesses. | Les promesses absentes du runtime ne sont pas réputées présentes. | Vérifier les preuves réelles avant toute formule. |
| `docs/canon/dialogues/J01_J21_TRACE_REGISTRY.md` | Canon | Sémantique des traces/audiences et de la trace finale. | Aucun droit média implicite. | Les preuves restent référencées, jamais résumées par score. |
| `docs/canon/dialogues/J01_J21_KNOWLEDGE_REGISTRY.md` | Canon | Sémantique des connaissances et knowers. | Toute connaissance non matérialisée dans `Season1State` reste absente du calcul N8. | Borne « Marie sait ». |
| `docs/canon/runtime/SEASON_1_NARRATIVE_STATE_CONTRACT.md` | À réécrire | Vocabulaire qualitatif et registres attendus. | Identifiant de reconfiguration antérieur, champs futurs non présents, finale trop liée à J21. | Ne pas importer ses champs absents ; adapter seulement le record J17 validé. |
| `docs/canon/dialogues/NAR_PROD_02_PAQUET_PRODUCTION_ACTE_I_J01_J04.md` | Archive | Ancien paquet de production du bloc J01–J04. | Bloc de jours comme structure. | Aucun. |
| `docs/canon/dialogues/NAR_PROD_03_PAQUET_PRODUCTION_ACTE_II_J05_J08.md` | Archive | Ancien paquet J05–J08. | Ancien découpage acte/jours. | Aucun. |
| `docs/canon/dialogues/NAR_PROD_04_PAQUET_PRODUCTION_ACTE_III_J09_J12.md` | Archive | Ancien paquet J09–J12. | Classement de J12 antérieur aux mouvements N7.1. | Aucun. |
| `docs/canon/dialogues/NAR_PROD_05_PAQUET_PRODUCTION_ACTE_IV_J13_J16.md` | Archive | Ancien paquet J13–J16. | Bloc journalier comme identité. | Aucun. |
| `docs/canon/dialogues/NAR_PROD_06_PAQUET_PRODUCTION_ACTE_V_J17_J21.md` | À réécrire | Budget/production de l’ancien acte V ; verdict visuel `NO_NEW_ASSET` encore utile. | J21 `READY` ne prouve pas la présence de la finale autonome. | Confirme qu’aucun asset N8 n’est requis. |
| `docs/narrative/R8C_N6_CANONICAL_SCENE_PORTFOLIO_INVENTORY.md` | Canon | Inventaire de scènes et mouvements, état de production. | Ne décide ni runtime ni prédicats J17. | Borne le portefeuille ; aucune migration. |
| `docs/narrative/R8C_N6_CONTENT_PRODUCTION_FORECAST_AND_ROADMAP.md` | À réécrire | Prévision N6 et dépendances de production encore traçables. | Ordre antérieur à N7/N7.1. | Ne gouverne pas l’entrée N8. |
| `docs/narrative/R8C_N7_J17_J21_CONTINUITY_AND_AFTERCARE_PLAN.md` | Canon | Décide quatre choix, six sorties, deux micro-retours et ordre final. | Notions de prédicats non traduites en formules runtime ; identité finale non fixée. | Source produit complétée par les formules N7.1. |
| `docs/narrative/R8C_N7_REVISION_PACKETS_AND_ACCEPTANCE_GATES.md` | Canon | Décide le paquet N7-RP-04, l’ordre des huit lignes et le périmètre. | `READY_FOR_SCRIPTING` ne vaut pas approbation du présent contrat. | N8 attend la revue produit N7.1. |
| `docs/narrative/R8C_N7_W4_PAYOFF_WRITTEN_RECONCILIATION.md` | Canon | Autorité N7 sur les payoffs W4 et aftercares associés. | Aucun effet d’autorisation sur N8. | Payoffs W4 explicitement hors périmètre. |
| `ROADMAP.md` | À réécrire | Mémoire de l’ordre A4/cutover. | Baseline et roadmap ne mentionnent pas N7/N8. | Ne peut pas élargir N8 ni déclencher A1–A10. |
| `docs/PROJECT_STATE.md` | À réécrire | Constate le runtime J01–J21 et l’absence de sauvegarde fichier. | Baseline/phase A4 anciennes. | Confirme seulement l’oracle historique. |
| `docs/canon/NARRATIVE_CANON_STATUS.md` | À réécrire | Confirme corpus/runtime présents. | « aucun bloqueur narratif » contredit le raccord final et les décisions N7.1. | N8 ne peut pas s’appuyer sur ce verdict global. |
| `docs/canon/DOCUMENTATION_READING_ORDER.md` | Canon | Index actif des autorités narrative/runtime. | N7.1 n’y est pas encore indexé, volontairement dans ce lot. | Aucun index modifié ; N8 suit directement ce contrat validé. |
| `docs/architecture/README.md` | Canon | Index A1–A10 et frontière oracle historique/prototype futur. | Aucun. | Autorité de l’interdiction de cutover. |
| `docs/runtime/README.md` | Runtime | Portail de la chaîne `Season1RuntimeProvider` J01–J21 et de l’absence de sauvegarde disque. | Ne définit ni structure canonique ni formule produit. | Confirme que N8 reste dans l’oracle historique et le snapshot mémoire. |
| `docs/CURRENT_NARRATIVE_SOURCE_OF_TRUTH.md` | Archive | Portail V0.xx explicitement historique. | Toutes prétentions de courant. | Aucun. |

Aucun document attendu nommé « contrat N8 approuvé » n’existe sur la baseline.
Aucun fichier dédié ne porte encore l’identité
`s1_m5_marie_player_final_conversation`; sa fonction est répartie entre le contrat
`14`, les sources J17/J21 et N7. Ce document n’en crée pas et ne s’attribue pas
l’approbation produit.

## 12. Décision d’architecture et allowlist N8

### 12.1 Décision

Le runtime historique sait présenter le corpus réel ; A1–A10 porte un modèle futur
plus durable mais reste déconnecté de Messages, Galerie, PhotoViewer et de la Saison
1 active. N8 corrige donc exclusivement la projection J17 de `Season1State` et son
provider. Il ne prépare aucun cutover.

### 12.2 Allowlist N8 fermée, à approuver par le produit

| Chemin réel | Modification N8 strictement autorisable |
|---|---|
| `game/scripts/runtime/season_1/Season1State.gd` | Résolveur ordonné, validation des quatre choix, six sorties, enrichissement/validation/snapshot du record J17. |
| `game/scripts/runtime/season_1/J17RuntimeProvider.gd` | Livraison conditionnelle et idempotente des deux micro-retours, sans nouveau point UI. |
| `game/data/conversations/chapter_17_departure_and_couple.json` | Deux micro-retours et resserrement strict des formulations de `choice_j17_reconquest` et `choice_j17_provisional` exigé par les sections 7.8–7.12 ; mêmes IDs, même ordre, quatre choix UI, aucun segment autonome, asset ou point UI nouveau. |
| `tests/test_runtime_s1_17_j17_playable_static.py` | Contrat statique des quatre choix et de leur ordre, des six états, des huit règles, des formulations sémantiques resserrées, du record et des interdits. |
| `game/tests/RUNTIME_S1_17J17PlayableSmokeDriver.gd` | Cas détaillés du résolveur, post-résolution, micro-retours, round-trip J17 du record/marqueurs/transcripts et absence de mutation sur entrée invalide. |

Cette allowlist contient exactement cinq fichiers modifiables. Elle n’est pas une
autorisation d’implémenter : elle devient applicable seulement après approbation
produit. Aucun nouveau fichier de test n’est nécessaire.

`game/tests/RUNTIME_S1_J16J21ProviderSnapshotSmokeDriver.gd` est **exécutable mais
non modifiable**. Il vérifie seulement le round-trip générique de début de journée et
la non-régression de la projection environnante J16–J21. Les transcripts et le record
d’état sont déjà inclus dans les snapshots; aucun nouveau champ provider n’est
nécessaire. Tout round-trip détaillé post-résolution J17 et des micro-retours appartient
au driver dédié `RUNTIME_S1_17J17PlayableSmokeDriver.gd`.

Tout besoin réel de modifier un sixième fichier impose une demande explicite
d’élargissement de périmètre avant changement.

### 12.3 Denylist N8

N8 ne modifie pas : A1–A10 ; `Season1RuntimeProvider.gd` ; les providers hors J17 ;
J21 ; les payoffs W4 ; les assets ; Galerie ; PhotoViewer ; UI ; layouts ; sauvegarde
disque ; runtime général ; autres conversations ; contrat général de contenu ;
formats généraux de données ; bundles A6.

Il ne crée aucun adaptateur général, double écriture, projection A6, exécuteur de
séquences, migration de corpus ou abstraction de cutover.

## 13. Tests ciblés attendus pour N8

Sans lancer N8 dans ce lot, la future validation doit couvrir :

1. les quatre identifiants de choix et leur ordre UI inchangés ;
2. chaque ligne de la table ordonnée, dont la priorité `FRACTURE` avant
   `DOUBLE_LIFE_FRAGILE` puis avant les conditions constructives ;
3. les six sorties, aucune septième valeur et aucun fallback pour choix inconnu ;
4. refus explicite de `choice_j17_refused_acknowledge` lorsque la discussion est due ;
5. refus des trois choix due-only lorsque la discussion est refusée/non due ;
6. absence valide de chaque fait dommageable évaluée à `false`, et refus sans
   mutation pour champ requis `UNESTABLISHED`, structure contradictoire ou référence
   annoncée mais absente ;
7. reconquête positive avec toutes les preuves et fallback pour chaque condition
   constructive fausse dans une entrée valide ;
8. reconfiguration positive avec les quatre preuves et fallback pour chaque
   condition fausse ;
9. verrouillage statique de la règle
   `J17_RULE_RECONQUEST_NO_FALSE_TIME_PLACE_OR_EXTERNAL_PROGRESSION` et des quatre
   garanties du choix provisoire : reconnaissance extérieure, pause, absence
   d’ouverture/permission rétroactive et droit complet de refus sans tiers engagé ;
10. historique dommageable jamais effacé par le libellé du choix ;
11. droit de refus de Marie invariant dans les six états ;
12. record contenant choix exact, état, références autorisées réellement présentes,
    conditions prouvées,
    marqueurs et projection temporelle ;
13. rejet de toute référence libre, inconnue ou annoncée mais absente ;
14. micro-retour Mathilde puis micro-retour Marie, chacun exactement une fois,
    idempotents après snapshot/restore et sans choix supplémentaire ;
15. round-trip détaillé du record, des marqueurs et des transcripts dans le driver
    J17 dédié, plus exécution inchangée du snapshot générique J16–J21 ;
16. aucun changement de J18–J21, A1–A10, Galerie, PhotoViewer, UI ou assets.

## 14. Gates d’entrée N8

| Gate | État N7.1 | Motif |
|---|---|---|
| Hiérarchie canonique complète | Fixée | Section 2. |
| Cinq mouvements | Fixés | Section 2.1. |
| Identité finale distincte | Fixée | Section 3.2 ; aucune collision. |
| Six états | Fixés | Section 4. |
| Mapping champs réels | Audité | Sections 5 et 7. |
| Formules exactes des prédicats | Fixées | Douze décisions intégrées ; sections 5.1, 7 et 9.1. |
| Table quatre choix/six états | Fixée normativement | Huit règles ordonnées, fallbacks propres et rejet des entrées invalides ; section 8. |
| Cas invalides/données absentes | Fixés | Sections 6–8. |
| Record minimal | Fixé avec deux listes fermées | Sections 9 et 9.1. |
| Deux micro-retours | Fixés fonctionnellement | Section 9.2. |
| Projection J01–J21 informative | Fixée | Section 10. |
| Gouvernance documentaire | Fixée | Section 11. |
| Allowlist N8 | Fermée à cinq fichiers, à approuver | Section 12.2 ; driver snapshot execute-only. |
| Tests ciblés | Fixés | Section 13. |
| Aucun cutover A1–A10 | Fixé | Sections 1 et 12. |

### 14.1 Douze décisions produit intégrées

Les décisions sont fermées dans le présent contrat, sans score ni compteur :

1. D1-A/B/C définissent exhaustivement la violation grave connue de Marie, leurs
   réparations suffisantes et les cas exclus — section 7.2.
2. Mathilde M-B2/M-B3 et le premier baiser Raphaëlle sont les seuls faits matériels
   dus; ils restent cachés faute de divulgation exacte — section 7.3.
3. D3 définit la version incompatible active et ses clôtures — section 7.4.
4. Quatre combinaisons authored fermées prouvent les actes Marie répétés — sections
   5.1 et 7.5.
5. La vérité suffisante est la structure valide sans fait matériel caché ni version
   incompatible active — section 7.6.
6. L’absence de violation active est la négation dérivée des trois gardes, jamais un
   nouveau champ — section 7.7.
7. La règle de reconquête porte l’identifiant fermé
   `J17_RULE_RECONQUEST_NO_FALSE_TIME_PLACE_OR_EXTERNAL_PROGRESSION` et exige le
   resserrement authored du choix existant — section 7.8.
8. Le désir extérieur reconnu ne peut provenir que de Sandra
   `SANDRA_DESIRE_BOUNDED` ou Raphaëlle `RESULT_SENT_ATTRACTION_NAMED`, avec
   reconnaissance explicite dans le choix provisoire resserré — section 7.9.
9. La sûreté des audiences se calcule uniquement sur l’événement de découverte J14
   ou son absence canonique, avec notice contrôleur payée — section 7.10.
10. La pause et la reconnaissance du droit complet de refus sont deux preuves
    distinctes du choix provisoire resserré; le droit reste invariant — sections
    7.11 et 7.12.
11. Les références de gardes et les conditions constructives du record utilisent
    deux listes fermées; toute référence annoncée absente est invalide — section 9.1.
12. L’allowlist contient exactement cinq fichiers modifiables; le driver snapshot
    J16–J21 est execute-only et le détail J17 appartient au driver dédié — section
    12.2.

Le statut de livraison est donc :

`SEASON_RUNTIME_PROJECTION_CONTRACT_READY_FOR_PRODUCT_REVIEW`

Le statut `SEASON_RUNTIME_PROJECTION_CONTRACT_APPROVED` ne peut être attribué que
par la revue produit. Aucun travail N8, J21 ou A1–A10 n’est autorisé par la présente
livraison.
